:r ./../_define.sql

:setvar dc_number 00390
:setvar dc_description "amount gived in warehouse list added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   14.10.2008 VLavrentiev  amount gived in warehouse list added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_SelectByGood_category_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях приходных документов по товару
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_good_category_id  numeric(38,0)
,@p_organization_id  numeric(38,0)
,@p_start_date		  datetime
,@p_end_date		  datetime
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
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_income_master_id
		  ,a.warehouse_type_id
		  ,a.warehouse_type_sname
		  ,a.date_created
		  ,a.number
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,convert(decimal(18,2), a.total) as total
		  ,convert(decimal(18,2), a.price) as price
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.full_string
		  ,a.organization_recieve_id	
		  ,a.organization_recieve_sname
		  ,a.amount_gived
	FROM dbo.utfVWRH_WRH_INCOME_SelectByGood_category_id(@p_good_category_id) as a
	where /*exists 
		(select 1
			from dbo.CWRH_WAREHOUSE_ITEM as b
			where b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.organization_id = a.organization_recieve_id
			  having sum(b.amount) > 0) 
	  and */
			a.organization_recieve_id = @p_organization_id
	 -- and a.date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		   and ((rtrim(ltrim(upper(a.number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
				or (rtrim(ltrim(upper(a.warehouse_type_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by date_created desc

	RETURN

go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_Check_correct_ts]
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
GO

GRANT EXECUTE ON [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_Check_correct_ts] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_Check_correct_ts] TO [$(db_app_user)]
GO

alter table dbo.cwrh_good_category
add car_mark_id numeric(38,0)
go

alter table dbo.cwrh_good_category
add car_model_id numeric(38,0)
go

create index ifk_car_mark_id_wrh_good_category on dbo.CWRH_GOOD_CATEGORY(car_mark_id)
on $(fg_idx_name)
go

create index ifk_car_model_id_wrh_good_category on dbo.CWRH_GOOD_CATEGORY(car_model_id)
on $(fg_idx_name)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'car_mark_id'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description',                                          
   'Ид модели',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'car_model_id'
go

alter table dbo.CWRH_GOOD_CATEGORY
   add constraint CWRH_GOOD_CATEGORY_CAR_MARK_ID_FK foreign key (car_mark_id)
      references dbo.CCAR_CAR_MARK (id)
go

alter table dbo.CWRH_GOOD_CATEGORY
   add constraint CWRH_GOOD_CATEGORY_CAR_MODEL_ID_FK foreign key (car_model_id)
      references dbo.CCAR_CAR_MODEL (id)
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVWRH_GOOD_CATEGORY] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения категорий товаров
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 

(	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id
		  ,a.organization_id
		  ,b.name as organization_name
		  ,a.good_category_type_id
		  ,c.short_name as good_category_type_sname
		  ,a.car_mark_id
		  ,d.short_name as car_mark_sname
		  ,a.car_model_id
		  ,e.short_name as car_model_sname
		  FROM dbo.CWRH_GOOD_CATEGORY as a
			LEFT OUTER JOIN dbo.CPRT_ORGANIZATION as b
				on a.organization_id = b.id
			LEFT OUTER JOIN dbo.CWRH_GOOD_CATEGORY_TYPE as c
				on a.good_category_type_id = c.id
			left outer join dbo.ccar_car_mark as d
				on a.car_mark_id = d.id
			left outer join dbo.ccar_car_model as e
				on a.car_model_id = e.id)

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVWRH_GOOD_CATEGORY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о категориях товаров
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_Str				  varchar(100) = null
 ,@p_Srch_Type			   tinyint = null 
 ,@p_Top_n_by_rank		   smallint = null)
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
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id	
		  ,a.good_category_type_id
		  ,a.good_category_type_sname
		  ,a.organization_id
		  ,a.organization_name
		  ,a.car_mark_id
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
	FROM dbo.utfVWRH_GOOD_CATEGORY() as a
    WHERE 
(((@p_Str != '')
		   and (rtrim(ltrim(upper(full_name))) like rtrim(ltrim(upper('%' + @p_Str + '%')))
			or rtrim(ltrim(upper(good_mark))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (good_mark, short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.id = KEY_TBL.[KEY]))
			OR (@p_Str = '')) */
	order by good_mark, full_name

	RETURN


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_GOOD_CATEGORY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить товар
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) = null out
	,@p_good_mark				varchar(30)
    ,@p_short_name				varchar(60)
	,@p_full_name				varchar(60)
	,@p_unit					varchar(20)
	,@p_parent_id				numeric(38,0)
	,@p_organization_id			numeric(38,0) = null
	,@p_good_category_type_id	numeric(38,0) = null
	,@p_car_mark_id			    numeric(38,0) = null
	,@p_car_model_id			numeric(38,0) = null    
	,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @p_short_name = @p_full_name

	 if (@p_unit is null)
	set @p_unit = 'шт.'

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, organization_id, good_category_type_id, unit, parent_id, car_mark_id, car_model_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_organization_id, @p_good_category_type_id, @p_unit, @p_parent_id,  @p_car_mark_id, @p_car_model_id, @p_sys_comment, @p_sys_user, @p_sys_user)
	 
    set @p_id = scope_identity() 

   end
  else    
  -- надо править существующий
		update dbo.CWRH_GOOD_CATEGORY set
		 good_mark = @p_good_mark
		,short_name = @p_short_name 
		,full_name = @p_full_name
		,unit = @p_unit
		,parent_id = @p_parent_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[uspVWRH_GOOD_CATEGORY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить товар
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) = null out
	,@p_good_mark				varchar(30)
    ,@p_short_name				varchar(120)
	,@p_full_name				varchar(120)
	,@p_unit					varchar(20)
	,@p_parent_id				numeric(38,0)
	,@p_organization_id			numeric(38,0) = null
	,@p_good_category_type_id	numeric(38,0) = null
	,@p_car_mark_id			    numeric(38,0) = null
	,@p_car_model_id			numeric(38,0) = null    
	,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @p_short_name = @p_full_name

	 if (@p_unit is null)
	set @p_unit = 'шт.'

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, organization_id, good_category_type_id, unit, parent_id, car_mark_id, car_model_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_organization_id, @p_good_category_type_id, @p_unit, @p_parent_id,  @p_car_mark_id, @p_car_model_id, @p_sys_comment, @p_sys_user, @p_sys_user)
	 
    set @p_id = scope_identity() 

   end
  else    
  -- надо править существующий
		update dbo.CWRH_GOOD_CATEGORY set
		 good_mark = @p_good_mark
		,short_name = @p_short_name 
		,full_name = @p_full_name
		,unit = @p_unit
		,parent_id = @p_parent_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVREP_WRH_DEMAND_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о требовании
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) = null out
	,@p_wrh_demand_detail_id	numeric(38,0)
	,@p_wrh_demand_master_id	numeric(38,0)
	,@p_good_category_id		numeric(38,0)
	,@p_good_category_fname		varchar(120)
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_warehouse_type_sname	varchar(30)
	,@p_car_id					numeric(38,0) = null
	,@p_state_number			varchar(20) = null
	,@p_car_type_id				numeric(38,0) = null
	,@p_car_kind_id				numeric(38,0) = null
	,@p_car_mark_id				numeric(38,0) = null
	,@p_car_model_id			numeric(38,0) = null
	,@p_number					varchar(20)
	,@p_date_created			datetime
	,@p_employee_recieve_id		numeric(38,0)
	,@p_employee_recieve_fio	varchar(100)
	,@p_employee_head_id		numeric(38,0)
	,@p_employee_head_fio		varchar(100)
	,@p_employee_worker_id		numeric(38,0)
	,@p_employee_worker_fio		varchar(100)
	,@p_organization_recieve_id numeric(38,0)
	,@p_wrh_demand_master_type_id numeric(38,0)
	,@p_organization_head_id	numeric(38,0)
	,@p_organization_worker_id  numeric(38,0)
	,@p_organization_giver_id	numeric(38,0)
	,@p_organization_giver_sname varchar(30)
	,@p_price					decimal(18,9)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

	

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	
    insert into dbo.CREP_WRH_DEMAND
            (wrh_demand_master_id, wrh_demand_detail_id, good_category_id, good_category_fname, good_category_sname
			,amount, warehouse_type_id, warehouse_type_sname, car_id
			,state_number, car_type_id, car_kind_id, car_mark_id, car_model_id
			,number, date_created, employee_recieve_id, employee_recieve_fio
			,employee_head_id, employee_head_fio, employee_worker_id
			,employee_worker_fio, organization_recieve_id, wrh_demand_master_type_id
			,organization_head_id, organization_worker_id, organization_giver_id, organization_giver_sname
			,price, sys_comment, sys_user_created, sys_user_modified)
	select   @p_wrh_demand_master_id, @p_wrh_demand_detail_id, @p_good_category_id, @p_good_category_fname, @p_good_category_fname
			,@p_amount, @p_warehouse_type_id, @p_warehouse_type_sname, @p_car_id
			,@p_state_number, @p_car_type_id, @p_car_kind_id, @p_car_mark_id, @p_car_model_id
			,@p_number, @p_date_created, @p_employee_recieve_id, @p_employee_recieve_fio
			,@p_employee_head_id, @p_employee_head_fio, @p_employee_worker_id
			,@p_employee_worker_fio, @p_organization_recieve_id, @p_wrh_demand_master_type_id
			,@p_organization_head_id, @p_organization_worker_id, @p_organization_giver_id, @p_organization_giver_sname
			,@p_price, @p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_WRH_DEMAND as b
		 where b.wrh_demand_detail_id = @p_wrh_demand_detail_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_WRH_DEMAND
		 set
			 wrh_demand_master_id	= @p_wrh_demand_master_id
			,wrh_demand_detail_id   = @p_wrh_demand_detail_id
			,good_category_id		= @p_good_category_id
			,good_category_fname	= @p_good_category_fname
			,good_category_sname	= @p_good_category_fname
			,amount					= @p_amount
			,warehouse_type_id		= @p_warehouse_type_id
			,warehouse_type_sname	= @p_warehouse_type_sname
			,car_id					= @p_car_id
			,state_number			= @p_state_number
			,car_type_id			= @p_car_type_id
			,car_kind_id			= @p_car_kind_id
			,car_mark_id			= @p_car_mark_id
			,car_model_id			= @p_car_model_id
			,number					= @p_number
			,date_created			= @p_date_created
			,employee_recieve_id	= @p_employee_recieve_id
			,employee_recieve_fio	= @p_employee_recieve_fio
			,employee_head_id		= @p_employee_head_id
			,employee_head_fio		= @p_employee_head_fio
			,employee_worker_id		= @p_employee_worker_id
			,employee_worker_fio	= @p_employee_worker_fio
			,organization_recieve_id= @p_organization_recieve_id
			,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
			,organization_head_id	= @p_organization_head_id
			,organization_worker_id	= @p_organization_worker_id
			,organization_giver_id	= @p_organization_giver_id
			,organization_giver_sname = @p_organization_giver_sname
			,price					= @p_price
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where wrh_demand_detail_id = @p_wrh_demand_detail_id


    
  return 

end
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по требованиям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id						numeric(38,0) = null out
	,@p_wrh_demand_master_id	numeric(38,0)
	,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_wrh_demand_detail_id	numeric(38,0)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare
	   @v_warehouse_type_sname	varchar(30)
	  ,@v_car_id					numeric(38,0)
	  ,@v_state_number			varchar(20)
	  ,@v_car_type_id			numeric(38,0)
	  ,@v_car_kind_id			numeric(38,0)
	  ,@v_car_mark_id			numeric(38,0)
	  ,@v_car_model_id			numeric(38,0)
	  ,@v_number					varchar(20)
	  ,@v_date_created			datetime
	  ,@v_employee_recieve_id	numeric(38,0)
	  ,@v_employee_recieve_fio	varchar(100)
	  ,@v_employee_head_id		numeric(38,0)
	  ,@v_employee_head_fio		varchar(100)
	  ,@v_employee_worker_id		numeric(38,0)
	  ,@v_employee_worker_fio	varchar(100)
	  ,@v_organization_recieve_id numeric(38,0)
	  ,@v_organization_head_id	 numeric(38,0)
	  ,@v_organization_worker_id  numeric(38,0)
	  ,@v_good_category_fname	varchar(120)
	  ,@v_wrh_demand_master_type_id numeric(38,0)
	  ,@v_organization_giver_id	numeric(38,0)
	  ,@v_organization_giver_sname varchar(30)
	  ,@v_price					   decimal(18,9)			
	  ,@v_Error int

  select @v_number = number 
		,@v_car_id = car_id
		,@v_date_created = date_created
		,@v_employee_recieve_id = employee_recieve_id
		,@v_employee_head_id = employee_head_id
		,@v_employee_worker_id = employee_worker_id
		,@v_wrh_demand_master_type_id = wrh_demand_master_type_id
		,@v_organization_giver_id = organization_giver_id
	from dbo.CWRH_WRH_DEMAND_MASTER
	where id = @p_wrh_demand_master_id

  select @v_state_number = state_number
		,@v_car_type_id = car_type_id
		,@v_car_kind_id = car_kind_id
		,@v_car_mark_id = car_mark_id
		,@v_car_model_id = car_model_id
	from dbo.CCAR_CAR
	where id = @v_car_id

  select @v_good_category_fname = full_name
	from dbo.CWRH_GOOD_CATEGORY
	where id = @p_good_category_id

  select @v_warehouse_type_sname = short_name
	from dbo.CWRH_WAREHOUSE_TYPE
	where id = @p_warehouse_type_id

  select @v_price = price
	from dbo.CWRH_WAREHOUSE_ITEM
	where good_category_id = @p_good_category_id
	  and warehouse_type_id = @p_warehouse_type_id

  select @v_employee_recieve_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_recieve_id = a.organization_id
	from dbo.CPRT_EMPLOYEE as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id
 
	where a.id = @v_employee_recieve_id

  select @v_employee_head_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_head_id = a.organization_id
	from dbo.CPRT_EMPLOYEE as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id 
	where a.id = @v_employee_head_id

  select @v_employee_worker_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_worker_id = a.organization_id
	from dbo.CPRT_EMPLOYEE
		as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id 
	where a.id = @v_employee_worker_id

  select @v_organization_giver_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @v_organization_giver_id

	
 /* set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction */

  exec @v_Error = 
	dbo.uspVREP_WRH_DEMAND_SaveById
	 @p_id						= @p_id out
	,@p_wrh_demand_detail_id	= @p_wrh_demand_detail_id
	,@p_wrh_demand_master_id	= @p_wrh_demand_master_id
	,@p_good_category_id		= @p_good_category_id
	,@p_good_category_fname		= @v_good_category_fname
	,@p_amount					= @p_amount
	,@p_warehouse_type_id		= @p_warehouse_type_id
	,@p_warehouse_type_sname	= @v_warehouse_type_sname
	,@p_car_id					= @v_car_id
	,@p_state_number			= @v_state_number
	,@p_car_type_id				= @v_car_type_id
	,@p_car_kind_id				= @v_car_kind_id
	,@p_car_mark_id				= @v_car_mark_id
	,@p_car_model_id			= @v_car_model_id
	,@p_number					= @v_number
	,@p_date_created			= @v_date_created
	,@p_employee_recieve_id		= @v_employee_recieve_id
	,@p_employee_recieve_fio	= @v_employee_recieve_fio
	,@p_employee_head_id		= @v_employee_head_id
	,@p_employee_head_fio		= @v_employee_head_fio
	,@p_employee_worker_id		= @v_employee_worker_id
	,@p_employee_worker_fio		= @v_employee_worker_fio
	,@p_organization_recieve_id = @v_organization_recieve_id
	,@p_organization_head_id	= @v_organization_head_id
	,@p_organization_worker_id  = @v_organization_worker_id
	,@p_wrh_demand_master_type_id  = @v_wrh_demand_master_type_id
	,@p_organization_giver_id   = @v_organization_giver_id
	,@p_organization_giver_sname	= @v_organization_giver_sname
	,@p_price					= @v_price
	,@p_sys_comment				= @p_sys_comment
	,@p_sys_user				= @p_sys_user

    /*   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end */


   
	 --  if (@@tranCount > @v_TrancountOnEntry)
     --   commit

	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные по об остатках товаров для отчетов по складу
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_good_category_id	 numeric(38,0)
	,@p_good_category_fname  varchar(120)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
	,@p_organization_id		 numeric(38,0)
	,@p_organization_sname   varchar(30)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare

	 @v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_amount_id		numeric(38,0)
	,@v_value_price_id		numeric(38,0)
	,@v_month_created		datetime
	,@v_date_created	        datetime
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(getdate())

 set @v_date_created = dbo.usfUtils_TimeToZero(getdate())




select @v_day_1 =
				case when datepart("Day", @v_date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_2 =case when datepart("Day", @v_date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_3 = case when datepart("Day", @v_date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_4 = case when datepart("Day", @v_date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_5 = case when datepart("Day", @v_date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_6 = case when datepart("Day", @v_date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_7 = case when datepart("Day", @v_date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_8 = case when datepart("Day", @v_date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_9 = case when datepart("Day", @v_date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_10 = case when datepart("Day", @v_date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_11 = case when datepart("Day", @v_date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_12 = case when datepart("Day", @v_date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_13 = case when datepart("Day", @v_date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_14 = case when datepart("Day", @v_date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_15 = case when datepart("Day", @v_date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_16 = case when datepart("Day", @v_date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_17 = case when datepart("Day", @v_date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_18 = case when datepart("Day", @v_date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_19 = case when datepart("Day", @v_date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_20 = case when datepart("Day", @v_date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_21 = case when datepart("Day", @v_date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_22 = case when datepart("Day", @v_date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_23 = case when datepart("Day", @v_date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_24 = case when datepart("Day", @v_date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_25 = case when datepart("Day", @v_date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_26 = case when datepart("Day", @v_date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_27 = case when datepart("Day", @v_date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_28 = case when datepart("Day", @v_date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_29 = case when datepart("Day", @v_date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_30 = case when datepart("Day", @v_date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_31 = case when datepart("Day", @v_date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
  from dbo.CWRH_WAREHOUSE_ITEM as a
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id
  and a.organization_id = @p_organization_id


  exec @v_Error = dbo.uspVREP_WAREHOUSE_ITEM_DAY_SaveById
			 @p_value_id			= @p_value_id
			,@p_good_category_id	= @p_good_category_id
			,@p_good_category_fname	= @p_good_category_fname
			,@p_good_mark			= @p_good_mark
			,@p_warehouse_type_id	= @p_warehouse_type_id
			,@p_warehouse_type_sname= @p_warehouse_type_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_organization_id	= @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_month_created = @v_month_created
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о месяце по складу
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					 numeric(38,0) = null out
	,@p_value_id			 numeric(38,0)
	,@p_month_created		 datetime
	,@p_good_category_id	 numeric(38,0)
	,@p_good_category_fname  varchar(120)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_day_1				 decimal(18,9) = 0
	,@p_day_2				 decimal(18,9) = 0
	,@p_day_3				 decimal(18,9) = 0
	,@p_day_4				 decimal(18,9) = 0
	,@p_day_5				 decimal(18,9) = 0
	,@p_day_6				 decimal(18,9) = 0
	,@p_day_7				 decimal(18,9) = 0
	,@p_day_8				 decimal(18,9) = 0
	,@p_day_9			     decimal(18,9) = 0
	,@p_day_10				 decimal(18,9) = 0
	,@p_day_11				 decimal(18,9) = 0
	,@p_day_12				 decimal(18,9) = 0
	,@p_day_13				 decimal(18,9) = 0
	,@p_day_14				 decimal(18,9) = 0
	,@p_day_15				 decimal(18,9) = 0
	,@p_day_16				 decimal(18,9) = 0
	,@p_day_17				 decimal(18,9) = 0
	,@p_day_18				 decimal(18,9) = 0
	,@p_day_19				 decimal(18,9) = 0
	,@p_day_20				 decimal(18,9) = 0
	,@p_day_21				 decimal(18,9) = 0
	,@p_day_22				 decimal(18,9) = 0
	,@p_day_23				 decimal(18,9) = 0
	,@p_day_24				 decimal(18,9) = 0
	,@p_day_25				 decimal(18,9) = 0
	,@p_day_26				 decimal(18,9) = 0
	,@p_day_27				 decimal(18,9) = 0
	,@p_day_28				 decimal(18,9) = 0
	,@p_day_29				 decimal(18,9) = 0
	,@p_day_30				 decimal(18,9) = 0
	,@p_day_31				 decimal(18,9) = 0
	,@p_organization_id		 numeric(38,0)
	,@p_organization_sname   varchar(30)
    ,@p_sys_comment			 varchar(2000) = '-'
    ,@p_sys_user			 varchar(30) = null
)
as
begin


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_MonthTo01(getdate())

if (@p_day_1 is null)
      set @p_day_1 = 0

if (@p_day_2 is null)
      set @p_day_2 = 0

if (@p_day_3 is null)
      set @p_day_3 = 0

if (@p_day_4 is null)
      set @p_day_4 = 0

if (@p_day_5 is null)
      set @p_day_5 = 0

if (@p_day_6 is null)
      set @p_day_6 = 0

if (@p_day_7 is null)
      set @p_day_7 = 0

if (@p_day_8 is null)
      set @p_day_8 = 0

if (@p_day_9 is null)
      set @p_day_9 = 0

if (@p_day_10 is null)
      set @p_day_10 = 0

if (@p_day_11 is null)
      set @p_day_11 = 0

if (@p_day_12 is null)
      set @p_day_12 = 0

if (@p_day_13 is null)
      set @p_day_13 = 0

if (@p_day_14 is null)
      set @p_day_14 = 0

if (@p_day_15 is null)
      set @p_day_15 = 0

if (@p_day_16 is null)
      set @p_day_16= 0

if (@p_day_17 is null)
      set @p_day_17 = 0

if (@p_day_18 is null)
      set @p_day_18 = 0

if (@p_day_19 is null)
      set @p_day_19 = 0

if (@p_day_20 is null)
      set @p_day_20 = 0

if (@p_day_21 is null)
      set @p_day_21 = 0

if (@p_day_22 is null)
      set @p_day_22 = 0

if (@p_day_23 is null)
      set @p_day_23 = 0

if (@p_day_24 is null)
      set @p_day_24 = 0

if (@p_day_25 is null)
      set @p_day_25 = 0

if (@p_day_26 is null)
      set @p_day_26 = 0

if (@p_day_27 is null)
      set @p_day_27 = 0

if (@p_day_28 is null)
      set @p_day_28 = 0

if (@p_day_29 is null)
      set @p_day_29 = 0

if (@p_day_30 is null)
      set @p_day_30 = 0

if (@p_day_31 is null)
      set @p_day_31 = 0
	 
insert into dbo.CREP_WAREHOUSE_ITEM_DAY
	  (		month_created, value_id, good_category_id, good_category_fname
			,good_mark, warehouse_type_id, warehouse_type_sname	
			, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31, organization_id, organization_sname
			, sys_comment, sys_user_created, sys_user_modified)
select		@p_month_created, @p_value_id, @p_good_category_id, @p_good_category_fname
			,@p_good_mark, @p_warehouse_type_id, @p_warehouse_type_sname	
			,@p_day_1, @p_day_2, @p_day_3, @p_day_4
			,@p_day_5, @p_day_6, @p_day_7, @p_day_8, @p_day_9, @p_day_10
			,@p_day_11, @p_day_12, @p_day_13, @p_day_14, @p_day_15, @p_day_16
			,@p_day_17, @p_day_18, @p_day_19, @p_day_20, @p_day_21, @p_day_22
			,@p_day_23, @p_day_24, @p_day_25, @p_day_26, @p_day_27, @p_day_28
			,@p_day_29, @p_day_30, @p_day_31, @p_organization_id, @p_organization_sname
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_WAREHOUSE_ITEM_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.good_category_id = @p_good_category_id
	and b.warehouse_type_id = @p_warehouse_type_id
	and b.organization_id = @p_organization_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_WAREHOUSE_ITEM_DAY
		 set
		    good_category_fname = @p_good_category_fname
		   ,good_mark = @p_good_mark
		   ,warehouse_type_sname = @p_warehouse_type_sname
		   ,day_1 = @p_day_1
		   ,day_2 = @p_day_2
		   ,day_3 = @p_day_3
		   ,day_4 = @p_day_4
		   ,day_5 = @p_day_5
		   ,day_6 = @p_day_6
		   ,day_7 = @p_day_7
		   ,day_8 = @p_day_8
		   ,day_9 = @p_day_9
		   ,day_10 = @p_day_10
		   ,day_11 = @p_day_11
		   ,day_12 = @p_day_12
		   ,day_13 = @p_day_13
		   ,day_14 = @p_day_14
		   ,day_15 = @p_day_15
		   ,day_16 = @p_day_16
		   ,day_17 = @p_day_17
		   ,day_18 = @p_day_18
		   ,day_19 = @p_day_19
		   ,day_20 = @p_day_20
		   ,day_21 = @p_day_21
		   ,day_22 = @p_day_22
		   ,day_23 = @p_day_23
		   ,day_24 = @p_day_24
		   ,day_25 = @p_day_25
		   ,day_26 = @p_day_26
		   ,day_27 = @p_day_27
		   ,day_28 = @p_day_28
		   ,day_29 = @p_day_29
		   ,day_30 = @p_day_30
		   ,day_31 = @p_day_31
		   ,organization_sname = @p_organization_sname
	       	   ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
	and value_id = @p_value_id
	and good_category_id = @p_good_category_id
	and warehouse_type_id = @p_warehouse_type_id
	and organization_id = @p_organization_id
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные по приходу товаров для отчетов по складу
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_good_category_id	 numeric(38,0)
	,@p_good_category_fname  varchar(120)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
	,@p_organization_id		 numeric(38,0)
	,@p_organization_sname   varchar(30)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare

	 @v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_amount_id		numeric(38,0)
	,@v_value_price_id		numeric(38,0)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)



select @v_day_1 = case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_2 = case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_3 = case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_4 = case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_5 = case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_6 = case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_7 = case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_8 = case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_9 = case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_10 = case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_11 = case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_12 = case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_13 = case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_14 = case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_15 = case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_16 = case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_17 = case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_18 = case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_19 = case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_20 = case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_21 = case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_22 = case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_23 = case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_24 = case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_25 = case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_26 = case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_27 = case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_28 = case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_29 = case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_30 = case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_31 = case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end  
  from dbo.CWRH_WRH_INCOME_DETAIL as a
	join dbo.CWRH_WRH_INCOME_MASTER as b
		on a.wrh_income_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and b.warehouse_type_id = @p_warehouse_type_id
  and b.organization_recieve_id = @p_organization_id
   and b.date_created > = @v_month_created
   and b.date_created < dateadd("mm", 1, @v_month_created)
group by a.good_category_id
		,b.warehouse_type_id
		,b.organization_recieve_id
		,b.date_created


  exec @v_Error = dbo.uspVREP_WAREHOUSE_ITEM_DAY_SaveById
			 @p_value_id			= @p_value_id
			,@p_good_category_id	= @p_good_category_id
			,@p_good_category_fname	= @p_good_category_fname
			,@p_good_mark			= @p_good_mark
			,@p_warehouse_type_id	= @p_warehouse_type_id
			,@p_warehouse_type_sname= @p_warehouse_type_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_month_created = @v_month_created
			,@p_organization_id	= @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные по выдаче товаров для отчетов по складу
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_good_category_id	 numeric(38,0)
	,@p_good_category_fname  varchar(120)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
	,@p_organization_id		 numeric(38,0)
	,@p_organization_sname   varchar(30)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare

	 @v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_amount_id		numeric(38,0)
	,@v_value_price_id		numeric(38,0)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)



select @v_day_1 = case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_2 = case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_3 = case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_4 = case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_5 = case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_6 = case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_7 = case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_8 = case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_9 = case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_10 = case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_11 = case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_12 = case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_13 = case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_14 = case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_15 = case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_16 = case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_17 = case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_18 = case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end 
	  ,@v_day_19 = case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_20 = case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_21 = case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_22 = case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_23 = case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_24 = case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_25 = case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_26 = case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_27 = case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_28 = case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_29 = case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_30 = case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end
	  ,@v_day_31 = case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then sum(isnull(a.amount, 0))
						  when @p_value_id = @v_value_price_id
						  then avg(isnull(a.price, 0))
					 end
				else 0
		   end  
  from dbo.CWRH_WRH_DEMAND_DETAIL as a
	join dbo.CWRH_WRH_DEMAND_MASTER as b
		on a.wrh_demand_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id
  and b.organization_giver_id = @p_organization_id
   and b.date_created > = @v_month_created
   and b.date_created < dateadd("mm", 1, @v_month_created)
group by a.good_category_id
		,a.warehouse_type_id
		,b.organization_giver_id
		,b.date_created


  exec @v_Error = dbo.uspVREP_WAREHOUSE_ITEM_DAY_SaveById
			 @p_value_id			= @p_value_id
			,@p_good_category_id	= @p_good_category_id
			,@p_good_category_fname	= @p_good_category_fname
			,@p_good_mark			= @p_good_mark
			,@p_warehouse_type_id	= @p_warehouse_type_id
			,@p_warehouse_type_sname= @p_warehouse_type_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_month_created = @v_month_created
			,@p_organization_id	= @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN

go

alter table dbo.CWRH_GOOD_CATEGORY
alter column full_name varchar(120)
go



drop index dbo.u_good_mark_full_name_gd_ctgry
go

CREATE UNIQUE NONCLUSTERED INDEX [u_good_mark_full_name_gd_ctgry] ON [dbo].[CWRH_GOOD_CATEGORY] 
(
	[good_mark] ASC,
	[full_name] ASC,
	[car_mark_id] asc,
	[car_model_id] asc
) ON [$(fg_idx_name)]
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVWRH_GOOD_CATEGORY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о категориях товаров
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_Str				  varchar(100) = null
 ,@p_Srch_Type			   tinyint = null 
 ,@p_Top_n_by_rank		   smallint = null)
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
		  ,a.good_mark
		  ,a.short_name
		  ,a.full_name
		  ,a.unit
		  ,a.parent_id	
		  ,a.good_category_type_id
		  ,a.good_category_type_sname
		  ,a.organization_id
		  ,a.organization_name
		  ,a.car_mark_id
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
	FROM dbo.utfVWRH_GOOD_CATEGORY() as a
    WHERE 
(((@p_Str != '')
		   and (rtrim(ltrim(upper(full_name))) like rtrim(ltrim(upper('%' + @p_Str + '%')))
			or rtrim(ltrim(upper(good_mark))) like rtrim(ltrim(upper('%' + @p_Str + '%')))
			or rtrim(ltrim(upper(car_mark_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))
			or rtrim(ltrim(upper(car_model_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (good_mark, short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.id = KEY_TBL.[KEY]))
			OR (@p_Str = '')) */
	order by good_mark, full_name

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


