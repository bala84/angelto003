
:r ./../_define.sql

:setvar dc_number 00468
:setvar dc_description "wrh order master fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.05.2009 VLavrentiev   wrh order master fix
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
	where a.date_created >=   dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	order by a.date_created, a.organization_id, a.state_number
			--,d.short_name
	RETURN
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
			  when a.order_state = 2 then 'Взят на ремонт, сведений о необх. запчастях нет'
			  when a.order_state = 3 then 'Взят на ремонт, есть сведения о необх. запчастях'
			  when a.order_state = 4 then 'Обработан'
			  when a.order_state = 5 then 'Отклонен'
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
	where a.date_created >=   dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and a.order_state != 6
	order by a.date_created, a.organization_id, a.state_number
			--,d.short_name
	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
,@p_state_number				  varchar(30)   = null
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
			  when a.order_state = 2 then 'Взят на ремонт, сведений о необх. запчастях нет'
			  when a.order_state = 3 then 'Взят на ремонт, есть сведения о необх. запчастях'
			  when a.order_state = 4 then 'Обработан'
			  when a.order_state = 5 then 'Отклонен'
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
	where a.date_created >=   dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	  and a.order_state != 6
	order by a.date_created, a.organization_id, a.state_number
			--,d.short_name
	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go








ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_wrh_demand_master_type_id numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id	numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
,@p_state_number	varchar(30)   = null
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.car_type_id
			,a.car_mark_id
			,a.car_model_id
			,a.number
			,a.date_created
			,a.employee_recieve_id
			,a.employee_recieve_fio
			,a.employee_head_id
			,a.employee_head_fio
			,a.employee_worker_id
			,a.employee_worker_fio
			,a.organization_recieve_id
			,a.organization_head_id
			,a.organization_worker_id
			,a.car_kind_id
			,a.organization_giver_id
			,a.organization_giver_sname
			,case when a.wrh_income_detail_id is not null
				  then case when c.account_type = 1
							then convert(decimal(18,2), b.total/b.amount)*a.amount
						    else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
					    end 
				  else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
			  end as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created_str
	        ,a.is_verified
	FROM dbo.utfVREP_WRH_DEMAND() as a
	left outer join dbo.cwrh_wrh_income_detail as b
		on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
		on b.wrh_income_master_id = c.id
	where a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	  and isnull(c.is_verified, 1) != 2
	order by a.organization_giver_sname, a.state_number, a.date_created, a.number

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_WRH_INCOME_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные для отчета о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_organization_id	numeric(38,0) = null
,@p_organization_recieve_id	numeric(38,0) = null
,@p_good_category_id	numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON
  
       SELECT  
		   a.number
		  ,a.organization_id
		  ,a.organization_name 
		  ,a.warehouse_type_id
		  ,a.warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,a.organization_recieve_name
		  ,case when a.account_type = 1
				then convert(decimal(18,2),a.total) 
				else convert(decimal(18,2),(convert(decimal(18,2),a.price*0.18) + convert(decimal(18,2),a.price))*a.amount)
		    end as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,case when a.account_type = 1
				then convert(decimal(18,2), a.total/a.amount)
				else
				convert(decimal(18,2),a.price*0.18) + convert(decimal(18,2),a.price) 
			 end as price
		  ,convert(decimal(18,2),a.amount) as amount
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created_str
	    ,a.is_verified
	FROM utfVREP_WRH_INCOME_MASTER() as a
	WHERE   date_created >= dbo.usfUtils_TimeToZero(@p_start_date)
	  and   date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	 -- and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (a.organization_recieve_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_sname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	ORDER BY a.organization_recieve_id, a.warehouse_type_id,a.date_created, a.number

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name](@p_id numeric(38,0))
RETURNS varchar(512)
AS
BEGIN
  declare
    @v_stmt varchar(512) 
   ,@v_tmp_stmt varchar(30)
   ,@i int
declare
shrt_name_cur cursor for
SELECT TOP(100) PERCENT c.short_name
				FROM dbo.cwrh_wrh_order_master as a 
				join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
				join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
				WHERE a.sys_status = 1
				--  and a.order_state = 1
				  and b.sys_status = 1
				  and c.sys_status = 1
				  and a.id = @p_id
	   ORDER BY c.short_name

begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt

set @i = 1
 set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
	 
      set @v_stmt = @v_tmp_stmt
     else
	  set @v_stmt = @v_stmt + ', ' + @v_tmp_stmt

fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create FUNCTION [dbo].[usfRRP_REPAIR_ZONE_Select_work_desc_By_rpr_zone_master_id](@p_repair_zone_master_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select work_desc
		from dbo.CRPR_REPAIR_ZONE_DETAIL
where repair_zone_master_id = @p_repair_zone_master_id
order by id asc


begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt


set @i = 1
set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
      set @v_stmt = ' ' + @v_tmp_stmt
	else
	  set @v_stmt = @v_stmt + CHAR(13) + ',' + @v_tmp_stmt


fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create FUNCTION [dbo].[usfRRP_REPAIR_ZONE_Select_hr_amount_By_rpr_zone_master_id](@p_repair_zone_master_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select convert(varchar(20), convert(decimal(18,2), hour_amount))
		from dbo.CRPR_REPAIR_ZONE_DETAIL
where repair_zone_master_id = @p_repair_zone_master_id
order by id asc


begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt


set @i = 1
set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
      set @v_stmt = ' ' + isnull(@v_tmp_stmt, '')
	else
	  set @v_stmt = @v_stmt + CHAR(13) + ',' + isnull(@v_tmp_stmt, '')


fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create FUNCTION [dbo].[usfRRP_REPAIR_ZONE_Select_worker_By_rpr_zone_master_id](@p_repair_zone_master_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select rtrim(f.lastname + ' ' + isnull(substring(f.name,1,1),'') + '. ' + isnull(substring(f.surname,1,1),'') + '.')
		from dbo.CRPR_REPAIR_ZONE_DETAIL as a
		 left outer join dbo.CPRT_EMPLOYEE as e
		    on a.employee_worker_id = e.id
		left outer join dbo.CPRT_PERSON as f
			on e.person_id = f.id
where a.repair_zone_master_id = @p_repair_zone_master_id
order by a.id asc


begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt


set @i = 1
set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
      set @v_stmt = ' ' + isnull(@v_tmp_stmt, '')
	else
	  set @v_stmt = @v_stmt + CHAR(13) + ',' + isnull(@v_tmp_stmt, '')


fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVREP_WRH_ORDER_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по заказам-нарядам
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
SELECT
		 id
		,date_created
		,state_number
		,car_id
		,car_type_id
		,car_type_sname
		,car_state_id
		,car_state_sname
		,car_mark_id
		,car_mark_sname
		,car_model_id
		,car_model_sname
		,car_kind_id
		,car_kind_sname
		,employee_recieve_id
		,fio_employee_recieve
		,employee_head_id
		,fio_employee_head
		,employee_worker_id
		,fio_employee_worker
		,order_state
		,repair_type_id
		,repair_type_sname
		,malfunction_desc
		,repair_zone_master_id
		,date_started
		,date_ended
		,malfunction_disc
		,employee_output_worker_id
		,fio_employee_output_worker
		,wrh_order_master_type_id
		,wrh_order_master_type_sname
		,number 
		,organization_id
		,organization_sname
FROM	
(SELECT 
		 a.id
		,a.date_created
		,b.state_number
		,a.car_id
		,b.car_type_id
		,c.short_name as car_type_sname
		,b.car_state_id
		,d.short_name as car_state_sname
		,b.car_mark_id
		,e.short_name as car_mark_sname
		,b.car_model_id
		,f.short_name as car_model_sname
		,b.car_kind_id
		,g.short_name as car_kind_sname
		,a.employee_recieve_id
		,rtrim(i1.lastname + ' ' + isnull(substring(i1.name,1,1),'') + '. ' + isnull(substring(i1.surname,1,1),'') + '.') as fio_employee_recieve
		,a.employee_head_id
		,rtrim(i2.lastname + ' ' + isnull(substring(i2.name,1,1),'') + '. ' + isnull(substring(i2.surname,1,1),'') + '.') as fio_employee_head
		,a.employee_worker_id
		,rtrim(i3.lastname + ' ' + isnull(substring(i3.name,1,1),'') + '. ' + isnull(substring(i3.surname,1,1),'') + '.') as fio_employee_worker
		,a.order_state
		,j.repair_type_master_id as repair_type_id
		,n.short_name as repair_type_sname
		,a.malfunction_desc
		,a.repair_zone_master_id
		,k.date_started
		,k.date_ended
		,k.malfunction_disc
		,a.employee_output_worker_id
		,rtrim(i4.lastname + ' ' + isnull(substring(i4.name,1,1),'') + '. ' + isnull(substring(i4.surname,1,1),'') + '.') as fio_employee_output_worker
		,a.wrh_order_master_type_id
		,l.short_name as wrh_order_master_type_sname
		,a.number 
		,b.organization_id
		,m.name as organization_sname
from dbo.CWRH_WRH_ORDER_MASTER as a
left outer join dbo.ccar_car as b
  on a.car_id = b.id
left outer join dbo.ccar_car_type as c
  on b.car_type_id = c.id
left outer join dbo.ccar_car_state as d
  on b.car_state_id = d.id
left outer join dbo.ccar_car_mark as e
  on b.car_mark_id = e.id
left outer join dbo.ccar_car_model as f
  on b.car_model_id = f.id
left outer join dbo.ccar_car_kind as g
  on b.car_kind_id = g.id
left outer join dbo.cprt_employee as h1
 on a.employee_recieve_id = h1.id
left outer join dbo.cprt_person as i1
 on h1.person_id = i1.id
left outer join dbo.cprt_employee as h2
 on a.employee_head_id = h2.id
left outer join dbo.cprt_person as i2
 on h2.person_id = i2.id
left outer join dbo.cprt_employee as h3
 on a.employee_worker_id = h3.id
left outer join dbo.cprt_person as i3
 on h3.person_id = i3.id
left outer join dbo.cprt_employee as h4
 on a.employee_output_worker_id = h4.id
left outer join dbo.cprt_person as i4
 on h4.person_id = i4.id
left outer join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as j
 on a.id = j.wrh_order_master_id
left outer join dbo.CRPR_REPAIR_ZONE_MASTER as k
 on a.repair_zone_master_id = k.id
left outer join dbo.CWRH_WRH_ORDER_MASTER_TYPE as l
 on a.wrh_order_master_type_id = l.id
left outer join dbo.cprt_organization as m
 on b.organization_id = m.id
left outer join dbo.crpr_repair_type_master as n
 on j.repair_type_master_id = n.id) as a
)

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
,@p_state_number				  varchar(30)   = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  --set @p_start_date = dateadd("Hh", -4, @p_start_date)
  --set @p_end_date = dateadd("Hh", -4, @p_end_date)
select
		 month_created
		,date_created
		,state_number
		,car_id
		,car_type_id
		,car_type_sname
		,car_state_id
		,car_state_sname
		,car_mark_id
		,car_mark_sname
		,car_model_id
		,car_model_sname
		,car_kind_id
		,car_kind_sname
		,employee_recieve_id
		,fio_employee_recieve
		,employee_head_id
		,fio_employee_head
		,employee_worker_id
		,fio_employee_worker
		,order_state
		,repair_type_id
		,malfunction_desc
		,repair_zone_master_id
		,date_started
		,date_ended
		,malfunction_disc
		,employee_output_worker_id
		,fio_employee_output_worker
		,wrh_order_master_type_id
		,wrh_order_master_type_sname
		,number
		,organization_id
		,organization_sname
		,id
		,repair_type_master_sname
		,work_desc
		,hour_amount
		,rpr_zone_detail_emp_worker_id
		,rpr_zone_detail_fio_emp_worker
		,start_date
		,end_date
from
   (select
		 convert(varchar(10),dbo.usfUtils_DayTo01(date_created), 104) + ' ' + convert(varchar(5),dbo.usfUtils_DayTo01(date_created), 108) as month_created
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created
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
			  when a.order_state = 2 then 'Взят на ремонт, сведений о необх. запчастях нет'
			  when a.order_state = 3 then 'Взят на ремонт, есть сведения о необх. запчастях'
			  when a.order_state = 4 then 'Обработан'
			  when a.order_state = 5 then 'Отклонен'
		  end as order_state
		,a.repair_type_id
		,a.malfunction_desc
		,a.repair_zone_master_id
		,convert(varchar(10),a.date_started, 104) + ' ' + convert(varchar(5),a.date_started, 108) as date_started
		,convert(varchar(10),a.date_ended, 104) + ' ' + convert(varchar(5),a.date_ended, 108) as date_ended
		,a.malfunction_disc
		,a.employee_output_worker_id
		,a.fio_employee_output_worker
		,a.wrh_order_master_type_id
		,a.wrh_order_master_type_sname
		,a.number
		,a.organization_id
		,a.organization_sname
		,a.id
		,dbo.usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name(a.id) as repair_type_master_sname
		,dbo.usfRRP_REPAIR_ZONE_Select_work_desc_By_rpr_zone_master_id(a.repair_zone_master_id) as work_desc
		,dbo.usfRRP_REPAIR_ZONE_Select_hr_amount_By_rpr_zone_master_id(a.repair_zone_master_id) as hour_amount
		,null as rpr_zone_detail_emp_worker_id
		,dbo.usfRRP_REPAIR_ZONE_Select_worker_By_rpr_zone_master_id(a.repair_zone_master_id)
			as rpr_zone_detail_fio_emp_worker
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	FROM dbo.utfVREP_WRH_ORDER_MASTER() as a
	--left outer join dbo.CPRT_EMPLOYEE as e
	--	on b.employee_worker_id = e.id
	--left outer join dbo.CPRT_PERSON as f
	--	on f.id = e.person_id
	where a.date_created >=   dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	 -- and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (a.repair_type_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	  and a.order_state != 6) as a
	order by  a.month_created, a.organization_id, a.date_created, a.id, a.state_number
			--,d.short_name
	RETURN

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




