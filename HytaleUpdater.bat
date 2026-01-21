@echo off
setlocal EnableDelayedExpansion
title HytaleUpdater v2.0

:: ========================================================
:: 1. KONFIGURACJA WERSJI GRY
:: ========================================================
set "V1_NAME=Update: Jan 15 - Jan 17 (Latest)"
set "V1_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/"

set "V2_NAME=HotFix: Jan 13 - Jan 15"
set "V2_LINK=https://game-patches.hytale.com/patches/windows/amd64/release/"

:: ========================================================
:: 2. KONFIGURACJA WERSJI ONLINE FIX (Z WYBOREM)
:: ========================================================

:: Fix 1 (Najnowszy - z Twojego repo)
set "FIX1_NAME=Online-Fix 15.01 - 17.01 (Latest)"
set "FIX1_LINK="

:: Fix 2 (Starszy / Inny - przyklad)
set "FIX2_NAME=Online-Fix (Template Ignore)"
set "FIX2_LINK="

:: ========================================================
:: 3. USTAWIENIA PLIKOW
:: ========================================================
set "BUTLER_EXE=butler.exe"
:: Kropka = biezacy folder (folder skryptu)
set "SUBPATH_TO_GAME=." 

set "PATCH_FILE=%TEMP%\update_patch.pwr"
set "FIX_ZIP=%TEMP%\online_fix.zip"
set "STAGING_DIR=%TEMP%\butler_staging_area"

set "ROOT_FOLDER=%~dp0"
if "%ROOT_FOLDER:~-1%"=="\" set "ROOT_FOLDER=%ROOT_FOLDER:~0,-1%"
set "TARGET_GAME_DIR=%ROOT_FOLDER%\%SUBPATH_TO_GAME%"

:MAIN_MENU
cls
echo ========================================================
echo                    HYTALE UPDATER v2.0
echo                      (By @neronreal)
echo ========================================================
echo.
echo   Current Status: Ready
echo.
echo   [1] Install / Switch Game Version
echo   [2] Install / Switch Online-Fix
echo   [3] Exit
echo.
echo ========================================================
echo   Select option [1, 2, 3]...

choice /C 123 /N

if errorlevel 3 exit
if errorlevel 2 goto FIX_MENU
if errorlevel 1 goto VERSION_MENU
goto MAIN_MENU

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
echo.
echo   [B] Back
echo.
echo ========================================================
echo   Select version [1, 2] or [B]ack...
choice /C 12B /N

if errorlevel 3 goto MAIN_MENU
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
:: INSTALACJA GRY (PWR)
:: ========================================================
:INSTALL_GAME
cls
echo ---------------------------------------------------
echo  Installing Game: %SELECTED_NAME%
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
if not exist "%TARGET_GAME_DIR%" mkdir "%TARGET_GAME_DIR%"
if not exist "%STAGING_DIR%" mkdir "%STAGING_DIR%"

"%ROOT_FOLDER%\%BUTLER_EXE%" apply --staging-dir="%STAGING_DIR%" "%PATCH_FILE%" "%TARGET_GAME_DIR%"

if %errorlevel% neq 0 (
    echo [ERROR] Update failed.
    pause
    goto MAIN_MENU
)

:: Sprzatanie
if exist "%PATCH_FILE%" del "%PATCH_FILE%"
if exist "%STAGING_DIR%" rmdir /s /q "%STAGING_DIR%"

echo.
echo  [SUCCESS] Game installed successfully.
pause >nul
goto MAIN_MENU

:: ========================================================
:: INSTALACJA ONLINE FIX (ZIP)
:: ========================================================
:INSTALL_FIX
cls
echo ---------------------------------------------------
echo  INSTALLING: %SELECTED_FIX_NAME%
echo ---------------------------------------------------
echo.
echo  Destination: "%TARGET_GAME_DIR%"
echo.
echo  Overwrite existing files?
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
:: Rozpakowuje ZIP i nadpisuje istniejace pliki (-Force)
powershell -Command "Expand-Archive -Path '%FIX_ZIP%' -DestinationPath '%TARGET_GAME_DIR%' -Force"

if %errorlevel% neq 0 (
    echo [ERROR] Extraction failed.
    pause
    goto MAIN_MENU
)

:: Sprzatanie
if exist "%FIX_ZIP%" del "%FIX_ZIP%"

echo.
echo  [SUCCESS] %SELECTED_FIX_NAME% installed!
echo.
pause >nul
goto MAIN_MENU
