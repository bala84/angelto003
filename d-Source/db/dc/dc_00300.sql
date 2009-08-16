:r ./../_define.sql

:setvar dc_number 00300
:setvar dc_description "power trailer reports added#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.06.2008 VLavrentiev  power trailer reports added#2
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

update dbo.csys_const set name = 'CAR_POWER_TRAILER_AMOUNT'
where id = 79
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
		,@v_value_fuel_return_id  numeric(38,0)
		,@v_pw_trailer_id		 numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set  @v_value_fuel_cnmptn_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
  set  @v_value_run_id = dbo.usfConst('CAR_KM_AMOUNT')
  set  @v_value_fuel_gived_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
  set  @v_value_fuel_return_id = dbo.usfConst('CAR_FUEL_RETURN_AMOUNT')
  set  @v_pw_trailer_id = dbo.usfConst('CAR_POWER_TRAILER_AMOUNT')
  
   
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
		,organization_id
		,organization_sname
		,month_created
		,pw_trailer_amount
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
		,organization_id
		,organization_sname
		,month_created
		,sum(pw_trailer_amount) as pw_trailer_amount
   from     
   (SELECT 
		  state_number
		 ,dbo.usfUtils_DayTo01(month_created) as month_created
		 ,isnull((select TOP(1) speedometer_start_indctn from dbo.utfVREP_CAR_DAY() as d
												  where 
												        d.month_created >= @p_start_date
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												   and  d.organization_id = a.organization_id
												  order by month_created asc, fact_start_duty asc)
				 ,(select speedometer_start_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((select TOP(1) speedometer_end_indctn from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= @p_end_date
												   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												   and  d.organization_id = a.organization_id
												  order by month_created desc, fact_end_duty desc)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_end_indctn
		 ,isnull((convert(decimal(18,0)
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
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as fuel_consumption
		 ,isnull((convert(decimal(18,0)
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
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as run
		 ,isnull((select TOP(1) fuel_start_left from dbo.utfVREP_CAR_DAY() as c
												  where c.month_created >= @p_start_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												  order by month_created asc, fact_start_duty asc)
				 ,(select fuel_start_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((select TOP(1) fuel_end_left from dbo.utfVREP_CAR_DAY() as d
												  where d.month_created <= @p_end_date
												--   and  d.value_id = a.value_id
												   and  d.car_id = a.car_id
												   and  d.organization_id = a.organization_id
												  order by month_created desc, fact_end_duty desc)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_end_left
		 ,(isnull((convert(decimal(18,0)
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
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0)
		- 
			isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_return_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0)) as fuel_gived
	,organization_id
	,organization_sname
	,isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_pw_trailer_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as pw_trailer_amount
	FROM dbo.utfVREP_CAR_DAY() as a
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)) as a
	group by
		 month_created
		,organization_id
	    ,organization_sname 
		,state_number) as b
	order by month_created, organization_sname, state_number

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
