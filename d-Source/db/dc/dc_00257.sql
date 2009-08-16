:r ./../_define.sql

:setvar dc_number 00257
:setvar dc_description "reports on cars fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.05.2008 VLavrentiev  gc full_name fixed
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


alter table dbo.CWRH_GOOD_CATEGORY
alter column full_name varchar(120) not null
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
		  ,a.amount
		  ,a.good_category_id
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.full_name as good_category_fname
		  ,b.unit
		  ,b.good_category_type_id
		  ,d.short_name as good_category_type_sname
		  ,c.short_name as warehouse_type_sname
		  ,a.price
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
	
)
GO



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
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id) as a
    WHERE ((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
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
	,@p_good_category_fname	   varchar(60)
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
	where full_name = @p_good_category_fname

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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
    ,@p_short_name				varchar(30)
	,@p_full_name				varchar(120)
	,@p_unit					varchar(20)
	,@p_parent_id				numeric(38,0)
	,@p_organization_id			numeric(38,0) = null
	,@p_good_category_type_id	numeric(38,0) = null
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

	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, organization_id, good_category_type_id, unit, parent_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_organization_id, @p_good_category_type_id, @p_unit, @p_parent_id,  @p_sys_comment, @p_sys_user, @p_sys_user)
	 
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
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
    ,@p_short_name				varchar(30)
	,@p_full_name				varchar(120)
	,@p_unit					varchar(20)
	,@p_parent_id				numeric(38,0)
	,@p_organization_id			numeric(38,0) = null
	,@p_good_category_type_id	numeric(38,0) = null
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

	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

	 if (@p_unit is null)
	set @p_unit = 'шт.'

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, organization_id, good_category_type_id, unit, parent_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_organization_id, @p_good_category_type_id, @p_unit, @p_parent_id,  @p_sys_comment, @p_sys_user, @p_sys_user)
	 
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
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**  @p_edit_state - способ записи : только апдейт ('U'), вставка - апдейт ('IU')
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_fname	   varchar(60)
	,@p_total_sum			   decimal(18,9)
	,@p_date_created		   datetime
	,@p_edit_state			   char(1)	= 'U'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  
         
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_good_category_sname varchar(30)
		,@v_Error		int
		,@v_TrancountOnEntry int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_edit_state is null)
    set @p_edit_state = 'U'

     if (@@tranCount = 0)
        begin transaction  

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

if ((@p_edit_state = 'IU') and (@v_warehouse_type_id is null))
  begin 
   exec @v_Error = dbo.uspVWRH_WAREHOUSE_TYPE_SaveById 
        @p_id =null
	   ,@p_short_name = @p_warehouse_type_sname
	   ,@p_full_name = @p_warehouse_type_sname	
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
  end

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

if ((@p_edit_state = 'IU') and (@v_good_category_id is null))
begin
  set @v_good_category_sname = substring(@p_good_category_fname, 1,30)
  exec @v_Error = dbo.uspVWRH_GOOD_CATEGORY_SaveById
        @p_id =null
	   ,@p_short_name = @v_good_category_sname
	   ,@p_full_name = 	@p_good_category_fname
	   ,@p_unit	= null
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
end

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
		  ,null as edit_state
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id) as a
    WHERE ((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**  @p_edit_state - способ записи : только апдейт ('U'), вставка - апдейт ('IU')
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_fname	   varchar(60)
	,@p_total_sum			   decimal(18,9)
	,@p_edit_state			   char(1)	= 'U'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  
         
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_good_category_sname varchar(30)
		,@v_Error		int
		,@v_TrancountOnEntry int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_edit_state is null)
    set @p_edit_state = 'U'

     if (@@tranCount = 0)
        begin transaction  

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

if ((@p_edit_state = 'IU') and (@v_warehouse_type_id is null))
  begin 
   exec @v_Error = dbo.uspVWRH_WAREHOUSE_TYPE_SaveById 
        @p_id =null
	   ,@p_short_name = @p_warehouse_type_sname
	   ,@p_full_name = @p_warehouse_type_sname	
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
  end

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

if ((@p_edit_state = 'IU') and (@v_good_category_id is null))
begin
  set @v_good_category_sname = substring(@p_good_category_fname, 1,30)
  exec @v_Error = dbo.uspVWRH_GOOD_CATEGORY_SaveById
        @p_id =null
	   ,@p_short_name = @v_good_category_sname
	   ,@p_full_name = 	@p_good_category_fname
	   ,@p_unit	= null
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
end

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

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**  @p_edit_state - способ записи : только апдейт ('U'), вставка - апдейт ('IU')
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_fname	   varchar(60)
	,@p_total_sum			   decimal(18,9)
	,@p_edit_state			   char(2)	= 'U'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  
         
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_good_category_sname varchar(30)
		,@v_Error		int
		,@v_TrancountOnEntry int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_edit_state is null)
    set @p_edit_state = 'U'

     if (@@tranCount = 0)
        begin transaction  

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

if ((@p_edit_state = 'IU') and (@v_warehouse_type_id is null))
  begin 
   exec @v_Error = dbo.uspVWRH_WAREHOUSE_TYPE_SaveById 
        @p_id =null
	   ,@p_short_name = @p_warehouse_type_sname
	   ,@p_full_name = @p_warehouse_type_sname	
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
  end

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

if ((@p_edit_state = 'IU') and (@v_good_category_id is null))
begin
  set @v_good_category_sname = substring(@p_good_category_fname, 1,30)
  exec @v_Error = dbo.uspVWRH_GOOD_CATEGORY_SaveById
        @p_id =null
	   ,@p_short_name = @v_good_category_sname
	   ,@p_full_name = 	@p_good_category_fname
	   ,@p_unit	= null
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
end

  set @v_price = @p_total_sum/convert(decimal, @p_amount)


        exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id =null
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_amount = @p_amount	
	   ,@p_good_category_id = @v_good_category_id
	   ,@p_price	   = @v_price
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

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**  @p_edit_state - способ записи : только апдейт ('U'), вставка - апдейт ('IU')
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_fname	   varchar(60)
	,@p_total_sum			   decimal(18,9)
	,@p_edit_state			   char(2)	= 'U'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  
         
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_good_category_sname varchar(30)
		,@v_Error		int
		,@v_TrancountOnEntry int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_edit_state is null)
    set @p_edit_state = 'U'

     if (@@tranCount = 0)
        begin transaction  

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

if ((@p_edit_state = 'IU') and (@v_warehouse_type_id is null))
  begin 
   exec @v_Error = dbo.uspVWRH_WAREHOUSE_TYPE_SaveById 
        @p_id =null
	   ,@p_short_name = @p_warehouse_type_sname
	   ,@p_full_name = @p_warehouse_type_sname	
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user


  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
  end

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

if ((@p_edit_state = 'IU') and (@v_good_category_id is null))
begin
  set @v_good_category_sname = substring(@p_good_category_fname, 1,30)
  exec @v_Error = dbo.uspVWRH_GOOD_CATEGORY_SaveById
        @p_id =null
	   ,@p_short_name = @v_good_category_sname
	   ,@p_full_name = 	@p_good_category_fname
	   ,@p_unit	= null
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
end

  set @v_price = @p_total_sum/convert(decimal, @p_amount)


        exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id =null
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_amount = @p_amount	
	   ,@p_good_category_id = @v_good_category_id
	   ,@p_price	   = @v_price
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

ALTER procedure [dbo].[uspVWRH_LOAD_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна загрузить по имени содержимое склада
**
**  Входные параметры: 
**  @p_edit_state - способ записи : только апдейт ('U'), вставка - апдейт ('IU')
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					   numeric(38,0) out
    ,@p_warehouse_type_sname   varchar(30)
    ,@p_amount				   int
	,@p_good_category_fname	   varchar(60)
	,@p_total_sum			   decimal(18,9)
	,@p_edit_state			   char(2)	= 'U'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  
         
	declare
		 @v_warehouse_type_id	numeric(38,0)
		,@v_good_category_id	numeric(38,0)
		,@v_price				decimal(18,9)
		,@v_good_category_sname varchar(30)
		,@v_Error		int
		,@v_TrancountOnEntry int
		,@v_id					numeric(38,0)


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_edit_state is null)
    set @p_edit_state = 'U'

     if (@@tranCount = 0)
        begin transaction  

  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

if ((@p_edit_state = 'IU') and (@v_warehouse_type_id is null))
  begin 
   exec @v_Error = dbo.uspVWRH_WAREHOUSE_TYPE_SaveById 
        @p_id =null
	   ,@p_short_name = @p_warehouse_type_sname
	   ,@p_full_name = @p_warehouse_type_sname	
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user


  select @v_warehouse_type_id = id
	from dbo.CWRH_WAREHOUSE_TYPE
	where short_name = @p_warehouse_type_sname

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
  end

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

if ((@p_edit_state = 'IU') and (@v_good_category_id is null))
begin
  set @v_good_category_sname = substring(@p_good_category_fname, 1,30)
  exec @v_Error = dbo.uspVWRH_GOOD_CATEGORY_SaveById
        @p_id =null
	   ,@p_short_name = @v_good_category_sname
	   ,@p_full_name = 	@p_good_category_fname
	   ,@p_unit	= null
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

  select @v_good_category_id = id
	from dbo.CWRH_GOOD_CATEGORY
	where full_name = @p_good_category_fname

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end  
end

  set @v_price = @p_total_sum/convert(decimal, @p_amount)
  

  select @v_id = id
  from dbo.CWRH_WAREHOUSE_ITEM
	where warehouse_type_id = @v_warehouse_type_id
	  and good_category_id = @v_good_category_id

        exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_id
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_amount = @p_amount	
	   ,@p_good_category_id = @v_good_category_id
	   ,@p_price	   = @v_price
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




