:r ./../_define.sql

:setvar dc_number 00136                  
:setvar dc_description "fio added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.03.2008 VLavrentiev  fio added
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

ALTER FUNCTION [dbo].[utfVPRT_EMPLOYEE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности EMPLOYEE
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      19.02.2008 VLavrentiev	Добавил обработку sex
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_location_type_mobile_phone_id  numeric(38,0)
 ,@p_location_type_home_phone_id    numeric(38,0)
 ,@p_location_type_work_phone_id    numeric(38,0)
 ,@p_table_name 		    int
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
		  ,a.organization_id
		  ,a.person_id
		  ,a.employee_type_id
		  ,case when b.sex = 1 then 'М' 
			    when b.sex = 0 then 'Ж'
           else ''
		   end as sex
          	  ,b.lastname+' '+b.name+' '+isnull(b.surname,'') as FIO
		  ,b.lastname 
		  ,b.name
		  ,b.surname
		  ,b.birthdate
		  ,e1.location_string as mobile_phone
		  ,e2.location_string as home_phone
		  ,e3.location_string as work_phone
	      	  ,c.name as org_name
		  ,d.short_name as job_title
      FROM dbo.CPRT_EMPLOYEE as a
      JOIN dbo.CPRT_PERSON as b on a.person_id = b.id
	  JOIN dbo.CPRT_ORGANIZATION as c on a.organization_id = c.id
      JOIN dbo.CPRT_EMPLOYEE_TYPE as d on a.employee_type_id = d.id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_Check_last_ts] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура проверяет прошлое ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id					numeric (38,0)		
,@p_last_ts_verified		tinyint out
)
AS
BEGIN

SET NOCOUNT ON

if exists(
select	TOP(1)   1
from dbo.utfVCAR_TS_TYPE_MASTER() as a
where exists
(select 1 from dbo.CCAR_CAR as b
	where b.car_mark_id = a.car_mark_id
	  and b.car_model_id = a.car_model_id
	  and b.id = @p_car_id)
  and not exists
(select 1 from dbo.CHIS_CONDITION as c
  where c.last_ts_type_master_id = a.id
	and c.sent_to = 'Y')) 

	set @p_last_ts_verified = 0

else

	set @p_last_ts_verified = 1

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные об автомобиле
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      06.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_id numeric(38,0)
)
AS
SET NOCOUNT ON
  

       SELECT 
			a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.state_number
		  ,null as last_speedometer_idctn
		  ,convert(decimal(18,0), a.speedometer_idctn, 128) as speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,a.car_type_sname
		  ,a.car_state_id
		  ,a.car_state_sname
		  ,a.car_mark_id 
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
		  ,a.fuel_type_id	
		  ,a.fuel_type_sname
		  ,a.car_kind_id
		  ,a.car_kind_sname
		  ,convert(decimal(18,3), b.fuel_norm , 128) as fuel_norm
		  ,null as last_begin_run
		  ,convert(decimal(18,0), a.begin_run, 128) as begin_run
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.condition_id
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,a.employee_id
	FROM dbo.utfVCAR_CAR() as a
	LEFT OUTER JOIN dbo.utfVCAR_FUEL_TYPE() as b on 
										   a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (11,12,1,2,3)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (4,5,6,7,8,9,10)
														   then dbo.usfConst('SUMMER_SEASON')
													  end
   WHERE a.id = @p_id

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

