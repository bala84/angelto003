:r ./../_define.sql

:setvar dc_number 00181                  
:setvar dc_description "repair order master fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.04.2008 VLavrentiev  repair order master fixed
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

ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения заказов-нарядов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
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
		  ,d.state_number
		  ,f.short_name as car_mark_sname
		  ,g.short_name as car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + substring(c.surname, 1, 1) as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + substring(c.surname, 1, 1) as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + substring(c.surname, 1, 1) as FIO_employee_worker
		  ,a.date_created
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_desc
		  ,e.run
		  ,case order_state when 0 
							then 'Открыт'
							when 1
							then 'Закрыт'
		   end as order_state 			
      FROM dbo.CWRH_WRH_ORDER_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CCAR_CAR as d
			on a.car_id = d.id
		join dbo.CCAR_CONDITION as e
			on a.car_id = e.car_id
		join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CRPR_REPAIR_TYPE_MASTER as h
			on a.repair_type_id = h.id
	  WHERE a.date_created between @p_start_date
							   and @p_end_date
		
		
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WRH_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о заказах-нарядах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
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
		  ,state_number
		  ,car_mark_sname
		  ,car_model_sname
		  ,number
		  ,employee_recieve_id
		  ,FIO_employee_recieve
		  ,employee_head_id
		  ,FIO_employee_head 
		  ,employee_worker_id
		  ,FIO_employee_worker
		  ,date_created
		  ,order_state
		  ,repair_type_id
		  ,repair_type_sname
		  ,malfunction_desc
		  ,run
		  ,order_state 
	FROM dbo.utfVWRH_WRH_ORDER_MASTER(@p_start_date, @p_end_date)

	RETURN
GO


alter table dbo.CWRH_WRH_ORDER_MASTER
alter column repair_type_id numeric(38,0)
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

