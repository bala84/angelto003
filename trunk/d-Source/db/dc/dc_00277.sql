:r ./../_define.sql

:setvar dc_number 00277
:setvar dc_description "ts_type master delete fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    29.05.2008 VLavrentiev  ts_type master delete fixed
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО
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
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction  

   delete from dbo.CCAR_TS_TYPE_RELATION
	where child_id = @p_id
		or parent_id = @p_id 

   delete
	from dbo.CCAR_TS_TYPE_MASTER
	where id = @p_id

   delete
	from dbo.CRPR_REPAIR_TYPE_DETAIL
	where repair_type_master_id = @p_id

   delete
	from dbo.CRPR_REPAIR_TYPE_MASTER
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта в справочнике ремонтов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) out
    ,@p_short_name					varchar(30)
    ,@p_full_name					varchar(60)
	,@p_code						varchar(20)
	,@p_time_to_repair_in_minutes	int
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CRPR_REPAIR_TYPE_MASTER 
            (short_name, full_name, code, time_to_repair_in_minutes, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_code, @p_time_to_repair_in_minutes, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
   begin
      if (@@tranCount = 0)
        begin transaction  
  -- надо править существующий
		update dbo.CRPR_REPAIR_TYPE_MASTER set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,code = @p_code
		,time_to_repair_in_minutes = @p_time_to_repair_in_minutes
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

	 --на случай привязки к ТО необходимо проапдейтить и ТО 
		update dbo.CCAR_TS_TYPE_MASTER set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

 
	   if (@@tranCount > @v_TrancountOnEntry)
        commit
 
	 end 
    
  return 

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVCAR_TS_TYPE_RELATION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения потомков ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую функцию
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
		  ,c.short_name parent_ts_type_sname
		  ,a.parent_id
		  ,b.short_name as child_ts_type_sname
		  ,a.child_id
		  FROM dbo.CCAR_TS_TYPE_RELATION as a
		JOIN dbo.CCAR_TS_TYPE_MASTER as b on a.child_id = b.id
		JOIN dbo.CCAR_TS_TYPE_MASTER  as c on a.parent_id = c.id

)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVCAR_TS_TYPE_RELATION] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVCAR_TS_TYPE_RELATION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_parent_id			numeric(38,0)
    ,@p_child_id			numeric(38,0)
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

	   insert into dbo.CCAR_TS_TYPE_RELATION
		(child_id, parent_id, sys_comment, sys_user_created, sys_user_modified)
	   values (@p_child_id, @p_parent_id, @p_sys_comment, @p_sys_user, @p_sys_user)
	
	   set @p_id = scope_identity()	
	end
  else
		update dbo.CCAR_TS_TYPE_RELATION set
		 parent_id = @p_parent_id
        ,child_id = @p_child_id
        ,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_RELATION_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_RELATION_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_TS_TYPE_RELATION_SelectByParent_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о дочерних типах ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
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
		  ,parent_id
		  ,parent_ts_type_sname
		  ,child_id
		  ,child_ts_type_sname	
	FROM dbo.utfVCAR_TS_TYPE_RELATION()

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_RELATION_SelectByParent_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_RELATION_SelectByParent_id] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVCAR_TS_TYPE_RELATION_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из отношений между ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0)
)
as
begin
  set nocount on

	delete
	from dbo.CCAR_TS_TYPE_RELATION
	where id = @p_id
 
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_RELATION_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_RELATION_DeleteById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_TS_TYPE_RELATION_SelectByParent_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о дочерних типах ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_parent_id numeric(38,0)
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
		  ,parent_id
		  ,parent_ts_type_sname
		  ,child_id
		  ,child_ts_type_sname	
	FROM dbo.utfVCAR_TS_TYPE_RELATION()
	where parent_id = @p_parent_id

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_short_name			varchar(30)
    ,@p_full_name			varchar(60)	  = null
	,@p_periodicity			int
	,@p_car_mark_id			numeric(38,0)
	,@p_car_model_id		numeric(38,0)
	,@p_tolerance			smallint	  = 0
	,@p_parent_id			numeric(38,0) = null
	,@p_code				varchar(20)	  = null
	,@p_time_to_repair_in_minutes int	  = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_code int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

	 if (@p_tolerance is null)
	set @p_tolerance = 0
     if (@p_code is null)
	set @p_code = '1000' 
	 if (@p_time_to_repair_in_minutes is null)
	set @p_time_to_repair_in_minutes = 999999

     if (@@tranCount = 0)
      begin transaction 

  exec @v_error = 
		dbo.uspVRPR_REPAIR_TYPE_MASTER_SaveById
			 @p_id = @p_id out
			,@p_short_name = @p_short_name
			,@p_full_name = @p_full_name
			,@p_code = @p_code
			,@p_time_to_repair_in_minutes = @p_time_to_repair_in_minutes
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user
		  
    insert into
			     dbo.CCAR_TS_TYPE_MASTER 
            (id, short_name, full_name, periodicity, car_mark_id, car_model_id
			, tolerance, sys_comment, sys_user_created, sys_user_modified)
	select  @p_id, @p_short_name, @p_full_name, @p_periodicity, @p_car_mark_id, @p_car_model_id
			, @p_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
    where not exists
	(select 1 from dbo.CCAR_TS_TYPE_MASTER
		where id = @p_id)

 if (@@rowcount = 0)  
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_MASTER set
		 short_name = @p_short_name
		,full_name = @p_full_name
		,periodicity = @p_periodicity
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,tolerance = @p_tolerance
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id



	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return  

end
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


