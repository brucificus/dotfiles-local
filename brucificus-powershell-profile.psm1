Import-Module -Name $PSScriptRoot\src\PowershellProfileMaintenance.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\AwsHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\FusionLog.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\WebHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\EnvHelper.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\HypervisorAwareness.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\src\CustomFonts.psm1 -DisableNameChecking

. "$PSScriptRoot\src\Prompt.ps1"

$env:HOME = $env:USERPROFILE
$env:HOMEDRIVE =  [System.IO.Path]::GetPathRoot($env:USERPROFILE)


Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *
