function Edit-Profile() {
    $profileDirectory = (Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
    $profileModule = (Join-Path $profileDirectory ".\profile.psm1")
    code --wait --new-window $profileDirectory $profileModule
    Write-Warning "Remember to close and reopen PowerShell sessions to enact changes to your profile."
}


Export-ModuleMember -Function * -Cmdlet *