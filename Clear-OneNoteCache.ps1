Stop-Process -Name onenoteim -ErrorAction SilentlyContinue
[string] $cachePath = "$($Env:LocalAppData)\Packages\Microsoft.Office.OneNote_8wekyb3d8bbwe\LocalState\AppData\Local\OneNote\16.0\cache"
if (Test-Path $cachePath -ErrorAction SilentlyContinue) {
    cmd /c rmdir /s /q "$cachePath"
}
Start-Process -FilePath "explorer.exe" -ArgumentList "shell:AppsFolder\Microsoft.Office.OneNote_8wekyb3d8bbwe!microsoft.onenoteim"
