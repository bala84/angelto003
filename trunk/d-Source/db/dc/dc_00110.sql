:r ./../_define.sql
:setvar dc_number 00110                   
:setvar dc_description "overrun added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    16.03.2008 VLavrentiev  overrun added
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

ALTER FUNCTION [dbo].[utfVCAR_CONDITION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ����������� ������� CCAR_CONDITION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	������� ����� �������
*******************************************************************************/
( @p_start_date	datetime			
 ,@p_end_date	datetime	
 ,@p_car_type_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
SELECT	 id
		,sys_status
		,sys_comment
		,sys_date_modified
		,sys_date_created
		,sys_user_modified
		,sys_user_created
		,car_id	  
		,state_number
		,ts_type_master_id
		,ts_type_name
		,car_mark_model_name
		,employee_id
		,FIO
		,car_state_id
		,car_state_name
		,car_type_id
		,run
		,speedometer_start_indctn
		,speedometer_end_indctn
		,last_ts_type_master_id
		,edit_state
		,fuel_start_left
		,fuel_end_left
		,sent_to
		,last_run
		,case when overrun < 0  then 0
			 else overrun
		end as overrun
FROM
(SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,b.state_number
		  ,a.ts_type_master_id
		  ,f.short_name as ts_type_name
		  ,g.short_name + ' - ' + h.short_name as car_mark_model_name
		  ,a.employee_id
		  ,e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as FIO
		  ,b.car_state_id
		  ,c.short_name as car_state_name
		  ,b.car_type_id
		  ,a.run
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.last_ts_type_master_id
		  ,'E' as edit_state
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,'N'  as sent_to
		  ,a.last_run
		  ,(case when f.periodicity is not null 
				then a.run - (ceiling(case when f.periodicity is not null
											 then a.run/f.periodicity
											 else 0
											 end)*isnull(f.periodicity,0))
				else 0
		   end
				  ) as overrun 
      FROM dbo.CCAR_CONDITION as a
		JOIN dbo.CCAR_CAR as b on a.car_id = b.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on b.car_state_id = c.id
		JOIN dbo.CCAR_CAR_MARK as g on b.car_mark_id = g.id
		JOIN dbo.CCAR_CAR_MODEL as h on b.car_model_id = h.id
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as d on a.employee_id = d.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as e on d.person_id = e.id
        LEFT OUTER JOIN dbo.CCAR_TS_TYPE_MASTER as f on a.ts_type_master_id = f.id
	  WHERE b.car_type_id = @p_car_type_id
	 -- AND a.sys_date_modified >= @p_start_date
	 -- AND a.sys_date_modified <= @p_end_date	 
) as a

)
GO






SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ��������� ��������� ����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')
	
    SET NOCOUNT ON
  
       SELECT 
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,ts_type_master_id
		  ,ts_type_name
		  ,car_mark_model_name
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,run
		  ,last_ts_type_master_id
	          ,edit_state
		  ,fuel_start_left
		  ,fuel_end_left
		  ,speedometer_start_indctn
		  ,speedometer_end_indctn
		  ,sent_to
		  ,last_run
		  ,overrun
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id)
	
  RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ��������� ��������� ����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')
	
    SET NOCOUNT ON
  
       SELECT 
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,ts_type_master_id
		  ,ts_type_name
		  ,car_mark_model_name
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,run
		  ,last_ts_type_master_id
		  ,edit_state
		  ,fuel_start_left
		  ,fuel_end_left
		  ,speedometer_start_indctn
		  ,speedometer_end_indctn
		  ,sent_to
		  ,last_run
		  ,overrun	
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id)

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