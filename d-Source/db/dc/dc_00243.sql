:r ./../_define.sql

:setvar dc_number 00243
:setvar dc_description "employee hours calculate added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.05.2008 VLavrentiev  employee hours calculate added
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

CREATE PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по сотрудникам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_day_created			datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
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
    ,@v_TrancountOnEntry	int
	,@v_value_id			numeric(38,0)
	,@v_value_total			decimal(18,9)
	,@v_value_day			decimal(18,9)
	,@v_value_night			decimal(18,9)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_TOTAL')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

select @v_hour_0 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 0 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 1 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 2 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 3 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 4 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 5 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 6 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 7 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 8 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 9 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 10 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 11
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 12 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 13 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 14 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 15 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 16
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 17 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 18 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 19 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 20
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 21 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 22 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 23 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   else 0
	   end)
 from dbo.CDRV_DRIVER_LIST
 where employee1_id = @p_employee_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_SaveById
			 @p_day_created			= @v_day_created	  
			,@p_value_id			= @v_value_id
			,@p_employee_id			= @p_employee_id
			,@p_person_id			= @p_person_id
			,@p_lastname			= @p_lastname
			,@p_name				= @p_name
			,@p_surname				= @p_surname
			,@p_organization_id		= @p_organization_id
			,@p_organization_sname	= @p_organization_sname
			,@p_employee_type_id	= @p_employee_type_id
			,@p_employee_type_sname	= @p_employee_type_sname
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
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value_total = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
		 ,@v_value_day = sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21)
		 ,@v_value_night = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5)+ sum(hour_22)
					 + sum(hour_23) 
    from dbo.CREP_EMPLOYEE_HOUR
  where employee_id = @p_employee_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end
--Правила для записи часов для отдела кадров

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')

if (@v_value_night > 6)
 set @v_value_night = 6

if (@v_value_total > 12)
 set @v_value_total = 12

if (@v_value_day + @v_value_night) > 12
 set @v_value_day = @v_value_day - ((@v_value_day + @v_value_night) - @v_value_total)

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_month_created
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

GRANT EXECUTE ON [dbo].[uspVREP_EMPLOYEE_HOUR_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_EMPLOYEE_HOUR_Calculate] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_CAR_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготовить данные для отчетов по автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9)
	,@p_speedometer_end_indctn		decimal(18,9)
	,@p_fuel_start_left				decimal(18,9)
	,@p_fuel_end_left				decimal(18,9)
	,@p_fuel_gived					decimal(18,9)
	,@p_fuel_return					decimal(18,9)
	,@p_fuel_addtnl_exp				decimal(18,9)
	,@p_run							decimal(18,9)
	,@p_fuel_consumption			decimal(18,9)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	@v_Error			int
    ,@v_TrancountOnEntry int

  declare    
	 @v_car_type_id					numeric(38,0)
	,@v_car_type_sname				varchar(30)
	,@v_car_state_id				numeric(38,0)	
	,@v_car_state_sname				varchar(30)
	,@v_car_mark_id					numeric(38,0)
	,@v_car_mark_sname				varchar(30)
	,@v_car_model_id				numeric(38,0)
	,@v_car_model_sname				varchar(30)
	,@v_begin_mntnc_date			datetime
	,@v_fuel_type_sname				varchar(30)
	,@v_car_kind_id					numeric(38,0)
	,@v_car_kind_sname				varchar(30)
	,@v_state_number				varchar(20)
    ,@v_sys_comment					varchar(2000)
    ,@v_sys_user					varchar(30)					

--if (@@rowcount = 1)
--begin
select 
		  
		   @v_state_number = b.state_number
		  ,@v_car_type_id = b.car_type_id 
		  ,@v_car_type_sname = b.car_type_sname
		  ,@v_car_state_id = b.car_state_id
		  ,@v_car_state_sname = b.car_state_sname	
		  ,@v_car_mark_id = b.car_mark_id
		  ,@v_car_mark_sname = b.car_mark_sname
		  ,@v_car_model_id = b.car_model_id
		  ,@v_car_model_sname = b.car_model_sname
		  ,@v_begin_mntnc_date = b.begin_mntnc_date
	      ,@v_fuel_type_sname = b.fuel_type_sname
		  ,@v_car_kind_id = b.car_kind_id
		  ,@v_car_kind_sname = b.car_kind_sname
	from  dbo.utfVCAR_CAR() as b
	 where  b.id = @p_car_id

exec @v_Error = 
		dbo.uspVREP_Calculate
				 @p_day_created			= @p_date_created
				,@p_state_number		= @v_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @v_car_type_id
				,@p_car_type_sname		= @v_car_type_sname
				,@p_car_state_id		= @v_car_state_id
				,@p_car_state_sname		= @v_car_state_sname
				,@p_car_mark_id			= @v_car_mark_id
				,@p_car_mark_sname		= @v_car_mark_sname
				,@p_car_model_id		= @v_car_model_id
				,@p_car_model_sname		= @v_car_model_sname
				,@p_begin_mntnc_date	= @v_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @v_fuel_type_sname
				,@p_car_kind_id			= @v_car_kind_id
				,@p_car_kind_sname		= @v_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_fuel_consumption	= @p_fuel_consumption
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user
--end			


	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_CAR_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_Prepare] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_EMPLOYEE_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по сотрудникам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_employee_id			numeric(38,0)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
  
  declare
	 @v_person_id			numeric(38,0)
	,@v_lastname			varchar(100)
	,@v_name				varchar(60)
	,@v_surname				varchar(60)
	,@v_organization_id		numeric(38,0)
	,@v_organization_sname	varchar(30)
	,@v_employee_type_id	numeric(38,0)
	,@v_employee_type_sname	varchar(30)
	,@v_Error		int


  select @v_person_id = person_id
		,@v_organization_id = organization_id
		,@v_employee_type_id = employee_type_id
    from dbo.CPRT_EMPLOYEE
	where id = @p_employee_id

  select @v_lastname = lastname
		,@v_name = name
		,@v_surname = surname
	from dbo.CPRT_PERSON
	where id = @v_person_id

  select @v_organization_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @v_organization_id

  select @v_employee_type_sname = short_name
	from dbo.CPRT_EMPLOYEE_TYPE
	where id = @v_employee_type_id

exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

return
GO

GRANT EXECUTE ON [dbo].[uspVREP_EMPLOYEE_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_EMPLOYEE_Prepare] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id							numeric(38,0) = null out
    ,@p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id		numeric(38,0)
	,@p_driver_list_type_id			numeric(38,0)
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9) = 0.0	
	,@p_speedometer_end_indctn		decimal(18,9) = 0.0
	,@p_fuel_start_left				decimal(18,9) = 0.0
	,@p_fuel_end_left				decimal(18,9) = 0.0
	,@p_fuel_gived					decimal(18,9) = 0.0
	,@p_fuel_return					decimal(18,9) = 0.0
	,@p_fuel_addtnl_exp				decimal(18,9) = 0.0
	,@p_last_run					decimal(18,9) = 0.0
	,@p_run							decimal(18,9)= 0.0
	,@p_fuel_consumption			decimal(18,9) = 0.0
	,@p_condition_id				numeric (38,0) = null out
	,@p_edit_state					char(1) = null
	,@p_employee_id					numeric (38,0) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_fuel_exp is null)
    set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	 if (@p_speedometer_end_indctn is null)		
    set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null) 
	set @p_fuel_end_left = 0.0

	 if (@p_fuel_gived is null)
    set @p_fuel_gived = 0.0

	 if (@p_fuel_return	is null)
	set @p_fuel_return = 0.0

	 if (@p_fuel_addtnl_exp is null)
    set @p_fuel_addtnl_exp = 0.0

	 if (@p_run is null)
    set @p_run = 0.0

	 if (@p_fuel_consumption is null)
	set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавлять
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   
				
				insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ(sys_comment)
				values('seq_gen')

				set @p_number = scope_identity()
			end 
	 	
	   		insert into
			     dbo.CDRV_DRIVER_LIST 
            		(date_created, number, car_id, fact_start_duty, fact_end_duty
			,driver_list_state_id, driver_list_type_id, fuel_exp
			,fuel_type_id, organization_id, employee1_id, employee2_id
			,speedometer_start_indctn,speedometer_end_indctn
		    ,fuel_start_left, fuel_end_left, fuel_gived, fuel_return
			,fuel_addtnl_exp, run, fuel_consumption
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
  begin	
	update dbo.CDRV_DRIVER_LIST set
		date_created = @p_date_created
	  , number = @p_number
	  , car_id = @p_car_id
	  , fact_start_duty = @p_fact_start_duty
	  , fact_end_duty = @p_fact_end_duty
	  , driver_list_state_id = @p_driver_list_state_id
	  , driver_list_type_id = @p_driver_list_type_id
	  , fuel_exp = @p_fuel_exp
	  , fuel_type_id = @p_fuel_type_id
	  , organization_id = @p_organization_id
	  , employee1_id = @p_employee1_id
      , employee2_id = @p_employee2_id
	  , speedometer_start_indctn = @p_speedometer_start_indctn
	  , speedometer_end_indctn = @p_speedometer_end_indctn
	  , fuel_start_left = @p_fuel_start_left
	  , fuel_end_left = @p_fuel_end_left
	  , fuel_gived = @p_fuel_gived
	  , fuel_return = @p_fuel_return
	  , fuel_addtnl_exp = @p_fuel_addtnl_exp
	  , run = @p_run
	  , fuel_consumption = @p_fuel_consumption
	  , sys_comment = @p_sys_comment
      , sys_user_modified = @p_sys_user
	where ID = @p_id
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)

	if (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
-- Убедимся, что при отсутствии изменений мы не увеличим пробег
	if (@p_condition_id is not null) and (@p_edit_state <> 'E')
		set @p_run = 0
  end
  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @p_run
    		,@p_last_run			= @p_last_run
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
--Отчеты
exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp	
	,@p_run							= @p_run	
	,@p_fuel_consumption			= @p_fuel_consumption
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 

exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @p_date_created	  
	,@p_employee_id			= @p_employee_id
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 


  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return  

end
GO

	

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[TRIUD_CDRV_DRIVER_LIST_REPORT]'))
DROP TRIGGER [dbo].[TRIUD_CDRV_DRIVER_LIST_REPORT]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id							numeric(38,0) = null out
    ,@p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id		numeric(38,0)
	,@p_driver_list_type_id			numeric(38,0)
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9) = 0.0	
	,@p_speedometer_end_indctn		decimal(18,9) = 0.0
	,@p_fuel_start_left				decimal(18,9) = 0.0
	,@p_fuel_end_left				decimal(18,9) = 0.0
	,@p_fuel_gived					decimal(18,9) = 0.0
	,@p_fuel_return					decimal(18,9) = 0.0
	,@p_fuel_addtnl_exp				decimal(18,9) = 0.0
	,@p_last_run					decimal(18,9) = 0.0
	,@p_run							decimal(18,9)= 0.0
	,@p_fuel_consumption			decimal(18,9) = 0.0
	,@p_condition_id				numeric (38,0) = null out
	,@p_edit_state					char(1) = null
	,@p_employee_id					numeric (38,0) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_fuel_exp is null)
    set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	 if (@p_speedometer_end_indctn is null)		
    set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null) 
	set @p_fuel_end_left = 0.0

	 if (@p_fuel_gived is null)
    set @p_fuel_gived = 0.0

	 if (@p_fuel_return	is null)
	set @p_fuel_return = 0.0

	 if (@p_fuel_addtnl_exp is null)
    set @p_fuel_addtnl_exp = 0.0

	 if (@p_run is null)
    set @p_run = 0.0

	 if (@p_fuel_consumption is null)
	set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавлять
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   
				
				insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ(sys_comment)
				values('seq_gen')

				set @p_number = scope_identity()
			end 
	 	
	   		insert into
			     dbo.CDRV_DRIVER_LIST 
            		(date_created, number, car_id, fact_start_duty, fact_end_duty
			,driver_list_state_id, driver_list_type_id, fuel_exp
			,fuel_type_id, organization_id, employee1_id, employee2_id
			,speedometer_start_indctn,speedometer_end_indctn
		    ,fuel_start_left, fuel_end_left, fuel_gived, fuel_return
			,fuel_addtnl_exp, run, fuel_consumption
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
  begin	
	update dbo.CDRV_DRIVER_LIST set
		date_created = @p_date_created
	  , number = @p_number
	  , car_id = @p_car_id
	  , fact_start_duty = @p_fact_start_duty
	  , fact_end_duty = @p_fact_end_duty
	  , driver_list_state_id = @p_driver_list_state_id
	  , driver_list_type_id = @p_driver_list_type_id
	  , fuel_exp = @p_fuel_exp
	  , fuel_type_id = @p_fuel_type_id
	  , organization_id = @p_organization_id
	  , employee1_id = @p_employee1_id
      , employee2_id = @p_employee2_id
	  , speedometer_start_indctn = @p_speedometer_start_indctn
	  , speedometer_end_indctn = @p_speedometer_end_indctn
	  , fuel_start_left = @p_fuel_start_left
	  , fuel_end_left = @p_fuel_end_left
	  , fuel_gived = @p_fuel_gived
	  , fuel_return = @p_fuel_return
	  , fuel_addtnl_exp = @p_fuel_addtnl_exp
	  , run = @p_run
	  , fuel_consumption = @p_fuel_consumption
	  , sys_comment = @p_sys_comment
      , sys_user_modified = @p_sys_user
	where ID = @p_id
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)

	if (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
-- Убедимся, что при отсутствии изменений мы не увеличим пробег
	if (@p_condition_id is not null) and (@p_edit_state <> 'E')
		set @p_run = 0
  end
  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @p_run
    		,@p_last_run			= @p_last_run
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
--Отчеты
exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp	
	,@p_run							= @p_run	
	,@p_fuel_consumption			= @p_fuel_consumption
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 

exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @p_date_created	  
	,@p_employee_id			= @p_employee1_id
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 


  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по сотрудникам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_day_created			datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
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
    ,@v_TrancountOnEntry	int
	,@v_value_id			numeric(38,0)
	,@v_value_total			decimal(18,9)
	,@v_value_day			decimal(18,9)
	,@v_value_night			decimal(18,9)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_TOTAL')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)


select @v_hour_0 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 0 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 1 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 2 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 3 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 4 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case 
	   when datepart("Hh", fact_end_duty) < 5 
	   then 0 
		else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 6 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 7 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 8 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 9 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 10 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 11
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 12 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 13 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 14 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 15 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 16
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 17 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 18 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 19 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 20
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case 
	   when datepart("Hh", fact_end_duty) < 21 
	   then 0 
	   else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 22 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case 
	   when datepart("Hh", fact_end_duty) < 23 
	   then 0 
	   else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   end)
 from dbo.CDRV_DRIVER_LIST
 where employee1_id = @p_employee_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_SaveById
			 @p_day_created			= @v_day_created	  
			,@p_value_id			= @v_value_id
			,@p_employee_id			= @p_employee_id
			,@p_person_id			= @p_person_id
			,@p_lastname			= @p_lastname
			,@p_name				= @p_name
			,@p_surname				= @p_surname
			,@p_organization_id		= @p_organization_id
			,@p_organization_sname	= @p_organization_sname
			,@p_employee_type_id	= @p_employee_type_id
			,@p_employee_type_sname	= @p_employee_type_sname
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
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value_total = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
		 ,@v_value_day = sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21)
		 ,@v_value_night = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5)+ sum(hour_22)
					 + sum(hour_23) 
    from dbo.CREP_EMPLOYEE_HOUR
  where employee_id = @p_employee_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end
--Правила для записи часов для отдела кадров

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')

if (@v_value_night > 6)
 set @v_value_night = 6

if (@v_value_total > 12)
 set @v_value_total = 12

if (@v_value_day + @v_value_night) > 12
 set @v_value_day = @v_value_day - ((@v_value_day + @v_value_night) - @v_value_total)

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_month_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_month_created
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




