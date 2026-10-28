#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Kills all running Microsoft Edge processes, then relaunches Edge with the
    remote debugging port enabled.
.DESCRIPTION
    Stops every msedge process, then starts Edge listening on CDP port 9222
    against the default user data directory so tools (Playwright, CDP clients)
    can attach.
#>

[CmdletBinding()]
param(
    [int]$Port = 9222,
    [string]$EdgePath = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
)

if (-not $IsWindows) {
    throw 'This script targets Microsoft Edge on Windows only.'
}

Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process -Force

& $EdgePath --remote-debugging-port=$Port --user-data-dir="$env:LOCALAPPDATA\Microsoft\Edge\User Data"
