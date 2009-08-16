:r ./../_define.sql

:setvar dc_number 00409
:setvar dc_description "repair details added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   13.01.2009 VLavrentiev  repair details added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[uspVREP_REPAIR_DETAILS_SelectAll]
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
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_good_category_sname varchar(100) = null
,@p_state_number		varchar(20) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	from
(select a.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , a.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , d.state_number
	 , e.short_name
     , convert(decimal(18,2), c2.amount) as amount
     , convert(decimal(18,2), c2.price) as price
     , convert(decimal(18,1),(c2.price*c2.amount*0.18) + (c2.price*c2.amount)) as total
     , b2.number as demand_number
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = a.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1) as sum_demanded
  from dbo.cwrh_wrh_order_master as a
   join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
   join dbo.ccar_car as d on a.car_id = d.id
   join dbo.cprt_organization as g on d.organization_id = g.id
   join dbo.ccar_car_kind as h on d.car_kind_id = h.id
   left outer join dbo.cwrh_wrh_demand_master as b2 on a.id = b2.wrh_order_master_id
   left outer join dbo.cwrh_wrh_demand_detail as c2 on b2.id = c2.wrh_demand_master_id
   left outer join dbo.cwrh_good_category as e on c2.good_category_id = e.id
where a.sys_status = 1
  and c.sys_status = 1
  and g.sys_status = 1
  and h.sys_status = 1
  and isnull(b2.sys_status,1) = 1
  and isnull(c2.sys_status,1) = 1
  and d.sys_status = 1
  and isnull(e.sys_status,1) = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (d.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (d.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (d.organization_id = @p_organization_id or @p_organization_id is null)
	  and (c2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(e.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(d.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name


	RETURN

go

GRANT EXECUTE ON [dbo].[uspVREP_REPAIR_DETAILS_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_REPAIR_DETAILS_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name](@p_id numeric(38,0))
RETURNS varchar
AS
BEGIN
  declare
    @v_stmt varchar(512) 
   ,@v_tmp_stmt varchar(30)
   ,@i int
declare
shrt_name_cur cursor for
SELECT TOP(100) PERCENT c.short_name
				FROM dbo.cwrh_wrh_order_master as a 
				join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
				join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
				WHERE a.sys_status = 1
				  and a.order_state = 1
				  and b.sys_status = 1
				  and c.sys_status = 1
				  and a.id = @p_id
	   ORDER BY c.short_name

begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt

set @i = 1
 set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
	 
      set @v_stmt = @v_tmp_stmt
     else
	  set @v_stmt = @v_stmt + ',' + @v_tmp_stmt

fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END
go

GRANT VIEW DEFINITION ON [dbo].[usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




alter PROCEDURE [dbo].[uspVREP_REPAIR_DETAILS_SelectAll]
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
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_good_category_sname varchar(100) = null
,@p_state_number		varchar(20) = null
,@p_top_n			 numeric(3,0)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

 if (@p_top_n is null)
  set @p_top_n = 100 

if (@p_top_n = 100)
   
select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	from
(select a.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , a.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , d.state_number
	 , e.short_name
     , convert(decimal(18,2), c2.amount) as amount
     , convert(decimal(18,2), c2.price) as price
     , convert(decimal(18,1),(c2.price*c2.amount*0.18) + (c2.price*c2.amount)) as total
     , b2.number as demand_number
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = a.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1) as sum_demanded
  from dbo.cwrh_wrh_order_master as a
   join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
   join dbo.ccar_car as d on a.car_id = d.id
   join dbo.cprt_organization as g on d.organization_id = g.id
   join dbo.ccar_car_kind as h on d.car_kind_id = h.id
   left outer join dbo.cwrh_wrh_demand_master as b2 on a.id = b2.wrh_order_master_id
   left outer join dbo.cwrh_wrh_demand_detail as c2 on b2.id = c2.wrh_demand_master_id
   left outer join dbo.cwrh_good_category as e on c2.good_category_id = e.id
where a.sys_status = 1
  and c.sys_status = 1
  and g.sys_status = 1
  and h.sys_status = 1
  and isnull(b2.sys_status,1) = 1
  and isnull(c2.sys_status,1) = 1
  and d.sys_status = 1
  and isnull(e.sys_status,1) = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (d.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (d.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (d.organization_id = @p_organization_id or @p_organization_id is null)
	  and (c2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(e.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(d.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name


if (@p_top_n = 5)

 select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	from
(select 
	   b2.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , b2.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , a.state_number
	 , e2.short_name
     , convert(decimal(18,2), d2.amount) as amount
     , convert(decimal(18,2), d2.price) as price
     , convert(decimal(18,1),(d2.price*d2.amount*0.18) + (d2.price*d2.amount)) as total
     , c2.number as demand_number
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = b2.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1) as sum_demanded
 from  
(select top(5) 
             a2.id
			,a2.organization_id
			,a2.car_kind_id
			,a2.car_mark_id
			,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
        join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
	      and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc) as a
        join dbo.cwrh_wrh_order_master as b2 on a.id = b2.car_id
		join dbo.crpr_repair_zone_master as c on b2.repair_zone_master_id = c.id
		join dbo.cprt_organization as g on a.organization_id = g.id
		join dbo.ccar_car_kind as h on a.car_kind_id = h.id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
		where b2.sys_status = 1
		  and b2.order_state = 1
		  and c.sys_status = 1
		  and g.sys_status = 1
		  and h.sys_status = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name


go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name](@p_id numeric(38,0))
RETURNS varchar(512)
AS
BEGIN
  declare
    @v_stmt varchar(512) 
   ,@v_tmp_stmt varchar(30)
   ,@i int
declare
shrt_name_cur cursor for
SELECT TOP(100) PERCENT c.short_name
				FROM dbo.cwrh_wrh_order_master as a 
				join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
				join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
				WHERE a.sys_status = 1
				  and a.order_state = 1
				  and b.sys_status = 1
				  and c.sys_status = 1
				  and a.id = @p_id
	   ORDER BY c.short_name

begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt

set @i = 1
 set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
	 
      set @v_stmt = @v_tmp_stmt
     else
	  set @v_stmt = @v_stmt + ', ' + @v_tmp_stmt

fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_REPAIR_DETAILS_SelectAll]
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
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_good_category_sname varchar(100) = null
,@p_state_number		varchar(20) = null
,@p_top_n			 numeric(3,0)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

 if (@p_top_n is null)
  set @p_top_n = 100 

if (@p_top_n = 100)
   
select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
    ,reason
	from
(select a.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , a.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , d.state_number
	 , e.short_name
     , convert(decimal(18,2), c2.amount) as amount
     , convert(decimal(18,2), c2.price) as price
     , convert(decimal(18,1),(c2.price*c2.amount*0.18) + (c2.price*c2.amount)) as total
     , b2.number as demand_number
     , dbo.usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name (a.id) as reason
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = a.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1) as sum_demanded
  from dbo.cwrh_wrh_order_master as a
   join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
   join dbo.ccar_car as d on a.car_id = d.id
   join dbo.cprt_organization as g on d.organization_id = g.id
   join dbo.ccar_car_kind as h on d.car_kind_id = h.id
   left outer join dbo.cwrh_wrh_demand_master as b2 on a.id = b2.wrh_order_master_id
   left outer join dbo.cwrh_wrh_demand_detail as c2 on b2.id = c2.wrh_demand_master_id
   left outer join dbo.cwrh_good_category as e on c2.good_category_id = e.id
where a.sys_status = 1
  and c.sys_status = 1
  and g.sys_status = 1
  and h.sys_status = 1
  and isnull(b2.sys_status,1) = 1
  and isnull(c2.sys_status,1) = 1
  and d.sys_status = 1
  and isnull(e.sys_status,1) = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (d.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (d.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (d.organization_id = @p_organization_id or @p_organization_id is null)
	  and (c2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(e.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(d.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name


if (@p_top_n = 5)

 select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
    ,reason
	from
(select 
	   b2.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , b2.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , a.state_number
	 , e2.short_name
     , convert(decimal(18,2), d2.amount) as amount
     , convert(decimal(18,2), d2.price) as price
     , convert(decimal(18,1),(d2.price*d2.amount*0.18) + (d2.price*d2.amount)) as total
     , c2.number as demand_number
	 , dbo.usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name (b2.id) as reason
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = b2.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1) as sum_demanded
 from  
(select top(5) 
             a2.id
			,a2.organization_id
			,a2.car_kind_id
			,a2.car_mark_id
			,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
        join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
	      and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc) as a
        join dbo.cwrh_wrh_order_master as b2 on a.id = b2.car_id
		join dbo.crpr_repair_zone_master as c on b2.repair_zone_master_id = c.id
		join dbo.cprt_organization as g on a.organization_id = g.id
		join dbo.ccar_car_kind as h on a.car_kind_id = h.id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
		where b2.sys_status = 1
		  and b2.order_state = 1
		  and c.sys_status = 1
		  and g.sys_status = 1
		  and h.sys_status = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name



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



