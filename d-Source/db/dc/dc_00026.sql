:r ./../_define.sql
:setvar dc_number 00026
:setvar dc_description "drv_driver_list procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.02.2008 VLavrentiev  drv_driver_list procs added   
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


print ' '
print 'Adding utfVDRV_DRIVER_LIST...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVDRV_DRIVER_LIST] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения путевых листов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,b.state_number
		  ,c.short_name + ' - ' + d.short_name as car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,f.lastname + ' ' + substring(f.name,1,1) + '.' + isnull(substring(f.surname,1,1) + '.','') as FIO_DRIVER1
		  ,f2.lastname + ' ' + substring(f2.name,1,1) + '.' + isnull(substring(f2.surname,1,1) + '.','') as FIO_DRIVER2
		  ,d.fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,g.short_name as driver_list_state_name
		  ,a.driver_list_type_id
		  ,h.short_name as driver_list_type_name
		  ,a.organization_id
		  ,i.name as org_name
		  ,b.fuel_type_id
		  ,a.fuel_exp
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,a.fuel_gived
		  ,a.fuel_return
		  ,a.fuel_addtnl_exp
		  ,a.run
		  ,a.fuel_consumption
      FROM dbo.CDRV_DRIVER_LIST as a
		JOIN dbo.CCAR_CAR as b on  a.car_id = b.id
		JOIN dbo.CCAR_FUEL_TYPE as j on b.fuel_type_id = j.id
		JOIN dbo.CCAR_CAR_MARK as c on b.car_mark_id = c.id
		JOIN dbo.CCAR_CAR_MODEL as d on b.car_model_id = d.id
		JOIN dbo.CPRT_EMPLOYEE as e on a.employee1_id = e.id
		JOIN dbo.CPRT_PERSON as f on e.person_id = f.id
        JOIN dbo.CDRV_DRIVER_LIST_STATE as g on a.driver_list_state_id = g.id
		JOIN dbo.CDRV_DRIVER_LIST_TYPE as h on a.driver_list_type_id = h.id
		JOIN dbo.CPRT_ORGANIZATION as i on a.organization_id = i.id
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as e2 on a.employee2_id = e2.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as f2 on e2.person_id = f2.id

)
go

GRANT VIEW DEFINITION ON [dbo].[utfVDRV_DRIVER_LIST] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_LIST_SelectAll...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVDRV_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах заметок
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS

    SET NOCOUNT ON
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,a.FIO_DRIVER1
		  ,a.FIO_DRIVER2
		  ,a.fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,a.driver_list_state_name
		  ,a.driver_list_type_id
		  ,a.driver_list_type_name
		  ,a.organization_id
		  ,a.org_name
		  ,a.fuel_type_id
		  ,a.fuel_exp
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,a.fuel_gived
		  ,a.fuel_return
		  ,a.fuel_addtnl_exp
		  ,a.run
		  ,a.fuel_consumption
	FROM dbo.utfVDRV_DRIVER_LIST() as a

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_LIST_SaveById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVDRV_DRIVER_LIST_SaveById]
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
	,@p_fuel_exp					decimal
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal = 0.0	
	,@p_speedometer_end_indctn		decimal = 0.0
	,@p_fuel_start_left				decimal = 0.0
	,@p_fuel_end_left				decimal = 0.0
	,@p_fuel_gived					decimal = 0.0
	,@p_fuel_return					decimal = 0.0
	,@p_fuel_addtnl_exp				decimal = 0.0
	,@p_run							decimal = 0.0
	,@p_fuel_consumption			decimal = 0.0
    ,@p_full_name					varchar(60)
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

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

       -- надо добавлять
  if (@p_id is null)
    begin
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
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_SaveById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_LIST_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
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
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_DeleteById] TO [$(db_app_user)]
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
