:r ./../_define.sql
:setvar dc_number 00031
:setvar dc_description "WRH_GOOD_CATEGORY procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.02.2008 VLavrentiev  WRH_GOOD_CATEGORY procs added   
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
print 'Adding utfVWRH_GOOD_CATEGORY...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVWRH_GOOD_CATEGORY] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения категорий товаров
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 

(	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id
		  FROM dbo.CWRH_GOOD_CATEGORY as a)
go

GRANT VIEW DEFINITION ON [dbo].[utfVWRH_GOOD_CATEGORY] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVWRH_GOOD_CATEGORY_SelectAll...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVWRH_GOOD_CATEGORY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о категориях товаров
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
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
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id	
	FROM dbo.utfVWRH_GOOD_CATEGORY() as a

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_SelectAll] TO [$(db_app_user)]
GO

print ' '
print 'Adding uspVWRH_GOOD_CATEGORY_SelectByParent_id...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVWRH_GOOD_CATEGORY_SelectByParent_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о категориях товаров
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_parent_id numeric(38,0)
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
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id	
	FROM dbo.utfVWRH_GOOD_CATEGORY() as a
	WHERE a.parent_id = @p_parent_id 

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_SelectByParent_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_SelectByParent_id] TO [$(db_app_user)]
GO

print ' '
print 'Adding uspVWRH_GOOD_CATEGORY_SaveById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVWRH_GOOD_CATEGORY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип ТО деталь
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_good_mark			numeric(30)
    ,@p_short_name			numeric(30)
	,@p_full_name			varchar(60)
	,@p_unit				varchar(20)
	,@p_parent_id			numeric(38,0)
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

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, unit, parent_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_unit, @p_parent_id,  @p_sys_comment, @p_sys_user, @p_sys_user)

   end
  else    
  -- надо править существующий
		update dbo.CWRH_GOOD_CATEGORY set
		 good_mark = @p_good_mark
		,short_name = @p_short_name 
		,full_name = @p_full_name
		,unit = @p_unit
		,parent_id = @p_parent_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_SaveById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVWRH_GOOD_CATEGORY_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVWRH_GOOD_CATEGORY_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО деталь
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
)
as
begin
  set nocount on

	delete
	from dbo.CWRH_GOOD_CATEGORY
	where id = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_DeleteById] TO [$(db_app_user)]
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
