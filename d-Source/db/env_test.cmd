@echo off

rem !!Remember to set trailing \!!

if "%ENV_ALREADY_PROCESSED%" == "true" (
goto end
)

REM set SCRIPT_DIR=%~d0%~p0

set SQL_SERVER_NAME=192.168.144.244
set SQL_INSTANCE_NAME=
set SQL_DB_NAME=ANGEL_TO_001_TEST5
set SQL_DBA_USER=Jego
set SQL_DBA_USER_PWD=1
set SQL_DB_OWNER_USER=ANGEL_TO_001_TEST_OWNER4
set SQL_DB_OWNER_USER_PWD=ANGEL_TO_001_TEST_OWNER41
set SQL_DB_APP_USER=ANGEL_TO_001_TEST_AU
set SQL_DB_APP_USER_PWD=ANGEL_TO_001_TEST_AU1
set SQL_DB_DC_USER=ANGEL_TO_001_TEST_DC
set SQL_DB_DC_USER_PWD=ANGEL_TO_001_TEST_DC1
set SQL_SCRIPT_DIR=%SCRIPT_DIR%
set SQL_FG_IDX_NAME=ANGEL_TO_001_TEST_IDX
set SQL_FG_DAT_NAME=ANGEL_TO_001_TEST_DAT
set SQL_FG_FT_NAME=ANGEL_TO_001_TEST_FT00
set SQL_FG_TXT_NAME=ANGEL_TO_001_TEST_TXT
rem **********************************************************
rem *                  MSSQL                                 *
rem **********************************************************
rem set __MSSQL="C:\PROGRA~1\MI6841~1"
set SQL_DIR_DAT="C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_IDX="C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_TXT="C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_LOG="C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"

set ENV_ALREADY_PROCESSED=true
echo ------------------------------------------------
echo Configuration:
echo SQL_SERVER_NAME=%SQL_SERVER_NAME%
echo SQL_DB_NAME=%SQL_DB_NAME%
echo ------------------------------------------------

if not "%NON_INTERACTIVE%" == "true" (
pause
)

if exist %SCRIPT_DIR%recreate_define.sql.cmd (
%SCRIPT_DIR%recreate_define.sql.cmd
)

:end 