:r ./../_define.sql

:setvar dc_number 00389
:setvar dc_description "condition tolerance fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   12.10.2008 VLavrentiev  condition tolerance fixed
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)
  ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type



	
    SET NOCOUNT ON
  
       SELECT 
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */
	
  RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
SET NOCOUNT ON
DECLARE
   @v_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
 
       SELECT 
              		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/

	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о требованиях
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON

declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
  
       SELECT  
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id
		  ,car_organization_id
		  ,car_organization_name
		  ,state_number
		  ,car_mark_sname
		  ,car_model_sname
		  ,number
		  ,employee_recieve_id
		  ,FIO_employee_recieve
		  ,employee_head_id
		  ,FIO_employee_head 
		  ,employee_worker_id
		  ,FIO_employee_worker
		  ,date_created
		  ,wrh_demand_master_type_id
		  ,wrh_demand_master_type_sname
		  ,organization_giver_id
		  ,organization_giver_sname
		  ,wrh_order_master_id
		  ,wrh_order_master_number
	FROM dbo.utfVWRH_WRH_DEMAND_MASTER(@p_start_date, @p_end_date)
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))
	order by date_created desc

	RETURN

go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей заказов-нарядов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_order_master_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,isnull(convert(decimal(18,2), a.amount) - convert(decimal(18,2), c.left_to_demand), convert(decimal(18,2), a.amount)) as left_to_demand
      FROM dbo.CWRH_WRH_ORDER_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
      outer apply(
		   select sum(e.amount) as left_to_demand
			from dbo.CWRH_WRH_DEMAND_MASTER as d
		left outer join dbo.CWRH_WRH_DEMAND_DETAIL as e
			on d.id = e.wrh_demand_master_id 
			where a.wrh_order_master_id = d.wrh_order_master_id
			  and e.good_category_id = a.good_category_id
			group by e.good_category_id) as c
	  where a.wrh_order_master_id = @p_wrh_order_master_id
	  union all
	  select null
			,null
			,null
			,null
			,null
			,null
			,null
			,a2.wrh_order_master_id
		    ,a.good_category_id
		    ,0 as amount
		    ,c.good_mark
		    ,c.short_name as good_category_sname
		    ,c.unit
		    ,- sum(convert(decimal(18,2), a.amount)) as left_to_demand
	  from dbo.cwrh_wrh_demand_detail as a
		join dbo.cwrh_wrh_demand_master as a2 on a.wrh_demand_master_id = a2.id
		join dbo.cwrh_wrh_order_master as b on a2.wrh_order_master_id = b.id
		JOIN dbo.CWRH_GOOD_CATEGORY as c
			on a.good_category_id = c.id
	  where not exists
		(select 1 from dbo.cwrh_wrh_order_detail as d
			where d.wrh_order_master_id = a2.wrh_order_master_id
			  and d.good_category_id = a.good_category_id)
	  group by 
			 a2.wrh_order_master_id
		    ,a.good_category_id
		    ,c.good_mark
		    ,c.short_name
		    ,c.unit
	
)
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_SelectByGood_category_id] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей приходных документов по товару
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_good_category_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_income_master_id
		  ,c.organization_recieve_id
		  ,e.name as organization_recieve_sname
		  ,c.date_created
		  ,c.number
		  ,c.warehouse_type_id
		  ,d.short_name as warehouse_type_sname
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.total
		  ,convert(decimal(18,2),a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,convert(varchar(60), convert(decimal(18,2), a.price)) + 'р.' + ' - ' + 'Дата создания: ' + convert(varchar(20), c.date_created, 103) + ' - Номер: ' + convert(varchar(60),c.number) as full_string
		  ,isnull(a2.amount_gived, 0) as amount_gived
      FROM dbo.CWRH_WRH_INCOME_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
		join dbo.CWRH_WRH_INCOME_MASTER as c
			on a.wrh_income_master_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d
			on c.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as e
			on c.organization_recieve_id = e.id
		outer apply
			(select sum(a2.amount) as amount_gived
				from dbo.cwrh_wrh_demand_detail as a2
				join dbo.cwrh_wrh_demand_master as b2 on a2.wrh_demand_master_id = b2.id
			  where a2.good_category_id = a.good_category_id
				and b2.organization_giver_id = c.organization_recieve_id
				and a2.warehouse_type_id = c.warehouse_type_id
			    and a2.price = a.price) as a2 
	  where b.id = @p_good_category_id
		and isnull(a2.amount_gived, 0) >= 0
)

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER function [dbo].[utfVWFE_Check_last_order_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о прошедшем ТО по заказу-наряду
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_date_created datetime
,@p_order_master_id numeric(38,0)
,@p_repair_type_master_id numeric(38,0)
)
returns table
AS

return
( 
select top(1) a.ts_type_route_detail_id
from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
	join dbo.CWRH_WRH_ORDER_MASTER as b on a.wrh_order_master_id = b.id
	left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c on b.id = c.wrh_order_master_id
where b.car_id = @p_car_id
  and (b.order_state = dbo.usfConst('ORDER_CLOSED')
	 or b.order_state = dbo.usfConst('ORDER_APPROVED')
	 or b.order_state = dbo.usfConst('ORDER_CORRECTED'))
  and a.ts_type_route_detail_id is not null
  and ((b.date_created <= @p_date_created) or (@p_date_created is null))
  and (--(a.wrh_order_master_id != @p_order_master_id
		--and a.repair_type_master_id != @p_repair_type_master_id) 
		not exists
			(select top(1) 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a2
							 join dbo.CWRH_WRH_ORDER_MASTER as b2 on a2.wrh_order_master_id = b2.id
				where a2.wrh_order_master_id = a.wrh_order_master_id
				  and a2.repair_type_master_id = a.repair_type_master_id
				  and a.wrh_order_master_id = @p_order_master_id
				  and a.repair_type_master_id = @p_repair_type_master_id
				order by b2.date_created desc)
	 or (@p_order_master_id is null
		and @p_repair_type_master_id is null))
order by b.date_created desc, c.date_ended desc)

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER function [dbo].[utfVWFE_Inquire_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о предстоящем ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_ts_type_master_id numeric(38,0)
,@p_date_created datetime
,@p_wrh_order_master_id numeric(38,0)
,@p_repair_type_master_id numeric(38,0)
)
returns table
AS

return
(
with inquire_ts (ordered, ts_type_route_master_id, ts_type_master_id) as 
	(select top(1)
			 b2.ordered, b2.ts_type_route_master_id, b2.ts_type_master_id
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
				--	and b2.ts_type_master_id = @p_ts_type_master_id
				    and b2.ordered >= (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where b3.id = isnull((select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created, @p_wrh_order_master_id, @p_repair_type_master_id))
															--Если записи о прошлом ТО не было, то вернем то, что проходим сейчас
															,(select TOP(1) b2.id
																  from dbo.ccar_car as g
																	join dbo.ccar_car_model as e on  e.id = g.car_model_id
																	join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
																	join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
																  where g.id = @p_car_id
																	and b2.ts_type_master_id = @p_ts_type_master_id
																order by b2.ordered asc))
									   )
				order by b2.ordered asc)
select top(1) 
  id, ts_type_master_id
from(
	--Let's get accurate ts
	select id, ts_type_master_id, ordered 
	from(
		select top(1) a.ts_type_master_id, a.ordered, a.id 
		from inquire_ts as b
		join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a on b.ts_type_route_master_id = a.ts_type_route_master_id
											and b.ordered < a.ordered
		where b.ts_type_master_id = @p_ts_type_master_id 
		order by a.ordered asc
		) as c
	--Ooops - we didn't get accuracy - trying just next ts
	union
	select id, ts_type_master_id, ordered 
	from(
		select top(1) a.ts_type_master_id, a.ordered, a.id 
		from inquire_ts as b
		join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a on b.ts_type_route_master_id = a.ts_type_route_master_id
											and b.ordered < a.ordered
		--where ts_type_master_id = @p_ts_type_master_id 
		order by a.ordered asc
		) as c 
	--Nothing got above - last resort - numbered - 1
	union
	select b2.id, b2.ts_type_master_id, b2.ordered
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ordered = 1) as d
	order by ordered desc)

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


