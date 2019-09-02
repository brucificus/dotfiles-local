function google([string] $query) {
    Write-Debug "Googling `"$query`""
    $url = "http://google.com/#safe=active&q=" + [System.Uri]::EscapeUriString($query)
    Start-Process $url
}


Export-ModuleMember -Function "google"
