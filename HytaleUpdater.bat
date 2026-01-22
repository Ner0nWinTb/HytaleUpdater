@echo off
setlocal EnableDelayedExpansion
title HytaleUpdater Beta v2.3

:: ========================================================
:: 1. KONFIGURACJA WERSJI GRY
:: ========================================================

:: --- NOWOSC: Opcja 1 (Pre-Release) ---
set "V1_NAME=Update 2: Jan 17 - Jan 22 (Pre-Release)"
set "V1_LINK=https://game-patches.hytale.com/patches/windows/amd64/pre-release/8/9.pwr"

:: !!! JAVA FIX (DLA PRE-RELEASE) !!!
:: Wklej tutaj link bezposredni do pliku .jar
set "JAVA_FIX_LINK=https://trashbytes.net/dl/DthrW7Ob6TvgLRsV9-W1p1JOCRR2xjzhHR6rrFPxwTitB2xwoHM0JxdYaO_GY5tcz2E3XHtJSytWyK-nqRhsPmi-MsWfaFcoY0kx5IQNG9QwBvCx?v=1769085610-zC54zt%2FLBZte98QQCu2YwydL5YE7jxL224aKEDRjLJI%3D"

:: --- Opcja 2 (Stable) ---
set "V2_NAME=Update 1: Jan 15 - Jan 17 (Latest Stable)"
set "V2_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/3/4.pwr"

:: --- Opcja 3 (Old) ---
set "V3_NAME=HotFix 2: Jan 13 - Jan 15"
set "V3_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/2/3.pwr"

:: ========================================================
:: 2. KONFIGURACJA WERSJI ONLINE FIX
:: ========================================================
set "FIX1_NAME=Online-Fix 15.01 - 17.01 (Latest)"
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
:: --- Folder Backupu ---
set "SUBPATH_BACKUP=install\release\package\game\backup_stable"

set "PATCH_FILE=%TEMP%\update_patch.pwr"
set "FIX_ZIP=%TEMP%\online_fix.zip"
set "NEW_SCRIPT=%TEMP%\HytaleUpdater_New.bat"
set "STAGING_DIR=%TEMP%\butler_staging_area"

set "ROOT_FOLDER=%~dp0"
if "%ROOT_FOLDER:~-1%"=="\" set "ROOT_FOLDER=%ROOT_FOLDER:~0,-1%"
set "TARGET_GAME_DIR=%ROOT_FOLDER%\%SUBPATH_TO_GAME%"
set "BACKUP_DIR=%ROOT_FOLDER%\%SUBPATH_BACKUP%"
set "SCRIPT_NAME=%~nx0"

:MAIN_MENU
cls
echo ========================================================
echo                   HYTALE UPDATER v2.3
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
:: MENU WYBORU GRY
:: ========================================================
:VERSION_MENU
cls
echo ========================================================
echo   SELECT GAME VERSION
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

:: OPCJA 3: OLD (Stable) -> Idzie do Restore
if errorlevel 3 (
    set "SELECTED_LINK=%V3_LINK%"
    set "SELECTED_NAME=%V3_NAME%"
    goto CHECK_RESTORE
)
:: OPCJA 2: STABLE -> Idzie do Restore
if errorlevel 2 (
    set "SELECTED_LINK=%V2_LINK%"
    set "SELECTED_NAME=%V2_NAME%"
    goto CHECK_RESTORE
)
:: OPCJA 1: PRE-RELEASE -> Idzie do Backup
if errorlevel 1 (
    set "SELECTED_LINK=%V1_LINK%"
    set "SELECTED_NAME=%V1_NAME%"
    goto CHECK_BACKUP
)
goto VERSION_MENU

:: ========================================================
:: LOGIKA BACKUPU
:: ========================================================
:CHECK_BACKUP
:: Jesli folder gry pusty, nie robimy backupu
if not exist "%TARGET_GAME_DIR%" goto INSTALL_GAME
:: Jesli backup juz jest, nie nadpisujemy go
if exist "%BACKUP_DIR%" goto INSTALL_GAME

cls
echo ========================================================
echo   BACKUP SYSTEM
echo ========================================================
echo.
echo   [IMPORTANT] Switching to Pre-Release.
echo   Do you want to BACKUP your current Stable version?
echo.
echo   [Y] Yes - Create Backup (Recommended)
echo   [N] No  - Proceed without Backup (Risky!)
echo.
echo ========================================================
choice /C YN /N

if errorlevel 2 goto INSTALL_GAME

echo.
echo   Cloning game files... (Robocopy)
robocopy "%TARGET_GAME_DIR%" "%BACKUP_DIR%" /MIR /NFL /NDL /NJH /NJS

if %errorlevel% gtr 7 (
    echo [ERROR] Backup failed.
    pause
    goto MAIN_MENU
)

echo   [OK] Backup created!
timeout /t 1 >nul
goto INSTALL_GAME

:: ========================================================
:: LOGIKA RESTORE
:: ========================================================
:CHECK_RESTORE
if not exist "%BACKUP_DIR%" goto INSTALL_GAME

cls
echo ========================================================
echo   RESTORE SYSTEM
echo ========================================================
echo.
echo   Found a Stable Backup!
echo   Do you want to restore it instead of downloading?
echo.
echo   [Y] Yes - Restore Backup (Instant)
echo   [N] No  - Download Fresh Files
echo.
echo ========================================================
choice /C YN /N

if errorlevel 2 goto INSTALL_GAME

echo.
echo   Restoring Stable version...
robocopy "%BACKUP_DIR%" "%TARGET_GAME_DIR%" /MIR /NFL /NDL /NJH /NJS

if %errorlevel% gtr 7 (
    echo [ERROR] Restore failed.
    pause
    goto MAIN_MENU
)

echo   [SUCCESS] Restored Stable Version!
pause
goto MAIN_MENU

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
:: INSTALACJA GRY
:: ========================================================
:INSTALL_GAME
cls
echo ---------------------------------------------------
echo  Downloading Hytale %SELECTED_NAME%
echo ---------------------------------------------------

if not exist "%ROOT_FOLDER%\%BUTLER_EXE%" (
    echo [ERROR] %BUTLER_EXE% not found.
    pause
    goto MAIN_MENU
)

echo.
echo  [1/3] Downloading patch...
powershell -Command "Invoke-WebRequest -Uri '%SELECTED_LINK%' -OutFile '%PATCH_FILE%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed.
    pause
    goto MAIN_MENU
)

echo.
echo  [2/3] Applying patch...

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

:: --- NOWOSC: JAVA FIX (TYLKO DLA PRE-RELEASE) ---
if "%SELECTED_NAME%"=="%V1_NAME%" (
    echo.
    echo   [3/3] Installing Java Fix
    
    :: Tworzymy folder Server jesli nie istnieje
    if not exist "%TARGET_GAME_DIR%\Server" mkdir "%TARGET_GAME_DIR%\Server"
    
    :: Pobieramy BEZPOSREDNIO jako HytaleServer.jar
    echo   Downloading HytaleServer.jar...
    powershell -Command "Invoke-WebRequest -Uri '%JAVA_FIX_LINK%' -OutFile '%TARGET_GAME_DIR%\Server\HytaleServer.jar'"
    
    if exist "%TARGET_GAME_DIR%\Server\HytaleServer.jar" (
        echo   [SUCCESS] Java Fix downloaded!
    ) else (
        echo   [ERROR] Download failed. Check link!
    )
)
:: -----------------------------------------------------

if exist "%PATCH_FILE%" del "%PATCH_FILE%"
if exist "%STAGING_DIR%" rmdir /s /q "%STAGING_DIR%"

echo.
echo  [SUCCESS] Game updated successfully.
pause >nul
goto MAIN_MENU

:: ========================================================
:: INSTALACJA ONLINE FIX (STARA DOBRA WERSJA V2.2)
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
