@echo off

setlocal

set SCRIPT_DIR=%~d0%~p0

rem Uncomment this for confirmation before starting any action
set NON_INTERACTIVE=true

rem Remember to set trailing '\'
set CONF_DIR=%SCRIPT_DIR%
set ENV_FILE=%CONF_DIR%env_home.cmd
set RESTART_FILE=%CONF_DIR%restart_server.cmd

rem process replication settings file
call %ENV_FILE%


sqlcmd -S %SQL_SERVER_NAME%%SQL_INSTANCE_NAME% ^
       -U %SQL_DBA_USER% ^
       -P %SQL_DBA_USER_PWD% ^
       -v file_script_dir = "%SQL_SCRIPT_DIR%" ^
       -i %SCRIPT_DIR%install.sql ^
       -o %SCRIPT_DIR%install.log


endlocal
