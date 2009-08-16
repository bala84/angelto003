:r ./../_define.sql

:setvar dc_number 00357
:setvar dc_description "condition fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.08.2008 VLavrentiev  condition fix
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


