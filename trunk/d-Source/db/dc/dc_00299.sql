:r ./../_define.sql

:setvar dc_number 00299
:setvar dc_description "power trailer reports added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.06.2008 VLavrentiev  power trailer reports added
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


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (79, 'CAR_POWER_TRAILER_AMOUNT', 'Кол-во литров топлива, ушедшего на энергоустановки')
set identity_insert dbo.CREP_VALUE off
go


insert into dbo.CSYS_CONST (id, name, description)
values (79, 'CAR_POWER_TRAILER_AMOUNT', 'Кол-во литров топлива, ушедшего на энергоустановки')
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_TRAILER_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные по энергоустановкам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_device_id			numeric(38,0)   = null
	,@p_day_created			datetime		= null
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
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
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
	,@v_value_pw_amount_id	numeric(38,0)
	,@v_month_created		datetime
	,@v_date_created	    datetime
	,@v_fact_start_duty		datetime
	,@v_fact_end_duty		datetime
	,@v_speedometer_start_indctn decimal(18,9)
	,@v_speedometer_end_indctn	 decimal(18,9)
	,@v_fuel_start_left			 decimal(18,9)
	,@v_fuel_end_left			 decimal(18,9)
	,@v_value				decimal(18,9)
	,@v_pw_trailer_id       numeric(38,0)
	,@v_year_created		datetime
	
  
 set @v_value_pw_amount_id = dbo.usfConst('CAR_POWER_TRAILER_AMOUNT')
 set  @v_date_created = dbo.usfUtils_TimeToZero(@p_day_created)
 set @v_pw_trailer_id = dbo.usfConst('Энергоустановка')




select @v_hour_0 = sum(case when datepart("Hh", @v_date_created) = 0
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_1 = sum(case when datepart("Hh", @v_date_created) = 1
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_2 = sum(case when datepart("Hh", @v_date_created) = 2
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_3 = sum(case when datepart("Hh", @v_date_created) = 3
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_4 = sum(case when datepart("Hh", @v_date_created) = 4
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_5 = sum(case when datepart("Hh", @v_date_created) = 5
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_6 = sum(case when datepart("Hh", @v_date_created) = 6
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_7 = sum(case when datepart("Hh", @v_date_created) = 7
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_8 = sum(case when datepart("Hh", @v_date_created) = 8
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_9 = sum(case when datepart("Hh", @v_date_created) = 9
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_10 = sum(case when datepart("Hh", @v_date_created) = 10
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_11 = sum(case when datepart("Hh", @v_date_created) = 11
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_12 = sum(case when datepart("Hh", @v_date_created) = 12
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_13 = sum(case when datepart("Hh", @v_date_created) = 13
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_14 = sum(case when datepart("Hh", @v_date_created) = 14
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_15 = sum(case when datepart("Hh", @v_date_created) = 15
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_16 = sum(case when datepart("Hh", @v_date_created) = 16
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_17 = sum(case when datepart("Hh", @v_date_created) = 17
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_18 = sum(case when datepart("Hh", @v_date_created) = 18
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_19 = sum(case when datepart("Hh", @v_date_created) = 19
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_20 = sum(case when datepart("Hh", @v_date_created) = 20
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_21 = sum(case when datepart("Hh", @v_date_created) = 21
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_22 = sum(case when datepart("Hh", @v_date_created) = 22
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_23 = sum(case when datepart("Hh", @v_date_created) = 23
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_speedometer_start_indctn = isnull((select TOP(1) speedometer_start_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty asc), @p_speedometer_start_indctn)
	   ,@v_speedometer_end_indctn = isnull((select TOP(1) speedometer_end_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty desc), @p_speedometer_end_indctn)
	   ,@v_fuel_start_left		= isnull((select TOP(1) fuel_start_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty asc), @p_fuel_start_left)
	   ,@v_fuel_end_left		= isnull((select TOP(1) fuel_end_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty desc), @p_fuel_end_left) 
  from dbo.CDRV_DRIVER_LIST as a
	left outer join dbo.CDRV_TRAILER as c
		on a.id = c.driver_list_id
where a.car_id = @p_car_id
  and a.date_created >= @v_date_created
  and a.date_created < @v_date_created + 1
  and c.device_id = @v_pw_trailer_id
  group by car_id


   set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_date_created
			,@p_value_id	 = @v_value_pw_amount_id
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
	and value_id = @v_value_pw_amount_id
	and day_created = @v_date_created

  set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_pw_amount_id
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
		  		,@p_month_created 		= @v_date_created
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
				,@p_value_id			= @v_value_pw_amount_id
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


GRANT EXECUTE ON [dbo].[uspVREP_TRAILER_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_TRAILER_Calculate] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.04.2008 VLavrentiev	Добавил новую процедуру
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
	,@p_run					decimal(18,9)	= null
	,@p_fuel_consumption    decimal(18,9)
	,@p_last_date_created	datetime		= null
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

	@v_Error			int
    ,@v_TrancountOnEntry int


  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = 
		dbo.uspVREP_CAR_HOUR_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_HOUR_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

  exec @v_Error = 
		dbo.uspVREP_CAR_KM_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_KM_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  end

  exec @v_Error = 
		dbo.uspVREP_CAR_EXIT_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_EXIT_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

  exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_CNMPTN_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_fuel_consumption    = @p_fuel_consumption
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

 if (@p_last_date_created) is not null
 begin
	exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_CNMPTN_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_fuel_consumption    = @p_fuel_consumption
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 end


exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_GIVED_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_GIVED_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end


exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_RETURN_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_RETURN_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

exec @v_Error = 
		dbo.uspVREP_TRAILER_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_TRAILER_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
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
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end




	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
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
	,@p_last_date_created			datetime	= null
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
			,fuel_addtnl_exp, run, fuel_consumption, last_date_created
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption, @p_last_date_created
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
	  , last_date_created = @p_last_date_created
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
--Незачем пересчитывать на прошлый и текущий день, если была вставка или даты равны
if ((dbo.usfUtils_TimeToZero(@p_date_created) = dbo.usfUtils_TimeToZero(@p_last_date_created))
	or (@p_edit_state <> 'E'))
set @p_last_date_created = null
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
	,@p_last_date_created			= @p_last_date_created
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
	,@p_last_date_created			= @p_last_date_created
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

ALTER PROCEDURE [dbo].[uspVREP_TRAILER_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные по энергоустановкам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_device_id			numeric(38,0)   = null
	,@p_day_created			datetime		= null
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
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
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
	,@v_value_pw_amount_id	numeric(38,0)
	,@v_month_created		datetime
	,@v_date_created	    datetime
	,@v_fact_start_duty		datetime
	,@v_fact_end_duty		datetime
	,@v_speedometer_start_indctn decimal(18,9)
	,@v_speedometer_end_indctn	 decimal(18,9)
	,@v_fuel_start_left			 decimal(18,9)
	,@v_fuel_end_left			 decimal(18,9)
	,@v_value				decimal(18,9)
	,@v_pw_trailer_id       numeric(38,0)
	,@v_year_created		datetime
	
  
 set @v_value_pw_amount_id = dbo.usfConst('CAR_POWER_TRAILER_AMOUNT')
 set  @v_date_created = dbo.usfUtils_TimeToZero(@p_day_created)
 set @v_pw_trailer_id = dbo.usfConst('Энергоустановка')




select @v_hour_0 = sum(case when datepart("Hh", @v_date_created) = 0
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_1 = sum(case when datepart("Hh", @v_date_created) = 1
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_2 = sum(case when datepart("Hh", @v_date_created) = 2
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_3 = sum(case when datepart("Hh", @v_date_created) = 3
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_4 = sum(case when datepart("Hh", @v_date_created) = 4
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_5 = sum(case when datepart("Hh", @v_date_created) = 5
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_6 = sum(case when datepart("Hh", @v_date_created) = 6
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_7 = sum(case when datepart("Hh", @v_date_created) = 7
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_8 = sum(case when datepart("Hh", @v_date_created) = 8
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_9 = sum(case when datepart("Hh", @v_date_created) = 9
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_10 = sum(case when datepart("Hh", @v_date_created) = 10
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_11 = sum(case when datepart("Hh", @v_date_created) = 11
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_12 = sum(case when datepart("Hh", @v_date_created) = 12
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_13 = sum(case when datepart("Hh", @v_date_created) = 13
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_14 = sum(case when datepart("Hh", @v_date_created) = 14
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_15 = sum(case when datepart("Hh", @v_date_created) = 15
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_16 = sum(case when datepart("Hh", @v_date_created) = 16
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_17 = sum(case when datepart("Hh", @v_date_created) = 17
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_18 = sum(case when datepart("Hh", @v_date_created) = 18
				then isnull(work_hour_amount,0)
				else 0
		   end) 
	  ,@v_hour_19 = sum(case when datepart("Hh", @v_date_created) = 19
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_20 = sum(case when datepart("Hh", @v_date_created) = 20
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_21 = sum(case when datepart("Hh", @v_date_created) = 21
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_22 = sum(case when datepart("Hh", @v_date_created) = 22
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_hour_23 = sum(case when datepart("Hh", @v_date_created) = 23
				then isnull(work_hour_amount,0)
				else 0
		   end)
	  ,@v_fact_start_duty = min(fact_start_duty)
	  ,@v_fact_end_duty = max(fact_end_duty)
	  ,@v_speedometer_start_indctn = isnull((select TOP(1) speedometer_start_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty asc), @p_speedometer_start_indctn)
	   ,@v_speedometer_end_indctn = isnull((select TOP(1) speedometer_end_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty desc), @p_speedometer_end_indctn)
	   ,@v_fuel_start_left		= isnull((select TOP(1) fuel_start_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty asc), @p_fuel_start_left)
	   ,@v_fuel_end_left		= isnull((select TOP(1) fuel_end_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_date_created
																				   and date_created < @v_date_created + 1
																				order by fact_start_duty desc), @p_fuel_end_left) 
  from dbo.CDRV_DRIVER_LIST as a
	left outer join dbo.CDRV_TRAILER as c
		on a.id = c.driver_list_id
where a.car_id = @p_car_id
  and a.date_created >= @v_date_created
  and a.date_created < @v_date_created + 1
  and c.device_id = @v_pw_trailer_id
  group by car_id


   set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_date_created
			,@p_value_id	 = @v_value_pw_amount_id
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
	and value_id = @v_value_pw_amount_id
	and day_created = @v_date_created

  set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_pw_amount_id
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
		  		,@p_month_created 		= @v_date_created
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
				,@p_value_id			= @v_value_pw_amount_id
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
