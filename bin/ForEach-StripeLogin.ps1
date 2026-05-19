#!/usr/bin/env pwsh

Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [scriptblock] $Process
)

Begin {
    $ErrorActionPreference = "Stop"
    Set-StrictMode -Version Latest

    if (-not (Test-Command "stripe")) {
        throw "stripe CLI is not installed or not in PATH."
    }

    function Get-StripeLoginList {
        $stripeLoginListOutput = [string[]](stripe login list)
        if ($stripeLoginListOutput[0] -notlike "*Available profiles:*") {
            throw "Unexpected output from 'stripe login list': $stripeLoginListOutput"
        }
        $stripeLoginListOutput = $stripeLoginListOutput[1..($stripeLoginListOutput.Length - 1)]
        foreach ($line in $stripeLoginListOutput) {
            if ($line.Trim() -eq "") {
                continue
            }
            # active line entry is prefixed with "* " and suffixed with " (active)".
            if ($line -match "\*\s+(.+)\s+\(active\)") {
                [PSCustomObject]@{
                    name = $matches[1];
                    active = $true;
                }
            } else {
                [PSCustomObject]@{
                    name = $line.Trim();
                    active = $false;
                }
            }
        }
    }
    $script:startingStripeLogins = [PSObject[]](Get-StripeLoginList)
    if ($script:startingStripeLogins.Count -eq 0) {
        throw "No stripe logins found. Please run 'stripe login' to add at least one login."
    }
}

Process {
    foreach ($stripeLogin in $script:startingStripeLogins) {
        stripe login switch $stripeLogin.name 2>&1 | Set-Variable -Name "stripeLoginOutput"
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to switch to stripe login '$($stripeLogin.name)'. Exit code: $LASTEXITCODE, Output: $stripeLoginOutput"
        }

        $Process.InvokeWithContext($null, [PSVariable]::new('_', $stripeLogin.name))
    }
}

End {
    # Switch back to the original stripe login.
    $targetStripeLogin = $script:startingStripeLogins | Where-Object { $_.active } | Select-Object -First 1
    if ($targetStripeLogin) {
        stripe login switch $targetStripeLogin.name | Out-Null
    }
}
