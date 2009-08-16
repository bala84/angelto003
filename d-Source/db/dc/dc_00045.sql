:r ./../_define.sql
:setvar dc_number 00045
:setvar dc_description "FUEL_MODEL id fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.02.2008 VLavrentiev  FUEL_MODEL id fixed   
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


alter table dbo.CCAR_FUEL_MODEL
drop ccar_fuel_model_pk
go

alter table dbo.CCAR_FUEL_MODEL
drop column id
go


alter table dbo.CCAR_FUEL_MODEL
add id numeric(38,0) identity(1000,1)
go


alter table dbo.CCAR_FUEL_MODEL
   add constraint ccar_fuel_model_pk primary key (id)
      on $(db_name)_idx
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ָה',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'id'
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
