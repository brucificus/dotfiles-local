#Requires -RunAsAdministrator

function Create-TempFile([TimeSpan] $deleteIn) {
    [string] $file = [System.IO.Path]::GetTempFileName()
    ."~/bin/Schedule-FolderDeletion.ps1" -path $file -in $deleteIn | Out-Null
    return $file
}