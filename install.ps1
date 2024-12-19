#!/usr/bin/env pwsh
#Requires -Modules @{ModuleName="poshy-lucidity";ModuleVersion="0.3.16"}
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


function Write-TerminatingError([string] $message, [object] $targetObject = $null) {
    $errorRecord = [System.Management.Automation.ErrorRecord]::new(
        [System.Exception]::new($message),
        'LocalDotfilesError',
        'OperationStopped',
        $targetObject
    )
    Write-Error $errorRecord
    $PSCmdlet.ThrowTerminatingError($errorRecord)
}

if (-not (Test-LinkCapability)) {
    if ($IsWindows) {
        Write-TerminatingError "🖇️ This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session, or enable Developer Mode in Windows Settings."
    } else {
        Write-TerminatingError "🖇️ This script requires filesystem link capabilities. Please run this script in an elevated PowerShell session."
    }
}

Push-Location $PSScriptRoot
trap {
    Pop-Location
}

# Make sure dotbot is and our other dependencies are available.
git submodule update --quiet --init --force --checkout --depth 1 --recursive

# folders_to_relink = @()
# folders_to_relink | Where-Object { -not (Test-ReparsePoint $_) } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

$dotbot_dir = "dotbot"
function run_dotbot {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $config_file
    )
    foreach ($python in ('python', 'python3', 'python2')) {
        # Python redirects to Microsoft Store in Windows 10 when not installed
        if (& { $ErrorActionPreference = "SilentlyContinue"
                ![string]::IsNullOrEmpty((&$python -V))
                $ErrorActionPreference = "Stop" }) {
            $python_bin = $python
            break
        }
    }
    if (-not $python_bin) {
        Write-TerminatingError "💥 Cannot find Python."
    }
    [string] $ds = [System.IO.Path]::DirectorySeparatorChar
    $dotbot_bin = "$PSScriptRoot${ds}${dotbot_dir}${ds}bin${ds}dotbot"
    &$python $dotbot_bin -d $PSScriptRoot -c $config_file
}

# Execute dotbot.
run_dotbot "install.conf.yaml"
if ($IsWindows -and (Test-Path "install.win.conf.yaml" -ErrorAction SilentlyContinue)) {
    run_dotbot "install.win.conf.yaml"
} elseif ($IsLinux -and $Env:WSL_DISTRO_NAME -and (Test-Path "install.wsl.conf.yaml" -ErrorAction SilentlyContinue)) {
    run_dotbot "install.wsl.conf.yaml"
}
