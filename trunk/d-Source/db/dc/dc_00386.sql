:r ./../_define.sql

:setvar dc_number 00386
:setvar dc_description "select condition fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.09.2008 VLavrentiev  select condition fixed
*******************************************************************************/ 
use [$(db_name)]
GO

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
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,(select ts_type_master_id from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3)) 
							as ts_type_master_id
		  ,(select b3.short_name from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
									join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3)) 
							as ts_type_name
		  ,car_mark_model_name
		  ,car_mark_id
		  ,car_model_id
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,last_ts_type_master_id
	      ,edit_state
		  ,convert(decimal(18,0), fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,sent_to
		  ,convert(decimal(18,0), last_run, 128) as last_run
		  ,convert(decimal(18,0), run - (ts_run + min_periodicity), 128) as overrun
		  ,case when run - (ts_run + min_periodicity) >= tolerance then 1 
				else 0
			end as in_tolerance
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
	outer apply 
				 (select  min(periodicity) as min_periodicity from dbo.CCAR_TS_TYPE_MASTER as a2
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
												   where e.ts_type_route_master_id = d.id))) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED')))
				  order by b4.date_created desc) as c
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
		     id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,(select ts_type_master_id from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3)) 
							as ts_type_master_id
		  ,(select b3.short_name from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
									join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate(), null, null) as c3)) 
							as ts_type_name
		  ,car_mark_model_name
		  ,car_mark_id
		  ,car_model_id
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,last_ts_type_master_id
	      ,edit_state
		  ,convert(decimal(18,0), fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,sent_to
		  ,convert(decimal(18,0), last_run, 128) as last_run
		  ,convert(decimal(18,0), run - (ts_run + min_periodicity), 128) as overrun
		  ,case when run - (ts_run + min_periodicity) >= tolerance then 1 
				else 0
			end as in_tolerance
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    	outer apply 
				 (select  min(periodicity) as min_periodicity from dbo.CCAR_TS_TYPE_MASTER as a2
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
												   where e.ts_type_route_master_id = d.id))) as b
	outer apply (select top(1) ts_run from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a4
												join dbo.CWRH_WRH_ORDER_MASTER as b4 on a4.wrh_order_master_id = b4.id
					where b4.car_id = a.car_id 
					  and a4.sent_to = 'Y'
					  and ((b4.order_state = dbo.usfConst('ORDER_CLOSED'))
							or (b4.order_state = dbo.usfConst('ORDER_APPROVED')))
				  order by b4.date_created desc) as c
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
										where b3.id = (select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, getdate(), @p_wrh_order_master_id, @p_repair_type_master_id))
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
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить заказ-наряд
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
	,@p_employee_head_id	numeric(38,0) = null
	,@p_employee_worker_id		   numeric(38,0) = null
	,@p_employee_output_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			varchar(100)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc			varchar(4000)
	,@p_repair_zone_master_id		numeric(38,0) = null
	,@p_wrh_order_master_type_id	numeric(38,0) = null
	,@p_run				    decimal(18,9) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	declare
		 @v_order_state smallint
		,@v_Error int
        ,@v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
--Небольшой маршрут состояний заказа-наряда
    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
											 when 'Взят на ремонт, сведений о необх. запчастях нет'
											 then 2
											 when 'Взят на ремонт, есть сведения о необх. запчастях'
											 then 3
											 when 'Обработан'
											 then 4 
											 when 'Отклонен'
											 then 5
						 end


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
  
  if (@@tranCount = 0)
    begin transaction  
       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_ORDER_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, run, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
			, @p_repair_zone_master_id, @p_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_ORDER_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
		,run = @p_run
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
 --Если у машины нет открытого путевого листа 
 
 if (not exists (select top(1) 1 from dbo.cdrv_driver_list
  												where car_id = @p_car_id and speedometer_end_indctn is null))
 begin 
  if (@v_order_state = 0)
 --Если заказ наряд открыт - проставим у машины состояние в ожидании ремонта
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfCONST('IN_WAIT_FOR_REPAIR')
   where id = @p_car_id
  if (@v_order_state = 2) or (@v_order_state = 3)
 --Если заказ-наряд в обработке - проставим у машины состояние в ремзоне
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_REPAIR_ZONE')
   where id = @p_car_id
 --Если закрыт и больше нет других открытых уберем
  if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0 
						   or order_state = 2 
						   or order_state = 3
					      and car_id = @p_car_id
						order by date_created desc))
	  update dbo.CCAR_CAR
		set car_state_id = dbo.usfCONST('IN_PARK')
	    where id = @p_car_id
 end


  exec @v_error = dbo.uspVREP_WRH_ORDER_MASTER_Prepare
   @p_id							= @p_id
  ,@p_number						= @p_number
  ,@p_car_id						= @p_car_id
  ,@p_employee_recieve_id			= @p_employee_recieve_id
  ,@p_employee_head_id				= @p_employee_head_id
  ,@p_employee_worker_id			= @p_employee_worker_id
  ,@p_employee_output_worker_id		= @p_employee_output_worker_id
  ,@p_date_created					= @p_date_created
  ,@p_order_state					= @v_order_state
  ,@p_repair_type_id				= @p_repair_type_id
  ,@p_malfunction_desc				= @p_malfunction_desc
  ,@p_repair_zone_master_id			= @p_repair_zone_master_id
  ,@p_wrh_order_master_type_id		= @p_wrh_order_master_type_id
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  exec @v_error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_Prepare
   @p_car_id						= @p_car_id
  ,@p_date_created					= @p_date_created
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
  return 

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVWFE_CAR_REPAIR_TYPE_GIVEN] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения пройденных машинами ремонтов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		   a.date_created
		  ,a.car_id
		  ,c.state_number
		  ,b.repair_type_master_id
		  ,f.short_name
		  ,a.run
		  ,e.run - (a.run + d.periodicity) as run_to_complete_for_the_next_repair
	  from
		dbo.CWRH_WRH_ORDER_MASTER as a
			join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
			join dbo.CRPR_REPAIR_TYPE_MASTER as f on b.repair_type_master_id = f.id
			join dbo.CCAR_CAR as c on a.car_id = c.id
			join dbo.CCAR_CONDITION as e on c.id = e.car_id
			left outer join dbo.CCAR_TS_TYPE_MASTER as d on b.repair_type_master_id = d.id		
)
go


GRANT VIEW DEFINITION ON [dbo].[utfVWFE_CAR_REPAIR_TYPE_GIVEN] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о заказах-нарядах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  
		   date_created
		  ,car_id
		  ,state_number
		  ,repair_type_master_id
		  ,short_name
		  ,run
		  ,run_to_complete_for_the_next_repair
	FROM utfVWFE_CAR_REPAIR_TYPE_GIVEN() as a
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(short_name))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))  
	 order by run_to_complete_for_the_next_repair desc, state_number asc, short_name asc

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о заказах-нарядах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
,@p_repair_type_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  
		   date_created
		  ,car_id
		  ,state_number
		  ,repair_type_master_id
		  ,short_name
		  ,run
		  ,run_to_complete_for_the_next_repair
	FROM utfVWFE_CAR_REPAIR_TYPE_GIVEN() as a
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(short_name))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))  
	 order by run_to_complete_for_the_next_repair desc, state_number asc, short_name asc

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWFE_CAR_REPAIR_TYPE_GIVEN] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения пройденных машинами ремонтов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		   a.date_created
		  ,a.car_id
		  ,c.state_number
		  ,b.repair_type_master_id
		  ,f.short_name
		  ,a.run
		  ,e.run - (a.run + d.periodicity) as run_to_complete_for_the_next_repair
		  ,case when e.run - (a.run + d.periodicity) >= d.tolerance then 1
				else 0
		   end as in_tolerance 
	  from
		dbo.CWRH_WRH_ORDER_MASTER as a
			join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
			join dbo.CRPR_REPAIR_TYPE_MASTER as f on b.repair_type_master_id = f.id
			join dbo.CCAR_CAR as c on a.car_id = c.id
			join dbo.CCAR_CONDITION as e on c.id = e.car_id
			left outer join dbo.CCAR_TS_TYPE_MASTER as d on b.repair_type_master_id = d.id		
)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о заказах-нарядах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  
		   date_created
		  ,car_id
		  ,state_number
		  ,repair_type_master_id
		  ,short_name
		  ,run
		  ,run_to_complete_for_the_next_repair
		  ,in_tolerance
	FROM utfVWFE_CAR_REPAIR_TYPE_GIVEN() as a
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(short_name))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))  
	 order by run_to_complete_for_the_next_repair desc, state_number asc, short_name asc

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWFE_CAR_REPAIR_TYPE_GIVEN] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения пройденных машинами ремонтов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		   a.date_created
		  ,a.car_id
		  ,c.state_number
		  ,b.repair_type_master_id
		  ,f.short_name
		  ,convert(decimal(18,0),a.run) as run
		  ,case when (select top(1) 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a2
									join dbo.CWRH_WRH_ORDER_MASTER as b2 on a2.wrh_order_master_id = b2.id
									where a2.repair_type_master_id = b.repair_type_master_id
									  and b2.car_id = c.id
						order by b2.date_created desc) = 1 then convert(decimal(18,0), e.run - (a.run + d.periodicity))
				else null
			end as run_to_complete_for_the_next_repair
		  ,case when (select top(1) 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a2
									join dbo.CWRH_WRH_ORDER_MASTER as b2 on a2.wrh_order_master_id = b2.id
									where a2.repair_type_master_id = b.repair_type_master_id
									  and b2.car_id = c.id
						order by b2.date_created desc) = 1 then 
															case when e.run - (a.run + d.periodicity) >= d.tolerance then 1
															else 0
															end
				else null
			end 
				as in_tolerance 
	  from
		dbo.CWRH_WRH_ORDER_MASTER as a
			join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
			join dbo.CRPR_REPAIR_TYPE_MASTER as f on b.repair_type_master_id = f.id
			join dbo.CCAR_CAR as c on a.car_id = c.id
			join dbo.CCAR_CONDITION as e on c.id = e.car_id
			left outer join dbo.CCAR_TS_TYPE_MASTER as d on b.repair_type_master_id = d.id		
)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWFE_CAR_REPAIR_TYPE_GIVEN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о заказах-нарядах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
declare
	  @v_Srch_Str      varchar(1000)

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  
		   date_created
		  ,car_id
		  ,state_number
		  ,repair_type_master_id
		  ,short_name
		  ,run
		  ,run_to_complete_for_the_next_repair
		  ,in_tolerance
	FROM utfVWFE_CAR_REPAIR_TYPE_GIVEN() as a
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(short_name))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))  
	 order by state_number asc, date_created desc, run_to_complete_for_the_next_repair desc, short_name asc

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


