:r ./../_define.sql

:setvar dc_number 00200
:setvar dc_description "repair_zone fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    15.04.2008 VLavrentiev  repair_zone fixed
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

ALTER FUNCTION [dbo].[utfVRPR_REPAIR_ZONE_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения ремонтной зоны
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
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
		  ,a.employee_h_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '.' + substring(c.surname, 1, 1)+ '.' as FIO_employee_h
		  ,a.employee_mech_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '.' + substring(c2.surname, 1, 1)+ '.' as FIO_employee_mech
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_disc	
		  ,a.date_started
		  ,a.date_ended		
      FROM dbo.CRPR_REPAIR_ZONE_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_h_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CPRT_EMPLOYEE as b2
			on a.employee_mech_id = b2.id
		join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		join dbo.CCAR_CAR as d
			on a.car_id = d.id
		join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CRPR_REPAIR_TYPE_MASTER as h
			on a.repair_type_id = h.id

		
		
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о ремонтных зонах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id numeric(38,0)
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
		  ,employee_h_id
		  ,FIO_employee_h
		  ,employee_mech_id
		  ,FIO_employee_mech 
		  ,repair_type_id
		  ,repair_type_sname
		  ,malfunction_disc	
		  ,date_started
		  ,date_ended 
	FROM dbo.utfVRPR_REPAIR_ZONE_MASTER()
	where id = @p_id

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о ремонтных зонах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
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
		  ,employee_h_id
		  ,FIO_employee_h
		  ,employee_mech_id
		  ,FIO_employee_mech 
		  ,repair_type_id
		  ,repair_type_sname
		  ,malfunction_disc	
		  ,date_started
		  ,date_ended 
	FROM dbo.utfVRPR_REPAIR_ZONE_MASTER()
	  WHERE date_started between @p_start_date
							   and @p_end_date

	RETURN
GO



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
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. ' + substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
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
		  ,a.repair_zone_master_id			
      FROM dbo.CWRH_WRH_ORDER_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		left outer join dbo.CPRT_EMPLOYEE as b2
			on a.employee_head_id = b2.id
		left outer join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		left outer join dbo.CPRT_EMPLOYEE as b3
			on a.employee_worker_id = b3.id
		left outer join dbo.CPRT_PERSON as c3
			on b3.person_id = c3.id
		left outer join dbo.CCAR_CAR as d
			on a.car_id = d.id
		left outer join dbo.CCAR_CONDITION as e
			on a.car_id = e.car_id
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
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
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_sname
		  ,a.car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,a.FIO_employee_recieve
		  ,a.employee_head_id
		  ,a.FIO_employee_head 
		  ,a.employee_worker_id
		  ,a.FIO_employee_worker
		  ,a.date_created
		  ,a.order_state
		  ,a.repair_type_id
		  ,a.repair_type_sname
		  ,a.malfunction_desc
		  ,a.run
		  ,a.order_state
		  ,a.repair_zone_master_id
		  ,b.date_started 
		  ,b.date_ended
		  ,b.malfunction_disc
	FROM dbo.utfVWRH_WRH_ORDER_MASTER(@p_start_date, @p_end_date) as a
	left outer join dbo.utfVRPR_REPAIR_ZONE_MASTER() as b
		on a.repair_zone_master_id = b.id

	RETURN
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
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_sname
		  ,a.car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,a.FIO_employee_recieve
		  ,a.employee_head_id
		  ,a.FIO_employee_head 
		  ,a.employee_worker_id
		  ,a.FIO_employee_worker
		  ,a.date_created
		  ,a.order_state
		  ,a.repair_type_id
		  ,a.repair_type_sname
		  ,a.malfunction_desc
		  ,convert(decimal(18,0), a.run) as run
		  ,a.order_state
		  ,a.repair_zone_master_id
		  ,b.date_started 
		  ,b.date_ended
		  ,b.malfunction_disc
	FROM dbo.utfVWRH_WRH_ORDER_MASTER(@p_start_date, @p_end_date) as a
	left outer join dbo.utfVRPR_REPAIR_ZONE_MASTER() as b
		on a.repair_zone_master_id = b.id

	RETURN
GO

alter table dbo.CRPR_REPAIR_ZONE_MASTER
drop constraint FK_CRPR_REP_REFERENCE_CCAR_CAR
go

alter table dbo.CRPR_REPAIR_ZONE_MASTER
add constraint CRPR_REPAIR_ZONE_M_CAR_ID_FK
foreign key (car_id)
references dbo.CCAR_CAR(id)
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

