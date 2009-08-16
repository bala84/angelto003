:r ./../_define.sql

:setvar dc_number 00191
:setvar dc_description "report_type_detail fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    14.04.2008 VLavrentiev  report_type_detail fixed
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


alter table dbo.CRPR_REPAIR_TYPE_DETAIL
drop constraint crpr_repair_type_detail_pk
go

alter table dbo.CRPR_REPAIR_TYPE_DETAIL
drop column id
go

alter table dbo.CRPR_REPAIR_TYPE_DETAIL
add id numeric(38,0) identity(1000,1)
go

alter table dbo.CRPR_REPAIR_TYPE_DETAIL
add constraint crpr_repair_type_detail_pk
primary key (id)
on $(fg_idx_name)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ָה',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'id'
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

