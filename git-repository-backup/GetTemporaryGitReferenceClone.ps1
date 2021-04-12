."$PSScriptRoot/CreateTempDirectory.ps1"

function Get-TemporaryGitReferenceClone([string] $source) {
    [string] $target = Create-TempDirectory -deleteIn ([TimeSpan]::FromMinutes(90))

    Remove-Item -Path "$target" -Recurse -Force | Out-Null
    
    git clone --quiet --mirror --reference `"$source`" `"$source`" `"$target`" | Out-Null

    return $target
}