:r ./../_define.sql

:setvar dc_number 00361
:setvar dc_description "driver list fields fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    15.08.2008 VLavrentiev  driver list fields fixed
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go



alter table dbo.CDRV_DRIVER_LIST
alter column organization_id numeric(38,0)
go

alter table dbo.CDRV_DRIVER_LIST
alter column driver_list_type_id numeric(38,0)
go

alter table dbo.CREP_DRIVER_LIST
alter column organization_id numeric(38,0)
go

alter table dbo.CREP_DRIVER_LIST
alter column driver_list_type_id numeric(38,0)
go

alter table dbo.CREP_DRIVER_LIST
alter column organization_sname varchar(30)
go

alter table dbo.CREP_DRIVER_LIST
alter column driver_list_type_sname varchar(30)
go






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


