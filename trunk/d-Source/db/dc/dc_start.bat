REM Version 1.1 (02.02.2007)
rem @echo off

setlocal
setlocal enabledelayedexpansion

set SCRIPT_DIR=%~d0%~p0

set CONF_DIR=%SCRIPT_DIR%..\
set ENV_FILE=%CONF_DIR%env.cmd

call %ENV_FILE%
call %CONF_DIR%recreate_define.sql.cmd

set NON_INTERACTIVE=true

set LOG_DIR=%SCRIPT_DIR%

if not exist "%LOG_DIR%" (
  mkdir "%LOG_DIR%"
)

if "%1" == "" (
  set USERS_FILE=%SCRIPT_DIR%\dc.default
  for /F "eol=; tokens=1-28" %%a in (!USERS_FILE!) do (
  set DC_NAME=%%a
echo.
echo.******************************************************
echo.  Starting !DC_NAME! script ...
echo.******************************************************
echo"F:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd" -S %SQL_SERVER_NAME% -U %SQL_DB_OWNER_USER% -P %SQL_DB_OWNER_USER_PWD% -i !DC_NAME! -o %LOG_DIR%\!DC_NAME!.log
)
) else (

echo.
echo.******************************************************
echo.  Starting %1 script ...
echo.******************************************************
"F:\Program Files\Microsoft SQL Server\90\Tools\Binn\sqlcmd" -S %SQL_SERVER_NAME% -U %SQL_DB_OWNER_USER% -P %SQL_DB_OWNER_USER_PWD% -i %1 -o %LOG_DIR%\%1.log
)

endlocal
