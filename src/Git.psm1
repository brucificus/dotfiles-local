# Adapted from: https://stackoverflow.com/a/44036771/12553250
function Split-GitHistory {
    [CmdletBinding()]  
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateScript({Test-Path $_ })]
        [string] $source,

        [Parameter(Position = 1, Mandatory = $true)]
        [string] $destination
    )
    $ErrorActionPreference = "Stop"

    [string] $currentOperation
    
    $currentOperation = "♻🖇🔤 Renames Original File to Destination for History-Preserving File Split"
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation $currentOperation
    git mv $source $destination
    git commit -m $currentOperation
    
    $currentOperation = "♻🖇📎 Sidelines Original File for History-Preserving File Split"
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation $currentOperation
    $saved = $(git rev-parse HEAD)
    git reset --hard HEAD^
    git mv $source "$source-copy"
    git commit -m $currentOperation
    
    $currentOperation = "♻🖇🔀 Merges Divergent Commits for History-Preserving File Split"
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation $currentOperation
    git merge $saved                   # This will generate conflicts
    git commit -a -m $currentOperation # Trivially resolve conflicts like this
    
    $currentOperation = "♻🖇◀ Restores Original File from History-Preserving File Split"
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation $currentOperation
    git mv "$source-copy" $source
    git commit -m $currentOperation

    Write-Progress -Activity "Splitting Git History of File" -Completed
}


Export-ModuleMember -Function "Split-GitHistory"
