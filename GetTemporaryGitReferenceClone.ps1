."$PSScriptRoot/CreateTempDirectory.ps1"

function Get-TemporaryGitReferenceClone([string] $source) {
    [string] $target = Create-TempDirectory

    Remove-Item -Path "$target" -Recurse -Force
    git clone --mirror --reference `"$source`" `"$source`" `"$target`" | Write-Debug

    return $target
}