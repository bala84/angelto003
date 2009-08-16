:r ./../_define.sql

:setvar dc_number 00268
:setvar dc_description "warehouse income report prepare added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.05.2008 VLavrentiev  warehouse income report prepare added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по приходу на склад
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(    @p_good_category_id	 numeric(38,0)
	,@p_wrh_income_master_id numeric(38,0)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
  
  declare
	 @v_good_category_fname	 varchar(60)
	,@v_warehouse_type_id	 numeric(38,0)
	,@v_warehouse_type_sname varchar(30)
	,@v_good_mark			 varchar(30)
	,@v_value_id			 numeric(38,0)
	,@v_date_created	 datetime


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


  select @v_good_category_fname = full_name
		,@v_good_mark = good_mark
    from dbo.CWRH_GOOD_CATEGORY
	where id = @p_good_category_id

  select @v_warehouse_type_id = warehouse_type_id
	,@v_date_created      = date_created
	from dbo.CWRH_WRH_INCOME_MASTER
	where id = @p_wrh_income_master_id

  select @v_warehouse_type_sname = short_name
	from dbo.CWRH_WAREHOUSE_TYPE
	where id = @v_warehouse_type_id

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_AMOUNT')

      if (@@tranCount = 0)
        begin transaction 

exec @v_Error = uspVREP_WAREHOUSE_ITEM_INCOME_Calculate
	 @p_value_id			 = @v_value_id
	,@p_date_created		 = @v_date_created	  
	,@p_good_category_id	 = @p_good_category_id
	,@p_good_category_fname  = @v_good_category_fname
	,@p_good_mark			 = @v_good_mark
	,@p_warehouse_type_id	 = @v_warehouse_type_id
	,@p_warehouse_type_sname = @v_warehouse_type_sname
    ,@p_sys_comment			 = @p_sys_comment
    ,@p_sys_user			 = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_PRICE')

exec @v_Error = uspVREP_WAREHOUSE_ITEM_INCOME_Calculate
	 @p_value_id			 = @v_value_id
	,@p_date_created		 = @v_date_created	  
	,@p_good_category_id	 = @p_good_category_id
	,@p_good_category_fname  = @v_good_category_fname
	,@p_good_mark			 = @v_good_mark
	,@p_warehouse_type_id	 = @v_warehouse_type_id
	,@p_warehouse_type_sname = @v_warehouse_type_sname
    ,@p_sys_comment			 = @p_sys_comment
    ,@p_sys_user			 = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

return
 GO


GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Prepare] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_INCOME_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь приходного документа
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_income_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_good_category_price_id  numeric(38,0) = null
	,@p_amount					int
	,@p_total					int
	,@p_price					decimal(18,9) = null
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
		  , @v_warehouse_type_id numeric(38,0)

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
			     dbo.CWRH_WRH_INCOME_DETAIL 
            ( wrh_income_master_id, good_category_id
			, good_category_price_id, amount
			, total, price
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_income_master_id, @p_good_category_id
			, @p_good_category_price_id, @p_amount
			, @p_total, @p_price
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_DETAIL set
		 wrh_income_master_id = @p_wrh_income_master_id
	    ,good_category_id = @p_good_category_id
		,good_category_price_id = @p_good_category_price_id
		,amount = @p_amount
		,total = @p_total
		,price = @p_price
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

  select @v_warehouse_type_id = c.warehouse_type_id 
						from dbo.CWRH_WRH_INCOME_MASTER as c
					    where id = @p_wrh_income_master_id

  select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @v_warehouse_type_id

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_edit_state = @v_edit_state
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

--Отчет для склада
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_INCOME_Prepare
	    @p_wrh_income_master_id = @p_wrh_income_master_id
	   ,@p_good_category_id = @p_good_category_id
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

