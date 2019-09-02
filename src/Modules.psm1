function Ensure-ModuleInstallation([string] $moduleName, [string] $MinimumVersion, [string] $MaximumVersion, [switch] $AllowPrerelease) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        if ($allowPrerelease) {
            Install-Module -Name $moduleName -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -AllowPrerelease
        } else {
            Install-Module -Name $moduleName -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion
        }
    }
}


Export-ModuleMember -Function "Ensure-ModuleInstallation"
