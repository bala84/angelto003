:r ./../_define.sql

:setvar dc_number 00388
:setvar dc_description "repair bill procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   23.09.2008 VLavrentiev  repair bill procs added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVRPR_REPAIR_BILL_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения ведомости используемых запчастей в ремонтах
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
		  ,a.full_name
		  ,a.repair_type_master_id
		  ,b.short_name	
		FROM dbo.CRPR_REPAIR_BILL_MASTER as a
		join dbo.CRPR_REPAIR_TYPE_MASTER as b
			on a.repair_type_master_id = b.id
)
go


GRANT VIEW DEFINITION ON [dbo].[utfVRPR_REPAIR_BILL_MASTER] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVRPR_REPAIR_BILL_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о ведомостях по используемым запчастям в ремонте
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_repair_type_master_id numeric(38,0)
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.full_name
		  ,a.repair_type_master_id
		  ,a.short_name	
	FROM dbo.utfVRPR_REPAIR_BILL_MASTER() as a
	where 
		a.repair_type_master_id = @p_repair_type_master_id
	  and
	(((@p_Str != '')
		   and (rtrim(ltrim(upper(a.full_name))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))

	RETURN
go



GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_BILL_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить ведомость запчастей
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_full_name				varchar(60)
	,@p_repair_type_master_id	numeric(38,0)
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
			     dbo.CRPR_REPAIR_BILL_MASTER
            (full_name, repair_type_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_full_name , @p_repair_type_master_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_BILL_MASTER set
         full_name =  @p_full_name
		,repair_type_master_id =  @p_repair_type_master_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

  
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVRPR_REPAIR_BILL_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить ведомость запчастей для ремонта
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 

   delete
	from dbo.CRPR_REPAIR_BILL_DETAIL
	where repair_bill_master_id = @p_id 


delete
	from dbo.CRPR_REPAIR_BILL_MASTER
	where id = @p_id



	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_MASTER_DeleteById] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVRPR_REPAIR_BILL_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения детали ведомости используемых запчастей 
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую функцию
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
		  ,a.amount
		  ,a.repair_bill_master_id
		  ,a.good_category_id
		  ,b.short_name
		FROM dbo.CRPR_REPAIR_BILL_DETAIL as a
		join dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVRPR_REPAIR_BILL_DETAIL] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях ведомостей по используемым запчастям в ремонте
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_repair_bill_master_id numeric(38,0)
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
		  ,a.amount
		  ,a.repair_bill_master_id
		  ,a.good_category_id
		  ,a.short_name
	FROM dbo.utfVRPR_REPAIR_BILL_DETAIL() as a
	where 
		a.repair_bill_master_id = @p_repair_bill_master_id

	RETURN
go



GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SelectByMaster_id] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь ведомости запчастей
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
	 ,@p_amount					decimal(18,9)
	 ,@p_repair_bill_master_id	numeric(38,0)
	 ,@p_good_category_id		numeric(38,0)
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
			     dbo.CRPR_REPAIR_BILL_DETAIL 
            ( repair_bill_master_id, good_category_id, amount, sys_comment, sys_user_created, sys_user_modified)
	values( @p_repair_bill_master_id, @p_good_category_id, @p_amount,  @p_sys_comment, @p_sys_user, @p_sys_user)
	
	set @p_id = scope_identity()

   end
  else    
  -- надо править существующий
		update dbo.CRPR_REPAIR_BILL_DETAIL  set
		 repair_bill_master_id = @p_repair_bill_master_id
		,good_category_id = @p_good_category_id
		,amount = @p_amount
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVRPR_REPAIR_BILL_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить ведомость запчастей для ремонта
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

delete
	from dbo.CRPR_REPAIR_BILL_DETAIL
	where id = @p_id

    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_BILL_DETAIL_DeleteById] TO [$(db_app_user)]
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


