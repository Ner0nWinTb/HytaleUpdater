@echo off
setlocal EnableDelayedExpansion
title HytaleUpdater Beta v2.2

:: ========================================================
:: 1. KONFIGURACJA WERSJI GRY (TERAZ 3 WERSJE)
:: ========================================================

:: --- NOWOSC: Opcja 1 (Pre-Release) ---
set "V1_NAME=Update 2: Jan 17 - Jan 22 (Pre-Release)"
set "V1_LINK=https://game-patches.hytale.com/patches/windows/amd64/pre-release/8/9.pwr"

:: --- Opcja 2 (Byla wczesniej nr 1) ---
set "V2_NAME=Update 1: Jan 15 - Jan 17 (Latest Stable)"
set "V2_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/3/4.pwr"

:: --- Opcja 3 (Byla wczesniej nr 2) ---
set "V3_NAME=HotFix 2: Jan 13 - Jan 15"
set "V3_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/2/3.pwr"

:: ========================================================
:: 2. KONFIGURACJA WERSJI ONLINE FIX
:: ========================================================
set "FIX1_NAME=Online-Fix 15.01 - 17.01 (Latest) (Don't work with Pre-Release)"
set "FIX1_LINK=https://trashbytes.net/dl/yYiz04P_yta6FdCfCA6mHTLPEqcWyiBBQEtLauFSfDGg2Z0GLrIuHaOub1flGc1jy7uKa2M59130F8RaoUcwgnx_Qi5AGbhlVkspHpzFvKFS?v=1769020873-cnLggA4mnARZBcPb8VnJ2RRAnlRF9FFWYMPgvladKAE%3D"

set "FIX2_NAME=Online-Fix (Template Ignore)"
set "FIX2_LINK="

:: ========================================================
:: 3. KONFIGURACJA SELF-UPDATERA
:: ========================================================
set "SELF_UPDATE_LINK=https://raw.githubusercontent.com/Ner0nWinTb/HytaleUpdater/main/HytaleUpdater.bat"

:: ========================================================
:: 4. USTAWIENIA PLIKOW
:: ========================================================
set "BUTLER_EXE=butler.exe"
set "SUBPATH_TO_GAME=install\release\package\game\latest" 

set "PATCH_FILE=%TEMP%\update_patch.pwr"
set "FIX_ZIP=%TEMP%\online_fix.zip"
set "NEW_SCRIPT=%TEMP%\HytaleUpdater_New.bat"
set "STAGING_DIR=%TEMP%\butler_staging_area"

set "ROOT_FOLDER=%~dp0"
if "%ROOT_FOLDER:~-1%"=="\" set "ROOT_FOLDER=%ROOT_FOLDER:~0,-1%"
set "TARGET_GAME_DIR=%ROOT_FOLDER%\%SUBPATH_TO_GAME%"
set "SCRIPT_NAME=%~nx0"

:MAIN_MENU
cls
echo ========================================================
echo                   HYTALE UPDATER v2.2
echo                     (By @neronreal)
echo ========================================================
echo.
echo   Current Status: Ready
echo.
echo   [1] Update Hytale (Select Version)
echo   [2] Add / Switch Online-Fix
echo   [3] Update Script (Self-Update)
echo   [4] Exit
echo.
echo ========================================================
echo   Select option [1-4]...

choice /C 1234 /N

if errorlevel 4 exit
if errorlevel 3 goto SELF_UPDATE
if errorlevel 2 goto FIX_MENU
if errorlevel 1 goto VERSION_MENU
goto MAIN_MENU

:: ========================================================
:: SEKCJA SELF-UPDATE
:: ========================================================
:SELF_UPDATE
cls
echo ---------------------------------------------------
echo  CHECKING FOR SCRIPT UPDATES
echo ---------------------------------------------------
echo.
echo  This will download the latest version from GitHub
echo  and restart the script.
echo.
echo  Current File: %SCRIPT_NAME%
echo.
echo  [Y] Update Now
echo  [N] Cancel
echo.
choice /C YN /N
if errorlevel 2 goto MAIN_MENU

echo.
echo  Downloading update...
powershell -Command "Invoke-WebRequest -Uri '%SELF_UPDATE_LINK%' -OutFile '%NEW_SCRIPT%'"

if %errorlevel% neq 0 (
    echo [ERROR] Failed to download update. Check internet or link.
    pause
    goto MAIN_MENU
)

echo.
echo  [SUCCESS] Update downloaded. Restarting...
timeout /t 2 >nul

start "" /min cmd /c "timeout /t 1 >nul & move /y "%NEW_SCRIPT%" "%ROOT_FOLDER%\%SCRIPT_NAME%" & start "" "%ROOT_FOLDER%\%SCRIPT_NAME%""
exit

:: ========================================================
:: MENU WYBORU GRY (3 OPCJE)
:: ========================================================
:VERSION_MENU
cls
echo ========================================================
echo   SELECT UPDATE
echo ========================================================
echo.
echo   [1] %V1_NAME%
echo   [2] %V2_NAME%
echo   [3] %V3_NAME%
echo.
echo   [B] Back
echo.
echo ========================================================
echo   Select version [1, 2, 3] or [B]ack...
choice /C 123B /N

if errorlevel 4 goto MAIN_MENU
if errorlevel 3 (
    set "SELECTED_LINK=%V3_LINK%"
    set "SELECTED_NAME=%V3_NAME%"
    goto INSTALL_GAME
)
if errorlevel 2 (
    set "SELECTED_LINK=%V2_LINK%"
    set "SELECTED_NAME=%V2_NAME%"
    goto INSTALL_GAME
)
if errorlevel 1 (
    set "SELECTED_LINK=%V1_LINK%"
    set "SELECTED_NAME=%V1_NAME%"
    goto INSTALL_GAME
)
goto VERSION_MENU

:: ========================================================
:: MENU WYBORU ONLINE FIX
:: ========================================================
:FIX_MENU
cls
echo ========================================================
echo   SELECT ONLINE FIX VERSION
echo ========================================================
echo.
echo   [1] %FIX1_NAME%
echo   [2] %FIX2_NAME%
echo.
echo   [B] Back
echo.
echo ========================================================
echo   Select fix [1, 2] or [B]ack...
choice /C 12B /N

if errorlevel 3 goto MAIN_MENU
if errorlevel 2 (
    set "SELECTED_FIX_LINK=%FIX2_LINK%"
    set "SELECTED_FIX_NAME=%FIX2_NAME%"
    goto INSTALL_FIX
)
if errorlevel 1 (
    set "SELECTED_FIX_LINK=%FIX1_LINK%"
    set "SELECTED_FIX_NAME=%FIX1_NAME%"
    goto INSTALL_FIX
)
goto FIX_MENU

:: ========================================================
:: INSTALACJA GRY (WERSJA STABILNA)
:: ========================================================
:INSTALL_GAME
cls
echo ---------------------------------------------------
echo  Downloading Hytale: %SELECTED_NAME%
echo ---------------------------------------------------

if not exist "%ROOT_FOLDER%\%BUTLER_EXE%" (
    echo [ERROR] %BUTLER_EXE% not found.
    pause
    goto MAIN_MENU
)

echo.
echo  [1/2] Downloading patch...
powershell -Command "Invoke-WebRequest -Uri '%SELECTED_LINK%' -OutFile '%PATCH_FILE%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed.
    pause
    goto MAIN_MENU
)

echo.
echo  [2/2] Applying patch...

:: --- FIX: Czyszczenie folderu tymczasowego przed startem ---
if exist "%STAGING_DIR%" (
    rmdir /s /q "%STAGING_DIR%"
)
:: ----------------------------------------------------------

if not exist "%TARGET_GAME_DIR%" mkdir "%TARGET_GAME_DIR%"
mkdir "%STAGING_DIR%"

"%ROOT_FOLDER%\%BUTLER_EXE%" apply --staging-dir="%STAGING_DIR%" "%PATCH_FILE%" "%TARGET_GAME_DIR%"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Update failed!
    echo Butler could not finish patching.
    pause
    goto MAIN_MENU
)

echo.
echo  [SUCCESS] Game updated successfully!
echo  (Press any key to clean up temp files and return to menu...)
pause >nul

:: Sprzatanie robimy DOPIERO PO wcisnieciu klawisza
if exist "%PATCH_FILE%" del /f /q "%PATCH_FILE%"
if exist "%STAGING_DIR%" rmdir /s /q "%STAGING_DIR%"

goto MAIN_MENU

:: ========================================================
:: INSTALACJA ONLINE FIX
:: ========================================================
:INSTALL_FIX
cls
echo ---------------------------------------------------
echo  INSTALLING: %SELECTED_FIX_NAME%
echo ---------------------------------------------------
echo.
echo  Destination: "%ROOT_FOLDER%"
echo.
echo  Download Online-Fix?
echo  [Y] Yes
echo  [N] No (Cancel)
echo.
choice /C YN /N

if errorlevel 2 goto MAIN_MENU

echo.
echo  [1/2] Downloading Fix...
powershell -Command "Invoke-WebRequest -Uri '%SELECTED_FIX_LINK%' -OutFile '%FIX_ZIP%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed. Check link or internet.
    pause
    goto MAIN_MENU
)

echo.
echo  [2/2] Extracting files...
if not exist "%TARGET_GAME_DIR%" mkdir "%TARGET_GAME_DIR%"
powershell -Command "Expand-Archive -Path '%FIX_ZIP%' -DestinationPath '%ROOT_FOLDER%' -Force"

if %errorlevel% neq 0 (
    echo [ERROR] Extraction failed.
    pause
    goto MAIN_MENU
)

if exist "%FIX_ZIP%" del "%FIX_ZIP%"

echo.
echo  [SUCCESS] %SELECTED_FIX_NAME% installed!
echo.
pause >nul
goto MAIN_MENU
