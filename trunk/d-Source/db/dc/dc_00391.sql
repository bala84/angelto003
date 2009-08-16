:r ./../_define.sql

:setvar dc_number 00391
:setvar dc_description "amount gived in warehouse list added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   20.11.2008 VLavrentiev  repairs fix
*******************************************************************************/ 
use [$(db_name)]
GO


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _drop_chis_all_objects.sql                         ='
PRINT '==============================================================================='
PRINT ' '
go

:r _drop_chis_all_objects.sql


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


update dbo.crpr_repair_type_master
set sys_status = 2
where short_name like '¿ ¡'
go


update dbo.crpr_repair_type_master
set sys_status = 1
where short_name like '¿ ¡'
and exists
(select 1 from dbo.ccar_ts_type_master as b
 where b.id = dbo.crpr_repair_type_master.id
	and b.car_mark_id is not null)
go

update dbo.crpr_repair_type_master
set repair_type_master_kind_id = 412
where not exists (select 1 from dbo.ccar_ts_type_master as b
					where b.id = dbo.crpr_repair_type_master.id)
go

update dbo.crpr_repair_type_master
set repair_type_master_kind_id = 410
where exists (select 1 from dbo.ccar_ts_type_master as b
					where b.id = dbo.crpr_repair_type_master.id)
go


update dbo.crpr_repair_type_master
set repair_type_master_kind_id = 411
where exists (select 1 from dbo.ccar_ts_type_master as b
					where b.id = dbo.crpr_repair_type_master.id)
  and (short_name like '¿ ¡' or short_name like '«‡ÏÂÌ‡ ÂÁËÌ˚')

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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

:r _add_chis_all_objects.sql
