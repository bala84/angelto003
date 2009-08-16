:r ./../_define.sql

:setvar dc_number 00163                  
:setvar dc_description "report_hour_amount fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.04.2008 VLavrentiev  report_hour_amount fixed#2
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
PRINT ' '
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве проработанных часов и 
** и среднем количестве проработанных часов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')
  
       SELECT  
		   month_created
		 , value_id
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , begin_mntnc_date
		 , fuel_type_id
		 , fuel_type_sname
		 , car_kind_id
		 , car_kind_sname
		 , convert(decimal(18,0),day_1/60) as day_1
		 , convert(decimal(18,0),day_2/60) as day_2, convert(decimal(18,0),day_3/60) as day_3
		 , convert(decimal(18,0),day_4/60) as day_4, convert(decimal(18,0),day_5/60) as day_5
		 , convert(decimal(18,0),day_6/60) as day_6, convert(decimal(18,0),day_7/60) as day_7
		 , convert(decimal(18,0),day_8/60) as day_8, convert(decimal(18,0),day_9/60) as day_9
		 , convert(decimal(18,0),day_10/60) as day_10, convert(decimal(18,0),day_11/60) as day_11
		 , convert(decimal(18,0),day_12/60) as day_12, convert(decimal(18,0),day_13/60) as day_13
		 , convert(decimal(18,0),day_14/60) as day_14, convert(decimal(18,0),day_15/60) as day_15
		 , convert(decimal(18,0),day_16/60) as day_16, convert(decimal(18,0),day_17/60) as day_17
		 , convert(decimal(18,0),day_18/60) as day_18, convert(decimal(18,0),day_19/60) as day_19
		 , convert(decimal(18,0),day_20/60) as day_20, convert(decimal(18,0),day_21/60) as day_21
		 , convert(decimal(18,0),day_22/60) as day_22, convert(decimal(18,0),day_23/60) as day_23
		 , convert(decimal(18,0),day_24/60) as day_24, convert(decimal(18,0),day_25/60) as day_25
		 , convert(decimal(18,0),day_26/60) as day_26, convert(decimal(18,0),day_27/60) as day_27
		 , convert(decimal(18,0),day_28/60) as day_28, convert(decimal(18,0),day_29/60) as day_29
		 , convert(decimal(18,0),day_30/60) as day_30, convert(decimal(18,0),day_31/60) as day_31
	FROM dbo.utfVREP_CAR_DAY()
	where month_created between  @p_start_date and @p_end_date

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
	
  
 set  @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_car_work_hour_amnt = sum(datediff("mi", fact_start_duty, fact_end_duty))
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
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
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
	--TODO: ®Ўа Ў®вЄ  §­ зҐ­Ё©
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

ALTER procedure [dbo].[uspVREP_CAR_MONTH_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о годе по автомобилю
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_year_created		datetime	  = null
	,@p_value_id			numeric(38,0)
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0) = null
	,@p_car_state_sname		varchar(30)	  = null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime	  = null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_month_created		datetime
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	declare
	  @v_month_1		decimal(18,9)
	, @v_month_2		decimal(18,9)
	, @v_month_3		decimal(18,9)
	, @v_month_4		decimal(18,9)
	, @v_month_5		decimal(18,9)
	, @v_month_6		decimal(18,9)
	, @v_month_7		decimal(18,9)
	, @v_month_8		decimal(18,9)
	, @v_month_9		decimal(18,9)
	, @v_month_10		decimal(18,9)
	, @v_month_11		decimal(18,9)
	, @v_month_12		decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_year_created is null)
	  set @p_year_created = dbo.usfUtils_DayTo01(getdate())
	 else
	  set @p_year_created = dbo.usfUtils_DayTo01(@p_month_created)
 
	 if (datepart("Month", @p_month_created) = 1)
		set @v_month_1 = @p_value
	 else
		set @v_month_1 = 0
	 if (datepart("Month", @p_month_created) = 2)
		set @v_month_2 = @p_value
	 else
		set @v_month_2 = 0
	 if (datepart("Month", @p_month_created) = 3)
		set @v_month_3 = @p_value
	 else
		set @v_month_3 = 0
	 if (datepart("Month", @p_month_created) = 4)
		set @v_month_4 = @p_value
	 else
		set @v_month_4 = 0
	 if (datepart("Month", @p_month_created) = 5)
		set @v_month_5 = @p_value
	 else
		set @v_month_5 = 0
	 if (datepart("Month", @p_month_created) = 6)
		set @v_month_6 = @p_value
	 else
		set @v_month_6 = 0
	 if (datepart("Month", @p_month_created) = 7)
		set @v_month_7 = @p_value
	 else
		set @v_month_7 = 0
	 if (datepart("Month", @p_month_created) = 8)
		set @v_month_8 = @p_value
	 else
		set @v_month_8 = 0
	 if (datepart("Month", @p_month_created) = 9)
		set @v_month_9 = @p_value
	 else
		set @v_month_9 = 0
	 if (datepart("Month", @p_month_created) = 10)
		set @v_month_10 = @p_value
	 else
		set @v_month_10 = 0
	 if (datepart("Month", @p_month_created) = 11)
		set @v_month_11 = @p_value
	 else
		set @v_month_11 = 0
	 if (datepart("Month", @p_month_created) = 12)
		set @v_month_12 = @p_value
	 else
		set @v_month_12 = 0
	 

insert into dbo.CREP_CAR_MONTH
	  (year_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, month_1, month_2, month_3, month_4
			, month_5, month_6, month_7, month_8, month_9, month_10
			, month_11, month_12
			, sys_comment, sys_user_created, sys_user_modified)
select @p_year_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @v_month_1, @v_month_2, @v_month_3, @v_month_4
			,@v_month_5, @v_month_6, @v_month_7, @v_month_8, @v_month_9, @v_month_10
			,@v_month_11, @v_month_12
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_MONTH as b
  where b.year_created = @p_year_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_CAR_MONTH
		 set
			year_created = @p_year_created
		   ,value_id = @p_value_id
		   ,state_number = @p_state_number
		   ,car_id = @p_car_id
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,begin_mntnc_date = @p_begin_mntnc_date
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,month_1 = @v_month_1
		   ,month_2 = @v_month_2
		   ,month_3 = @v_month_3
		   ,month_4 = @v_month_4
		   ,month_5 = @v_month_5
		   ,month_6 = @v_month_6
		   ,month_7 = @v_month_7
		   ,month_8 = @v_month_8
		   ,month_9 = @v_month_9
		   ,month_10 = @v_month_10
		   ,month_11 = @v_month_11
		   ,month_12 = @v_month_12
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where year_created = @p_year_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return

end
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_CAR_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о месяце по автомобилю
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_month_created		datetime	  = null
	,@p_value_id			numeric(38,0)
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0) = null
	,@p_car_state_sname		varchar(30)	  = null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime	  = null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_day_created			datetime
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	declare
	  @v_day_1		decimal(18,9)
	, @v_day_2		decimal(18,9)
	, @v_day_3		decimal(18,9)
	, @v_day_4		decimal(18,9)
	, @v_day_5		decimal(18,9)
	, @v_day_6		decimal(18,9)
	, @v_day_7		decimal(18,9)
	, @v_day_8		decimal(18,9)
	, @v_day_9		decimal(18,9)
	, @v_day_10		decimal(18,9)
	, @v_day_11		decimal(18,9)
	, @v_day_12		decimal(18,9)
	, @v_day_13		decimal(18,9)
	, @v_day_14		decimal(18,9)
	, @v_day_15		decimal(18,9)
	, @v_day_16		decimal(18,9)
	, @v_day_17		decimal(18,9)
	, @v_day_18		decimal(18,9)
	, @v_day_19		decimal(18,9)
	, @v_day_20		decimal(18,9)
	, @v_day_21		decimal(18,9)
	, @v_day_22		decimal(18,9)
	, @v_day_23		decimal(18,9)
	, @v_day_24		decimal(18,9)
	, @v_day_25		decimal(18,9)
	, @v_day_26		decimal(18,9)
	, @v_day_27		decimal(18,9)
	, @v_day_28		decimal(18,9)
	, @v_day_29		decimal(18,9)
	, @v_day_30		decimal(18,9)
	, @v_day_31		decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_month_created = dbo.usfUtils_TimeToZero(@p_day_created)
 
	 if (datepart("Day", @p_day_created) = 1)
		set @v_day_1 = @p_value
	 else
		set @v_day_1 = 0
	 if (datepart("Day", @p_day_created) = 2)
		set @v_day_2 = @p_value
	 else
		set @v_day_2 = 0
	 if (datepart("Day", @p_day_created) = 3)
		set @v_day_3 = @p_value
	 else
		set @v_day_3 = 0
	 if (datepart("Day", @p_day_created) = 4)
		set @v_day_4 = @p_value
	 else
		set @v_day_4 = 0
	 if (datepart("Day", @p_day_created) = 5)
		set @v_day_5 = @p_value
	 else
		set @v_day_5 = 0
	 if (datepart("Day", @p_day_created) = 6)
		set @v_day_6 = @p_value
	 else
		set @v_day_6 = 0
	 if (datepart("Day", @p_day_created) = 7)
		set @v_day_7 = @p_value
	 else
		set @v_day_7 = 0
	 if (datepart("Day", @p_day_created) = 8)
		set @v_day_8 = @p_value
	 else
		set @v_day_8 = 0
	 if (datepart("Day", @p_day_created) = 9)
		set @v_day_9 = @p_value
	 else
		set @v_day_9 = 0
	 if (datepart("Day", @p_day_created) = 10)
		set @v_day_10 = @p_value
	 else
		set @v_day_10 = 0
	 if (datepart("Day", @p_day_created) = 11)
		set @v_day_11 = @p_value
	 else
		set @v_day_11 = 0
	 if (datepart("Day", @p_day_created) = 12)
		set @v_day_12 = @p_value
	 else
		set @v_day_12 = 0
	 if (datepart("Day", @p_day_created) = 13)
		set @v_day_13 = @p_value
	 else
		set @v_day_13 = 0
	 if (datepart("Day", @p_day_created) = 14)
		set @v_day_14 = @p_value
	 else
		set @v_day_14 = 0
	 if (datepart("Day", @p_day_created) = 15)
		set @v_day_15 = @p_value
	 else
		set @v_day_15 = 0
	 if (datepart("Day", @p_day_created) = 16)
		set @v_day_16 = @p_value
	 else
		set @v_day_16 = 0
	 if (datepart("Day", @p_day_created) = 17)
		set @v_day_17 = @p_value
	 else
		set @v_day_17 = 0
	 if (datepart("Day", @p_day_created) = 18)
		set @v_day_18 = @p_value
	 else
		set @v_day_18 = 0
	 if (datepart("Day", @p_day_created) = 19)
		set @v_day_19 = @p_value
	 else
		set @v_day_19 = 0
	 if (datepart("Day", @p_day_created) = 20)
		set @v_day_20 = @p_value
	 else
		set @v_day_20 = 0
	 if (datepart("Day", @p_day_created) = 21)
		set @v_day_21 = @p_value
	 else
		set @v_day_21 = 0
	 if (datepart("Day", @p_day_created) = 22)
		set @v_day_22 = @p_value
	 else
		set @v_day_22 = 0
	 if (datepart("Day", @p_day_created) = 23)
		set @v_day_23 = @p_value
	 else
		set @v_day_23 = 0
	 if (datepart("Day", @p_day_created) = 24)
		set @v_day_24 = @p_value
	 else
		set @v_day_24 = 0
	 if (datepart("Day", @p_day_created) = 25)
		set @v_day_25 = @p_value
	 else
		set @v_day_25 = 0
	 if (datepart("Day", @p_day_created) = 26)
		set @v_day_26 = @p_value
	 else
		set @v_day_26 = 0
	 if (datepart("Day", @p_day_created) = 27)
		set @v_day_27 = @p_value
	 else
		set @v_day_27 = 0
	 if (datepart("Day", @p_day_created) = 28)
		set @v_day_28 = @p_value
	 else
		set @v_day_28 = 0
	 if (datepart("Day", @p_day_created) = 29)
		set @v_day_29 = @p_value
	 else
		set @v_day_29 = 0
	 if (datepart("Day", @p_day_created) = 30)
		set @v_day_30 = @p_value
	 else
		set @v_day_30 = 0
	 if (datepart("Day", @p_day_created) = 31)
		set @v_day_31 = @p_value
	 else
		set @v_day_31 = 0

insert into dbo.CREP_CAR_DAY
	  (month_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, sys_comment, sys_user_created, sys_user_modified)
select @p_month_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @v_day_1, @v_day_2, @v_day_3, @v_day_4
			,@v_day_5, @v_day_6, @v_day_7, @v_day_8, @v_day_9, @v_day_10
			,@v_day_11, @v_day_12, @v_day_13, @v_day_14, @v_day_15, @v_day_16
			,@v_day_17, @v_day_18, @v_day_19, @v_day_20, @v_day_21, @v_day_22
			,@v_day_23, @v_day_24, @v_day_25, @v_day_26, @v_day_27, @v_day_28
			,@v_day_29, @v_day_30, @v_day_31
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_CAR_DAY 
		 set
			month_created = @p_month_created
		   ,value_id = @p_value_id
		   ,state_number = @p_state_number
		   ,car_id = @p_car_id
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,begin_mntnc_date = @p_begin_mntnc_date
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,day_1 = @v_day_1
		   ,day_2 = @v_day_2
		   ,day_3 = @v_day_3
		   ,day_4 = @v_day_4
		   ,day_5 = @v_day_5
		   ,day_6 = @v_day_6
		   ,day_7 = @v_day_7
		   ,day_8 = @v_day_8
		   ,day_9 = @v_day_9
		   ,day_10 = @v_day_10
		   ,day_11 = @v_day_11
		   ,day_12 = @v_day_12
		   ,day_13 = @v_day_13
		   ,day_14 = @v_day_14
		   ,day_15 = @v_day_15
		   ,day_16 = @v_day_16
		   ,day_17 = @v_day_17
		   ,day_18 = @v_day_18
		   ,day_19 = @v_day_19
		   ,day_20 = @v_day_20
		   ,day_21 = @v_day_21
		   ,day_22 = @v_day_22
		   ,day_23 = @v_day_23
		   ,day_24 = @v_day_24
		   ,day_25 = @v_day_25
		   ,day_26 = @v_day_26
		   ,day_27 = @v_day_27
		   ,day_28 = @v_day_28
		   ,day_29 = @v_day_29
		   ,day_30 = @v_day_30
		   ,day_31 = @v_day_31
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return 

end
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

