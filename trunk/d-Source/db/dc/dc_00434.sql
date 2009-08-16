:r ./../_define.sql

:setvar dc_number 00434
:setvar dc_description "rep driver plan fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   29.03.2009 VLavrentiev   rep driver plan fixed
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


alter table dbo.CREP_DRIVER_PLAN_DETAIL
alter column car_id numeric(38,0) null
go

alter table dbo.CREP_DRIVER_PLAN_DETAIL
add rownum int 
go

create index i_CREP_DRIVER_PLAN_DETAIL_rownum on dbo.CREP_DRIVER_PLAN_DETAIL(rownum)
on $(fg_idx_name)
go

alter table dbo.CREP_DRIVER_PLAN_DETAIL
add organization_id numeric(38,0)
go

create index i_CREP_DRIVER_PLAN_DETAIL_organization_id on dbo.CREP_DRIVER_PLAN_DETAIL(organization_id)
on $(fg_idx_name)
go


alter table dbo.CREP_DRIVER_PLAN_DETAIL
add car_kind_id numeric(38,0)
go

create index i_CREP_DRIVER_PLAN_DETAIL_car_kind_id on dbo.CREP_DRIVER_PLAN_DETAIL(car_kind_id)
on $(fg_idx_name)
go


alter table dbo.CREP_DRIVER_PLAN_DETAIL
add organization_sname varchar(100)
go


alter table dbo.CREP_DRIVER_PLAN_DETAIL
add car_kind_sname varchar(30)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [TAIUD_CDRV_DRIVER_PLAN_DETAIL]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для регистрации созданного плана выхода на линию
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CDRV_DRIVER_PLAN_DETAIL]
after insert, update, delete
as
begin
  
  
  -- Если время позже шести - проставим статус плана - завершен
  if (datepart("Hh", getdate()) > 6) 
  begin
    update dbo.cdrv_driver_plan_detail
	   set is_completed = 1
	  where is_completed = 0
		and date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))
  end
  -- Если плана нет в отчетных планах добавим отчет
  if (not exists (select 1 from dbo.crep_driver_plan_detail where date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))))
  begin
	insert into dbo.crep_driver_plan_detail( car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
											,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname)
	select car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
		  ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname
	  from dbo.cdrv_driver_plan_detail
	  where date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))
  end	 


end
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о детальном плане выхода на линию по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


/*if (not exists (select 1 from dbo.cdrv_driver_plan_detail as a
				 where date = @p_date 
				   and exists
						(select 1 from dbo.ccar_car as b
							where a.car_id = b.id
							  and b.car_kind_id = @p_car_kind_id
							  and b.organization_id = @p_organization_id)))
select null as id
	 , null as sys_status
	 , null as sys_comment
	 , null as sys_date_modified
	 , null as sys_date_created
	 , null as sys_user_modified
	 , null as sys_user_created
	 , b.car_id
	 , c.state_number
	 , @p_date as date
	 , null as time
	 , b.employee_id 
	 , e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as fio_driver
	 , d.driver_license
	 , null as shift_number
	 , null as comments
	 , null as mech_employee_id
	 , 0 as is_completed
	  ,f.id as organization_id
	  ,f.name as organization_sname
	  ,g.id as car_kind_id
	  ,g.short_name as car_kind_sname
	  ,null as dt_time
	  ,null as is_night_work
 from
(select car_id, case when schema_schedule = 1 then employee1_id
					when schema_schedule = 2 then employee2_id
					when schema_schedule = 3 then employee3_id
					when schema_schedule = 4 then employee4_id
				end as employee_id
from
(select b.car_id, employee1_id, employee2_id, employee3_id, employee4_id
				 ,case  when Day(@p_date) = 1
		         then a.day_1
				 when Day(@p_date) = 2
		         then a.day_2
				 when Day(@p_date) = 3
		         then a.day_3
				 when Day(@p_date) = 4
		         then a.day_4
				 when Day(@p_date) = 5
		         then a.day_5
				 when Day(@p_date) = 6
		         then a.day_6
				 when Day(@p_date) = 7
		         then a.day_7
				 when Day(@p_date) = 8
		         then a.day_9
				 when Day(@p_date) = 10
		         then a.day_10
				 when Day(@p_date) = 11
		         then a.day_11
				 when Day(@p_date) = 12
		         then a.day_12
				 when Day(@p_date) = 13
		         then a.day_13
				 when Day(@p_date) = 14
		         then a.day_14
				 when Day(@p_date) = 15
		         then a.day_15
				 when Day(@p_date) = 16
		         then a.day_16
				 when Day(@p_date) = 17
		         then a.day_17
			     when Day(@p_date) = 18
		         then a.day_18
				 when Day(@p_date) = 19
		         then a.day_19
				 when Day(@p_date) = 20
		         then a.day_20
				 when Day(@p_date) = 21
		         then a.day_21
				 when Day(@p_date) = 22
		         then a.day_22
				 when Day(@p_date) = 23
		         then a.day_23
				 when Day(@p_date) = 24
		         then a.day_24
				 when Day(@p_date) = 25
		         then a.day_25
				 when Day(@p_date) = 26
		         then a.day_26
				 when Day(@p_date) = 27
		         then a.day_27
				 when Day(@p_date) = 28
		         then a.day_28
				 when Day(@p_date) = 29
		         then a.day_29
				 when Day(@p_date) = 30
		         then a.day_30
				 when Day(@p_date) = 31
		         then a.day_31
			 end as schema_schedule
from dbo.cdrv_month_plan as a
		join dbo.cdrv_driver_plan as b
		  on  a.month = dbo.usfUtils_TimeToZero(b.time)
where a.month = dbo.usfUtils_DayTo01(@p_date)) as a) as b
join dbo.ccar_car as c
  on b.car_id = c.id
join dbo.cprt_employee as d
  on b.employee_id = d.id
join dbo.cprt_person as e
  on d.person_id = e.id
join dbo.cprt_organization as f
  on f.id = c.organization_id
	join dbo.ccar_car_kind as g
	  on c.car_kind_id = g.id
where c.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and f.sys_status = 1
  and g.sys_status = 1
  and c.car_kind_id = @p_car_kind_id
  and c.organization_id = @p_organization_id

else*/
if (exists
		(select 1 
		  where dbo.usfUtils_TimeToZero(getdate()) > @p_date))

select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,case when datepart("Hh", a.time) < 10
			then '0' + convert(varchar(1), datepart("Hh", a.time))
			else convert(varchar(2), datepart("Hh", a.time))
		end + ':' +
			case when datepart("Minute", a.time) < 10
			then '0' + convert(varchar(1), datepart("Minute", a.time))
			else convert(varchar(2), datepart("Minute", a.time))
			end as time
	  ,a.employee_id
	  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as fio_driver
	  ,c.driver_license
	  ,a.shift_number
	  ,a.comments
	  ,a.mech_employee_id
	  ,a.is_completed
	  ,a.id as organization_id
	  ,a.organization_sname
	  ,a.id as car_kind_id
	  ,a.car_kind_sname
	  ,a.time as dt_time
	  ,case when datepart("Hh", a.time )< dbo.usfConst('Начало ночной смены')
		then 0
	    else 1
	    end as is_night_work
	  ,a.rownum
  from dbo.CREP_DRIVER_PLAN_DETAIL as a
	left outer join dbo.ccar_car as b
	  on a.car_id = b.id
	left outer join dbo.cprt_employee as c
	  on a.employee_id = c.id
	left outer join dbo.cprt_person as d
	  on c.person_id = d.id
  where isnull(b.sys_status, 1) = 1
	and isnull(c.sys_status, 1) = 1
    and isnull(d.sys_status, 1) = 1
    and a.date = @p_date
	and a.car_kind_id = @p_car_kind_id
	and a.organization_id = @p_organization_id
   order by a.rownum, a.time

else

select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,case when datepart("Hh", a.time) < 10
			then '0' + convert(varchar(1), datepart("Hh", a.time))
			else convert(varchar(2), datepart("Hh", a.time))
		end + ':' +
			case when datepart("Minute", a.time) < 10
			then '0' + convert(varchar(1), datepart("Minute", a.time))
			else convert(varchar(2), datepart("Minute", a.time))
			end as time
	  ,a.employee_id
	  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as fio_driver
	  ,c.driver_license
	  ,a.shift_number
	  ,a.comments
	  ,a.mech_employee_id
	  ,a.is_completed
	  ,a.id as organization_id
	  ,a.organization_sname
	  ,a.id as car_kind_id
	  ,a.car_kind_sname
	  ,a.time as dt_time
	  ,case when datepart("Hh", a.time )< dbo.usfConst('Начало ночной смены')
		then 0
	    else 1
	    end as is_night_work
	  ,a.rownum
  from dbo.CDRV_DRIVER_PLAN_DETAIL as a
	left outer join dbo.ccar_car as b
	  on a.car_id = b.id
	left outer join dbo.cprt_employee as c
	  on a.employee_id = c.id
	left outer join dbo.cprt_person as d
	  on c.person_id = d.id
  where isnull(b.sys_status, 1) = 1
	and isnull(c.sys_status, 1) = 1
    and isnull(d.sys_status, 1) = 1
    and a.date = @p_date
	and a.car_kind_id = @p_car_kind_id
	and a.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN

go

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
,convert(varchar(10),j3.date_return, 104) + ' ' + convert(varchar(5),j3.date_return, 108) as date_return
,convert(varchar(10),@p_date, 104) + ' ' + convert(varchar(5),@p_date, 108) as date
 from
(select 
	 dbo.usfUtils_TimeToZero(b.date_created) as date_created 
	,b.state_number
	,b.fio
	--,j.time
	,(select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number) as date_planned
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
order by a.date_created desc 
,a.state_number asc
,a.date_exit


	RETURN
go

ALTER trigger [TAIUD_CDRV_DRIVER_PLAN_DETAIL]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для регистрации созданного плана выхода на линию
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CDRV_DRIVER_PLAN_DETAIL]
after insert, update, delete
as
begin
  
  
  -- Если время позже шести - проставим статус плана - завершен
  if (datepart("Hh", getdate()) > 6) 
  begin
    update dbo.cdrv_driver_plan_detail
	   set is_completed = 1
	  where is_completed = 0
		and date = dbo.usfUtils_TimeToZero(getdate())
  end
  -- Если плана нет в отчетных планах добавим отчет
  if (not exists (select 1 from dbo.crep_driver_plan_detail where date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))))
  begin
	insert into dbo.crep_driver_plan_detail( car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
											,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname)
	select car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
		  ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname
	  from dbo.cdrv_driver_plan_detail
	  where date = dbo.usfUtils_TimeToZero(getdate())
  end	 


end
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER trigger [TAIUD_CDRV_DRIVER_PLAN_DETAIL]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для регистрации созданного плана выхода на линию
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CDRV_DRIVER_PLAN_DETAIL]
after insert, update, delete
as
begin
  
  
  -- Если время позже шести - проставим статус плана - завершен
  if (datepart("Hh", getdate()) > 6) 
  begin
    update dbo.cdrv_driver_plan_detail
	   set is_completed = 1
	  where is_completed = 0
		and date = dbo.usfUtils_TimeToZero(getdate())
  end
  -- Если плана нет в отчетных планах добавим отчет
  if (not exists (select 1 from dbo.crep_driver_plan_detail where date = dbo.usfUtils_TimeToZero(getdate())))
  begin
	insert into dbo.crep_driver_plan_detail( car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
											,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname)
	select car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
		  ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname
	  from dbo.cdrv_driver_plan_detail
	  where date = dbo.usfUtils_TimeToZero(getdate())
  end	 


end
go


CREATE UNIQUE NONCLUSTERED INDEX [u_car_noexit_reason_detail_car_id_time] ON [dbo].[CCAR_NOEXIT_REASON_DETAIL] 
(
	[car_id] ASC,
	[time] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [$(fg_idx_name)]
go

drop index [dbo].[CDRV_DRIVER_PLAN_DETAIL].u_drv_driver_plan_detail_rownum_date_org_id_car_kind_id
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



