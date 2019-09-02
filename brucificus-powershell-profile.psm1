Import-Module -Name $PSScriptRoot\src\PowershellProfileMaintenance.psm1 -DisableNameChecking

Ensure-ProfileModuleDependencyInstallations
Import-ProfileModuleDependencies

Import-Module -Name $PSScriptRoot\src\GitHub.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\Windows.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\Fonts.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\NerdFonts.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\Chocolatey.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\AwsHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\FusionLog.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\HypervisorAwareness.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\WebHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\EnvHelper.psm1 -DisableNameChecking



Import-Module -Name $PSScriptRoot\src\Git.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\CustomFonts.psm1 -DisableNameChecking
Ensure-CustomFontInstallations

$env:HOME = $env:USERPROFILE
$env:HOMEDRIVE =  [System.IO.Path]::GetPathRoot($env:USERPROFILE)



Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *
