:r ./../_define.sql

:setvar dc_number 00358
:setvar dc_description "driver list save fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    11.08.2008 VLavrentiev  driver list save fix
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
	if (@v_action = 'E') and (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
	else
     begin
-- Убедимся, что при отсутствии изменений пробега мы не увеличим пробег
	if (@v_action = 'E') and (@p_last_run = 0) and (@p_condition_id is not null)
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
  end





  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return  

end
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

ALTER procedure [dbo].[uspVCAR_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные о состоянии автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
    ,@p_car_id		        		numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id					numeric(38,0) = null
    ,@p_run 			    		decimal(18,9)
    ,@p_last_run					decimal(18,9)	      = 0.0
    ,@p_speedometer_start_indctn	decimal(18,9)	      = 0.0
    ,@p_speedometer_end_indctn		decimal(18,9)	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal(18,9)	      = 0.0
	,@p_fuel_end_left               decimal(18,9)	      = 0.0
	,@p_sent_to						char		  = 'N'
	,@p_ts_type_route_detail_id		numeric(38,0) = null
	,@p_last_ts_type_route_detail_id numeric(38,0) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
   set nocount on
   set xact_abort on
  

   declare @v_Error					  int
         , @v_TrancountOnEntry		  int
	     , @v_action				  smallint
		 , @v_ts_type_master_id		  numeric(38,0)
		 , @v_overrun				  decimal(18,9)
		 , @v_run					  decimal(18,9)
		 , @v_in_tolerance			  bit
		 , @v_ts_type_route_detail_id numeric(38,0)
		 , @v_fuel_start_left		  decimal(18,9)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_fuel_end_left			   decimal(18,9)
		 , @v_speedometer_end_indctn   decimal(18,9)
	 
   declare @t_run table (run decimal(18,9), ts_type_master_id numeric(38,0))

      if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_run is null)
	set @p_run = 0.0
	    
     if (@p_last_run is null)
	set @p_last_run = @p_run

     if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0

     if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

     if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

     if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0	

	 if (@p_sent_to is null)
	set @p_sent_to = 'N'

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount

--На всякий случай записывааем только последние показания по машине
	select TOP(1) @v_fuel_start_left = fuel_start_left, @v_speedometer_start_indctn = speedometer_start_indctn
				, @v_fuel_end_left = fuel_end_left, @v_speedometer_end_indctn = speedometer_end_indctn
	from dbo.CDRV_DRIVER_LIST
	where car_id = @p_car_id
	order by date_created desc, fact_end_duty desc

	if (@v_fuel_start_left is null)
	  set @v_fuel_start_left = @p_fuel_start_left

	if (@v_fuel_end_left is null)
	  set @v_fuel_end_left = @p_fuel_end_left

	if (@v_speedometer_start_indctn is null)
	  set @v_speedometer_start_indctn = @p_speedometer_start_indctn


	if (@v_speedometer_end_indctn is null)
	  set @v_speedometer_end_indctn = @p_speedometer_end_indctn





	 if (@@tranCount = 0)
	  begin transaction 

  
    

       -- надо добавлять
  if (@p_id is null)
    begin


	  exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @p_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_ts_type_route_detail_id = @v_ts_type_route_detail_id out
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, overrun, in_tolerance
	  , ts_type_route_detail_id, last_ts_type_route_detail_id, sys_comment, sys_user_created, sys_user_modified)
	    values
	(@p_car_id, @v_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @v_speedometer_start_indctn, @v_speedometer_end_indctn
	,@v_fuel_start_left, @v_fuel_end_left, @v_overrun, @v_in_tolerance
	, @v_ts_type_route_detail_id, @p_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

	  set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
  -- надо править существующий

	begin
	
    select @v_run = case when @p_edit_state = 'E'
						 then @p_run
						 else run + @p_run 
					end from dbo.CCAR_CONDITION
	where id = @p_id

    exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @v_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_ts_type_route_detail_id = @v_ts_type_route_detail_id out
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = @v_ts_type_master_id
							/*case when @p_sent_to = 'N'
								 then @v_ts_type_master_id
								 when @p_sent_to = 'Y'
								 then @p_ts_type_master_id
							end*/
		,employee_id = @p_employee_id
		-- Добавляем именно нарастающим итогом
		-- Но если укажем @p_edit_state, то можем переписать
		,run = @v_run
		,last_run = @p_last_run
		,last_ts_type_master_id = @p_last_ts_type_master_id
		,speedometer_start_indctn = @v_speedometer_start_indctn
		,speedometer_end_indctn = @v_speedometer_end_indctn
		,fuel_start_left = @v_fuel_start_left
		,fuel_end_left = @v_fuel_end_left
		,overrun = @v_overrun
		,in_tolerance = @v_in_tolerance
		,ts_type_route_detail_id = @v_ts_type_route_detail_id	
		,last_ts_type_route_detail_id = @p_ts_type_route_detail_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		output inserted.run, inserted.ts_type_master_id into @t_run 		
		where ID = @p_id
		

		set @v_action = dbo.usfConst('ACTION_UPDATE')

		select @p_run = run, @v_ts_type_master_id = ts_type_master_id from @t_run

	end


	  exec @v_Error = 
        dbo.uspVHIS_CONDITION_SaveById
        	 @p_action						= @v_action
			,@p_car_id						= @p_car_id
    		,@p_ts_type_master_id			= @v_ts_type_master_id
			,@p_last_ts_type_master_id		= @p_last_ts_type_master_id
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= @p_last_run
    		,@p_speedometer_start_indctn 	= @v_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @v_speedometer_end_indctn
			,@p_edit_state					= @p_edit_state 
			,@p_fuel_start_left				= @v_fuel_start_left
			,@p_fuel_end_left				= @v_fuel_end_left
			,@p_sent_to						= @p_sent_to
			,@p_overrun						= @v_overrun
			,@p_in_tolerance				= @v_in_tolerance
			,@p_ts_type_route_detail_id		= @v_ts_type_route_detail_id	
			,@p_last_ts_type_route_detail_id= @p_ts_type_route_detail_id
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


