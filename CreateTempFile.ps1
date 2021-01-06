function Create-TempFile([TimeSpan] $deleteIn) {
    [string] $file = [System.IO.Path]::GetTempFileName()
    ."$PSScriptRoot/Schedule-FolderDeletion.ps1" -path $file -in $deleteIn | Out-Null
    return $file
}