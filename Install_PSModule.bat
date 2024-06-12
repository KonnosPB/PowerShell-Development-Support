@echo off
setlocal

REM Setze den Quell- und Zielpfad
set "SOURCE_DIR=."
set "TARGET_DIR=%USERPROFILE%\OneDrive - KUMAVISION AG\Dokumente\PowerShell\Modules\PSDevelopmentSupport"

REM Überprüfe, ob das Zielverzeichnis existiert, und erstelle es falls notwendig
if not exist "%TARGET_DIR%" (
    echo Erstelle das Zielverzeichnis: %TARGET_DIR%
    mkdir "%TARGET_DIR%"
)

REM Kopiere die Dateien und ersetze vorhandene Dateien, schließe das .git-Verzeichnis aus
echo Kopiere Dateien von %SOURCE_DIR% nach %TARGET_DIR%
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /XD ".git"

echo PowerShell-Modul wurde erfolgreich installiert/aktualisiert.
endlocal
pause