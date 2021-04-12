Import-Module -Name $PSScriptRoot\personal-modules\PowershellProfileMaintenance.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\AwsHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\FusionLog.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\Git.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\WebHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\EnvHelper.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\HypervisorAwareness.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\CustomFonts.psm1 -DisableNameChecking

$env:HOME = $env:USERPROFILE
$env:HOMEDRIVE =  [System.IO.Path]::GetPathRoot($env:USERPROFILE)

Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *
