/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DBA user 
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 09.02.2007    VLavrentiev    Скрипт для создания БД ANGEL-TO-001
 ================================================================================== */ 


use [master]
go

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'$(db_name)')
  CREATE DATABASE [$(db_name)]  
    ON 
  PRIMARY 
(NAME = N'$(db_name)_dat00'
  , FILENAME = N'$(dir_dat)$(db_name)_dat00.mdf', SIZE = 50, FILEGROWTH = 10) 
, FILEGROUP [$(db_name)_DAT] 
(NAME = N'$(db_name)_dat01'
  , FILENAME = N'$(dir_dat)$(db_name)_dat01.ndf', SIZE = 1, FILEGROWTH = 10) 
, FILEGROUP [$(db_name)_IDX] 
(NAME = N'$(db_name)_idx01'
  , FILENAME = N'$(dir_idx)$(db_name)_idx01.ndf', SIZE = 1, FILEGROWTH = 10) 
, FILEGROUP [$(db_name)_TXT] 
(NAME = N'$(db_name)_txt01'
  , FILENAME = N'$(dir_txt)$(db_name)_txt01.ndf', SIZE = 1, FILEGROWTH = 10) 
 LOG ON (NAME = N'$(db_name)_log', FILENAME = N'$(dir_log)$(db_name)_log.ldf', SIZE = 1, MAXSIZE = 2000000, FILEGROWTH = 10%)
GO

ALTER DATABASE [$(db_name)] 
MODIFY FILEGROUP [$(db_name)_DAT] default
GO


                                                                   

EXEC dbo.sp_dbcmptlevel @dbname=N'$(db_name)', @new_cmptlevel=90
GO

ALTER DATABASE [$(db_name)] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [$(db_name)] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [$(db_name)] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [$(db_name)] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [$(db_name)] SET ARITHABORT OFF 
GO
ALTER DATABASE [$(db_name)] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [$(db_name)] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [$(db_name)] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [$(db_name)] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [$(db_name)] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [$(db_name)] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [$(db_name)] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [$(db_name)] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [$(db_name)] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [$(db_name)] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [$(db_name)] SET ENABLE_BROKER 
GO
ALTER DATABASE [$(db_name)] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [$(db_name)] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [$(db_name)] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [$(db_name)] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [$(db_name)] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [$(db_name)] SET READ_WRITE 
GO
ALTER DATABASE [$(db_name)] SET RECOVERY FULL 
GO
ALTER DATABASE [$(db_name)] SET MULTI_USER 
GO
ALTER DATABASE [$(db_name)] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [$(db_name)] SET DB_CHAINING OFF 
GO