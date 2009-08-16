:r ./../_define.sql

:setvar dc_number 00418
:setvar dc_description "wrh demand  price 0 added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   12.03.2009 VLavrentiev   wrh demand  price 0 added
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

     if (@p_price is null)
    set @p_price = 0
	

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
 @p_good_category_id     numeric(38,0)
,@p_organization_id      numeric(38,0)
,@p_start_date		     datetime
,@p_end_date		     datetime
,@p_wrh_income_detail_id numeric(38,0) = null
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
,@p_mode			 smallint = 1
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
--Если тип вывода - по имеющимся прих. документам
if (@p_mode = 1)
  
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


-- Если тип вывода по текущему приходному документу
if (@p_mode = 2)
  
       SELECT  
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
	where a.id = @p_wrh_income_detail_id


	RETURN
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
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_demand_master_id
		  ,a.good_category_id
		  ,a.amount
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.warehouse_type_id
		  ,a.warehouse_type_sname
		  ,null as last_amount
		  ,a.price
		  ,null as last_organization_giver_id
		  ,a.wrh_income_detail_id
		  ,c.number
	FROM dbo.utfVWRH_WRH_DEMAND_DETAIL(@p_wrh_demand_master_id) as a
	left outer join dbo.cwrh_wrh_income_detail as b
				  on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
				  on b.wrh_income_master_id = c.id

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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql



