function Edit-Profile() {
    Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking

    Ensure-ChocolateyPackageInstallation "vscode"

    $profileDirectory = (Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
    code --wait --new-window $profileDirectory $($PROFILE.CurrentUserAllHosts)
    Write-Warning "Remember to close and reopen PowerShell sessions to enact changes to your profile."
}


Export-ModuleMember -Function "Edit-Profile"
