/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a user with the DBA role on database.
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания пользователя владельца схемы ASE
 ================================================================================== */ 
use [master]
go

CREATE LOGIN [$(dba_user)] 
WITH PASSWORD=N'$(dba_user_pwd)'
,DEFAULT_DATABASE=[master]
,DEFAULT_LANGUAGE=[us_english] 
GO
EXEC sys.sp_addsrvrolemember @loginame = N'$(dba_user)', @rolename = N'sysadmin'
GO


