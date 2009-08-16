:r ./../_define.sql

:setvar dc_number 00202
:setvar dc_description "route_master_id added in car_model"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.04.2008 VLavrentiev  route_master_id added in car_model
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


alter table dbo.CCAR_CAR_MODEL
add route_master_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид маршрута ТО',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'route_master_id'
go



alter table CCAR_CAR_MODEL
   add constraint CCAR_CAR_MODEL_TS_TYPE_ROUTE_MASTER_ID_FK foreign key (route_master_id)
      references CCAR_TS_TYPE_ROUTE_MASTER (id)
go

create index ifk_ts_type_route_master_id_car_model on dbo.CCAR_CAR_MODEL(route_master_id)
on $(fg_idx_name)
go



alter table CCAR_CONDITION
   add constraint CCAR_CONDITION_LAST_TS_TYPE_MASTER_ID_FK foreign key (last_ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
go


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
		  ,a.route_master_id
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
		  ,route_master_id
		  ,case when route_master_id is null
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
	,@p_route_master_id numeric(38,0) = null
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
            (short_name, full_name, mark_id, route_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_mark_id, @p_route_master_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CAR_MODEL set
			short_name =  @p_short_name
        	,full_name =  @p_full_name
			,mark_id = @p_mark_id
			,route_master_id = @p_route_master_id
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

