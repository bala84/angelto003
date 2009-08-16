:r ./../_define.sql
:setvar dc_number 00052
:setvar dc_description "TS_TYPE_MASTER tables fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.02.2008 VLavrentiev  TS_TYPE_MASTER tables fixed   
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

alter table dbo.CCAR_TS_TYPE_DETAIL
drop ccar_ts_type_detail_pk
go

alter table dbo.CCAR_TS_TYPE_DETAIL
drop column id
go


alter table dbo.CCAR_TS_TYPE_DETAIL
add id numeric(38,0) identity(1000,1)
go

alter table dbo.CCAR_TS_TYPE_DETAIL
drop CCAR_TS_TYPE_DETAL_MASTER_ID_FK
go

alter table dbo.CCAR_CONDITION
drop CCAR_CNDTN_TS_TYPE_MASTER_ID_FK
go

alter table dbo.CCAR_TS_TYPE_DETAIL
   add constraint ccar_ts_type_detail_pk primary key (id)
      on $(db_name)_idx
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ָה',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'id'
go


alter table dbo.CCAR_TS_TYPE_MASTER
drop ccar_ts_type_master_pk
go

alter table dbo.CCAR_TS_TYPE_MASTER
drop column id
go


alter table dbo.CCAR_TS_TYPE_MASTER
add id numeric(38,0) identity(1000,1)
go


alter table dbo.CCAR_TS_TYPE_MASTER
   add constraint ccar_ts_type_master_pk primary key (id)
      on $(db_name)_idx
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ָה',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'id'
go


alter table dbo.CCAR_TS_TYPE_DETAIL
   add constraint CCAR_TS_TYPE_DETAL_MASTER_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
go

alter table dbo.CCAR_CONDITION
   add constraint CCAR_CNDTN_TS_TYPE_MASTER_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
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
