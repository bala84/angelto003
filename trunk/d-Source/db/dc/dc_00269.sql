:r ./../_define.sql

:setvar dc_number 00269
:setvar dc_description "warehouse outcome calculate added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.05.2008 VLavrentiev  warehouse outcome calculate added
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

create PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate]
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
	,@p_good_category_fname  varchar(60)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
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
	,@v_price			    decimal(18,9)
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)

select @v_price = price
	from dbo.CWRH_WAREHOUSE_ITEM
	where good_category_id = @p_good_category_id
	  and warehouse_type_id = @p_warehouse_type_id



select @v_day_1 = sum(case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then @v_price
					 end
				else 0
		   end)  
  from dbo.CWRH_WRH_DEMAND_DETAIL as a
	join dbo.CWRH_WRH_DEMAND_MASTER as b
		on a.wrh_demand_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id
   and b.date_created > = @v_month_created
   and b.date_created < dateadd("mm", 1, @v_month_created)


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
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare]
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
(    @p_good_category_id	  numeric(38,0)
	,@p_wrh_demand_master_id  numeric(38,0)
	,@p_warehouse_type_id	  numeric(38,0)	
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

  select @v_date_created      = date_created
	from dbo.CWRH_WRH_DEMAND_MASTER
	where id = @p_wrh_demand_master_id

  select @v_warehouse_type_sname = short_name
	from dbo.CWRH_WAREHOUSE_TYPE
	where id = @p_warehouse_type_id

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')

      if (@@tranCount = 0)
        begin transaction 

exec @v_Error = uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate
	 @p_value_id			 = @v_value_id
	,@p_date_created		 = @v_date_created	  
	,@p_good_category_id	 = @p_good_category_id
	,@p_good_category_fname  = @v_good_category_fname
	,@p_good_mark			 = @v_good_mark
	,@p_warehouse_type_id	 = @p_warehouse_type_id
	,@p_warehouse_type_sname = @v_warehouse_type_sname
    ,@p_sys_comment			 = @p_sys_comment
    ,@p_sys_user			 = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

exec @v_Error = uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate
	 @p_value_id			 = @v_value_id
	,@p_date_created		 = @v_date_created	  
	,@p_good_category_id	 = @p_good_category_id
	,@p_good_category_fname  = @v_good_category_fname
	,@p_good_mark			 = @v_good_mark
	,@p_warehouse_type_id	 = @p_warehouse_type_id
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



GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare] TO [$(db_app_user)]
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
	,@p_amount					int
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				int = null
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


--Отчет для склада
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare
	    @p_wrh_demand_master_id = @p_wrh_demand_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_warehouse_type_id	= @p_warehouse_type_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 

select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id

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
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
	,@p_good_category_fname  varchar(60)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
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
	,@v_price			    decimal(18,9)
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)

select @v_price = price
	from dbo.CWRH_WAREHOUSE_ITEM
	where good_category_id = @p_good_category_id
	  and warehouse_type_id = @p_warehouse_type_id



select @v_day_1 = sum(case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)  
  from dbo.CWRH_WRH_DEMAND_DETAIL as a
	join dbo.CWRH_WRH_DEMAND_MASTER as b
		on a.wrh_demand_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id
   and b.date_created > = @v_month_created
   and b.date_created < dateadd("mm", 1, @v_month_created)


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
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
	,@p_good_category_fname  varchar(60)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
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



select @v_day_1 = sum(case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)  
  from dbo.CWRH_WRH_INCOME_DETAIL as a
	join dbo.CWRH_WRH_INCOME_MASTER as b
		on a.wrh_income_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and b.warehouse_type_id = @p_warehouse_type_id
   and date_created > = @v_month_created
   and date_created < dateadd("mm", 1, @v_month_created)


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
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

	RETURN
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


