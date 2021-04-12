Param(
    [psobject] $repositoryCollection
)

Write-Information "Searching for repositories."

[string] $backupTarget = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.target))
[string] $baseRefPrefix = [System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.refPrefix)
[string[]] $repositoryLocations = `
    &"$PSScriptRoot/Find-GitRepositories.ps1" -root $repositoryCollectionLocation `
    | ForEach-Object { [System.IO.Path]::GetRelativePath($repositoryCollectionLocation, $_) } `
    | ForEach-Object { $_.Replace("\`"", "/") }

Write-Information "Discovered $($repositoryLocations.Length) repositories."
Write-Information ""

pushd $repositoryCollectionLocation
try {
    foreach ($repositoryLocation in $repositoryLocations) {

        [string] $finalRefPrefix = $baseRefPrefix + ($repositoryLocation.Replace("\", "/")) + "/"
        Write-Information "Backup-GitRepository.ps1 -downstreamRepo `"$repositoryLocation`" -upstreamRepo `"$backupTarget`" -refPrefix `"$finalRefPrefix`""
        &"$PSScriptRoot/Backup-GitRepository.ps1" -downstreamRepo "$repositoryLocation" -upstreamRepo "$backupTarget" -refPrefix "$finalRefPrefix"

        Write-Information ""
    }
} finally {
    popd
}

Write-Information ""