
:r ./../_define.sql

:setvar dc_number 00469
:setvar dc_description "car condition addtnl ts added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.05.2009 VLavrentiev   car condition addtnl ts added
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



ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)
  ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type



	
    SET NOCOUNT ON
  
       SELECT 
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,null as addtnl_ts
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */
	
  RETURN
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
SET NOCOUNT ON
DECLARE
   @v_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
 
       SELECT 
              		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,null as addtnl_ts
		FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/

	RETURN

go


alter table dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
add sent_addtnl_ts char(1) default 'N'
go

execute sp_addextendedproperty 'MS_Description', 
   'Доп. ТО или нет',
   'user', 'dbo', 'table', 'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', 'column', 'sent_addtnl_ts'
go

create index i_wrh_order_master_repair_type_master_sent_addtnl_ts on dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER (sent_addtnl_ts)
on $(fg_idx_name)
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта для заказа - наряда
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id		numeric(38,0)
	,@p_repair_type_master_id	numeric(38,0)
    ,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_date_created datetime
		 , @v_car_id	   numeric(38,0) 
		 , @v_ts_type_master_id numeric(38,0)
		 , @v_ts_type_route_detail_id numeric(38,0)
		 , @v_sent_to char(1)
		 , @v_ts_run	decimal(18,9)
		 , @v_sent_addtnl_ts char(1)

--Узнаем данные о заказе-наряде
	select @v_date_created = date_created
		  ,@v_car_id	   = car_id
		  ,@v_ts_run	   = run
	  from dbo.CWRH_WRH_ORDER_MASTER
	where id = @p_wrh_order_master_id


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @v_sent_to = 'N'

	set @v_sent_addtnl_ts = 'N'

--Попробуем обновить ТО, если это (основное) ТО
select   @v_ts_type_master_id = a.id
		,@v_sent_to = 'Y'
  from dbo.ccar_ts_type_master as a where a.id = @p_repair_type_master_id 
	and exists
			(select 1 from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id 
			  where g.id = @v_car_id
				and b2.ts_type_master_id = a.id) 
--Попробуем узнать - доп ТО или нет				
select @v_sent_addtnl_ts = 'Y'
from dbo.ccar_ts_type_master as a where a.id = @p_repair_type_master_id

if (@v_ts_type_master_id is not null)
--Узнаем следующий маршрут ТО
 --если встака то без указания текущего ремонта
 if (not exists (select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
						  where wrh_order_master_id = @p_wrh_order_master_id
							and repair_type_master_id = @p_repair_type_master_id))
  select @v_ts_type_route_detail_id  = id 
	from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id, @v_ts_type_master_id, @v_date_created, null, null)
 -- если редактирование, то мы должны посмотреть с указанием текущего ремонта (исключить из поиска)
else
  select @v_ts_type_route_detail_id  = id 
	from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id, @v_ts_type_master_id, @v_date_created, @p_wrh_order_master_id, @p_repair_type_master_id)  

	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id, ts_type_route_detail_id, sent_to, sent_addtnl_ts, ts_run
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id, @v_ts_type_route_detail_id, @v_sent_to, @v_sent_addtnl_ts, @v_ts_run
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

 if (@@ROWCOUNT = 0)	
	  update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		 set  ts_type_route_detail_id = @v_ts_type_route_detail_id
			 ,sent_to = @v_sent_to
			 ,sent_addtnl_ts = @v_sent_addtnl_ts
			 ,ts_run = @v_ts_run
			 ,sys_user_modified = @p_sys_user
			 ,sys_comment = @p_sys_comment
		where wrh_order_master_id = @p_wrh_order_master_id
			  and repair_type_master_id = @p_repair_type_master_id
       
  
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


create function [dbo].[utfVWFE_Inquire_addtnl_ts_by_car_id]
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

GRANT VIEW DEFINITION ON [dbo].[utfVWFE_Inquire_addtnl_ts_by_car_id] TO [$(db_app_user)]
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)
  ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type



	
    SET NOCOUNT ON
  
       SELECT 
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,dbo.utfVWFE_Inquire_addtnl_ts_by_car_id(a.car_id, null, null) as addtnl_ts
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */
	
  RETURN
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
SET NOCOUNT ON
DECLARE
   @v_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
 
       SELECT 
              		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,dbo.utfVWFE_Inquire_addtnl_ts_by_car_id(a.car_id, null, null) as addtnl_ts
		FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER function [dbo].[utfVWFE_Inquire_addtnl_ts_by_car_id]
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


alter table dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
add addtnl_ts varchar(1000)
go

execute sp_addextendedproperty 'MS_Description', 
   'Доп. ТО',
   'user', 'dbo', 'table', 'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', 'column', 'addtnl_ts'
go

create index i_wrh_order_master_repair_type_master_addtnl_ts on dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER (addtnl_ts)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create trigger [TAIUD_CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER]
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


     exec @v_result_stmt = dbo.utfVWFE_select_addtnl_ts_by_car_id
					 @p_car_id = @v_car_id
					,@p_date_created = @v_date_created

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
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create function [dbo].[utfVWFE_select_addtnl_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о предстоящем доп. ТО для состояния автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_date_created datetime
)
returns varchar(1000)
AS
begin
  declare
	 @v_result_stmt varchar(1000)

  select top(1)
		@v_result_stmt = addtnl_ts
	from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
	join dbo.cwrh_wrh_order_master as b
		on a.wrh_order_master_id = b.id
	where addtnl_ts is not null
	  and b.car_id = @p_car_id
	  and (b.date_created < @p_date_created or @p_date_created is null)
	  and ((b.order_state = dbo.usfConst('ORDER_CLOSED'))
					or (b.order_state = dbo.usfConst('ORDER_APPROVED'))
					or (b.order_state = dbo.usfConst('ORDER_CORRECTED'))
					)
	 order by b.date_created desc
 
  return @v_result_stmt

end

go


GRANT VIEW DEFINITION ON [dbo].[utfVWFE_select_addtnl_ts_by_car_id] TO [$(db_app_user)]
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)
  ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type



	
    SET NOCOUNT ON
  
       SELECT 
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,dbo.utfVWFE_select_addtnl_ts_by_car_id(a.car_id, null) as addtnl_ts
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */
	
  RETURN
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
SET NOCOUNT ON
DECLARE
   @v_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
 
       SELECT 
              		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,a.state_number
		  ,isnull(d.ts_type_master_id, b.min_id) as ts_type_master_id
		  ,isnull(d.ts_name, b.min_name) as ts_type_name
		  ,a.car_mark_model_name
		  ,a.car_mark_id
		  ,a.car_model_id
		  ,a.employee_id
		  ,a.FIO
		  ,a.car_state_id
		  ,a.car_state_name
		  ,a.car_type_id
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,a.last_ts_type_master_id
	      ,a.edit_state
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.sent_to
		  ,convert(decimal(18,0), a.last_run, 128) as last_run
		  ,convert(decimal(18,0), a.run - (c.ts_run + b.min_periodicity), 128) as overrun
		  ,case when (c.ts_run +b.min_periodicity) - a.run <= d.tolerance then 1 
				else 0
			end as in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,dbo.utfVWFE_select_addtnl_ts_by_car_id(a.car_id, null) as addtnl_ts
		FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    	outer apply 
				 (select top(1) periodicity as min_periodicity, a2.id as min_id, a2.short_name as min_name from dbo.CCAR_TS_TYPE_MASTER as a2
						where exists
						(select 1 from dbo.ccar_car as b
							where b.id = a.car_id
							  and b.car_model_id = a2.car_model_id)
						  and exists
						(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as c
									join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d
													on d.id = c.ts_type_route_master_id
						  where a2.id = c.ts_type_master_id
							and a2.car_model_id = (select id from dbo.ccar_car_model as e
												   where e.ts_type_route_master_id = d.id))
						order by periodicity asc) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED'))
							or (b4.order_state = dbo.usfConst('ORDER_CORRECTED'))
							)
				  order by b4.date_created desc) as c
	outer apply ((select a3.ts_type_master_id, b3.tolerance, b3.short_name + ' (' + convert(varchar(20), a3.ordered) + ')'  as ts_name  
					from   dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					  join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
					where a3.id = (select c3.ts_type_route_detail_id 
									from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3))) as d
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/

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




