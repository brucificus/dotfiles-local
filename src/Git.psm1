Import-Module posh-git
$GitPromptSettings.DefaultPromptPrefix = '[$(hostname)] '
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

function tgit([Parameter(Mandatory = $true)] [ValidateNotNullOrEmpty()] [string] $command) {
	TortoiseGitProc.exe /command:$command
}


Export-ModuleMember -Function * -Cmdlet * -Variable * -Alias *