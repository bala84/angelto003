:r ./../_define.sql

:setvar dc_number 00159                  
:setvar dc_description "rep_car fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.04.2008 VLavrentiev  rep_car fixed
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

ALTER procedure [dbo].[uspVREP_CAR_HOUR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о дне по автомобилю
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_day_created			datetime	  = null
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
	,@p_hour_0				decimal(18,9) = 0
	,@p_hour_1				decimal(18,9) = 0	
	,@p_hour_2				decimal(18,9) = 0
	,@p_hour_3				decimal(18,9) = 0
	,@p_hour_4				decimal(18,9) = 0
	,@p_hour_5				decimal(18,9) = 0
	,@p_hour_6				decimal(18,9) = 0
	,@p_hour_7				decimal(18,9) = 0
	,@p_hour_8				decimal(18,9) = 0
	,@p_hour_9				decimal(18,9) = 0
	,@p_hour_10				decimal(18,9) = 0
	,@p_hour_11				decimal(18,9) = 0
	,@p_hour_12				decimal(18,9) = 0
	,@p_hour_13				decimal(18,9) = 0
	,@p_hour_14				decimal(18,9) = 0
	,@p_hour_15				decimal(18,9) = 0
	,@p_hour_16				decimal(18,9) = 0
	,@p_hour_17				decimal(18,9) = 0
	,@p_hour_18				decimal(18,9) = 0
	,@p_hour_19				decimal(18,9) = 0
	,@p_hour_20				decimal(18,9) = 0
	,@p_hour_21				decimal(18,9) = 0
	,@p_hour_22				decimal(18,9) = 0
	,@p_hour_23				decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

	declare @v_value decimal(18,9)
		   ,@v_month_created datetime

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_day_created is null)
	  set @p_day_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_day_created = dbo.usfUtils_TimeToZero(@p_day_created) 
	 if (@p_hour_0 is null)
	set @p_hour_0 = 0
	 if (@p_hour_1 is null)
	set @p_hour_1 = 0
	 if (@p_hour_2 is null)
	set @p_hour_2 = 0
	 if (@p_hour_3 is null)
	set @p_hour_3 = 0
	 if (@p_hour_4 is null)
	set @p_hour_4 = 0
	 if (@p_hour_5 is null)
	set @p_hour_5 = 0
	 if (@p_hour_6 is null)
	set @p_hour_6 = 0
	 if (@p_hour_7 is null)
	set @p_hour_7 = 0
	 if (@p_hour_8 is null)
	set @p_hour_8 = 0
	 if (@p_hour_9 is null)
	set @p_hour_9 = 0
	 if (@p_hour_10 is null)
	set @p_hour_10 = 0
	 if (@p_hour_11 is null)
	set @p_hour_11 = 0
	 if (@p_hour_12 is null)
	set @p_hour_12 = 0
	 if (@p_hour_13 is null)
	set @p_hour_13 = 0
	 if (@p_hour_14 is null)
	set @p_hour_14 = 0
	 if (@p_hour_15 is null)
	set @p_hour_15 = 0
	 if (@p_hour_16 is null)
	set @p_hour_16 = 0
	 if (@p_hour_17 is null)
	set @p_hour_17 = 0
	 if (@p_hour_18 is null)
	set @p_hour_18 = 0
	 if (@p_hour_19 is null)
	set @p_hour_19 = 0
	 if (@p_hour_20 is null)
	set @p_hour_20 = 0
	 if (@p_hour_21 is null)
	set @p_hour_21 = 0
	 if (@p_hour_22 is null)
	set @p_hour_22 = 0
	 if (@p_hour_23 is null)
	set @p_hour_23 = 0


    insert into dbo.CREP_CAR_HOUR
            (day_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, hour_0, hour_1, hour_2
			,hour_3, hour_4, hour_5, hour_6
			,hour_7, hour_8, hour_9, hour_10
			,hour_11, hour_12, hour_13, hour_14
			,hour_15, hour_16, hour_17, hour_18
			,hour_19, hour_20, hour_21, hour_22
			,hour_23, sys_comment, sys_user_created, sys_user_modified)
	select   @p_day_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_hour_0, @p_hour_1, @p_hour_2
			,@p_hour_3, @p_hour_4, @p_hour_5, @p_hour_6
			,@p_hour_7, @p_hour_8, @p_hour_9, @p_hour_10
			,@p_hour_11, @p_hour_12, @p_hour_13, @p_hour_14
			,@p_hour_15, @p_hour_16, @p_hour_17, @p_hour_18
			,@p_hour_19, @p_hour_20, @p_hour_21, @p_hour_22
			,@p_hour_23, @p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_CAR_HOUR as b
		 where b.day_created = @p_day_created
		   and b.value_id = @p_value_id
		   and b.car_id = @p_car_id) 
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_CAR_HOUR 
		 set
			 state_number = @p_state_number
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
			,hour_0 = @p_hour_0
			,hour_1 = @p_hour_1
			,hour_2 = @p_hour_2
			,hour_3 = @p_hour_3
			,hour_4 = @p_hour_4
			,hour_5 = @p_hour_5
			,hour_6 = @p_hour_6
			,hour_7 = @p_hour_7
			,hour_8 = @p_hour_8
			,hour_9 = @p_hour_9
			,hour_10 = @p_hour_10
			,hour_11 = @p_hour_11
			,hour_12 = @p_hour_12
			,hour_13 = @p_hour_13
			,hour_14 = @p_hour_14
			,hour_15 = @p_hour_15
			,hour_16 = @p_hour_16
			,hour_17 = @p_hour_17
			,hour_18 = @p_hour_18
			,hour_19 = @p_hour_19
			,hour_20 = @p_hour_20
			,hour_21 = @p_hour_21
			,hour_22 = @p_hour_22
			,hour_23 = @p_hour_23
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where day_created = @p_day_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id


    
  return 

end
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
 set  @v_car_work_hour_amnt = datediff("mi", @p_fact_start_duty, @p_fact_end_duty)
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_car_work_hour_amnt
if (@v_hour = 1)
  set @v_hour_1 = @v_car_work_hour_amnt
if (@v_hour = 2)
  set @v_hour_2 = @v_car_work_hour_amnt
if (@v_hour = 3)
  set @v_hour_3 = @v_car_work_hour_amnt
if (@v_hour = 4)
  set @v_hour_4 = @v_car_work_hour_amnt
if (@v_hour = 5)
  set @v_hour_5 = @v_car_work_hour_amnt
if (@v_hour = 6)
  set @v_hour_6 = @v_car_work_hour_amnt
if (@v_hour = 7)
  set @v_hour_7 = @v_car_work_hour_amnt
if (@v_hour = 8)
  set @v_hour_8 = @v_car_work_hour_amnt
if (@v_hour = 9)
  set @v_hour_9 = @v_car_work_hour_amnt
if (@v_hour = 10)
  set @v_hour_10  = @v_car_work_hour_amnt
if (@v_hour = 11)
  set @v_hour_11  = @v_car_work_hour_amnt
if (@v_hour = 12)
  set @v_hour_12  = @v_car_work_hour_amnt
if (@v_hour = 13)
  set @v_hour_13  = @v_car_work_hour_amnt
if (@v_hour = 14)
  set @v_hour_14  = @v_car_work_hour_amnt
if (@v_hour = 15)
  set @v_hour_15  = @v_car_work_hour_amnt 
if (@v_hour = 16)
  set @v_hour_16  = @v_car_work_hour_amnt
if (@v_hour = 17)
  set @v_hour_17  = @v_car_work_hour_amnt
if (@v_hour = 18)
  set @v_hour_18  = @v_car_work_hour_amnt
if (@v_hour = 19)
  set @v_hour_19  = @v_car_work_hour_amnt 
if (@v_hour = 20)
  set @v_hour_20  = @v_car_work_hour_amnt
if (@v_hour = 21)
  set @v_hour_21  = @v_car_work_hour_amnt
if (@v_hour = 22)
  set @v_hour_22  = @v_car_work_hour_amnt
if (@v_hour = 23)
  set @v_hour_23  = @v_car_work_hour_amnt

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @p_day_created
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


   set @v_value = @v_hour_0 + @v_hour_1 + @v_hour_2
					 + @v_hour_3 + @v_hour_4 + @v_hour_5 + @v_hour_6
					 + @v_hour_7 + @v_hour_8 + @v_hour_9 + @v_hour_10
					 + @v_hour_11 + @v_hour_12 + @v_hour_13 + @v_hour_14
					 + @v_hour_15 + @v_hour_16 + @v_hour_17 + @v_hour_18
					 + @v_hour_19 + @v_hour_20 + @v_hour_21 + @v_hour_22
					 + @v_hour_23
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

