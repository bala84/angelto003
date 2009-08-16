:r ./../_define.sql

:setvar dc_number 00336
:setvar dc_description "rep order master fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.07.2008 VLavrentiev  rep order master fixed#2
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным заказам-нарядам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date					  datetime
,@p_end_date					  datetime
,@p_car_mark_id					  numeric(38,0) = null
,@p_car_kind_id					  numeric(38,0) = null
,@p_car_id						  numeric(38,0) = null
,@p_employee_recieve_id			  numeric(38,0) = null
,@p_rpr_zone_d_employee_worker_id numeric(38,0) = null
,@p_employee_output_worker_id	  numeric(38,0) = null
,@p_employee_worker_id			  numeric(38,0) = null
,@p_repair_type_id				  numeric(38,0) = null
,@p_organization_id				  numeric(38,0) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,a.date_created
		,a.state_number
		,a.car_id
		,a.car_type_id
		,a.car_type_sname
		,a.car_state_id
		,a.car_state_sname
		,a.car_mark_id
		,a.car_mark_sname
		,a.car_model_id
		,a.car_model_sname
		,a.car_kind_id
		,a.car_kind_sname
		,a.employee_recieve_id
		,a.fio_employee_recieve
		,a.employee_head_id
		,a.fio_employee_head
		,a.employee_worker_id
		,a.fio_employee_worker
		,a.order_state
		,a.repair_type_id
		,a.malfunction_desc
		,a.repair_zone_master_id
		,a.date_started
		,a.date_ended
		,a.malfunction_disc
		,a.employee_output_worker_id
		,a.fio_employee_output_worker
		,a.wrh_order_master_type_id
		,a.wrh_order_master_type_sname
		,a.number
		,a.organization_id
		,a.organization_sname
		,a.id
	FROM dbo.utfVREP_WRH_ORDER_MASTER() as a
	left outer join dbo.CRPR_REPAIR_ZONE_DETAIL as b
		on a.repair_zone_master_id = b.repair_zone_master_id
	left outer join dbo.utfVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER() as c
		on a.id = c.wrh_order_master_id
	where a.date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	order by a.organization_sname, a.date_created, a.car_type_sname, a.car_mark_sname, a.state_number

	RETURN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным заказам-нарядам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date					  datetime
,@p_end_date					  datetime
,@p_car_mark_id					  numeric(38,0) = null
,@p_car_kind_id					  numeric(38,0) = null
,@p_car_id						  numeric(38,0) = null
,@p_employee_recieve_id			  numeric(38,0) = null
,@p_rpr_zone_d_employee_worker_id numeric(38,0) = null
,@p_employee_output_worker_id	  numeric(38,0) = null
,@p_employee_worker_id			  numeric(38,0) = null
,@p_repair_type_id				  numeric(38,0) = null
,@p_organization_id				  numeric(38,0) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,a.date_created
		,a.state_number
		,a.car_id
		,a.car_type_id
		,a.car_type_sname
		,a.car_state_id
		,a.car_state_sname
		,a.car_mark_id
		,a.car_mark_sname
		,a.car_model_id
		,a.car_model_sname
		,a.car_kind_id
		,a.car_kind_sname
		,a.employee_recieve_id
		,a.fio_employee_recieve
		,a.employee_head_id
		,a.fio_employee_head
		,a.employee_worker_id
		,a.fio_employee_worker
		,case when a.order_state = 0 then 'Открыт'
			  when a.order_state = 1 then 'Закрыт'
		  end as order_state
		,a.repair_type_id
		,a.malfunction_desc
		,a.repair_zone_master_id
		,a.date_started
		,a.date_ended
		,a.malfunction_disc
		,a.employee_output_worker_id
		,a.fio_employee_output_worker
		,a.wrh_order_master_type_id
		,a.wrh_order_master_type_sname
		,a.number
		,a.organization_id
		,a.organization_sname
		,a.id
		,d.short_name as repair_type_master_sname
		,b.work_desc
		,b.hour_amount
		,b.employee_worker_id as rpr_zone_detail_emp_worker_id
		,rtrim(f.lastname + ' ' + isnull(substring(f.name,1,1),'') + '. ' + isnull(substring(f.surname,1,1),'') + '.')
			as rpr_zone_detail_fio_emp_worker
	FROM dbo.utfVREP_WRH_ORDER_MASTER() as a
	left outer join dbo.CRPR_REPAIR_ZONE_DETAIL as b
		on a.repair_zone_master_id = b.repair_zone_master_id
	left outer join dbo.utfVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER() as c
		on a.id = c.wrh_order_master_id
	left outer join dbo.CRPR_REPAIR_TYPE_MASTER as d
		on d.id = c.repair_type_master_id
	left outer join dbo.CPRT_EMPLOYEE as e
		on b.employee_worker_id = e.id
	left outer join dbo.CPRT_PERSON as f
		on f.id = e.person_id
	where a.date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	order by a.date_created, a.organization_sname, a.car_type_sname, a.car_mark_sname, a.state_number
			,d.short_name
	RETURN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным заказам-нарядам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date					  datetime
,@p_end_date					  datetime
,@p_car_mark_id					  numeric(38,0) = null
,@p_car_kind_id					  numeric(38,0) = null
,@p_car_id						  numeric(38,0) = null
,@p_employee_recieve_id			  numeric(38,0) = null
,@p_rpr_zone_d_employee_worker_id numeric(38,0) = null
,@p_employee_output_worker_id	  numeric(38,0) = null
,@p_employee_worker_id			  numeric(38,0) = null
,@p_repair_type_id				  numeric(38,0) = null
,@p_organization_id				  numeric(38,0) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,a.date_created
		,a.state_number
		,a.car_id
		,a.car_type_id
		,a.car_type_sname
		,a.car_state_id
		,a.car_state_sname
		,a.car_mark_id
		,a.car_mark_sname
		,a.car_model_id
		,a.car_model_sname
		,a.car_kind_id
		,a.car_kind_sname
		,a.employee_recieve_id
		,a.fio_employee_recieve
		,a.employee_head_id
		,a.fio_employee_head
		,a.employee_worker_id
		,a.fio_employee_worker
		,case when a.order_state = 0 then 'Открыт'
			  when a.order_state = 1 then 'Закрыт'
		  end as order_state
		,a.repair_type_id
		,a.malfunction_desc
		,a.repair_zone_master_id
		,a.date_started
		,a.date_ended
		,a.malfunction_disc
		,a.employee_output_worker_id
		,a.fio_employee_output_worker
		,a.wrh_order_master_type_id
		,a.wrh_order_master_type_sname
		,a.number
		,a.organization_id
		,a.organization_sname
		,a.id
		,d.short_name as repair_type_master_sname
		,b.work_desc
		,b.hour_amount
		,b.employee_worker_id as rpr_zone_detail_emp_worker_id
		,rtrim(f.lastname + ' ' + isnull(substring(f.name,1,1),'') + '. ' + isnull(substring(f.surname,1,1),'') + '.')
			as rpr_zone_detail_fio_emp_worker
	FROM dbo.utfVREP_WRH_ORDER_MASTER() as a
	left outer join dbo.CRPR_REPAIR_ZONE_DETAIL as b
		on a.repair_zone_master_id = b.repair_zone_master_id
	left outer join dbo.utfVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER() as c
		on a.id = c.wrh_order_master_id
	left outer join dbo.CRPR_REPAIR_TYPE_MASTER as d
		on d.id = c.repair_type_master_id
	left outer join dbo.CPRT_EMPLOYEE as e
		on b.employee_worker_id = e.id
	left outer join dbo.CPRT_PERSON as f
		on f.id = e.person_id
	where a.date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	order by a.date_created, a.organization_sname, a.car_type_sname, a.car_mark_sname, a.state_number
			--,d.short_name
	RETURN
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

