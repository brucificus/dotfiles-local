# Taken and modified from: https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/8d3d148aba5e18ad325d5a856e5a3fae55b5b2f0/Themes/Agnoster.psm1
#requires -Version 2 -Modules posh-git
#requires -Version 2 -Modules PANSIES

function Write-Segment {
    param(
        $content,
        $foregroundColor,
        $backgroundColor = $null
    )

    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentBackwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
    if ($backgroundColor) {
        $prompt += Write-Prompt -Object $content -ForegroundColor $foregroundColor -BackgroundColor $backgroundColor
    } else {
        $prompt += Write-Prompt -Object $content -ForegroundColor $foregroundColor
    }
    
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.PromptSymbolColor
    
    return $prompt
}

function Write-GitSegment {
    param(
        $vcsInfo
    )

    $prompt += Write-Prompt -Object $sl.PromptSymbols.GitSegmentBackwardSymbol -ForegroundColor $vcsInfo.BackgroundColor
    $prompt += Write-Prompt -Object $vcsInfo.VcInfo -ForegroundColor $sl.Colors.GitForegroundColor -BackgroundColor $vcsInfo.BackgroundColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.GitSegmentForwardSymbol) " -ForegroundColor $vcsInfo.BackgroundColor

    return $prompt
}

function Write-FirstLine {
    param(
        $lastCommandFailed
    )

    $boxDrawingsLightDownAndRight = [char]::ConvertFromUtf32(0x250C) # '┌'
    $prompt = Write-Prompt -Object $boxDrawingsLightDownAndRight -ForegroundColor $sl.Colors.PromptSymbolColor

    $user = $sl.CurrentUser
    $prompt += Write-Segment -content $user -foregroundColor $sl.Colors.PromptForegroundColor

    $status = Get-VCSStatus
    if ($status) {
        $vcsInfo = Get-VcsInfo -status ($status)
        $prompt += Write-GitSegment $vcsInfo
    }

    #python virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Segment -content "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -foregroundColor $sl.Colors.VirtualEnvForegroundColor
    }

    #check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Segment -content $sl.PromptSymbols.ElevatedSymbol -foregroundColor $sl.Colors.AdminIconForegroundColor
    }

    #check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Segment -content $sl.PromptSymbols.FailedCommandSymbol -foregroundColor $sl.Colors.CommandFailedIconForegroundColor
    }

    $prompt += ''

    return $prompt
}

function Write-SecondLine {
    param(
        $with
    )

    $boxDrawingsLightUpAndRight = [char]::ConvertFromUtf32(0x2514) # '└'
    $prompt += Write-Prompt -Object $boxDrawingsLightUpAndRight -ForegroundColor $sl.Colors.PromptSymbolColor
    
    $path += Get-ShortPath -dir $pwd
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentBackwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object $path -ForegroundColor $sl.Colors.PromptForegroundColor

    #python virtualenv
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName)" -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
        $prompt += Write-Prompt -Object "$($with.ToUpper())" -ForegroundColor $sl.Colors.WithForegroundColor -BackgroundColor 
    }

    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
    
    return $prompt
}

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $prompt += Write-FirstLine $lastCommandFailed
    $prompt += Set-Newline
    $prompt += Write-SecondLine $with
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.PromptIndicator) " -ForegroundColor $sl.Colors.PromptSymbolColor
    
    return $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.PromptSymbols.TruncatedFolderSymbol = '…'
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0xf071) # '' (nf-fa-exclamation_triangle)
$sl.PromptSymbols.SegmentForwardSymbol = ']'
$sl.PromptSymbols.SegmentBackwardSymbol = '['
$sl.PromptSymbols.GitSegmentForwardSymbol = [char]::ConvertFromUtf32(0xe0b0) # '' (nf-pl-left_hard_divider)
$sl.PromptSymbols.GitSegmentBackwardSymbol = [char]::ConvertFromUtf32(0xe0b2) # '' (nf-pl-right_hard_divider)
$sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0xf982) # '廬' (nf-mdi-security)
$sl.PromptSymbols.HomeSymbol = [char]::ConvertFromUtf32(0xf7db) # '' (nf-mdi-home)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0xf054) # '' (nf-fa-chevron_right)
$sl.Colors.PromptForegroundColor = [ConsoleColor]::DarkGreen
$sl.Colors.PromptSymbolColor = [ConsoleColor]::DarkBlue
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.GitForegroundColor = [ConsoleColor]::Black
$sl.Colors.WithForegroundColor = [ConsoleColor]::White
$sl.Colors.WithBackgroundColor = [ConsoleColor]::DarkRed
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White
