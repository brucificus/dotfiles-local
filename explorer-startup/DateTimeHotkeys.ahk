#Requires AutoHotkey v2
#SingleInstance force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

; Ctrl+Alt+Win+;
; Lexicographical symbol-less date
;   for file/folder names
^!#;:: {
    nowish := A_Now
    DateText := FormatTime(nowish, "yyyyMMdd")
    Send(DateText)
}

; Ctrl+Alt+Shift+Win+;
; Symbol-less 24-hour hours+minutes time
;   for file names
^!+#;:: {
    nowish := A_Now
    DateText := FormatTime(nowish, "HHmm")
    Send(DateText)
}


; Ctrl+Win+;
; Lexicographical hyphenated date
;   for free-form text fields
^#;:: {
    nowish := A_Now
    DateText := FormatTime(nowish, "yyyy-MM-dd")
    Send(DateText)
}

; Ctrl+Shift+Win+;
; Colon-separated 24-hour hours+minutes time
;   for free-form text fields
^+#;:: {
    nowish := A_Now
    DateText := FormatTime(nowish, "HH:mm")
    Send(DateText)
}


; Ctrl+Alt+;
; Y#### W##
;   for freeform text bodies that exist in corpora with lots of time variability. (Journals)
^!;:: {
    nowish := A_Now
    YearWeekDigits := FormatTime(nowish, "YWeek")
    YearText := SubStr(YearWeekDigits, 1, 4)
    WeekText := SubStr(YearWeekDigits, 5, 2)
    Send("Y" YearText " W" WeekText)
}

; Ctrl+Alt+Shift+;
; MM-dd dddd (YDay0)
;   for freeform text bodies that exist in corpora with lots of time variability. (Journals)
^!+;:: {
    nowish := A_Now
    MonthDayText := FormatTime(nowish, "MM-dd")
    DayOfWeekText := FormatTime(nowish, "dddd")
    YearDayDigits := FormatTime(nowish, "YDay0")
    Send(MonthDayText " " DayOfWeekText " (D" YearDayDigits ")")
}
