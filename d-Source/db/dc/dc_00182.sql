:r ./../_define.sql

:setvar dc_number 00182                  
:setvar dc_description "repair demand master added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.04.2008 VLavrentiev  repair demand master added
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

create FUNCTION [dbo].[utfVWRH_WRH_DEMAND_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую функцию
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
      FROM dbo.CWRH_WRH_DEMAND_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CCAR_CAR as d
			on a.car_id = d.id
		join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
	  WHERE a.date_created between @p_start_date
							   and @p_end_date
		
		
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVWRH_WRH_DEMAND_MASTER] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о требованиях
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
	FROM dbo.utfVWRH_WRH_DEMAND_MASTER(@p_start_date, @p_end_date)

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id
			, employee_worker_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из требований
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.cwrh_wrh_demand_master
	where id = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_DEMAND_MASTER_DeleteById] TO [$(db_app_user)]
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

