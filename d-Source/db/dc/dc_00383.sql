:r ./../_define.sql

:setvar dc_number 00383
:setvar dc_description "condition save fixed to a new version"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.09.2008 VLavrentiev  condition save fixed to a new version
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

ALTER procedure [dbo].[uspVCAR_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные о состоянии автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
    ,@p_car_id		        		numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id					numeric(38,0) = null
    ,@p_run 			    		decimal(18,9)
    ,@p_last_run					decimal(18,9)	      = 0.0
    ,@p_speedometer_start_indctn	decimal(18,9)	      = 0.0
    ,@p_speedometer_end_indctn		decimal(18,9)	      = 0.0 
	,@p_edit_state				    char		  = null
	,@p_last_ts_type_master_id		numeric(38,0) = null
	,@p_fuel_start_left             decimal(18,9)	      = 0.0
	,@p_fuel_end_left               decimal(18,9)	      = 0.0
	,@p_sent_to						char		  = 'N'
	,@p_ts_type_route_detail_id		numeric(38,0) = null
	,@p_last_ts_type_route_detail_id numeric(38,0) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
   set nocount on
   set xact_abort on
  

   declare @v_Error					  int
         , @v_TrancountOnEntry		  int
	     , @v_action				  smallint
		 , @v_ts_type_master_id		  numeric(38,0)
		 , @v_overrun				  decimal(18,9)
		 , @v_run					  decimal(18,9)
		 , @v_in_tolerance			  bit
		 , @v_ts_type_route_detail_id numeric(38,0)
		 , @v_fuel_start_left		  decimal(18,9)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_fuel_end_left			   decimal(18,9)
		 , @v_speedometer_end_indctn   decimal(18,9)
	 
   declare @t_run table (run decimal(18,9), ts_type_master_id numeric(38,0))

      if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_run is null)
	set @p_run = 0.0
	    
     if (@p_last_run is null)
	set @p_last_run = @p_run

     if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0

     if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

     if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

     if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0	

	 if (@p_sent_to is null)
	set @p_sent_to = 'N'

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount

--На всякий случай записывааем только последние показания по машине
	select TOP(1) @v_fuel_start_left = fuel_start_left, @v_speedometer_start_indctn = speedometer_start_indctn
				, @v_fuel_end_left = fuel_end_left, @v_speedometer_end_indctn = speedometer_end_indctn
	from dbo.CDRV_DRIVER_LIST
	where car_id = @p_car_id
	order by date_created desc, fact_end_duty desc

	if (@v_fuel_start_left is null)
	  set @v_fuel_start_left = @p_fuel_start_left

	if (@v_fuel_end_left is null)
	  set @v_fuel_end_left = @p_fuel_end_left

	if (@v_speedometer_start_indctn is null)
	  set @v_speedometer_start_indctn = @p_speedometer_start_indctn


	if (@v_speedometer_end_indctn is null)
	  set @v_speedometer_end_indctn = @p_speedometer_end_indctn





	 if (@@tranCount = 0)
	  begin transaction 

  
    

       -- надо добавлять
  if (@p_id is null)
    begin


	  exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @p_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_ts_type_route_detail_id = @v_ts_type_route_detail_id out
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, overrun, in_tolerance
	  , ts_type_route_detail_id, last_ts_type_route_detail_id, sys_comment, sys_user_created, sys_user_modified)
	    values
	(@p_car_id, @v_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @v_speedometer_start_indctn, @v_speedometer_end_indctn
	,@v_fuel_start_left, @v_fuel_end_left, 0, 0
	, @v_ts_type_route_detail_id, @p_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

	  set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
  -- надо править существующий

	begin
	
    select @v_run = case when @p_edit_state = 'E'
						 then @p_run
						 else run + @p_run 
					end from dbo.CCAR_CONDITION
	where id = @p_id

   /* exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @v_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_ts_type_route_detail_id = @v_ts_type_route_detail_id out
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end */

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = @p_ts_type_master_id
							/*case when @p_sent_to = 'N'
								 then @v_ts_type_master_id
								 when @p_sent_to = 'Y'
								 then @p_ts_type_master_id
							end*/
		,employee_id = @p_employee_id
		-- Добавляем именно нарастающим итогом
		-- Но если укажем @p_edit_state, то можем переписать
		,run = @v_run
		,last_run = @p_last_run
		,last_ts_type_master_id = @p_last_ts_type_master_id
		,speedometer_start_indctn = @v_speedometer_start_indctn
		,speedometer_end_indctn = @v_speedometer_end_indctn
		,fuel_start_left = @v_fuel_start_left
		,fuel_end_left = @v_fuel_end_left
		,overrun = 0
		,in_tolerance = 0
		,ts_type_route_detail_id = @p_ts_type_route_detail_id	
		,last_ts_type_route_detail_id = @p_last_ts_type_route_detail_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		output inserted.run, inserted.ts_type_master_id into @t_run 		
		where ID = @p_id
		

		set @v_action = dbo.usfConst('ACTION_UPDATE')

		select @p_run = run, @v_ts_type_master_id = ts_type_master_id from @t_run

	end


	  exec @v_Error = 
        dbo.uspVHIS_CONDITION_SaveById
        	 @p_action						= @v_action
			,@p_car_id						= @p_car_id
    		,@p_ts_type_master_id			= @v_ts_type_master_id
			,@p_last_ts_type_master_id		= @p_last_ts_type_master_id
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= @p_last_run
    		,@p_speedometer_start_indctn 	= @v_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @v_speedometer_end_indctn
			,@p_edit_state					= @p_edit_state 
			,@p_fuel_start_left				= @v_fuel_start_left
			,@p_fuel_end_left				= @v_fuel_end_left
			,@p_sent_to						= @p_sent_to
			,@p_overrun						= 0
			,@p_in_tolerance				= 0
			,@p_ts_type_route_detail_id		= @v_ts_type_route_detail_id	
			,@p_last_ts_type_route_detail_id= @p_ts_type_route_detail_id
			,@p_sys_comment					= @p_sys_comment  
  			,@p_sys_user					= @p_sys_user

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

ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта для заказа - наряда
**
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

--Узнаем данные о заказе-наряде
	select @v_date_created = date_created
		  ,@v_car_id	   = car_id
	  from dbo.CWRH_WRH_ORDER_MASTER
	where id = @p_wrh_order_master_id


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

--Попробуем обновить ТО, если это ТО
select @v_ts_type_master_id = id
  from dbo.ccar_ts_type_master where id = @p_repair_type_master_id 


if (@v_ts_type_master_id is not null)
--Узнаем маршрут ТО
  select @v_ts_type_route_detail_id  = id from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id, @v_ts_type_master_id, @v_date_created)


	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id, ts_type_route_detail_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id, @v_ts_type_route_detail_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

 if (@@ROWCOUNT = 0)	
	  update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		 set  ts_type_route_detail_id = @v_ts_type_route_detail_id
			 ,sys_user_modified = @p_sys_user
			 ,sys_comment = @p_sys_comment
		where wrh_order_master_id = @p_wrh_order_master_id
			  and repair_type_master_id = @p_repair_type_master_id
       
  
  return 

end
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
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate()) as c3)) 
							as ts_type_master_id
		  ,(select b3.short_name from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
									join dbo.CCAR_TS_TYPE_MASTER as b3 on a3.ts_type_master_id = b3.id
									where a3.id = (select c3.ts_type_route_detail_id from dbo.utfVWFE_Check_last_order_ts_by_car_id(a.car_id, getdate()) as c3)) 
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
	outer apply (select top(1) run as ts_run from dbo.chis_condition
					where car_id = a.car_id 
					  and sent_to = 'Y'
				  order by date_created desc) as c
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

ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта для заказа - наряда
**
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

--Узнаем данные о заказе-наряде
	select @v_date_created = date_created
		  ,@v_car_id	   = car_id
	  from dbo.CWRH_WRH_ORDER_MASTER
	where id = @p_wrh_order_master_id


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

--Попробуем обновить ТО, если это ТО
select @v_ts_type_master_id = id
  from dbo.ccar_ts_type_master where id = @p_repair_type_master_id 


if (@v_ts_type_master_id is not null)
--Узнаем следующий маршрут ТО
  select @v_ts_type_route_detail_id  = id from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id, @v_ts_type_master_id, @v_date_created)


	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id, ts_type_route_detail_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id, @v_ts_type_route_detail_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

 if (@@ROWCOUNT = 0)	
	  update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		 set  ts_type_route_detail_id = @v_ts_type_route_detail_id
			 ,sys_user_modified = @p_sys_user
			 ,sys_comment = @p_sys_comment
		where wrh_order_master_id = @p_wrh_order_master_id
			  and repair_type_master_id = @p_repair_type_master_id
       
  
  return 

end
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
select top(1) ts_type_master_id, a.ordered, id 
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (
				select top(1) b2.ordered, b2.ts_type_route_master_id
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ts_type_master_id = @p_ts_type_master_id
					and b2.ts_type_route_master_id = a.ts_type_route_master_id
				    and b2.ordered > (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where id = (select id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created)))
				order by b2.ordered asc) as b
where a.ordered > b.ordered
order by a.ordered asc) as c
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
from (select top(1) b2.ordered, b2.ts_type_route_master_id
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ts_type_master_id = @p_ts_type_master_id
				    and b2.ordered > (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where b3.id = (select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created)))
				order by b2.ordered asc) as b
	join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a on b.ts_type_route_master_id = a.ts_type_route_master_id
											and b.ordered < a.ordered
order by a.ordered asc) as c
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

create index i_ordered_ts_type_route_detail on dbo.CCAR_TS_TYPE_ROUTE_DETAIL(ordered)
on $(fg_idx_name)
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
				  where g.id = 1002
					and b2.ts_type_master_id = 1003
				    and b2.ordered >= (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where b3.id = (select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(1002, getdate()))
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

--Узнаем данные о заказе-наряде
	select @v_date_created = date_created
		  ,@v_car_id	   = car_id
	  from dbo.CWRH_WRH_ORDER_MASTER
	where id = @p_wrh_order_master_id


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

--Попробуем обновить ТО, если это (основное) ТО
select @v_ts_type_master_id = a.id
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
  select @v_ts_type_route_detail_id  = id 
	from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id, @v_ts_type_master_id, @v_date_created)


	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id, ts_type_route_detail_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id, @v_ts_type_route_detail_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

 if (@@ROWCOUNT = 0)	
	  update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
		 set  ts_type_route_detail_id = @v_ts_type_route_detail_id
			 ,sys_user_modified = @p_sys_user
			 ,sys_comment = @p_sys_comment
		where wrh_order_master_id = @p_wrh_order_master_id
			  and repair_type_master_id = @p_repair_type_master_id
       
  
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
