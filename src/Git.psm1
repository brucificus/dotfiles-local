#Requires -Modules @{ ModuleName = "posh-git"; ModuleVersion = "0.7.3" }

$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *
