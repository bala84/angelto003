:r ./../_define.sql

:setvar dc_number 00417
:setvar dc_description "wrh demand income id added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   11.03.2009 VLavrentiev   wrh demand income id added
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

alter table dbo.CWRH_WRH_DEMAND_DETAIL
add wrh_income_detail_id numeric(38,0)
go


create index ifk_wrh_demand_detail_wrh_income_detail_id on dbo.CWRH_WRH_DEMAND_DETAIL(wrh_income_detail_id)
on [$(fg_idx_name)]
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид товара по приходному документу, по которому списан товар',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'wrh_income_detail_id'
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_SelectByGood_category_id] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей приходных документов по товару
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_good_category_id numeric(38,0)
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
		  ,a.wrh_income_master_id
		  ,c.organization_recieve_id
		  ,e.name as organization_recieve_sname
		  ,c.date_created
		  ,c.number
		  ,c.warehouse_type_id
		  ,d.short_name as warehouse_type_sname
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.total
		  ,convert(decimal(18,2),a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,convert(varchar(60), convert(decimal(18,2), a.price)) + 'р.' + ' - ' + 'Дата создания: ' + convert(varchar(20), c.date_created, 103) + ' - Номер: ' + convert(varchar(60),c.number) as full_string
		  ,isnull(a2.amount_gived, 0) as amount_gived
      FROM dbo.CWRH_WRH_INCOME_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
		join dbo.CWRH_WRH_INCOME_MASTER as c
			on a.wrh_income_master_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d
			on c.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as e
			on c.organization_recieve_id = e.id
		outer apply
			(select sum(a2.amount) as amount_gived
				from dbo.cwrh_wrh_demand_detail as a2
				join dbo.cwrh_wrh_demand_master as b2 on a2.wrh_demand_master_id = b2.id
			  where --a2.good_category_id = a.good_category_id
				--and b2.organization_giver_id = c.organization_recieve_id
				--and a2.warehouse_type_id = c.warehouse_type_id
			  --  and a2.price = a.price
			   -- and 
					a.id = a2.wrh_income_detail_id
			) as a2 
	  where b.id = @p_good_category_id
		and isnull(a2.amount_gived, 0) >= 0
)

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
     @p_id							numeric(38,0) out
    ,@p_wrh_demand_master_id		numeric(38,0)
    ,@p_good_category_id			numeric(38,0)
	,@p_amount						decimal(18,9)
	,@p_warehouse_type_id			numeric(38,0)
	,@p_last_amount					decimal(18,9) = null
	,@p_price						decimal(18,9) = null
	,@p_last_organization_giver_id  numeric(38,0) = null
	,@p_wrh_income_detail_id		numeric(38,0) = null
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
		  ,	@v_last_amount decimal(18,9)
		  , @v_last_price  decimal(18,9)
		  , @v_last_good_category_id numeric(38,0)
		  , @v_last_organization_id	  numeric(38,0)
		  , @v_last_warehouse_type_id numeric(38,0)
		  , @v_last_warehouse_item_id numeric(38,0)

	declare @v_data				xml
		   ,@v_tablename_id		numeric(38,0)
		   ,@v_action		    tinyint
		   ,@v_message_level_id numeric(38,0)
		   ,@v_subsystem_id		numeric(38,0)		
		   ,@v_system_date_created	datetime 
		   ,@v_system_user_id		numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	

    --Проставим режим обработки для товара со склада в режим апдейта
	set @v_edit_state = 'U'

	set @v_system_date_created  = getdate()
	--set @v_tablename_id = dbo.usfConst('dbo.CWRH_WRH_DEMAND_DETAIL')
	--set @v_message_level_id = dbo.usfValue('LOG_MESSAGE_LEVEL')
	--set @v_subsystem_id = dbo.usfConst('DEMAND_SUBSYSTEM')

	--select @v_system_user_id = id from dbo.CPRT_USER where username = @p_sys_user
	-- if (@v_system_user_id is null)
	--	select @v_system_user_id = id from dbo.CPRT_GROUP where name = @p_sys_user 

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
			, amount, warehouse_type_id, price, wrh_income_detail_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id, @p_price, @p_wrh_income_detail_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)

       
	  set @p_id = scope_identity();
--	  set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
  begin

  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,price = @p_price
		,wrh_income_detail_id = @p_wrh_income_detail_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

	  --  set @v_action = dbo.usfConst('ACTION_UPDATE')

  end


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



	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVWRH_WRH_DEMAND_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_demand_master_id numeric(38,0)
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
		  ,a.wrh_demand_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,a.warehouse_type_id
		  ,c.short_name as warehouse_type_sname
		  ,convert(decimal(18,2), a.price) as price
		  ,a.wrh_income_detail_id
      FROM dbo.CWRH_WRH_DEMAND_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
		JOIN dbo.CWRH_WAREHOUSE_TYPE as c
			on a.warehouse_type_id = c.id
	  where a.wrh_demand_master_id = @p_wrh_demand_master_id
	
)
go





set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях требований
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_wrh_demand_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,wrh_demand_master_id
		  ,good_category_id
		  ,amount
		  ,good_mark
		  ,good_category_sname
		  ,unit
		  ,warehouse_type_id
		  ,warehouse_type_sname
		  ,null as last_amount
		  ,price
		  ,null as last_organization_giver_id
		  ,wrh_income_detail_id
	FROM dbo.utfVWRH_WRH_DEMAND_DETAIL(@p_wrh_demand_master_id)

	RETURN
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
  
       SELECT  top(1)
		   a.id
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
		  ,convert(decimal(18,2), a.amount_gived) as amount_gived
	FROM dbo.utfVWRH_WRH_INCOME_SelectByGood_category_id(@p_good_category_id) as a
	where a.amount > a.amount_gived
/*exists 
		(select 1
			from dbo.CWRH_WAREHOUSE_ITEM as b
			where b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.organization_id = a.organization_recieve_id
			  having sum(b.amount) > 0) 
	  and */
	and		a.organization_recieve_id = @p_organization_id
	 -- and a.date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		   and ((rtrim(ltrim(upper(a.number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
				or (rtrim(ltrim(upper(a.warehouse_type_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by date_created asc

	RETURN

go




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_ORDER_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь заказа-наряда
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_order_master_id		numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_left_to_demand			decimal(18,9) = null
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
-- Если товар без - по количеству, которое надо выдать - запишем его - иначе - это просто товар, который списали по ошибке 
  if (@p_left_to_demand >= 0)
   begin
			  -- надо добавлять
		  if (@p_id is null)
			begin
			   insert into
						 dbo.CWRH_WRH_ORDER_DETAIL 
					( wrh_order_master_id, good_category_id
					, amount
					, sys_comment, sys_user_created, sys_user_modified)
			   values
					( @p_wrh_order_master_id, @p_good_category_id
					, @p_amount
					, @p_sys_comment, @p_sys_user, @p_sys_user)
		       
			  set @p_id = scope_identity();
			end   
		       
			    
		 else
		  -- надо править существующий
				update dbo.CWRH_WRH_ORDER_DETAIL set
				 wrh_order_master_id = @p_wrh_order_master_id
				,good_category_id = @p_good_category_id
				,amount = @p_amount
				,sys_comment = @p_sys_comment
				,sys_user_modified = @p_sys_user
				where ID = @p_id
   end
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql



