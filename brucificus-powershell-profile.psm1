Import-Module PSReadLine
Import-Module PsIni

Import-Module -Name $PSScriptRoot\src\AwsHelpers.psm1
Import-Module -Name $PSScriptRoot\src\FusionLog.psm1
Import-Module -Name $PSScriptRoot\src\Git.psm1
Import-Module -Name $PSScriptRoot\src\HypervisorAwareness.psm1
Import-Module -Name $PSScriptRoot\src\PowershellProfileMaintenance.psm1
Import-Module -Name $PSScriptRoot\src\WebHelpers.psm1
Import-Module -Name $PSScriptRoot\src\EnvHelper.psm1

$env:HOME = $env:USERPROFILE
$env:HOMEDRIVE =  [System.IO.Path]::GetPathRoot($env:USERPROFILE)


Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *