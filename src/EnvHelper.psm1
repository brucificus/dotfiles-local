function Measure-EnvVarChanges([ScriptBlock] $inner) {
    [Hashtable] $before = @{}
    Get-ChildItem Env:\ | %{ $orig[$_.Name] = $_.Value }

    &$inner

    [Hashtable] $after = @{}
    Get-ChildItem Env:\ | %{ $after[$_.Name] = $_.Value }

    return ($orig.Keys + $after.Keys) `
            | Select-Object -Unique `
            | %{ New-Object PSCustomObject -Property @{key = $_; before=$orig[$_]; after=$after[$_]}} `
            | ?{$_.before -ne $_.after}
}


Export-ModuleMember -Function *