Import-Module "$PSScriptRoot\Modules.psm1" -DisableNameChecking

Ensure-ModuleInstallation PSReadLine -MinimumVersion 2.0.0-beta3 -MaximumVersion 2.0.0-beta3 -AllowPrerelease
Import-Module PSReadLine

Ensure-ModuleInstallation posh-git -MinimumVersion 0.7.3 -MaximumVersion 0.7.3
Import-Module posh-git

$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

Ensure-CustomFontInstallations
