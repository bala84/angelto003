:r ./../_define.sql

:setvar dc_number 00314
:setvar dc_description "warehouse item organization added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.06.2008 VLavrentiev  warehouse item organization added
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



alter table dbo.CWRH_WAREHOUSE_ITEM
add organization_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'organization_id'
go


create index ifk_organization_id_wrh_item on dbo.CWRH_WAREHOUSE_ITEM(organization_id)
on $(fg_idx_name)
go



alter table dbo.CHIS_WAREHOUSE_ITEM
add organization_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CHIS_WAREHOUSE_ITEM', 'column', 'organization_id'
go


create index ifk_organization_id_his_wrh_item on dbo.CHIS_WAREHOUSE_ITEM(organization_id)
on $(fg_idx_name)
go



alter table CWRH_WAREHOUSE_ITEM
   add constraint CWRH_WAREHOUSE_ITEM_ORGANIZATION_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVHIS_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об истории состояний автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
	,@p_date_created				datetime      = null
	,@p_action						smallint
    ,@p_warehouse_type_id			numeric(38,0)
    ,@p_amount						decimal(18,9)
	,@p_good_category_id			numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_edit_state					char(1)		  = 'E'
	,@p_price						decimal(18,9) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

     if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_date_created is null)
	set @p_date_created = getdate();

   if (@p_id is null)
	begin
	insert into dbo.CHIS_WAREHOUSE_ITEM 
     (date_created, action, warehouse_type_id, amount, price, good_category_id
	  ,organization_id, sys_comment, sys_user_created, sys_user_modified)
	select @p_date_created, @p_action, @p_warehouse_type_id, @p_amount, @p_price, @p_good_category_id
	  ,@p_organization_id, @p_sys_comment, @p_sys_user, @p_sys_user
	
	  set @p_id = scope_identity();
	end
	return 

end
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
    ,@p_amount				decimal(18,9)
	,@p_good_category_id	numeric(38,0)
	,@p_organization_id		numeric(38,0)
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

  declare @t_amount table (amount int)

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
            (warehouse_type_id, amount, good_category_id, price, organization_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_warehouse_type_id, @p_amount, @p_good_category_id, @p_price, @p_organization_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

      set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
   begin
  -- надо править существующий
  -- если режим редактирования - "E" - переписываем @p_amount
  -- если режим редактирования - "U" - прибавляем @p_amount к прошлому amount 
		update dbo.CWRH_WAREHOUSE_ITEM set
		 warehouse_type_id =  @p_warehouse_type_id
        ,amount =  case when @p_edit_state = 'E' then @p_amount
				when @p_edit_state = 'U' then amount + @p_amount
				   end
		,good_category_id = @p_good_category_id
		,price	= @p_price
		,organization_id = @p_organization_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		output inserted.amount  into @t_amount
		where ID = @p_id

		set @v_action = dbo.usfConst('ACTION_UPDATE')

		select @p_amount = amount from @t_amount

   end	
	--Запишем историю изменения склада
	  exec @v_Error = 
        dbo.uspVHIS_WAREHOUSE_ITEM_SaveById
        	 @p_action						= @v_action
			,@p_warehouse_type_id			= @p_warehouse_type_id
    		,@p_amount						= @p_amount
			,@p_good_category_id			= @p_good_category_id
    		,@p_edit_state					= @p_edit_state
    		,@p_price						= @p_price
			,@p_organization_id				= @p_organization_id
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
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WAREHOUSE_ITEM] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения содержимого склада
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0)
 ,@p_warehouse_type_id	   numeric(38,0)
 ,@p_organization_id	   numeric(38,0)	
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
		  ,a.warehouse_type_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.good_category_id
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.full_name as good_category_fname
		  ,b.unit
		  ,b.good_category_type_id
		  ,d.short_name as good_category_type_sname
		  ,c.short_name as warehouse_type_sname
		  ,a.price
		  ,a.organization_id
      FROM dbo.CWRH_WAREHOUSE_ITEM as a
	   join dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
	   join dbo.CWRH_WAREHOUSE_TYPE as c
			on a.warehouse_type_id = c.id
	   left outer join dbo.CWRH_GOOD_CATEGORY_TYPE as d
			on b.good_category_type_id = d.id
	 WHERE a.warehouse_type_id = @p_warehouse_type_id
	   AND (b.good_category_type_id = @p_good_category_type_id
			or @p_good_category_type_id is null)
	   AND (a.organization_id = @p_organization_id
			or @p_organization_id is null)
	
)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WAREHOUSE_ITEM_SelectByType_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о содержимом склада
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0) = null
 ,@p_warehouse_type_id	   numeric(38,0)
 ,@p_organization_id	   numeric(38,0) = null
 ,@p_Str				  varchar(100) = null
 ,@p_Srch_Type			   tinyint = null 
 ,@p_Top_n_by_rank		   smallint = null
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
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,warehouse_type_id
		  ,amount
		  ,good_category_id
		  ,good_mark
		  ,good_category_sname
		  ,good_category_fname
		  ,unit
		  ,good_category_type_id
		  ,good_category_type_sname
		  ,warehouse_type_sname
		  ,price
		 --для редима редактирования выведем edit_state (нужно ли запоминать в бд?)
		  ,null as edit_state
		  ,organization_id
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id
									,@p_organization_id) as a
    WHERE 
--поиск
(((@p_Str != '')
		   and (rtrim(ltrim(upper(good_category_sname))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))
		or (@p_Str = '')) */

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


