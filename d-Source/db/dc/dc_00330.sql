:r ./../_define.sql

:setvar dc_number 00330
:setvar dc_description "warehouse item day report fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    01.07.2008 VLavrentiev  warehouse item day report fixed#2
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
,@p_organization_id		numeric(38,0) = null
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
  ,a.organization_id
  ,a.organization_sname
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
  ,a.organization_id
  ,a.organization_sname
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
  ,a.organization_id
  ,a.organization_sname
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
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)) as a
group by    
   a.month_created
  ,a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.organization_id
  ,a.organization_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname) as a
order by a.month_created
		,a.warehouse_type_sname
	    ,a.organization_sname
		,a.good_mark
		,a.good_category_fname

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



