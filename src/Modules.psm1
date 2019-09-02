function Ensure-ModuleInstallation([string] $moduleName, [string] $MinimumVersion, [string] $MaximumVersion, [switch] $AllowPrerelease, [switch] $AllowClobber) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        [string[]] $parameters = @('-Name', $moduleName)
        $parameters += @('-MinimumVersion', $MinimumVersion)
        $parameters += @('-MaximumVersion', $MaximumVersion)

        if ($AllowPrerelease) {
            $parameters += @('-AllowPrerelease')
        }

        if ($AllowClobber) {
            $parameters += @('-AllowClobber')
        }

        Invoke-Expression "Install-Module $parameters"
    }
}


Export-ModuleMember -Function "Ensure-ModuleInstallation"
