Param(
    [string] $downstreamRepo,
    [string] $upstreamRepo,
    [string] $refPrefix
)

."$PSScriptRoot/GetTemporaryGitReferenceClone.ps1"

pushd $downstreamRepo
try {
    
    [string] $directory = Get-TemporaryGitReferenceClone -source .

    Write-Information "Using temporary clone in `"$directory`"."
    pushd $directory
    try {
        [string[]] $sourceRefPairs = git show-ref
        
        [string] $temporaryGitRemoteName = "backup"
        git remote add "$temporaryGitRemoteName" "$upstreamRepo"

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

                    git update-ref "$targetRefName" "$sourceRefName"
                }
                "tag" {
                    [string] $targetTagName = $refPrefix + $sourceRefName.Substring("refs/tags/".Length)
                    $targetRefName = "refs/tags/" + $targetTagName

                    git update-ref "$targetRefName" "$sourceRefName"
                }
                default {
                    Write-Error "Unexpected ref type: " + $refType
                }
            }
        }

        foreach($sourceRefPair in $sourceRefPairs) {
            [string] $sourceRefName = $sourceRefPair.Split(" ")[1]
            git update-ref -d "$sourceRefName"
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
