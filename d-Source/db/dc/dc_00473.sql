
:r ./../_define.sql

:setvar dc_number 00473
:setvar dc_description "car addtnl ts report overrun"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   10.06.2009 VLavrentiev   car addtnl ts report overrun
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_WRH_ADDTNL_TS_OVERRUN_SelectAll]
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
)
AS
BEGIN

	SET NOCOUNT ON

select a.state_number, e.short_name, e.repair_type_master_id, e.wrh_order_date_created, e.number
	  ,convert(decimal(18,0), e.wrh_order_run) as wrh_order_run
	  ,convert(decimal(18,0), f.run) as run
	  ,e.repair_type_master_kind_id
	  ,convert(decimal(18,0), ((e.wrh_order_run + e.periodicity) - f.run)) as overrun
from dbo.ccar_car as a
outer apply
	(select top(100)
		b.short_name, b.id as repair_type_master_id, d.date_created as wrh_order_date_created, d.run as wrh_order_run, g.repair_type_master_kind_id, b.periodicity, d.number
		from dbo.ccar_ts_type_master as b
		join dbo.crpr_repair_type_master as g
		    on b.id = g.id
		join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			on b.id = c.repair_type_master_id
		join dbo.cwrh_wrh_order_master as d
			on d.id = c.wrh_order_master_id
		where d.car_id = a.id
		  and (		d.order_state = 1
				or 	d.order_state = 4)
		  and g.repair_type_master_kind_id = dbo.usfConst('Дополнительное ТО')
		  and a.car_model_id = b.car_model_id
		  and d.date_created = (select max(date_created)
								 from dbo.cwrh_wrh_order_master  as d2
								 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c2
									on d2.id = c2.wrh_order_master_id
								where d2.car_id = d.car_id
								 and c2.repair_type_master_id = g.id)
		order by d.date_created desc) as e
join dbo.ccar_condition as f
	on a.id = f.car_id
where e.short_name is not null
  and a.sys_status = 1
  and (a.id = @p_car_id or @p_car_id is null)
  and (e.repair_type_master_id = @p_ts_type_master_id or @p_ts_type_master_id is null)
 
END

go


GRANT EXECUTE ON [dbo].[uspVREP_WRH_ADDTNL_TS_OVERRUN_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_ADDTNL_TS_OVERRUN_SelectAll] TO [$(db_app_user)]
GO



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




