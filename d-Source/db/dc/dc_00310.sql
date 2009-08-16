:r ./../_define.sql

:setvar dc_number 00310
:setvar dc_description "driver list report save added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.06.2008 VLavrentiev  driver list report save added
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


alter table dbo.CREP_DRIVER_LIST
alter column car_state_id numeric(38,0)
go


alter table dbo.CREP_DRIVER_LIST
alter column car_state_sname varchar(30)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVREP_DRIVER_LIST_SaveById]
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
     @p_id					numeric(38,0)
	,@p_date_created		datetime
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
	,@p_driver_list_state_id numeric(38,0)
	,@p_driver_list_state_sname varchar(30)
	,@p_driver_list_type_id numeric(38,0)
	,@p_driver_list_type_sname varchar(30)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_exp			decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname  varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_employee1_id		numeric(38,0)
	,@p_fio_employee1		varchar(256) = 0
	,@p_fuel_gived			decimal(18,9) = 0
	,@p_fuel_return			decimal(18,9) = 0
	,@p_fuel_addtnl_exp		decimal(18,9) = 0
	,@p_run					decimal(18,9) = 0
	,@p_fuel_consumption	decimal(18,9) = 0
	,@p_number				numeric(38,0)
	,@p_last_date_created   datetime	  = null
	,@p_power_trailer_hour	decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on


    insert into dbo.CREP_DRIVER_LIST
            (date_created, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, driver_list_state_id, driver_list_state_sname
			,driver_list_type_id, driver_list_type_sname
			,speedometer_start_indctn, speedometer_end_indctn
			,fuel_exp, fuel_start_left, fuel_end_left
			,organization_id, organization_sname
		    ,fact_start_duty, fact_end_duty
			,employee1_id, fio_employee1
			,fuel_gived, fuel_return, fuel_addtnl_exp
			,run, fuel_consumption, number, last_date_created, power_trailer_hour 
			,sys_comment, sys_user_created, sys_user_modified)
	select   @p_date_created, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_driver_list_state_id, @p_driver_list_state_sname
			,@p_driver_list_type_id, @p_driver_list_type_sname
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_exp, @p_fuel_start_left, @p_fuel_end_left
			,@p_organization_id, @p_organization_sname
		    ,@p_fact_start_duty, @p_fact_end_duty
			,@p_employee1_id, @p_fio_employee1
			,@p_fuel_gived, @p_fuel_return, @p_fuel_addtnl_exp
			,@p_run, @p_fuel_consumption, @p_number, @p_last_date_created, @p_power_trailer_hour 
			,@p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_DRIVER_LIST as b
		 where b.id = @p_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_DRIVER_LIST
		 set
			date_created = @p_date_created
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
			,fuel_type_id = @p_fuel_type_id
			,fuel_type_sname = @p_fuel_type_sname
			,car_kind_id = @p_car_kind_id
			,car_kind_sname = @p_car_kind_sname
			,driver_list_state_id = @p_driver_list_state_id
			,driver_list_state_sname = @p_driver_list_state_sname
			,driver_list_type_id = @p_driver_list_type_id
			,driver_list_type_sname = @p_driver_list_type_sname
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_exp = @p_fuel_exp
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
			,organization_id = @p_organization_id
			,organization_sname = @p_organization_sname
			,fact_start_duty = @p_fact_start_duty
			,fact_end_duty = @p_fact_end_duty
			,employee1_id = @p_employee1_id
			,fuel_gived = @p_fuel_gived
			,fuel_return = @p_fuel_return
			,fuel_addtnl_exp = @p_fuel_addtnl_exp
			,run = @p_run
			,fuel_consumption = @p_fuel_consumption
			,number = @p_number
			,last_date_created = @p_last_date_created
			,power_trailer_hour = @p_power_trailer_hour
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where id	= @p_id


    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVREP_DRIVER_LIST_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_DRIVER_LIST_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_DRIVER_LIST_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по путевым листам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(    @p_id							numeric(38,0) = null out
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
	,@p_last_date_created			datetime	= null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
AS
SET NOCOUNT ON
  
  
  declare
	 @v_car_type_id			 numeric(38,0)
	,@v_car_type_sname		 varchar(30)
	,@v_car_kind_id			 numeric(38,0)
	,@v_car_kind_sname		 varchar(30)
	,@v_car_mark_id			 numeric(38,0)
	,@v_car_mark_sname		 varchar(30)
	,@v_car_model_id		 numeric(38,0)
	,@v_car_model_sname		 varchar(30)
	,@v_car_state_id		 numeric(38,0)
	,@v_car_state_sname		 varchar(30)
	,@v_state_number		 varchar(20)
	,@v_driver_list_state_sname varchar(30)
	,@v_driver_list_type_sname varchar(30)
	,@v_fuel_type_sname		 varchar(30)
	,@v_organization_sname	 varchar(30)
	,@v_fio_employee1		 varchar(256)
	,@v_power_trailer_hour	 decimal(18,9)
	,@v_Error		 int


  select 
	 @v_car_type_id		= car_type_id
	,@v_car_type_sname	= car_type_sname
	,@v_car_kind_id		= car_kind_id
	,@v_car_kind_sname	= car_kind_sname
	,@v_car_mark_id		= car_mark_id
	,@v_car_mark_sname	= car_mark_sname
	,@v_car_model_id	= car_model_id
	,@v_car_model_sname	= car_model_sname
	,@v_car_state_id	= car_state_id
	,@v_car_state_sname	= car_state_sname
	,@v_car_kind_id		= car_kind_id
	,@v_car_kind_sname	= car_kind_sname
	,@v_state_number	= state_number
	,@v_fuel_type_sname	= fuel_type_sname	
    from dbo.utfVCAR_CAR()
	where id = @p_car_id

  select @v_organization_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @p_organization_id

  select @v_driver_list_state_sname = short_name
	from dbo.CDRV_DRIVER_LIST_STATE
	where id = @p_driver_list_state_id

  select @v_driver_list_type_sname = short_name
	from dbo.CDRV_DRIVER_LIST_TYPE
	where id = @p_driver_list_type_id

  select @v_fuel_type_sname = short_name
	from dbo.CCAR_FUEL_TYPE
	where id = @p_fuel_type_id

  select @v_fio_employee1 = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
	from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b on a.person_id = b.id
	where a.id = @p_employee1_id

  select @v_power_trailer_hour = sum(work_hour_amount)
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id
	  and device_id = dbo.usfCONST('Энергоустановка')


exec @v_Error = uspVREP_DRIVER_LIST_SaveById
	 @p_id					= @p_id	
	,@p_date_created		= @p_date_created
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
	,@p_fuel_type_id		= @p_fuel_type_id
	,@p_fuel_type_sname		= @v_fuel_type_sname	
	,@p_car_kind_id			= @v_car_kind_id
	,@p_car_kind_sname		= @v_car_kind_sname
	,@p_driver_list_state_id = @p_driver_list_state_id
	,@p_driver_list_state_sname = @v_driver_list_state_sname
	,@p_driver_list_type_id = @p_driver_list_type_id
	,@p_driver_list_type_sname = @v_driver_list_type_sname
	,@p_speedometer_start_indctn = @p_speedometer_start_indctn
	,@p_speedometer_end_indctn = @p_speedometer_end_indctn
	,@p_fuel_exp			= @p_fuel_exp
	,@p_fuel_start_left		= @p_fuel_start_left	
	,@p_fuel_end_left		= @p_fuel_end_left
	,@p_organization_id		= @p_organization_id
	,@p_organization_sname  = @v_organization_sname
	,@p_fact_start_duty		= @p_fact_start_duty
	,@p_fact_end_duty		= @p_fact_end_duty
	,@p_employee1_id		= @p_employee1_id
	,@p_fio_employee1		= @v_fio_employee1
	,@p_fuel_gived			= @p_fuel_gived
	,@p_fuel_return			= @p_fuel_return
	,@p_fuel_addtnl_exp		= @p_fuel_addtnl_exp
	,@p_run					= @p_run
	,@p_fuel_consumption	= @p_fuel_consumption
	,@p_number				= @p_number
	,@p_last_date_created   = @p_last_date_created
	,@p_power_trailer_hour	= @v_power_trailer_hour
    ,@p_sys_comment			= @p_sys_comment
    ,@p_sys_user			= @p_sys_user



return
GO

GRANT EXECUTE ON [dbo].[uspVREP_DRIVER_LIST_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_DRIVER_LIST_Prepare] TO [$(db_app_user)]
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
	  , last_date_created = @p_last_date_created
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
--Незачем пересчитывать на прошлый и текущий день, если была вставка или даты равны
if ((dbo.usfUtils_TimeToZero(@p_date_created) = dbo.usfUtils_TimeToZero(@p_last_date_created))
	or (@p_edit_state <> 'E'))
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


  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return  

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_DRIVER_LIST_SaveById]
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
     @p_id					numeric(38,0)
	,@p_date_created		datetime
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
	,@p_driver_list_state_id numeric(38,0)
	,@p_driver_list_state_sname varchar(30)
	,@p_driver_list_type_id numeric(38,0)
	,@p_driver_list_type_sname varchar(30)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_exp			decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname  varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_employee1_id		numeric(38,0)
	,@p_fio_employee1		varchar(256) = 0
	,@p_fuel_gived			decimal(18,9) = 0
	,@p_fuel_return			decimal(18,9) = 0
	,@p_fuel_addtnl_exp		decimal(18,9) = 0
	,@p_run					decimal(18,9) = 0
	,@p_fuel_consumption	decimal(18,9) = 0
	,@p_number				numeric(38,0)
	,@p_last_date_created   datetime	  = null
	,@p_power_trailer_hour	decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on


    insert into dbo.CREP_DRIVER_LIST
            (id, date_created, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, driver_list_state_id, driver_list_state_sname
			,driver_list_type_id, driver_list_type_sname
			,speedometer_start_indctn, speedometer_end_indctn
			,fuel_exp, fuel_start_left, fuel_end_left
			,organization_id, organization_sname
		    ,fact_start_duty, fact_end_duty
			,employee1_id, fio_employee1
			,fuel_gived, fuel_return, fuel_addtnl_exp
			,run, fuel_consumption, number, last_date_created, power_trailer_hour 
			,sys_comment, sys_user_created, sys_user_modified)
	select   @p_id, @p_date_created, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_driver_list_state_id, @p_driver_list_state_sname
			,@p_driver_list_type_id, @p_driver_list_type_sname
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_exp, @p_fuel_start_left, @p_fuel_end_left
			,@p_organization_id, @p_organization_sname
		    ,@p_fact_start_duty, @p_fact_end_duty
			,@p_employee1_id, @p_fio_employee1
			,@p_fuel_gived, @p_fuel_return, @p_fuel_addtnl_exp
			,@p_run, @p_fuel_consumption, @p_number, @p_last_date_created, @p_power_trailer_hour 
			,@p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_DRIVER_LIST as b
		 where b.id = @p_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_DRIVER_LIST
		 set
			date_created = @p_date_created
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
			,fuel_type_id = @p_fuel_type_id
			,fuel_type_sname = @p_fuel_type_sname
			,car_kind_id = @p_car_kind_id
			,car_kind_sname = @p_car_kind_sname
			,driver_list_state_id = @p_driver_list_state_id
			,driver_list_state_sname = @p_driver_list_state_sname
			,driver_list_type_id = @p_driver_list_type_id
			,driver_list_type_sname = @p_driver_list_type_sname
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_exp = @p_fuel_exp
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
			,organization_id = @p_organization_id
			,organization_sname = @p_organization_sname
			,fact_start_duty = @p_fact_start_duty
			,fact_end_duty = @p_fact_end_duty
			,employee1_id = @p_employee1_id
			,fuel_gived = @p_fuel_gived
			,fuel_return = @p_fuel_return
			,fuel_addtnl_exp = @p_fuel_addtnl_exp
			,run = @p_run
			,fuel_consumption = @p_fuel_consumption
			,number = @p_number
			,last_date_created = @p_last_date_created
			,power_trailer_hour = @p_power_trailer_hour
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where id	= @p_id


    
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
