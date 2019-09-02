function Ensure-FontInstallationsFromChocolatey {
    Import-Module "$PSScriptRoot\Fonts.psm1"
    
    [string[]] $chocoFonts = @()

    if (-not (Get-Font 'Fira Code')) {
        $chocoFonts += @('FiraCode')
    }

    if (-not (Get-Font 'Roboto')) {
        $chocoFonts += @('RobotFonts')
    }

    if (-not (Get-Font 'Source Code Pro')) {
        $chocoFonts += @('sourcecodepro')
    }

    if (-not (Get-Font 'Envy Code R')) {
        $chocoFonts += @('envycoder')
    }

    if ($chocoFonts.Length) {
        Write-Verbose "Missing fonts: $chocoFonts"
        Import-Module "$PSScriptRoot\Chocolatey.psm1"

        $chocoFonts | Ensure-ChocolateyPackageInstallation
    }
}

function Ensure-FontInstallationsFromNerdFonts {
    Import-Module "$PSScriptRoot\Fonts.psm1"

    [string []] $nerdFonts = @()

    if (-not (Get-Font 'FuraCode NF')) {
        $nerdFonts += @('Fura Code * Complete Windows Compatible')
    }

    if (-not (Get-Font 'RobotoMono NF')) {
        $nerdFonts += @('Roboto Mono * Complete Windows Compatible')
    }

    if (-not (Get-Font 'SauceCodePro NF')) {
        $nerdFonts += @('Sauce Code Pro * Complete Windows Compatible')
    }

    if ($nerdFonts.Length) {
        Write-Verbose "Missing fonts: $nerdFonts"
        Import-Module "$PSScriptRoot\NerdFonts.psm1"
        Install-NerdFont -FontNameFilter $nerdFonts
    }
}

function Ensure-CustomFontInstallations {
    Write-Verbose "Ensuring custom fonts are installed"
    Ensure-FontInstallationsFromChocolatey
    Ensure-FontInstallationsFromNerdFonts
}


Export-ModuleMember -Function "Ensure-CustomFontInstallations"
