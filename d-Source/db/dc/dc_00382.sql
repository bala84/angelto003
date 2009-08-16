
:r ./../_define.sql

:setvar dc_number 00382
:setvar dc_description "func to inquire ts added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.09.2008 VLavrentiev  func to inquire ts added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go




drop procedure dbo.uspVWFE_Inquire_ts_by_car_id
go 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[utfVWFE_Inquire_ts_by_car_id]
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
)
returns table
AS

return
( 
select top(1) 
  id, ts_type_master_id
from(
select id, ts_type_master_id, ordered from(
select top(1) ts_type_master_id, a.ordered, id 
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (
select b2.ordered, b2.ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2
				  where b2.id = (select ts_type_route_detail_id
								from dbo.ccar_condition
								where car_id = @p_car_id)
					and ts_type_route_master_id = a.ts_type_route_master_id
) as b
where a.ordered > b.ordered
order by a.ordered asc) as c
union
select id, ts_type_master_id, a.ordered
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (select ordered, ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
				  where id = (select ts_type_route_detail_id
								from dbo.ccar_condition
								where car_id = @p_car_id)
					and ts_type_route_master_id = a.ts_type_route_master_id) as b
where a.ordered = 1) as d
order by ordered desc)
go


GRANT VIEW DEFINITION ON [dbo].[utfVWFE_Inquire_ts_by_car_id] TO [$(db_app_user)]
GO

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


      if (@@tranCount = 0)
        begin transaction 

	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

--Попробуем обновить ТО, если это ТО
select @v_ts_type_master_id = id
  from dbo.ccar_ts_type_master where id = @p_repair_type_master_id 


if (@v_ts_type_master_id is not null)
 begin
--Узнаем маршрут ТО
  select @v_ts_type_route_detail_id  = id from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id)

  EXEC	@v_Error = dbo.uspVWFE_CONDITION_Update_ts_ByCar_Id
		@p_car_id = @v_car_id,
		@p_ts_type_master_id = @v_ts_type_master_id,
		@p_ts_type_route_detail_id = @v_ts_type_route_detail_id


   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
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


      if (@@tranCount = 0)
        begin transaction 

	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 

--Попробуем обновить ТО, если это ТО
select @v_ts_type_master_id = id
  from dbo.ccar_ts_type_master where id = @p_repair_type_master_id 


if (@v_ts_type_master_id is not null)
 begin
--Узнаем маршрут ТО
  select @v_ts_type_route_detail_id  = id from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id)

--TODO: Запишем состояние автомобиля, если у нас обновились данные 
  EXEC	@v_Error = dbo.uspVWFE_CONDITION_Update_ts_ByCar_Id
		@p_car_id = @v_car_id,
		@p_ts_type_master_id = @v_ts_type_master_id,
		@p_ts_type_route_detail_id = @v_ts_type_route_detail_id


   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
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

ALTER FUNCTION [dbo].[utfVCAR_CONDITION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CCAR_CONDITION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
( @p_start_date	datetime			
 ,@p_end_date	datetime	
 ,@p_car_type_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id	  
		  ,b.state_number
		  ,a.ts_type_master_id
		  ,f.short_name as ts_type_name
		  ,g.short_name + ' - ' + h.short_name as car_mark_model_name
		  ,g.id	as car_mark_id
		  ,h.id as car_model_id
		  ,a.employee_id
		  ,e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as FIO
		  ,b.car_state_id
		  ,c.short_name as car_state_name
		  ,b.car_type_id
		  ,a.run
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.last_ts_type_master_id
		  ,'E' as edit_state
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,'N'  as sent_to
		  ,a.last_run
		  ,isnull(a.overrun, 0) as overrun
		  ,a.in_tolerance
		  ,a.ts_type_route_detail_id
		  ,a.last_ts_type_route_detail_id
		  ,f.tolerance
      FROM dbo.CCAR_CONDITION as a
		JOIN dbo.CCAR_CAR as b on a.car_id = b.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on b.car_state_id = c.id
		JOIN dbo.CCAR_CAR_MARK as g on b.car_mark_id = g.id
		JOIN dbo.CCAR_CAR_MODEL as h on b.car_model_id = h.id
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as d on a.employee_id = d.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as e on d.person_id = e.id
        LEFT OUTER JOIN dbo.CCAR_TS_TYPE_MASTER as f on a.ts_type_master_id = f.id
	  WHERE b.car_type_id = @p_car_type_id
	 -- AND a.sys_date_modified >= @p_start_date
	 -- AND a.sys_date_modified <= @p_end_date	 

)
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
		  ,ts_type_master_id
		  ,ts_type_name
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
		  ,case when run - (ts_run + min_periodicity) <= tolerance then 1 
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

ALTER procedure [dbo].[uspVHIS_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об истории состояний автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
	,@p_date_created				datetime      = null
	,@p_action						smallint
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
	,@p_overrun					    decimal(18,9)		  = 0
	,@p_in_tolerance				bit			  = 0
	,@p_ts_type_route_detail_id		numeric(38,0) = null
	,@p_last_ts_type_route_detail_id numeric(38,0) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
         , @v_sex bit

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

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

	 if (@p_overrun is null)
	set @p_overrun = 0

	 if (@p_in_tolerance is null)
	set @p_in_tolerance = 0

	 if (@p_date_created is null)
	set @p_date_created = getdate();

   if (@p_id is null)
	begin
	insert into dbo.CHIS_CONDITION 
     (date_created, action, car_id, ts_type_master_id, employee_id
	  , run, last_run, last_ts_type_master_id, speedometer_start_indctn, speedometer_end_indctn
	  , fuel_start_left, fuel_end_left, edit_state, sent_to, overrun, in_tolerance
	  , ts_type_route_detail_id, last_ts_type_route_detail_id,	sys_comment, sys_user_created, sys_user_modified)
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance
	,@p_ts_type_route_detail_id, @p_last_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user
       
	  set @p_id = scope_identity();
	end
   else
	begin

	  update dbo.CHIS_CONDITION
	   set date_created				= @p_date_created
		 , action					= @p_action
		 , car_id					= @p_car_id
		 , ts_type_master_id		= @p_ts_type_master_id
		 , employee_id				= @p_employee_id
		 , run						= @p_run
		 , last_run					= @p_last_run
		 , last_ts_type_master_id	= @p_last_ts_type_master_id
		 , speedometer_start_indctn	= @p_speedometer_start_indctn
		 , speedometer_end_indctn	= @p_speedometer_end_indctn
		 , fuel_start_left			= @p_fuel_start_left
		 , fuel_end_left			= @p_fuel_end_left
		 , edit_state				= @p_edit_state
		 , sent_to					= @p_sent_to
		 , overrun					= @p_overrun
		 , in_tolerance				= @p_in_tolerance
		 , ts_type_route_detail_id  = @p_ts_type_route_detail_id
		 , last_ts_type_route_detail_id  = @p_last_ts_type_route_detail_id
		 , sys_comment				= @p_sys_comment
		 , sys_user_created			= @p_sys_user
		 , sys_user_modified		= @p_sys_user
	  where id = @p_id

    end
  

	return 

end
go


alter table dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
add ts_type_route_detail_id numeric(38,0)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид маршрута ТО',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', 'column', 'ts_type_route_detail_id'
go



alter table dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
   add constraint CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_TS_TYPE_ROUTE_DETAIL_ID_FK foreign key (ts_type_route_detail_id)
      references dbo.CCAR_TS_TYPE_ROUTE_DETAIL (id)
go


create index IFK_TS_TYPE_ROUTE_DETAIL_ID_WRH_ORDER_MASTER_REPAIR_TYPE_MASTER
on dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER(ts_type_route_detail_id)
on $(fg_idx_name)
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
  select @v_ts_type_route_detail_id  = id from dbo.utfVWFE_Inquire_ts_by_car_id(@v_car_id)


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
       
  
  return 

end
go




insert into dbo.csys_const (id, name, description)
values (1, 'ORDER_CLOSED', 'Состояние заказа-наряда - закрыт')

insert into dbo.csys_const (id, name, description)
values (4, 'ORDER_APPROVED', 'Состояние заказа-наряда - обработан')

go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[utfVWFE_Check_last_order_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна извлекать данные о прошедшем ТО по заказу-наряду
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
)
returns table
AS

return
( 
select top(1) a.ts_type_route_detail_id
from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
	join dbo.CWRH_WRH_ORDER_MASTER as b on a.wrh_order_master_id = b.id
where b.car_id = @p_car_id
  and (b.order_state = dbo.usfConst('ORDER_CLOSED')
	 or b.order_state = dbo.usfConst('ORDER_APPROVED'))
  and a.ts_type_route_detail_id is not null
order by b.date_created desc)
go


GRANT VIEW DEFINITION ON [dbo].[utfVWFE_Check_last_order_ts_by_car_id] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
)
returns table
AS

return
( 
select top(1) a.ts_type_route_detail_id
from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as a
	join dbo.CWRH_WRH_ORDER_MASTER as b on a.wrh_order_master_id = b.id
where b.car_id = @p_car_id
  and (b.order_state = dbo.usfConst('ORDER_CLOSED')
	 or b.order_state = dbo.usfConst('ORDER_APPROVED'))
  and a.ts_type_route_detail_id is not null
  and ((b.date_created <= @p_date_created) or (@p_date_created is null))
order by b.date_created desc)
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
,@p_date_created datetime
)
returns table
AS

return
( 
select top(1) 
  id, ts_type_master_id
from(
select id, ts_type_master_id, ordered from(
select top(1) ts_type_master_id, a.ordered, id 
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (
select b2.ordered, b2.ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2
				  where b2.id = (select id from utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created))
					and ts_type_route_master_id = a.ts_type_route_master_id
) as b
where a.ordered > b.ordered
order by a.ordered asc) as c
union
select id, ts_type_master_id, a.ordered
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (select ordered, ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
				  where id = (select id from utfVWFE_Check_last_order_ts_by_car_id(@p_car_id, @p_date_created))
					and ts_type_route_master_id = a.ts_type_route_master_id) as b
where a.ordered = 1) as d
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
select id, ts_type_master_id, ordered from(
select top(1) ts_type_master_id, a.ordered, id 
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (
				select b2.ordered, b2.ts_type_route_master_id
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
) as b
where a.ordered > b.ordered
order by a.ordered asc) as c
union
select id, ts_type_master_id, a.ordered
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (select b2.ordered, b2.ts_type_route_master_id
				  from dbo.ccar_car as g
					join dbo.ccar_car_model as e on  e.id = g.car_model_id
					join dbo.CCAR_TS_TYPE_ROUTE_MASTER as d on e.ts_type_route_master_id = d.id
					join dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2 on d.id = b2.ts_type_route_master_id  											
				  where g.id = @p_car_id
					and b2.ts_type_route_master_id = a.ts_type_route_master_id) as b
where a.ordered = 1) as d
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
