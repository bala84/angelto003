:r ./../_define.sql

:setvar dc_number 00253
:setvar dc_description "good category report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    21.05.2008 VLavrentiev  good category report fixed
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
	FROM dbo.utfVWRH_GOOD_CATEGORY() as a
    WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (good_mark, short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.id = KEY_TBL.[KEY]))
			OR (@p_Str = ''))
	order by short_name

	RETURN
GO

alter table dbo.CWRH_WAREHOUSE_ITEM
add price decimal(18,9)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Цена товара',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'price'
go




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

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_edit_state is null)
	set @p_edit_state = 'E'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WAREHOUSE_ITEM 
            (warehouse_type_id, amount, good_category_id, price, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_warehouse_type_id, @p_amount, @p_good_category_id, @p_price, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
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

    
  return 

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_sname	   varchar(30)
	,@p_total_sum			   decimal(18,9)
	,@p_date_created		   datetime
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_Error		int


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where short_name = @p_good_category_sname

  set @v_price = @p_total_sum/convert(decimal, @p_amount)


        exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id =null
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_amount = @p_amount	
	   ,@p_good_category_id = @v_good_category_id
	   ,@v_price	   = @v_price
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById] TO [$(db_app_user)]
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




