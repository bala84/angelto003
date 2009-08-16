:r ./../_define.sql
:setvar dc_number 00062
:setvar dc_description "VDRV_DRIVER_LIST save fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.02.2008 VLavrentiev  VDRV_DRIVER_LIST save fixed#2   
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



alter table dbo.CDRV_DRIVER_CONTROL
drop CDRV_DRIVER_CONTROL_DRV_LIST_ID_FK
go

alter table dbo.CDRV_TRAILER
drop CDRV_TRAILER_DRIVER_LIST_ID_FK
go


alter table dbo.CDRV_DRIVER_LIST
drop cdrv_driver_list_pk
go

alter table dbo.CDRV_DRIVER_LIST
drop column id
go


alter table dbo.CDRV_DRIVER_LIST
add id numeric(38,0) identity(1000,1)
go



alter table dbo.CDRV_DRIVER_LIST
   add constraint cdrv_driver_list_pk primary key (id)
      on $(db_name)_idx
go




declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ָה',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'id'
go


alter table dbo.CDRV_TRAILER
   add constraint CDRV_TRAILER_DRIVER_LIST_ID_FK foreign key (driver_list_id)
      references CDRV_DRIVER_LIST (id)
go

alter table dbo.CDRV_DRIVER_CONTROL
   add constraint CDRV_DRIVER_CONTROL_DRV_LIST_ID_FK foreign key (driver_list_id)
      references CDRV_DRIVER_LIST (id)
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
