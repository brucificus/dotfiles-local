function Test-Elevation() {
    Write-Debug "Testing elevation"
    return [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")
}


Export-ModuleMember -Function "Test-Elevation"
