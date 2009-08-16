:r ./../_define.sql

:setvar dc_number 00377
:setvar dc_description "driver list delete fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   16.09.2008 VLavrentiev  driver list delete fixed
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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)
		 , @v_run	 decimal(18,9)

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount


  

   if (@@tranCount = 0)
	  begin transaction 

	select @v_car_id = car_id
		  ,@v_run = run
		from dbo.CDRV_DRIVER_LIST
	 where id = @p_id

	delete 
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id


	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id 

if (not exists (select TOP(1) 1 from dbo.CDRV_DRIVER_LIST
				where driver_list_state_id = dbo.usfConst('LIST_OPEN')
				  and speedometer_end_indctn is null
				  and car_id = @v_car_id))
 update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

 
   if (@v_run > 0)
    update dbo.CCAR_CONDITION
	    set run = run - @v_run
	where car_id = @v_car_id

  if (@@tranCount > @v_TrancountOnEntry)
    commit
  
    
  return 

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)
		 , @v_run	 decimal(18,9)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_emp_id	   numeric(38,0) 
		 , @v_condition_id     numeric(38,0)
		 , @v_date_created datetime
		 , @v_last_date_created datetime
		 , @v_number	     numeric(38,0)
		 , @v_fact_start_duty datetime
		 , @v_fact_end_duty   datetime
		 , @v_fuel_exp		decimal(18,9)
		 , @v_fuel_type_id    numeric(38,0)
		 , @v_organization_id numeric(38,0)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_speedometer_end_indctn	 decimal(18,9)
		 , @v_fuel_start_left			 decimal(18,9)			 
		 , @v_fuel_end_left			 decimal(18,9)
		 , @v_fuel_gived				 decimal(18,9)
		 , @v_fuel_return				 decimal(18,9)	
		 , @v_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_fuel_consumption		 decimal(18,9)
		 , @v_driver_list_state_id	 numeric(38,0)

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount


  

   if (@@tranCount = 0)
	  begin transaction 

	select  @v_car_id = car_id
		   ,@v_emp_id = employee1_id
		   ,@v_date_created = date_created
		   ,@v_last_date_created = last_date_created
		   ,@v_number = number
		   ,@v_fact_start_duty = fact_start_duty
		   ,@v_fact_end_duty = fact_end_duty
		   ,@v_fuel_exp = fuel_exp
		   ,@v_fuel_type_id = fuel_type_id
		   ,@v_organization_id = organization_id
		   ,@v_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_fuel_start_left = fuel_start_left
		   ,@v_fuel_end_left = fuel_end_left
		   ,@v_fuel_gived = fuel_gived
		   ,@v_fuel_return = fuel_return	
		   ,@v_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_last_run = run	
		   ,@v_fuel_consumption	= fuel_consumption
		   ,@v_driver_list_state_id = driver_list_state_id
		from dbo.CDRV_DRIVER_LIST
	 where id = @p_id

	delete 
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id


	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id 

if (not exists (select TOP(1) 1 from dbo.CDRV_DRIVER_LIST
				where driver_list_state_id = dbo.usfConst('LIST_OPEN')
				  and speedometer_end_indctn is null
				  and car_id = @v_car_id))
 update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

 
   if (@v_run > 0)
    update dbo.CCAR_CONDITION
	    set run = run - @v_run
	where car_id = @v_car_id

--Посчитаем отчеты, если у нас закрытый п/л
if (@v_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Отчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_date_created
	,@p_number						= @v_number
	,@p_car_id						= @v_car_id
	,@p_fact_start_duty				= @v_fact_start_duty
	,@p_fact_end_duty				= @v_fact_end_duty
	,@p_fuel_exp					= @v_fuel_exp
	,@p_fuel_type_id				= @v_fuel_type_id
	,@p_organization_id				= @v_organization_id
	,@p_employee1_id				= @v_emp_id
	,@p_employee2_id				= @v_emp_id
	,@p_speedometer_start_indctn	= @v_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_speedometer_end_indctn
	,@p_fuel_start_left				= @v_fuel_start_left
	,@p_fuel_end_left				= @v_fuel_end_left
	,@p_fuel_gived					= @v_fuel_gived
	,@p_fuel_return					= @v_fuel_return	
	,@p_fuel_addtnl_exp				= @v_fuel_addtnl_exp	
	,@p_run							= @v_run	
	,@p_fuel_consumption			= @v_fuel_consumption
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 


 
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @v_emp_id
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)
		 , @v_run	 decimal(18,9)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_emp_id	   numeric(38,0) 
		 , @v_condition_id     numeric(38,0)
		 , @v_date_created datetime
		 , @v_last_date_created datetime
		 , @v_number	     numeric(38,0)
		 , @v_fact_start_duty datetime
		 , @v_fact_end_duty   datetime
		 , @v_fuel_exp		decimal(18,9)
		 , @v_fuel_type_id    numeric(38,0)
		 , @v_organization_id numeric(38,0)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_speedometer_end_indctn	 decimal(18,9)
		 , @v_fuel_start_left			 decimal(18,9)			 
		 , @v_fuel_end_left			 decimal(18,9)
		 , @v_fuel_gived				 decimal(18,9)
		 , @v_fuel_return				 decimal(18,9)	
		 , @v_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_fuel_consumption		 decimal(18,9)
		 , @v_driver_list_state_id	 numeric(38,0)

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount


  

   if (@@tranCount = 0)
	  begin transaction 

	select  @v_car_id = car_id
		   ,@v_emp_id = employee1_id
		   ,@v_date_created = date_created
		   ,@v_last_date_created = last_date_created
		   ,@v_number = number
		   ,@v_fact_start_duty = fact_start_duty
		   ,@v_fact_end_duty = fact_end_duty
		   ,@v_fuel_exp = fuel_exp
		   ,@v_fuel_type_id = fuel_type_id
		   ,@v_organization_id = organization_id
		   ,@v_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_fuel_start_left = fuel_start_left
		   ,@v_fuel_end_left = fuel_end_left
		   ,@v_fuel_gived = fuel_gived
		   ,@v_fuel_return = fuel_return	
		   ,@v_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_run = run	
		   ,@v_fuel_consumption	= fuel_consumption
		   ,@v_driver_list_state_id = driver_list_state_id
		from dbo.CDRV_DRIVER_LIST
	 where id = @p_id

	delete 
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id


	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id 

if (not exists (select TOP(1) 1 from dbo.CDRV_DRIVER_LIST
				where driver_list_state_id = dbo.usfConst('LIST_OPEN')
				  and speedometer_end_indctn is null
				  and car_id = @v_car_id))
 update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

 
   if (@v_run > 0)
    update dbo.CCAR_CONDITION
	    set run = run - @v_run
	where car_id = @v_car_id

--Посчитаем отчеты, если у нас закрытый п/л
if (@v_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Отчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_date_created
	,@p_number						= @v_number
	,@p_car_id						= @v_car_id
	,@p_fact_start_duty				= @v_fact_start_duty
	,@p_fact_end_duty				= @v_fact_end_duty
	,@p_fuel_exp					= @v_fuel_exp
	,@p_fuel_type_id				= @v_fuel_type_id
	,@p_organization_id				= @v_organization_id
	,@p_employee1_id				= @v_emp_id
	,@p_employee2_id				= @v_emp_id
	,@p_speedometer_start_indctn	= @v_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_speedometer_end_indctn
	,@p_fuel_start_left				= @v_fuel_start_left
	,@p_fuel_end_left				= @v_fuel_end_left
	,@p_fuel_gived					= @v_fuel_gived
	,@p_fuel_return					= @v_fuel_return	
	,@p_fuel_addtnl_exp				= @v_fuel_addtnl_exp	
	,@p_run							= @v_run	
	,@p_fuel_consumption			= @v_fuel_consumption
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 


 
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @v_emp_id
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

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
