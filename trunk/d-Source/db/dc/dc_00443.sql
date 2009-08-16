
:r ./../_define.sql

:setvar dc_number 00443
:setvar dc_description "car exit rep fix#4"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   06.04.2009 VLavrentiev   car exit rep fix#4
*******************************************************************************/ 
use [$(db_name)]
GO


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _drop_chis_all_objects.sql                         ='
PRINT '==============================================================================='
PRINT ' '
go

:r _drop_chis_all_objects.sql



PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






create PROCEDURE [dbo].[uspVREP_CAR_EXIT_SelectCountByDate_to12]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о выходе автомобилей за день(количество) (до 12 часов)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date			datetime
)
AS
SET NOCOUNT ON

 if (@p_date is null)
  set @p_date = getdate();
   
with exit_stmt (date_exit, id, message_code, state_number) as
(select c.date_created as date_exit, id, message_code, state_number
		   from dbo.crep_serial_log as c
		where c.message_code like ('%вышел%')
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date))
		  and c.date_created > dbo.usfUtils_TimeToZero(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date)))
select
  count(*)  as kol
 from
(select 
	 dbo.usfUtils_TimeToZero(b.date_created) as date_created 
	,b.state_number
	,b.fio
	--,j.time
	,isnull((select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc)
	,(select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
     and time > j2.date_exit
	 order by time asc)) as date_planned
	,j2.date_exit
	from dbo.crep_serial_log as b
	outer apply
		(select top(1) date_exit
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc) as j2
	where b.id = (select top(1) id 
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc)) as a
outer apply
	(select top(1) c.date_created as date_return
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	  and c.date_created < (select top(1) date_exit 
							from exit_next_stmt
							where state_number = a.state_number
							order by date_exit asc)
	order by c.date_created desc) as j3
where 
 --Статистика только до 12 часов
   a.date_exit <= (dateadd("Hh", 12, @p_date))


	RETURN

go

GRANT EXECUTE ON [dbo].[uspVREP_CAR_EXIT_SelectCountByDate_to12] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_EXIT_SelectCountByDate_to12] TO [$(db_app_user)]
GO




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о выходе автомобилей за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date			datetime
)
AS
SET NOCOUNT ON

 if (@p_date is null)
  set @p_date = getdate();
   
with exit_stmt (date_exit, id, message_code, state_number) as
(select c.date_created as date_exit, id, message_code, state_number
		   from dbo.crep_serial_log as c
		where c.message_code like ('%вышел%')
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date))
		  and c.date_created > dbo.usfUtils_TimeToZero(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date)))
select
TOP(100) PERCENT 
 convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created 
,a.state_number
,a.fio
,convert(varchar(10),a.date_planned, 104) + ' ' + convert(varchar(5),a.date_planned, 108) as date_planned 
,convert(varchar(10),a.date_exit, 104) + ' ' + convert(varchar(5),a.date_exit, 108) as date_exit
,isnull(convert(varchar(10),j3.date_return, 104) + ' ' + convert(varchar(5),j3.date_return, 108)
	   ,(select top(1) convert(varchar(10),c.date_created, 104) + ' ' + convert(varchar(5),c.date_created, 108)
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	order by c.date_created desc)) as date_return
,convert(varchar(10),@p_date, 104) + ' ' + convert(varchar(5),@p_date, 108) as date
,case when (a.date_planned is not null
	   and a.date_exit is not null
		--and a.date_planned < a.date_exit
		)
	  then --case when datediff("mi", a.date_planned, a.date_exit) > 480
				--then null
				--else 
				datediff("mi", a.date_planned, a.date_exit)
			--end
	  else null
  end as wait_time
 from
(select 
	 dbo.usfUtils_TimeToZero(b.date_created) as date_created 
	,b.state_number
	,b.fio
	--,j.time
	,isnull((select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc)
	,(select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
     and time > j2.date_exit
	 order by time asc)) as date_planned
	,j2.date_exit
	from dbo.crep_serial_log as b
	outer apply
		(select top(1) date_exit
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc) as j2
	where b.id = (select top(1) id 
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc)) as a
outer apply
	(select top(1) c.date_created as date_return
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	  and c.date_created < (select top(1) date_exit 
							from exit_next_stmt
							where state_number = a.state_number
							order by date_exit asc)
	order by c.date_created desc) as j3
--where a.date_planned is not null
order by a.date_created desc
,a.date_planned asc 
,a.state_number asc
,a.date_exit asc


	RETURN


go




alter PROCEDURE [dbo].[uspVREP_CAR_EXIT_SelectCountByDate_to12]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о выходе автомобилей за день(количество) (до 12 часов)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date			datetime
)
AS
SET NOCOUNT ON

 if (@p_date is null)
  set @p_date = getdate();
   
with exit_stmt (date_exit, id, message_code, state_number) as
(select c.date_created as date_exit, id, message_code, state_number
		   from dbo.crep_serial_log as c
		where c.message_code like ('%вышел%')
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date))
		  and c.date_created > dbo.usfUtils_TimeToZero(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date)))
select
  count(*)  as kol
 from
(select 
	 dbo.usfUtils_TimeToZero(b.date_created) as date_created 
	,b.state_number
	,b.fio
	--,j.time
	,isnull((select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc)
	,(select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
     and time > j2.date_exit
	 order by time asc)) as date_planned
	,j2.date_exit
	from dbo.crep_serial_log as b
	outer apply
		(select top(1) date_exit
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc) as j2
	where b.id = (select top(1) id 
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc)) as a
outer apply
	(select top(1) c.date_created as date_return
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	  and c.date_created < (select top(1) date_exit 
							from exit_next_stmt
							where state_number = a.state_number
							order by date_exit asc)
	order by c.date_created desc) as j3
where 
 --Статистика только до 12 часов
   a.date_exit <= (dateadd("Hh", 12, @p_date))


	RETURN

go





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


