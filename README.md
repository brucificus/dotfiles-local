# Brucificus' PowerShell Profile

This is my personal PowerShell profile. It's here on GitHub because I want to version it and access it from anywhere, so this seemed like the way to do it.

## Requirements

- Windows PowerShell 5.1 or PowerShell Core 6.2.2
- If on Windows, release 1903 (build 18362.295) or higher

## Installing the Brucificus PowerShell Profile

### Install with cmd.exe

```cmd
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/brucificus/powershell-profile/master/bootstrap/install.ps1'))"
```

### Install with PowerShell.exe

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/brucificus/powershell-profile/master/bootstrap/install.ps1'))
```

## Contributing

If you see something here that you would like tweaked in order to make this more useful to you, please don't hesitate to open an issue or a pull request.
