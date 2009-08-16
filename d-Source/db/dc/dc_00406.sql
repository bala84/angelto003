:r ./../_define.sql

:setvar dc_number 00406
:setvar dc_description "demand reports fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   26.12.2008 VLavrentiev  demand reports fixed
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



ALTER FUNCTION [dbo].[utfVREP_WRH_DEMAND] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ôóíêöèÿ îòîáğàæåíèÿ òàáëèöû îò÷åòà ïî òğåáîâàíèÿì ïî àâòîìîáèëÿì
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ôóíêöèş
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
		SELECT   a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,c.full_name as good_category_fname
			,convert(decimal(18,2), a.amount) as amount
		    ,convert(decimal(18,2),a.price) as price
			,a.warehouse_type_id
			,d.short_name as warehouse_type_sname
			,b.car_id
			,e.state_number
			,e.car_type_id
			,e.car_mark_id
			,e.car_model_id
			,b.number
			,b.date_created
			,b.employee_recieve_id
			,ltrim(rtrim(
									h1.lastname + ' ' + substring(h1.name,1,1) + '. '
									+ isnull(substring(h1.surname,1,1),'') + '.')) as employee_recieve_fio
			,b.employee_head_id
			,ltrim(rtrim(
									h2.lastname + ' ' + substring(h2.name,1,1) + '. '
									+ isnull(substring(h2.surname,1,1),'') + '.')) as employee_head_fio
			,b.employee_worker_id
			,ltrim(rtrim(
									h3.lastname + ' ' + substring(h3.name,1,1) + '. '
									+ isnull(substring(h3.surname,1,1),'') + '.')) as employee_worker_fio
			,g1.id as organization_recieve_id
			,g2.id as organization_head_id
			,g3.id as organization_worker_id
			,e.car_kind_id
			,b.wrh_demand_master_type_id
			,b.organization_giver_id
			,f.name as organization_giver_sname
      FROM dbo.CWRH_WRH_DEMAND_DETAIL as a
		join dbo.CWRH_WRH_DEMAND_MASTER as b on a.wrh_demand_master_id = b.id
		join dbo.CWRH_GOOD_CATEGORY as c on a.good_category_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d on a.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as f on b.organization_giver_id = f.id
		left outer join dbo.CCAR_CAR as e on b.car_id = e.id
		left outer join dbo.CPRT_EMPLOYEE as g1 on b.employee_recieve_id = g1.id
		left outer join dbo.CPRT_PERSON as h1 on g1.person_id = h1.id
		left outer join dbo.CPRT_EMPLOYEE as g2 on b.employee_head_id = g2.id
		left outer join dbo.CPRT_PERSON as h2 on g2.person_id = h2.id
		left outer join dbo.CPRT_EMPLOYEE as g3 on b.employee_worker_id = g3.id
		left outer join dbo.CPRT_PERSON as h3 on g3.person_id = h3.id
	  where	(	a.sys_status = 1
			or  a.sys_status = 3)		
		and (	b.sys_status = 1
			or  b.sys_status = 3)	
		and c.sys_status = 1	
		and d.sys_status = 1
		and isnull(e.sys_status, 1) = 1
		and f.sys_status = 1
		and isnull(h1.sys_status, 1) = 1
		and isnull(g1.sys_status, 1) = 1
		and isnull(h2.sys_status, 1) = 1
		and isnull(g2.sys_status, 1) = 1
		and isnull(h3.sys_status, 1) = 1
		and isnull(g3.sys_status, 1) = 1
)


go




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î òğåáîâàíèÿõ çà äåíü
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_wrh_demand_master_type_id numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id	numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
,@p_state_number	varchar(30)   = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.car_type_id
			,a.car_mark_id
			,a.car_model_id
			,a.number
			,a.date_created
			,a.employee_recieve_id
			,a.employee_recieve_fio
			,a.employee_head_id
			,a.employee_head_fio
			,a.employee_worker_id
			,a.employee_worker_fio
			,a.organization_recieve_id
			,a.organization_head_id
			,a.organization_worker_id
			,a.car_kind_id
			,a.organization_giver_id
			,a.organization_giver_sname
			,convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) as total
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created >= @p_start_date 
	  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	order by a.organization_giver_sname, a.state_number, a.date_created, a.number

	RETURN


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î òğåáîâàíèÿõ çà äåíü ïî ìàøèíàì
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_state_number	varchar(30)	  = null
,@p_good_category_sname varchar(100) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 
			max(a.wrh_demand_master_id) as wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.organization_giver_id
			,a.organization_giver_sname
			,convert(decimal(18,2),sum((a.amount*a.price) + (a.amount*a.price*0.18))) as total
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where  a.date_created >= @p_start_date 
	  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and a.car_id is not null
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	group by a.good_category_id, a.good_category_fname
			,a.car_id,a.state_number, a.warehouse_type_id, a.warehouse_type_sname
			,a.organization_giver_id
			,a.organization_giver_sname
	order by a.organization_giver_sname, a.state_number

	RETURN

go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î ïóòåâûõ ëèñòàõ (ñğåäíèå çíà÷åíèÿ)
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
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
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Ñğåäíèå çíà÷åíèÿ (â öåëîì ïî àâòîêîëîííå)' as header
	 , 1 as organization_id
	 , 'Âñåãî' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Ñğåäíèå çíà÷åíèÿ ïî îğãàíèçàöèè' as header
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
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî âèäàì àâòîìîáèëåé' as header
	 , c.id as organization_id
	 , case c.short_name when 'ÌÒÎ' then 'Òåõíè÷êè'
						 when 'İâàêóàòîğ' then 'İâàêóàòîğû'
						 when 'VIP-òğàíñôåğ' then 'VIP-òğàíñôåğû'
						 when 'Äåæóğíûé' then 'Ìàøèíû îáåñïå÷åíèÿ'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),convert(decimal(18,2),count(*))/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî ìàğêàì àâòîìîáèëåé' as header
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
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî ıâàêóàòîğàì' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî òåõíè÷êàì' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî VIP-òğàíñôåğàì' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
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
	 , 'Ñğåäíèå çíà÷åíèÿ ïî ìàøèíàì îáñïå÷åíèÿ' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(convert(decimal(18,2),sum(datediff("MI", fact_start_duty, fact_end_duty)))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql


