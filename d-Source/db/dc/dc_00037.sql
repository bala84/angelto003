:r ./../_define.sql
:setvar dc_number 00037
:setvar dc_description "VCAR_CONDITION fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    24.02.2008 VLavrentiev  VCAR_CONDITION fixed   
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
** Функция отображения таблицы CCAR_CONDITION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
( @p_start_date	datetime			
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
		  ,a.car_id	  
		  ,b.state_number
		  ,a.ts_type_master_id
		  ,f.short_name as ts_type_name
		  ,g.short_name + ' - ' + h.short_name as car_mark_model_name
		  ,a.employee_id
		  ,e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as FIO
		  ,b.car_state_id
		  ,c.short_name as car_state_name
		  ,a.car_type_id
		  ,a.run
      FROM dbo.CCAR_CONDITION as a
		JOIN dbo.CCAR_CAR as b on a.car_id = b.id
		JOIN dbo.CCAR_CAR_STATE as c on b.car_state_id = c.id
		JOIN dbo.CCAR_CAR_MARK as g on b.car_mark_id = g.id
		JOIN dbo.CCAR_CAR_MODEL as h on b.car_model_id = h.id
		JOIN dbo.CPRT_EMPLOYEE as d on a.employee_id = d.id
		JOIN dbo.CPRT_PERSON as e on d.person_id = e.id
        LEFT OUTER JOIN dbo.CCAR_TS_TYPE_MASTER as f on a.ts_type_master_id = f.id
	  WHERE a.car_type_id = @p_car_type_id
	 -- AND a.sys_date_modified >= @p_start_date
	 -- AND a.sys_date_modified <= @p_end_date	 


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
