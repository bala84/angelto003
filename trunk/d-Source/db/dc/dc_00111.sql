:r ./../_define.sql
:setvar dc_number 00111                  
:setvar dc_description "overrun added#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    16.03.2008 VLavrentiev  overrun added#2
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

alter table dbo.CCAR_CONDITION
add overrun decimal default 0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Перепробег',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'overrun'
go


alter table dbo.CHIS_CONDITION
add overrun decimal default 0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Перепробег',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'overrun'
go



/*==============================================================*/
/* Index: i_overrun_to_chis_condition	                        */
/*==============================================================*/
create index i_overrun_chis_condition on CHIS_CONDITION (
overrun DESC
)
on "$(db_name)_IDX"
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CONDITION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CCAR_CONDITION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
( @p_start_date	datetime			
 ,@p_end_date	datetime	
 ,@p_car_type_id numeric(38,0)
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
		  ,a.car_id	  
		  ,b.state_number
		  ,a.ts_type_master_id
		  ,f.short_name as ts_type_name
		  ,g.short_name + ' - ' + h.short_name as car_mark_model_name
		  ,a.employee_id
		  ,e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as FIO
		  ,b.car_state_id
		  ,c.short_name as car_state_name
		  ,b.car_type_id
		  ,a.run
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.last_ts_type_master_id
		  ,'E' as edit_state
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,'N'  as sent_to
		  ,a.last_run
		  ,case when a.overrun < 0  then 0
				else a.overrun
			end as overrun
      FROM dbo.CCAR_CONDITION as a
		JOIN dbo.CCAR_CAR as b on a.car_id = b.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on b.car_state_id = c.id
		JOIN dbo.CCAR_CAR_MARK as g on b.car_mark_id = g.id
		JOIN dbo.CCAR_CAR_MODEL as h on b.car_model_id = h.id
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as d on a.employee_id = d.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as e on d.person_id = e.id
        LEFT OUTER JOIN dbo.CCAR_TS_TYPE_MASTER as f on a.ts_type_master_id = f.id
	  WHERE b.car_type_id = @p_car_type_id
	 -- AND a.sys_date_modified >= @p_start_date
	 -- AND a.sys_date_modified <= @p_end_date	 

)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_CONDITION_Check_ts_type] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура проверяет предстоящее ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_run						decimal
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal out
,@p_ts_type_master_id		decimal out
,@p_last_ts_type_master_id	numeric (38,0) = null	)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity numeric(38,0)
	
		SELECT @p_ts_type_master_id = id, @v_periodicity = periodicity
		FROM
		(SELECT TOP(1) id, periodicity, tolerance
		FROM dbo.utfVCAR_TS_TYPE_MASTER() as a
       WHERE 
			(@p_run >= ((ceiling(@p_run/a.periodicity)*a.periodicity) - a.tolerance))			
	    AND @p_run > 0
		and
		EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id)	   
		ORDER BY periodicity desc) as a
		WHERE NOT EXISTS
		(select 1 from dbo.CHIS_CONDITION as c
		where c.car_id = @p_car_id
		and c.date_created <= getdate()
		and c.last_ts_type_master_id is not null 
		and c.last_ts_type_master_id = a.id
		and c.sent_to = 'Y'
		and c.run >= ((ceiling(@p_run/a.periodicity)*a.periodicity) - a.tolerance) 
		and c.run <= (ceiling(@p_run/a.periodicity)*a.periodicity)
		)
		--and c.run >= @p_run)
--Попробуем найти ТО с перепробегом
if (@p_ts_type_master_id is null)     
select TOP(1) @p_ts_type_master_id = a.ts_type_master_id
			 ,@p_overrun = @p_run - (floor(@p_run/c.periodicity)*c.periodicity) 
from dbo.chis_condition as a
join dbo.CCAR_TS_TYPE_MASTER as c on a.ts_type_master_id = c.id
where a.car_id = @p_car_id
  and a.ts_type_master_id is not null
  and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where a.car_id = b.car_id
		   and b.date_created > a.date_created
		   and b.sent_to = 'Y'
		   and b.run <= (ceiling(b.run/c.periodicity)*c.periodicity)
		   and b.last_ts_type_master_id = a.ts_type_master_id
	)
 order by a.date_created desc


END
GO

GRANT EXECUTE ON [dbo].[uspVCAR_CONDITION_Check_ts_type] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_CONDITION_Check_ts_type] TO [$(db_app_user)]
GO



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
    ,@p_run 			    		decimal
    ,@p_last_run					decimal	      = 0.0
    ,@p_speedometer_start_indctn	decimal	      = 0.0
    ,@p_speedometer_end_indctn		decimal	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal	      = 0.0
	,@p_fuel_end_left               decimal	      = 0.0
	,@p_sent_to						char		  = 'N'
	,@p_overrun					    decimal		  = 0
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

	 if (@p_date_created is null)
	set @p_date_created = getdate();

	insert into dbo.CHIS_CONDITION 
     (date_created, action, car_id, ts_type_master_id, employee_id
	   ,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, edit_state, sent_to, overrun, sys_comment, sys_user_created, sys_user_modified)
	   values
	(@p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    
  return 

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные о состоянии автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
    ,@p_car_id		        		numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id					numeric(38,0) = null
    ,@p_run 			    		decimal
    ,@p_last_run					decimal	      = 0.0
    ,@p_speedometer_start_indctn	decimal	      = 0.0
    ,@p_speedometer_end_indctn		decimal	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal	      = 0.0
	,@p_fuel_end_left               decimal	      = 0.0
	,@p_sent_to						char		  = 'N'
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
   set nocount on
   set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
	     , @v_action smallint
		 , @v_ts_type_master_id numeric(38,0)
		 , @v_overrun decimal
		 , @v_run decimal
	 
   declare @t_run table (run decimal, ts_type_master_id numeric(38,0))

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

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction 

  
    

       -- надо добавлять
  if (@p_id is null)
    begin


	  exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @p_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, sys_comment, sys_user_created, sys_user_modified)
	    values
	(@p_car_id, @v_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

	  set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
  -- надо править существующий

	begin
	
    select @v_run = case when @p_edit_state = 'E'
						 then @p_run
						 else run + @p_run 
					end from dbo.CCAR_CONDITION
	where id = @p_id

    exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @v_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = 
							case when @p_sent_to = 'N'
								 then @v_ts_type_master_id
								 when @p_sent_to = 'Y'
								 then @p_ts_type_master_id
							end
		,employee_id = @p_employee_id
		-- Добавляем именно нарастающим итогом
		-- Но если укажем @p_edit_state, то можем переписать
		,run = @v_run
		,last_run = @p_last_run
		,last_ts_type_master_id = @p_last_ts_type_master_id
		,speedometer_start_indctn = @p_speedometer_start_indctn
		,speedometer_end_indctn = @p_speedometer_end_indctn
		,fuel_start_left = @p_fuel_start_left
		,fuel_end_left = @p_fuel_end_left
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		output inserted.run, inserted.ts_type_master_id into @t_run 		
		where ID = @p_id
		

		set @v_action = dbo.usfConst('ACTION_UPDATE')

		select @p_run = run, @v_ts_type_master_id = ts_type_master_id from @t_run

	end



	  exec @v_Error = 
        dbo.uspVHIS_CONDITION_SaveById
        	 @p_action						= @v_action
			,@p_car_id						= @p_car_id
    		,@p_ts_type_master_id			= @v_ts_type_master_id
			,@p_last_ts_type_master_id		= @p_last_ts_type_master_id
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= @p_last_run
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn
			,@p_edit_state					= @p_edit_state 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_sent_to						= @p_sent_to
			,@p_overrun						= @v_overrun
			,@p_sys_comment					= @p_sys_comment  
  			,@p_sys_user					= @p_sys_user

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 



	
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
