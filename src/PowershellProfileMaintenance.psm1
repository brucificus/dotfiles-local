function Edit-Profile() {
    $profileDirectory = (Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
    $profileModule = (Join-Path $profileDirectory ".\profile.psm1")
    code --wait --new-window $profileDirectory $profileModule
    Write-Warning "Remember to close and reopen PowerShell sessions to enact changes to your profile."
}

function Ensure-ModuleInstallation([string] $moduleName, [string] $MinimumVersion, [string] $MaximumVersion, [switch] $AllowPrerelease) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        if ($allowPrerelease) {
            Install-Module -Name $moduleName -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion -AllowPrerelease
        } else {
            Install-Module -Name $moduleName -MinimumVersion $MinimumVersion -MaximumVersion $MaximumVersion
        }
    }
}

function Ensure-ProfileModuleDependencyInstallations {
    Ensure-ModuleInstallation PSReadLine -MinimumVersion 2.0.0-beta3 -MaximumVersion 2.0.0-beta3 -AllowPrerelease
    Ensure-ModuleInstallation psini -MinimumVersion 3.1.2 -MaximumVersion 3.1.2
    Ensure-ModuleInstallation posh-git -MinimumVersion 0.7.3 -MaximumVersion 0.7.3
}

function Import-ProfileModuleDependencies {
    Import-Module PSReadLine
    Import-Module psini
    Import-Module posh-git
}

Export-ModuleMember -Function * -Cmdlet *