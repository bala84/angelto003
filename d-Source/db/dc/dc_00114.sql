:r ./../_define.sql

:setvar dc_number 00114                  
:setvar dc_description "full text on cars and persons added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    17.03.2008 VLavrentiev  full text on cars and persons added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go

SELECT GETDATE() as start_time
go

PRINT ' '
select SYSTEM_USER as "user"
go
PRINT ' '
go

/*
use [master]
go

ALTER DATABASE [$(db_name)] ADD FILEGROUP [$(db_name)_FT00]
GO

ALTER DATABASE [$(db_name)] ADD FILE (NAME = N'$(db_name)_ft00.ndf', FILENAME = N'$(dir_dat)$(db_name)_ft00.ndf', SIZE = 50, FILEGROWTH = 10)
TO FILEGROUP [$(db_name)_FT00]
GO

use [$(db_name)]
GO


PRINT ' '
PRINT 'creating PersonFTCat...'
go

CREATE FULLTEXT CATALOG PersonFTCat
ON FILEGROUP [$(db_name)_FT00]
go

PRINT ' '
PRINT 'creating FT index on  dbo.CPRT_PERSON...'
go

CREATE FULLTEXT INDEX ON dbo.CPRT_PERSON
     (name, lastname, surname)
     KEY INDEX cprt_person_pk
          ON PersonFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go


PRINT ' '
PRINT 'creating CarFTCat...'
go

CREATE FULLTEXT CATALOG CarFTCat
ON FILEGROUP [$(db_name)_FT00]
go

PRINT ' '
PRINT 'creating FT index on  dbo.CCAR_CAR...'
go

CREATE FULLTEXT INDEX ON dbo.CCAR_CAR
     (state_number)
     KEY INDEX ccar_car_pk
          ON CarFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go
*/

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Registering devchange                                              ='
PRINT '==============================================================================='
PRINT ' '
go

PRINT 'Registering devchange.'
go

INSERT INTO dbo.sys_dc ( m_number, m_date, m_description )
VALUES ( $(dc_number), GETDATE() , '$(dc_description)' )
go

PRINT ' '
SELECT GETDATE() as finish_time
go

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Script dc_$(dc_number).sql finished                                ='
PRINT '==============================================================================='
PRINT ' '
go
