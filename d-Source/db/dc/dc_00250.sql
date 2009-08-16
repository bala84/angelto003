:r ./../_define.sql

:setvar dc_number 00250
:setvar dc_description "report last_day fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    17.05.2008 VLavrentiev  report last_day fix
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

ALTER PROCEDURE [dbo].[uspVREP_CAR_Prepare]
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
	,@p_last_date_created			datetime = null
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
				,@p_last_date_created	= @p_last_date_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user
--end			


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

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_Prepare]
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
	,@p_last_date_created	datetime		= null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
  
  declare
	 @v_person_id			numeric(38,0)
	,@v_lastname			varchar(100)
	,@v_name				varchar(60)
	,@v_surname				varchar(60)
	,@v_organization_id		numeric(38,0)
	,@v_organization_sname	varchar(30)
	,@v_employee_type_id	numeric(38,0)
	,@v_employee_type_sname	varchar(30)


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


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

      if (@@tranCount = 0)
        begin transaction 

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
	,@p_last_date_created	= @p_last_date_created
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

if (@p_last_date_created is not null)
begin
  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_last_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
	,@p_last_date_created	= @p_last_date_created
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 end

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

return
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




