
:r ./../_define.sql

:setvar dc_number 00470
:setvar dc_description "drv plan fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   05.06.2009 VLavrentiev   drv plan fix
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










ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_CreateBy_currmonth]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна заполнить план на основе предыдущего дня
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      31.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_date	datetime
		 , @v_next_month_year_index varchar(10)
		 , @v_month_year_index varchar(10)

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


    select   @v_date = dateadd("Month", 1, dbo.usfUtils_DayTo01(getdate()))
			,@v_month_year_index = case when datepart("Month", getdate()) < 10
											then '0' + convert(varchar(2), datepart("Month", getdate()))
											else convert(varchar(2), datepart("Month", getdate()))
									end
									   + '.' + convert(varchar(4),datepart("Year", getdate()))
			,@v_next_month_year_index = case when datepart("Month", dateadd("Month", 1, dateadd("Month", 1, getdate()))) < 10
											then '0' + convert(varchar(2), datepart("Month", dateadd("Month", 1, getdate())))
											else convert(varchar(2), datepart("Month", dateadd("Month", 1, getdate())))
									end
									   + '.' + convert(varchar(4),datepart("Year", dateadd("Month", 1, getdate())))
  -- Если вдруг нет плана по тек. месяцу - сместим к.точки на месяц назад
  if (not exists
		(select 1 from dbo.cdrv_driver_plan
			where month_year_index = @v_month_year_index ))
  begin
    select   @v_date = dateadd("Month", 1, dbo.usfUtils_DayTo01(dateadd("Month", -1 ,getdate())))
			,@v_month_year_index = case when datepart("Month", dateadd("Month", -1 ,getdate())) < 10
											then '0' + convert(varchar(2), datepart("Month", dateadd("Month", -1 ,getdate())))
											else convert(varchar(2), datepart("Month", dateadd("Month", -1 ,getdate())))
									end
									   + '.' + convert(varchar(4),datepart("Year", dateadd("Month", -1 ,getdate())))
			,@v_next_month_year_index = case when datepart("Month", dateadd("Month", 1, dateadd("Month", 1, dateadd("Month", -1 ,getdate())))) < 10
											then '0' + convert(varchar(2), datepart("Month", dateadd("Month", 1, dateadd("Month", -1 ,getdate()))))
											else convert(varchar(2), datepart("Month", dateadd("Month", 1, dateadd("Month", -1 ,getdate()))))
									end
									   + '.' + convert(varchar(4),datepart("Year", dateadd("Month", 1, dateadd("Month", -1 ,getdate()))))
  end
    
															
      if (@@tranCount = 0)
        begin transaction 

	    insert into dbo.cdrv_month_plan(month, month_index, sys_user_modified,  sys_user_created) 
		select @v_date, datepart("Month", @v_date), @p_sys_user, @p_sys_user
		 where not exists
			(select 1 from dbo.cdrv_month_plan
			   where month = @v_date) 


		insert into dbo.cdrv_driver_plan(car_id, "time",employee1_id, employee2_id, employee3_id, employee4_id, month_year_index, sys_user_modified,  sys_user_created)
		select car_id, dateadd("Month", 1, "time"),employee1_id, employee2_id, employee3_id, employee4_id, @v_next_month_year_index, @p_sys_user, @p_sys_user
		  from dbo.cdrv_driver_plan as a
		 where month_year_index = @v_month_year_index
          and not exists
			(select 1 from dbo.cdrv_driver_plan as b
				where b.month_year_index = @v_next_month_year_index)

       
	   if (@@tranCount > @v_TrancountOnEntry)
        commit


end

go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[usfVWFE_Inquire_addtnl_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о предстоящем доп. ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_date_created datetime
,@p_wrh_order_master_id numeric(38,0)
)
returns varchar(1000)
AS
begin
  declare
	 @v_id			numeric(38,0)
	,@v_short_name  varchar(30)
    ,@v_next_run decimal(18,9)
	,@i				int
	,@v_result_stmt varchar(1000)

  declare col_cur cursor for
  select a.id, a.short_name, (isnull(g.ts_run,0) - (a.periodicity + isnull(g.ts_run,0)))
from dbo.ccar_ts_type_master as a
		join dbo.ccar_car as b
			on a.car_model_id = b.car_model_id
		join dbo.CRPR_REPAIR_TYPE_MASTER as c
			on a.id = c.id
 outer apply (
			  select top(1) d.ts_run
			  from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as d
			  join dbo.cwrh_wrh_order_master as e
				on d.wrh_order_master_id = e.id
			  where d.repair_type_master_id = a.id
			   and (e.date_created <= @p_date_created or @p_date_created is null)
			   and (d.wrh_order_master_id != @p_wrh_order_master_id  or @p_wrh_order_master_id is null)
			   and ((e.order_state = dbo.usfConst('ORDER_CLOSED'))
					or (e.order_state = dbo.usfConst('ORDER_APPROVED'))
					or (e.order_state = dbo.usfConst('ORDER_CORRECTED'))
					)
			  order by e.date_created desc) as g
where b.id = @p_car_id 
and c.repair_type_master_kind_id = dbo.usfConst('ADDTNL_TO_REPAIR_TYPE')

  open col_cur

  fetch next from col_cur
  into @v_id, @v_short_name, @v_next_run

  set @i = 1

  while @@fetch_status = 0
	begin
      if (@v_result_stmt != '')
		set @v_result_stmt = @v_result_stmt + @v_short_name + ' : ' + convert(varchar(20), convert(decimal(18,0), @v_next_run)) + char(13)
      else
	    set @v_result_stmt = @v_short_name + ' : ' + convert(varchar(20), convert(decimal(18,0), @v_next_run)) + char(13)

 
	    fetch next from col_cur
		into @v_id, @v_short_name, @v_next_run
		
	  set @i = @i + 1
		
	end

  CLOSE col_cur
  DEALLOCATE col_cur
 
  return @v_result_stmt

end
go

GRANT VIEW DEFINITION ON [dbo].[usfVWFE_Inquire_addtnl_ts_by_car_id] TO [$(db_app_user)]
GO



drop function dbo.utfVWFE_Inquire_addtnl_ts_by_car_id
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER trigger [TAIUD_CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для обновления доп. ТО
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER]
after insert, update, delete
as
begin
  declare
	 @v_quc_iud				  char(1)
	,@v_wrh_order_master_id	  numeric(38,0)
	,@v_car_id				  numeric(38,0)
	,@v_repair_type_master_id numeric(38,0)
	,@v_id					  numeric(38,0)
	,@v_date_created		  datetime
	,@v_result_stmt			  varchar(1000)

  declare 
     @table table (car_id			  numeric(38,0)
				  ,date_created		  datetime
				  ,repair_type_master_id numeric(38,0)
				  ,wrh_order_master_id	 numeric(38,0)
				  ,sys_date_modified	datetime)


--Определим вид действия над таблицей 
 
  if   ((exists (select top(1) 1 from inserted))
   and (exists (select top(1) 1 from deleted)))
    set @v_quc_iud = 'U'
  else
    begin
	    if   (exists (select top(1) 1 from inserted))
		 set @v_quc_iud = 'I'
		else
		 set @v_quc_iud = 'D'
    end
     
--Вставим во временную таблицу измененные данные
  insert into @table (car_id, date_created, repair_type_master_id, wrh_order_master_id, sys_date_modified)
  select b.car_id, b.date_created, a.repair_type_master_id, a.wrh_order_master_id, a.sys_date_modified
	from inserted as a
	join dbo.cwrh_wrh_order_master as b on a.wrh_order_master_id = b.id
	where @v_quc_iud = 'I'
       or @v_quc_iud = 'U'
  union all
  select b.car_id, b.date_created, a.repair_type_master_id, a.wrh_order_master_id, a.sys_date_modified
	from deleted as a
	join dbo.cwrh_wrh_order_master as b on a.wrh_order_master_id = b.id
	where @v_quc_iud = 'D'

--Пройдемся в цикле по каждой записи и создадим по ней заявку
  while (exists (select top (1) 1 from @table
				   order by sys_date_modified asc))
  begin
	select 
		top(1) @v_car_id = car_id 
			  ,@v_date_created = date_created
			  ,@v_repair_type_master_id = repair_type_master_id
			  ,@v_wrh_order_master_id = wrh_order_master_id
	 from @table
	 order by sys_date_modified asc


     exec @v_result_stmt = dbo.usfVWFE_Inquire_addtnl_ts_by_car_id
					 @p_car_id = @v_car_id
					,@p_date_created = @v_date_created
					,@p_wrh_order_master_id = null

	if (@v_quc_iud in ('I','U'))
	 update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		set addtnl_ts = @v_result_stmt
		where repair_type_master_id = @v_repair_type_master_id
		  and wrh_order_master_id = @v_wrh_order_master_id
	else
	 begin
	   select top(1) @v_wrh_order_master_id = a.wrh_order_master_id
		from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
			join dbo.cwrh_wrh_order_master as b
				on a.wrh_order_master_id = b.id			
		where b.car_id = @v_car_id
		  and a.repair_type_master_id = @v_repair_type_master_id
		 order by b.date_created

		update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		set addtnl_ts = @v_result_stmt
		where repair_type_master_id = @v_repair_type_master_id
		  and wrh_order_master_id = @v_wrh_order_master_id
	 end 
					
    delete from @table
		where repair_type_master_id = @v_repair_type_master_id
		  and wrh_order_master_id = @v_wrh_order_master_id
  end
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
 return;

with reserve_stmt (report_type
				  ,header
				  ,header_1
				  ,kol 
				  ,kol_1
				  ,header_2
				  ,kol_2)
as
(select 7 as report_type
	  ,'Количество "боевых" автомобилей в резерве:'
	  ,'Эвакуаторы:' as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1
	  ,null as header_2
	  ,null as kol_2 
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and (b.speedometer_end_indctn is null or b.fact_end_duty > @p_end_date)
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
	  ,null as header_2
	  ,null as kol_2
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and (b.speedometer_end_indctn is null or b.fact_end_duty > @p_end_date)
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
	  ,null as header_2
	  ,null as kol_2
from dbo.ccar_car as a
join dbo.ccar_car_kind as e
	on a.car_kind_id = e.id
where not exists
 (select 1 from dbo.cdrv_driver_list as b
	where a.id = b.car_id
	and (b.speedometer_end_indctn is null or b.fact_end_duty > @p_end_date)
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
						  and @p_end_date)))
, exit_stmt (report_type
				  ,header
				  ,header_1
				  ,kol 
				  ,kol_1
				  ,header_2
				  ,kol_2)
as
(select  10 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Эвакуаторы:' as header_1
	  ,--'Из них на линии:' 
		null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
	  , null as header_2
	  ,(select isnull(convert(decimal(18,2),count(*)),0)
		 from dbo.cdrv_driver_list as a
			join dbo.ccar_car as b on b.id = a.car_id
		  where a.sys_status = 1
			and b.sys_status = 1
			--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
			and b.car_kind_id = 50
			and (a.speedometer_end_indctn is null or a.fact_end_duty > @p_end_date)
			and a.fact_start_duty >= @p_start_date
			and a.fact_start_duty < @p_end_date
			and not exists
				(select 1 from dbo.cwrh_wrh_order_master as a10
				  where a10.car_id = a.car_id
					and a10.order_state not in (5,6)
					and a10.sys_status = 1
					and a10.date_created > a.fact_start_duty
					and a10.date_created <= @p_end_date)) as kol_2
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 50
	--and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date
union all
select  11 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'Технички:' as header_1
	  ,--'Из них на линии:' 
		null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
	  , null as header_2
	  ,(select isnull(convert(decimal(18,2),count(*)),0)
		 from dbo.cdrv_driver_list as a
			join dbo.ccar_car as b on b.id = a.car_id
		  where a.sys_status = 1
			and b.sys_status = 1
			--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
			and b.car_kind_id = 51
			and (a.speedometer_end_indctn is null or a.fact_end_duty > @p_end_date)
			and a.fact_start_duty >= @p_start_date
			and a.fact_start_duty < @p_end_date
			and not exists
				(select 1 from dbo.cwrh_wrh_order_master as a10
				  where a10.car_id = a.car_id
					and a10.order_state not in (5,6)
					and a10.sys_status = 1
					and a10.date_created > a.fact_start_duty
					and a10.date_created <= @p_end_date)) as kol_2
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 51
	--and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date
union all
select  12 as report_type
	  ,'Количество "боевых" автомобилей, вышедших на линию:'
	  ,'VIP-трансферы:' as header_1
	  ,--'Из них на линии:' 
	   null	as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
	  , null as header_2
	  ,(select isnull(convert(decimal(18,2),count(*)),0)
		 from dbo.cdrv_driver_list as a
			join dbo.ccar_car as b on b.id = a.car_id
		  where a.sys_status = 1
			and b.sys_status = 1
			--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
			and b.car_kind_id = 53
			and (a.speedometer_end_indctn is null or a.fact_end_duty > @p_end_date)
			and a.fact_start_duty >= @p_start_date
			and a.fact_start_duty < @p_end_date
			and not exists
				(select 1 from dbo.cwrh_wrh_order_master as a10
				  where a10.car_id = a.car_id
					and a10.order_state not in (5,6)
					and a10.sys_status = 1
					and a10.date_created > a.fact_start_duty
					and a10.date_created <= @p_end_date)) as kol_2
  from  dbo.cdrv_driver_list as a
	join dbo.ccar_car as b on b.id = a.car_id
  where a.sys_status = 1
	and b.sys_status = 1
	--and driver_list_state_id = dbo.usfConst('LIST_OPEN')
    and b.car_kind_id = 53
	--and a.speedometer_end_indctn is null
    and a.fact_start_duty >= @p_start_date
	and a.fact_start_duty < @p_end_date) 
,long_repair(report_type
				  ,header
				  ,header_1
				  ,kol 
				  ,kol_1
				  ,header_2
				  ,kol_2)
as
(
select report_type
	  ,header
	  ,'Эвакуаторы:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,null as header_2
	  ,null as kol_2
  from
(select 13 as report_type
	  ,'Количество "боевых" автомобилей, находящихся в длительном ремонте (более семи дней):' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 50
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
  and not exists
	(select 1
		from dbo.cwrh_wrh_order_master as a7
		join dbo.ccar_car as d7
			on a7.car_id = d7.id
		join dbo.ccar_car_kind as e7
			on d7.car_kind_id = e7.id
		left outer join dbo.crpr_repair_zone_master as c7 on a7.repair_zone_master_id = c7.id
		where a7.sys_status = 1
		  and a7.order_state not in (5,6)
		  and isnull(c7.sys_status, 1) = 1
		  and isnull(c7.date_started, a7.date_created) >= ( @p_end_date - 7)
		  and isnull(c7.date_started, a7.date_created) < @p_end_date
		  and (c7.date_ended > @p_end_date or c7.date_ended is null)
		  and d7.sys_status = 1
		  and e7.is_comm_duty_car = 1
		  and e7.id = 50
		  and d7.id = d.id
		  and not exists
			(select 1 from dbo.cdrv_driver_list as b7
				where b7.car_id = a7.car_id
				  and b7.fact_start_duty 
				  between isnull(c7.date_started, a7.date_created)
					  and @p_end_date)
		  and not exists
			(select 1 from dbo.ccar_car_event as f7
				where f7.car_id = a7.car_id
				  and f7.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
				  and f7.date_started <= @p_end_date
				  and (f7.date_ended > @p_end_date or f7.date_ended is null))
		group by a7.car_id)
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol
union all
select report_type
	  ,header
	  ,'Технички:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,null as header_2
	  ,null as kol_2
  from
(select 14 as report_type
	  ,'Количество "боевых" автомобилей, находящихся в длительном ремонте (более семи дней):' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 51
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
  and not exists
	(select 1
		from dbo.cwrh_wrh_order_master as a7
		join dbo.ccar_car as d7
			on a7.car_id = d7.id
		join dbo.ccar_car_kind as e7
			on d7.car_kind_id = e7.id
		left outer join dbo.crpr_repair_zone_master as c7 on a7.repair_zone_master_id = c7.id
		where a7.sys_status = 1
		  and a7.order_state not in (5,6)
		  and isnull(c7.sys_status, 1) = 1
		  and isnull(c7.date_started, a7.date_created) >= ( @p_end_date - 7)
		  and isnull(c7.date_started, a7.date_created) < @p_end_date
		  and (c7.date_ended > @p_end_date or c7.date_ended is null)
		  and d7.sys_status = 1
		  and e7.is_comm_duty_car = 1
		  and e7.id = 51
		  and d7.id = d.id
		  and not exists
			(select 1 from dbo.cdrv_driver_list as b7
				where b7.car_id = a7.car_id
				  and b7.fact_start_duty 
				  between isnull(c7.date_started, a7.date_created)
					  and @p_end_date)
		  and not exists
			(select 1 from dbo.ccar_car_event as f7
				where f7.car_id = a7.car_id
				  and f7.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
				  and f7.date_started <= @p_end_date
				  and (f7.date_ended > @p_end_date or f7.date_ended is null))
		group by a7.car_id)
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol
union all
select report_type
	  ,header
	  ,'VIP-трансферы:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,null as header_2
	  ,null as kol_2
  from
(select 15 as report_type
	  ,'Количество "боевых" автомобилей, находящихся в длительном ремонте (более семи дней):' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 53
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
  and not exists
	(select 1
		from dbo.cwrh_wrh_order_master as a7
		join dbo.ccar_car as d7
			on a7.car_id = d7.id
		join dbo.ccar_car_kind as e7
			on d7.car_kind_id = e7.id
		left outer join dbo.crpr_repair_zone_master as c7 on a7.repair_zone_master_id = c7.id
		where a7.sys_status = 1
		  and a7.order_state not in (5,6)
		  and isnull(c7.sys_status, 1) = 1
		  and isnull(c7.date_started, a7.date_created) >= ( @p_end_date - 7)
		  and isnull(c7.date_started, a7.date_created) < @p_end_date
		  and (c7.date_ended > @p_end_date or c7.date_ended is null)
		  and d7.sys_status = 1
		  and e7.is_comm_duty_car = 1
		  and e7.id = 53
		  and d7.id = d.id
		  and not exists
			(select 1 from dbo.cdrv_driver_list as b7
				where b7.car_id = a7.car_id
				  and b7.fact_start_duty 
				  between isnull(c7.date_started, a7.date_created)
					  and @p_end_date)
		  and not exists
			(select 1 from dbo.ccar_car_event as f7
				where f7.car_id = a7.car_id
				  and f7.event in (dbo.usfConst('CAR_OUTDATED'), dbo.usfConst('CAR_LOANED'))
				  and f7.date_started <= @p_end_date
				  and (f7.date_ended > @p_end_date or f7.date_ended is null))
		group by a7.car_id)
group by a.car_id) as a
group by report_type
	  ,header
	  ,header_1
	  ,kol)
,curr_repair(report_type
				  ,header
				  ,header_1
				  ,kol 
				  ,kol_1
				  ,header_2
				  ,kol_2)
as
(select report_type
	  ,header
	  ,'Эвакуаторы:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,header_2
	  ,kol_2
  from
(select 16 as report_type
	  ,'Количество "боевых" автомобилей, находящихся на текущем ремонте:' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 50
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
	  ,kol
	  ,header_2
	  ,kol_2
union all
select report_type
	  ,header
	  ,'Технички:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,header_2
	  ,kol_2
  from
(select 17 as report_type
	  ,'Количество "боевых" автомобилей, находящихся на текущем ремонте:' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 51
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
	  ,kol
	  ,header_2
	  ,kol_2
union all
select report_type
	  ,header
	  ,'VIP-трансферы:' as header_1
	  ,kol
	  ,convert(varchar(100), count(*))  as kol_1
	  ,header_2
	  ,kol_2
  from
(select 18 as report_type
	  ,'Количество "боевых" автомобилей, находящихся на текущем ремонте:' as header
	  , null as header_1
	  , null as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
  and e.id = 53
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
	  ,kol
	  ,header_2
	  ,kol_2)
select report_type
	  ,header
	  ,header_1
	  ,kol 
	  ,convert(decimal(18,2),kol_1) as kol_1
	  ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	  ,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	  ,header_2
	  ,convert(decimal(18,2),kol_2) as kol_2
from
(select 0 as report_type
	  ,'Количество автомобилей на балансе:' as header
	  , null as header_1
	  ,convert(varchar(100), count(*)) as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
	  ,convert(varchar(100), count(*)) 
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
	  ,convert(varchar(100), count(*)) 
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2
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
select *from long_repair
union all
select *from curr_repair
union all
select report_type
	  ,header
	  ,header_1
	  ,kol 
	  ,kol_1
	  ,header_2
	  ,kol_2
from
(select 20 as report_type
	  ,'Количество невыходов "боевых" автомобилей:' as header
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1 
	  ,null as header_2
	  ,null as kol_2
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
select 20 as report_type
	  ,'Количество невыходов "боевых" автомобилей:'
	  ,null as header_1
	  ,0 as kol
	  ,null as kol_1 
	  ,null as header_2
	  ,null as kol_2
where not exists
(select 1 from dbo.ccar_noexit_reason_detail as b
		  join dbo.ccar_car as a 
			on b.car_id = a.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
  where b.time <= @p_end_date
    and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1))as a
union all
select report_type
	  ,header
	  ,header_1
	  ,kol 
	  ,kol_1
	  ,header_2
	  ,kol_2
from
(select 21 as report_type
	  ,'Количество возвратов "боевых" автомобилей:' as header
	  ,c.short_name as header_1
	  , null as kol
	  , convert(decimal(18,2),count(*)) as kol_1
	  ,null as header_2
	  ,null as kol_2 
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
select 21 as report_type
	  ,'Количество возвратов "боевых" автомобилей:'
	  ,null as header_1
	  , 0 as kol
	  ,null as kol_1
	  ,null as header_2
	  ,null as kol_2 
where not exists
(select 1 from dbo.ccar_return_reason_detail as b
		  join dbo.ccar_car as a 
			on b.car_id = a.id
		join dbo.ccar_car_kind as e
		  on a.car_kind_id = e.id
  where b.time <= @p_end_date
    and b.time > @p_start_date
  and a.sys_status = 1
  and e.is_comm_duty_car = 1)) as a
union all
select a.report_type + 40
	  ,'Количество исправных "боевых" автомобилей:'
	  ,a.header_1
	  ,null as kol 
	  ,isnull(a.kol_2, 0) + isnull(c.kol_1, 0)
	  ,null as header_2
	  ,null as kol_2
  from exit_stmt as a
  outer apply
	(select b.kol_1
		from reserve_stmt as b
	  where a.header_1 = b.header_1) as c
union all
select report_type + 50
	  ,header
	  ,header_1
	  ,kol 
	  ,kol_1
	  ,header_2
	  ,kol_2
  from reserve_stmt
union all
select report_type + 100
	  ,header
	  ,header_1
	  ,kol 
	  ,kol_1
	  ,header_2
	  ,kol_2
from exit_stmt
) as a
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




