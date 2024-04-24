@echo off
setlocal

:: Set the source and target directories
set "sourceDir=%~dp0\..\PSDevelopmentSupport"
set "targetDir=%USERPROFILE%\OneDrive - KUMAVISION AG\Dokumente\WindowsPowerShell\Modules\PSDevelopmentSupport"

:: Remove the target directory if it exists
if exist "%targetDir%" (
    rd /s /q "%targetDir%"
)

:: Create the target directory if it doesn't exist
mkdir "%targetDir%"

:: Copy the PowerShell module
xcopy /E /I /Y "%sourceDir%" "%targetDir%"

endlocal