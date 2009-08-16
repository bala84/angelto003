:r ./../_define.sql

:setvar dc_number 00327
:setvar dc_description "repair zone emp report added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.06.2008 VLavrentiev  repair zone emp report added
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


alter table dbo.CRPR_REPAIR_ZONE_MASTER
drop constraint CRPR_REPAIR_ZONE_MASTER_ORDER_MASTER_ID_FK
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь ремонтной зоны
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_repair_zone_master_id	numeric(38,0)
    ,@p_work_desc				varchar(2000) = '-//-'
	,@p_hour_amount				decimal(18,9)
	,@p_employee_worker_id		numeric(38,0) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  set xact_abort on
	declare
		 @v_order_state			smallint
		,@v_Error				int
        	,@v_TrancountOnEntry int
		,@v_date_created		datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
  
  if (@@tranCount = 0)
    begin transaction  

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CRPR_REPAIR_ZONE_DETAIL 
            ( repair_zone_master_id, work_desc
			, hour_amount, employee_worker_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_repair_zone_master_id, @p_work_desc
			, @p_hour_amount, @p_employee_worker_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_DETAIL set
		 repair_zone_master_id = @p_repair_zone_master_id
		,work_desc = @p_work_desc
		,hour_amount = @p_hour_amount
		,employee_worker_id = @p_employee_worker_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

select @v_date_created = a.date_started
from dbo.CRPR_REPAIR_ZONE_MASTER as a
where a.id = @p_repair_zone_master_id


exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @p_employee_worker_id
	,@p_last_date_created			= null
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
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_REPAIR_TIME_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о времени ремонта 
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_month_created		datetime		= null
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error				int
    	,@v_TrancountOnEntry int
	,@v_value_id			numeric(38,0)
	,@v_month_created		datetime
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
	
  
 set  @v_value_id = dbo.usfConst('CAR_REPAIR_TIME')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_month_created)



select @v_day_1 = sum(case when datepart("Day", b.date_created) = 1
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then datediff("mi", c.date_started, c.date_ended)
				else 0
		   end)  
  from dbo.CWRH_WRH_ORDER_MASTER as b
	left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c
		on b.repair_zone_master_id = c.id 
where b.car_id = @p_car_id
   and date_created > = @v_month_created
   and date_created < dateadd("mm", 1, @v_month_created)

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_SaveById
			 @p_month_created  = @v_month_created
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
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_organization_id = @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user



       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_RUN_TIME_AFTER_TO_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о времени наработки на отказ
** после ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_month_created		datetime		= null
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error				int
    	,@v_TrancountOnEntry int
	,@v_value_id			numeric(38,0)
	,@v_month_created		datetime
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
	,@v_ts_type_route_master_id		numeric(38,0)
	
  
 set  @v_value_id = dbo.usfConst('CAR_RUN_TIME_AFTER_TO')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_month_created)

 select @v_ts_type_route_master_id = ts_type_route_master_id
	from dbo.CCAR_CAR_MODEL
	where id = (select car_model_id from dbo.CCAR_CAR
				where id = @p_car_id)


select @v_day_1 = sum(case when datepart("Day", a.date_created) = 1
				then d.val
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", a.date_created) = 2
				then d.val
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", a.date_created) = 3
				then d.val
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", a.date_created) = 4
				then d.val
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", a.date_created) = 5
				then d.val
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", a.date_created) = 6
				then d.val
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", a.date_created) = 7
				then d.val
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", a.date_created) = 8
				then d.val
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", a.date_created) = 9
				then d.val
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", a.date_created) = 10
				then d.val
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", a.date_created) = 11
				then d.val
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", a.date_created) = 12
				then d.val
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", a.date_created) = 13
				then d.val
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", a.date_created) = 14
				then d.val
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", a.date_created) = 15
				then d.val
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", a.date_created) = 16
				then d.val
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", a.date_created) = 17
				then d.val
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", a.date_created) = 18
				then d.val
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", a.date_created) = 19
				then d.val
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", a.date_created) = 20
				then d.val
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", a.date_created) = 21
				then d.val
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", a.date_created) = 22
				then d.val
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", a.date_created) = 23
				then d.val
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", a.date_created) = 24
				then d.val
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", a.date_created) = 25
				then d.val
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", a.date_created) = 26
				then d.val
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", a.date_created) = 27
				then d.val
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", a.date_created) = 28
				then d.val
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", a.date_created) = 29
				then d.val
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", a.date_created) = 30
				then d.val
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", a.date_created) = 31
				then d.val
				else 0
		   end)  
  from dbo.CWRH_WRH_ORDER_MASTER as a
	left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c
		on a.repair_zone_master_id = c.id 
    outer apply
			(
			select sum(datediff("mi", c.fact_start_duty, c.fact_end_duty)) as val
			  from dbo.CDRV_DRIVER_LIST as c
			where c.car_id = @p_car_id
			  and c.date_created >= 
							--Найдем дату окончания последнего ремонта
						(select top(1) c.date_ended
							from dbo.CWRH_WRH_ORDER_MASTER as b
							 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
							  on b.id = e.wrh_order_master_id
						left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c
							  on b.repair_zone_master_id = c.id 
						  where b.car_id = @p_car_id
							and b.date_created <= a.date_created
							and b.id != (select top(1) b2.id from dbo.CWRH_WRH_ORDER_MASTER as b2
										  	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e2
												on b2.id = e2.wrh_order_master_id
										   where b2.car_id = @p_car_id
											 and b2.date_created <= a.date_created
											 and exists
											(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as h
												where h.ts_type_route_master_id = @v_ts_type_route_master_id
												  and h.ts_type_master_id = e2.repair_type_master_id)
										   order by b2.date_created desc)
							and b.order_state = 1
							and exists
								(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as h
									where h.ts_type_route_master_id = @v_ts_type_route_master_id
									  and h.ts_type_master_id = e.repair_type_master_id)
							order by b.date_created desc)
							-- И посчитаем до даты последнего заказа-наряда к моменту подсчета
			  and c.date_created < (select top(1) b3.date_created from dbo.CWRH_WRH_ORDER_MASTER as b3
										  	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e3
												on b3.id = e3.wrh_order_master_id
										   where b3.car_id = @p_car_id
											 and b3.date_created <= a.date_created
											 and exists
											(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as h
												where h.ts_type_route_master_id = @v_ts_type_route_master_id
												  and h.ts_type_master_id = e3.repair_type_master_id)
										   order by b3.date_created desc)) as d
where a.car_id = @p_car_id
   and date_created > = @v_month_created
   and date_created < dateadd("mm", 1, @v_month_created)

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_SaveById
			 @p_month_created  = @v_month_created
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
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_organization_id = @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user



       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_RUN_TIME_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о времени наработки на отказ
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_month_created		datetime		= null
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error				int
    	,@v_TrancountOnEntry int
	,@v_value_id			numeric(38,0)
	,@v_month_created		datetime
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
	,@v_prev_date_ended		datetime
	,@v_value				decimal(18,9)
	
  
 set  @v_value_id = dbo.usfConst('CAR_RUN_TIME')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_month_created)


select @v_day_1 = sum(case when datepart("Day", a.date_created) = 1
				then d.val
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", a.date_created) = 2
				then d.val
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", a.date_created) = 3
				then d.val
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", a.date_created) = 4
				then d.val
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", a.date_created) = 5
				then d.val
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", a.date_created) = 6
				then d.val
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", a.date_created) = 7
				then d.val
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", a.date_created) = 8
				then d.val
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", a.date_created) = 9
				then d.val
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", a.date_created) = 10
				then d.val
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", a.date_created) = 11
				then d.val
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", a.date_created) = 12
				then d.val
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", a.date_created) = 13
				then d.val
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", a.date_created) = 14
				then d.val
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", a.date_created) = 15
				then d.val
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", a.date_created) = 16
				then d.val
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", a.date_created) = 17
				then d.val
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", a.date_created) = 18
				then d.val
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", a.date_created) = 19
				then d.val
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", a.date_created) = 20
				then d.val
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", a.date_created) = 21
				then d.val
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", a.date_created) = 22
				then d.val
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", a.date_created) = 23
				then d.val
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", a.date_created) = 24
				then d.val
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", a.date_created) = 25
				then d.val
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", a.date_created) = 26
				then d.val
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", a.date_created) = 27
				then d.val
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", a.date_created) = 28
				then d.val
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", a.date_created) = 29
				then d.val
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", a.date_created) = 30
				then d.val
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", a.date_created) = 31
				then d.val
				else 0
		   end)  
  from dbo.CWRH_WRH_ORDER_MASTER as a
	left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c
		on a.repair_zone_master_id = c.id 
    outer apply
			(
			select sum(datediff("mi", c.fact_start_duty, c.fact_end_duty)) as val
			  from dbo.CDRV_DRIVER_LIST as c
			where c.car_id = @p_car_id
			  and c.date_created >= 
							--Найдем дату окончания последнего ремонта
						(select top(1) c.date_ended
							from dbo.CWRH_WRH_ORDER_MASTER as b
						left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c
							  on b.repair_zone_master_id = c.id 
						  where b.car_id = @p_car_id
							and b.date_created <= a.date_created
							and b.id != (select top(1) id from dbo.CWRH_WRH_ORDER_MASTER
										   where car_id = @p_car_id
											 and date_created <= a.date_created
										   order by date_created desc)
							and b.order_state = 1
							order by b.date_created desc)
							-- И посчитаем до даты последнего заказа-наряда к моменту подсчета
			  and c.date_created < (select top(1) date_created from dbo.CWRH_WRH_ORDER_MASTER
										   where car_id = @p_car_id
											 and date_created <= a.date_created
										   order by date_created desc)) as d
where a.car_id = @p_car_id
   and date_created > = @v_month_created
   and date_created < dateadd("mm", 1, @v_month_created)

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_SaveById
			 @p_month_created  = @v_month_created
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
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_organization_id = @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user



       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
go 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_CAR_REPAIR_TIME_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о времени ремонта и времени наработки на отказ
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_day_1				 decimal(18,9) = 0
	,@p_day_2				 decimal(18,9) = 0
	,@p_day_3				 decimal(18,9) = 0
	,@p_day_4				 decimal(18,9) = 0
	,@p_day_5				 decimal(18,9) = 0
	,@p_day_6				 decimal(18,9) = 0
	,@p_day_7				 decimal(18,9) = 0
	,@p_day_8				 decimal(18,9) = 0
	,@p_day_9			     decimal(18,9) = 0
	,@p_day_10				 decimal(18,9) = 0
	,@p_day_11				 decimal(18,9) = 0
	,@p_day_12				 decimal(18,9) = 0
	,@p_day_13				 decimal(18,9) = 0
	,@p_day_14				 decimal(18,9) = 0
	,@p_day_15				 decimal(18,9) = 0
	,@p_day_16				 decimal(18,9) = 0
	,@p_day_17				 decimal(18,9) = 0
	,@p_day_18				 decimal(18,9) = 0
	,@p_day_19				 decimal(18,9) = 0
	,@p_day_20				 decimal(18,9) = 0
	,@p_day_21				 decimal(18,9) = 0
	,@p_day_22				 decimal(18,9) = 0
	,@p_day_23				 decimal(18,9) = 0
	,@p_day_24				 decimal(18,9) = 0
	,@p_day_25				 decimal(18,9) = 0
	,@p_day_26				 decimal(18,9) = 0
	,@p_day_27				 decimal(18,9) = 0
	,@p_day_28				 decimal(18,9) = 0
	,@p_day_29				 decimal(18,9) = 0
	,@p_day_30				 decimal(18,9) = 0
	,@p_day_31				 decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_month_created = dbo.usfUtils_TimeToZero(@p_month_created)

	 if (@p_day_1 is null)
		set @p_day_1 = 0

	 if (@p_day_2 is null)
		set @p_day_2 = 0

	 if (@p_day_3 is null)
		set @p_day_3 = 0

	 if (@p_day_4 is null)
		set @p_day_4 = 0

	 if (@p_day_5 is null)
		set @p_day_5 = 0

	 if (@p_day_6 is null)
		set @p_day_6 = 0

	 if (@p_day_7 is null)
		set @p_day_7 = 0

	 if (@p_day_8 is null)
		set @p_day_8 = 0

	 if (@p_day_9 is null)
		set @p_day_9 = 0

	 if (@p_day_10 is null)
		set @p_day_10 = 0

	 if (@p_day_11 is null)
		set @p_day_11 = 0

	 if (@p_day_12 is null)
		set @p_day_12 = 0

	 if (@p_day_13 is null)
		set @p_day_13 = 0

	 if (@p_day_14 is null)
		set @p_day_14 = 0

	 if (@p_day_15 is null)
		set @p_day_15 = 0

	 if (@p_day_16 is null)
		set @p_day_16 = 0

	 if (@p_day_17 is null)
		set @p_day_17 = 0

	 if (@p_day_18 is null)
		set @p_day_18 = 0

	 if (@p_day_19 is null)
		set @p_day_19 = 0

	 if (@p_day_20 is null)
		set @p_day_20 = 0

	 if (@p_day_21 is null)
		set @p_day_21 = 0

	 if (@p_day_22 is null)
		set @p_day_22 = 0

	 if (@p_day_23 is null)
		set @p_day_23 = 0

	 if (@p_day_24 is null)
		set @p_day_24 = 0

	 if (@p_day_25 is null)
		set @p_day_25 = 0

	 if (@p_day_26 is null)
		set @p_day_26 = 0

	 if (@p_day_27 is null)
		set @p_day_27 = 0

	 if (@p_day_28 is null)
		set @p_day_28 = 0

	 if (@p_day_29 is null)
		set @p_day_29 = 0

	 if (@p_day_30 is null)
		set @p_day_30 = 0

	 if (@p_day_31 is null)
		set @p_day_31 = 0

 

insert into dbo.CREP_CAR_REPAIR_TIME_DAY
	  (month_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, organization_id, organization_sname
			, sys_comment, sys_user_created, sys_user_modified)
select @p_month_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_day_1, @p_day_2, @p_day_3, @p_day_4
			,@p_day_5, @p_day_6, @p_day_7, @p_day_8, @p_day_9, @p_day_10
			,@p_day_11, @p_day_12, @p_day_13, @p_day_14, @p_day_15, @p_day_16
			,@p_day_17, @p_day_18, @p_day_19, @p_day_20, @p_day_21, @p_day_22
			,@p_day_23, @p_day_24, @p_day_25, @p_day_26, @p_day_27, @p_day_28
			,@p_day_29, @p_day_30, @p_day_31
			,@p_organization_id, @p_organization_sname
	        ,@p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_REPAIR_TIME_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_CAR_REPAIR_TIME_DAY
		 set
		    state_number = @p_state_number
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,day_1 = @p_day_1
		   ,day_2 = @p_day_2
		   ,day_3 = @p_day_3
		   ,day_4 = @p_day_4
		   ,day_5 = @p_day_5
		   ,day_6 = @p_day_6
		   ,day_7 = @p_day_7
		   ,day_8 = @p_day_8
		   ,day_9 = @p_day_9
		   ,day_10 = @p_day_10
		   ,day_11 = @p_day_11
		   ,day_12 = @p_day_12
		   ,day_13 = @p_day_13
		   ,day_14 = @p_day_14
		   ,day_15 = @p_day_15
		   ,day_16 = @p_day_16
		   ,day_17 = @p_day_17
		   ,day_18 = @p_day_18
		   ,day_19 = @p_day_19
		   ,day_20 = @p_day_20
		   ,day_21 = @p_day_21
		   ,day_22 = @p_day_22
		   ,day_23 = @p_day_23
		   ,day_24 = @p_day_24
		   ,day_25 = @p_day_25
		   ,day_26 = @p_day_26
		   ,day_27 = @p_day_27
		   ,day_28 = @p_day_28
		   ,day_29 = @p_day_29
		   ,day_30 = @p_day_30
		   ,day_31 = @p_day_31
			,organization_id = @p_organization_id
			,organization_sname = @p_organization_sname
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return 

end
go 


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
