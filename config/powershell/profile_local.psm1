$ErrorActionPreference = 'Stop'


Push-Location $PSScriptRoot
trap {
    Pop-Location
}

Import-Module ./profile_local.psm1
