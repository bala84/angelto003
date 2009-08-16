:r ./../_define.sql
:setvar dc_number 00067
:setvar dc_description "CCAR_CONDITION save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    29.02.2008 VLavrentiev  CCAR_CONDITION save fixed
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

alter table dbo.CCAR_CONDITION
drop ccar_condition_pk
go

alter table dbo.CCAR_CONDITION
drop column id
go


alter table dbo.CCAR_CONDITION
add id numeric(38,0) identity(1000,1)
go



alter table dbo.CCAR_CONDITION
   add constraint ccar_condition_pk primary key (id)
      on $(db_name)_idx
go




declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'id'
go

alter table dbo.CCAR_CONDITION
add last_run decimal not null default 0.0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Прошлый пробег',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'last_run'
go


alter table dbo.CCAR_CONDITION
alter column employee_id numeric(38,0) null
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
     @p_id				numeric(38,0) = null out
    ,@p_car_id		        	numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id			numeric(38,0) = null
    ,@p_run 			    	decimal
    ,@p_last_run			decimal	      = 0.0
    ,@p_speedometer_start_indctn	decimal	      = 0.0
    ,@p_speedometer_end_indctn		decimal	      = 0.0    
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30)   = null
)
as
begin
  set nocount on

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

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, speedometer_start_indctn, speedometer_end_indctn, sys_comment, sys_user_created, sys_user_modified)
	   values
	(@p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_speedometer_start_indctn, @p_speedometer_end_indctn, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = @p_ts_type_master_id
		,employee_id = @p_employee_id
		,run = run + @p_run
		,last_run = @p_last_run
		,speedometer_start_indctn = @p_speedometer_start_indctn
		,speedometer_end_indctn = @p_speedometer_end_indctn
		,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
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
     	 @p_id						numeric(38,0) = null out
    	,@p_date_created				datetime
	,@p_number					bigint
	,@p_car_id					numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id			numeric(38,0)
	,@p_driver_list_type_id				numeric(38,0)
	,@p_fuel_exp					decimal
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn			decimal = 0.0	
	,@p_speedometer_end_indctn			decimal = 0.0
	,@p_fuel_start_left				decimal = 0.0
	,@p_fuel_end_left				decimal = 0.0
	,@p_fuel_gived					decimal = 0.0
	,@p_fuel_return					decimal = 0.0
	,@p_fuel_addtnl_exp				decimal = 0.0
	,@p_run						decimal = 0.0
	,@p_fuel_consumption				decimal = 0.0
	,@p_condition_id				numeric (38,0) = null out
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

  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= null
    		,@p_run				= @p_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

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
