# Very loosely based on: https://raw.githubusercontent.com/dfinke/InstallModuleFromGitHub/7c633865c575d4762b2e49f15620020245f36d46/InstallModuleFromGitHub.psm1
function Use-GitHubZipBall {
    [CmdletBinding()]
    param(
        [string] $GitHubRepo,
        [string] $Branch = "master",
        [string] $SSOToken,
        [ScriptBlock] $action
    )

    Process {   
        if($GitHubRepo) {   
            [string] $url = "https://api.github.com/repos/{0}/zipball/{1}" -f $GitHubRepo, $Branch
            [string] $tmpDir = [System.IO.Path]::GetTempPath()
            [string] $OutFile = "{0}_{1}.zip" -f $($GitHubRepo.Replace("/", "_")), $Branch
            $OutFile = Join-Path -Path $tmpDir -ChildPath $OutFile

            if (-not (Test-Path $OutFile -ErrorAction SilentlyContinue)) {
                if ($SSOToken) {
                    $headers = @{"Authorization" = "token $SSOToken" }
                }
    
                #enable TLS1.2 encryption
                if (-not ($IsLinux -or $IsOSX)) {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                }
    
                Invoke-RestMethod $url -OutFile $OutFile -Headers $headers
            }

            if (-not ($IsLinux -or $IsOSX)) {
                Unblock-File $OutFile
            }

            [string] $fileHash = $(Get-FileHash -Path $OutFile).hash
            $tmpDir = "$tmpDir/$fileHash"

            Expand-Archive -Path $OutFile -DestinationPath $tmpDir -Force

            pushd $tmpDir
            pushd (dir)[0]
            try {
                Invoke-Command $action
            } finally {
                popd
                popd
                rmdir $tmpDir -Recurse -Force
            }
        }
    }
}


Export-ModuleMember -Function "Use-GitHubZipBall"
