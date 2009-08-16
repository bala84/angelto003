:r ./../_define.sql

:setvar dc_number 00208
:setvar dc_description "check ts type fixed#3"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    20.04.2008 VLavrentiev  check ts type fixed#3
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


SELECT GETDATE() as start_time
go

PRINT ' '
select SYSTEM_USER as "user"
go
PRINT ' '
go


alter table dbo.CCAR_CONDITION
add ts_type_route_detail_id numeric(38,0)
go

alter table dbo.CCAR_CONDITION
add last_ts_type_route_detail_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид этапа маршрута',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'ts_type_route_detail_id'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид предыдущего этапа маршрута',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'last_ts_type_route_detail_id'
go


alter table CCAR_CONDITION
   add constraint CCAR_CONDITION_TS_TYPE_ROUTE_DETAIL_ID_FK foreign key (ts_type_route_detail_id)
      references CCAR_TS_TYPE_ROUTE_DETAIL (id)
go



alter table CCAR_CONDITION
   add constraint CCAR_CONDITION_LAST_TS_TYPE_ROUTE_DETAIL_ID_FK foreign key (last_ts_type_route_detail_id)
      references CCAR_TS_TYPE_ROUTE_DETAIL (id)
go


alter table dbo.CHIS_CONDITION
add ts_type_route_detail_id numeric(38,0)
go

alter table dbo.CHIS_CONDITION
add last_ts_type_route_detail_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид этапа маршрута',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'ts_type_route_detail_id'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид предыдущего этапа маршрута',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'last_ts_type_route_detail_id'
go


create index ifk_ts_type_route_detail_id_ccar_condition on dbo.CCAR_CONDITION(ts_type_route_detail_id)
on $(fg_idx_name)
go

create index ifk_last_ts_type_route_detail_id_ccar_condition on dbo.CCAR_CONDITION(last_ts_type_route_detail_id)
on $(fg_idx_name)
go


create index ifk_ts_type_route_detail_id_chis_condition on dbo.CHIS_CONDITION(ts_type_route_detail_id)
on $(fg_idx_name)
go


create index ifk_last_ts_type_route_detail_id_chis_condition on dbo.CHIS_CONDITION(last_ts_type_route_detail_id)
on $(fg_idx_name)
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
	/*select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, a.id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
    from dbo.CCAR_TS_TYPE_MASTER as a
	where a.id = @p_last_ts_type_master_id and @p_sent_to = 'Y'
    union*/
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, b.child_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance
	,@p_ts_type_route_detail_id, @p_last_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user
	from dbo.CCAR_TS_TYPE_RELATION as b
	where b.parent_id = @p_last_ts_type_master_id and @p_sent_to = 'Y'
	union
	select @p_date_created, @p_action, @p_car_id, @p_ts_type_master_id, @p_employee_id
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @p_edit_state, @p_sent_to, @p_overrun, @p_in_tolerance
	,@p_ts_type_route_detail_id, @p_last_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user
       
	  set @p_id = scope_identity();
	end
   else
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

    
  return 

end
GO


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
GO



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
		  ,convert(decimal(18,0), overrun, 128) as overrun
		  ,in_tolerance
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))
	
  RETURN
GO



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
		  ,convert(decimal(18,0), overrun, 128) as overrun
		  ,in_tolerance	
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))

	RETURN
GO


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
  

   declare @v_Error int
         , @v_TrancountOnEntry int
	     , @v_action smallint
		 , @v_ts_type_master_id numeric(38,0)
		 , @v_overrun decimal(18,9)
		 , @v_run decimal(18,9)
		 , @v_in_tolerance bit
	 
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
	,@p_run, @p_last_run, @p_last_ts_type_master_id, @p_speedometer_start_indctn, @p_speedometer_end_indctn
	,@p_fuel_start_left, @p_fuel_end_left, @v_overrun, @v_in_tolerance
	, @p_ts_type_route_detail_id, @p_last_ts_type_route_detail_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
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

    exec @v_Error = 
        dbo.uspVCAR_CONDITION_Check_ts_type
        	 @p_run						= @v_run
			,@p_car_id					= @p_car_id
    		,@p_overrun					= @v_overrun out
			,@p_ts_type_master_id       = @v_ts_type_master_id out
			,@p_in_tolerance			= @v_in_tolerance out
			,@p_last_ts_type_master_id	= @p_last_ts_type_master_id
			,@p_sent_to					= @p_sent_to

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 

	  if (@v_in_tolerance is null)
		set @v_in_tolerance = 0

		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = @v_ts_type_master_id
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
		,speedometer_start_indctn = @p_speedometer_start_indctn
		,speedometer_end_indctn = @p_speedometer_end_indctn
		,fuel_start_left = @p_fuel_start_left
		,fuel_end_left = @p_fuel_end_left
		,overrun = @v_overrun
		,in_tolerance = @v_in_tolerance
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
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn
			,@p_edit_state					= @p_edit_state 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_sent_to						= @p_sent_to
			,@p_overrun						= @v_overrun
			,@p_in_tolerance				= @v_in_tolerance
			,@p_ts_type_route_detail_id		= @p_ts_type_route_detail_id	
			,@p_last_ts_type_route_detail_id= @p_last_ts_type_route_detail_id
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
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_Check_ts_type] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура проверяет предстоящее ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_run						decimal(18,9)
,@p_car_id					numeric (38,0)		
,@p_overrun				    decimal(18,9) out
,@p_ts_type_master_id		decimal(18,9) out
,@p_in_tolerance			bit  = 0 out
,@p_last_ts_type_master_id	numeric (38,0) = null	
,@p_sent_to					char(1)
)
AS
BEGIN

SET NOCOUNT ON

DECLARE  @v_periodicity							numeric(38,0)
		,@v_temp_ts_type_master_id				numeric(38,0)
		,@v_prev_ts_type_route_detail_id		numeric(38,0)
		,@v_prev_last_ts_type_route_detail_id	numeric(38,0)
		,@v_ts_type_route_detail_id				numeric(38,0)
		,@v_last_ts_type_route_detail_id		numeric(38,0)
		,@v_is_overrun							bit
	
if (@p_in_tolerance is null)
	set @p_in_tolerance = 0


--if (@p_sent_to = 'Y')
 -- begin


	select TOP(1) @v_prev_ts_type_route_detail_id = ts_type_route_detail_id
			     ,@v_prev_last_ts_type_route_detail_id = last_ts_type_route_detail_id	
	  from dbo.CHIS_CONDITION
	 where car_id = @p_car_id
	  and ts_type_master_id is not null
	  and last_ts_type_master_id is not null
	 order by date_created desc
 --Присвоим значения точек входа, в случае отправки на ТО
 --Поскольку при отправке мы еще не знаем предстоящее ТО
	set @v_ts_type_route_detail_id = @v_prev_ts_type_route_detail_id
	set @v_last_ts_type_route_detail_id = @v_prev_last_ts_type_route_detail_id
  --end
--else
 -- begin
   -- set @v_ts_type_master_id = @p_ts_type_master_id
	--set @v_last_ts_type_master_id = @p_last_ts_type_master_id
 -- end
   

--Найдем следующий ТО, по списку очередности ТО
--в случае отправки на ТО
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
and (
(a.ordered > (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.id = @v_ts_type_route_detail_id)
	 and @p_sent_to = 'Y')
     or
     (a.ordered = (select a2.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a2
					where b.id = a2.ts_type_route_master_id
					  and a2.id = @v_ts_type_route_detail_id)
	 and @p_sent_to = 'N'))
and ((a.ordered > (select a3.ordered
					from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a3
					where b.id = a3.ts_type_route_master_id
					  and a3.id = @v_last_ts_type_route_detail_id)
	 and @p_sent_to = 'Y')
	or @p_sent_to = 'N')
order by a.ordered asc


--Найдем первый элемент, если следующего или необходимого нет
if (@v_temp_ts_type_master_id is null)
select TOP(1) @v_temp_ts_type_master_id = a.ts_type_master_id
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
  join dbo.CCAR_TS_TYPE_ROUTE_MASTER as b
		on a.ts_type_route_master_id = b.id
where exists
		(select 1 from dbo.CCAR_CAR_MODEL as c
			where b.id = c.ts_type_route_master_id
			  and c.id = (select car_model_id from dbo.CCAR_CAR
											  where id = @p_car_id))
order by a.ordered asc

--Если ничего нет в очередности, то не считаем
if (@v_temp_ts_type_master_id is null)
	begin
	  set @p_ts_type_master_id = null
	 -- return @p_ts_type_master_id
	end



--Попробуем найти ТО с перепробегом 	
select        @p_ts_type_master_id = id 
			 ,@p_overrun =  delta
			 ,@v_is_overrun = 1
from
(select 
 a.id
,@p_run as run
,a.periodicity as periodicity
,isnull((
		select top(1) @p_run - (c.run + a.periodicity)
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'
		 --and c.run < (c.run + a.periodicity)		 
		 order by date_created desc)
		,@p_run -(floor(@p_run/a.periodicity)*a.periodicity)) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where a.id = @v_temp_ts_type_master_id
  and @p_run > a.periodicity) as a
where a.delta > 0
 and not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run - a.periodicity--((ceiling(a.run/a.periodicity)-2)*a.periodicity)
		   and b.run <= a.run
		   and b.last_ts_type_master_id = a.id
	)

--В случае если мы не перескочили проверки, попробуем найти то без перепробега
if (@v_is_overrun is null) 


select       @p_ts_type_master_id = id
			 ,@p_in_tolerance = case when delta <= tolerance
									 then 1
									 else 0
								end 
			 ,@p_overrun = - delta
from
(select id, @p_run as run, a.periodicity as periodicity, a.tolerance
,isnull
(
(
		select top(1) (c.run + a.periodicity) - @p_run   
		from dbo.chis_condition as c
		where c.car_id = @p_car_id
		 and c.last_ts_type_master_id = a.id
		 and c.sent_to = 'Y'		 
		 order by date_created desc)
		,(ceiling(case @p_run 
						when 0
						then 1
						else @p_run
				  end/a.periodicity)*a.periodicity) - @p_run
			) as delta
from dbo.CCAR_TS_TYPE_MASTER as a
where @p_run >= 0 and a.id = @v_temp_ts_type_master_id) as a
where 
not exists 
	(
		select 1 from dbo.chis_condition as b
		 where b.car_id = @p_car_id
		   and b.date_created < getdate()
		   and b.sent_to = 'Y'
		   and b.run  > a.run 
		   and b.run <= a.run + a.periodicity
		   and b.last_ts_type_master_id = a.id
	)

END
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
