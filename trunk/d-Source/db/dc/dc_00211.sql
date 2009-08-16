:r ./../_define.sql

:setvar dc_number 00211
:setvar dc_description "check_ts_type fixed: no records found"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    29.04.2008 VLavrentiev  check_ts_type fixed: no records found
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
,@p_ts_type_route_detail_id numeric (38,0) = null out
,@p_sent_to					char(1)
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity							numeric(8,0)
		,@v_temp_ts_type_master_id				numeric(38,0)
		,@v_prev_ts_type_route_detail_id		numeric(38,0)
		,@v_prev_last_ts_type_route_detail_id	numeric(38,0)
		,@v_ts_type_route_detail_id				numeric(38,0)
		,@v_last_ts_type_route_detail_id		numeric(38,0)
		,@v_is_overrun							bit
		,@v_min_periodicity						numeric(8,0)
	
if (@p_in_tolerance is null)
	set @p_in_tolerance = 0


select  @v_min_periodicity = min(periodicity) from dbo.CCAR_TS_TYPE_MASTER as a
where exists
(select 1 from dbo.ccar_car as b
	where b.id = @p_car_id
	  and b.car_model_id = a.car_model_id)
  and exists
(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
			join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
							on d.id = c.ts_type_route_master_id
  where a.id = c.ts_type_master_id
	and a.car_model_id = (select id from dbo.ccar_car_model as e
				where e.ts_type_route_master_id = d.id))


	select TOP(1) @v_prev_ts_type_route_detail_id = ts_type_route_detail_id
			     ,@v_prev_last_ts_type_route_detail_id = last_ts_type_route_detail_id	
	  from dbo.CHIS_CONDITION
	 where car_id = @p_car_id
	  and ts_type_master_id is not null
	  and last_ts_type_master_id is not null
	 order by date_created desc
 --Присвоим значения точек входа, в случае отправки на ТО
 --Поскольку при отправке мы еще не знаем предстоящее ТО
	set @v_ts_type_route_detail_id = @v_prev_ts_type_route_detail_id
	set @v_last_ts_type_route_detail_id = @v_prev_last_ts_type_route_detail_id
  --end
--else
 -- begin
   -- set @v_ts_type_master_id = @p_ts_type_master_id
	--set @v_last_ts_type_master_id = @p_last_ts_type_master_id
 -- end
   

--Найдем следующий ТО, по списку очередности ТО
--в случае отправки на ТО
select TOP(1)  @v_temp_ts_type_master_id = a.ts_type_master_id
			  ,@p_ts_type_route_detail_id = a.id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
and (
(a.ordered > (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.id = @v_ts_type_route_detail_id)
	 and @p_sent_to = 'Y')
     or
     (a.ordered = (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.id = @v_ts_type_route_detail_id)
	 and @p_sent_to = 'N'))
and ((a.ordered > (select a3.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					where b.id = a3.ts_type_route_master_id
					  and a3.id = @v_last_ts_type_route_detail_id)
	 and @p_sent_to = 'Y')
	or @p_sent_to = 'N')
order by a.ordered asc


--Найдем первый элемент, если следующего или необходимого нет
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
			 ,@p_ts_type_route_detail_id = a.id
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
	 -- return @p_ts_type_master_id
	end




--Попробуем найти ТО с перепробегом 	
select        @p_ts_type_master_id = id 
			 ,@p_overrun =  delta
			 ,@v_is_overrun = 1
from
(select 
 a.id
,@p_run as run
,@v_min_periodicity  as periodicity
,isnull((
		select top(1) @p_run - (c.run + @v_min_periodicity)
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 --and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'
		 --and c.run < (c.run + a.periodicity)		 
		 order by date_created desc)
		,@p_run -(floor(@p_run/@v_min_periodicity)*@v_min_periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where a.id = @v_temp_ts_type_master_id
  and @p_run > @v_min_periodicity) as a
where a.delta > 0
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - @v_min_periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   --and b.last_ts_type_master_id = a.id
	)

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@v_is_overrun is null) 


select       @p_ts_type_master_id = id
			 ,@p_in_tolerance = case when delta <= tolerance
									 then 1
									 else 0
								end 
			 ,@p_overrun = - delta
from
(select id, @p_run as run, @v_min_periodicity  as periodicity, a.tolerance
,isnull
(
(
		select top(1) (c.run + @v_min_periodicity) - @p_run   
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		-- and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'		 
		 order by date_created desc)
		,(ceiling(case @p_run 
						when 0
						then 1
						else @p_run
				  end/@v_min_periodicity)*@v_min_periodicity) - @p_run
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
		   and b.run <= a.run + @v_min_periodicity
		  -- and b.last_ts_type_master_id = a.id
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

