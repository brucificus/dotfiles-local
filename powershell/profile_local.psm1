Import-Module -Name $PSScriptRoot\personal-modules\PowershellProfileMaintenance.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\AwsHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\FusionLog.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\WebHelpers.psm1 -DisableNameChecking
Import-Module -Name $PSScriptRoot\personal-modules\CustomFonts.psm1 -DisableNameChecking

# Update local dotfiles
function ldfu() {
    Push-Location (Get-Item ~/.dotfiles_local).Target | Out-Null
    try {
        git pull --ff-only
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        ./install.ps1 -q
    } finally {
        Pop-Location | Out-Null
    }
}

Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *
