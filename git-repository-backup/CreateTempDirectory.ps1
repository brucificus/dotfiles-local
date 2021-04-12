#Requires -RunAsAdministrator

function Create-TempDirectory([TimeSpan] $deleteIn) {
    [string] $directory = [System.IO.Path]::GetTempFileName()
    Remove-Item $directory | Out-Null
    mkdir $directory | Out-Null
    ."$PSScriptRoot/Schedule-FolderDeletion.ps1" -path $directory -in $deleteIn | Out-Null
    return $directory
}
