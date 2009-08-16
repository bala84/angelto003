:r ./../_define.sql

:setvar dc_number 00288
:setvar dc_description "car summary fixed#5"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    06.06.2008 VLavrentiev  car summary fixed#5
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

ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ���������� ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_EXIT_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_exit_amnt = count(*)
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_exit_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_exit_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_exit_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_exit_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_exit_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_exit_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_exit_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_exit_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_exit_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_exit_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_exit_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_exit_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_exit_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_exit_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_exit_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_exit_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_exit_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_exit_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_exit_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_exit_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_exit_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_exit_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_exit_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_exit_amnt
else
  set @v_hour_23 = 0

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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_CNMPTN_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ������� ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_fuel_consumption	decimal(18,9)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	,@v_fuel_cnmptn_amnt int
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_fuel_cnmptn_amnt = sum(fuel_consumption)
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_fuel_cnmptn_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_fuel_cnmptn_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_fuel_cnmptn_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_fuel_cnmptn_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_fuel_cnmptn_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_fuel_cnmptn_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_fuel_cnmptn_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_fuel_cnmptn_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_fuel_cnmptn_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_fuel_cnmptn_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_fuel_cnmptn_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_fuel_cnmptn_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_fuel_cnmptn_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_fuel_cnmptn_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_fuel_cnmptn_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_fuel_cnmptn_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_fuel_cnmptn_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_fuel_cnmptn_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_fuel_cnmptn_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_fuel_cnmptn_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_fuel_cnmptn_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_fuel_cnmptn_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_fuel_cnmptn_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_fuel_cnmptn_amnt
else
  set @v_hour_23 = 0

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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_GIVED_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ������ ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	,@v_fuel_gived_amnt int
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_fuel_gived_amnt = sum(fuel_gived)
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_fuel_gived_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_fuel_gived_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_fuel_gived_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_fuel_gived_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_fuel_gived_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_fuel_gived_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_fuel_gived_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_fuel_gived_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_fuel_gived_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_fuel_gived_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_fuel_gived_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_fuel_gived_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_fuel_gived_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_fuel_gived_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_fuel_gived_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_fuel_gived_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_fuel_gived_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_fuel_gived_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_fuel_gived_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_fuel_gived_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_fuel_gived_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_fuel_gived_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_fuel_gived_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_fuel_gived_amnt
else
  set @v_hour_23 = 0

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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_RETURN_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � �������� ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	,@v_fuel_return_amnt int
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_FUEL_RETURN_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_fuel_return_amnt = sum(fuel_return)
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_fuel_return_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_fuel_return_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_fuel_return_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_fuel_return_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_fuel_return_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_fuel_return_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_fuel_return_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_fuel_return_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_fuel_return_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_fuel_return_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_fuel_return_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_fuel_return_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_fuel_return_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_fuel_return_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_fuel_return_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_fuel_return_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_fuel_return_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_fuel_return_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_fuel_return_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_fuel_return_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_fuel_return_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_fuel_return_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_fuel_return_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_fuel_return_amnt
else
  set @v_hour_23 = 0

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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	,@v_car_work_hour_amnt  int
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_car_work_hour_amnt = sum(datediff("mi", fact_start_duty, fact_end_duty))
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_car_work_hour_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_car_work_hour_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_car_work_hour_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_car_work_hour_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_car_work_hour_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_car_work_hour_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_car_work_hour_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_car_work_hour_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_car_work_hour_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_car_work_hour_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_car_work_hour_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_car_work_hour_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_car_work_hour_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_car_work_hour_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_car_work_hour_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_car_work_hour_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_car_work_hour_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_car_work_hour_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_car_work_hour_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_car_work_hour_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_car_work_hour_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_car_work_hour_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_car_work_hour_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_car_work_hour_amnt
else
  set @v_hour_23 = 0

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
         if (@@tranCount > @v_TrancountOnEntry)
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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
	--TODO: R�ࠡR⪠ �-��_-�c
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
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_KM_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ����������� �� ���������� 
** �������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
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
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_run					decimal(18,9)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
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
	,@v_car_km_amnt  int
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_KM_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_car_km_amnt = sum(run)
		,@v_fact_start_duty = min(fact_start_duty)
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
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_car_km_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_car_km_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_car_km_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_car_km_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_car_km_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_car_km_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_car_km_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_car_km_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_car_km_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_car_km_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_car_km_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_car_km_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_car_km_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_car_km_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_car_km_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_car_km_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_car_km_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_car_km_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_car_km_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_car_km_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_car_km_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_car_km_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_car_km_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_car_km_amnt
else
  set @v_hour_23 = 0

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
         if (@@tranCount > @v_TrancountOnEntry)
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

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
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
         if (@@tranCount > @v_TrancountOnEntry)
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
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

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

