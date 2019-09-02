    <#
    .Synopsis
        Gets the fonts currently loaded on the system
    .Description
        Uses shell automation to retrieve all of the fonts loaded by the system.
    .Parameter FontNameFilter
        A filter to use to search by font names
    .Example
        # Get All Fonts
        Get-Font
    .Example
        # Get All Lucida Fonts
        Get-Font *Lucida*
    #>
function Get-Font([string] $FontNameFilter = "*") {
    Write-Debug "Getting font like `"$FontNameFilter`""

    $shellApp = New-Object -ComObject shell.application
    $fonts = $shellApp.NameSpace(0x14)

    $fonts.Items() |
        Where-Object { $_.Name -like "$FontNameFilter" }
}

    <#
    .Synopsis
        Detertmines if fonts matching the given filter exist in the registry.
    .Description
        Uses shell automation to retrieve all of the fonts loaded by the system.
    .Parameter FontNameFilter
        A filter to use to search by font names
    .Example
        # Returns 'true' if a Lucida font is installed
        Test-Font *Lucida*
    #>
function Test-Font([string] $FontNameFilter) {
    [string[]] $keys = @(
        "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts",
        "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    )

    $found = $keys `
        | ForEach-Object { Get-ItemProperty $_ | Get-Member -MemberType NoteProperty } `
        | Where-Object { $_.Name -like ($FontNameFilter + " (TrueType)") }

    if ($found) {
        return $true
    } else {
        return $false
    }
}

    <#
    .Synopsis
        Installs a font
    .Description
        Uses shell automation to install a font
    .Parameter FontFile
        The font file to install
    .Example
        # Installs a font
        Install-Font MyFont.ttf
    #>
function Install-Font([string] $FontFile) {
    Write-Verbose "Installing Font: $FontFile"

    $shellApp = New-Object -ComObject shell.application
    $fonts = $shellApp.NameSpace(0x14)
    $fonts.CopyHere($FontFile)
}


Export-ModuleMember -Function "Get-Font","Install-Font","Test-Font"
