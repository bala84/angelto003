:r ./../_define.sql

:setvar dc_number 00143                  
:setvar dc_description "check ts type periodicity fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.03.2008 VLavrentiev  check ts type periodicity fixed
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
		   and b.run  > a.run - a.periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)
order by a.delta asc, a.periodicity desc


END
GO


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
		  ,g.id	as car_mark_id
		  ,h.id as car_model_id
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
		  ,isnull(a.overrun, 0) as overrun
		  ,a.in_tolerance
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
		  ,last_ts_type_master_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,ts_type_sname
	FROM dbo.utfVCAR_LAST_TS_TYPE(@p_car_id)
	order by run desc, last_ts_type_master_id asc 

	RETURN
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

