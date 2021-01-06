Param(
    [string] $path,
    [TimeSpan] $in
)

[DateTime] $at = [DateTime]::Now.Add($in)

[Microsoft.Management.Infrastructure.CimInstance] $taskAction = New-ScheduledTaskAction `
    -Execute "cmd" `
    -Argument "/C del /F `"$path`""

[Microsoft.Management.Infrastructure.CimInstance] $taskTrigger = New-ScheduledTaskTrigger -Once -At ($at.TimeOfDay.ToString("hh\:mm\:ss")) -RandomDelay "00:05:00"
$taskTrigger.EndBoundary = $at.AddMinutes(90).ToString('s')

[Microsoft.Management.Infrastructure.CimInstance] $taskSettings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter "02:00:00"

Register-ScheduledTask -TaskName "Delete File $(New-Guid)" -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings