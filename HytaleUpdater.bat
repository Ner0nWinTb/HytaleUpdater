@echo off
setlocal EnableDelayedExpansion
title HytaleUpdater Beta v2.5

:: ========================================================
:: 1. KONFIGURACJA WERSJI GRY
:: ========================================================

:: --- Opcja 1 (NOWY RELEASE) ---
:: !!! PAMIETAJ: Wpisz tu prawdziwa wage pliku (np. 120MB) jak wyjdzie !!!
set "V1_NAME=Update 2: Jan 17 -^> Jan 24 (71,1MB) (Latest)"
set "V1_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/4/5.pwr"

:: --- Opcja 2 (Poprzedni Stable) ---
set "V2_NAME=Update 1: Jan 15 -^> Jan 17 (67,9MB)"
set "V2_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/3/4.pwr"

:: --- Opcja 3 (Old) ---
set "V3_NAME=HotFix 2: Jan 13 -^> Jan 15 (57,7MB)"
set "V3_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/2/3.pwr"

:: ========================================================
:: 2. KONFIGURACJA ONLINE FIX
:: ========================================================
set "FIX1_NAME=Online-Fix for 24.01 (Wait for Release)"
set "FIX1_LINK="

set "FIX2_NAME=Online-Fix for 17.01 (89,4MB)"
set "FIX2_LINK=http://dl.dropboxusercontent.com/scl/fi/mm2bntn58vn9m0ba4ebam/OnlineFixBackup.zip?rlkey=ok6vogia9ey5s7o1evg21e4o7&st=yogaeame&dl=0"

:: JAVA FIX (Potrzebny do Update 2 na start)
set "JAVA_FIX_LINK=http://dl.dropboxusercontent.com//scl/fi/91g8f4yvp6hrjq1urvr0j/HytaleServer.jar?rlkey=xf3nayfuzezu1acb11agsqyoz&st=p8f2kd9v&dl=0"

:: ========================================================
:: 3. SELF-UPDATER
:: ========================================================
set "SELF_UPDATE_LINK=https://raw.githubusercontent.com/Ner0nWinTb/HytaleUpdater/main/HytaleUpdater.bat"

:: ========================================================
:: 4. USTAWIENIA PLIKOW
:: ========================================================
set "BUTLER_EXE=butler.exe"
set "SUBPATH_TO_GAME=install\release\package\game\latest" 
set "SUBPATH_BACKUP=install\release\package\game\backup_stable"
set "GAME_SAVES_PATH=Client\UserData"
set "SAVES_BACKUP_DIR=install\release\package\game\saved_data_backup"

set "PATCH_FILE=%TEMP%\update_patch.pwr"
set "FIX_ZIP=%TEMP%\online_fix.zip"
set "NEW_SCRIPT=%TEMP%\HytaleUpdater_New.bat"
set "STAGING_DIR=%TEMP%\butler_staging_area"

set "ROOT_FOLDER=%~dp0"
if "%ROOT_FOLDER:~-1%"=="\" set "ROOT_FOLDER=%ROOT_FOLDER:~0,-1%"
set "TARGET_GAME_DIR=%ROOT_FOLDER%\%SUBPATH_TO_GAME%"
set "BACKUP_DIR=%ROOT_FOLDER%\%SUBPATH_BACKUP%"
set "FULL_SAVES_DIR=%TARGET_GAME_DIR%\%GAME_SAVES_PATH%"
set "FULL_SAVES_BACKUP=%ROOT_FOLDER%\%SAVES_BACKUP_DIR%"
set "SCRIPT_NAME=%~nx0"

:MAIN_MENU
cls
echo ========================================================
echo                   HYTALE UPDATER v2.5
echo                     (By @neronreal)
echo ========================================================
echo.
echo   Current Status: Ready
echo.
echo   [1] Update Hytale (Select Version)
echo   [2] Add / Switch Online-Fix
echo   [3] Import / Export Saves (UserData Manager)
echo   [4] Update Script (Self-Update)
echo   [5] Exit
echo.
echo ========================================================
echo   Select option [1-5]...

choice /C 12345 /N

if errorlevel 5 exit
if errorlevel 4 goto SELF_UPDATE
if errorlevel 3 goto SAVE_MENU
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
echo  This will download the latest version from GitHub.
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
    echo [ERROR] Failed to download update.
    pause
    goto MAIN_MENU
)

echo.
echo  [SUCCESS] Update downloaded. Restarting...
timeout /t 2 >nul
start "" /min cmd /c "timeout /t 1 >nul & move /y "%NEW_SCRIPT%" "%ROOT_FOLDER%\%SCRIPT_NAME%" & start "" "%ROOT_FOLDER%\%SCRIPT_NAME%""
exit

:: ========================================================
:: SAVE MANAGER
:: ========================================================
:SAVE_MENU
cls
echo ========================================================
echo   USERDATA MANAGER (Import / Export)
echo ========================================================
echo.
echo   Manage your UserData (Worlds, Settings, Avatars).
echo.
echo   [1] EXPORT UserData (Game -^> Backup)
echo   [2] IMPORT UserData (Backup -^> Game)
echo.
echo   [B] Back to Main Menu
echo.
echo ========================================================
choice /C 12B /N

if errorlevel 3 goto MAIN_MENU
if errorlevel 2 goto IMPORT_SAVES
if errorlevel 1 goto EXPORT_SAVES
goto SAVE_MENU

:EXPORT_SAVES
cls
echo ---------------------------------------------------
echo  EXPORTING SAVES...
echo ---------------------------------------------------
echo.
if not exist "%FULL_SAVES_DIR%" goto ERR_NO_SAVES

echo  Copying files to safe backup...
if not exist "%FULL_SAVES_BACKUP%" mkdir "%FULL_SAVES_BACKUP%"
robocopy "%FULL_SAVES_DIR%" "%FULL_SAVES_BACKUP%" /MIR >nul

if %errorlevel% gtr 7 goto ERR_EXPORT_FAIL
echo  [SUCCESS] Saves backed up successfully!
timeout /t 2 >nul
goto SAVE_MENU

:IMPORT_SAVES
cls
echo ---------------------------------------------------
echo  IMPORTING SAVES...
echo ---------------------------------------------------
echo.
if not exist "%FULL_SAVES_BACKUP%" goto ERR_NO_BACKUP

echo  Restoring files to game folder...
if not exist "%FULL_SAVES_DIR%" mkdir "%FULL_SAVES_DIR%"
robocopy "%FULL_SAVES_BACKUP%" "%FULL_SAVES_DIR%" /MIR >nul

if %errorlevel% gtr 7 goto ERR_IMPORT_FAIL
echo  [SUCCESS] Saves restored successfully!
timeout /t 2 >nul
goto SAVE_MENU

:ERR_NO_SAVES
echo  [ERROR] No game saves found.
pause
goto SAVE_MENU
:ERR_NO_BACKUP
echo  [ERROR] No backup found.
pause
goto SAVE_MENU
:ERR_EXPORT_FAIL
echo  [ERROR] Export failed.
pause
goto SAVE_MENU
:ERR_IMPORT_FAIL
echo  [ERROR] Import failed.
pause
goto SAVE_MENU

:: ========================================================
:: MENU WYBORU GRY
:: ========================================================
:VERSION_MENU
cls
echo =======================================================================
echo   SELECT GAME VERSION (BACK TO 17 JAN VERSION AFTER USING PRE-RELEASE)
echo =======================================================================
echo.
echo   [1] %V1_NAME%
echo   [2] %V2_NAME%
echo   [3] %V3_NAME%
echo.
echo   [B] Back
echo.
echo ========================================================================
echo   Select version [1, 2, 3] or [B]ack...
choice /C 123B /N

if errorlevel 4 goto MAIN_MENU

:: OPCJA 3
if errorlevel 3 (
    set "SELECTED_LINK=%V3_LINK%"
    set "SELECTED_NAME=%V3_NAME%"
    goto CHECK_RESTORE
)
:: OPCJA 2
if errorlevel 2 (
    set "SELECTED_LINK=%V2_LINK%"
    set "SELECTED_NAME=%V2_NAME%"
    goto CHECK_RESTORE
)
:: OPCJA 1 (TERAZ IDZIE DO SPRAWDZENIA BACKUPU)
if errorlevel 1 (
    set "SELECTED_LINK=%V1_LINK%"
    set "SELECTED_NAME=%V1_NAME%"
    goto CHECK_BACKUP
)
goto VERSION_MENU

:: ========================================================
:: BACKUP / RESTORE
:: ========================================================
:CHECK_BACKUP
:: 1. Jesli gry nie ma w ogole, nie ma co backupowac -> Instaluj
if not exist "%TARGET_GAME_DIR%" goto INSTALL_GAME

:: 2. Jesli backup JUZ istnieje, uznajemy ze jest bezpiecznie -> Instaluj
if exist "%BACKUP_DIR%" goto INSTALL_GAME

:: 3. Jesli gry jest, a backupu brak -> Pytamy uzytkownika
cls
echo ========================================================
echo   SAFETY CHECK (Highly Recommended)
echo ========================================================
echo.
echo   You are about to update to a new version.
echo   Multiplayer (Online-Fix) might NOT released on Day 1.
echo.
echo   Create a backup of your current version?
echo   (Allows instant restore if you want to go back)
echo.
echo   [Y] Yes - Create Backup (Safe)
echo   [N] No  - Skip (You can't back)
echo.
choice /C YN /N
if errorlevel 2 goto INSTALL_GAME

echo.
echo   Creating backup (Please wait)...
mkdir "%BACKUP_DIR%"
robocopy "%TARGET_GAME_DIR%" "%BACKUP_DIR%" /MIR >nul
echo   [SUCCESS] Backup created. Proceeding to update...
timeout /t 2 >nul
goto INSTALL_GAME

:CHECK_RESTORE
if not exist "%BACKUP_DIR%" goto INSTALL_GAME
cls
echo ========================================================
echo   RESTORE SYSTEM
echo ========================================================
echo.
echo   Downgrading to older version.
echo   Restore from backup if available?
echo.
echo   [Y] Yes - Restore Backup (Recommented)
echo   [N] No  - Cancel
echo.
choice /C YN /N
if errorlevel 2 goto MAIN_MENU

echo.
echo   Restoring...
robocopy "%BACKUP_DIR%" "%TARGET_GAME_DIR%" /MIR >nul
if %errorlevel% gtr 7 (
    echo [ERROR] Restore failed.
    pause
    goto MAIN_MENU
)
echo   [SUCCESS] Version restored.
echo   Cleaning up...
rmdir /s /q "%BACKUP_DIR%"
pause
goto MAIN_MENU

:: ========================================================
:: MENU ONLINE FIX
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
choice /C 12B /N
if errorlevel 3 goto MAIN_MENU
if errorlevel 2 (
    set "SELECTED_FIX_LINK=%FIX2_LINK%"
    set "SELECTED_FIX_NAME=%FIX2_NAME%"
    goto INSTALL_FIX
)
if errorlevel 1 (
    if "%FIX1_LINK%"=="" (
        echo.
        echo   [INFO] Fix not available yet. Please play Singleplayer.
        echo.        
        pause
        goto FIX_MENU
    )
 
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
echo  [1/2] Downloading patch...
powershell -Command "Invoke-WebRequest -Uri '%SELECTED_LINK%' -OutFile '%PATCH_FILE%'"
if %errorlevel% neq 0 (
    echo [ERROR] Download failed. Check link!
    pause
    goto MAIN_MENU
)

echo.
echo  [2/2] Applying patch...
if exist "%STAGING_DIR%" rmdir /s /q "%STAGING_DIR%"
if not exist "%TARGET_GAME_DIR%" mkdir "%TARGET_GAME_DIR%"
mkdir "%STAGING_DIR%"

"%ROOT_FOLDER%\%BUTLER_EXE%" apply --staging-dir="%STAGING_DIR%" "%PATCH_FILE%" "%TARGET_GAME_DIR%"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Update failed!
    pause
    goto MAIN_MENU
)

:: --- JAVA FIX (Twoj kod) ---
if "%SELECTED_NAME%"=="%V1_NAME%" (
    echo.
    echo   [3/3] Installing Java Fix
    
    if not exist "%TARGET_GAME_DIR%\Server" mkdir "%TARGET_GAME_DIR%\Server"
    
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
    echo [ERROR] Download failed.
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
