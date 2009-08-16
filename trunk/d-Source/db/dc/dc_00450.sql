
:r ./../_define.sql

:setvar dc_number 00450
:setvar dc_description "noexit fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   noexit fix
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










ALTER procedure [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить детальный план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 	 datetime	   = null
	,@p_comments		 	varchar(1000) = null
	,@p_mech_employee_id 		numeric(38,0) = null
	,@p_car_noexit_reason_type_id	numeric(38,0)
	,@p_rownum			int
	,@p_is_verified		varchar(30) = null
    	,@p_sys_comment		varchar(2000)  = '-'
    	,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime
	       ,@v_is_verified bit


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'

	if (@p_is_verified = 'Не проверен')
	set @v_is_verified = 0
	else
	set @v_is_verified = 1

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_NOEXIT_REASON_DETAIL
            (rownum, car_id, date, "time",  comments ,mech_employee_id, car_noexit_reason_type_id, is_verified
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_rownum, @p_car_id, @p_date, @p_time, @p_comments ,@p_mech_employee_id, @p_car_noexit_reason_type_id, @v_is_verified
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_NOEXIT_REASON_DETAIL set
		  rownum = @p_rownum
		, car_id = @p_car_id
	    , date   = @p_date
		, "time" = @p_time
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, car_noexit_reason_type_id     = @p_car_noexit_reason_type_id
	    , is_verified = @v_is_verified
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end

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
 @p_date		datetime
)
AS
SET NOCOUNT ON

 if (@p_date is null)
  set @p_date = getdate()

  set @p_date = dateadd("Hh", -4, @p_date)

select report_type
	  ,header
	  ,header_1
	  ,convert(decimal(18,2), kol) as kol 
	  ,convert(decimal(18,2),kol_1) as kol_1
	  ,convert(varchar(10),@p_date, 104) + ' ' + convert(varchar(5),@p_date, 108) as date
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
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
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
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
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
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
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
  and isnull(c.date_started, a.date_created) <= @p_date - 7 
    and (c.date_ended > @p_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between @p_date - 7  
			  and @p_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
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
  and isnull(c.date_started, a.date_created) >= ( @p_date - 7)
  and isnull(c.date_started, a.date_created) < @p_date
  and (c.date_ended > @p_date or c.date_ended is null)
  and d.sys_status = 1
  and e.is_comm_duty_car = 1
  and not exists
	(select 1 from dbo.cdrv_driver_list as b
		where b.car_id = a.car_id
		  and b.fact_start_duty 
		  between isnull(c.date_started, a.date_created)
			  and @p_date)
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.car_id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
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
where b.time <= @p_date
  and b.time > dbo.usfUtils_TimeToZero(@p_date)
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
where b.time <= @p_date
  and b.time > dbo.usfUtils_TimeToZero(@p_date)
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
    and b.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and b.date_created < @p_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 50
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_date - 7)
	and isnull(d.date_started, c.date_created) < @p_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_date - 7 
				and (c3.date_ended > @p_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_date - 7  
						  and @p_date))
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
    and b.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and b.date_created < @p_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 51
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_date - 7)
	and isnull(d.date_started, c.date_created) < @p_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_date - 7 
				and (c3.date_ended > @p_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_date - 7  
						  and @p_date))
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
    and b.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and b.date_created < @p_date
    and b.sys_status = 1)
  and a.sys_status = 1
  and e.is_comm_duty_car = 1
  and e.id = 53
  and not exists
	(select 1 from dbo.ccar_car_event as f
		where f.car_id = a.id
	      and f.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
		  and f.date_started <= @p_date
		  and (f.date_ended > @p_date or f.date_ended is null))
  and not exists
 (select 1 from dbo.cwrh_wrh_order_master as c
		   left outer join dbo.crpr_repair_zone_master as d on c.repair_zone_master_id = d.id
	where c.sys_status = 1
	and c.order_state not in (5,6)
	and isnull(d.sys_status, 1) = 1
	and c.car_id = a.id
	and isnull(d.date_started, c.date_created) >= ( @p_date - 7)
	and isnull(d.date_started, c.date_created) < @p_date
    and not exists
	(select 1 from dbo.cdrv_driver_list as b2
		where b2.car_id = c.car_id
		  and b2.fact_start_duty 
		  between isnull(d.date_started, c.date_created)
			  and @p_date))
    and not exists
  (select 1 
	from dbo.cwrh_wrh_order_master as a3
			left outer join dbo.crpr_repair_zone_master as c3 on a3.repair_zone_master_id = c3.id
			where a3.sys_status = 1
			  and a3.order_state not in (5,6)
			  and isnull(c3.sys_status, 1) = 1
			  and a3.car_id = a.id
			  and isnull(c3.date_started, a3.date_created) <= @p_date - 7 
				and (c3.date_ended > @p_date or c3.date_ended is null)
			  and not exists
				(select 1 from dbo.cdrv_driver_list as b3
					where b3.car_id = a3.car_id
					  and b3.fact_start_duty 
					  between @p_date - 7  
						  and @p_date))
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
    and a.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and a.date_created < @p_date
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
    and a.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and a.date_created < @p_date
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
    and a.date_created >= dbo.usfUtils_TimeToZero(@p_date)
	and a.date_created < @p_date) as a
order by report_type, header_1

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go











ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить детальный план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 varchar(5)	   = null
	,@p_employee_id		 numeric(38,0) = null
	,@p_shift_number	 tinyint	   = null
	,@p_comments		 varchar(1000) = null
	,@p_mech_employee_id numeric(38,0) = null
	,@p_is_completed	 bit		   = 0
	,@p_rownum			 int		
	,@p_organization_id	 numeric(38,0) 
	,@p_organization_sname	varchar(100)
	,@p_car_kind_id		numeric(38,0)
	,@p_car_kind_sname	varchar(30)
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)
    if ((@p_time is not null) and (@p_time != ''))
      select @v_time = convert(datetime, substring(convert(varchar(30), @p_date), 1, 11) + ' ' + @p_time + ':00')
    else
	     set @v_time = null
															
    

   if (@p_is_completed is null)
    set @p_is_completed = 0

  --Чтобы всегда срабатывал триггер до изменений - проапдейтим любую запись

  update top(1) dbo.CDRV_DRIVER_PLAN_DETAIL
	set sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_employee_id, @p_shift_number, @p_comments ,@p_mech_employee_id, @p_is_completed
		    ,@p_rownum, @p_organization_id, @p_organization_sname, @p_car_kind_id, @p_car_kind_sname 	
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_PLAN_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, employee_id = @p_employee_id
		, shift_number = @p_shift_number
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, is_completed     = @p_is_completed
		, rownum = @p_rownum
		, organization_id = @p_organization_id
		, organization_sname = @p_organization_sname
		, car_kind_id = @p_car_kind_id
		, car_kind_sname = @p_car_kind_sname
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
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



