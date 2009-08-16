:r ./../_define.sql

:setvar dc_number 00249
:setvar dc_description "report employee sync"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    16.05.2008 VLavrentiev  report employee sync
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

create trigger [TRIUD_CDRV_DRIVER_LIST_REPORT]
on  [dbo].[CDRV_DRIVER_LIST]
AFTER INSERT, UPDATE, DELETE
as
begin
  declare    
	 @v_id							numeric(38,0)
    ,@v_date_created				datetime
	,@v_number						bigint
	,@v_car_id						numeric(38,0)
	,@v_car_type_id					numeric(38,0)
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
	,@v_fact_start_duty				datetime
	,@v_fact_end_duty				datetime
	,@v_fuel_exp					decimal(18,9)
	,@v_fuel_type_id				numeric(38,0)
	,@v_organization_id				numeric(38,0)
	,@v_employee1_id				numeric(38,0)
	,@v_employee2_id				numeric(38,0)
	,@v_speedometer_start_indctn	decimal(18,9)
	,@v_speedometer_end_indctn		decimal(18,9)
	,@v_fuel_start_left				decimal(18,9)
	,@v_fuel_end_left				decimal(18,9)
	,@v_fuel_gived					decimal(18,9)
	,@v_fuel_return					decimal(18,9)
	,@v_fuel_addtnl_exp				decimal(18,9)
	,@v_run							decimal(18,9)
	,@v_fuel_consumption			decimal(18,9)
	,@v_condition_id				numeric(38,0)
	,@v_state_number				varchar(20)
	,@v_last_date_created			datetime
		  ,@v_driver_list_state_id 	decimal(18,9)
		  ,@v_driver_list_type_id 	decimal(18,9)
    ,@v_sys_comment					varchar(2000)
    ,@v_sys_user					varchar(30)	
	,@v_Error						int				

--if (@@rowcount = 1)
--begin
select 
		   @v_id = a.id
		  ,@v_sys_comment = a.sys_comment
		  ,@v_sys_user = a.sys_user_modified
		  ,@v_date_created = a.date_created
		  ,@v_number = a.number
		  ,@v_car_id = a.car_id
		  ,@v_state_number = b.state_number
		  ,@v_employee1_id = a.employee1_id
		  ,@v_employee2_id = a.employee2_id
		  ,@v_fuel_type_id = a.fuel_type_id
		  ,@v_fact_start_duty = a.fact_start_duty
		  ,@v_fact_end_duty = a.fact_end_duty
		  ,@v_organization_id = a.organization_id
		  ,@v_fuel_exp = a.fuel_exp 
		  ,@v_speedometer_start_indctn = a.speedometer_start_indctn
		  ,@v_speedometer_end_indctn = a.speedometer_end_indctn
		  ,@v_fuel_start_left = a.fuel_start_left
		  ,@v_fuel_end_left = a.fuel_end_left 
		  ,@v_fuel_gived = a.fuel_gived
		  ,@v_fuel_return = a.fuel_return
		  ,@v_fuel_addtnl_exp = a.fuel_addtnl_exp 
		  ,@v_run = a.run
		  ,@v_fuel_consumption = a.fuel_consumption 
		  ,@v_driver_list_state_id =  a.driver_list_state_id
		  ,@v_driver_list_type_id =  a.driver_list_type_id
		  ,@v_condition_id = b.condition_id
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
		  ,@v_last_date_created = a.last_date_created
	from inserted as a
	 join dbo.utfVCAR_CAR() as b
		on a.car_id = b.id
if (@@rowcount = 0)
  select 
		   @v_id = a.id
		  ,@v_sys_comment = a.sys_comment
		  ,@v_sys_user = a.sys_user_modified
		  ,@v_date_created = a.date_created
		  ,@v_number = a.number
		  ,@v_car_id = a.car_id
		  ,@v_state_number = b.state_number
		  ,@v_employee1_id = a.employee1_id
		  ,@v_employee2_id = a.employee2_id
		  ,@v_fuel_type_id = a.fuel_type_id
		  ,@v_fact_start_duty = a.fact_start_duty
		  ,@v_fact_end_duty = a.fact_end_duty
		  ,@v_organization_id = a.organization_id
		  ,@v_fuel_exp = a.fuel_exp 
		  ,@v_speedometer_start_indctn = a.speedometer_start_indctn
		  ,@v_speedometer_end_indctn = a.speedometer_end_indctn
		  ,@v_fuel_start_left = a.fuel_start_left
		  ,@v_fuel_end_left = a.fuel_end_left 
		  ,@v_fuel_gived = a.fuel_gived
		  ,@v_fuel_return = a.fuel_return
		  ,@v_fuel_addtnl_exp = a.fuel_addtnl_exp 
		  ,@v_run = a.run
		  ,@v_fuel_consumption = a.fuel_consumption
		  ,@v_driver_list_state_id =  a.driver_list_state_id
		  ,@v_driver_list_type_id =  a.driver_list_type_id 
		  ,@v_condition_id = b.condition_id
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
		  ,@v_last_date_created = a.last_date_created
	from deleted as a
	 join dbo.utfVCAR_CAR() as b
		on a.car_id = b.id


exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_date_created
	,@p_number						= @v_number
	,@p_car_id						= @v_car_id
	,@p_fact_start_duty				= @v_fact_start_duty
	,@p_fact_end_duty				= @v_fact_end_duty
	,@p_fuel_exp					= @v_fuel_exp
	,@p_fuel_type_id				= @v_fuel_type_id
	,@p_organization_id				= @v_organization_id
	,@p_employee1_id				= @v_employee1_id
	,@p_employee2_id				= @v_employee2_id
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
    ,@p_sys_comment					= 'rep_sync'
    ,@p_sys_user					= @v_sys_user


--Построим отчет по путевому листу
  exec @v_Error = 
        dbo.uspVREP_DRIVER_LIST_Prepare
	 @p_id							=  @v_id
    ,@p_date_created				= @v_date_created
	,@p_number						= @v_number
	,@p_car_id						= @v_car_id
	,@p_fact_start_duty				= @v_fact_start_duty	
	,@p_fact_end_duty				= @v_fact_end_duty
	,@p_driver_list_state_id		= @v_driver_list_state_id
	,@p_driver_list_type_id			= @v_driver_list_type_id
	,@p_fuel_exp					= @v_fuel_exp
	,@p_fuel_type_id				= @v_fuel_type_id
	,@p_organization_id				= @v_organization_id
	,@p_employee1_id				= @v_employee1_id
	,@p_speedometer_start_indctn	= @v_speedometer_start_indctn	
	,@p_speedometer_end_indctn		= @v_speedometer_end_indctn
	,@p_fuel_start_left				= @v_fuel_start_left
	,@p_fuel_end_left				= @v_fuel_end_left
	,@p_fuel_gived					= @v_fuel_gived
	,@p_fuel_return					= @v_fuel_return	
	,@p_fuel_addtnl_exp				= @v_fuel_addtnl_exp
	,@p_last_run					= null
	,@p_run							= @v_run
	,@p_fuel_consumption			= @v_fuel_consumption
	,@p_last_date_created			= @v_last_date_created 
    ,@p_sys_comment			= 'rep_sync'  
  	,@p_sys_user 			= @v_sys_user

exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @v_employee1_id
    ,@p_sys_comment					= 'rep_sync'
    ,@p_sys_user					= @v_sys_user

--end			

end
GO


print 'количество путевых листов:' 
select count(*)
	from cdrv_driver_list
	where date_created >= convert(datetime, '05.01.2008')
go


print ' '
go
 
print 'Запуск синхронизации:'
go
 


declare
	 @p_id numeric(38,0)
	,@i	int

declare
drv_cur cursor for
select id
	from cdrv_driver_list
	where date_created >= convert(datetime, '05.01.2008')

begin
open drv_cur

fetch next from drv_cur
into @p_id

set @i = 1

while @@fetch_status = 0
begin

  update dbo.CDRV_DRIVER_LIST
		set sys_comment = 'report_sync'
			,sys_date_modified = getdate()
  where id = @p_id

fetch next from drv_cur
into @p_id
set @i = @i + 1
select @i - 1
end

CLOSE drv_cur
DEALLOCATE drv_cur
end
go

drop trigger [TRIUD_CDRV_DRIVER_LIST_REPORT]
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




