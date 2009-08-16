:r ./../_define.sql

:setvar dc_number 00139                  
:setvar dc_description "last ts type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.03.2008 VLavrentiev  last ts type added
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

CREATE FUNCTION [dbo].[utfVCAR_LAST_TS_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности последних ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_car_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT --TOP(1)
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id
		  ,a.last_ts_type_master_id
		  ,run
      FROM dbo.CHIS_CONDITION as a
		JOIN dbo.CCAR_TS_TYPE_MASTER as g on g.id = a.last_ts_type_master_id
	 where  a.car_id = @p_car_id 
		and a.sent_to = 'Y'
		and a.run = (select max(run) from dbo.CHIS_CONDITION as a2
					 where a.last_ts_type_master_id = a2.last_ts_type_master_id
					   and a.car_id = a2.car_id
					   and a2.sent_to = 'Y')
		and a.last_ts_type_master_id in (select c.id from dbo.CCAR_TS_TYPE_MASTER as c
										 where exists
											(select 1 from dbo.CCAR_CAR as b
												where c.car_mark_id = b.car_mark_id
												  and c.car_model_id = b.car_model_id
												  and b.id = @p_car_id))											
	  
	  

)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVCAR_LAST_TS_TYPE] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVCAR_LAST_TS_TYPE_SelectByCar_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о последних ТО автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_car_id numeric(38,0)
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
		  ,car_id
		  ,last_ts_type_master_id
		  ,run
	FROM dbo.utfVCAR_LAST_TS_TYPE(@p_car_id)
	order by run desc, last_ts_type_master_id asc 

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_LAST_TS_TYPE_SelectByCar_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_LAST_TS_TYPE_SelectByCar_Id] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVCAR_LAST_TS_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об истории прохождения ТО автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
	,@p_date_created				datetime      = null
    ,@p_car_id		        		numeric(38,0)
    ,@p_last_ts_type_master_id   	numeric(38,0) = null
    ,@p_run 			    		decimal(18,9)
	,@p_sent_to						char		  = 'Y'
	,@p_overrun					    decimal(18,9)		  = 0
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
  set nocount on

	declare @v_action smallint

     if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_run is null)
	set @p_run = 0.0
	    
	
	 if (@p_sent_to is null)
	set @p_sent_to = 'Y'




	 if (@p_date_created is null)
	set @p_date_created = getdate();

	if (@p_id is null)

	 begin

		set @v_action = dbo.usfConst('ACTION_INSERT')

		insert into dbo.CHIS_CONDITION 
		(date_created, action, car_id, ts_type_master_id, employee_id
		,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
		, fuel_start_left, fuel_end_left, edit_state, sent_to, overrun, in_tolerance, sys_comment, sys_user_created, sys_user_modified)
		values
		(@p_date_created, @v_action, @p_car_id, null, null
		,@p_run, 0, @p_last_ts_type_master_id, 0.0 , 0.0
		,0.0 , 0.0 , null, @p_sent_to, 0.0, 0, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

	 end
    
	else
	 begin

		set @v_action = dbo.usfConst('ACTION_UPDATE')

		update dbo.CHIS_CONDITION
		set 
		   run = @p_run
		  ,last_ts_type_master_id = @p_last_ts_type_master_id
		  ,action = @v_action
		  ,sent_to = @p_sent_to
		  ,sys_comment = @p_sys_comment
          ,sys_user_modified = @p_sys_user
		where id = @p_id

	 end
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_LAST_TS_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_LAST_TS_TYPE_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_Check_last_ts] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура проверяет прошлое ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id					numeric (38,0)		
,@p_last_ts_verified		tinyint out
)
AS
BEGIN

SET NOCOUNT ON

if exists(
select	TOP(1)   1
from dbo.utfVCAR_TS_TYPE_MASTER() as a
where exists
(select 1 from dbo.CCAR_CAR as b
	where b.car_mark_id = a.car_mark_id
	  and b.car_model_id = a.car_model_id
	  and b.id = @p_car_id)
  and a.periodicity <= isnull((select max(c2.run) from dbo.CHIS_CONDITION as c2
						 where c2.car_id = @p_car_id), 0)
  and not exists
(select 1 from dbo.CHIS_CONDITION as c
  where c.last_ts_type_master_id = a.id
	and c.sent_to = 'Y')) 

	set @p_last_ts_verified = 0

else

	set @p_last_ts_verified = 1

END
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

