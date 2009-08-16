:r ./../_define.sql

:setvar dc_number 00266
:setvar dc_description "save report warehouse item day added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.05.2008 VLavrentiev  save report warehouse item day added
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

create procedure [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SaveById]
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

GRANT EXECUTE ON [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SaveById] TO [$(db_app_user)]
GO



create index i_good_category_id_rep_warehouse_item_day on dbo.CREP_WAREHOUSE_ITEM_DAY(good_category_id)
on $(fg_idx_name)
go

create index i_month_created_rep_warehouse_item_day on dbo.CREP_WAREHOUSE_ITEM_DAY(month_created)
on $(fg_idx_name)
go

create index i_value_id_rep_warehouse_item_day on dbo.CREP_WAREHOUSE_ITEM_DAY(value_id)
on $(fg_idx_name)
go


create index i_warehouse_type_id_rep_warehouse_item_day on dbo.CREP_WAREHOUSE_ITEM_DAY(warehouse_type_id)
on $(fg_idx_name)
go



set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(72, 'WAREHOUSE_ITEM_INCOME_AMOUNT', 'Количество полученного товара')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(72, 'WAREHOUSE_ITEM_INCOME_AMOUNT', 'Количество полученного товара')
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(73, 'WAREHOUSE_ITEM_OUTCOME_AMOUNT', 'Количество выданного товара')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(73, 'WAREHOUSE_ITEM_OUTCOME_AMOUNT', 'Количество выданного товара')
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(74, 'WAREHOUSE_ITEM_AMOUNT', 'Количество товара на складе')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(74, 'WAREHOUSE_ITEM_AMOUNT', 'Количество товара на складе')
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

