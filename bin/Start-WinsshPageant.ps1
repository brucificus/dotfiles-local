#!/usr/bin/env pwsh

#
# Start-WinsshPageant
#
# Starts the WinSSH-Pageant application after proactively validating the system configuration for compatibility.
# WinSSH-Pageant implements a Pageant-style agent adapted on top of this Windows system's OpenSSH SSH agent.
#
# This script, in its current form, is not suitable for using at Windows startup because it unavoidably leaves a window open and visible.
# (The PowerShell process cannot be exited at the end without an explicit `exit` which will also kill the child process started herein.)
#
param(
    [Parameter(HelpMessage = 'The path to the SSH pipe. Defaults to $Env:SSH_AUTH_SOCK.')]
    [ValidateScript({ (-not $_) -or (Test-Path $_ -PathType Leaf) })]
    [string] $SshPipePath = [string]::Empty,

    [Parameter(HelpMessage = 'Disable Pageant named pipe proxying.')]
    [switch] $DisablePageantPipe,

    [Parameter(HelpMessage = 'The amount of time to wait for the ambient environment to start a GPG agent. Defaults to 30 seconds. Set to 0 to disable. Ignored if a different SSH agent is specified.')]
    [TimeSpan] $GpgAgentStartWait = [TimeSpan]::FromSeconds(30),

    [Parameter(HelpMessage = 'The amount of time to wait for a recently-started GPG agent to create the named pipe for SSH agent forwarding. Defaults to 30 seconds. Set to 0 to disable. Ignored if a different SSH agent is specified.')]
    [TimeSpan] $GpgAgentWarmupTimeout = [TimeSpan]::FromSeconds(30),

    [Parameter()]
    [switch] $AttachTTY,

    [Parameter()]
    [switch] $DelayExit
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[int] $errorExitDelaySeconds = 10
[int] $exitDelayed = 0
function Start-ExitTimer([int] $seconds) {
    if (-not $DelayExit) {
        return
    }
    [int] $delayRemainingSeconds = [Math]::Max($seconds - $script:exitDelayed, 0)
    if (($seconds -gt 0) -and ($delayRemainingSeconds -gt 0)) {
        Write-Host "[Exiting in $delayRemainingSeconds second(s)…]"
        Start-Sleep -Seconds $delayRemainingSeconds
        $script:exitDelayed += $delayRemainingSeconds
    }
}

trap {
    if ($DelayExit) {
        Start-ExitTimer -seconds $errorExitDelaySeconds
        break
    }
}

function Write-TerminatingError([string] $message, [object] $targetObject = $null) {
    $errorRecord = [System.Management.Automation.ErrorRecord]::new(
        [System.Exception]::new($message),
        'WinSSH-PageantError',
        'OperationStopped',
        $targetObject
    )
    if ($DelayExit) {
        Write-Error $errorRecord -ErrorAction 'Continue'
        trap {
            Start-ExitTimer -seconds $errorExitDelaySeconds
            break
        }
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    } else {
        Write-Error $errorRecord
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }
}

if (-not $IsWindows) {
    Write-TerminatingError '🪟 This script is only supported on Windows.' (Get-Variable -Name IsWindows)
}

[string] $winsshPageantProcessName = 'winssh-pageant'
[System.Diagnostics.Process] $winsshPageantProcess = Get-Process -Name $winsshPageantProcessName -ErrorAction SilentlyContinue
if ($winsshPageantProcess) {
    Write-TerminatingError '🚸 WinSSH-Pageant is already running.' $winsshPageantProcess
}

[string] $winsshPageantExe = (Get-Command $winsshPageantProcessName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
if (-not $winsshPageantExe) {
    [string] $defaultWinsshPageantExe = Join-Path $Env:LOCALAPPDATA "Programs/WinSSH-Pageant/$winsshPageantProcessName.exe"
    if (Test-Path $defaultWinsshPageantExe) {
        $winsshPageantExe = $defaultWinsshPageantExe
    }
}
if (-not $winsshPageantExe) {
    Write-TerminatingError '🪛 WinSSH-Pageant is not installed. See: https://github.com/ndbeals/winssh-pageant#installation'
}
Write-Debug "ℹ️ WinSSH-Pageant executable: $winsshPageantExe"

Write-Information "📋 Validating SSH pipe…"

[string] $defaultWindowsGpgOpenSshAgentPipePath = "\\.\pipe\openssh-ssh-agent"
[bool] $defaultWindowsGpgOpenSshAgentPipeExists = Test-Path $defaultWindowsGpgOpenSshAgentPipePath -ErrorAction SilentlyContinue
[string] $gpgAgentConfPath = "$Env:APPDATA\gnupg\gpg-agent.conf"
[string] $gpgAgentProcessName = 'gpg-agent'
[System.Diagnostics.Process] $gpgAgentProcess = Get-Process -Name $gpgAgentProcessName -ErrorAction SilentlyContinue
[bool] $gpgAgentConfExists = Test-Path $gpgAgentConfPath -ErrorAction SilentlyContinue
[Nullable[bool]] $gpgAgentConfEnableWin32OpensshSupport = $null
[Nullable[bool]] $gpgAgentConfEnablePuttySupport = $null
[Nullable[bool]] $gpgAgentConfEnableSshSupport = $null
if ($gpgAgentConfExists) {
    [string[]] $gpgAgentConf = @(Get-Content -LiteralPath $gpgAgentConfPath | Where-Object { $_ -notmatch '^\s*#' } | ForEach-Object { $_.Trim() })
    $gpgAgentConfEnableWin32OpensshSupport = 'enable-win32-openssh-support' -in $gpgAgentConf
    $gpgAgentConfEnablePuttySupport = 'enable-putty-support' -in $gpgAgentConf
    $gpgAgentConfEnableSshSupport = 'enable-ssh-support' -in $gpgAgentConf
}

if ($gpgAgentProcess -and $gpgAgentConfEnablePuttySupport -and (-not $DisablePageantPipe)) {
    Write-TerminatingError "😖 GPG agent is running and configured to support PuTTY, which will prevent WinSSH-Pageant from functioning. To use WinSSH-Pageant, remove 'enable-putty-support' from '$gpgAgentConfPath' and restart the GPG agent before trying again." (Get-Item $gpgAgentConfPath)
}

[System.Diagnostics.Process] $pageantProcess = Get-Process -Name 'pageant' -ErrorAction SilentlyContinue
if ($pageantProcess -and (-not $DisablePageantPipe)) {
    Write-TerminatingError  "😖 Pageant is running, which will prevent WinSSH-Pageant from functioning. To use WinSSH-Pageant, please close Pageant or use the `-DisablePageantPipe` parameter of this script." $pageantProcess
}

# TODO: Look for other Pageant-like processes that may conflict with WinSSH-Pageant.

function Wait-ForGpgAgentProcess {
    $script:gpgAgentProcess = Get-Process -Name $gpgAgentProcessName -ErrorAction SilentlyContinue
    [DateTime] $startTime = Get-Date
    [float] $remainingWaitSeconds = [Math]::Max($GpgAgentStartWait.TotalSeconds - (((Get-Date) - $startTime)).TotalSeconds, 0)
    [bool] $first = $true
    while ((-not $gpgAgentProcess) -and ($remainingWaitSeconds -gt 0)) {
        if ($first) {
            Write-Information "⏳ Waiting for GPG agent process '$gpgAgentProcessName' to start…"
            $first = $false
        }
        Start-Sleep -Seconds 1
        $script:gpgAgentProcess = Get-Process -Name $gpgAgentProcessName -ErrorAction SilentlyContinue
        $remainingWaitSeconds = [Math]::Max($GpgAgentStartWait.TotalSeconds - (((Get-Date) - $startTime)).TotalSeconds, 0)
    }
    if (-not $gpgAgentProcess) {
        Write-TerminatingError "❓ GPG agent process '$gpgAgentProcessName' is not running, waited for $($GpgAgentStartWait.TotalSeconds) seconds."
    } else {
        Write-Debug "✔️ GPG agent process '$gpgAgentProcessName' is running."
    }
    return $gpgAgentProcess
}

function Wait-ForGpgAgentPipeCreation([string] $pipePath) {
    [System.Diagnostics.Process] $gpgAgentProcess = Get-Process -Name $gpgAgentProcessName

    [TimeSpan] $gpgAgentProcessAge = ((Get-Date) - $gpgAgentProcess.StartTime)
    [bool] $targetExists = Test-Path $pipePath -ErrorAction SilentlyContinue
    [bool] $first = $true
    Write-Information "⏱️ GPG agent has been running for $gpgAgentProcessAge."
    while ((-not $targetExists) -and ($gpgAgentProcessAge -lt $GpgAgentWarmupTimeout)) {
        if ($first) {
            Write-Information "⏳ Waiting for GPG agent to create SSH agent pipe ('$pipePath')…"
            $first = $false
        }
        Start-Sleep -Seconds 1
        $gpgAgentProcess.Refresh()
        $gpgAgentProcessAge = ((Get-Date) - $gpgAgentProcess.StartTime)
        $targetExists = Test-Path $pipePath -ErrorAction SilentlyContinue
    }
    if (-not $targetExists) {
        Write-TerminatingError "❓ GPG agent has been running for $gpgAgentProcessAge, but the SSH agent pipe ('$pipePath') does not exist."
    } else {
        Write-Debug "✔️ GPG agent created the SSH agent pipe ('$pipePath')."
    }
}

function Validate-OpenSshAgentPipeVariable([string] $pipePathVariableValue, [string] $pipePathVariableDescriptor) {
    if (-not $pipePathVariableValue) {
        Write-Warning "$pipePathVariableDescriptor is not set. This may cause issues with SSH agent forwarding."
        return
    }
    [bool] $targetExists = Test-Path $pipePathVariableValue -ErrorAction SilentlyContinue
    if ($pipePathVariableValue -eq $defaultWindowsGpgOpenSshAgentPipePath) {
        # The pipe path variable (whichever it is) points to the default path used by GPG's OpenSSH agent.
        # Validate GPG-specific SSH configuration.
        Write-Information "🔎 $pipePathVariableDescriptor points to default path used by GPG's OpenSSH agent: $pipePathVariableValue"
        if ($gpgAgentConfExists) {
            if (-not $gpgAgentConfEnableSshSupport) {
                Write-Warning "$pipePathVariableDescriptor implies GPG agent should be configured to support SSH, but it is not. Please add 'enable-ssh-support' to '$gpgAgentConfPath'."
            } else {
                Write-Debug "✔️ $pipePathVariableDescriptor implies GPG agent should be configured to support SSH, confirmed by finding 'enable-ssh-support' in '$gpgAgentConfPath'."
            }
            if (-not $gpgAgentConfEnableWin32OpensshSupport) {
                Write-Warning "$pipePathVariableDescriptor implies GPG agent should be configured to support OpenSSH on Windows, but it is not. Please add 'enable-win32-openssh-support' to '$gpgAgentConfPath'."
            } else {
                Write-Debug "✔️ $pipePathVariableDescriptor implies GPG agent should be configured to support OpenSSH on Windows, confirmed by finding 'enable-win32-openssh-support' in '$gpgAgentConfPath'."
            }
            if ($gpgAgentConfEnableSshSupport -and $gpgAgentConfEnableWin32OpensshSupport -and (-not $gpgAgentProcess)) {
                # We only wait for GPG to start if we know it is configured correctly and that we definitely *expect* it to be running.
                $script:gpgAgentProcess = Wait-ForGpgAgentProcess
            }
            if (-not $gpgAgentProcess) {
                Write-Warning "$pipePathVariableDescriptor implies GPG agent should be running, but no process matching '$gpgAgentProcessName' was found."
            } else {
                Write-Debug "✔️ $pipePathVariableDescriptor implies GPG agent should be running, and a process matching '$gpgAgentProcessName' was found."
            }
        } else {
            Write-Warning "$pipePathVariableDescriptor implies GPG agent should be configured, but the configuration file could not be found: $gpgAgentConfPath"
        }
        if ($gpgAgentConfEnableSshSupport -and $gpgAgentConfEnableWin32OpensshSupport) {
            if ($gpgAgentProcess) {
                # We only wait for GPG to create the pipe if we know it is running and we know it is configured correctly.
                Wait-ForGpgAgentPipeCreation -pipePath $pipePathVariableValue
                $targetExists = $true # We don't test the pipe "again" because sometimes it flickers into and out of existence.
                Write-Information "✅ GPG agent is running and configured to support SSH/OpenSSH on Windows, and the pipe seems to exist."
            } else { # (-not $gpgAgentProcess)
                if ($targetExists) {
                    Write-Warning "Although configured to support SSH/OpenSSH on Windows, the GPG agent is not currently running - despite its pipe existing. Manually confirm no other agent is running."
                } else {
                    Write-TerminatingError "❌ Although configured to support SSH/OpenSSH on Windows, the GPG agent is not currently running and its pipe is missing. Please ensure the agent is running and try again."
                }
            }
        } else {
            if ($gpgAgentProcess) {
                if ($targetExists) {
                    Write-Warning "GPG agent is not configured correctly, but the pipe exists. This may cause issues with SSH agent forwarding."
                } else {
                    Write-TerminatingError "❌ GPG agent is not configured correctly, and the pipe does not exist. Check the GPG agent's configuration, then restart the GPG agent before trying again."
                }
            } else { # (-not $gpgAgentProcess)
                if ($targetExists) {
                    Write-Warning "GPG agent is not correctly configured and is not running, but the pipe exists. Manually confirm no other agent is running."
                } else {
                    Write-TerminatingError "❌ GPG agent's pipe is not available because the agent is not correctly configured and is not running. Check the GPG agent's configuration, then restart the GPG agent before trying again."
                }
            }
        }
    } else { # ($pipePathVariableValue -ne $defaultWindowsGpgOpenSshAgentPipePath)
        # TODO: Check SSH agent pipe path for patterns of other known SSH agents, and provide warnings if they aren't running.
        Write-Information "🔎 $pipePathVariableDescriptor points to non-default path: $pipePathVariableValue"
    }
    if (-not $targetExists) {
        Write-TerminatingError "❌ $pipePathVariableDescriptor points to a non-existent path. Please ensure the SSH agent is running, configured correctly, then restart the GPG agent before trying again."
    }
}

if ((-not $SshPipePath) -and ($Env:SSH_AUTH_SOCK)) {
    Validate-OpenSshAgentPipeVariable -pipePathVariableValue $Env:SSH_AUTH_SOCK -pipePathVariableDescriptor '$Env:SSH_AUTH_SOCK'
} elseif ($SshPipePath) {
    if ($Env:SSH_AUTH_SOCK) {
        Write-Information "❕ Parameter `-SshPipePath` was provided, so the pre-existing `$Env:SSH_AUTH_SOCK will be ignored."
    }
    Validate-OpenSshAgentPipeVariable -pipePathVariableValue $SshPipePath -pipePathVariableDescriptor 'Parameter `-SshPipePath`'
} elseif (-not $SshPipePath) {
    Write-Warning 'No SSH pipe path was provided, and $Env:SSH_AUTH_SOCK is not set. WinSSH-Pageant may not be able to locate an SSH agent.'
}

[string[]] $arguments = @()
if ((-not $SshPipePath) -and $Env:SSH_AUTH_SOCK) {
    $arguments += @("--sshpipe", $Env:SSH_AUTH_SOCK)
} elseif ($SshPipePath) {
    $arguments += @("--sshpipe", $SshPipePath)
}
if ($DisablePageantPipe) {
    $arguments += @("--no-pageant-pipe")
}

[int] $exitDelaySeconds = $errorExitDelaySeconds
if ($AttachTTY) {
    [Nullable[int]] $winsshPageantExitCode = $null
    [bool] $winsshPageantExitNow = $false
    Write-Information "🚀 Executing WinSSH-Pageant with arguments: $arguments"
    &$winsshPageantExe @arguments `
    | ForEach-Object {
        if ($null -eq $winsshPageantExitCode) {
            $winsshPageantExitCode = $LASTEXITCODE
            $winsshPageantExitNow = $true
        }
        try {
            if ($_ -like "*already running*") {
                Write-TerminatingError "😖 WinSSH-Pageant reports that a Pageant-like process is already running."
            } else {
                Write-Output $_
            }
        } finally {
            if ($winsshPageantExitNow) {
                $winsshPageantExitNow = $false
                if ($winsshPageantExitCode -eq 0) {
                    $exitDelaySeconds = 1
                    Write-Information "✨ WinSSH-Pageant exited successfully."
                } else {
                    Write-TerminatingError "💥 WinSSH-Pageant exited with code $winsshPageantExitCode."
                }
            }
        }
    }
    if ($null -eq $winsshPageantExitCode) {
        $winsshPageantExitCode = $LASTEXITCODE
        $winsshPageantExitNow = $true
    }
    if ($winsshPageantExitNow) {
        $winsshPageantExitNow = $false
        if ($winsshPageantExitCode -eq 0) {
            $exitDelaySeconds = 1
            Write-Information "✨ WinSSH-Pageant exited successfully."
        } else {
            Write-TerminatingError "💥 WinSSH-Pageant exited with code $winsshPageantExitCode."
        }
    }
} else {
    Write-Information "🚀 Starting WinSSH-Pageant with arguments: $arguments"

    [System.Diagnostics.Process] $process = Start-Process -FilePath $winsshPageantExe -ArgumentList $arguments -WindowStyle 'Hidden' -PassThru
    if ($process) {
        $InformationPreference = 'Continue'
        Write-Information "✨ WinSSH-Pageant is running in the background with PID $($process.Id)."
        $process.Dispose() | Out-Null
        $exitDelaySeconds = 1
    } else {
        Write-TerminatingError "💥 Failed to start WinSSH-Pageant."
    }
}

Start-ExitTimer -seconds $exitDelaySeconds
