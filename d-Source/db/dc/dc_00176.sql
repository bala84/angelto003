:r ./../_define.sql

:setvar dc_number 00176                  
:setvar dc_description "warehouse income master added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    11.04.2008 VLavrentiev  warehouse income master added
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

create procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить приходный документ на складе
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(150)
	,@p_organization_id		numeric(38,0)
    ,@p_warehouse_type_id   numeric(38,0)
	,@p_date_created		datetime
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

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_MASTER 
            ( number, organization_id
			, warehouse_type_id
			, date_created
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_number, @p_organization_id
			, @p_warehouse_type_id
			, @p_date_created
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_MASTER set
		 number = @p_number
	    ,organization_id = @p_organization_id
		,warehouse_type_id = @p_warehouse_type_id
		,date_created = @p_date_created
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из приходных документов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.cwrh_wrh_income_master
	where id = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_MASTER_DeleteById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[utfVWRH_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения приходных документов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,warehouse_type_id
		  ,date_created
      FROM dbo.CWRH_WRH_INCOME_MASTER
	
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVWRH_WRH_INCOME_MASTER] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
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
		  ,number
		  ,organization_id
		  ,warehouse_type_id	
		  ,date_created
	FROM dbo.utfVWRH_WRH_INCOME_MASTER()

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll] TO [$(db_app_user)]
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
