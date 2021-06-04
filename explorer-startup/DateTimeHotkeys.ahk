#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Ctrl+Alt+Win+;
; Lexicographical symbol-less date
;   for file/folder names
^!#;::
FormatTime, DateText, , yyyyMMdd
Send, %DateText%
return

; Ctrl+Alt+Shift+Win+;
; Symbol-less 24-hour hours+minutes time
;   for file names
^!+#;::
FormatTime, DateText, , HHmm
Send, %DateText%
return


; Ctrl+Win+;
; Lexicographical hyphenated date
;   for free-form text fields
^#;::
FormatTime, DateText, , yyyy-MM-dd
Send, %DateText%
return

; Ctrl+Shift+Win+;
; Colon-separated 24-hour hours+minutes time
;   for free-form text fields
^+#;::
FormatTime, DateText, , HH:mm
Send, %DateText%
return


; Ctrl+Alt+;
; Y#### W## 
;   for freeform text bodies that exist in corpora with lots of time variability. (Journals)
^!;::
nowish := A_Now
FormatTime, YearWeekDigits, nowish, YWeek
YearText := SubStr(YearWeekDigits, 1, 4)
WeekText := SubStr(YearWeekDigits, 5, 2)
Send, Y%YearText% W%WeekText%
return

; Ctrl+Alt+Shift+;
; MM-dd dddd (YDay0)
;   for freeform text bodies that exist in corpora with lots of time variability. (Journals)
^!+;::
nowish := A_Now
FormatTime, MonthDayText, nowish, MM-dd
FormatTime, DayOfWeekText, nowish, dddd
FormatTime, YearDayDigits, nowish, YDay0
Send, %MonthDayText% %DayOfWeekText% (D%YearDayDigits%)
return