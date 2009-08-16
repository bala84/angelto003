:r ./../_define.sql

:setvar dc_number 00270
:setvar dc_description "warehouse item calculate added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.05.2008 VLavrentiev  warehouse item calculate added
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

CREATE PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_Calculate]
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
	,@v_date_created	        datetime
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(getdate())

 set @v_date_created = dbo.usfUtils_TimeToZero(getdate())




select @v_day_1 = sum(case when datepart("Day", @v_date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", @v_date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", @v_date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", @v_date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", @v_date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", @v_date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", @v_date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", @v_date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", @v_date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", @v_date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", @v_date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", @v_date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", @v_date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", @v_date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", @v_date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", @v_date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", @v_date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", @v_date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", @v_date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", @v_date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", @v_date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", @v_date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", @v_date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", @v_date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", @v_date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", @v_date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", @v_date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", @v_date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", @v_date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", @v_date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", @v_date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(a.price, 0)
					 end
				else 0
		   end)  
  from dbo.CWRH_WAREHOUSE_ITEM as a
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id


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

GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_Calculate] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов об остатках на складе
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(    @p_good_category_id	  numeric(38,0)
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

  select @v_warehouse_type_sname = short_name
	from dbo.CWRH_WAREHOUSE_TYPE
	where id = @p_warehouse_type_id

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_AMOUNT')

      if (@@tranCount = 0)
        begin transaction 

exec @v_Error = uspVREP_WAREHOUSE_ITEM_Calculate
	 @p_value_id			 = @v_value_id  
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

set @v_value_id = dbo.usfConst('WAREHOUSE_ITEM_PRICE')

exec @v_Error = uspVREP_WAREHOUSE_ITEM_Calculate
	 @p_value_id			 = @v_value_id	  
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

GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_Prepare] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить содержимое склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_warehouse_type_id   numeric(38,0)
    ,@p_amount				int
	,@p_good_category_id	numeric(38,0)
	,@p_edit_state			char(1)		  = 'E'
	,@p_price				decimal(18,9) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_action smallint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_edit_state is null)
	set @p_edit_state = 'E'

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount

 if (@@tranCount = 0)
        begin transaction  

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WAREHOUSE_ITEM 
            (warehouse_type_id, amount, good_category_id, price, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_warehouse_type_id, @p_amount, @p_good_category_id, @p_price, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

      set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
   begin
  -- надо править существующий
		update dbo.CWRH_WAREHOUSE_ITEM set
		 warehouse_type_id =  @p_warehouse_type_id
        ,amount =  case when @p_edit_state = 'E' then @p_amount
				when @p_edit_state = 'U' then amount + @p_amount
				   end
		,good_category_id = @p_good_category_id
		,price	= @p_price
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

		set @v_action = dbo.usfConst('ACTION_UPDATE')
   end	

	  exec @v_Error = 
        dbo.uspVHIS_WAREHOUSE_ITEM_SaveById
        	 @p_action						= @v_action
			,@p_warehouse_type_id			= @p_warehouse_type_id
    		,@p_amount						= @p_amount
			,@p_good_category_id			= @p_good_category_id
    		,@p_edit_state					= @p_edit_state
    		,@p_price						= @p_price
			,@p_sys_comment					= @p_sys_comment  
  			,@p_sys_user					= @p_sys_user

	  if (@v_Error > 0)
		begin 
			if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end

--Отчет для склада
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_Prepare
	    @p_warehouse_type_id = @p_warehouse_type_id
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
	,@p_good_category_fname  varchar(60)
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
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
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
			, day_29, day_30, day_31
			, sys_comment, sys_user_created, sys_user_modified)
select		@p_month_created, @p_value_id, @p_good_category_id, @p_good_category_fname
			,@p_good_mark, @p_warehouse_type_id, @p_warehouse_type_sname	
			,@p_day_1, @p_day_2, @p_day_3, @p_day_4
			,@p_day_5, @p_day_6, @p_day_7, @p_day_8, @p_day_9, @p_day_10
			,@p_day_11, @p_day_12, @p_day_13, @p_day_14, @p_day_15, @p_day_16
			,@p_day_17, @p_day_18, @p_day_19, @p_day_20, @p_day_21, @p_day_22
			,@p_day_23, @p_day_24, @p_day_25, @p_day_26, @p_day_27, @p_day_28
			,@p_day_29, @p_day_30, @p_day_31
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_WAREHOUSE_ITEM_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.good_category_id = @p_good_category_id
	and b.warehouse_type_id = @p_warehouse_type_id)
       
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
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
	and value_id = @p_value_id
	and good_category_id = @p_good_category_id
	and warehouse_type_id = @p_warehouse_type_id
    
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


