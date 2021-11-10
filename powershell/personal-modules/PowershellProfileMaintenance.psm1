function Edit-WindowsTerminalSettings {
    if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
        Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking
        Ensure-ChocolateyPackageInstallation "vscode"
    }

    [string] $file = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    code --wait --new-window $file
}

function Edit-ConEmuSettings {
    if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
        Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking
        Ensure-ChocolateyPackageInstallation "vscode"
    }

    [string] $file = "$Env:APPDATA\ConEmu.xml"
    code --wait --new-window $file
}

function Edit-Profile() {
    if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
        Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking
        Ensure-ChocolateyPackageInstallation "vscode"
    }

    $profileDirectory = (Get-Item $PROFILE.CurrentUserAllHosts).DirectoryName
    code --wait --new-window $profileDirectory $($PROFILE.CurrentUserAllHosts)
    Write-Warning "Remember to close and reopen PowerShell sessions to enact changes to your profile."
}


Export-ModuleMember -Function "Edit-WindowsTerminalSettings","Edit-ConEmuSettings","Edit-Profile"
