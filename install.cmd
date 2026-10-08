@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "visual_analysis_exit=%ERRORLEVEL%"
if "%~1"=="" pause
exit /b %visual_analysis_exit%
