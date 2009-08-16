:r ./../_define.sql
:setvar dc_number 00054
:setvar dc_description "uspVDRV_DRIVER_LIST_SelectById added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.02.2008 VLavrentiev  uspVDRV_DRIVER_LIST_SelectById added   
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

CREATE PROCEDURE [dbo].[uspVDRV_DRIVER_LIST_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о путевом листе
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_id			numeric(38,0)
,@p_start_date	datetime
,@p_end_date	datetime
,@p_car_type_id	numeric(38,0)
)
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
		  ,a.fio_driver1
		  ,a.fio_driver2
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
	FROM dbo.utfVDRV_DRIVER_LIST(@p_start_date, @p_end_date, @p_car_type_id) as a
	WHERE a.id = @p_id

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_SelectById] TO [$(db_app_user)]
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
