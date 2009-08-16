:r ./../_define.sql

:setvar dc_number 00363
:setvar dc_description "driver list save wrong ids fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.08.2008 VLavrentiev  driver list save wrong ids fixed
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


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
	,@p_pw_trailer_amount			decimal(18,9) = 0.0
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error			   int
         , @v_TrancountOnEntry int
		 , @v_action		   char(1)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_last_car_id	   numeric(38,0)
		 , @v_last_emp_id	   numeric(38,0)
		 , @v_error_run		   decimal(18,9) 
		 , @v_condition_id     numeric(38,0)
		 , @v_error_date_created datetime
		 , @v_error_number	     numeric(38,0)
		 , @v_error_fact_start_duty datetime
		 , @v_error_fact_end_duty   datetime
		 , @v_error_fuel_exp		decimal(18,9)
		 , @v_error_fuel_type_id    numeric(38,0)
		 , @v_error_organization_id numeric(38,0)
		 , @v_error_speedometer_start_indctn decimal(18,9)
		 , @v_error_speedometer_end_indctn	 decimal(18,9)
		 , @v_error_fuel_start_left			 decimal(18,9)			 
		 , @v_error_fuel_end_left			 decimal(18,9)
		 , @v_error_fuel_gived				 decimal(18,9)
		 , @v_error_fuel_return				 decimal(18,9)	
		 , @v_error_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_error_fuel_consumption		 decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	-- if (@p_fuel_exp is null)
   -- set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	-- if (@p_speedometer_end_indctn is null)		
   -- set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	-- if (@p_fuel_end_left is null) 
	--set @p_fuel_end_left = 0.0

	-- if (@p_fuel_gived is null)
   -- set @p_fuel_gived = 0.0

	-- if (@p_fuel_return	is null)
	--set @p_fuel_return = 0.0

	-- if (@p_fuel_addtnl_exp is null)
   -- set @p_fuel_addtnl_exp = 0.0

	-- if (@p_run is null)
   -- set @p_run = 0.0

	-- if (@p_fuel_consumption is null)
	--set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

	 if (@p_pw_trailer_amount is null)
	set @p_pw_trailer_amount = 0.0

	set @v_trailer_id = dbo.usfConst('Энергоустановка')

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
	--Запомним совершенное действие
	  set @v_action = 'I'
    end   
       
	    
 else
	begin
  -- запомним последние значения машины и водителя	
	select  @v_last_car_id = car_id
		   ,@v_last_emp_id = employee1_id
		   ,@v_error_date_created = date_created
		   ,@v_error_number = number
		   ,@v_error_fact_start_duty = fact_start_duty
		   ,@v_error_fact_end_duty = fact_end_duty
		   ,@v_error_fuel_exp = fuel_exp
		   ,@v_error_fuel_type_id = fuel_type_id
		   ,@v_error_organization_id = organization_id
		   ,@v_error_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_error_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_error_fuel_start_left = fuel_start_left
		   ,@v_error_fuel_end_left = fuel_end_left
		   ,@v_error_fuel_gived = fuel_gived
		   ,@v_error_fuel_return = fuel_return	
		   ,@v_error_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_last_run = run	
		   ,@v_error_fuel_consumption	= fuel_consumption
	  from dbo.CDRV_DRIVER_LIST
	where id = @p_id
  -- надо править существующий
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
--Запомним совершенное действие
	set @v_action = 'E'

	end

  exec  @v_Error = dbo.uspVDRV_TRAILER_SaveById 
   @p_device_id			= @v_trailer_id
  ,@p_work_hour_amount	= @p_pw_trailer_amount
  ,@p_driver_list_id	= @p_id 
  ,@p_sys_comment		= @p_sys_comment
  ,@p_sys_user			= @p_sys_user

if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end



--Построим отчет по путевому листу
  exec @v_Error = 
        dbo.uspVREP_DRIVER_LIST_Prepare
	 @p_id							=  @p_id
    ,@p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty	
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_driver_list_state_id		= @p_driver_list_state_id
	,@p_driver_list_type_id			= @p_driver_list_type_id
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn	
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp
	,@p_last_run					= @p_last_run
	,@p_run							= @p_run
	,@p_fuel_consumption			= @p_fuel_consumption
	,@p_last_date_created			= @p_last_date_created 
    ,@p_sys_comment			= @p_sys_comment  
  	,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end
-- Изменим состояние автомобиля, если известны значения по приезду
-- например, показание спидометра
if (@p_speedometer_end_indctn is not null)
begin
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)
  if (@p_car_id = @v_last_car_id)
   begin
	if (@v_action = 'E') and (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
	else
     begin
-- Убедимся, что при отсутствии изменений пробега мы не увеличим пробег
	if (@v_action = 'E') and (@p_last_run = 0) and (@p_condition_id is not null)
		set @p_run = 0
	 end
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
 -- Если поменялась машина, то мы должны вычесть у ошибочной машины прибавленный пробег
 if (@p_car_id <> @v_last_car_id)
 begin

   set @v_error_run = -@v_last_run

   select @v_condition_id = id
	 from dbo.CCAR_CONDITION
	where car_id = @v_last_car_id

   exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @v_condition_id
    		,@p_car_id		        = @v_last_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @v_error_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @v_error_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @v_error_speedometer_start_indctn
			,@p_fuel_start_left = @v_error_fuel_start_left
			,@p_fuel_end_left = @v_error_fuel_start_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

    if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
 end
--Посчитаем отчеты, если у нас закрытый п/л
if (@p_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Незачем пересчитывать на прошлый и текущий день, если не было редактирования
 if (@p_edit_state <> 'E')
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
-- пересчитаем измененный автомобиль на всякий случай
if (@p_car_id <> @v_last_car_id)
 begin
   --Отчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_error_date_created
	,@p_number						= @v_error_number
	,@p_car_id						= @v_last_car_id
	,@p_fact_start_duty				= @v_error_fact_start_duty
	,@p_fact_end_duty				= @v_error_fact_end_duty
	,@p_fuel_exp					= @v_error_fuel_exp
	,@p_fuel_type_id				= @v_error_fuel_type_id
	,@p_organization_id				= @v_error_organization_id
	,@p_employee1_id				= @v_last_emp_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @v_error_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_error_speedometer_end_indctn
	,@p_fuel_start_left				= @v_error_fuel_start_left
	,@p_fuel_end_left				= @v_error_fuel_end_left
	,@p_fuel_gived					= @v_error_fuel_gived
	,@p_fuel_return					= @v_error_fuel_return	
	,@p_fuel_addtnl_exp				= @v_error_fuel_addtnl_exp	
	,@p_run							= @v_error_run	
	,@p_fuel_consumption			= @v_error_fuel_consumption
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
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
  
--пересчитаем измененного водителя
 if (@p_employee1_id <> @v_last_emp_id)
 begin
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_error_date_created	  
	,@p_employee_id			= @v_last_emp_id
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
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
			  else convert(decimal(18,2),(convert(decimal(18,2), fuel_consumption - pw_trailer_amount)*convert(decimal(18,2), 100)
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
		 ,isnull((y.speedometer_start_indctn)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((z.speedometer_end_indctn)
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
		 ,isnull((y.fuel_start_left)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((z.fuel_end_left)
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
	outer apply (select TOP(1) fuel_start_left, speedometer_start_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created >= @p_start_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												  order by date_created asc, fact_start_duty asc) as y
	outer apply (select TOP(1) fuel_end_left, speedometer_end_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created <= @p_end_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												  order by date_created desc, fact_end_duty desc) as z
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
  union all
	select state_number 
		,  speedometer_end_indctn
		,  speedometer_end_indctn
		,  0
		,  0
		,  fuel_end_left
		,  fuel_end_left
		,  0
		,  organization_id
		,  name as organization_sname
		,  null as month_created
		,  0
	from dbo.CCAR_CONDITION as a3
	 join dbo.CCAR_CAR as a4 on a3.car_id = a4.id
	 left outer join dbo.CPRT_ORGANIZATION as a5 on a4.organization_id = a5.id
	where not exists
		(select 1 FROM dbo.utfVREP_CAR_DAY() as a2
		 	where month_created 
							between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
							and a3.car_id = a2.car_id
						    and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
						    and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
						    and (car_id = @p_car_id or @p_car_id is null)
						    and (organization_id = @p_organization_id or @p_organization_id is null)
						    )) as a
	group by
		 month_created
		,organization_id
	    ,organization_sname 
		,state_number) as b
	order by month_created, organization_sname, state_number

	RETURN

go


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
	,@p_pw_trailer_amount			decimal(18,9) = 0.0
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error			   int
         , @v_TrancountOnEntry int
		 , @v_action		   char(1)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_last_car_id	   numeric(38,0)
		 , @v_last_emp_id	   numeric(38,0)
		 , @v_error_run		   decimal(18,9) 
		 , @v_condition_id     numeric(38,0)
		 , @v_error_date_created datetime
		 , @v_error_number	     numeric(38,0)
		 , @v_error_fact_start_duty datetime
		 , @v_error_fact_end_duty   datetime
		 , @v_error_fuel_exp		decimal(18,9)
		 , @v_error_fuel_type_id    numeric(38,0)
		 , @v_error_organization_id numeric(38,0)
		 , @v_error_speedometer_start_indctn decimal(18,9)
		 , @v_error_speedometer_end_indctn	 decimal(18,9)
		 , @v_error_fuel_start_left			 decimal(18,9)			 
		 , @v_error_fuel_end_left			 decimal(18,9)
		 , @v_error_fuel_gived				 decimal(18,9)
		 , @v_error_fuel_return				 decimal(18,9)	
		 , @v_error_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_error_fuel_consumption		 decimal(18,9)
		 , @v_car_type_id				     numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	-- if (@p_fuel_exp is null)
   -- set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	-- if (@p_speedometer_end_indctn is null)		
   -- set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	-- if (@p_fuel_end_left is null) 
	--set @p_fuel_end_left = 0.0

	-- if (@p_fuel_gived is null)
   -- set @p_fuel_gived = 0.0

	-- if (@p_fuel_return	is null)
	--set @p_fuel_return = 0.0

	-- if (@p_fuel_addtnl_exp is null)
   -- set @p_fuel_addtnl_exp = 0.0

	-- if (@p_run is null)
   -- set @p_run = 0.0

	-- if (@p_fuel_consumption is null)
	--set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

	 if (@p_pw_trailer_amount is null)
	set @p_pw_trailer_amount = 0.0

	set @v_trailer_id = dbo.usfConst('Энергоустановка')

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавлять
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   

			 select @v_car_type_id = car_type_id
			  from dbo.CCAR_CAR
			  where id = @p_car_id
			
			 exec @v_Error = dbo.uspVDRV_DRIVER_LIST_SEQ_Generate 
				 @p_car_type_id = @v_car_type_id
				,@p_organization_id = @p_organization_id
				,@p_number = @p_number OUTPUT
			    ,@p_sys_comment = @p_sys_comment


			if (@v_Error > 0)
			 begin 
			  if (@@tranCount > @v_TrancountOnEntry)
				 rollback
			  return @v_Error	
			 end
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
	--Запомним совершенное действие
	  set @v_action = 'I'
    end   
       
	    
 else
	begin
  -- запомним последние значения машины и водителя	
	select  @v_last_car_id = car_id
		   ,@v_last_emp_id = employee1_id
		   ,@v_error_date_created = date_created
		   ,@v_error_number = number
		   ,@v_error_fact_start_duty = fact_start_duty
		   ,@v_error_fact_end_duty = fact_end_duty
		   ,@v_error_fuel_exp = fuel_exp
		   ,@v_error_fuel_type_id = fuel_type_id
		   ,@v_error_organization_id = organization_id
		   ,@v_error_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_error_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_error_fuel_start_left = fuel_start_left
		   ,@v_error_fuel_end_left = fuel_end_left
		   ,@v_error_fuel_gived = fuel_gived
		   ,@v_error_fuel_return = fuel_return	
		   ,@v_error_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_last_run = run	
		   ,@v_error_fuel_consumption	= fuel_consumption
	  from dbo.CDRV_DRIVER_LIST
	where id = @p_id
  -- надо править существующий
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
--Запомним совершенное действие
	set @v_action = 'E'

	end

  exec  @v_Error = dbo.uspVDRV_TRAILER_SaveById 
   @p_device_id			= @v_trailer_id
  ,@p_work_hour_amount	= @p_pw_trailer_amount
  ,@p_driver_list_id	= @p_id 
  ,@p_sys_comment		= @p_sys_comment
  ,@p_sys_user			= @p_sys_user

if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end



--Построим отчет по путевому листу
  exec @v_Error = 
        dbo.uspVREP_DRIVER_LIST_Prepare
	 @p_id							=  @p_id
    ,@p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty	
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_driver_list_state_id		= @p_driver_list_state_id
	,@p_driver_list_type_id			= @p_driver_list_type_id
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn	
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp
	,@p_last_run					= @p_last_run
	,@p_run							= @p_run
	,@p_fuel_consumption			= @p_fuel_consumption
	,@p_last_date_created			= @p_last_date_created 
    ,@p_sys_comment			= @p_sys_comment  
  	,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end
-- Изменим состояние автомобиля, если известны значения по приезду
-- например, показание спидометра
if (@p_speedometer_end_indctn is not null)
begin
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)
  if (@p_car_id = @v_last_car_id)
   begin
	if (@v_action = 'E') and (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
	else
     begin
-- Убедимся, что при отсутствии изменений пробега мы не увеличим пробег
	if (@v_action = 'E') and (@p_last_run = 0) and (@p_condition_id is not null)
		set @p_run = 0
	 end
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
 -- Если поменялась машина, то мы должны вычесть у ошибочной машины прибавленный пробег
 if (@p_car_id <> @v_last_car_id)
 begin

   set @v_error_run = -@v_last_run

   select @v_condition_id = id
	 from dbo.CCAR_CONDITION
	where car_id = @v_last_car_id

   exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @v_condition_id
    		,@p_car_id		        = @v_last_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @v_error_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @v_error_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @v_error_speedometer_start_indctn
			,@p_fuel_start_left = @v_error_fuel_start_left
			,@p_fuel_end_left = @v_error_fuel_start_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

    if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
 end
--Посчитаем отчеты, если у нас закрытый п/л
if (@p_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Незачем пересчитывать на прошлый и текущий день, если не было редактирования
 if (@p_edit_state <> 'E')
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
-- пересчитаем измененный автомобиль на всякий случай
if (@p_car_id <> @v_last_car_id)
 begin
   --Отчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_error_date_created
	,@p_number						= @v_error_number
	,@p_car_id						= @v_last_car_id
	,@p_fact_start_duty				= @v_error_fact_start_duty
	,@p_fact_end_duty				= @v_error_fact_end_duty
	,@p_fuel_exp					= @v_error_fuel_exp
	,@p_fuel_type_id				= @v_error_fuel_type_id
	,@p_organization_id				= @v_error_organization_id
	,@p_employee1_id				= @v_last_emp_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @v_error_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_error_speedometer_end_indctn
	,@p_fuel_start_left				= @v_error_fuel_start_left
	,@p_fuel_end_left				= @v_error_fuel_end_left
	,@p_fuel_gived					= @v_error_fuel_gived
	,@p_fuel_return					= @v_error_fuel_return	
	,@p_fuel_addtnl_exp				= @v_error_fuel_addtnl_exp	
	,@p_run							= @v_error_run	
	,@p_fuel_consumption			= @v_error_fuel_consumption
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
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
  
--пересчитаем измененного водителя
 if (@p_employee1_id <> @v_last_emp_id)
 begin
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_error_date_created	  
	,@p_employee_id			= @v_last_emp_id
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_car_type_id      numeric(38,0)
    ,@p_organization_id	 numeric(38,0)
	,@p_number			 varchar(20)   = null out
    ,@p_sys_comment		 varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


---
   if @p_car_type_id = dbo.usfCONST('CAR') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ	

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FREIGHT') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ	


      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
   if @p_car_type_id = dbo.usfCONST('CAR') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FREIGHT') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ	
	
      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
   
    
  return  

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о cуммарном пробеге и 
** и среднем пробеге
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		 datetime
,@p_end_date		 datetime
,@p_employee_id		 numeric(38,0) = null
,@p_employee_type_id numeric(38,0) = null
,@p_organization_id  numeric(38,0) = null
,@p_report_type		 varchar(10)   = 'ALL'
)
AS
SET NOCOUNT ON

	declare
		 @v_value_id numeric(38,0)
		,@v_location_type_mobile_phone_id numeric(38,0)
		,@v_location_type_home_phone_id numeric(38,0)
		,@v_location_type_work_phone_id numeric(38,0)
		,@v_table_name int
		,@v_job_title_driver_id			numeric(38,0)	
		,@v_job_title_mto_id			numeric(38,0)
		,@v_job_title_evacuator_id		numeric(38,0)
		,@v_job_title_dutier_id			numeric(38,0)

 set @v_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @v_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @v_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')
 set @v_job_title_driver_id = dbo.usfConst('DRIVER') 
 set @v_job_title_mto_id = dbo.usfConst('MTO') 
 set @v_job_title_evacuator_id = dbo.usfConst('EVACUATOR') 
 set @v_job_title_dutier_id = dbo.usfConst('DUTIER') 

 set @v_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (((@p_report_type != 'HR') and (@p_report_type != 'ALL')) or @p_report_type is null)
  set @p_report_type = 'ALL'
--TODO: обработка неработающих водителей    
select 
	 case when month_sum = 0 then null
		  else month_created
	   end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
	,month_sum
	,first_half_month_sum
	,scnd_half_month_sum
from 	
(
select
	 case when month_created = convert(datetime, '01.01.2099') then null
		  else month_created
	  end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,case when day_1 = 0 then null else day_1 end as day_1
	,case when day_2 = 0 then null else day_2 end as day_2
	,case when day_3 = 0 then null else day_3 end as day_3
	,case when day_4 = 0 then null else day_4 end as day_4
	,case when day_5 = 0 then null else day_5 end as day_5
	,case when day_6 = 0 then null else day_6 end as day_6
	,case when day_7 = 0 then null else day_7 end as day_7
	,case when day_8 = 0 then null else day_8 end as day_8
	,case when day_9 = 0 then null else day_9 end as day_9
	,case when day_10 = 0 then null else day_10 end as day_10
	,case when day_11 = 0 then null else day_11 end as day_11
	,case when day_12 = 0 then null else day_12 end as day_12
	,case when day_13 = 0 then null else day_13 end as day_13
	,case when day_14 = 0 then null else day_14 end as day_14
	,case when day_15 = 0 then null else day_15 end as day_15
	,case when day_16 = 0 then null else day_16 end as day_16
	,case when day_17 = 0 then null else day_17 end as day_17
	,case when day_18 = 0 then null else day_18 end as day_18
	,case when day_19 = 0 then null else day_19 end as day_19
	,case when day_20 = 0 then null else day_20 end as day_20
	,case when day_21 = 0 then null else day_21 end as day_21
	,case when day_22 = 0 then null else day_22 end as day_22
	,case when day_23 = 0 then null else day_23 end as day_23
	,case when day_24 = 0 then null else day_24 end as day_24
	,case when day_25 = 0 then null else day_25 end as day_25
	,case when day_26 = 0 then null else day_26 end as day_26
	,case when day_27 = 0 then null else day_27 end as day_27
	,case when day_28 = 0 then null else day_28 end as day_28
	,case when day_29 = 0 then null else day_29 end as day_29
	,case when day_30 = 0 then null else day_30 end as day_30
	,case when day_31 = 0 then null else day_31 end as day_31
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 + day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as month_sum
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 as first_half_month_sum
	, day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as scnd_half_month_sum
from 
(SELECT dbo.usfUtils_DayTo01(month_created) as month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
			end as "value"
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else convert(decimal(18,0),day_1)
			end) as day_1 
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else convert(decimal(18,0),day_2)
			end) as day_2
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else convert(decimal(18,0),day_3)
			end) as day_3
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else convert(decimal(18,0),day_4)
			end) as day_4
, sum(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else convert(decimal(18,0),day_5)
			end) as day_5
, sum(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else convert(decimal(18,0),day_6)
			end) as day_6
, sum(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else convert(decimal(18,0),day_7)
			end) as day_7
, sum(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else convert(decimal(18,0),day_8)
			end) as day_8
, sum(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else convert(decimal(18,0),day_9)
			end) as day_9
, sum(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else convert(decimal(18,0),day_10)
			end) as day_10
, sum(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else convert(decimal(18,0),day_11)
			end) as day_11
, sum(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else convert(decimal(18,0),day_12)
			end) as day_12
, sum(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else convert(decimal(18,0),day_13)
			end) as day_13
, sum(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else convert(decimal(18,0),day_14)
			end) as day_14
, sum(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else convert(decimal(18,0),day_15)
			end) as day_15
, sum(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else convert(decimal(18,0),day_16)
			end) as day_16
, sum(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else convert(decimal(18,0),day_17)
			end) as day_17
, sum(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else convert(decimal(18,0),day_18)
			end) as day_18
, sum(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else convert(decimal(18,0),day_19)
			end) as day_19
, sum(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else convert(decimal(18,0),day_20)
			end) as day_20
, sum(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else convert(decimal(18,0),day_21)
			end) as day_21
, sum(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else convert(decimal(18,0),day_22)
			end) as day_22
, sum(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else convert(decimal(18,0),day_23)
			end) as day_23
, sum(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else convert(decimal(18,0),day_24)
			end) as day_24
, sum(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else convert(decimal(18,0),day_25)
			end) as day_25
, sum(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else convert(decimal(18,0),day_26)
			end) as day_26
, sum(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else convert(decimal(18,0),day_27)
			end) as day_27
, sum(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else convert(decimal(18,0),day_28)
			end) as day_28
, sum(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else convert(decimal(18,0),day_29)
			end) as day_29
, sum(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else convert(decimal(18,0),day_30)
			end) as day_30
, sum(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else convert(decimal(18,0),day_31)
			end) as day_31
	FROM (
select 
month_created
	,employee_id
	,person_id
	,value_id
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
from
dbo.utfVREP_EMPLOYEE_DAY()
where month_created between  @p_start_date and @p_end_date
	  and (     ((@p_report_type = 'ALL') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL')
													) or value_id is null)))
            or  ((@p_report_type = 'HR') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
													)or value_id is null)))
		  )
	  and (employee_type_id = @v_job_title_driver_id
		or employee_type_id = @v_job_title_mto_id
		or employee_type_id = @v_job_title_evacuator_id
		or employee_type_id = @v_job_title_dutier_id)
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
--TODO: считать только по отчетным таблицам
--Выберем тех сотрудников, которые не ездили
union all
select 
	 convert(datetime, '01.01.2099') as month_created
	,b.id as employee_id
	,person_id
	,null as value_id
	,lastname
	,name
	,surname
	,organization_id
	,org_name as organization_sname
	,employee_type_id
	,job_title as employee_type_sname
	,null as day_1
	,null as day_2
	,null as day_3
	,null as day_4
	,null as day_5
	,null as day_6
	,null as day_7
	,null as day_8
	,null as day_9
	,null as day_10
	,null as day_11
	,null as day_12
	,null as day_13
	,null as day_14
	,null as day_15
	,null as day_16
	,null as day_17
	,null as day_18
	,null as day_19
	,null as day_20
	,null as day_21
	,null as day_22
	,null as day_23
	,null as day_24
	,null as day_25
	,null as day_26
	,null as day_27
	,null as day_28
	,null as day_29
	,null as day_30
	,null as day_31
from dbo.utfVPRT_EMPLOYEE(@v_location_type_mobile_phone_id
				 ,@v_location_type_home_phone_id
				 ,@v_location_type_work_phone_id
				 ,@v_table_name) as b
where (employee_type_id = @v_job_title_driver_id
		or employee_type_id = @v_job_title_mto_id
		or employee_type_id = @v_job_title_evacuator_id
		or employee_type_id = @v_job_title_dutier_id)
	  and (id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and not exists
		(select 1 from dbo.utfVREP_EMPLOYEE_DAY() as c
			where c.employee_id = b.id
			 and c.month_created between  @p_start_date and @p_end_date)) as a
    group by dbo.usfUtils_DayTo01(month_created)
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then 'Общее'
			end
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname) as a
) as a
	order by month_created, organization_sname, employee_type_sname, lastname, name, surname 
			  , "value"

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_MECH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о cуммарном пробеге и 
** и среднем пробеге
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		 datetime
,@p_end_date		 datetime
,@p_employee_id		 numeric(38,0) = null
,@p_employee_type_id numeric(38,0) = null
,@p_organization_id  numeric(38,0) = null
,@p_report_type		 varchar(10)   = 'ALL'
)
AS
SET NOCOUNT ON

	declare
		 @v_value_id numeric(38,0)
		,@v_location_type_mobile_phone_id numeric(38,0)
		,@v_location_type_home_phone_id numeric(38,0)
		,@v_location_type_work_phone_id numeric(38,0)
		,@v_table_name int
		,@v_job_title_mech_id			numeric(38,0)	
		,@v_job_title_mto_id			numeric(38,0)
		,@v_job_title_evacuator_id		numeric(38,0)
		,@v_job_title_dutier_id			numeric(38,0)

 set @v_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @v_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @v_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')
 set @v_job_title_mech_id = dbo.usfConst('MECH_WORKER')  

 set @v_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (((@p_report_type != 'HR') and (@p_report_type != 'ALL')) or @p_report_type is null)
  set @p_report_type = 'ALL'
--TODO: обработка неработающих водителей    
select case when month_sum = 0 then null
		  else month_created
	   end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
	,month_sum
	,first_half_month_sum
	,scnd_half_month_sum
from 	
(
select
	 case when month_created = convert(datetime, '01.01.2099') then null
		  else month_created
	  end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,case when day_1 = 0 then null else day_1 end as day_1
	,case when day_2 = 0 then null else day_2 end as day_2
	,case when day_3 = 0 then null else day_3 end as day_3
	,case when day_4 = 0 then null else day_4 end as day_4
	,case when day_5 = 0 then null else day_5 end as day_5
	,case when day_6 = 0 then null else day_6 end as day_6
	,case when day_7 = 0 then null else day_7 end as day_7
	,case when day_8 = 0 then null else day_8 end as day_8
	,case when day_9 = 0 then null else day_9 end as day_9
	,case when day_10 = 0 then null else day_10 end as day_10
	,case when day_11 = 0 then null else day_11 end as day_11
	,case when day_12 = 0 then null else day_12 end as day_12
	,case when day_13 = 0 then null else day_13 end as day_13
	,case when day_14 = 0 then null else day_14 end as day_14
	,case when day_15 = 0 then null else day_15 end as day_15
	,case when day_16 = 0 then null else day_16 end as day_16
	,case when day_17 = 0 then null else day_17 end as day_17
	,case when day_18 = 0 then null else day_18 end as day_18
	,case when day_19 = 0 then null else day_19 end as day_19
	,case when day_20 = 0 then null else day_20 end as day_20
	,case when day_21 = 0 then null else day_21 end as day_21
	,case when day_22 = 0 then null else day_22 end as day_22
	,case when day_23 = 0 then null else day_23 end as day_23
	,case when day_24 = 0 then null else day_24 end as day_24
	,case when day_25 = 0 then null else day_25 end as day_25
	,case when day_26 = 0 then null else day_26 end as day_26
	,case when day_27 = 0 then null else day_27 end as day_27
	,case when day_28 = 0 then null else day_28 end as day_28
	,case when day_29 = 0 then null else day_29 end as day_29
	,case when day_30 = 0 then null else day_30 end as day_30
	,case when day_31 = 0 then null else day_31 end as day_31
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 + day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as month_sum
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 as first_half_month_sum
	, day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as scnd_half_month_sum
from 
(SELECT dbo.usfUtils_DayTo01(month_created) as month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
			end as "value"
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else convert(decimal(18,0),day_1)
			end) as day_1 
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else convert(decimal(18,0),day_2)
			end) as day_2
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else convert(decimal(18,0),day_3)
			end) as day_3
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else convert(decimal(18,0),day_4)
			end) as day_4
, sum(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else convert(decimal(18,0),day_5)
			end) as day_5
, sum(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else convert(decimal(18,0),day_6)
			end) as day_6
, sum(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else convert(decimal(18,0),day_7)
			end) as day_7
, sum(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else convert(decimal(18,0),day_8)
			end) as day_8
, sum(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else convert(decimal(18,0),day_9)
			end) as day_9
, sum(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else convert(decimal(18,0),day_10)
			end) as day_10
, sum(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else convert(decimal(18,0),day_11)
			end) as day_11
, sum(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else convert(decimal(18,0),day_12)
			end) as day_12
, sum(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else convert(decimal(18,0),day_13)
			end) as day_13
, sum(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else convert(decimal(18,0),day_14)
			end) as day_14
, sum(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else convert(decimal(18,0),day_15)
			end) as day_15
, sum(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else convert(decimal(18,0),day_16)
			end) as day_16
, sum(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else convert(decimal(18,0),day_17)
			end) as day_17
, sum(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else convert(decimal(18,0),day_18)
			end) as day_18
, sum(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else convert(decimal(18,0),day_19)
			end) as day_19
, sum(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else convert(decimal(18,0),day_20)
			end) as day_20
, sum(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else convert(decimal(18,0),day_21)
			end) as day_21
, sum(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else convert(decimal(18,0),day_22)
			end) as day_22
, sum(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else convert(decimal(18,0),day_23)
			end) as day_23
, sum(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else convert(decimal(18,0),day_24)
			end) as day_24
, sum(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else convert(decimal(18,0),day_25)
			end) as day_25
, sum(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else convert(decimal(18,0),day_26)
			end) as day_26
, sum(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else convert(decimal(18,0),day_27)
			end) as day_27
, sum(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else convert(decimal(18,0),day_28)
			end) as day_28
, sum(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else convert(decimal(18,0),day_29)
			end) as day_29
, sum(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else convert(decimal(18,0),day_30)
			end) as day_30
, sum(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else convert(decimal(18,0),day_31)
			end) as day_31
	FROM (
select 
month_created
	,employee_id
	,person_id
	,value_id
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
from
dbo.utfVREP_EMPLOYEE_DAY()
where month_created between  @p_start_date and @p_end_date
	  and (     ((@p_report_type = 'ALL') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL')
													) or value_id is null)))
            or  ((@p_report_type = 'HR') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
													)or value_id is null)))
		  )
	  and (employee_type_id = @v_job_title_mech_id)
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
--TODO: считать только по отчетным таблицам
--Выберем тех сотрудников, которые не ездили
union all
select 
	 convert(datetime, '01.01.2099') as month_created
	,b.id as employee_id
	,person_id
	,null as value_id
	,lastname
	,name
	,surname
	,organization_id
	,org_name as organization_sname
	,employee_type_id
	,job_title as employee_type_sname
	,null as day_1
	,null as day_2
	,null as day_3
	,null as day_4
	,null as day_5
	,null as day_6
	,null as day_7
	,null as day_8
	,null as day_9
	,null as day_10
	,null as day_11
	,null as day_12
	,null as day_13
	,null as day_14
	,null as day_15
	,null as day_16
	,null as day_17
	,null as day_18
	,null as day_19
	,null as day_20
	,null as day_21
	,null as day_22
	,null as day_23
	,null as day_24
	,null as day_25
	,null as day_26
	,null as day_27
	,null as day_28
	,null as day_29
	,null as day_30
	,null as day_31
from dbo.utfVPRT_EMPLOYEE(@v_location_type_mobile_phone_id
				 ,@v_location_type_home_phone_id
				 ,@v_location_type_work_phone_id
				 ,@v_table_name) as b
where (employee_type_id = @v_job_title_mech_id)
	  and (id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and not exists
		(select 1 from dbo.utfVREP_EMPLOYEE_DAY() as c
			where c.employee_id = b.id
			 and c.month_created between  @p_start_date and @p_end_date)) as a
    group by dbo.usfUtils_DayTo01(month_created)
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then 'Общее'
			end
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname) as a
) as a
	order by month_created, organization_sname, employee_type_sname, lastname, name, surname 
			  , "value"

	RETURN
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
			  else convert(decimal(18,2),(convert(decimal(18,2), fuel_consumption - pw_trailer_amount)*convert(decimal(18,2), 100)
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
		 ,isnull((y.speedometer_start_indctn)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((z.speedometer_end_indctn)
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
		 ,isnull((y.fuel_start_left)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((z.fuel_end_left)
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
	outer apply (select TOP(1) fuel_start_left, speedometer_start_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created >= @p_start_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												  order by date_created asc, fact_start_duty asc) as y
	outer apply (select TOP(1) fuel_end_left, speedometer_end_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created <= @p_end_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												  order by date_created desc, fact_end_duty desc) as z
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
 /* union all
	select state_number 
		,  speedometer_end_indctn
		,  speedometer_end_indctn
		,  0
		,  0
		,  fuel_end_left
		,  fuel_end_left
		,  0
		,  organization_id
		,  name as organization_sname
		,  null as month_created
		,  0
	from dbo.CCAR_CONDITION as a3
	 join dbo.CCAR_CAR as a4 on a3.car_id = a4.id
	 left outer join dbo.CPRT_ORGANIZATION as a5 on a4.organization_id = a5.id
	where not exists
		(select 1 FROM dbo.utfVREP_CAR_DAY() as a2
		 	where month_created 
							between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
							and a3.car_id = a2.car_id
						    and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
						    and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
						    and (car_id = @p_car_id or @p_car_id is null)
						    and (organization_id = @p_organization_id or @p_organization_id is null)
						    )*/) as a
	group by
		 month_created
		,organization_id
	    ,organization_sname 
		,state_number) as b
	order by month_created, organization_sname, state_number

	RETURN

go


update dbo.csys_const
set id = 1011
where name = 'ORG1'
go

update dbo.csys_const
set id = 1015
where name = 'ORG2'
go


insert into dbo.csys_const(id, name, description)
values (60,'FORM_3', 'Форма №3')
go


insert into dbo.csys_const(id, name, description)
values (61,'FORM_4P', 'Форма №4П')
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_car_type_id      numeric(38,0)
    ,@p_organization_id	 numeric(38,0)
	,@p_number			 varchar(20)   = null out
    ,@p_sys_comment		 varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ	

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ	


      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ	
	
      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
   
    
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


