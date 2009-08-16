
:r ./../_define.sql

:setvar dc_number 00452
:setvar dc_description "count cars date_started fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   count cars date_started fix
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





ALTER PROCEDURE [dbo].[uspVREP_COUNT_CAR_SelectAll_Current]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о текущем состоянии автоколонны
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	    datetime 
,@p_end_date		datetime
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dbo.usfUtils_TimeToZero(getdate())

 if (@p_end_date is null)
  set @p_end_date = getdate()

--Почему-то в сервере прибавляет четыре часа??
  set @p_start_date = dateadd("Hh", -4, @p_start_date)
  set @p_end_date = dateadd("Hh", -4, @p_end_date)

--Строим только за сутки
if (exists(select 1 
			where datediff("Hh", @p_start_date, @p_end_date) > 24))
 return

select report_type
	  ,header
	  ,header_1
	  ,convert(decimal(18,2), kol) as kol 
	  ,convert(decimal(18,2),kol_1) as kol_1
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
from
(select 0 as report_type
	  ,'Количество автомобилей на балансе:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
where a.sys_status = 1
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select 1 as report_type
	  ,'Количество "боевых" автомобилей на балансе:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where a.sys_status = 1
  and e.is_comm_duty_car = 1
and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select 2 as report_type
	  ,'Количество "боевых" автомобилей в аренде:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where a.sys_status = 1
  and e.is_comm_duty_car = 1
and exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select report_type
	  ,header
	  ,header_1
	  ,count(*) as kol
	  ,kol_1
  from
(select 3 as report_type
	  ,'Количество "боевых" автомобилей, находящихся в длительном ремонте (более семи дней):' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as d
	on a.car_id = d.id
join dbo.ccar_car_kind as e
	on d.car_kind_id = e.id
left outer join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
where a.sys_status = 1
  and a.order_state not in (5,6)
  and isnull(c.sys_status, 1) = 1
  and isnull(c.date_started, a.date_created) <= @p_end_date - 7 
    and (c.date_ended > @p_end_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between @p_end_date - 7  
			  and @p_end_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol_1
union all
select report_type
	  ,header
	  ,header_1
	  ,count(*) as kol
	  ,kol_1
  from
(select 4 as report_type
	  ,'Количество "боевых" автомобилей, находящихся на текущем ремонте:' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as d
	on a.car_id = d.id
join dbo.ccar_car_kind as e
	on d.car_kind_id = e.id
left outer join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
where a.sys_status = 1
  and a.order_state not in (5,6)
  and isnull(c.sys_status, 1) = 1
  and isnull(c.date_started, a.date_created) >= ( @p_end_date - 7)
  and isnull(c.date_started, a.date_created) < @p_end_date
  and (c.date_ended > @p_end_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between isnull(c.date_started, a.date_created)
			  and @p_end_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol_1
union all
select 5 as report_type
	  ,'Количество невыходов "боевых" автомобилей:'
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
		from dbo.ccar_car as a
		join dbo.ccar_noexit_reason_detail as b
		  on a.id = b.car_id
		join dbo.ccar_car_noexit_reason_type as c
		  on b.car_noexit_reason_type_id = c.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
where b.time <= @p_end_date
  and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
group by c.short_name
union all
select 6 as report_type
	  ,'Количество возвратов "боевых" автомобилей:'
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
		from dbo.ccar_car as a
		join dbo.ccar_return_reason_detail as b
		  on a.id = b.car_id
		join dbo.ccar_car_return_reason_type as c
		  on b.car_return_reason_type_id = c.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
where b.time <= @p_end_date
  and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
group by c.short_name
union all
select 7 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'Эвакуаторы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.date_created >= @p_start_date
	and b.date_created < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 50
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select 8 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'Технички:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.date_created >= @p_start_date
	and b.date_created < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 51
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select 9 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'VIP-трансферы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.date_created >= @p_start_date
	and b.date_created < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 53
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select  10 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Эвакуаторы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 50
	and a.speedometer_end_indctn is null
    and a.date_created >= @p_start_date
	and a.date_created < @p_end_date
union all
select  11 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Технички:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 51
	and a.speedometer_end_indctn is null
    and a.date_created >= @p_start_date
	and a.date_created < @p_end_date
union all
select  12 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'VIP-трансферы:' as header_1
	  ,null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 53
	and a.speedometer_end_indctn is null
    and a.date_created >= @p_start_date
	and a.date_created < @p_end_date) as a
order by report_type, header_1

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_COUNT_CAR_SelectAll_Current]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о текущем состоянии автоколонны
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	    datetime 
,@p_end_date		datetime
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dbo.usfUtils_TimeToZero(getdate())

 if (@p_end_date is null)
  set @p_end_date = getdate()

--Почему-то в сервере прибавляет четыре часа??
  set @p_start_date = dateadd("Hh", -4, @p_start_date)
  set @p_end_date = dateadd("Hh", -4, @p_end_date)

--Строим только за сутки
if (exists(select 1 
			where datediff("Hh", @p_start_date, @p_end_date) > 24))
 return

select report_type
	  ,header
	  ,header_1
	  ,convert(decimal(18,2), kol) as kol 
	  ,convert(decimal(18,2),kol_1) as kol_1
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
from
(select 0 as report_type
	  ,'Количество автомобилей на балансе:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
where a.sys_status = 1
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select 1 as report_type
	  ,'Количество "боевых" автомобилей на балансе:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where a.sys_status = 1
  and e.is_comm_duty_car = 1
and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select 2 as report_type
	  ,'Количество "боевых" автомобилей в аренде:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where a.sys_status = 1
  and e.is_comm_duty_car = 1
and exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
union all
select report_type
	  ,header
	  ,header_1
	  ,count(*) as kol
	  ,kol_1
  from
(select 3 as report_type
	  ,'Количество "боевых" автомобилей, находящихся в длительном ремонте (более семи дней):' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as d
	on a.car_id = d.id
join dbo.ccar_car_kind as e
	on d.car_kind_id = e.id
left outer join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
where a.sys_status = 1
  and a.order_state not in (5,6)
  and isnull(c.sys_status, 1) = 1
  and isnull(c.date_started, a.date_created) <= @p_end_date - 7 
    and (c.date_ended > @p_end_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between @p_end_date - 7  
			  and @p_end_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol_1
union all
select report_type
	  ,header
	  ,header_1
	  ,count(*) as kol
	  ,kol_1
  from
(select 4 as report_type
	  ,'Количество "боевых" автомобилей, находящихся на текущем ремонте:' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as d
	on a.car_id = d.id
join dbo.ccar_car_kind as e
	on d.car_kind_id = e.id
left outer join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
where a.sys_status = 1
  and a.order_state not in (5,6)
  and isnull(c.sys_status, 1) = 1
  and isnull(c.date_started, a.date_created) >= ( @p_end_date - 7)
  and isnull(c.date_started, a.date_created) < @p_end_date
  and (c.date_ended > @p_end_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between isnull(c.date_started, a.date_created)
			  and @p_end_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol_1
union all
select 5 as report_type
	  ,'Количество невыходов "боевых" автомобилей:'
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
		from dbo.ccar_car as a
		join dbo.ccar_noexit_reason_detail as b
		  on a.id = b.car_id
		join dbo.ccar_car_noexit_reason_type as c
		  on b.car_noexit_reason_type_id = c.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
where b.time <= @p_end_date
  and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
group by c.short_name
union all
select 6 as report_type
	  ,'Количество возвратов "боевых" автомобилей:'
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
		from dbo.ccar_car as a
		join dbo.ccar_return_reason_detail as b
		  on a.id = b.car_id
		join dbo.ccar_car_return_reason_type as c
		  on b.car_return_reason_type_id = c.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
where b.time <= @p_end_date
  and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
group by c.short_name
union all
select 7 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'Эвакуаторы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.fact_start_duty >= @p_start_date
	and b.fact_start_duty < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 50
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select 8 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'Технички:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.fact_start_duty >= @p_start_date
	and b.fact_start_duty < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 51
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select 9 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'VIP-трансферы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and b.speedometer_end_indctn is null
    and b.fact_start_duty >= @p_start_date
	and b.fact_start_duty < @p_end_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 53
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_end_date
		  and (f.date_ended > @p_end_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_end_date - 7)
	and isnull(d.date_started, c.date_created) < @p_end_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_end_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_end_date - 7 
				and (c3.date_ended > @p_end_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_end_date - 7  
						  and @p_end_date))
union all
select  10 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Эвакуаторы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 50
	and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date
union all
select  11 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Технички:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 51
	and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date
union all
select  12 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'VIP-трансферы:' as header_1
	  ,null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 53
	and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date) as a
order by report_type, header_1
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



