$ErrorActionPreference = "Stop"
$InformationPreference = "Continue"

[psobject] $configuration = Get-Content -Raw "$PSScriptRoot/GitRepositories.json" | ConvertFrom-Json
[scriptblock[]] $cleanup = @()

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

function Execute-InformationLoggedExpression([string] $expression, [switch] $suppressOutput) {
    Write-Information "Executing: $expression"

    if ($suppressOutput) {
        Invoke-Expression $expression 2>&1 | Out-Null
    } else {
        Invoke-Expression $expression 2>&1 | Write-Information
    }
}

function Execute-DebugLoggedExpression([string] $expression, [switch] $suppressOutput) {
    Write-Debug "Executing: $expression"

    if ($suppressOutput) {
        Invoke-Expression $expression 2>&1 | Out-Null
    } else {
        Invoke-Expression $expression 2>&1 | Write-Debug
    }
}

function Create-TempFile() {
    [string] $file = [System.IO.Path]::GetTempFileName()
    $cleanup += @({ Remove-Item -Path $file -Force }.GetNewClosure())
    return $file
}

function Create-TempDirectory() {
    [string] $directory = [System.IO.Path]::GetTempFileName()
    Remove-Item $directory | Out-Null
    mkdir $directory | Out-Null
    $cleanup += @({ Remove-Item -Path $directory -Recurse -Force }.GetNewClosure())
    return $directory
}


function Get-TemporaryGitReferenceClone([string] $source) {
    [string] $target = Create-TempDirectory

    Execute-DebugLoggedExpression "Remove-Item -Path `"$target`" -Recurse -Force" -suppressOutput
    git clone --mirror --reference `"$source`" `"$source`" `"$target`" | Write-Debug

    return $target
}

function PushTo-Remote([string] $downstreamRepo, [string] $upstreamRepo, [string] $refPrefix) {
    pushd $downstreamRepo
    try {
        
        [string] $directory = Get-TemporaryGitReferenceClone -source .

        Write-Information "Using temporary clone in `"$directory`"."
        pushd $directory
        try {
            [string[]] $sourceRefPairs = git show-ref
            
            [string] $temporaryGitRemoteName = "backup"
            Execute-DebugLoggedExpression "git remote add `"$temporaryGitRemoteName`" `"$upstreamRepo`"" -suppressOutput
            # git fetch "$temporaryGitRemoteName" "refs/heads/$refPrefix*:refs/heads/$refPrefix*" --no-auto-maintenance --no-auto-gc | Write-Information

            Write-Information "Renaming refs to include prefixes."
            foreach($sourceRefPair in $sourceRefPairs) {
                [string] $sourceRefName = $sourceRefPair.Split(" ")[1]
                [string] $sourceRefTarget = $sourceRefPair.Split(" ")[0]
                
                [string] $refType = (git cat-file -t $sourceRefTarget)
                [string] $targetRefName = ""
                switch ($refType) {
                    "commit" {
                        [string] $targetBranchName = $refPrefix + $sourceRefName.Substring("refs/".Length)
                        $targetRefName = "refs/heads/" + $targetBranchName

                        Execute-DebugLoggedExpression "git update-ref `"$targetRefName`" `"$sourceRefName`"" -suppressOutput
                        # Execute-DebugLoggedExpression "git branch --set-upstream-to=`"$temporaryGitRemoteName/$targetBranchName`" `"$targetBranchName`"" -suppressOutput
                    }
                    "tag" {
                        [string] $targetTagName = $refPrefix + $sourceRefName.Substring("refs/tags/".Length)
                        $targetRefName = "refs/tags/" + $targetTagName

                        Execute-DebugLoggedExpression "git update-ref `"$targetRefName`" `"$sourceRefName`"" -suppressOutput
                    }
                    default {
                        Write-Error "Unexpected ref type: " + $refType
                    }
                }
            }

            foreach($sourceRefPair in $sourceRefPairs) {
                [string] $sourceRefName = $sourceRefPair.Split(" ")[1]
                Execute-DebugLoggedExpression "git update-ref -d `"$sourceRefName`"" -suppressOutput
            }

            git fetch "$temporaryGitRemoteName" "refs/heads/$refPrefix*:refs/heads/$refPrefix*" --no-auto-maintenance --no-auto-gc | Write-Information

            Write-Information "Pushing to `"$upstreamRepo`""
            git push --all "$upstreamRepo" --atomic --force | Write-Information
            git push --tags "$upstreamRepo" --atomic --force | Write-Information
        } finally {
            popd
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
    
            [string] $finalRefPrefix = $baseRefPrefix + ($repositoryLocation.Replace("\", "/")) + "/"
            PushTo-Remote -downstreamRepo $repositoryLocation -upstreamRepo $backupTarget -refPrefix $finalRefPrefix

            Write-Information ""
        }
    } finally {
        popd
    }
}

try {
    foreach ($repositoryCollection in $configuration.repositoryCollections) {
        [string] $repositoryCollectionLocation = Resolve-Path ([System.Environment]::ExpandEnvironmentVariables($repositoryCollection.location))
        Write-Information "Repository Collection: `"$repositoryCollectionLocation`""

        Backup-RepositoryCollection -repositoryCollection $repositoryCollection

        Write-Information ""
    }
} finally {
    $cleanup | ForEach-Object % { &$_ }
}