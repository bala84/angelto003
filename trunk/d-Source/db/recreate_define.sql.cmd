@echo off

rem 
rem Syntax: recreate_define.sql.cmd
rem 
rem example: call recreate_define.sql.cmd
rem 

setlocal

set SCRIPT_DIR=%~d0%~p0

rem Uncomment this for confirmation before starting any action
set NON_INTERACTIVE=true

rem Remember to set trailing '\'
set CONF_DIR=%SCRIPT_DIR%
set ENV_FILE=%CONF_DIR%.\env.cmd

rem process replication settings file
call %ENV_FILE%

set DEFINE_FN=%CONF_DIR%\_define.sql

echo :setvar server_name %SQL_SERVER_NAME%>%DEFINE_FN%
echo :setvar instance_name %SQL_INSTANCE_NAME%>>%DEFINE_FN%
echo :setvar db_name %SQL_DB_NAME%>>%DEFINE_FN%
echo :setvar dba_user %SQL_DBA_USER%>>%DEFINE_FN%
echo :setvar dba_user_pwd %SQL_DBA_USER_PWD%>>%DEFINE_FN%
echo :setvar db_owner_user %SQL_DB_OWNER_USER%>>%DEFINE_FN%
echo :setvar db_owner_user_pwd %SQL_DB_OWNER_USER_PWD%>>%DEFINE_FN%
echo :setvar db_app_user %SQL_DB_APP_USER%>>%DEFINE_FN%
echo :setvar db_app_user_pwd %SQL_DB_APP_USER_PWD%>>%DEFINE_FN%
echo :setvar db_dc_user %SQL_DB_DC_USER%>>%DEFINE_FN%
echo :setvar db_dc_user_pwd %SQL_DB_DC_USER_PWD%>>%DEFINE_FN%
echo :setvar file_script_dir %SQL_SCRIPT_DIR%>>%DEFINE_FN%
echo :setvar dir_dat  %SQL_DIR_DAT%>>%DEFINE_FN%
echo :setvar dir_idx  %SQL_DIR_IDX%>>%DEFINE_FN%
echo :setvar dir_txt  %SQL_DIR_TXT%>>%DEFINE_FN%
echo :setvar dir_log  %SQL_DIR_LOG%>>%DEFINE_FN%
echo :setvar fg_idx_name  %SQL_FG_IDX_NAME%>>%DEFINE_FN%
echo :setvar fg_dat_name  %SQL_FG_DAT_NAME%>>%DEFINE_FN%
echo :setvar fg_ft_name  %SQL_FG_FT_NAME%>>%DEFINE_FN%
echo :setvar fg_txt_name  %SQL_FG_TXT_NAME%>>%DEFINE_FN%
endlocal
