#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if ((Test-Command tmux) -and (-not $Env:TMUX)) {
    # The Bash/Zsh equivalents were originally in the scripts that run at *login*,
    # but PowerShell doesn't have a direct equivalent to that.
    # TODO: Find a way to run this only once per *user*, so that reconnects don't spawn new sessions.

    if (Test-Command Test-SessionInteractivity) {
        if (Test-SessionInteractivity) {
            tmux -u new -A -s homeassistant pwsh -l
        }
    } else {
        tmux -u new -A -s homeassistant pwsh -l
    }
}
