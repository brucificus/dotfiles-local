function Edit-Profile() {
    Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking

    Ensure-ChocolateyPackageInstallation "vscode"

    $profileDirectory = (Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
    code --wait --new-window $profileDirectory $($PROFILE.CurrentUserAllHosts)
    Write-Warning "Remember to close and reopen PowerShell sessions to enact changes to your profile."
}

function Ensure-ProfileModuleDependencyInstallations() {
    Write-Verbose "Ensuring profile module's dependency modules are installed"
    Import-Module "$PSScriptRoot\Modules.psm1"

    Ensure-ModuleInstallation PSReadLine -MinimumVersion 2.0.0-beta3 -MaximumVersion 2.0.0-beta3 -AllowPrerelease
    Ensure-ModuleInstallation psini -MinimumVersion 3.1.2 -MaximumVersion 3.1.2
    Ensure-ModuleInstallation posh-git -MinimumVersion 0.7.3 -MaximumVersion 0.7.3
}

function Import-ProfileModuleDependencies() {
    Write-Verbose "Importing profile module's dependency modules"
    Import-Module PSReadLine
    Import-Module psini
    Import-Module posh-git
}


Export-ModuleMember -Function "Import-ProfileModuleDependencies"
