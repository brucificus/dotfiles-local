Param(
    [psobject] $repositoryCollection
)

[string] $backupTarget = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.target))
[string] $baseRefPrefix = [System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.refPrefix)
[string[]] $repositoryLocations = `
    &"$PSScriptRoot/Find-GitRepositories.ps1" -root $repositoryCollectionLocation `
    | ForEach-Object { [System.IO.Path]::GetRelativePath($repositoryCollectionLocation, $_) } `
    | ForEach-Object { $_.Replace("\`"", "/") }

pushd $repositoryCollectionLocation
try {
    foreach ($repositoryLocation in $repositoryLocations) {
        Write-Information "Repository: `"$repositoryLocation`""

        [string] $finalRefPrefix = $baseRefPrefix + ($repositoryLocation.Replace("\", "/")) + "/"
        &"$PSScriptRoot/Backup-GitRepository.ps1" -downstreamRepo $repositoryLocation -upstreamRepo $backupTarget -refPrefix $finalRefPrefix

        Write-Information ""
    }
} finally {
    popd
}
