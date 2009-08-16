:r ./../_define.sql

:setvar dc_number 00272
:setvar dc_description "car summary fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    27.05.2008 VLavrentiev  car summary fixed#2
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

ALTER PROCEDURE [dbo].[uspVREP_CAR_SUMMARY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать суммарный отчет об автомобиле
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_time_interval		smallint = null
,@p_car_mark_id			numeric(38,0) = null
,@p_car_kind_id			numeric(38,0) = null
,@p_car_id		        numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
)
AS
SET NOCOUNT ON

	declare
		 @v_value_fuel_cnmptn_id numeric(38,0)
		,@v_value_run_id		 numeric(38,0)
		,@v_value_fuel_gived_id  numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set  @v_value_fuel_cnmptn_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
  set  @v_value_run_id = dbo.usfConst('CAR_KM_AMOUNT')
  set  @v_value_fuel_gived_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
  
   
   select
		 state_number 
		,convert(decimal(18,0), speedometer_start_indctn) as speedometer_start_indctn
		,convert(decimal(18,0), speedometer_end_indctn) as speedometer_end_indctn
		,fuel_consumption
		,run
		,convert(decimal(18,2),(convert(decimal(18,2), fuel_consumption)*convert(decimal(18,2), 100)
				/convert(decimal(18,2),run))) as fuel_cnmptn_100_km
		,convert(decimal(18,0), fuel_start_left) as fuel_start_left
		,convert(decimal(18,0), fuel_end_left) as fuel_end_left
		,fuel_gived
	from
   (select
		 state_number 
		,min(speedometer_start_indctn) as speedometer_start_indctn
		,max(speedometer_end_indctn) as speedometer_end_indctn
		,sum(fuel_consumption) as fuel_consumption
		,sum(run) as run
		,min(fuel_start_left) as fuel_start_left
		,max(fuel_end_left) as fuel_end_left
		,sum(convert(decimal,fuel_gived)) as fuel_gived
   from     
   (SELECT 
		  state_number
		 ,isnull((select TOP(1) speedometer_start_indctn from dbo.utfVREP_CAR_DAY() as d
												  where 
												        d.month_created >= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created asc)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((select TOP(1) speedometer_end_indctn from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created desc)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_end_indctn
		 ,(convert(decimal(18,0)
			,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
				from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_cnmptn_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as fuel_consumption
		 ,(convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_run_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as run
		 ,isnull((select TOP(1) fuel_start_left from dbo.utfVREP_CAR_DAY() as c
												  where c.month_created >= a.month_created
												   and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												  order by month_created asc)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((select TOP(1) fuel_end_left from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created desc)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_end_left
		 ,(convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_gived_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as fuel_gived
	FROM dbo.utfVREP_CAR_DAY() as a
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)) as a
	group by
		 state_number) as b
	order by state_number

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON

declare
  @v_item_amount_id numeric(38,0)
 ,@v_item_price_id numeric(38,0)
 ,@v_item_income_amount_id numeric(38,0)
 ,@v_item_income_price_id numeric(38,0)
 ,@v_item_outcome_amount_id numeric(38,0)
 ,@v_item_outcome_price_id numeric(38,0)
 ,@v_start_date_to_01 datetime
 ,@v_end_date_to_01 datetime

set @v_item_amount_id = dbo.usfConst('WAREHOUSE_ITEM_AMOUNT')
set @v_item_price_id = dbo.usfConst('WAREHOUSE_ITEM_PRICE')
set @v_item_income_amount_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_AMOUNT')
set @v_item_income_price_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_PRICE')
set @v_item_outcome_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
set @v_item_outcome_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()
   

set @v_start_date_to_01 = dbo.usfUtils_DayTo01(@p_start_date)
set @v_end_date_to_01 = dbo.usfUtils_DayTo01(@p_end_date)



select 
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.begin_amount
  ,a.begin_price
  ,convert(decimal(18,4), a.begin_amount*a.begin_price) as begin_sum
  ,a.income_amount
  ,a.income_price
  ,convert(decimal(18,4), a.income_amount*a.income_price) as income_sum
  ,a.outcome_amount
  ,a.outcome_price
  ,convert(decimal(18,4), a.outcome_amount*a.outcome_price) as outcome_sum
  ,a.end_amount
  ,a.end_price
  ,convert(decimal(18,4), a.end_amount*a.end_price) as end_sum
from
(select   
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,convert(decimal(18,4),sum(a.begin_amount)) as begin_amount
  ,convert(decimal(18,4),sum(a.begin_price)) as begin_price
  ,convert(decimal(18,4),sum(a.income_amount)) as income_amount
  ,convert(decimal(18,4),sum(a.income_price)) as income_price
  ,convert(decimal(18,4),sum(a.outcome_amount)) as outcome_amount
  ,convert(decimal(18,4),sum(a.outcome_price)) as outcome_price
  ,convert(decimal(18,4),sum(a.end_amount)) as end_amount
  ,convert(decimal(18,4),sum(a.end_price)) as end_price
  from
(select
   a.warehouse_type_id
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,case when a.value_id = @v_item_amount_id then isnull(b.amount, 0) 
		else 0
	end as begin_amount
  ,case when a.value_id = @v_item_price_id then isnull(b.price, 0) 
		else 0
	end as begin_price
  ,case when a.value_id = @v_item_income_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as income_amount
  ,case when a.value_id = @v_item_income_price_id then isnull(f.avg_price, 0)
		else 0
	end as income_price
  ,case when a.value_id = @v_item_outcome_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as outcome_amount
  ,case when a.value_id = @v_item_outcome_price_id then isnull(f.avg_price, 0)
		else 0
	end as outcome_price
  ,case when a.value_id = @v_item_amount_id then isnull(d.amount, 0) 
		else 0
	end as end_amount
  ,case when a.value_id = @v_item_price_id then isnull(d.price, 0) 
		else 0
	end as end_price
from dbo.CREP_WAREHOUSE_ITEM_DAY as a
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_start_date
				order by c.date_created desc) as b
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_end_date
				order by c.date_created desc) as d
outer apply 
		(select (case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
					  then 0
			    else day_1
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
					  then 0
			    else day_2
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
					  then 0
			    else day_3
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
					  then 0
			    else day_4
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
					  then 0
			    else day_5
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
					  then 0
			    else day_6
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
					  then 0
			    else day_7
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
					  then 0
			    else day_8
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
					  then 0
			    else day_9
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
					  then 0
			    else day_10
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
					  then 0
			    else day_11
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
					  then 0
			    else day_12
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
					  then 0
			    else day_13
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
					  then 0
			    else day_14
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
					  then 0
			    else day_15
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
					  then 0
			    else day_16
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
					  then 0
			    else day_17
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
					  then 0
			    else day_18
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
					  then 0
			    else day_19
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
					  then 0
			    else day_20
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
					  then 0
			    else day_21
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
					  then 0
			    else day_22
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
					  then 0
			    else day_23
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
					  then 0
			    else day_24
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
					  then 0
			    else day_25
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
					  then 0
			    else day_26
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
					  then 0
			    else day_27
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
					  then 0
			    else day_28
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
					  then 0
			    else day_29
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
					  then 0
			    else day_30
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
					  then 0
			    else day_31
				end) as month_sum
			from dbo.CREP_WAREHOUSE_ITEM_DAY as b
			WHERE b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.month_created = a.month_created
			  and b.value_id = a.value_id) as e
outer apply (select avg(c.price) as avg_price
			from CHIS_WAREHOUSE_ITEM as c 
			where c.warehouse_type_id = a.warehouse_type_id
			and c.good_category_id = a.good_category_id
			and c.date_created between @p_start_date and @p_end_date) as f
where a.month_created >= @v_start_date_to_01
  and a.month_created <= @v_end_date_to_01
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)) as a
group by    
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created) as a
order by a.month_created
		,a.warehouse_type_sname
		,a.good_mark
		,a.good_category_fname

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_SUMMARY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать суммарный отчет об автомобиле
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_time_interval		smallint = null
,@p_car_mark_id			numeric(38,0) = null
,@p_car_kind_id			numeric(38,0) = null
,@p_car_id		        numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
)
AS
SET NOCOUNT ON

	declare
		 @v_value_fuel_cnmptn_id numeric(38,0)
		,@v_value_run_id		 numeric(38,0)
		,@v_value_fuel_gived_id  numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set  @v_value_fuel_cnmptn_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
  set  @v_value_run_id = dbo.usfConst('CAR_KM_AMOUNT')
  set  @v_value_fuel_gived_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
  
   
   select
		 state_number 
		,convert(decimal(18,0), speedometer_start_indctn) as speedometer_start_indctn
		,convert(decimal(18,0), speedometer_end_indctn) as speedometer_end_indctn
		,fuel_consumption
		,run
		,case when run = 0 then 0
			  else convert(decimal(18,2),(convert(decimal(18,2), fuel_consumption)*convert(decimal(18,2), 100)
				/convert(decimal(18,2),run))) 
		  end as fuel_cnmptn_100_km
		,convert(decimal(18,0), fuel_start_left) as fuel_start_left
		,convert(decimal(18,0), fuel_end_left) as fuel_end_left
		,fuel_gived
	from
   (select
		 state_number 
		,min(speedometer_start_indctn) as speedometer_start_indctn
		,max(speedometer_end_indctn) as speedometer_end_indctn
		,sum(fuel_consumption) as fuel_consumption
		,sum(run) as run
		,min(fuel_start_left) as fuel_start_left
		,max(fuel_end_left) as fuel_end_left
		,sum(convert(decimal,fuel_gived)) as fuel_gived
   from     
   (SELECT 
		  state_number
		 ,isnull((select TOP(1) speedometer_start_indctn from dbo.utfVREP_CAR_DAY() as d
												  where 
												        d.month_created >= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created asc)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((select TOP(1) speedometer_end_indctn from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created desc)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_end_indctn
		 ,(convert(decimal(18,0)
			,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
				from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_cnmptn_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as fuel_consumption
		 ,(convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_run_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as run
		 ,isnull((select TOP(1) fuel_start_left from dbo.utfVREP_CAR_DAY() as c
												  where c.month_created >= a.month_created
												   and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												  order by month_created asc)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((select TOP(1) fuel_end_left from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= a.month_created
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												  order by month_created desc)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_end_left
		 ,(convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_gived_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id))) as fuel_gived
	FROM dbo.utfVREP_CAR_DAY() as a
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)) as a
	group by
		 state_number) as b
	order by state_number

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


