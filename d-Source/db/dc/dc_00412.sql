:r ./../_define.sql

:setvar dc_number 00412
:setvar dc_description "rep sum/avg driver lists org id added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   10.02.2009 VLavrentiev  rep sum/avg driver lists org id added
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




ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_organization_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
where (a.organization_id = @p_organization_id or @p_organization_id is null)
order by report_type, organization_sname



	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_organization_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select 
	 report_type
	,header
	,organization_id
	,organization_sname
	,run
	,cnsmptn
	,kol
	,time_on_line
	    ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select 0 as report_type
	 , 'В целом по автоколонне' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'По организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'По видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end  as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'По маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'По эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'По VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'По машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
where (a.organization_id = @p_organization_id or @p_organization_id is null)
order by report_type, organization_sname




	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_organization_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
and (c.id = @p_organization_id or @p_organization_id is null)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
and (c.id = @p_organization_id or @p_organization_id is null)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, dateadd("DD",1,@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_organization_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select 
	 report_type
	,header
	,organization_id
	,organization_sname
	,run
	,cnsmptn
	,kol
	,time_on_line
	    ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select 0 as report_type
	 , 'В целом по автоколонне' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
union all
select 1 as report_type
	 , 'По организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'По видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end  as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'По маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'По эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'По VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'По машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by b.id, b.state_number) as a
order by report_type, organization_sname




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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql





