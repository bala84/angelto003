
:r ./../_define.sql

:setvar dc_number 00474
:setvar dc_description "car overrun ts fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.06.2009 VLavrentiev   car overrun ts fix
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


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WRH_ADDTNL_TS_OVERRUN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет о перепробеге по доп. то
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.06.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

(
  @p_car_id		numeric(38,0) = null
 ,@p_ts_type_master_id  numeric (38,0) = null
 ,@p_car_mark_id        numeric (38,0) = null
)
AS
BEGIN

	SET NOCOUNT ON

select a.state_number, e.short_name + ' - ' + l.short_name + ' - ' + m.short_name as short_name, e.repair_type_master_id
	  ,convert(varchar(10),e.wrh_order_date_created, 104) + ' ' + convert(varchar(5),e.wrh_order_date_created, 108) as wrh_order_date_created, e.number
	  ,convert(decimal(18,0), e.wrh_order_run) as wrh_order_run
	  ,convert(decimal(18,0), f.run) as run
	  ,e.repair_type_master_kind_id
	  ,convert(decimal(18,0), (f.run - (e.wrh_order_run + e.periodicity))) as overrun
from dbo.ccar_car as a
outer apply
	(select 
		max(a.short_name) as short_name
		,a.repair_type_master_id
	        ,max(a.wrh_order_date_created) as wrh_order_date_created
		,max(a.wrh_order_run) as wrh_order_run
		,max(a.repair_type_master_kind_id) as repair_type_master_kind_id
		,max(a.periodicity) as periodicity
		,max(a.number) as number
		from
		(select b.short_name, b.id as repair_type_master_id, d.date_created as wrh_order_date_created, d.run as wrh_order_run, g.repair_type_master_kind_id, b.periodicity, d.number
		from dbo.ccar_ts_type_master as b
		join dbo.crpr_repair_type_master as g
		    on b.id = g.id
		join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			on b.id = c.repair_type_master_id
		join dbo.cwrh_wrh_order_master as d
			on d.id = c.wrh_order_master_id
		where d.car_id = a.id
		  and (		d.order_state = 1
				or 	d.order_state = 4
				or 	d.order_state = 6)
		  and g.repair_type_master_kind_id = dbo.usfConst('Дополнительное ТО')
		  and a.car_model_id = b.car_model_id
		  and d.date_created = (select max(date_created)
								 from dbo.cwrh_wrh_order_master  as d2
								 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c2
									on d2.id = c2.wrh_order_master_id
								where d2.car_id = d.car_id
								 and c2.repair_type_master_id = g.id
								 and d2.order_state = d.order_state)) as a
		group by a.repair_type_master_id) as e
join dbo.ccar_condition as f
	on a.id = f.car_id
join dbo.ccar_car_mark as l
	on a.car_mark_id = l.id
join dbo.ccar_car_model as m
	on a.car_model_id = m.id
where e.short_name is not null
  and a.sys_status = 1
  and (a.id = @p_car_id or @p_car_id is null)
  and (e.repair_type_master_id = @p_ts_type_master_id or @p_ts_type_master_id is null)
  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
order by l.short_name, m.short_name, a.state_number asc
 
END

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




