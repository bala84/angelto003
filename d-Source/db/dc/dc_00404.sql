:r ./../_define.sql

:setvar dc_number 00404
:setvar dc_description "wrh item day fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   24.12.2008 VLavrentiev  wrh item day fixed
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


ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   




with wrh_left (total_start, warehouse_type_id, good_category_id, price, organization_id, amount_start, total_end, amount_end, month_created) as
(select	   isnull(convert(decimal(18,2), sum(a.amount_start)*a.price*0.18 + sum(a.amount_start)*a.price),0) as total_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,a.organization_id
		  ,isnull(convert(decimal(18,2), sum(a.amount_start)),0) as amount_start
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)*a.price*0.18 + sum(a.amount_end)*a.price),0) as total_end  
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)),0) as amount_end
		  , month_created from 
(select sum(a.amount) as amount_start, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and b.date_created < @p_start_date
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount_start, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created < @p_start_date
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select  null as amount_start
	  , b.warehouse_type_id
	  , a.good_category_id
	  , a.price as price
	  , b.organization_recieve_id  as organization_id
	  , sum(a.amount) as amount_end 
	  , dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
--  and a.good_category_id = 1011
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select     null as amount_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,-sum(a.amount) as amount_end
		  , dbo.usfUtils_DayTo01(b.date_created) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and  b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
)
as a
group by a.month_created, a.organization_id,  a.warehouse_type_id, a.good_category_id,a.price)
,income_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as
(
select     isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount
		  ,b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  --and a.good_category_id = 1011
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
)
,demand_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as 
(select 
		   isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price)
select-- TOP(100) PERCENT
	  a.warehouse_type_id
	, b.short_name as warehouse_type_sname
	, a.good_category_id
	, c.full_name as good_category_sname
  	, a.month_created
	, a.organization_id
	, d.name as organization_sname
	, replace(convert(varchar(100),sum(a.amount_start)),'.',',') as begin_amount
	, replace(convert(varchar(100),sum(a.total_start)),'.',',') as begin_sum
	, replace(convert(varchar(100),isnull((select sum(c.amount)
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)),'.',',') as income_amount
, replace(convert(varchar(100),isnull( (select sum(c.total) 
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)),'.',',') as income_sum
	, replace(convert(varchar(100),isnull((select sum(c.amount)
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)),'.',',') as outcome_amount
	, replace(convert(varchar(100),isnull( (select sum(c.total) 
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)),'.',',') as outcome_sum
	, replace(convert(varchar(100),sum(a.amount_end)),'.',',') as end_amount
	, replace(convert(varchar(100),sum(a.total_end)),'.',',') as end_sum 
from wrh_left as a 
join dbo.cwrh_warehouse_type as b on a.warehouse_type_id = b.id
join dbo.cwrh_good_category as c on a.good_category_id = c.id
join dbo.cprt_organization as d on a.organization_id = d.id
where (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)
  and ((upper(c.full_name) like upper('%' + @p_good_category_sname + '%')) or @p_good_category_sname is null)
group by a.month_created, a.organization_id, d.name, a.warehouse_type_id, b.short_name, a.good_category_id 
	, c.full_name
order by a.month_created, d.name,b.short_name,c.full_name


	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   


with wrh_left (total_start, warehouse_type_id, good_category_id, price, organization_id, amount_start, total_end, amount_end, month_created) as
(select	   isnull(convert(decimal(18,2), sum(a.amount_start)*a.price*0.18 + sum(a.amount_start)*a.price),0) as total_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,a.organization_id
		  ,isnull(convert(decimal(18,2), sum(a.amount_start)),0) as amount_start
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)*a.price*0.18 + sum(a.amount_end)*a.price),0) as total_end  
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)),0) as amount_end
		  , month_created from 
(select sum(a.amount) as amount_start, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and b.date_created < @p_start_date
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount_start, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,null as amount_end                                                                       
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created < @p_start_date
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select sum(a.amount) as amount_start, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount_start, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,null as amount_end                                                                       
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created < @p_start_date
 -- and a.good_category_id = 1011
and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select  null as amount_start
	  , b.warehouse_type_id
	  , a.good_category_id
	  , a.price as price
	  , b.organization_recieve_id  as organization_id
	  , sum(a.amount) as amount_end 
	  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
--  and a.good_category_id = 1011
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select     null as amount_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,-sum(a.amount) as amount_end
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and  b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select  null as amount_start
	  , b.warehouse_type_id
	  , a.good_category_id
	  , a.price as price
	  , b.organization_recieve_id  as organization_id
	  , sum(a.amount) as amount_end 
	  , dbo.usfUtils_DayTo01(@p_start_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
--  and a.good_category_id = 1011
  and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select     null as amount_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,-sum(a.amount) as amount_end
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
)
as a
group by a.month_created, a.organization_id,  a.warehouse_type_id, a.good_category_id,a.price)
,income_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as
(
select     isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount
		  ,b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  --and a.good_category_id = 1011
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
)
,demand_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as 
(select 
		   isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price)
select-- TOP(100) PERCENT
	  a.warehouse_type_id
	, b.short_name as warehouse_type_sname
	, a.good_category_id
	, c.full_name as good_category_sname
  	, a.month_created
	, a.organization_id
	, d.name as organization_sname
	, convert(decimal(18,2),sum(a.amount_start)) as begin_amount
	, convert(decimal(18,2),sum(a.total_start)) as begin_sum
	, convert(decimal(18,2),isnull((select sum(c.amount)
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as income_amount
, convert(decimal(18,2),isnull( (select sum(c.total) 
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as income_sum
	, convert(decimal(18,2),isnull((select sum(c.amount)
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as outcome_amount
	, convert(decimal(18,2),isnull( (select sum(c.total) 
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as outcome_sum
	, convert(decimal(18,2),sum(a.amount_end)) as end_amount
	, convert(decimal(18,2),sum(a.total_end)) as end_sum 
from wrh_left as a 
join dbo.cwrh_warehouse_type as b on a.warehouse_type_id = b.id
join dbo.cwrh_good_category as c on a.good_category_id = c.id
join dbo.cprt_organization as d on a.organization_id = d.id
where (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)
  and ((upper(c.full_name) like upper('%' + @p_good_category_sname + '%')) or @p_good_category_sname is null)
  and (@p_start_date < @p_end_date) 
  and (not exists(select 1 where datepart("mm",@p_start_date) != datepart("mm", @p_end_date)))
group by a.month_created, a.organization_id, d.name, a.warehouse_type_id, b.short_name, a.good_category_id 
	, c.full_name
order by a.month_created, d.name,b.short_name,c.full_name


	RETURN


go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по суммарным величинам прихода на склад
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
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
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN
go


GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по суммарным величинам прихода на склад
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
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
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по суммарным величинам расхода со склада
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
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
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN
go


GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVREP_CAR_EXIT_SelectByDate]
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
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_DayTo01(@p_date))
		  and c.date_created > dbo.usfUtils_DayTo01(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, dbo.usfUtils_DayTo01(@p_date)))
select
TOP(100) PERCENT 
 a.date_created 
,a.state_number
,a.fio
,a.date_planned 
,a.date_exit
,j3.date_return
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



GRANT EXECUTE ON [dbo].[uspVREP_CAR_EXIT_SelectByDate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_EXIT_SelectByDate] TO [$(db_app_user)]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным путевым листам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_car_mark_id			numeric(38,0) = null
,@p_car_kind_id			numeric(38,0) = null
,@p_car_id		        numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_employee1_id		numeric(38,0) = null
,@p_state_number		varchar(30) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,date_created
		,state_number
		,car_id
		,car_type_id
		,car_type_sname
		,car_mark_id
		,car_mark_sname
		,car_model_id
		,car_model_sname
		,fuel_type_id
		,fuel_type_sname
		,car_kind_id
		,car_kind_sname
		,driver_list_state_id
		,driver_list_state_sname
		,driver_list_type_id
		,driver_list_type_sname
		,convert(decimal(18,2),speedometer_start_indctn) as speedometer_start_indctn
		,convert(decimal(18,2),speedometer_end_indctn) as speedometer_end_indctn
		,convert(decimal(18,2),fuel_exp) as fuel_exp
		,convert(decimal(18,2),fuel_start_left) as fuel_start_left
		,convert(decimal(18,2),fuel_end_left) as fuel_end_left
		,organization_id
		,organization_sname
		,fact_start_duty
		,fact_end_duty
		,employee1_id
		,fio_employee1
		,convert(decimal(18,2),fuel_gived) as fuel_gived
		,convert(decimal(18,2),fuel_return) as fuel_return
		,convert(decimal(18,2),fuel_addtnl_exp) as fuel_addtnl_exp
		,convert(decimal(18,2),run) as run
		,convert(decimal(18,2),fuel_consumption) as fuel_consumption
		,number
		,last_date_created
		,convert(decimal(18,0),power_trailer_hour) as power_trailer_hour
	FROM dbo.utfVREP_DRIVER_LIST() as a
	where date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and (employee1_id = @p_employee1_id or @p_employee1_id is null)
	  and (upper(state_number) like upper('%' + @p_state_number + '%') or @p_state_number is null)
	order by date_created, organization_sname, car_type_sname, state_number

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVREP_CAR_SUMMARY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать суммарный отчет об автомобиле
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_time_interval		smallint = null
,@p_car_mark_id			numeric(38,0) = null
,@p_car_kind_id			numeric(38,0) = null
,@p_car_id		        numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_state_number		varchar(30)	  = null
)
AS
SET NOCOUNT ON

	declare
		 @v_value_fuel_cnmptn_id numeric(38,0)
		,@v_value_run_id		 numeric(38,0)
		,@v_value_fuel_gived_id  numeric(38,0)
		,@v_value_fuel_return_id  numeric(38,0)
		,@v_pw_trailer_id		 numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set  @v_value_fuel_cnmptn_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
  set  @v_value_run_id = dbo.usfConst('CAR_KM_AMOUNT')
  set  @v_value_fuel_gived_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
  set  @v_value_fuel_return_id = dbo.usfConst('CAR_FUEL_RETURN_AMOUNT')
  set  @v_pw_trailer_id = dbo.usfConst('CAR_POWER_TRAILER_AMOUNT')
  
   
   select
		 state_number 
		,convert(decimal(18,0), speedometer_start_indctn) as speedometer_start_indctn
		,convert(decimal(18,0), speedometer_end_indctn) as speedometer_end_indctn
		,fuel_consumption
		,run
		,case when run = 0 then 0
			  else convert(decimal(18,2),(convert(decimal(18,2), fuel_consumption - pw_trailer_amount)*convert(decimal(18,2), 100)
				/convert(decimal(18,2),run))) 
		  end as fuel_cnmptn_100_km
		,convert(decimal(18,0), fuel_start_left) as fuel_start_left
		,convert(decimal(18,0), fuel_end_left) as fuel_end_left
		,fuel_gived
		,organization_id
		,organization_sname
		,month_created
		,pw_trailer_amount
	from
   (select
		 state_number 
		,min(speedometer_start_indctn) as speedometer_start_indctn
		,max(speedometer_end_indctn) as speedometer_end_indctn
		,sum(fuel_consumption) as fuel_consumption
		,sum(run) as run
		,min(fuel_start_left) as fuel_start_left
		,max(fuel_end_left) as fuel_end_left
		,sum(convert(decimal,fuel_gived)) as fuel_gived
		,organization_id
		,organization_sname
		,month_created
		,sum(pw_trailer_amount) as pw_trailer_amount
   from     
   (SELECT 
		  state_number
		 ,dbo.usfUtils_DayTo01(month_created) as month_created
		 ,isnull((y.speedometer_start_indctn)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_start_indctn
		 ,isnull((z.speedometer_end_indctn)
				 ,(select speedometer_end_indctn from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as speedometer_end_indctn
		 ,isnull((convert(decimal(18,0)
			,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
				from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_cnmptn_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as fuel_consumption
		 ,isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_run_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as run
		 ,isnull((y.fuel_start_left)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_start_left
		 ,isnull((z.fuel_end_left)
				 ,(select fuel_end_left from dbo.CCAR_CONDITION
												  where car_id = a.car_id)) as fuel_end_left
		 ,(isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_gived_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0)
		- 
			isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_value_fuel_return_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0)) as fuel_gived
	,organization_id
	,organization_sname
	,isnull((convert(decimal(18,0)
		    ,(select 
				day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7
			  +	day_8 + day_9 + day_10 + day_11 + day_12 + day_13 + day_14
			  + day_15 + day_16 + day_17 + day_18 + day_19 + day_20 + day_21
			  + day_22 + day_23 + day_24 + day_25 + day_26 + day_27 + day_28
			  + day_29 + day_30 + day_31
			from dbo.utfVREP_CAR_DAY() as b
						 where value_id = @v_pw_trailer_id
						   and b.month_created = a.month_created
						   and b.value_id = a.value_id
						   and b.car_id = a.car_id
						   and b.organization_id = a.organization_id))), 0) as pw_trailer_amount
	FROM dbo.utfVREP_CAR_DAY() as a
	outer apply (select TOP(1) fuel_start_left, speedometer_start_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created >= @p_start_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												   and  c.driver_list_state_id = dbo.usfConst('LIST_CLOSED')
												  order by date_created asc, fact_start_duty asc) as y
	outer apply (select TOP(1) fuel_end_left, speedometer_end_indctn
												 from dbo.CDRV_DRIVER_LIST as c
												  where c.date_created <= @p_end_date
												 --  and  c.value_id = a.value_id
												   and  c.car_id = a.car_id
												   and  c.organization_id = a.organization_id
												   and  c.driver_list_state_id = dbo.usfConst('LIST_CLOSED')
												  order by date_created desc, fact_end_duty desc) as z
	where month_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and (upper(state_number) like upper('%' + @p_state_number + '%') or @p_state_number is null)
 /* union all
	select state_number 
		,  speedometer_end_indctn
		,  speedometer_end_indctn
		,  0
		,  0
		,  fuel_end_left
		,  fuel_end_left
		,  0
		,  organization_id
		,  name as organization_sname
		,  null as month_created
		,  0
	from dbo.CCAR_CONDITION as a3
	 join dbo.CCAR_CAR as a4 on a3.car_id = a4.id
	 left outer join dbo.CPRT_ORGANIZATION as a5 on a4.organization_id = a5.id
	where not exists
		(select 1 FROM dbo.utfVREP_CAR_DAY() as a2
		 	where month_created 
							between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
							and a3.car_id = a2.car_id
						    and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
						    and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
						    and (car_id = @p_car_id or @p_car_id is null)
						    and (organization_id = @p_organization_id or @p_organization_id is null)
						    )*/) as a
	group by
		 month_created
		,organization_id
	    ,organization_sname 
		,state_number) as b
	order by month_created, organization_sname, state_number

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


