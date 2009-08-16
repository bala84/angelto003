/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DBA user 
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания пользователей БД
 ================================================================================== */ 
use[master]
go



PRINT ' '
PRINT 'Creating db owner user...'
go

CREATE LOGIN [$(db_owner_user)] WITH PASSWORD=N'$(db_owner_user_pwd)' 
,DEFAULT_DATABASE=[$(db_name)]
,DEFAULT_LANGUAGE=[us_english]
GO
USE [$(db_name)]
GO
CREATE USER [$(db_owner_user)] FOR LOGIN [$(db_owner_user)]
GO
EXEC sp_addrolemember N'db_owner', N'$(db_owner_user)'
GO


ALTER USER [$(db_owner_user)] WITH DEFAULT_SCHEMA=[dbo]
GO



PRINT ' '
PRINT 'Creating db app user...'
go

CREATE LOGIN [$(db_app_user)] WITH PASSWORD=N'$(db_app_user_pwd)' 
,DEFAULT_DATABASE=[$(db_name)]
,DEFAULT_LANGUAGE=[us_english]
GO
CREATE USER [$(db_app_user)] FOR LOGIN [$(db_app_user)]
GO

EXEC sp_addrolemember N'db_datareader', N'$(db_app_user)'
GO

EXEC sp_addrolemember N'db_datawriter', N'$(db_app_user)'
GO

ALTER USER [$(db_app_user)] WITH DEFAULT_SCHEMA=[dbo]
GO
