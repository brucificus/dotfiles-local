function Install-NerdFont {
    <#
    .SYNOPSIS
        Installs the provided `Nerd-Fonts` fonts.
    .DESCRIPTION
        Installs all the `Nerd-Fonts` fonts by default.  The FontNameFilter
        parameter can be used to pick a subset of fonts to install.
    .EXAMPLE
        C:\PS> Install-NerdFont -All
        Installs all the fonts located in the `Nerd-Fonts` Git repository.
    .EXAMPLE
        C:\PS> Install-NerdFont furamono-, hack-*
        Installs all the FuraMono and Hack fonts.
    .EXAMPLE
        C:\PS> Install-NerdFont d* -WhatIf
        Shows which fonts would be installed without actually installing the fonts.
        Remove the "-WhatIf" to install the fonts.
    #>
    [CmdletBinding(SupportsShouldProcess)]  
    param(
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Single")]
        [string[]] $FontNameFilter,

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = "All")]
        [switch]  $All
    )
    Import-Module "$PSScriptRoot\GitHub.psm1"

    if ($All) {
        $FontNameFilter = @("*")
    }

    Use-GitHubZipBall 'ryanoasis/nerd-fonts' '2.0.0' -action {
        # Taken and modified from: https://github.com/ryanoasis/nerd-fonts/blob/b752a82fd2d778428075e2130947e951d98befd8/patched-fonts/install.ps1

        cd patched-fonts
        $fontFiles = New-Object 'System.Collections.Generic.List[System.IO.FileInfo]'
        foreach ($aFontName in $FontNameFilter) {
            Write-Debug "Looking for Font: $aFontName"
            Get-ChildItem $pwd -Filter "${aFontName}.ttf" -Recurse | Foreach-Object {$fontFiles.Add($_)}
            Get-ChildItem $pwd -Filter "${aFontName}.otf" -Recurse | Foreach-Object {$fontFiles.Add($_)}
        }

        Import-Module "$PSScriptRoot\Fonts.psm1"
        foreach ($fontFile in $fontFiles) {
            if ($PSCmdlet.ShouldProcess($fontFile.Name, "Install Font")) {
                Install-Font $fontFile.FullName
            }
        }
    }
}


Export-ModuleMember -Function "Install-NerdFont"
