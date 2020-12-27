function Create-TempFile() {
    [string] $file = [System.IO.Path]::GetTempFileName()
    $cleanup += @({ Remove-Item -Path $file -Force | Out-Null }.GetNewClosure())
    return $file
}