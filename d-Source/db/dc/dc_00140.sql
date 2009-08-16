:r ./../_define.sql

:setvar dc_number 00140                  
:setvar dc_description "last ts type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.03.2008 VLavrentiev  last ts type fixed
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

ALTER FUNCTION [dbo].[utfVCAR_LAST_TS_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности последних ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_car_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT --TOP(1)
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id
		  ,a.last_ts_type_master_id
		  ,a.run
		  ,g.short_name as ts_type_sname
      FROM dbo.CHIS_CONDITION as a
		JOIN dbo.CCAR_TS_TYPE_MASTER as g on g.id = a.last_ts_type_master_id
	 where  a.car_id = @p_car_id 
		and a.sent_to = 'Y'
		and a.run = (select max(run) from dbo.CHIS_CONDITION as a2
					 where a.last_ts_type_master_id = a2.last_ts_type_master_id
					   and a.car_id = a2.car_id
					   and a2.sent_to = 'Y')
		and a.last_ts_type_master_id in (select c.id from dbo.CCAR_TS_TYPE_MASTER as c
										 where exists
											(select 1 from dbo.CCAR_CAR as b
												where c.car_mark_id = b.car_mark_id
												  and c.car_model_id = b.car_model_id
												  and b.id = @p_car_id))											
	  
	  

)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_LAST_TS_TYPE_SelectByCar_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о последних ТО автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_car_id numeric(38,0)
)
AS
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
		  ,last_ts_type_master_id
		  ,run
		  ,ts_type_sname
	FROM dbo.utfVCAR_LAST_TS_TYPE(@p_car_id)
	order by run desc, last_ts_type_master_id asc 

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

