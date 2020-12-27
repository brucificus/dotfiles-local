$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

[psobject] $configuration = Get-Content -Raw "$PSScriptRoot/GitRepositories.json" | ConvertFrom-Json
[scriptblock[]] $cleanup = @()

try {
    foreach ($repositoryCollection in $configuration.repositoryCollections) {
        [string] $repositoryCollectionLocation = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.location))
        Write-Information "Repository Collection: `"$repositoryCollectionLocation`""

        &"$PSScriptRoot/Backup-GitRepositoryCollection.ps1" -repositoryCollection $repositoryCollection

        Write-Information ""
    }
} finally {
    $cleanup | ForEach-Object % { &$_ }
}