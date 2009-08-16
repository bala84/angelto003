:r ./../_define.sql

:setvar dc_number 00203
:setvar dc_description "route_master added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.04.2008 VLavrentiev  route_master added
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

CREATE FUNCTION [dbo].[utfVCAR_TS_TYPE_ROUTE_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения маршрута ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2008 VLavrentiev	Добавил новую функцию
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
      FROM dbo.CCAR_TS_TYPE_ROUTE_MASTER as a
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVCAR_TS_TYPE_ROUTE_MASTER] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о маршрутах ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2008 VLavrentiev	Добавил новую процедуру
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
	FROM dbo.utfVCAR_TS_TYPE_ROUTE_MASTER()

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SelectAll] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить маршрут автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.08.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) = null out
    ,@p_short_name       varchar(30)
    ,@p_full_name        varchar(60) = null
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

	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_TS_TYPE_ROUTE_MASTER 
            (short_name, full_name, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_ROUTE_MASTER set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_SaveById] TO [$(db_app_user)]
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

