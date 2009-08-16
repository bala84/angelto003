@echo off

rem !!Remember to set trailing \!!

if "%ENV_ALREADY_PROCESSED%" == "true" (
goto end
)

REM set SCRIPT_DIR=%~d0%~p0

set SQL_SERVER_NAME=POLUS-LAPTOP
set SQL_INSTANCE_NAME=
set SQL_DB_NAME=ANGEL_TO_001_TEST4
set SQL_DBA_USER=ANGEL_TO_001_DEV_ADMIN
set SQL_DBA_USER_PWD=ANGEL_TO_001_DEV_ADMIN1
set SQL_DB_OWNER_USER=ANGEL_TO_001_TEST_OWNER2
set SQL_DB_OWNER_USER_PWD=ANGEL_TO_001_TEST_OWNER21
set SQL_DB_APP_USER=ANGEL_TO_001_TEST_OWNER2
set SQL_DB_APP_USER_PWD=ANGEL_TO_001_TEST_OWNER21
set SQL_DB_DC_USER=ANGEL_TO_001_TEST_DC
set SQL_DB_DC_USER_PWD=ANGEL_TO_001_TEST_DC1
set SQL_SCRIPT_DIR=%SCRIPT_DIR%
set SQL_FG_IDX_NAME=ANGEL_TO_001_TEST_IDX
set SQL_FG_DAT_NAME=ANGEL_TO_001_TEST_DAT
set SQL_FG_FT_NAME=ANGEL_TO_001_DEV_FT00
set SQL_FG_TXT_NAME=ANGEL_TO_001_DEV_TXT
rem **********************************************************
rem *                  MSSQL                                 *
rem **********************************************************
rem set __MSSQL="F:\PROGRA~1\MI6841~1"
set SQL_DIR_DAT="F:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_IDX="F:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_TXT="F:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
set SQL_DIR_LOG="F:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"

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