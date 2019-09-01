function Enable-FusionLogging {
    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Fusion").EnableLog -eq 1) {
        Write-Error "Fusion EnableLog already set"
        break;
    }
  
    [string] $keyPath = "HKLM:\SOFTWARE\Microsoft\Fusion\"
    [string] $fusionLogPath = "C:\FusionLog\"
    New-ItemProperty -Path $keyPath -Name "EnableLog" -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "ForceLog" -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "LogFailures" -PropertyType DWORD -Value 1 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "LogResourceBinds" -PropertyType DWORD -Value 1 -Force | Out-Null
    if (-not (Test-Path $fusionLogPath)) {
        mkdir $fusionLogPath
    }
    New-ItemProperty -Path $keyPath -Name "LogPath" -PropertyType String -Value $fusionLogPath -Force | Out-Null
}

function Show-FusionLog {
    &"C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.7 Tools\fuslogvw.exe"
}

function Get-FusionLogItems {
    [string] $fusionLogPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Fusion").LogPath
    foreach ($categoryFolder in (Get-ChildItem -Path $fusionLogPath)) {
        [string] $categoryName = $categoryFolder.Name
        foreach ($applicationFolder in (Get-ChildItem $categoryFolder.FullName)) {
            [string] $applicationName = $applicationFolder.Name
            foreach ($logFile in (Get-ChildItem $applicationFolder.FullName)) {
                [string] $description = [System.IO.Path]::GetFileNameWithoutExtension($logFile.Name)
                New-Object PSObject -Property @{"category" = $categoryName; "application" = $applicationName; "description" = $description; "logFilePath" = $logFile.FullName }
            }
        }
    }
}

function Disable-FusionLogging {
    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Fusion").EnableLog -ne 1) {
        Write-Error "Fusion EnableLog not set"
        break;
    }

    [string] $keyPath = "HKLM:\SOFTWARE\Microsoft\Fusion\"
    New-ItemProperty -Path $keyPath -Name "LogResourceBinds" -PropertyType DWORD -Value 0 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "LogFailures" -PropertyType DWORD -Value 0 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "ForceLog" -PropertyType DWORD -Value 0 -Force | Out-Null
    New-ItemProperty -Path $keyPath -Name "EnableLog" -PropertyType DWORD -Value 0 -Force | Out-Null
}


Export-ModuleMember -Function * -Cmdlet *
