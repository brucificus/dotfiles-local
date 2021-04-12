Param(
    [string] $root
)

[string[]] $interestingChildren = `
    Get-ChildItem -Path $root -Directory `
    | Where-Object { -not (@(".git", "node_modules") -contains $_.Name) } `
    | Select-Object -ExpandProperty FullName

if (-not $interestingChildren) {
    return @()
} else {
    [string[]] $leafChildren = `
        $interestingChildren `
        | Where-Object { Test-Path (Join-Path $_ ".git") -ErrorAction SilentlyContinue }

    [string[]] $stemChildren = `
        $interestingChildren `
        | Where-Object { -not (Test-Path (Join-Path $_ ".git") -ErrorAction SilentlyContinue ) }

    if ($stemChildren) {
        foreach ($stemChild in $stemChildren) {
            $leafChildren += (&"$PSScriptRoot/Find-GitRepositories.ps1" -root $stemChild)
        }
    }

    $leafChildren = $leafChildren | Where-Object { -not [String]::IsNullOrWhiteSpace($_) }

    return $leafChildren
}
