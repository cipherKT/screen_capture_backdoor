@echo off
powershell Start-Process powershell.exe -windowstyle hidden "$env:temp/capture.ps1"
