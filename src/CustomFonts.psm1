function Ensure-FontInstallationsFromChocolatey {
    Import-Module "$PSScriptRoot\Fonts.psm1" -DisableNameChecking
    
    [string[]] $chocoFonts = @()

    if (-not (Test-Font 'Fira Code')) {
        $chocoFonts += @('FiraCode')
    }

    if (-not (Test-Font 'Roboto')) {
        $chocoFonts += @('RobotFonts')
    }

    if (-not (Test-Font 'Source Code Pro')) {
        $chocoFonts += @('sourcecodepro')
    }

    if (-not (Test-Font 'Envy Code R')) {
        $chocoFonts += @('envycoder')
    }

    if ($chocoFonts.Length) {
        Write-Verbose "Missing fonts: $chocoFonts"
        Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking

        $chocoFonts | Ensure-ChocolateyPackageInstallation
    }
}

function Ensure-FontInstallationsFromNerdFonts {
    Import-Module "$PSScriptRoot\Fonts.psm1" -DisableNameChecking

    [string []] $nerdFonts = @()

    if (-not (Test-Font 'Fura Code * Complete Mono Windows Compatible')) {
        $nerdFonts += @('Fura Code * Complete Mono Windows Compatible')
    }

    if (-not (Test-Font 'Roboto Mono * Complete Mono Windows Compatible')) {
        $nerdFonts += @('Roboto Mono * Complete Mono Windows Compatible')
    }

    if (-not (Test-Font 'Sauce Code Pro * Complete Mono Windows Compatible')) {
        $nerdFonts += @('Sauce Code Pro * Complete Mono Windows Compatible')
    }

    if ($nerdFonts.Length) {
        Write-Verbose "Missing fonts: $nerdFonts"
        Import-Module "$PSScriptRoot\NerdFonts.psm1" -DisableNameChecking
        Install-NerdFont -FontNameFilter $nerdFonts
    }
}

function Ensure-CustomFontInstallations {
    Write-Verbose "Ensuring custom fonts are installed"
    Ensure-FontInstallationsFromChocolatey
    Ensure-FontInstallationsFromNerdFonts
}


Export-ModuleMember -Function "Ensure-CustomFontInstallations"
