Import-Module PSReadLine
Import-Module PsIni

Import-Module -Name $PSScriptRoot\AwsHelpers.psm1
Import-Module -Name $PSScriptRoot\FusionLog.psm1
Import-Module -Name $PSScriptRoot\Git.psm1
Import-Module -Name $PSScriptRoot\HypervisorAwareness.psm1
Import-Module -Name $PSScriptRoot\PowershellProfileMaintenance.psm1
Import-Module -Name $PSScriptRoot\WebHelpers.psm1
Import-Module -Name $PSScriptRoot\EnvHelper.psm1

$env:HOME = $env:USERPROFILE
$env:HOMEDRIVE =  [System.IO.Path]::GetPathRoot($env:USERPROFILE)


Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *