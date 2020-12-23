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

function PushTo-Remote([string] $downstreamRepo, [string] $upstreamRepo, [string] $refPrefix) {
    pushd $downstreamRepo
    try {
        [string] $temporaryGitRemoteName = "backup"
        
        Execute-LoggedExpression "git remote add $temporaryGitRemoteName $upstreamRepo" -suppressOutput
        try {
            [string[]] $sourceRefs = git show-ref | % { $_.Split(" ")[1] }

            foreach($sourceRef in $sourceRefs) {
                $sourceRef = $sourceRef.Replace("(", "__")
                $sourceRef = $sourceRef.Replace(")", "__")
                $sourceRef = $sourceRef.Replace(":", "__")

                [string] $refspec = $sourceRef + ":" + ($refPrefix + $sourceRef)
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

foreach ($repositoryCollection in $configuration.repositoryCollections) {
    [string] $repositoryCollectionLocation = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.location))
    Write-Information "Repository Collection: `"$repositoryCollectionLocation`""

    [string] $backupTarget = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.target))
    [string] $baseRefPrefix = [System.Environment]::ExpandEnvironmentVariables($repositoryCollection.backup.refPrefix)
    [string[]] $repositoryLocations = Find-GitRepositories -root $repositoryCollectionLocation

    foreach ($repositoryLocation in $repositoryLocations) {
        [string] $repositoryRelativePath = [System.IO.Path]::GetRelativePath($repositoryCollectionLocation, $repositoryLocation)
        $repositoryRelativePath = $repositoryRelativePath.Replace("\", "/")
        Write-Information "Repository: `"$repositoryRelativePath`""

        [string] $finalRefPrefix = "refs/" + $baseRefPrefix + $repositoryRelativePath + "/"

        PushTo-Remote -downstreamRepo $repositoryLocation -upstreamRepo $backupTarget -refPrefix $finalRefPrefix
    }

    Write-Information ""
    Write-Information ""
}