:r ./../_define.sql

:setvar dc_number 00348
:setvar dc_description "mech employee hour rep fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    07.07.2008 VLavrentiev  mech employee hour rep fixed
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

ALTER PROCEDURE [dbo].[uspVREP_MECH_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по сотрудникам механикам
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
	,@v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
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

 set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)


select @v_hour_0 = 
		sum(case datepart("Hh", a.date_ended)
	   when 0 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", a.date_ended)
	   when 1 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", a.date_ended)
	   when 2 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", a.date_ended)
	   when 3 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", a.date_ended)
	   when 4 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", a.date_ended) 
	   when 5
	   then hour_amount 
		else 0
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", a.date_ended)
	   when 6 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", a.date_ended)
	   when 7 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", a.date_ended)
	   when 8 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", a.date_ended)
	   when 9 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", a.date_ended)
	   when 10 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", a.date_ended)
	   when 11
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", a.date_ended)
	   when 12 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", a.date_ended)
	   when 13 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", a.date_ended)
	   when 14 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", a.date_ended)
	   when 15 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", a.date_ended)
	   when 16
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", a.date_ended)
	   when 17 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", a.date_ended)
	   when 18 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", a.date_ended)
	   when 19 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", a.date_ended)
	   when 20
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", a.date_ended)
	   when 21
	   then hour_amount 
	   else 0
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", a.date_ended)
	   when 22 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", a.date_ended)
	   when 23
	   then hour_amount
	   else 0
	   end)
 from dbo.CRPR_REPAIR_ZONE_MASTER as a
    join dbo.CRPR_REPAIR_ZONE_DETAIL  as b
      on a.id = b.repair_zone_master_id
 where b.employee_worker_id = @p_employee_id
   and a.date_started > = @v_day_created
   and a.date_started < @v_day_created + 1

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
			,@p_month_created = @v_month_created
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
		  		,@p_month_created 		= @v_day_created
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
		  		,@p_month_created 		= @v_day_created
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
		  		,@p_month_created 		= @v_day_created
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
--Общее кол-во часов не должно быть больше 12
if (@v_value_total > 12)
 set @v_value_total = 12
--Если дневные часы равны 12 или больше - то ночных не должно быть
if (@v_value_day >= 12)
 begin
  set @v_value_night = 0
  set @v_value_day = 12
 end

--Ночных часов должно быть не больше 6
if (@v_value_night > 6)
 set @v_value_night = 6


--Если сумма больше 12 - значит дневное значение больше шести, потому что ночное значение уже не может быть больше 6

if (@v_value_day + @v_value_night) > 12
 set @v_value_night = @v_value_night - ((@v_value_day + @v_value_night) - 12)

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
		  		,@p_month_created 		= @v_day_created
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
		  		,@p_month_created 		= @v_day_created
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
		  		,@p_month_created 		= @v_day_created
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


GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_AMOUNT_DAY_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_AMOUNT_DAY_SelectAll] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве выходов и 
** и среднем количестве выходов автомобилей
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set @v_value_id = dbo.usfConst('CAR_EXIT_AMOUNT')
  
select
	  month_created
	 ,organization_sname
	 ,organization_id
	 ,day_created
	 ,value_id
	 ,state_number
	 ,car_id
	 ,car_type_id
	 ,car_type_sname
	 ,car_state_id
	 ,car_state_sname
	 ,car_mark_id
	 ,car_mark_sname
	 ,car_model_id 
	 ,car_model_sname
	 ,begin_mntnc_date
	 ,fuel_type_id
	 ,fuel_type_sname
	 ,car_kind_id
	 ,car_kind_sname
	 ,convert(decimal(18,2),(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else day_1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else day_2
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else day_3
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else day_4
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else day_5
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else day_6
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else day_7
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else day_8
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else day_9
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else day_10
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else day_11
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else day_12
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else day_13
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else day_14
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else day_15
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else day_16
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else day_17
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else day_18
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else day_19
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else day_20
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else day_21
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else day_22
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else day_23
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else day_24
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else day_25
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else day_26
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else day_27
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else day_28
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else day_29
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else day_30
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else day_31
			end)
	/(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else 1
			end)) as average_value
	 ,day_1,day_2,day_3,day_4,day_5,day_6,day_7,day_8,day_9,day_10,day_11,day_12,day_13
	 ,day_14,day_15,day_16,day_17,day_18,day_19,day_20,day_21,day_22,day_23,day_24,day_25,day_26
	 ,day_27,day_28,day_29,day_30,day_31
     from
    (SELECT     
		   dbo.usfUtils_DayTo01(month_created) as month_created
		 , organization_sname
		 , organization_id 
		 , max(month_created) as day_created
		 , value_id
		 , (select top(1) state_number from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as state_number
		 , car_id
		 , (select top(1) car_type_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_type_id
		 , (select top(1) car_type_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_type_sname
		 , (select top(1) car_state_id	from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_state_id
		 , (select top(1) car_state_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_state_sname
		 , (select top(1) car_mark_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_mark_id
		 , (select top(1) car_mark_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_mark_sname
		 , (select top(1) car_model_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as  car_model_id
		 , (select top(1) car_model_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_model_sname
		 , (select top(1) begin_mntnc_date from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as begin_mntnc_date
		 , (select top(1) fuel_type_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as fuel_type_id
		 , (select top(1) fuel_type_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as fuel_type_sname
		 , (select top(1) car_kind_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_kind_id
		 , (select top(1) car_kind_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_kind_sname
		 , sum(convert(decimal(18,0),day_1)) as day_1
		 , sum(convert(decimal(18,0),day_2)) as day_2, sum(convert(decimal(18,0),day_3)) as day_3
		 , sum(convert(decimal(18,0),day_4)) as day_4, sum(convert(decimal(18,0),day_5)) as day_5
		 , sum(convert(decimal(18,0),day_6)) as day_6, sum(convert(decimal(18,0),day_7)) as day_7
		 , sum(convert(decimal(18,0),day_8)) as day_8, sum(convert(decimal(18,0),day_9)) as day_9
		 , sum(convert(decimal(18,0),day_10)) as day_10, sum(convert(decimal(18,0),day_11)) as day_11
		 , sum(convert(decimal(18,0),day_12)) as day_12, sum(convert(decimal(18,0),day_13)) as day_13
		 , sum(convert(decimal(18,0),day_14)) as day_14, sum(convert(decimal(18,0),day_15)) as day_15
		 , sum(convert(decimal(18,0),day_16)) as day_16, sum(convert(decimal(18,0),day_17)) as day_17
		 , sum(convert(decimal(18,0),day_18)) as day_18, sum(convert(decimal(18,0),day_19)) as day_19
		 , sum(convert(decimal(18,0),day_20)) as day_20, sum(convert(decimal(18,0),day_21)) as day_21
		 , sum(convert(decimal(18,0),day_22)) as day_22, sum(convert(decimal(18,0),day_23)) as day_23
		 , sum(convert(decimal(18,0),day_24)) as day_24, sum(convert(decimal(18,0),day_25)) as day_25
		 , sum(convert(decimal(18,0),day_26)) as day_26, sum(convert(decimal(18,0),day_27)) as day_27
		 , sum(convert(decimal(18,0),day_28)) as day_28, sum(convert(decimal(18,0),day_29)) as day_29
		 , sum(convert(decimal(18,0),day_30)) as day_30, sum(convert(decimal(18,0),day_31)) as day_31
	FROM dbo.utfVREP_CAR_DAY() as a
	where month_created between  @p_start_date and @p_end_date
	  and value_id = @v_value_id
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null) 
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	group by 
		   dbo.usfUtils_DayTo01(month_created)
		 , organization_id
		 , organization_sname
		 , value_id
		 , car_id) as a
--order by 
--	  month_created
--	 ,organization_sname
--	 ,state_number

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


