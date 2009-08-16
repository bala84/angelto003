:r ./../_define.sql

:setvar dc_number 00360
:setvar dc_description "car states added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.08.2008 VLavrentiev  car states added
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


set identity_insert dbo.CCAR_CAR_STATE on
go

insert into dbo.CCAR_CAR_STATE (id, short_name, full_name)
values (302, 'На линии', 'На линии')
go

insert into dbo.CCAR_CAR_STATE (id, short_name, full_name)
values (303, 'На стоянке', 'На стоянке')
go

set identity_insert dbo.CCAR_CAR_STATE off
go



alter table dbo.CPRT_EMPLOYEE
add driver_license varchar(100)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Удостоверение водителя',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'driver_license'
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


