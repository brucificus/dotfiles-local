Import-Module "$PSScriptRoot\Chocolatey.psm1" -DisableNameChecking

Ensure-ChocolateyPackageInstallation "vagrant"
Ensure-ChocolateyPackageInstallation "minikube"

[string] $vagrantExecutable = (Get-Command vagrant).Source
[string] $minikubeExecutable = (Get-Command minikube).Source

[bool] $thisProcessElevated = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

Enum HypervisorMode {
    HyperV
    VirtualBox
}

[System.Lazy[HypervisorMode]] $script:lazyHypervisorMode = $null
[bool] $script:minikubeFirstTimeConfigured = $false


function Set-MinikubeDriverToHyperv()
{
    # This takes at least 0.5 seconds on my machine  -BM 2018-02-13
    &$minikubeExecutable config set vm-driver hyperv | Out-Null
}

function Set-MinikubeDriverToVirtualbox()
{
    # This takes at least 0.5 seconds on my machine  -BM 2018-02-13
    &$minikubeExecutable config set vm-driver virtualbox | Out-Null
}

function Get-HypervExternalSwitchName
{
    if ($script:lazyHypervisorMode.Value -ne [HypervisorMode]::HyperV) {
        throw "Hyper-V is unavailable"
    }

    return ((Get-VMSwitch) | ?{$_.SwitchType -eq "External"} | Select-Object -First 1).Name
}

function Execute-FirstTimeMinikubeConfiguration()
{
    if ($script:minikubeFirstTimeConfigured -eq $false) {
        switch ($script:lazyHypervisorMode.Value) {
            ([HypervisorMode]::HyperV) {
                Set-MinikubeDriverToHyperv
            }
            ([HypervisorMode]::VirtualBox) {
                Set-MinikubeDriverToVirtualbox
            }
            default {
                throw "Unrecognized hypervisor mode while first-time configuring minikube for session."
            }
        }

        $script:minikubeFirstTimeConfigured = $true
    }
}

function Get-FirstTimeHypervisorModeDetectionAndConfiguration()
{
    [string] $hypervEnabled = (Get-CimInstance Win32_ComputerSystem).HypervisorPresent

    if ($hypervEnabled) {
        $env:VAGRANT_DEFAULT_PROVIDER = "hyperv"
        return [HypervisorMode]::HyperV;
    } else {
        $env:VAGRANT_DEFAULT_PROVIDER = "virtualbox"
        return [HypervisorMode]::VirtualBox;
    }
}

function minikube()
{
    if ($script:lazyHypervisorMode.Value -eq $null) {
        Write-Error "Minikube unavailable because Powershell profile could not determine hypervisor mode."
        return
    }

    Execute-FirstTimeMinikubeConfiguration

    [string[]] $newParams = $args
    [bool] $subcommandNeedsHypervisorSpecification = $args -contains "start"

    if ($subcommandNeedsHypervisorSpecification) {
        switch ($script:lazyHypervisorMode.Value) {
            ([HypervisorMode]::HyperV) {
                [string] $hypervExternalSwitchName = Get-HypervExternalSwitchName
                $newParams = $newParams + @("--hyperv-virtual-switch=$hypervExternalSwitchName")
            }
            ([HypervisorMode]::VirtualBox) {
            }
            default {
                throw "Unrecognized hypervisor mode"
            }
        }
    }

    &$minikubeExecutable @newParams
}


$script:lazyHypervisorMode = New-Object Lazy[HypervisorMode] ([System.Func[HypervisorMode]] { return Get-FirstTimeHypervisorModeDetectionAndConfiguration; })

Set-Alias -Name "mk" -Value "minikube"
Set-Alias -Name "k" -Value "kubectl"


Export-ModuleMember -Function "Get-HypervExternalSwitchName" -Alias *
