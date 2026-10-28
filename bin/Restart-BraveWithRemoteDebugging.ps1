#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Kills all running Brave processes, then relaunches Brave with the
    remote debugging port enabled.
.DESCRIPTION
    Stops every brave process, then starts Brave listening on CDP port 9222
    against the default user data directory so tools (Playwright, CDP clients)
    can attach.
#>

[CmdletBinding()]
param(
    [int]$Port = 9222,
    [string]$BravePath = "${env:USERPROFILE}\AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe"
)

if (-not $IsWindows) {
    throw 'This script targets Brave on Windows only.'
}

Get-Process brave -ErrorAction SilentlyContinue | Stop-Process -Force

& $BravePath --remote-debugging-port=$Port
