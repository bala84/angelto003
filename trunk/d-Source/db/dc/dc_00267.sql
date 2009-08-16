:r ./../_define.sql

:setvar dc_number 00267
:setvar dc_description "warehouse income report added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.05.2008 VLavrentiev  warehouse income report added
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

set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(75, 'WAREHOUSE_ITEM_INCOME_PRICE', 'Цена полученного товара')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(75, 'WAREHOUSE_ITEM_INCOME_PRICE', 'Цена полученного товара')
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(76, 'WAREHOUSE_ITEM_OUTCOME_PRICE', 'Цена выданного товара')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(76, 'WAREHOUSE_ITEM_OUTCOME_PRICE', 'Цена выданного товара')
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(77, 'WAREHOUSE_ITEM_PRICE', 'Цена товара на складе')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(77, 'WAREHOUSE_ITEM_PRICE', 'Цена товара на складе')
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Calculate]
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
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then a.amount
						  when @p_value_id = @v_value_price_id
						  then a.price
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



GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_INCOME_Calculate] TO [$(db_app_user)]
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

