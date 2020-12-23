$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"
$DebugPreference = "Continue"

[psobject] $configuration = Get-Content -Raw "$PSScriptRoot/GitRepositories.json" | ConvertFrom-Json

function Find-GitRepositories([string] $root) {
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
                $leafChildren += (Find-GitRepositories -root $stemChild)
            }
        }

        $leafChildren = $leafChildren | Where-Object { -not [String]::IsNullOrWhiteSpace($_) }

        return $leafChildren
    }
}

function Execute-LoggedExpression([string] $expression, [switch] $suppressOutput) {
    Write-Information $expression

    if ($suppressOutput) {
        Invoke-Expression $expression | Out-Null
    } else {
        Invoke-Expression $expression
    }
}

function Escape-RefName([string] $ref) {
    [string] $result = $ref.Replace("(", "__")
    $result = $result.Replace(")", "__")
    $result = $result.Replace(":", "__")
    return $result
}

function PushTo-Remote([string] $downstreamRepo, [string] $upstreamRepo, [string] $refPrefix) {
    pushd $downstreamRepo
    try {
        [string] $temporaryGitRemoteName = "backup"
        
        Execute-LoggedExpression "git remote add $temporaryGitRemoteName $upstreamRepo" -suppressOutput
        try {
            [string[]] $sourceRefs = git show-ref | % { $_.Split(" ")[1] }

            foreach($sourceRef in $sourceRefs) {
                $sourceRef = Escape-RefName -ref $sourceRef
                [string] $targetRef = $refPrefix + $sourceRef
                [string] $refspec = $sourceRef + ":" + $targetRef

                Execute-LoggedExpression "git push $temporaryGitRemoteName $refspec --porcelain --atomic --force" -suppressOutput
            }

        } finally {
            Execute-LoggedExpression "git remote remove $temporaryGitRemoteName" -suppressOutput
        }
    }
    finally {
        popd
    }
}

function Backup-RepositoryCollection([psobject] $repositoryCollection) {
    [string] $backupTarget = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.target))
    [string] $baseRefPrefix = [System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.refPrefix)
    [string[]] $repositoryLocations = `
        Find-GitRepositories -root $repositoryCollectionLocation `
        | ForEach-Object { [System.IO.Path]::GetRelativePath($repositoryCollectionLocation, $_) } `
        | ForEach-Object { $_.Replace("\`"", "/") }

    pushd $repositoryCollectionLocation
    try {
        foreach ($repositoryLocation in $repositoryLocations) {
            Write-Information "Repository: `"$repositoryLocation`""
    
            [string] $finalRefPrefix = "refs/" + $baseRefPrefix + $repositoryLocation + "/"
            PushTo-Remote -downstreamRepo $repositoryLocation -upstreamRepo $backupTarget -refPrefix $finalRefPrefix
        }
    } finally {
        popd
    }
}

foreach ($repositoryCollection in $configuration.repositoryCollections) {
    [string] $repositoryCollectionLocation = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.location))
    Write-Information "Repository Collection: `"$repositoryCollectionLocation`""

    Backup-RepositoryCollection -repositoryCollection $repositoryCollection

    Write-Information ""
    Write-Information ""
}