@echo off

setlocal
setlocal enabledelayedexpansion

:: We use the for-loop to tokenize the args in a way to preserve the
:: string contents of the args. 'Standard' arg syntax will remove
:: certain delimiter characters inside args (e.g. '=').
for /f "tokens=1* delims= " %%A in ("%*") do (
    set COMMAND=%%A
    set OPTIONS=%%B
)

:: Locate the root file
call :FindRootFilePath
if not defined ROOT_FILE_PATH (
    echo ERROR: Can't find `rr.cfg`
    exit /b 1
)

:: Directory for the root file
for %%a in (%ROOT_FILE_PATH%) do set ROOT_FILE_DIR=%%~dpa

:: List of executable extensions
:: First entry empty to allow for explicit extension specification
set EXTENSIONS[0]= 
set EXTENSIONS[1]=.bat
set EXTENSIONS[2]=.cmd
set EXTENSIONS[3]=.exe

:: Parse the root file looking for paths
for /f %%a in (%ROOT_FILE_PATH%) do (
    set COMMAND_DIR=%ROOT_FILE_DIR%%%a

    :: Search for a valid path/command/extension mix
    for /f "tokens=2 delims==" %%s in ('set EXTENSIONS[') do (
        set COMMAND_PATH=!COMMAND_DIR!\%COMMAND%%%s
        if exist !COMMAND_PATH! (

            :: Launch and return the error code
            if defined USE_START (
                start !COMMAND_PATH! %OPTIONS%
            ) else (
                call !COMMAND_PATH! %OPTIONS%
            )
            exit /b %ERRORLEVEL%
        )
    )
)

echo Command %COMMAND% not found
exit /b 1

:FindRootFilePath

    :: Walk up parent directories lookup for root file
    set SEARCH_PATH=%cd%
    :WhileTrue

        :: Exit search at drive root
        if %SEARCH_PATH:~0,3% == %SEARCH_PATH% (
            set ROOT_FILE_PATH=
            exit /b
        )

        :: Check to see if the root file can be found at this level
        set ROOT_FILE_PATH=%SEARCH_PATH%\rr.cfg
        if exist %ROOT_FILE_PATH% (
            exit /b
        )

        :: Hack to get drive and directory
        for %%a in (%SEARCH_PATH%) do set SEARCH_PATH=%%~dpa

        :: Remove any trailing slashes
        if %SEARCH_PATH:~-1%==\ SET SEARCH_PATH=%SEARCH_PATH:~0,-1%

        goto :WhileTrue

    exit /b

