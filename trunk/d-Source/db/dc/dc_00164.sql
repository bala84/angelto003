:r ./../_define.sql

:setvar dc_number 00164                  
:setvar dc_description "new report wrapper added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.04.2008 VLavrentiev  new report wrapper added
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_Calculate]
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

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVREP_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_Calculate] TO [$(db_app_user)]
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER trigger [TRIUD_CDRV_DRIVER_LIST_REPORT]
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
	from deleted as a
	 join dbo.utfVCAR_CAR() as b
		on a.car_id = b.id

exec @v_Error = 
		dbo.uspVREP_Calculate
				 @p_day_created			= @v_date_created
				,@p_state_number		= @v_state_number
				,@p_car_id				= @v_car_id
				,@p_car_type_id			= @v_car_type_id
				,@p_car_type_sname		= @v_car_type_sname
				,@p_car_state_id		= @v_car_state_id
				,@p_car_state_sname		= @v_car_state_sname
				,@p_car_mark_id			= @v_car_mark_id
				,@p_car_mark_sname		= @v_car_mark_sname
				,@p_car_model_id		= @v_car_model_id
				,@p_car_model_sname		= @v_car_model_sname
				,@p_begin_mntnc_date	= @v_begin_mntnc_date
				,@p_fuel_type_id		= @v_fuel_type_id
				,@p_fuel_type_sname		= @v_fuel_type_sname
				,@p_car_kind_id			= @v_car_kind_id
				,@p_car_kind_sname		= @v_car_kind_sname
				,@p_fact_start_duty 	= @v_fact_start_duty
		  		,@p_fact_end_duty 		= @v_fact_end_duty
				,@p_run					= @v_run
				,@p_sys_comment			= @v_sys_comment 
				,@p_sys_user			= @v_sys_user
--end			

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

