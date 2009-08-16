:r ./../_define.sql
:setvar dc_number 00028
:setvar dc_description "DRIVER_CONTROL procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.02.2008 VLavrentiev  DRIVER_CONTROL procs added   
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



print ' '
print 'Adding utfVDRV_DRIVER_CONTROL...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVDRV_DRIVER_CONTROL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения контроля за путевым листом
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
	SELECT a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.control_type_id
		  ,b.short_name as control_type_name
		  ,a.employee_id
		  ,a.driver_list_id
		  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as FIO_control_type
      FROM dbo.CDRV_DRIVER_CONTROL as a
		JOIN dbo.CDRV_CONTROL_TYPE as b on a.control_type_id = b.id
		JOIN dbo.CPRT_EMPLOYEE as c on a.employee_id = c.id
		JOIN dbo.CPRT_PERSON as d on c.person_id = d.id
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVDRV_DRIVER_CONTROL] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_CONTROL_SelectById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVDRV_DRIVER_CONTROL_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах заметок
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_control_type_id numeric(38,0)
 ,@p_employee_id	 numeric(38,0)
 ,@p_driver_list_id  numeric(38,0)
)
AS

    SET NOCOUNT ON
  
       SELECT  
		   sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,control_type_id
		  ,control_type_name
		  ,employee_id
		  ,driver_list_id
		  ,FIO_control_type
	FROM dbo.utfVDRV_DRIVER_CONTROL()
	WHERE   control_type_id = @p_control_type_id
		and employee_id = @p_employee_id
		and driver_list_id = @p_driver_list_id

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_CONTROL_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_CONTROL_SelectById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_CONTROL_SaveById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVDRV_DRIVER_CONTROL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_control_type_id  numeric(38,0)
    ,@p_employee_id      numeric(38,0)
	,@p_driver_list_id   numeric(38,0)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     
   insert into
			     dbo.CDRV_DRIVER_CONTROL 
            (control_type_id, employee_id, driver_list_id, sys_comment, sys_user_created, sys_user_modified)
	select @p_control_type_id, @p_employee_id, @p_driver_list_id, @p_sys_comment, @p_sys_user, @p_sys_user
	 where not exists
		(select 1 from dbo.CDRV_DRIVER_CONTROL as b
          where b.control_type_id = @p_control_type_id
			and b.employee_id = @p_employee_id
			and b.driver_list_id = @p_driver_list_id)
       
  -- надо править существующий
		update dbo.CDRV_DRIVER_CONTROL set
		 sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where   control_type_id = @p_control_type_id
			and employee_id = @p_employee_id
			and driver_list_id = @p_driver_list_id
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_CONTROL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_CONTROL_SaveById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_DRIVER_CONTROL_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVDRV_DRIVER_CONTROL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_control_type_id numeric(38,0)
    ,@p_employee_id		numeric(38,0)
	,@p_driver_list_id  numeric(38,0)
)
as
begin
  set nocount on

	delete
	from dbo.CDRV_DRIVER_CONTROL
	where control_type_id = @p_control_type_id
			and employee_id = @p_employee_id
			and driver_list_id = @p_driver_list_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_CONTROL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_CONTROL_DeleteById] TO [$(db_app_user)]
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
