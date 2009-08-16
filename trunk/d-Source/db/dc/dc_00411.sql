:r ./../_define.sql

:setvar dc_number 00411
:setvar dc_description "rep sum order fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.01.2009 VLavrentiev  rep sum order fixed
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






ALTER PROCEDURE [dbo].[uspVREP_SUM_ORDER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î çàÿâêàõ (ñóììàğíûå çíà÷åíèÿ)
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
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
	  ,kol
	  ,sum_order
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select
	 0 as report_type
	 , 'Â öåëîì ïî àâòîêîëîííå' as header
	 , 1 as organization_id
	 , 'Âñåãî' as organization_sname	 
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and e.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Ïî îğãàíèçàöèè' as header
	 , d.id as organization_id
	 , d.name as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by d.id, d.name
union all
select 2 as report_type
	 , 'Ïî âèäàì àâòîìîáèëåé' as header
	 , g.id as organization_id
	 , case g.short_name when 'ÌÒÎ' then 'Òåõíè÷êè'
						 when 'İâàêóàòîğ' then 'İâàêóàòîğû'
						 when 'VIP-òğàíñôåğ' then 'VIP-òğàíñôåğû'
						 when 'Äåæóğíûé' then 'Ìàøèíû îáåñïå÷åíèÿ'
		end  as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by g.id, g.short_name
union all
select 3 as report_type
	 , 'Ïî ìàğêàì àâòîìîáèëåé' as header
	 , g.id as organization_id
	 , g.short_name as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_mark as g on g.id = e.car_mark_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by g.id, g.short_name
union all
select 4 as report_type
	 , 'Ïî ıâàêóàòîğàì' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 50
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 5 as report_type
	 , 'ïî òåõíè÷êàì' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 51
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 6 as report_type
	 , 'Ïî VIP-òğàíñôåğàì' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname		
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 53
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 7 as report_type
	 , 'Ïî ìàøèíàì îáñïå÷åíèÿ' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 52
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number) as a
order by report_type, organization_sname


	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_COUNT_CAR_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î êîëè÷åñòâå ÑÒÏ
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,header_1
	  ,convert(decimal(18,2), kol) as kol 
	  ,convert(decimal(18,2),kol_1) as kol_1
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
from
(select 0 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé íà áàëàíñå:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
where a.sys_status = 1
  and a.state_number not like 'â418%'
union all
select 1 as report_type
	  ,'Êîëè÷åñòâî ñïèñàííûõ àâòîìîáèëåé:' as header
	  , null as header_1
	  ,count(*) as kol
	  ,null as kol_1
from dbo.ccar_car as a
where a.sys_status = 1
  and a.state_number like 'â418%'
union all
select 2 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé, íàõîäèâøèõñÿ â äëèòåëüíîì ğåìîíòå (áîëåå ñåìè äíåé):' as header
	  , null as header_1
	  ,count(a.car_id) as kol
	  ,null as kol_1
from dbo.cwrh_wrh_order_master as a
join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
where a.sys_status = 1
  and a.order_state = 1
  and c.sys_status = 1
  and c.date_started <= c.date_ended - 7 
    and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select  4 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé, âûõîäèâøèõ íà ëèíèş çà äåíü:'
	  ,'İâàêóàòîğû:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*))/(select datediff("DD",@p_start_date, dateadd("DD",1,@p_end_date))) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_CLOSED')
    and b.car_kind_id = 50
    and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select  5 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé, âûõîäèâøèõ íà ëèíèş çà äåíü:'
	  ,'Òåõíè÷êè:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*))/(select datediff("DD",@p_start_date, dateadd("DD",1,@p_end_date))) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_CLOSED')
    and b.car_kind_id = 51
    and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select  6 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé, âûõîäèâøèõ íà ëèíèş çà äåíü:'
	  ,'VIP-òğàíñôåğû:' as header_1
	  ,null as kol
	  , convert(decimal(18,2),count(*))/(select datediff("DD",@p_start_date, dateadd("DD",1,@p_end_date))) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_CLOSED')
    and b.car_kind_id = 53
    and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select  7 as report_type
	  ,'Êîëè÷åñòâî àâòîìîáèëåé, âûõîäèâøèõ íà ëèíèş çà äåíü:'
	  ,'Ìàøèíû îáåñïå÷åíèÿ:' as header_1
	  ,null as kol
	  , convert(decimal(18,2),count(*))/(select datediff("DD",@p_start_date, dateadd("DD",1,@p_end_date))) as kol_1 
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	and driver_list_state_id = dbo.usfConst('LIST_CLOSED')
    and b.car_kind_id = 52
    and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, @p_end_date)) as a
order by report_type




	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò ïî ñóììàğíûì âåëè÷èíàì ïğèõîäà íà ñêëàä
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id     numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_income_master as a
		join dbo.cwrh_wrh_income_detail as b on a.id = b.wrh_income_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_recieve_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (c.id = @p_organization_id or @p_organization_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò ïî ñóììàğíûì âåëè÷èíàì ğàñõîäà ñî ñêëàäà
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id     numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_demand_master as a
		join dbo.cwrh_wrh_demand_detail as b on a.id = b.wrh_demand_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_giver_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
 and (c.id = @p_organization_id or @p_organization_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



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
** Ïğîöåäóğà äîëæíà èçâëåêàòü äàííûå î âûõîäå àâòîìîáèëåé çà äåíü
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
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
		where c.message_code like ('%âûøåë%')
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date))
		  and c.date_created > dbo.usfUtils_TimeToZero(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%âûøåë%')
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
	 time from dbo.cdrv_driver_plan_detail as a
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
	  and c.message_code like ('%âåğíóëñÿ%')
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





