:r ./../_define.sql
:setvar dc_number 00030
:setvar dc_description "CAR_TS_TYPE_DETAIL procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.02.2008 VLavrentiev  CAR_TS_TYPE_DETAIL procs added   
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
print 'Adding utfVCAR_TS_TYPE_DETAIL...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVCAR_TS_TYPE_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения ТО детали
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
		  ,a.good_category_id
		  ,b.good_mark
		  ,b.short_name as good_category_name
		  ,b.unit
		  ,a.amount
		  ,a.ts_type_master_id		
		  FROM dbo.CCAR_TS_TYPE_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b on a.good_category_id = b.id
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVCAR_TS_TYPE_DETAIL] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVCAR_TS_TYPE_DETAIL_SelectAll...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVCAR_TS_TYPE_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ts_type_master_id numeric(38,0)
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
		  ,good_category_id
		  ,good_mark
		  ,good_category_name
		  ,unit
		  ,amount
		  ,ts_type_master_id	
	FROM dbo.utfVCAR_TS_TYPE_DETAIL()
	WHERE ts_type_master_id = @p_ts_type_master_id 

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVCAR_TS_TYPE_DETAIL_SaveById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVCAR_TS_TYPE_DETAIL_SaveById]
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
	,@p_ts_type_master_id	numeric(38,0)
    ,@p_good_category_id	numeric(38,0)
	,@p_amount				smallint
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
			     dbo.CCAR_TS_TYPE_DETAIL 
            ( ts_type_master_id, good_category_id, amount, sys_comment, sys_user_created, sys_user_modified)
	values( @p_ts_type_master_id, @p_good_category_id, @p_amount,  @p_sys_comment, @p_sys_user, @p_sys_user)

   end
  else    
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_DETAIL set
		 ts_type_master_id = @p_ts_type_master_id
		,good_category_id = @p_good_category_id
		,amount = @p_amount
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_DETAIL_SaveById] TO [$(db_app_user)]
GO



print ' '
print 'Adding uspVCAR_TS_TYPE_DETAIL_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVCAR_TS_TYPE_DETAIL_DeleteById]
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
	from dbo.CCAR_TS_TYPE_DETAIL
	where id = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_DETAIL_DeleteById] TO [$(db_app_user)]
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
