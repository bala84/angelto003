:r ./../_define.sql

:setvar dc_number 00438
:setvar dc_description "rep car_exit fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   02.04.2009 VLavrentiev   rep car_exit fix
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
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc) as date_planned
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
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
,case when (a.date_planned is not null
	   and a.date_exit is not null)
	  then datediff("mi",a.date_planned, a.date_exit)
	  else null
  end as wait_time
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
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc) as date_planned
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
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER function [dbo].[utfVWFE_Check_last_order_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о прошедшем ТО по заказу-наряду
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_date_created datetime
,@p_order_master_id numeric(38,0)
,@p_repair_type_master_id numeric(38,0)
)
returns table
AS

return
( 
select top(1) a.ts_type_route_detail_id
from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
	join dbo.CWRH_WRH_ORDER_MASTER as b on a.wrh_order_master_id = b.id
	left outer join dbo.CRPR_REPAIR_ZONE_MASTER as c on b.id = c.wrh_order_master_id
where b.car_id = @p_car_id
  and (b.order_state = dbo.usfConst('ORDER_CLOSED')
	 or b.order_state = dbo.usfConst('ORDER_APPROVED')
	 or b.order_state = dbo.usfConst('ORDER_CORRECTED'))
  and a.ts_type_route_detail_id is not null
  and ((b.date_created <= @p_date_created) or (@p_date_created is null))
  and ((a.wrh_order_master_id != @p_order_master_id
		and a.repair_type_master_id != @p_repair_type_master_id) 
	 or (@p_order_master_id is null
		and @p_repair_type_master_id is null))
order by b.date_created desc, c.date_ended desc)

go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[utfVWFE_Inquire_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о предстоящем ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
,@p_ts_type_master_id numeric(38,0)
,@p_date_created datetime
,@p_wrh_order_master_id numeric(38,0)
,@p_repair_type_master_id numeric(38,0)
)
returns table
AS
return
( 
select top(1) 
  id, ts_type_master_id
from(
select id, ts_type_master_id, ordered 
from(
select top(1) a.ts_type_master_id, a.ordered, a.id 
from (select top(1)
			 b2.ordered, b2.ts_type_route_master_id
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ts_type_master_id = @p_ts_type_master_id
				    and b2.ordered >= (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where b3.id = isnull((select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created, @p_wrh_order_master_id, @p_repair_type_master_id))
															--Если записи о прошлом ТО не было, то вернем то, что проходим сейчас
															,(select TOP(1) b2.id
																  from dbo.ccar_car as g
																	join dbo.ccar_car_model as e on  e.id = g.car_model_id
																	join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
																	join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
																  where g.id = @p_car_id
																	and b2.ts_type_master_id = @p_ts_type_master_id
																order by b2.ordered asc))
					)
				order by b2.ordered asc) as b
	join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a on b.ts_type_route_master_id = a.ts_type_route_master_id
											and b.ordered < a.ordered
order by a.ordered asc
) as c
union
select b2.id, b2.ts_type_master_id, b2.ordered
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ordered = 1) as d
order by ordered desc)
GO

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
            ( wrh_order_master_id,  repair_type_master_id, ts_type_route_detail_id, sent_to, ts_run
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id, @v_ts_type_route_detail_id, @v_sent_to, @v_ts_run
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

 if (@@ROWCOUNT = 0)	
	  update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		 set  ts_type_route_detail_id = @v_ts_type_route_detail_id
			 ,sent_to = @v_sent_to
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


ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_Check_correct_ts]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна проверить правильность оформления ремонта
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.11.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0)
	,@p_repair_type_master_id	numeric(38,0)
	,@p_date_created			datetime
	,@p_is_correct			    char(1)		  out

)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_is_correct char(1)

   set @v_is_correct = 'Y'
 --Если ремонт - то - попробуем узнать правильность заведения ремонта
   if (exists (select 1 from dbo.CCAR_TS_TYPE_MASTER
				where id = @p_repair_type_master_id))
    begin
      --Соответствие модели автомобиля
	if (not exists(select 1 from dbo.ccar_ts_type_master as a
					 where a.id = @p_repair_type_master_id
					   and exists
							(select 1 from dbo.ccar_car_model as b
							   where b.id = (select car_model_id from dbo.ccar_car where id = @p_id)
								 and b.id = a.car_model_id) ))

	  set @v_is_correct = 'N'
	  --Выбранное ТО не может быть меньшим по периодичности, чем то - которое должен пройти автомобиль
    if (not exists
				  (select 1 from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_id, @p_date_created, null, null) as a
							join dbo.ccar_ts_type_route_detail as b on a.ts_type_route_detail_id = b.id
							join dbo.ccar_ts_type_master as c on b.ts_type_master_id = c.id
							where c.periodicity >  
												(select c2.periodicity 
												 from dbo.ccar_ts_type_master as c2
												 where id = @p_repair_type_master_id)))
	  set @v_is_correct = 'N'
								

	end

	set @p_is_correct = @v_is_correct

  return 

end
go




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
	,@p_wrh_demand_master_type_id numeric(38,0) = null
	,@p_organization_giver_id	numeric(38,0) = null
	,@p_wrh_order_master_id	numeric(38,0) = null
	,@p_is_verified			varchar(30) = 'Не проверен'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	 declare
		 @v_number varchar(20)
		,@v_Error int
        ,@v_TrancountOnEntry int
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

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



if (@@tranCount = 0)
        begin transaction  
      
		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_DEMAND_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number

       -- надо добавлять
  if (@p_id is null)
    begin



	
	   insert into
			     dbo.CWRH_WRH_DEMAND_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id, is_verified
			, employee_worker_id, wrh_demand_master_type_id, organization_giver_id, wrh_order_master_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @v_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @v_is_verified
			, @p_employee_worker_id, @p_wrh_demand_master_type_id, @p_organization_giver_id, @p_wrh_order_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity()



    end   
       
	    
 else
  begin

  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_MASTER set
		 car_id = @p_car_id
		,number = @v_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
		,organization_giver_id = @p_organization_giver_id
		,wrh_order_master_id = @p_wrh_order_master_id
		,is_verified = @v_is_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end


if (@@tranCount > @v_TrancountOnEntry)
        commit
	   
  return 

end

go


 set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить заявку на закупку на склад
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(150)
	,@p_date_created		datetime
	,@p_total				decimal(18,9)
	,@p_is_verified			varchar(30) = 'Не проверен'
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

  declare
    @v_is_verified bit
   ,@v_account_type smallint
   ,@v_number varchar(150)
		,@v_Error int
        ,@v_TrancountOnEntry int


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



     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

		if (@@tranCount = 0)
         begin transaction  


		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_INCOME_ORDER_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number


       -- надо добавлять
  if (@p_id is null)
    begin



	   insert into
			     dbo.CWRH_WRH_INCOME_ORDER_MASTER 
            ( number 
			, date_created, total, is_verified
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @v_number
			, @p_date_created, @p_total,  @v_is_verified
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();


    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_ORDER_MASTER set
		 number = @v_number
		,date_created = @p_date_created
		,total = @p_total
		,is_verified = @v_is_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id


	  if (@@tranCount > @v_TrancountOnEntry)
        commit

    
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


