:r ./../_define.sql
:setvar dc_number 00038
:setvar dc_description "VCAR_CAR_MODEL fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.02.2008 VLavrentiev  VCAR_CAR_MODEL fixed   
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

ALTER FUNCTION [dbo].[utfVCAR_CAR_MODEL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения моделей автомобилей
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_car_mark_id numeric(38,0)
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
		  ,a.short_name
		  ,a.full_name
		  ,a.mark_id
		  ,b.short_name as car_mark_name
      FROM dbo.CCAR_CAR_MODEL as a
		JOIN dbo.CCAR_CAR_MARK as b on a.mark_id = b.id
	 WHERE mark_id = @p_car_mark_id	
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_CAR_MODEL_SelectByMark_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о моделях автомобиля по ид марки
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_car_mark_id numeric(38,0)
)
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
		  ,mark_id
		  ,car_mark_name
	FROM dbo.utfVCAR_CAR_MODEL(@p_car_mark_id)

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_CAR_MODEL_SelectByMark_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_CAR_MODEL_SelectByMark_id] TO [$(db_app_user)]
GO



drop procedure dbo.uspVCAR_CAR_MODEL_SelectAll
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
