$ErrorActionPreference = 'Stop'

Push-Location ~/.dotfiles_local/powershell

try {
    Import-Module ./profile_local.psm1
} finally {
    Pop-Location
}
