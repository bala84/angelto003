
:r ./../_define.sql

:setvar dc_number 00472
:setvar dc_description "car condition fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   10.06.2009 VLavrentiev   car condition fix
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



drop trigger TAIUD_CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
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




