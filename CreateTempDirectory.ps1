function Create-TempDirectory() {
    [string] $directory = [System.IO.Path]::GetTempFileName()
    Remove-Item $directory | Out-Null
    mkdir $directory | Out-Null
    $cleanup += @({ Remove-Item -Path $directory -Recurse -Force }.GetNewClosure())
    return $directory
}
