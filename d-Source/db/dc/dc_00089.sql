:r ./../_define.sql
:setvar dc_number 00089
:setvar dc_description "fuel_type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    06.03.2008 VLavrentiev  fuel_type fixed
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

ALTER FUNCTION [dbo].[utfVCAR_FUEL_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения типов топлива
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
		  ,a.short_name
		  ,a.full_name
		  ,b.fuel_norm
		  ,b.car_model_id
		  ,c.mark_id
		  ,d.short_name + ' - ' + c.short_name as car_mark_model_sname
		  ,a.season
		  ,b.id as fuel_model_id
		  ,d.short_name as car_mark_sname
		  ,c.short_name as car_model_sname
      FROM dbo.CCAR_FUEL_MODEL as b
		JOIN dbo.CCAR_FUEL_TYPE as a on a.id = b.fuel_type_id
		JOIN dbo.CCAR_CAR_MODEL as c on  c.id = b.car_model_id
		JOIN dbo.CCAR_CAR_MARK as d on c.mark_id = d.id
	
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_FUEL_TYPE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах топлива
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,fuel_norm
		  ,car_model_id
		  ,mark_id
		  ,car_mark_model_sname
		  ,case season when dbo.usfConst('WINTER_SEASON')
					   then 'Зима'
					   when dbo.usfConst('SUMMER_SEASON')
					   then 'Лето'
		  end as season
		 ,fuel_model_id
		 ,car_mark_sname
		 ,car_model_sname
	FROM dbo.utfVCAR_FUEL_TYPE()

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
