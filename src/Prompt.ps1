Import-Module "$PSScriptRoot\Modules.psm1" -DisableNameChecking

Ensure-CustomFontInstallations

# We can't rely on `Ensure-ModuleInstallation` to detect module presence in this case,
# because `PANSIES` is a clobbering-only-installation
if (-not (Get-Command 'Get-Gradient' -ErrorAction SilentlyContinue)) {
    Ensure-ModuleInstallation PANSIES -MinimumVersion 2.0.0 -MaximumVersion 2.0.0 -AllowClobber -Force
}
Import-Module PANSIES

Ensure-ModuleInstallation oh-my-posh -MinimumVersion 2.0.440 -MaximumVersion 2.0.440 -AllowClobber -Force
Import-Module oh-my-posh

Set-Theme "$PSScriptRoot\OhMyPoshTheme\Brucificus.psm1"
