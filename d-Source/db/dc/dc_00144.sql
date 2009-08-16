:r ./../_define.sql

:setvar dc_number 00144                  
:setvar dc_description "check last ts type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    29.03.2008 VLavrentiev  check last ts type fixed
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
	FROM dbo.utfVCAR_LAST_TS_TYPE(@p_car_id)
	order by run desc, last_ts_type_master_id asc 

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об автомобиле
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						 numeric(38,0) = null out
    ,@p_state_number			 varchar(20)
	,@p_last_speedometer_idctn	 decimal(18,9)		 = 0.0
    ,@p_speedometer_idctn		 decimal(18,9)      = 0.0
    ,@p_car_type_id				 numeric(38,0)
	,@p_car_state_id			 numeric(38,0)   = null
	,@p_car_mark_id				 numeric(38,0)
	,@p_car_model_id			 numeric(38,0)
	,@p_begin_mntnc_date		 datetime		= null
	,@p_fuel_type_id			 numeric(38,0)
	,@p_car_kind_id				 numeric(38,0)
	,@p_last_begin_run			 decimal(18,9)			= 0.0
	,@p_begin_run				 decimal(18,9)			= 0.0
	,@p_run						 decimal(18,9)		= 0.0
	,@p_speedometer_start_indctn decimal(18,9)			= 0.0
	,@p_speedometer_end_indctn	 decimal(18,9)			= 0.0
	,@p_fuel_start_left			 decimal(18,9)			= 0.0
	,@p_fuel_end_left			 decimal(18,9)			= 0.0
	,@p_condition_id			 numeric(38,0)	= null out
	,@p_employee_id				 numeric(38,0)	= null
	,@p_sys_comment				 varchar(2000)	= '-'
    ,@p_sys_user				 varchar(30)		= null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_last_ts_verified tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_begin_run is null)
	set @p_begin_run = 0.0

	 if (@p_speedometer_idctn is null)
	set @p_speedometer_idctn = 0.0

	 if (@p_last_begin_run is null)
	set @p_last_begin_run = 0.0
	 
	 if (@p_run is null)
	set @p_run = 0.0

	 if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0
     
         if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0
	 
	 if (@p_last_speedometer_idctn is null)
	set @p_last_speedometer_idctn = 0.0

     
     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction 



       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date
			,fuel_type_id, car_kind_id, begin_run, last_ts_verified
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, 0
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end

		update dbo.CCAR_CAR
		   set last_ts_verified = @v_last_ts_verified
		 where id = @p_id
    end   
       
	    
 else
	begin

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end 
  -- надо править существующий
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		,car_state_id = @p_car_state_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
		,last_ts_verified = @v_last_ts_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end

   --если у нас еще нет сосотояния автомобиля мы должны выставить правильное конечное показание спидометра равное начальному показанию спидометра
  
--   if (@p_condition_id is null)
--	begin


	
		exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id							= @p_condition_id
    		,@p_car_id						= @p_id
    		,@p_ts_type_master_id			= null
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_edit_state					= 'E'   
    		,@p_sys_comment					= @p_sys_comment  
  		,@p_sys_user 						= @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 
--	end

  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return 

end
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
--Если соблюдается условие отсутствия закрытых ТО, вернем 0
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
	and c.sent_to = 'Y'
	and c.car_id = @p_car_id)) 

	set @p_last_ts_verified = 0

else

	set @p_last_ts_verified = 1

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
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity numeric(38,0)

if (@p_in_tolerance is null)
	set @p_in_tolerance = 0
	
select TOP(1) @p_ts_type_master_id = id 
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
		 and c.ts_type_master_id = a.id
		 and exists
			(
			select 1 from dbo.chis_condition as b
			where c.car_id = b.car_id
			  and b.date_created > c.date_created
			  and b.sent_to = 'Y'		
			  and b.last_ts_type_master_id = c.ts_type_master_id
			  and b.run < (c.run + a.periodicity))
		 order by date_created desc)
		,@p_run -(floor(@p_run/a.periodicity)*a.periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run > a.periodicity
and
EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id
		)) as a
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
order by a.delta asc, a.periodicity desc

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@p_ts_type_master_id is null) 


select top(1) @p_ts_type_master_id = id
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
		 and c.ts_type_master_id = a.id
		 and exists
			(
			select 1 from dbo.chis_condition as b
			where c.car_id = b.car_id
			  and b.date_created > c.date_created
			  and b.sent_to = 'Y'		
			  and b.last_ts_type_master_id = c.ts_type_master_id
			  and b.run < (c.run + a.periodicity))
		 order by date_created desc)
		,(ceiling(@p_run/a.periodicity)*a.periodicity) - @p_run) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run > 0
and
EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id
		)) as a
where 
not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run --((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run + a.periodicity
		   and b.last_ts_type_master_id = a.id
	)
order by a.delta asc, a.periodicity desc


END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об автомобиле
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						 numeric(38,0) = null out
    ,@p_state_number			 varchar(20)
	,@p_last_speedometer_idctn	 decimal(18,9)		 = 0.0
    ,@p_speedometer_idctn		 decimal(18,9)      = 0.0
    ,@p_car_type_id				 numeric(38,0)
	,@p_car_state_id			 numeric(38,0)   = null
	,@p_car_mark_id				 numeric(38,0)
	,@p_car_model_id			 numeric(38,0)
	,@p_begin_mntnc_date		 datetime		= null
	,@p_fuel_type_id			 numeric(38,0)
	,@p_car_kind_id				 numeric(38,0)
	,@p_last_begin_run			 decimal(18,9)			= 0.0
	,@p_begin_run				 decimal(18,9)			= 0.0
	,@p_run						 decimal(18,9)		= 0.0
	,@p_speedometer_start_indctn decimal(18,9)			= 0.0
	,@p_speedometer_end_indctn	 decimal(18,9)			= 0.0
	,@p_fuel_start_left			 decimal(18,9)			= 0.0
	,@p_fuel_end_left			 decimal(18,9)			= 0.0
	,@p_condition_id			 numeric(38,0)	= null out
	,@p_employee_id				 numeric(38,0)	= null
	,@p_sys_comment				 varchar(2000)	= '-'
    ,@p_sys_user				 varchar(30)		= null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_last_ts_verified tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_begin_run is null)
	set @p_begin_run = 0.0

	 if (@p_speedometer_idctn is null)
	set @p_speedometer_idctn = 0.0

	 if (@p_last_begin_run is null)
	set @p_last_begin_run = 0.0
	 
	 if (@p_run is null)
	set @p_run = 0.0

	 if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0
     
         if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0
	 
	 if (@p_last_speedometer_idctn is null)
	set @p_last_speedometer_idctn = 0.0

     
     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction 



       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date
			,fuel_type_id, car_kind_id, begin_run, last_ts_verified
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, 0
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end

		update dbo.CCAR_CAR
		   set last_ts_verified = @v_last_ts_verified
		 where id = @p_id
    end   
       
	    
 else
	begin

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end 
  -- надо править существующий
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		,car_state_id = @p_car_state_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
		,last_ts_verified = @v_last_ts_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end

   --если у нас еще нет сосотояния автомобиля мы должны выставить правильное конечное показание спидометра равное начальному показанию спидометра
   --проверим правильное состояние
   if (@p_condition_id is null)
	select @p_condition_id = id 
	from dbo.CCAR_CONDITION 
	where car_id = @p_id


	
		exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id							= @p_condition_id
    		,@p_car_id						= @p_id
    		,@p_ts_type_master_id			= null
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_edit_state					= 'E'   
    		,@p_sys_comment					= @p_sys_comment  
  		,@p_sys_user 						= @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 
--	end

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

