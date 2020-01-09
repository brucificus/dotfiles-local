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

    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation "♻🖇🔤 Renames Original File to Destination for History-Preserving File Split"
    git mv $source $destination
    git commit -m "♻🖇🔤 Renames Original File to Destination for History-Preserving File Split"
    
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation "♻🖇📎 Sidelines Original File for History-Preserving File Split"
    $saved = $(git rev-parse HEAD)
    git reset --hard HEAD^
    git mv $source "$source-copy"
    git commit -m "♻🖇📎 Sidelines Original File for History-Preserving File Split"
    
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation "♻🖇🔀 Merges Divergent Commits for History-Preserving File Split"
    git merge $saved     # This will generate conflicts
    git commit -a -m "♻🖇🔀 Merges Divergent Commits for History-Preserving File Split"        # Trivially resolve conflicts like this
    
    Write-Progress -Activity "Splitting Git History of File" -CurrentOperation "♻🖇◀ Restores Original File from History-Preserving File Split"
    git mv "$source-copy" $source
    git commit -m "♻🖇◀ Restores Original File from History-Preserving File Split"

    Write-Progress -Activity "Splitting Git History of File" -Completed
}


Export-ModuleMember -Function "Split-GitHistory"
