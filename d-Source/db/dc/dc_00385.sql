:r ./../_define.sql

:setvar dc_number 00385
:setvar dc_description "check last ts fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.09.2008 VLavrentiev  check last ts fixed
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
where b.car_id = @p_car_id
  and (b.order_state = dbo.usfConst('ORDER_CLOSED')
	 or b.order_state = dbo.usfConst('ORDER_APPROVED'))
  and a.ts_type_route_detail_id is not null
  and ((b.date_created <= @p_date_created) or (@p_date_created is null))
  and ((a.wrh_order_master_id != @p_order_master_id
		and a.repair_type_master_id != @p_repair_type_master_id) 
	 or (@p_order_master_id is null
		and @p_repair_type_master_id is null))
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
				  where g.id = 1002
					and b2.ts_type_master_id = 1003
				    and b2.ordered >= (select ordered 
										from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b3
										where b3.id = (select ts_type_route_detail_id 
													from dbo.utfVWFE_Check_last_order_ts_by_car_id(1002, getdate(), @p_wrh_order_master_id, @p_repair_type_master_id))
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

ALTER PROCEDURE [dbo].[uspVRPR_REPAIR_TYPE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о видах ремонта
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null)
AS
SET NOCOUNT ON

DECLARE
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
			id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,code		  
		  ,time_to_repair_in_minutes
		  ,car_mark_sname
		  ,car_model_sname
	FROM dbo.utfVRPR_REPAIR_TYPE_MASTER()
	where (((@p_Str != '')
		   and (rtrim(ltrim(upper(short_name))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by car_mark_sname, car_model_sname, short_name 

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


