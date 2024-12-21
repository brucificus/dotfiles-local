#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ModuleName="poshy-env-var";ModuleVersion="0.6.1"}


# Unlike the [da|ba]sh version of this script, we don't declare an ldfu
# here because it's defined elsewhere in the upstream `dotfiles` PowerShell stack.

# We *do* declare DOTFILES_LOCAL *here* because it's not (authoritatively) defined
# in the upstream `dotfiles` PowerShell stack.
Set-EnvVar -Process -Name "DOTFILES_LOCAL" -Value "~/.dotfiles_local" -SkipOverwrite
