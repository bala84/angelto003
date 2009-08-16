:r ./../_define.sql

:setvar dc_number 00206
:setvar dc_description "check ts type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.04.2008 VLavrentiev  check ts type fixed
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

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_Check_ts_type] 
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
 @p_run						decimal(18,9)
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal(18,9) out
,@p_ts_type_master_id		decimal(18,9) out
,@p_in_tolerance			bit  = 0 out
,@p_last_ts_type_master_id	numeric (38,0) = null	
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity			numeric(38,0)
		,@v_temp_ts_type_master_id   numeric(38,0)
	
if (@p_in_tolerance is null)
	set @p_in_tolerance = 0
--Найдем следующий ТО, по списку очередности ТО
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
and a.ordered > (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.ts_type_master_id = @p_ts_type_master_id)
and a.ordered > (select a3.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					where b.id = a3.ts_type_route_master_id
					  and a3.ts_type_master_id = @p_last_ts_type_master_id)
order by a.ordered asc
--Найдем первый элемент, если следующего нет
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
order by a.ordered asc
--Если ничего нет в очередности, то не считаем
if (@v_temp_ts_type_master_id is null)
	begin
	  set @p_ts_type_master_id = null
	  return 0
	end
--Попробуем найти ТО с перепробегом 	
select        @p_ts_type_master_id = id 
			 ,@p_overrun =  delta
from
(select 
 a.id
,@p_run as run
,a.periodicity as periodicity
,isnull((
		select top(1) @p_run - (c.run + a.periodicity)
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'
		 --and c.run < (c.run + a.periodicity)		 
		 order by date_created desc)
		,@p_run -(floor(@p_run/a.periodicity)*a.periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where a.id = @v_temp_ts_type_master_id
  and @p_run > a.periodicity) as a
where a.delta > 0
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - a.periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@p_ts_type_master_id is null) 


select       @p_ts_type_master_id = id
			 ,@p_in_tolerance = case when delta <= tolerance
									 then 1
									 else 0
								end 
			 ,@p_overrun = - delta
from
(select id, @p_run as run, a.periodicity as periodicity, a.tolerance
,isnull((
		select top(1) (c.run + a.periodicity) - @p_run   
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'		 
		 order by date_created desc)
		,(ceiling(case @p_run 
						when 0
						then 1
						else @p_run
				  end/a.periodicity)*a.periodicity) - @p_run) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run >= 0 and a.id = @v_temp_ts_type_master_id) as a
where 
not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run 
		   and b.run <= a.run + a.periodicity
		   and b.last_ts_type_master_id = a.id
	)

END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_Check_ts_type] 
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
 @p_run						decimal(18,9)
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal(18,9) out
,@p_ts_type_master_id		decimal(18,9) out
,@p_in_tolerance			bit  = 0 out
,@p_last_ts_type_master_id	numeric (38,0) = null	
,@p_sent_to					char(1)
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity					numeric(38,0)
		,@v_temp_ts_type_master_id		numeric(38,0)
		,@v_prev_ts_type_master_id		 numeric(38,0)
		,@v_prev_last_ts_type_master_id	 numeric(38,0)
	
if (@p_in_tolerance is null)
	set @p_in_tolerance = 0


--Найдем следующий ТО, по списку очередности ТО
--в случае отправки на ТО
if (@p_sent_to = 'Y')
begin

--Найдем последние данные по очередности ТО
select TOP(1) @v_prev_ts_type_master_id = ts_type_master_id
			 ,@v_prev_last_ts_type_master_id = last_ts_type_master_id
from dbo.CHIS_CONDITION
where car_id = @p_car_id
  and ts_type_master_id is not null
  and last_ts_type_master_id is not null
order by date_created desc

select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
and a.ordered > (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.ts_type_master_id = @v_prev_ts_type_master_id)
and a.ordered > (select a3.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					where b.id = a3.ts_type_route_master_id
					  and a3.ts_type_master_id = @v_prev_last_ts_type_master_id)
order by a.ordered asc
--Найдем первый элемент, если следующего нет
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
order by a.ordered asc
--Если ничего нет в очередности, то не считаем
if (@v_temp_ts_type_master_id is null)
	begin
	  set @p_ts_type_master_id = null
	  return 0
	end
end
else
 select TOP(1) @v_temp_ts_type_master_id = ts_type_master_id
   from dbo.CHIS_CONDITION
  where car_id = @p_car_id
    and ts_type_master_id is not null
  order by date_created desc


--Попробуем найти ТО с перепробегом 	
select        @p_ts_type_master_id = id 
			 ,@p_overrun =  delta
from
(select 
 a.id
,@p_run as run
,a.periodicity as periodicity
,isnull((
		select top(1) @p_run - (c.run + a.periodicity)
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'
		 --and c.run < (c.run + a.periodicity)		 
		 order by date_created desc)
		,@p_run -(floor(@p_run/a.periodicity)*a.periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where a.id = @v_temp_ts_type_master_id
  and @p_run > a.periodicity) as a
where a.delta > 0
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - a.periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@p_ts_type_master_id is null) 


select       @p_ts_type_master_id = id
			 ,@p_in_tolerance = case when delta <= tolerance
									 then 1
									 else 0
								end 
			 ,@p_overrun = - delta
from
(select id, @p_run as run, a.periodicity as periodicity, a.tolerance
,isnull
(
(
		select top(1) (c.run + a.periodicity) - @p_run   
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'		 
		 order by date_created desc)
		,(ceiling(case @p_run 
						when 0
						then 1
						else @p_run
				  end/a.periodicity)*a.periodicity) - @p_run
			) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run >= 0 and a.id = @v_temp_ts_type_master_id) as a
where 
not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run 
		   and b.run <= a.run + a.periodicity
		   and b.last_ts_type_master_id = a.id
	)

END
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
    ,@p_run 			    		decimal(18,9)
    ,@p_last_run					decimal(18,9)	      = 0.0
    ,@p_speedometer_start_indctn	decimal(18,9)	      = 0.0
    ,@p_speedometer_end_indctn		decimal(18,9)	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal(18,9)	      = 0.0
	,@p_fuel_end_left               decimal(18,9)	      = 0.0
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
		 , @v_overrun decimal(18,9)
		 , @v_run decimal(18,9)
		 , @v_in_tolerance bit
	 
   declare @t_run table (run decimal(18,9), ts_type_master_id numeric(38,0))

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
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, overrun, in_tolerance, sys_comment, sys_user_created, sys_user_modified)
	    values
	(@p_car_id, @v_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @v_overrun, @v_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user)
       
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
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = @v_ts_type_master_id
							/*case when @p_sent_to = 'N'
								 then @v_ts_type_master_id
								 when @p_sent_to = 'Y'
								 then @p_ts_type_master_id
							end*/
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
		,overrun = @v_overrun
		,in_tolerance = @v_in_tolerance
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
			,@p_in_tolerance				= @v_in_tolerance
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
	/*select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, a.id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
    from dbo.CCAR_TS_TYPE_MASTER as a
	where a.id = @p_last_ts_type_master_id and @p_sent_to = 'Y'
    union*/
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, b.child_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
	from dbo.CCAR_TS_TYPE_RELATION as b
	where b.parent_id = @p_last_ts_type_master_id and @p_sent_to = 'Y'
	union
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
       
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

    
  return 

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_Check_ts_type] 
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
 @p_run						decimal(18,9)
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal(18,9) out
,@p_ts_type_master_id		decimal(18,9) out
,@p_in_tolerance			bit  = 0 out
,@p_last_ts_type_master_id	numeric (38,0) = null	
,@p_sent_to					char(1)
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity					numeric(38,0)
		,@v_temp_ts_type_master_id		numeric(38,0)
		,@v_prev_ts_type_master_id		 numeric(38,0)
		,@v_prev_last_ts_type_master_id	 numeric(38,0)
	
if (@p_in_tolerance is null)
	set @p_in_tolerance = 0


--Найдем следующий ТО, по списку очередности ТО
--в случае отправки на ТО
if (@p_sent_to = 'Y')
begin

--Найдем последние данные по очередности ТО
select TOP(1) @v_prev_ts_type_master_id = ts_type_master_id
			 ,@v_prev_last_ts_type_master_id = last_ts_type_master_id
from dbo.CHIS_CONDITION
where car_id = @p_car_id
  and ts_type_master_id is not null
  and last_ts_type_master_id is not null
order by date_created desc

select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
and a.ordered > (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.ts_type_master_id = @v_prev_ts_type_master_id)
and a.ordered > (select a3.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					where b.id = a3.ts_type_route_master_id
					  and a3.ts_type_master_id = @v_prev_last_ts_type_master_id)
order by a.ordered asc
--Найдем первый элемент, если следующего нет
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
order by a.ordered asc
--Если ничего нет в очередности, то не считаем
if (@v_temp_ts_type_master_id is null)
	begin
	  set @p_ts_type_master_id = null
	  return 0
	end
end
else
 begin
 select TOP(1) @v_temp_ts_type_master_id = ts_type_master_id
   from dbo.CHIS_CONDITION
  where car_id = @p_car_id
    and ts_type_master_id is not null
  order by date_created desc
 
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
order by a.ordered asc

 end


--Попробуем найти ТО с перепробегом 	
select        @p_ts_type_master_id = id 
			 ,@p_overrun =  delta
from
(select 
 a.id
,@p_run as run
,a.periodicity as periodicity
,isnull((
		select top(1) @p_run - (c.run + a.periodicity)
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'
		 --and c.run < (c.run + a.periodicity)		 
		 order by date_created desc)
		,@p_run -(floor(@p_run/a.periodicity)*a.periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where a.id = @v_temp_ts_type_master_id
  and @p_run > a.periodicity) as a
where a.delta > 0
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - a.periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@p_ts_type_master_id is null) 


select       @p_ts_type_master_id = id
			 ,@p_in_tolerance = case when delta <= tolerance
									 then 1
									 else 0
								end 
			 ,@p_overrun = - delta
from
(select id, @p_run as run, a.periodicity as periodicity, a.tolerance
,isnull
(
(
		select top(1) (c.run + a.periodicity) - @p_run   
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'		 
		 order by date_created desc)
		,(ceiling(case @p_run 
						when 0
						then 1
						else @p_run
				  end/a.periodicity)*a.periodicity) - @p_run
			) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run >= 0 and a.id = @v_temp_ts_type_master_id) as a
where 
not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run 
		   and b.run <= a.run + a.periodicity
		   and b.last_ts_type_master_id = a.id
	)

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

