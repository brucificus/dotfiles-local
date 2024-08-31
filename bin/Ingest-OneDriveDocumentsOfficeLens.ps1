#!/usr/bin/env pwsh

#
# Ingest-OneDriveDocumentsOfficeLens
#
param(
    [Parameter()]
    [switch] $DelayExit
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[int] $exitDelayed = 0
function Start-ExitTimer([int] $seconds) {
    if (-not $DelayExit) {
        return
    }
    [int] $delayRemainingSeconds = [Math]::Max($seconds - $script:exitDelayed, 0)
    if (($seconds -gt 0) -and ($delayRemainingSeconds -gt 0)) {
        Write-Host "[Exiting in $delayRemainingSeconds second(s)…]"
        Start-Sleep -Seconds $delayRemainingSeconds
        $script:exitDelayed += $delayRemainingSeconds
    }
}
trap {
    if ($DelayExit) {
        Start-ExitTimer -seconds $errorExitDelaySeconds
        break
    }
}
[int] $errorExitDelaySeconds = 10
[int] $exitDelaySeconds = $errorExitDelaySeconds
function Write-TerminatingError([string] $message, [object] $targetObject = $null) {
    $errorRecord = [System.Management.Automation.ErrorRecord]::new(
        [System.Exception]::new($message),
        'Dotfiles-IngestionError',
        'OperationStopped',
        $targetObject
    )
    if ($DelayExit) {
        Write-Error $errorRecord -ErrorAction 'Continue'
        trap {
            Start-ExitTimer -seconds $errorExitDelaySeconds
            break
        }
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    } else {
        Write-Error $errorRecord
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }
}

if (-not $IsWindows) {
    Write-TerminatingError '🪟 This script is only supported on Windows.' (Get-Variable -Name IsWindows)
}

[System.IO.DirectoryInfo] $onedriveDir = [System.IO.DirectoryInfo]::new("$env:USERPROFILE\OneDrive")
if (-not $onedriveDir.Exists) {
    Write-TerminatingError "❓ The OneDrive directory '$($onedriveDir.FullName)' does not exist." $onedriveDir
}

[System.IO.DirectoryInfo] $sourceDir = Get-Item (Join-Path $onedriveDir.FullName "Documents\Office Lens")
if (-not $sourceDir.Exists) {
    Write-TerminatingError "❓ The source directory '$($sourceDir.FullName)' does not exist." $sourceDir
}

[System.IO.DirectoryInfo] $destinationDirRoot = Get-Item (Join-Path $onedriveDir.FullName "Personal\Notes\Areas\Inbox\OfficeLens")
if (-not $destinationDirRoot.Exists) {
    Write-TerminatingError "❓ The destination directory '$($destinationDirRoot.FullName)' does not exist." $destinationDirRoot
}

[System.Collections.Generic.List[System.IO.FileInfo]] $sourceFiles = Get-ChildItem -Path $sourceDir.FullName -File -Recurse -Force -ErrorAction 'SilentlyContinue'
if (-not $sourceFiles) {
    Write-Host "📁 No files found in the source directory '$($sourceDir.FullName)'."
    Start-ExitTimer -seconds 5
    return
}

# Create a list of move operations as tuples of:
#   sourceFile, destinationDir, destinationFileName
[Tuple[System.IO.FileInfo, System.IO.DirectoryInfo, string][]] $moveOperations = @()
Push-Location $sourceDir.FullName
try {
    foreach ($sourceFile in $sourceFiles) {
        [string] $sourceFileParentDirRelativePath = ''
        if ($sourceFile.Directory.FullName -ne $sourceDir.FullName) {
            $sourceFileParentDirRelativePath = Resolve-Path $sourceFile.Directory.FullName -Relative
        }
        [System.IO.DirectoryInfo] $destinationDir = [System.IO.DirectoryInfo]::new((Join-Path $destinationDirRoot.FullName $sourceFileParentDirRelativePath))

        function Format-FileBaseName {
            param(
                [System.IO.FileInfo] $file
            )
            [string] $fileBaseName = $file.BaseName

            # Collapse whitespace
            $fileBaseName = $fileBaseName -replace '\s+', ' '

            # Find timestamp in the format 'YYYY_MM_DD HH_mm AM' and replace with 'YYYYMMDDHHmm' (24-hour time).
            [string] $dateComponentSeparatorPattern = '[-_./]'
            [string] $timeComponentSeperatorPattern = '[_:]'
            [string] $timestampPattern = "(\d{4})$dateComponentSeparatorPattern(\d{1,2})$dateComponentSeparatorPattern(\d{1,2})\s+(\d{1,2})$timeComponentSeperatorPattern(\d{2})\s+(AM|PM)"
            $timestampMatch = $fileBaseName -match $timestampPattern
            if ($timestampMatch) {
                [string] $year = $matches[1]
                [string] $month = $matches[2].PadLeft(2, '0')
                [string] $day = $matches[3].PadLeft(2, '0')
                [int] $hour = $matches[4] -as [int]
                [string] $minute = $matches[5]
                [string] $amPm = $matches[6]
                if ($amPm -eq 'PM') {
                    $hour = [int] $hour + 12
                }
                [string] $hourStr = $hour.ToString().PadLeft(2, '0')
                $newTimestampInfix = "${year}${month}${day}${hourStr}${minute}"
                $fileBaseName = $fileBaseName -replace $timestampPattern, $newTimestampInfix
            }

            # Do a sentinel compactification of 'Office Lens' to 'OfficeLens' in the filename.
            $fileBaseName = $fileBaseName -replace 'Office Lens', 'OfficeLens'

            return $fileBaseName
        }

        [string] $destinationFileName = (Format-FileBaseName -file $sourceFile) + $sourceFile.Extension
        $moveOperations += @([Tuple]::Create($sourceFile, $destinationDir, $destinationFileName))
    }
} finally {
    Pop-Location
}

# Execute the move operations from the common base folder of the source and destination.
Write-Host "📂 Found $($moveOperations.Count) file(s) to ingest from the source directory."
if ($moveOperations.Count -gt 0) {
Push-Location $onedriveDir.FullName
try {
    foreach ($moveOperation in $moveOperations) {
        [System.IO.FileInfo] $sourceFile = $moveOperation.Item1
        [System.IO.DirectoryInfo] $destinationDir = $moveOperation.Item2
        [string] $destinationFileName = $moveOperation.Item3

        if (-not $destinationDir.Exists) {
            Write-Host "✨ Creating destination directory '$($destinationDir.FullName)'…"
            $null = $destinationDir.Create()
        }

        [string] $sourceFileRelativePath = Resolve-Path $sourceFile.FullName -Relative
        [string] $destinationDirRelativePath = Resolve-Path $destinationDir.FullName -Relative
        [string] $destinationFileRelativePath = Join-Path $destinationDirRelativePath $destinationFileName

        [System.IO.FileInfo] $destinationFile = [System.IO.FileInfo]::new((Join-Path $destinationDir.FullName $destinationFileName))
        if ($destinationFile.Exists) {
            Write-Host "⚠️ Destination file '$($destinationFile.FullName)' already exists. Skipping…"
            continue
        }

        Write-Information "🚚 Moving & renaming file '$($sourceFileRelativePath)' to '$($destinationFileRelativePath)'…"
        Move-Item -LiteralPath $sourceFileRelativePath -Destination $destinationFileRelativePath
        Write-Host "📄 Moved & renamed file '$($sourceFileRelativePath)' to '$($destinationFileRelativePath)'."
    }
} finally {
    Pop-Location
}
}

Start-ExitTimer -seconds $exitDelaySeconds
