:r ./../_define.sql

:setvar dc_number 00251
:setvar dc_description "driver list last_day fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    17.05.2008 VLavrentiev  driver list last_day fix
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


alter table dbo.CDRV_DRIVER_LIST
add last_date_created datetime
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Последняя дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'last_date_created'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVDRV_DRIVER_LIST] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения путевых листов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_start_date	datetime			
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
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,b.state_number
		  ,c.short_name + ' - ' + d.short_name as car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,f.lastname + ' ' + substring(f.name,1,1) + '.' + isnull(substring(f.surname,1,1) + '.','') as FIO_DRIVER1
		  ,f2.lastname + ' ' + substring(f2.name,1,1) + '.' + isnull(substring(f2.surname,1,1) + '.','') as FIO_DRIVER2
		  ,k.fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,g.short_name as driver_list_state_name
		  ,a.driver_list_type_id
		  ,h.short_name as driver_list_type_name
		  ,a.organization_id
		  ,i.name as org_name
		  ,a.fuel_type_id
		  ,j.short_name as fuel_type_name
		  ,a.fuel_exp
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,a.fuel_gived
		  ,a.fuel_return
		  ,a.fuel_addtnl_exp
		  ,null as last_run
		  ,a.run
		  ,a.fuel_consumption
		  ,l.id as condition_id
		  ,null as edit_state
		  ,l.employee_id
		  ,last_date_created
      FROM dbo.CDRV_DRIVER_LIST as a
		JOIN dbo.CCAR_CAR as b on  a.car_id = b.id
		JOIN dbo.CCAR_FUEL_TYPE as j on a.fuel_type_id = j.id
		JOIN dbo.CCAR_CAR_MARK as c on b.car_mark_id = c.id
		JOIN dbo.CCAR_CAR_MODEL as d on b.car_model_id = d.id
		JOIN dbo.CPRT_EMPLOYEE as e on a.employee1_id = e.id
		JOIN dbo.CPRT_PERSON as f on e.person_id = f.id
        JOIN dbo.CDRV_DRIVER_LIST_STATE as g on a.driver_list_state_id = g.id
		JOIN dbo.CDRV_DRIVER_LIST_TYPE as h on a.driver_list_type_id = h.id
		JOIN dbo.CPRT_ORGANIZATION as i on a.organization_id = i.id
		JOIN dbo.CCAR_FUEL_MODEL as k on (d.id = k.car_model_id 
									 and j.id = k.fuel_type_id
									 and k.season = case when month(a.date_created) in (11,12,1,2,3)
														 then dbo.usfConst('WINTER_SEASON')
														 when month(a.date_created) in (4,5,6,7,8,9,10)
														 then dbo.usfConst('SUMMER_SEASON')
													end)
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as e2 on a.employee2_id = e2.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as f2 on e2.person_id = f2.id
		LEFT OUTER JOIN dbo.CCAR_CONDITION as l on b.id = l.car_id
	  WHERE b.car_type_id = @p_car_type_id
	    AND a.date_created >= @p_start_date
	    AND a.date_created <= @p_end_date	

)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_LIST_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о путевых листах легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
	DECLARE
		@p_car_type_id numeric(38,0) 
	   ,@v_Srch_Str      varchar(1000)

	set @p_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,a.fio_driver1
		  ,a.fio_driver2
		  ,convert(decimal(18,3), a.fuel_norm, 128) as fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,a.driver_list_state_name
		  ,a.driver_list_type_id
		  ,a.driver_list_type_name
		  ,a.organization_id
		  ,a.org_name
		  ,a.fuel_type_id
		  ,a.fuel_type_name
		  ,convert(decimal(18,3), a.fuel_exp, 128) as fuel_exp 
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left 
		  ,convert(decimal(18,0), a.fuel_gived, 128) as fuel_gived
		  ,convert(decimal(18,0), a.fuel_return, 128) as fuel_return
		  ,convert(decimal(18,0), a.fuel_addtnl_exp, 128) as fuel_addtnl_exp 
		  ,a.last_run
		  ,convert(decimal(18,0), a.run , 128) as run
		  ,convert(decimal(18,0), a.fuel_consumption, 128) as fuel_consumption 
		  ,a.condition_id
		  ,a.edit_state
		  ,a.employee_id
		  ,last_date_created
	FROM dbo.utfVDRV_DRIVER_LIST(@p_start_date, @p_end_date, @p_car_type_id) as a
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

ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_LIST_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о путевых листах грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
	DECLARE
		@p_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000) 

	set @p_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,a.fio_driver1
		  ,a.fio_driver2
		  ,convert(decimal(18,3),a.fuel_norm, 128) as fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,a.driver_list_state_name
		  ,a.driver_list_type_id
		  ,a.driver_list_type_name
		  ,a.organization_id
		  ,a.org_name
		  ,a.fuel_type_id
		  ,a.fuel_type_name	
		  ,convert(decimal(18,3), a.fuel_exp, 128) as fuel_exp 
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left 
		  ,convert(decimal(18,0), a.fuel_gived, 128) as fuel_gived
		  ,convert(decimal(18,0), a.fuel_return, 128) as fuel_return
		  ,convert(decimal(18,0), a.fuel_addtnl_exp, 128) as fuel_addtnl_exp 
		  ,a.last_run
		  ,convert(decimal(18,0),a.run, 128) as run
		  ,convert(decimal(18,0),a.fuel_consumption, 128) as fuel_consumption 
		  ,a.condition_id
		  ,a.edit_state
		  ,a.employee_id
		  ,last_date_created
	FROM dbo.utfVDRV_DRIVER_LIST(@p_start_date, @p_end_date, @p_car_type_id) as a
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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id							numeric(38,0) = null out
    ,@p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id		numeric(38,0)
	,@p_driver_list_type_id			numeric(38,0)
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9) = 0.0	
	,@p_speedometer_end_indctn		decimal(18,9) = 0.0
	,@p_fuel_start_left				decimal(18,9) = 0.0
	,@p_fuel_end_left				decimal(18,9) = 0.0
	,@p_fuel_gived					decimal(18,9) = 0.0
	,@p_fuel_return					decimal(18,9) = 0.0
	,@p_fuel_addtnl_exp				decimal(18,9) = 0.0
	,@p_last_run					decimal(18,9) = 0.0
	,@p_run							decimal(18,9)= 0.0
	,@p_fuel_consumption			decimal(18,9) = 0.0
	,@p_condition_id				numeric (38,0) = null out
	,@p_edit_state					char(1) = null
	,@p_employee_id					numeric (38,0) = null
	,@p_last_date_created			datetime	= null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_fuel_exp is null)
    set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	 if (@p_speedometer_end_indctn is null)		
    set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null) 
	set @p_fuel_end_left = 0.0

	 if (@p_fuel_gived is null)
    set @p_fuel_gived = 0.0

	 if (@p_fuel_return	is null)
	set @p_fuel_return = 0.0

	 if (@p_fuel_addtnl_exp is null)
    set @p_fuel_addtnl_exp = 0.0

	 if (@p_run is null)
    set @p_run = 0.0

	 if (@p_fuel_consumption is null)
	set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавлять
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   
				
				insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ(sys_comment)
				values('seq_gen')

				set @p_number = scope_identity()
			end 
	 	
	   		insert into
			     dbo.CDRV_DRIVER_LIST 
            		(date_created, number, car_id, fact_start_duty, fact_end_duty
			,driver_list_state_id, driver_list_type_id, fuel_exp
			,fuel_type_id, organization_id, employee1_id, employee2_id
			,speedometer_start_indctn,speedometer_end_indctn
		    ,fuel_start_left, fuel_end_left, fuel_gived, fuel_return
			,fuel_addtnl_exp, run, fuel_consumption, last_date_created
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption, @p_last_date_created
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
  begin	
	update dbo.CDRV_DRIVER_LIST set
		date_created = @p_date_created
	  , number = @p_number
	  , car_id = @p_car_id
	  , fact_start_duty = @p_fact_start_duty
	  , fact_end_duty = @p_fact_end_duty
	  , driver_list_state_id = @p_driver_list_state_id
	  , driver_list_type_id = @p_driver_list_type_id
	  , fuel_exp = @p_fuel_exp
	  , fuel_type_id = @p_fuel_type_id
	  , organization_id = @p_organization_id
	  , employee1_id = @p_employee1_id
      , employee2_id = @p_employee2_id
	  , speedometer_start_indctn = @p_speedometer_start_indctn
	  , speedometer_end_indctn = @p_speedometer_end_indctn
	  , fuel_start_left = @p_fuel_start_left
	  , fuel_end_left = @p_fuel_end_left
	  , fuel_gived = @p_fuel_gived
	  , fuel_return = @p_fuel_return
	  , fuel_addtnl_exp = @p_fuel_addtnl_exp
	  , run = @p_run
	  , fuel_consumption = @p_fuel_consumption
	  , last_date_created = @p_last_date_created
	  , sys_comment = @p_sys_comment
      , sys_user_modified = @p_sys_user
	where ID = @p_id
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)

	if (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
-- Убедимся, что при отсутствии изменений мы не увеличим пробег
	if (@p_condition_id is not null) and (@p_edit_state <> 'E')
		set @p_run = 0
  end
  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @p_run
    		,@p_last_run			= @p_last_run
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 

if (dbo.usfUtils_TimeToZero(@p_date_created) = dbo.usfUtils_TimeToZero(@p_last_date_created))
set @p_last_date_created = null
--Отчеты
exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp	
	,@p_run							= @p_run	
	,@p_fuel_consumption			= @p_fuel_consumption
	,@p_last_date_created			= @p_last_date_created
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 

exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @p_date_created	  
	,@p_employee_id			= @p_employee1_id
	,@p_last_date_created			= @p_last_date_created
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

ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_LIST_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о путевом листе
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_id			numeric(38,0)
,@p_start_date	datetime
,@p_end_date	datetime
,@p_car_type_id	numeric(38,0)
)
AS
SET NOCOUNT ON

       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,a.state_number
		  ,a.car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,a.fio_driver1
		  ,a.fio_driver2
		  ,convert(decimal(18,3), a.fuel_norm, 128) as fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,a.driver_list_state_name
		  ,a.driver_list_type_id
		  ,a.driver_list_type_name
		  ,a.organization_id
		  ,a.org_name
		  ,a.fuel_type_id
		  ,a.fuel_type_name
		  ,convert(decimal(18,3), a.fuel_exp, 128) as fuel_exp 
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left 
		  ,convert(decimal(18,0), a.fuel_gived, 128) as fuel_gived
		  ,convert(decimal(18,0), a.fuel_return, 128) as fuel_return
		  ,convert(decimal(18,0), a.fuel_addtnl_exp, 128) as fuel_addtnl_exp 
		  ,convert(decimal(18,0),a.run, 128) as run
		  ,convert(decimal(18,0),a.fuel_consumption, 128) as fuel_consumption 
		  ,a.condition_id
		  ,a.employee_id
		  ,last_date_created
	FROM dbo.utfVDRV_DRIVER_LIST(@p_start_date, @p_end_date, @p_car_type_id) as a
	WHERE a.id = @p_id

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по сотрудникам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_last_date_created	datetime		= null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
  
  declare
	 @v_person_id			numeric(38,0)
	,@v_lastname			varchar(100)
	,@v_name				varchar(60)
	,@v_surname				varchar(60)
	,@v_organization_id		numeric(38,0)
	,@v_organization_sname	varchar(30)
	,@v_employee_type_id	numeric(38,0)
	,@v_employee_type_sname	varchar(30)


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


  select @v_person_id = person_id
		,@v_organization_id = organization_id
		,@v_employee_type_id = employee_type_id
    from dbo.CPRT_EMPLOYEE
	where id = @p_employee_id

  select @v_lastname = lastname
		,@v_name = name
		,@v_surname = surname
	from dbo.CPRT_PERSON
	where id = @v_person_id

  select @v_organization_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @v_organization_id

  select @v_employee_type_sname = short_name
	from dbo.CPRT_EMPLOYEE_TYPE
	where id = @v_employee_type_id

      if (@@tranCount = 0)
        begin transaction 

exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

if (@p_last_date_created is not null)
begin
  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_last_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

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




