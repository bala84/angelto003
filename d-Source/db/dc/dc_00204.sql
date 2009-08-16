:r ./../_define.sql

:setvar dc_number 00204
:setvar dc_description "route_detail added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.04.2008 VLavrentiev  route_detail added
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


EXEC sp_rename 'CCAR_TS_TYPE_ROUTE_DETAIL.ts_type_master_id', 'ts_type_route_master_id', 'COLUMN'
go



alter table dbo.CCAR_TS_TYPE_ROUTE_DETAIL
add ts_type_master_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'ts_type_master_id'
go



alter table CCAR_TS_TYPE_ROUTE_DETAIL
   add constraint CCAR_TS_TYPE_DETAIL_TS_TYPE_MASTER_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
go

create index ifk_ts_type_master_id_ts_type_detail on dbo.CCAR_TS_TYPE_ROUTE_DETAIL(ts_type_master_id)
on $(fg_idx_name)
go


create index u_ts_type_mstr_route_mstr_ordrd_ts_type_d on dbo.CCAR_TS_TYPE_ROUTE_DETAIL(ts_type_route_master_id, ts_type_master_id, ordered)
on $(fg_idx_name)
go



EXEC sp_rename 'CCAR_CAR_MODEL.route_master_id', 'ts_type_route_master_id', 'COLUMN'
go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVCAR_TS_TYPE_ROUTE_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей маршрута
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.08.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_ts_type_route_master_id		numeric(38,0)
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
		  ,a.ts_type_route_master_id
		  ,a.ts_type_master_id
		  ,b.short_name
		  ,a.ordered
      FROM dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
		JOIN dbo.CCAR_TS_TYPE_MASTER as b on a.ts_type_master_id = b.id
	 WHERE ts_type_route_master_id = @p_ts_type_route_master_id	
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVCAR_TS_TYPE_ROUTE_DETAIL] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о маршруте ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_ts_type_route_master_id numeric(38,0)
)
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
		  ,ts_type_master_id
		  ,ts_type_route_master_id
		  ,ordered
	FROM dbo.utfVCAR_TS_TYPE_ROUTE_DETAIL(@p_ts_type_route_master_id)

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SelectByTs_type_route_master_id] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь маршрута
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.08.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) = null out
    ,@p_ts_type_master_id		numeric(38,0)
	,@p_ts_type_route_master_id numeric(38,0)
	,@p_ordered					smallint
    ,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
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
			     dbo.CCAR_TS_TYPE_ROUTE_DETAIL
            (ts_type_master_id, ts_type_route_master_id, ordered, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_ts_type_master_id , @p_ts_type_route_master_id, @p_ordered, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_ROUTE_DETAIL set
			 ts_type_master_id =  @p_ts_type_master_id
        	,ts_type_route_master_id =  @p_ts_type_route_master_id
			,ordered = @p_ordered
	    	,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей маршрутов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
	where id = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_DeleteById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR_MODEL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения моделей автомобилей
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_car_mark_id		numeric(38,0)
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
		  ,a.short_name
		  ,a.full_name
		  ,a.mark_id
		  ,b.short_name as car_mark_name
		  ,a.ts_type_route_master_id
      FROM dbo.CCAR_CAR_MODEL as a
		JOIN dbo.CCAR_CAR_MARK as b on a.mark_id = b.id
	 WHERE mark_id = @p_car_mark_id	
)
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_MODEL_SelectByMark_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о моделях автомобиля по ид марки
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_car_mark_id numeric(38,0)
)
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
		  ,mark_id
		  ,car_mark_name
		  ,ts_type_route_master_id
		  ,case when ts_type_route_master_id is null
				then 0
				else 1
			end as is_has_route_master
	FROM dbo.utfVCAR_CAR_MODEL(@p_car_mark_id)

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure dbo.uspVCAR_CAR_MODEL_SaveById
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить модель автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0) = null out
    ,@p_short_name		varchar(30)
    ,@p_full_name		varchar(60)
    ,@p_mark_id			numeric(38,0)   
	,@p_ts_type_route_master_id numeric(38,0) = null
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
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
			     dbo.CCAR_CAR_MODEL 
            (short_name, full_name, mark_id, ts_type_route_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_mark_id, @p_ts_type_route_master_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CAR_MODEL set
			short_name =  @p_short_name
        	,full_name =  @p_full_name
			,mark_id = @p_mark_id
			,ts_type_route_master_id = @p_ts_type_route_master_id
	    	,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where ID = @p_id
    
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

