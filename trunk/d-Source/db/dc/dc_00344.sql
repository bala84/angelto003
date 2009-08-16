:r ./../_define.sql

:setvar dc_number 00344
:setvar dc_description "repair by car report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    04.07.2008 VLavrentiev  repair by car report fixed
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


alter table dbo.CCAR_CAR
add organization_id numeric(38,0)
go


create index ifk_organization_id_ccar_car on dbo.CCAR_CAR(organization_id)
go

alter table dbo.CCAR_CAR
   add constraint CCAR_CAR_ORGANIZATION_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности CAR
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
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
		  ,a.state_number
		  ,a.speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,b.short_name as car_type_sname
		  ,a.car_state_id
		  ,c.short_name as car_state_sname
		  ,a.car_mark_id 
		  ,d.short_name as car_mark_sname
		  ,a.car_model_id
		  ,e.short_name as car_model_sname
		  ,a.fuel_type_id	
		  ,f.short_name as fuel_type_sname
		  ,a.car_kind_id
		  ,g.short_name as car_kind_sname
		  ,a.begin_run
		  ,a.last_ts_verified
		  ,h.run as run
		  ,h.speedometer_start_indctn as speedometer_start_indctn
		  ,h.speedometer_end_indctn as speedometer_end_indctn
		  ,h.id as condition_id
		  ,h.fuel_start_left
		  ,h.fuel_end_left
		  ,h.employee_id
		  ,a.card_number
		  ,a.organization_id
		  ,j.name as organization_sname
      FROM dbo.CCAR_CAR as a
		JOIN dbo.CCAR_CAR_KIND as g on a.car_kind_id = g.id
		JOIN dbo.CCAR_CAR_TYPE as b on a.car_type_id = b.id	
		JOIN dbo.CCAR_CAR_MARK as d on a.car_mark_id = d.id
		JOIN dbo.CCAR_CAR_MODEL as e on a.car_model_id = e.id
		JOIN dbo.CCAR_FUEL_TYPE as f on a.fuel_type_id = f.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on a.car_state_id = c.id
		LEFT OUTER JOIN dbo.CCAR_CONDITION as h on a.id = h.car_id
		LEFT OUTER JOIN dbo.CPRT_ORGANIZATION as j on j.id = a.organization_id
)
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о автомобилях
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_Str varchar(100) = null
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
			a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.state_number
		  ,null as last_speedometer_idctn
		  ,convert(decimal(18,0),a.speedometer_idctn,128) as speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,a.car_type_sname
		  ,a.car_state_id
		  ,a.car_state_sname
		  ,a.car_mark_id 
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
		  ,a.fuel_type_id	
		  ,a.fuel_type_sname
		  ,a.car_kind_id
		  ,a.car_kind_sname
		  ,convert(decimal(18,3), b.fuel_norm, 128) as fuel_norm
		  ,null as last_begin_run
		  ,convert(decimal(18,0),a.begin_run, 128) as begin_run
		  ,convert(decimal(18,0),a.run, 128) as run
		  ,convert(decimal(18,0),a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0),a.speedometer_end_indctn, 128) as speedometer_end_indctn 
		  ,a.condition_id
		  ,convert(decimal(18,0),a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0),a.fuel_end_left, 128) as fuel_end_left
		  ,a.employee_id
		  ,a.last_ts_verified
		  ,a.card_number
		  ,a.organization_id
		  ,a.organization_sname
	FROM dbo.utfVCAR_CAR() as a 
	LEFT OUTER JOIN dbo.utfVCAR_FUEL_TYPE() as b on 
										   a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (11,12,1,2,3)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (4,5,6,7,8,9,10)
														   then dbo.usfConst('SUMMER_SEASON')
													  end
    WHERE 
        (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))

	/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */

	RETURN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные об автомобиле
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      06.03.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_id numeric(38,0)
)
AS
SET NOCOUNT ON
  

       SELECT 
			a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.state_number
		  ,null as last_speedometer_idctn
		  ,convert(decimal(18,0), a.speedometer_idctn, 128) as speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,a.car_type_sname
		  ,a.car_state_id
		  ,a.car_state_sname
		  ,a.car_mark_id 
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
		  ,a.fuel_type_id	
		  ,a.fuel_type_sname
		  ,a.car_kind_id
		  ,a.car_kind_sname
		  ,convert(decimal(18,3), b.fuel_norm , 128) as fuel_norm
		  ,null as last_begin_run
		  ,convert(decimal(18,0), a.begin_run, 128) as begin_run
		  ,convert(decimal(18,0), a.run, 128) as run
		  ,convert(decimal(18,0), a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), a.speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,a.condition_id
		  ,convert(decimal(18,0), a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), a.fuel_end_left, 128) as fuel_end_left
		  ,a.employee_id
		  ,a.organization_id
		  ,a.organization_sname
	FROM dbo.utfVCAR_CAR() as a
	LEFT OUTER JOIN dbo.utfVCAR_FUEL_TYPE() as b on 
										   a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (11,12,1,2,3)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (4,5,6,7,8,9,10)
														   then dbo.usfConst('SUMMER_SEASON')
													  end
   WHERE a.id = @p_id

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об автомобиле
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						 numeric(38,0) = null out
    ,@p_state_number			 varchar(20)
	,@p_last_speedometer_idctn	 decimal(18,9)		 = 0.0
    ,@p_speedometer_idctn		 decimal(18,9)      = 0.0
    ,@p_car_type_id				 numeric(38,0)
	,@p_car_state_id			 numeric(38,0)   = null
	,@p_car_mark_id				 numeric(38,0)
	,@p_car_model_id			 numeric(38,0)
	,@p_begin_mntnc_date		 datetime		= null
	,@p_fuel_type_id			 numeric(38,0)
	,@p_car_kind_id				 numeric(38,0)
	,@p_last_begin_run			 decimal(18,9)			= 0.0
	,@p_begin_run				 decimal(18,9)			= 0.0
	,@p_run						 decimal(18,9)		= 0.0
	,@p_speedometer_start_indctn decimal(18,9)			= 0.0
	,@p_speedometer_end_indctn	 decimal(18,9)			= 0.0
	,@p_fuel_start_left			 decimal(18,9)			= 0.0
	,@p_fuel_end_left			 decimal(18,9)			= 0.0
	,@p_condition_id			 numeric(38,0)	= null out
	,@p_employee_id				 numeric(38,0)	= null
	,@p_card_number				 varchar(128)	= null
	,@p_organization_id			 numeric(38,0)	= null
	,@p_sys_comment				 varchar(2000)	= '-'
    ,@p_sys_user				 varchar(30)		= null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_last_ts_verified tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_begin_run is null)
	set @p_begin_run = 0.0

	 if (@p_speedometer_idctn is null)
	set @p_speedometer_idctn = 0.0

	 if (@p_last_begin_run is null)
	set @p_last_begin_run = 0.0
	 
	 if (@p_run is null)
	set @p_run = 0.0

	 if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0
     
         if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0
	 
	 if (@p_last_speedometer_idctn is null)
	set @p_last_speedometer_idctn = 0.0

     
     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction 



       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date, organization_id
			,fuel_type_id, car_kind_id, begin_run, last_ts_verified, card_number
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date, @p_organization_id
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, 0, @p_card_number
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end

		update dbo.CCAR_CAR
		   set last_ts_verified = @v_last_ts_verified
		 where id = @p_id
    end   
       
	    
 else
	begin

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end 
  -- надо править существующий
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		,car_state_id = @p_car_state_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
		,last_ts_verified = @v_last_ts_verified
		,organization_id = @p_organization_id
		,card_number = @p_card_number
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end

   --если у нас еще нет сосотояния автомобиля мы должны выставить правильное конечное показание спидометра равное начальному показанию спидометра
   --проверим правильное состояние
   if (@p_condition_id is null)
	select @p_condition_id = id 
	from dbo.CCAR_CONDITION 
	where car_id = @p_id


	
		exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id							= @p_condition_id
    		,@p_car_id						= @p_id
    		,@p_ts_type_master_id			= null
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_edit_state					= 'E'   
    		,@p_sys_comment					= @p_sys_comment  
  		,@p_sys_user 						= @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 
--	end

  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return 

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготовить данные для отчетов по затратам на автомобили
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.07.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created				datetime
	,@p_car_id						numeric(38,0)
	,@p_last_date_created			datetime = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	@v_Error			int
    ,@v_TrancountOnEntry int

  declare    
	 @v_car_type_id					numeric(38,0)
	,@v_car_type_sname				varchar(30)
	,@v_car_state_id				numeric(38,0)	
	,@v_car_state_sname				varchar(30)
	,@v_car_mark_id					numeric(38,0)
	,@v_car_mark_sname				varchar(30)
	,@v_car_model_id				numeric(38,0)
	,@v_car_model_sname				varchar(30)
	,@v_begin_mntnc_date			datetime
	,@v_fuel_type_id				numeric(38,0)
	,@v_fuel_type_sname				varchar(30)
	,@v_car_kind_id					numeric(38,0)
	,@v_car_kind_sname				varchar(30)
	,@v_state_number				varchar(20)
    ,@v_sys_comment					varchar(2000)
    ,@v_sys_user					varchar(30)	
	,@v_organization_id				numeric(38,0)	
	,@v_organization_sname			varchar(30)				

--if (@@rowcount = 1)
--begin
select 
		  
		   @v_state_number = b.state_number
		  ,@v_car_type_id = b.car_type_id 
		  ,@v_car_type_sname = b.car_type_sname
		  ,@v_car_state_id = b.car_state_id
		  ,@v_car_state_sname = b.car_state_sname	
		  ,@v_car_mark_id = b.car_mark_id
		  ,@v_car_mark_sname = b.car_mark_sname
		  ,@v_car_model_id = b.car_model_id
		  ,@v_car_model_sname = b.car_model_sname
		  ,@v_begin_mntnc_date = b.begin_mntnc_date
	      	  ,@v_fuel_type_id = b.fuel_type_id
	      	  ,@v_fuel_type_sname = b.fuel_type_sname
		  ,@v_car_kind_id = b.car_kind_id
		  ,@v_car_kind_sname = b.car_kind_sname
		  ,@v_organization_id = b.organization_id
		  ,@v_organization_sname = b.organization_sname
	from  dbo.utfVCAR_CAR() as b
	 where  b.id = @p_car_id

exec @v_Error = 
		dbo.uspVREP_CAR_WRH_ITEM_PRICE_Calculate
				 @p_date_created		= @p_date_created
				,@p_state_number		= @v_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @v_car_type_id
				,@p_car_type_sname		= @v_car_type_sname
				,@p_car_state_id		= @v_car_state_id
				,@p_car_state_sname		= @v_car_state_sname
				,@p_car_mark_id			= @v_car_mark_id
				,@p_car_mark_sname		= @v_car_mark_sname
				,@p_car_model_id		= @v_car_model_id
				,@p_car_model_sname		= @v_car_model_sname
				,@p_begin_mntnc_date	= @v_begin_mntnc_date
				,@p_fuel_type_id		= @v_fuel_type_id
				,@p_fuel_type_sname		= @v_fuel_type_sname
				,@p_car_kind_id			= @v_car_kind_id
				,@p_car_kind_sname		= @v_car_kind_sname
				,@p_organization_id		= @v_organization_id
				,@p_organization_sname  = @v_organization_sname
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user
--end			


	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Prepare] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь требования
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_demand_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				decimal(18,9) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int
		  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
		  , @v_organization_id numeric(38,0)
		  , @v_date_created    datetime
		  , @v_car_id numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    --Проставим режим обработки для товара со склада в режим апдейта
	set @v_edit_state = 'U'

    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_DETAIL 
            ( wrh_demand_master_id, good_category_id
			, amount, warehouse_type_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id


  exec @v_Error = 
		dbo.uspVREP_WRH_DEMAND_Calculate
				 @p_id					= null
				,@p_wrh_demand_detail_id= @p_id
				,@p_wrh_demand_master_id= @p_wrh_demand_master_id
				,@p_good_category_id	= @p_good_category_id
				,@p_amount				= @p_amount
				,@p_warehouse_type_id	= @p_warehouse_type_id
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end


select @v_organization_id = a.organization_giver_id
	  ,@v_date_created	  = a.date_created
	  ,@v_car_id		  = a.car_id
from dbo.CWRH_WRH_DEMAND_MASTER as a
where id = @p_wrh_demand_master_id
 

select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id
	 and a.organization_id = @v_organization_id

--Отчет для склада
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare
	    @p_wrh_demand_master_id = @p_wrh_demand_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_warehouse_type_id	= @p_warehouse_type_id
	   ,@p_organization_id = @v_organization_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

--Отчет по затратам на автомобили
 if (@v_car_id is not null)
  begin
   exec @v_Error = 
        dbo.uspVREP_CAR_WRH_ITEM_PRICE_Prepare
	    @p_date_created = @v_date_created
	   ,@p_car_id = @v_car_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

if (@p_last_amount is null) or (@p_last_amount = @p_amount)
	set @p_amount = -@p_amount
else
	set @p_amount = -(@p_amount - @p_last_amount)

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @p_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id 
	   ,@p_edit_state = @v_edit_state
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

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


