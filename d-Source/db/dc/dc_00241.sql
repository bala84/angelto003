:r ./../_define.sql

:setvar dc_number 00241
:setvar dc_description "demand month select fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.05.2008 VLavrentiev  demand month select fixed
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

ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 
			max(a.wrh_demand_master_id) as wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and a.car_id is not null
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	group by a.good_category_id, a.good_category_sname
			,a.car_id,a.state_number, a.warehouse_type_id, a.warehouse_type_sname
	order by a.state_number

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_BY_RECIEVER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_employee_recieve_id numeric(38,0) = null

)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 
			 max(a.wrh_demand_master_id) as wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.employee_recieve_id
			,a.employee_recieve_fio
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and a.car_id is null
	group by  a.good_category_id, a.good_category_sname
			,a.employee_recieve_id, a.employee_recieve_fio, a.warehouse_type_id, a.warehouse_type_sname
	order by a.employee_recieve_fio

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




