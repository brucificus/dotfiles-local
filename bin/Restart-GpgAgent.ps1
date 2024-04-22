#!/usr/bin/env pwsh

param(
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

if (-not (Get-Command gpg-connect-agent -ErrorAction SilentlyContinue)) {
    Write-TerminatingError "🪛 Command 'gpg-connect-agent' could not be found. Please ensure that GnuPG is installed and available in the PATH."
}

[int] $exitCode = 0

Write-Information "🔪 Killing the existing GnuPG agent…"
gpg-connect-agent killagent /bye
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
    Write-TerminatingError "💥 Failed to kill the existing GnuPG agent. gpg-connect-agent exited with code: $exitCode"
}

[int] $exitDelaySeconds = 0
Write-Information "🚀 Triggering startup of a new GnuPG agent…"
gpg-connect-agent /bye
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
    Write-TerminatingError "💥 Failed to start a new GnuPG agent. gpg-connect-agent exited with code: $exitCode"
}

$exitDelaySeconds = 1
Write-Information "✅ GnuPG agent has been restarted successfully."

Start-ExitTimer -seconds $exitDelaySeconds
