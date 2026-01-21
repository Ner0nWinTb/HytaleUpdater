@echo off
setlocal EnableDelayedExpansion

:: ========================================================
:: CONFIGURATION
:: ========================================================

:: 1. DIRECT LINK TO .PWR FILE
set "DIRECT_LINK=https://game-patches.hytale.com/"

:: 2. Butler filename (must be next to launcher and this script)
set "BUTLER_EXE=butler.exe"

:: 3. Subpath to game files (without "Hytale" at the start!)
set "SUBPATH_TO_GAME=install\release\package\game\latest"

:: 4. Working directory and temp files
set "PATCH_FILE=%TEMP%\update_patch.pwr"
set "STAGING_DIR=%TEMP%\butler_staging_area"

:: ========================================================
:: END OF CONFIGURATION
:: ========================================================

:: Current folder (Hytale)
set "ROOT_FOLDER=%~dp0"
:: Remove trailing backslash
if "%ROOT_FOLDER:~-1%"=="\" set "ROOT_FOLDER=%ROOT_FOLDER:~0,-1%"

:: Building full path to "latest"
set "TARGET_GAME_DIR=%ROOT_FOLDER%\%SUBPATH_TO_GAME%"

cls
echo ========================================================
echo             HYTALE UPDATER (By neronreal)
echo ========================================================
echo.
echo  [INFO] Script location (Root):
echo  "%ROOT_FOLDER%"
echo.
echo  [INFO] Update target:
echo  "%TARGET_GAME_DIR%"
echo.

:: CHECK 1: Is butler nearby?
if not exist "%ROOT_FOLDER%\%BUTLER_EXE%" (
    echo [ERROR] File %BUTLER_EXE% not found!
    echo Please put butler in the same folder as the Launcher.
    pause
    exit /b
)

:: CHECK 2: Does 'latest' folder exist?
if not exist "%TARGET_GAME_DIR%" (
    echo [ERROR] Game folder not found:
    echo "%TARGET_GAME_DIR%"
    echo.
    echo Make sure you are running this in the main Hytale folder!
    pause
    exit /b
)

echo.
echo ---------------------------------------------------
echo      1. DOWNLOADING PATCH FROM GAME SERVERS...
echo          Source: game-patches.hytale.com
echo ---------------------------------------------------

powershell -Command "try { Invoke-WebRequest -Uri '%DIRECT_LINK%' -OutFile '%PATCH_FILE%' -ErrorAction Stop; Write-Host 'Download complete.' -ForegroundColor Green } catch { Write-Host 'Download error!' -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to download the file.
    pause
    exit /b
)

echo.
echo ---------------------------------------------------
echo               2. INSTALLING UPDATE...
echo ---------------------------------------------------

if not exist "%STAGING_DIR%" mkdir "%STAGING_DIR%"

:: Butler applies patch to deep structure
"%ROOT_FOLDER%\%BUTLER_EXE%" apply --staging-dir="%STAGING_DIR%" "%PATCH_FILE%" "%TARGET_GAME_DIR%"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Butler reported a problem.
    echo Make sure the game and launcher are CLOSED.
    pause
    exit /b
)

echo.
echo ---------------------------------------------------
echo                    3. CLEANUP...
echo ---------------------------------------------------
del "%PATCH_FILE%"
rmdir /s /q "%STAGING_DIR%"
echo Temporary files removed.

echo.
echo ===================================================
echo          SUCCESS! Game has been updated.
echo ===================================================
echo.

pause
