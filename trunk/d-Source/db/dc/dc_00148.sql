:r ./../_define.sql

:setvar dc_number 00148                  
:setvar dc_description "ts type and condition save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.03.2008 VLavrentiev  ts type and condition save fixed
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

ALTER procedure [dbo].[uspVHIS_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об истории состояний автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
	,@p_date_created				datetime      = null
	,@p_action						smallint
    ,@p_car_id		        		numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id					numeric(38,0) = null
    ,@p_run 			    		decimal(18,9)
    ,@p_last_run					decimal(18,9)	      = 0.0
    ,@p_speedometer_start_indctn	decimal(18,9)	      = 0.0
    ,@p_speedometer_end_indctn		decimal(18,9)	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal(18,9)	      = 0.0
	,@p_fuel_end_left               decimal(18,9)	      = 0.0
	,@p_sent_to						char		  = 'N'
	,@p_overrun					    decimal(18,9)		  = 0
	,@p_in_tolerance				bit			  = 0
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_run is null)
	set @p_run = 0.0
	    
     if (@p_last_run is null)
	set @p_last_run = @p_run

     if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0

     if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

     if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

     if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0	
	
	 if (@p_sent_to is null)
	set @p_sent_to = 'N'

	 if (@p_overrun is null)
	set @p_overrun = 0

	 if (@p_in_tolerance is null)
	set @p_in_tolerance = 0

	 if (@p_date_created is null)
	set @p_date_created = getdate();

   if (@p_id is null)
	begin
	insert into dbo.CHIS_CONDITION 
     (date_created, action, car_id, ts_type_master_id, employee_id
	  , run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, edit_state, sent_to, overrun, in_tolerance, sys_comment, sys_user_created, sys_user_modified)
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, a.id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
    from dbo.CCAR_TS_TYPE_MASTER as a
	where a.id = @p_last_ts_type_master_id
	   or a.parent_id = @p_last_ts_type_master_id
       
	  set @p_id = scope_identity();
	end
   else
	update dbo.CHIS_CONDITION
	   set date_created				= @p_date_created
		 , action					= @p_action
		 , car_id					= @p_car_id
		 , ts_type_master_id		= @p_ts_type_master_id
		 , employee_id				= @p_employee_id
		 , run						= @p_run
		 , last_run					= @p_last_run
		 , last_ts_type_master_id	= @p_last_ts_type_master_id
		 , speedometer_start_indctn	= @p_speedometer_start_indctn
		 , speedometer_end_indctn	= @p_speedometer_end_indctn
		 , fuel_start_left			= @p_fuel_start_left
		 , fuel_end_left			= @p_fuel_end_left
		 , edit_state				= @p_edit_state
		 , sent_to					= @p_sent_to
		 , overrun					= @p_overrun
		 , in_tolerance				= @p_in_tolerance
		 , sys_comment				= @p_sys_comment
		 , sys_user_created			= @p_sys_user
		 , sys_user_modified		= @p_sys_user
	  where id = @p_id
		 or exists
		(select 1 
			FROM dbo.CHIS_CONDITION as a
		  where  a.car_id = dbo.CHIS_CONDITION.car_id 
		    and  a.sent_to = 'Y'
			and  a.run = (select max(run) 
							from dbo.CHIS_CONDITION as a2
						   where a.last_ts_type_master_id = a2.last_ts_type_master_id
							 and a.car_id = a2.car_id
							 and a2.sent_to = 'Y')
			and a.last_ts_type_master_id in (select c.id 
											 from dbo.CCAR_TS_TYPE_MASTER as c
											 where id = @p_last_ts_type_master_id
										      or parent_id = @p_last_ts_type_master_id))
    
  return 

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_LAST_TS_TYPE_SaveById]
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
		   ,@v_Error int

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

		set @v_action = dbo.usfConst('ACTION_INSERT')

    
	else
		set @v_action = dbo.usfConst('ACTION_UPDATE')

	 	exec @v_Error = 
        dbo.uspVHIS_CONDITION_SaveById
        	 @p_id							= @p_id  out
			,@p_action						= @v_action
			,@p_car_id						= @p_car_id
    		,@p_ts_type_master_id			= null
			,@p_last_ts_type_master_id		= @p_last_ts_type_master_id
    		,@p_employee_id					= null
    		,@p_run							= @p_run
    		,@p_last_run					= 0
    		,@p_speedometer_start_indctn 	= 0 
    		,@p_speedometer_end_indctn 		= 0
			,@p_edit_state					= 0 
			,@p_fuel_start_left				= 0
			,@p_fuel_end_left				= 0
			,@p_sent_to						= @p_sent_to
			,@p_overrun						= 0
			,@p_in_tolerance				= 0
			,@p_sys_comment					= @p_sys_comment  
  			,@p_sys_user					= @p_sys_user
  return 

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_LAST_TS_TYPE_SelectByCar_Id]
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
		  ,car_mark_id
		  ,car_model_id
		  ,last_ts_type_master_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,ts_type_sname
	FROM dbo.utfVCAR_LAST_TS_TYPE(@p_car_id) as a
	where not exists
	(select 1 
		from dbo.utfVCAR_LAST_TS_TYPE(@p_car_id) as b
		where a.run = b.run
		and a.ts_type_sname != b.ts_type_sname
		and a.last_ts_type_master_id in (select c.id
										 from dbo.CCAR_TS_TYPE_MASTER as c
										 where c.parent_id = b.last_ts_type_master_id))	
	order by run desc, last_ts_type_master_id asc 

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_LAST_TS_TYPE] 
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
		  ,e.car_mark_id
		  ,e.car_model_id
		  ,a.last_ts_type_master_id
		  ,a.run
		  ,g.short_name as ts_type_sname
      FROM dbo.CHIS_CONDITION as a
		JOIN dbo.CCAR_TS_TYPE_MASTER as g on g.id = a.last_ts_type_master_id
		JOIN dbo.CCAR_CAR as e on a.car_id = e.id
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

