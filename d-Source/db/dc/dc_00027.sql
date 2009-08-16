:r ./../_define.sql
:setvar dc_number 00027
:setvar dc_description "DRV_TRAILER procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.02.2008 VLavrentiev  DRV_TRAILER procs added   
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
print 'Adding utfVDRV_TRAILER...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVDRV_TRAILER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения прицепленных устройств
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
	SELECT	   a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.device_id
		  ,b.short_name as device_name
		  ,a.work_hour_amount
		  ,a.driver_list_id
      FROM dbo.CDRV_TRAILER as a
		JOIN dbo.CDEV_DEVICE as b on a.device_id = b.id
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVDRV_TRAILER] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_TRAILER_SelectById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVDRV_TRAILER_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о прицепленных устройствах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(                      
 @p_device_id 	   numeric(38,0)
,@p_driver_list_id numeric(38,0)
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
		  ,device_id
		  ,device_name
		  ,work_hour_amount
		  ,driver_list_id
	FROM dbo.utfVDRV_TRAILER()
	WHERE device_id = @p_device_id
	  and driver_list_id = @p_driver_list_id

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVDRV_TRAILER_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_TRAILER_SelectById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_TRAILER_SaveById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVDRV_TRAILER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить прицепленное устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_device_id			numeric(38,0)
    ,@p_work_hour_amount    int
	,@p_driver_list_id		numeric(38,0)
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

    
	insert into
			     dbo.CDRV_TRAILER 
            (device_id, work_hour_amount, driver_list_id, sys_comment, sys_user_created, sys_user_modified)
	select @p_device_id, @p_work_hour_amount, @p_driver_list_id, @p_sys_comment, @p_sys_user, @p_sys_user
     where not exists
       (select top(1) 1 from dbo.CDRV_TRAILER as b
		 where @p_device_id = b.device_id
		   and @p_driver_list_id = b.driver_list_id)
       
	    
 if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CDRV_TRAILER set
		 work_hour_amount = @p_work_hour_amount
		,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where device_id = @p_device_id
		  and driver_list_id = @p_driver_list_id 
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_TRAILER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_TRAILER_SaveById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVDRV_TRAILER_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVDRV_TRAILER_DeleteById]
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
     @p_device_id          numeric(38,0)
    ,@p_driver_list_id     numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CDRV_TRAILER
	where device_id = @p_device_id
	  and driver_list_id = @p_driver_list_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_TRAILER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_TRAILER_DeleteById] TO [$(db_app_user)]
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
