:r ./../_define.sql

:setvar dc_number 00312
:setvar dc_description "driver list report select added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    21.06.2008 VLavrentiev  driver list report select added
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

ALTER PROCEDURE [dbo].[uspVREP_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным путевым листам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_car_mark_id			numeric(38,0) = null
,@p_car_kind_id			numeric(38,0) = null
,@p_car_id		        numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_employee1_id		numeric(38,0) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,date_created
		,state_number
		,car_id
		,car_type_id
		,car_type_sname
		,car_mark_id
		,car_mark_sname
		,car_model_id
		,car_model_sname
		,fuel_type_id
		,fuel_type_sname
		,car_kind_id
		,car_kind_sname
		,driver_list_state_id
		,driver_list_state_sname
		,driver_list_type_id
		,driver_list_type_sname
		,speedometer_start_indctn
		,speedometer_end_indctn
		,fuel_exp
		,fuel_start_left
		,fuel_end_left
		,organization_id
		,organization_sname
		,fact_start_duty
		,fact_end_duty
		,employee1_id
		,fio_employee1
		,fuel_gived
		,fuel_return
		,fuel_addtnl_exp
		,run
		,fuel_consumption
		,number
		,last_date_created
		,power_trailer_hour 
	FROM dbo.utfVREP_DRIVER_LIST() as a
	where date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and (employee1_id = @p_employee1_id or @p_employee1_id is null)
	order by date_created, organization_sname, car_type_sname, state_number

	RETURN
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


