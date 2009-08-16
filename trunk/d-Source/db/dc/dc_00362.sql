:r ./../_define.sql

:setvar dc_number 00362
:setvar dc_description "driver list select fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    17.08.2008 VLavrentiev  driver list select fixed
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

ALTER FUNCTION [dbo].[utfVDRV_DRIVER_LIST] 
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
(
  @p_start_date	datetime			
 ,@p_end_date	datetime	
 ,@p_car_type_id numeric(38,0)
)
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
		  ,k.fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,g.short_name as driver_list_state_name
		  ,a.driver_list_type_id
		  ,h.short_name as driver_list_type_name
		  ,a.organization_id
		  ,i.name as org_name
		  ,a.fuel_type_id
		  ,j.short_name as fuel_type_name
		  ,a.fuel_exp
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,a.fuel_gived
		  ,a.fuel_return
		  ,a.fuel_addtnl_exp
		  ,null as last_run
		  ,a.run
		  ,a.fuel_consumption
		  ,l.id as condition_id
		  ,null as edit_state
		  ,l.employee_id
		  ,last_date_created
      FROM dbo.CDRV_DRIVER_LIST as a
		JOIN dbo.CCAR_CAR as b on  a.car_id = b.id
		JOIN dbo.CCAR_FUEL_TYPE as j on a.fuel_type_id = j.id
		JOIN dbo.CCAR_CAR_MARK as c on b.car_mark_id = c.id
		JOIN dbo.CCAR_CAR_MODEL as d on b.car_model_id = d.id
		JOIN dbo.CPRT_EMPLOYEE as e on a.employee1_id = e.id
		JOIN dbo.CPRT_PERSON as f on e.person_id = f.id
        JOIN dbo.CDRV_DRIVER_LIST_STATE as g on a.driver_list_state_id = g.id
		JOIN dbo.CCAR_FUEL_MODEL as k on (d.id = k.car_model_id 
									 and j.id = k.fuel_type_id
									 and k.season = case when month(a.date_created) in (11,12,1,2,3)
														 then dbo.usfConst('WINTER_SEASON')
														 when month(a.date_created) in (4,5,6,7,8,9,10)
														 then dbo.usfConst('SUMMER_SEASON')
													end)
		LEFT OUTER JOIN dbo.CDRV_DRIVER_LIST_TYPE as h on a.driver_list_type_id = h.id
		LEFT OUTER JOIN dbo.CPRT_ORGANIZATION as i on a.organization_id = i.id
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as e2 on a.employee2_id = e2.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as f2 on e2.person_id = f2.id
		LEFT OUTER JOIN dbo.CCAR_CONDITION as l on b.id = l.car_id
	  WHERE b.car_type_id = @p_car_type_id
	    AND a.date_created >= @p_start_date
	    AND a.date_created <= @p_end_date	

)
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


