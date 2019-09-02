function Ensure-ChocolateyInstallation() {
    if (-not (Get-Command choco -ErrorAction "SilentlyContinue")) {
        Write-Verbose "Chocolatey NOT FOUND"
        Import-Module "$PSScriptRoot\Windows.psm1" -DisableNameChecking

        if (-not (Test-Elevation)) {
            Write-Error "Chocolatey is required but not installed, and an elevated shell is required to install it."
        } else {
            Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
    } else {
        Write-Verbose "Chocolatey FOUND"
    }
}

function Get-ChocolateyPackageInstallation() {
    Ensure-ChocolateyInstallation
    
    [hashtable] $results = @{}
    
    [string[]] $rawText = (choco list all --local-only --limit-output)
    $rawText | ForEach-Object {
        [string[]] $splitPair = $_.Split("|")
        $packageName = $splitPair[0]
        $packageVersion = $splitPair[1]
        $results += @{ "$packageName" = $packageVersion  }
    }

    return $results
}

function Test-ChocolateyPackageInstallation([string] $packageName) {
    Ensure-ChocolateyInstallation

    if (-not (Test-Path "$Env:ProgramData\chocolatey\lib\$packageName" -ErrorAction "SilentlyContinue")) {
        $installedPackages = Get-ChocolateyPackageInstallation
        if (-not ($installedPackages[$packageName])) {
            Write-Verbose "Chocolatey package `"$packageName`" installation NOT FOUND"
            return $false
        } else {
            Write-Verbose "Chocolatey package `"$packageName`" installation FOUND"
            return $true
        }
    } else {
        Write-Verbose "Chocolatey package `"$packageName`" installation FOUND"
        return $true
    }
}

function Ensure-ChocolateyPackageInstallation([string] $packageName) {
    Ensure-ChocolateyInstallation

    if (-not (Test-ChocolateyPackageInstallation $packageName)) {
        Import-Module "$PSScriptRoot\Windows.psm1" -DisableNameChecking
        if (-not (Test-Elevation)) {
            Write-Error "Chocolatey package `"$packageName`" is required but not installed, and an elevated shell is required to install it."
        } else {
            Write-Verbose "Installing Chocolatey package `"$packageName`""
            choco install $packageName -y
        }
    }
}


Export-ModuleMember -Function "Ensure-ChocolateyInstallation","Get-ChocolateyPackageInstallation","Test-ChocolateyPackageInstallation","Ensure-ChocolateyPackageInstallation"
