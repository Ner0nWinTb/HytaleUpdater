@echo off
setlocal EnableDelayedExpansion

:: ========================================================
:: CONFIGURATION
:: ========================================================

:: 1. Direct link to Pixeldrain (Upload your update as .ZIP!)
:: Example: https://pixeldrain.com/u/abc12345
set "LINK_ORG="

:: 2. Temporary file name
set "TEMP_FILE=%TEMP%\game_update_pkg.zip"

:: ========================================================
:: END OF CONFIGURATION
:: ========================================================

:: Determine the current folder (where this script is located)
set "GAME_FOLDER=%~dp0"

cls
echo ========================================================
echo           Online-Fix Applier (By neronreal)
echo ========================================================
echo.
echo  Target directory:
echo  "%GAME_FOLDER%"
echo.
echo  [IMPORTANT] Make sure this script is inside your Game Folder!
echo.
pause

:: 1. LINK FIX (Pixeldrain /u/ to /api/file/)
set "LINK_DIRECT=%LINK_ORG:/u/=/api/file/%"

echo.
echo ---------------------------------------------------
echo       1. DOWNLOADING ONLINE-FIX FILES...
echo             Source: online-fix.me
echo ---------------------------------------------------

:: Using PowerShell to download
powershell -Command "try { Invoke-WebRequest -Uri '%LINK_DIRECT%' -OutFile '%TEMP_FILE%' -ErrorAction Stop; Write-Host 'Download complete.' -ForegroundColor Green } catch { Write-Host 'Download failed! Check your internet connection.' -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Could not download the file.
    pause
    exit /b
)

echo.
echo ---------------------------------------------------
echo       2. EXTRACTING AND OVERWRITING FILES...
echo ---------------------------------------------------

:: Using PowerShell to unzip (Native Windows feature)
:: -Force means it will overwrite existing files automatically
powershell -Command "try { Expand-Archive -Path '%TEMP_FILE%' -DestinationPath '%GAME_FOLDER%' -Force -ErrorAction Stop; Write-Host 'Update applied successfully.' -ForegroundColor Green } catch { Write-Host 'Extraction failed!' -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo.
    echo CRITICAL ERROR during extraction.
    echo Ensure the game is closed and you have write permissions.
    pause
    exit /b
)

echo.
echo ---------------------------------------------------
echo                  3. CLEANUP...
echo ---------------------------------------------------
del "%TEMP_FILE%"
echo Temporary files removed.

echo.
echo ===================================================
echo           SUCCESS! Online-Fix added!
echo           You can now start the game
echo ===================================================
echo.

pause
