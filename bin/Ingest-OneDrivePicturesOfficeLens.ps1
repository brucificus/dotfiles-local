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

[System.IO.DirectoryInfo] $sourceDir = Get-Item (Join-Path $onedriveDir.FullName "Pictures\Office Lens")
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

            # Remove a trailing period if there is one. (They happen rarely.)
            $fileBaseName = $fileBaseName -replace '\.+$', ''

            function Get-FilenameEmbeddedTimestamp {
                # timestampPattern, timestampParsed, timestampRenormalized
                [PSObject[]] $timestampsFoundByPattern = @()

                #
                # Formats "2019_01_18 11_29 AM Office Lens" and "2019_01_18 11_29_59 AM Office Lens"
                #        (YYYY_MM_DD HH_mm ?M)              and (YYYY_MM_DD HH_mm_ss ?M)
                #
                try {
                    [string] $dateComponentSeparatorPattern = '[-_./]'
                    [string] $dateTimeSeparatorPattern = '[_\s]?'
                    [string] $timeComponentSeperatorPattern = '[_:]?'
                    [string] $timestampPattern = "^(\d{4})$dateComponentSeparatorPattern(\d{2})$dateComponentSeparatorPattern(\d{2})$dateTimeSeparatorPattern(\d{1,2})$timeComponentSeperatorPattern(\d{2})($timeComponentSeperatorPattern(\d{2}))?\s+(AM|PM)"
                    if ($fileBaseName -match $timestampPattern) {
                        [int] $year = $matches[1] -as [int]
                        [int] $month = $matches[2] -as [int]
                        [int] $day = $matches[3] -as [int]
                        [int] $hour = $matches[4] -as [int]
                        [int] $minute = $matches[5] -as [int]
                        [int] $seconds = 0
                        if ($matches[7]) {
                            $seconds = $matches[7] -as [int]
                        }
                        [string] $amPm = $matches[8]
                        if ($amPm -eq 'PM' -and $hour -lt 12) {
                            $hour = $hour + 12
                        }
                        [DateTimeOffset] $timestampParsed = [DateTimeOffset]::new($year, $month, $day, $hour, $minute, $seconds, 0, 0, [TimeSpan]::Zero)
                        [string] $timestampRenormalized = $timestampParsed.ToString('yyyyMMddHHmm')
                        # TODO: Debug that this `if` condition works.
                        if ($matches[7]) {
                            $timestampRenormalized += $timestampParsed.Second.ToString().PadLeft(2, '0')
                        }
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $timestampParsed;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }


                #
                # Formats "01_18_19 11_29 AM Office Lens" and "01_18_19 11_29_59 AM Office Lens"
                #        (MM_DD_YY HH_mm ?M)              and (MM_DD_YY HH_mm_ss ?M)
                #
                try {
                    [string] $dateComponentSeparatorPattern = '[-_./]'
                    [string] $dateTimeSeparatorPattern = '[_\s]?'
                    [string] $timeComponentSeperatorPattern = '[_:]?'
                    [string] $timestampPattern = "(\b[01]?\d)$dateComponentSeparatorPattern([0123]?\d)$dateComponentSeparatorPattern(\d{2,4})$dateTimeSeparatorPattern([012]?\d)$timeComponentSeperatorPattern([0-5]\d)($timeComponentSeperatorPattern([0-5]\d))?\s+(AM|PM)"
                    if ($fileBaseName -match $timestampPattern) {
                        [int] $month = $matches[1] -as [int]
                        [int] $day = $matches[2] -as [int]
                        [int] $year = $matches[3] -as [int]
                        [int] $hour = $matches[4] -as [int]
                        [int] $minute = $matches[5] -as [int]
                        [int] $seconds = 0
                        if ($matches[7]) {
                            $seconds = $matches[7] -as [int]
                        }
                        [string] $amPm = $matches[8]
                        if ($amPm -eq 'PM' -and $hour -lt 12) {
                            $hour = $hour + 12
                        }
                        [DateTimeOffset] $timestampParsed = [DateTimeOffset]::new($year, $month, $day, $hour, $minute, $seconds, 0, 0, [TimeSpan]::Zero)
                        [string] $timestampRenormalized = $timestampParsed.ToString('yyyyMMddHHmm')
                        # TODO: Debug that this `if` condition works.
                        if ($matches[7]) {
                            $timestampRenormalized += $timestampParsed.Second.ToString().PadLeft(2, '0')
                        }
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $timestampParsed;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }

                #
                # Formats "20190110_072234" and "Screenshot_20180812-093053_Microsoft Launcher"
                #         (YYYYMMDD_HHmmss)               (_YYYYMMDD-HHmmss)
                #
                try {
                    [string] $separatorPattern = '[-_\s]'
                    [string] $timestampPattern = "${separatorPattern}*([12][09]\d\d)([01]\d)([0123]\d)${separatorPattern}([012]\d)([0-5]\d)([0-5]\d)${separatorPattern}*"
                    if ($fileBaseName -match $timestampPattern) {
                        [int] $year = $matches[1] -as [int]
                        [int] $month = $matches[2] -as [int]
                        [int] $day = $matches[3] -as [int]
                        [int] $hour = $matches[4] -as [int]
                        [int] $minute = $matches[5] -as [int]
                        [int] $seconds = $matches[6] -as [int]
                        [DateTimeOffset] $timestampParsed = [DateTimeOffset]::new($year, $month, $day, $hour, $minute, $seconds, 0, 0, [TimeSpan]::Zero)
                        [string] $timestampRenormalized = $timestampParsed.ToString('yyyyMMddHHmmss')
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $timestampParsed;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }

                #
                # Format "authenticator_screenshot_2017_47_27_12_47_31"
                #                                 (YYYY_XX_XX_HH_mm_ss)
                #
                try {
                    [string] $separatorPattern = '[-_\b]'
                    [string] $timestampPattern = "${separatorPattern}?(\d{4})${separatorPattern}(\d{2})${separatorPattern}(\d{2})${separatorPattern}(\d{2})${separatorPattern}(\d{2})${separatorPattern}(\d{2})"
                    if ($fileBaseName -match $timestampPattern) {
                        [int] $year = $matches[1] -as [int]
                        [int] $match2 = $matches[2] -as [int]
                        [int] $match3 = $matches[3] -as [int]
                        [int] $hour = $matches[4] -as [int]
                        [int] $minute = $matches[5] -as [int]
                        [int] $seconds = $matches[6] -as [int]
                        # [DateTimeOffset] $timestampParsed = [DateTimeOffset]::new($year, $month, $day, $hour, $minute, $seconds, 0, 0, [TimeSpan]::Zero)
                        [string] $hourStr = $hour.ToString().PadLeft(2, '0')
                        [string] $minuteStr = $minute.ToString().PadLeft(2, '0')
                        [string] $secondsStr = $seconds.ToString().PadLeft(2, '0')
                        [string] $timestampRenormalized = "${year}MMdd${hourStr}${minuteStr}${secondsStr}"
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $null;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }

                #
                # Formats "FB_IMG_1599610708766" and "1599610708766"
                #                 ^ unix timestamp **with milliseconds**
                #
                try {
                    [string] $separatorPattern = '[-_\b]'
                    [string] $timestampPattern = "${separatorPattern}*(\d{13})${separatorPattern}*"
                    if ($fileBaseName -match $timestampPattern) {
                        [long] $unixTimestampMs = $matches[1] -as [long]
                        [DateTimeOffset] $timestampParsed = [DateTimeOffset]::FromUnixTimeMilliseconds($unixTimestampMs)
                        $timestampParsed = $timestampParsed.ToLocalTime()
                        [string] $timestampRenormalized = $timestampParsed.ToString('yyyyMMddHHmmss') + "." + $timestampParsed.Millisecond.ToString().PadLeft(3, '0')
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $timestampParsed;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }

                #
                # Format "Snapchat-1080506636"
                #                  ^ unix timestamp _without_ milliseconds
                #
                try {
                    [string] $separatorPattern = '[-_\b]'
                    [string] $timestampPattern = "${separatorPattern}(\d{10})"
                    if ($fileBaseName -match $timestampPattern) {
                        [long] $unixTimestamp = $matches[1] -as [long]
                        [DateTimeOffset] $timestampParsed = [DateTimeOffset]::FromUnixTimeSeconds($unixTimestamp)
                        $timestampParsed = $timestampParsed.ToLocalTime()
                        [string] $timestampRenormalized = $timestampParsed.ToString('yyyyMMddHHmmss')
                        $timestampsFoundByPattern += @([PSCustomObject]@{
                            timestampPattern = $timestampPattern;
                            # timestampParsed = $timestampParsed;
                            timestampRenormalized = $timestampRenormalized;
                        })
                    }
                } catch {
                    Write-Warning "⚠️ Error parsing embedded timestamp in filename '$($fileBaseName)': $_"
                }
                return $timestampsFoundByPattern
            }

            # Collect any extra suffices in the filename, we'll add them back at the end.
            [string[]] $fileBaseNameExtraSuffices = @()
            if ($fileBaseName -match '(\.[\w]{2,4})+$') {
                $fileBaseNameExtraSuffices = $matches[0]
                $fileBaseName = $fileBaseName -replace '(\.[\w]{2,4})+$', ''
            }

            # If we have the word "screenshot" embedded in the filename, let's shuffle it to a place that will leave it near the front of the new filename.
            [string] $separatorPattern = '[-_\s]'
            [string] $screenshotTextPattern = "${separatorPattern}*[Ss]creen(shot)?${separatorPattern}*"
            if ($fileBaseName -match $screenshotTextPattern) {
                $fileBaseName = $fileBaseName -replace $screenshotTextPattern, ""
                $fileBaseName = "Screenshot - $fileBaseName"
            }

            # If we have a timestamp embedded in the filename, let's shuffle it to the *very* front of the new filename.
            [PSObject[]] $timestampsFoundByPattern = Get-FilenameEmbeddedTimestamp
            if ($timestampsFoundByPattern) {
                [string] $timestampPattern = $timestampsFoundByPattern[0].timestampPattern
                # [Nullable[DateTimeOffset]] $timestampParsed = $timestampsFoundByPattern[0].timestampParsed
                [string] $timestampRenormalized = $timestampsFoundByPattern[0].timestampRenormalized
                $fileBaseName = $fileBaseName -replace $timestampPattern, ""
                if ($fileBaseName -match '^\w') {
                    $fileBaseName = $timestampRenormalized + " " + $fileBaseName
                } else {
                    $fileBaseName = $timestampRenormalized + $fileBaseName
                }
            }

            # Shuffle the word "screenshot" around again, in case the separators were removed by the timestamp shuffle.
            [string] $separatorPattern = '[-_\s]'
            [string] $screenshotTextPattern = "[Ss]creen(shot)?${separatorPattern}*"
            if ($fileBaseName -match $screenshotTextPattern) {
                $fileBaseName = $fileBaseName -replace $screenshotTextPattern, "Screenshot - "
            }

            # Clean up some other keywords that get cluttered in the filename.
            $fileBaseName = $fileBaseName -replace '_resized', '(resized)'

            # Do a sentinel compactification of 'Office Lens' to 'OfficeLens' in the filename.
            $fileBaseName = $fileBaseName -replace 'Office Lens', 'OfficeLens'
            $fileBaseName = $fileBaseName.Trim()

            # Remove any weird separators still at the end of the filename before the extension(s).
            $fileBaseName = $fileBaseName -replace '[-_\s\.]+$', ''

            # Add the extra suffices back to the filename.
            if ($fileBaseNameExtraSuffices) {
                $fileBaseName += $fileBaseNameExtraSuffices
            }

            return $fileBaseName
        }

        [string] $destinationFileName = (Format-FileBaseName -file $sourceFile) + $sourceFile.Extension
        $moveOperations += @([Tuple]::Create($sourceFile, $destinationDir, $destinationFileName))
    }
} finally {
    Pop-Location
}

# Remove ops that don't rename, b/c they didn't have timestamps we could use.
$moveOperations = $moveOperations | Where-Object { $_.Item1.Name -ne $_.Item3 }

# Execute the move operations from the common base folder of the source and destination.
Write-Host "📂 Found $($moveOperations.Count) file(s) to ingest from the source directory."

if ($moveOperations) {
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
