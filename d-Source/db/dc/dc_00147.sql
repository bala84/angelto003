:r ./../_define.sql

:setvar dc_number 00147                  
:setvar dc_description "ts type master child array added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.03.2008 VLavrentiev  ts type master child array added
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

ALTER FUNCTION [dbo].[utfVCAR_TS_TYPE_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения ТО
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
		  ,a.short_name
		  ,a.full_name
		  ,a.periodicity
		  ,a.car_mark_id
		  ,b.short_name + ' - ' + c.short_name as car_mark_model_name
		  ,a.car_model_id
		  ,a.tolerance	
		  ,b.short_name as car_mark_sname
		  ,c.short_name as car_model_sname	
		  ,a.parent_id
		  ,null as child_ts_type_array
		  FROM dbo.CCAR_TS_TYPE_MASTER as a
		JOIN dbo.CCAR_CAR_MARK as b on a.car_mark_id = b.id
		JOIN dbo.CCAR_CAR_MODEL as c on a.car_model_id = c.id

)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_TS_TYPE_MASTER_SelectAll]
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
		  ,short_name
		  ,full_name
		  ,periodicity
		  ,car_mark_id
		  ,car_mark_model_name
		  ,car_model_id
		  ,tolerance	
		  ,car_mark_sname
		  ,car_model_sname
		  ,parent_id
		  ,child_ts_type_array	
	FROM dbo.utfVCAR_TS_TYPE_MASTER()

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
	,@p_child_ts_type_array xml			  = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int


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

     if (@@tranCount = 0)
      begin transaction 

  if (@p_id is null)
   begin   
    insert into
			     dbo.CCAR_TS_TYPE_MASTER 
            (short_name, full_name, periodicity, car_mark_id, car_model_id
			, tolerance, parent_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_short_name, @p_full_name, @p_periodicity, @p_car_mark_id, @p_car_model_id
			, @p_tolerance, @p_parent_id, @p_sys_comment, @p_sys_user, @p_sys_user)

   end
  else    
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_MASTER set
		 short_name = @p_short_name
		,full_name = @p_full_name
		,periodicity = @p_periodicity
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,tolerance = @p_tolerance
		,parent_id = @p_parent_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id

    if (@p_child_ts_type_array is not null)
	  update dbo.CCAR_TS_TYPE_MASTER set
		parent_id = @p_id
	  where exists
		(select 1
		  from @p_child_ts_type_array.nodes('/ts_type/id') 
			as ts_type_id(id)
		  where ts_type_id.id.value('.','numeric(38,0)') 
			  = dbo.CCAR_TS_TYPE_MASTER.id)
		   


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

