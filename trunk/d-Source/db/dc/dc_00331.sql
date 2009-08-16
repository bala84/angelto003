:r ./../_define.sql

:setvar dc_number 00331
:setvar dc_description "report car_wrh_item_price added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    01.07.2008 VLavrentiev  report car_wrh_item_price added
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


insert into dbo.CSYS_CONST(id, name, description)
values(83, 'CAR_WRH_ITEM_PRICE', 'Суммарные затраты на автомобиль')
go

set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(83, 'CAR_WRH_ITEM_PRICE', 'Суммарные затраты на автомобиль')
set identity_insert dbo.CREP_VALUE off
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о суммарных затратах на автомобиль
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      01.07.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime		
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname  varchar(30)	 
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_exit_amnt  int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	,@v_fact_start_duty		datetime
	,@v_fact_end_duty		datetime
	,@v_speedometer_start_indctn decimal(18,9)
	,@v_speedometer_end_indctn	 decimal(18,9)
	,@v_fuel_start_left			 decimal(18,9)
	,@v_fuel_end_left			 decimal(18,9)
	


 set  @v_value_id = dbo.usfConst('CAR_WRH_ITEM_PRICE')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_date_created)


  select
		 @v_fact_start_duty = min(fact_start_duty)
		,@v_fact_end_duty = max(fact_end_duty)
		,@v_speedometer_start_indctn = (select TOP(1) speedometer_start_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty asc)
		,@v_speedometer_end_indctn = (select TOP(1) speedometer_end_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty desc)
		,@v_fuel_start_left		= (select TOP(1) fuel_start_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty asc)
		,@v_fuel_end_left		= (select TOP(1) fuel_end_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty desc)
 from dbo.CDRV_DRIVER_LIST as a
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
 group by a.car_id

 

select 
@v_hour_0 = 
		sum(case datepart("Hh", a.date_created)
	   when 0 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", a.date_created)
	   when 1 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", a.date_created)
	   when 2 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", a.date_created)
	   when 3 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", a.date_created)
	   when 4 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", a.date_created)
	   when 5
	   then c.total_sum
	   else 0
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", a.date_created)
	   when 6 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", a.date_created)
	   when 7 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", a.date_created)
	   when 8 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", a.date_created)
	   when 9 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", a.date_created)
	   when 10 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", a.date_created)
	   when 11
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", a.date_created)
	   when 12 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", a.date_created)
	   when 13 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", a.date_created)
	   when 14 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", a.date_created)
	   when 15 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", a.date_created)
	   when 16
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", a.date_created)
	   when 17 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", a.date_created)
	   when 18 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", a.date_created)
	   when 19 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", a.date_created)
	   when 20
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", a.date_created)
	   when 21
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", a.date_created)
	   when 22 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", a.date_created)
	   when 23
	   then c.total_sum
	   else 0
	   end)
	from 
dbo.CWRH_WRH_DEMAND_MASTER as a
join dbo.CWRH_WRH_DEMAND_DETAIL as b
	on a.id = b.wrh_demand_master_id
outer apply (select TOP(1) price*b.amount as total_sum
					 from dbo.CHIS_WAREHOUSE_ITEM
					 where good_category_id = b.good_category_id 
					   and warehouse_type_id = b.warehouse_type_id
					   and organization_id = a.organization_giver_id
					   and date_created <= a.date_created
					 order by date_created desc) as c
where a.car_id = @p_car_id
and a.date_created >= @v_day_created
and a.date_created < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @v_speedometer_start_indctn
			,@p_speedometer_end_indctn = @v_speedometer_end_indctn
			,@p_fuel_start_left = @v_fuel_start_left
			,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_date_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @v_speedometer_start_indctn
				,@p_speedometer_end_indctn = @v_speedometer_end_indctn
				,@p_fuel_start_left = @v_fuel_start_left
				,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @v_speedometer_start_indctn
				,@p_speedometer_end_indctn = @v_speedometer_end_indctn
				,@p_fuel_start_left = @v_fuel_start_left
				,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN




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



