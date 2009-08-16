:r ./../_define.sql

:setvar dc_number 00127                  
:setvar dc_description "check to fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    21.03.2008 VLavrentiev  check to fixed
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
 @p_run						decimal(18,13)
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal(18,13) out
,@p_ts_type_master_id		decimal(18,13) out
,@p_last_ts_type_master_id	numeric (38,0) = null	
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity numeric(38,0)
	
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
		,ceiling(@p_run/a.periodicity)*a.periodicity - @p_run) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run > 0
and
EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id
		)) as a
where delta <= tolerance
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - (a.periodicity - a.tolerance)--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)
order by delta asc, periodicity desc




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
