:r ./../_define.sql

:setvar dc_number 00315
:setvar dc_description "warehouse demand save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.06.2008 VLavrentiev  warehouse demand save fixed
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
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				decimal(18,9) = null
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

select @v_organization_id = a.organization_giver_id
from dbo.CWRH_WRH_DEMAND_MASTER as a
where id = @p_wrh_demand_master_id
 

select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id
	 and a.organization_id = @v_organization_id

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
	   ,@p_organization_id = @v_organization_id 
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
go


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
	,@p_amount					decimal(18,9)
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
		  , @v_organization_id  numeric(38,0)

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
		,@v_organization_id = c.organization_recieve_id
						from dbo.CWRH_WRH_INCOME_MASTER as c
					    where id = @p_wrh_income_master_id

  select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @v_warehouse_type_id
	 and a.organization_id = @v_organization_id

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id
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
go

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
	,@p_organization_id		   numeric(38,0)
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
	  and organization_id = @p_organization_id

        exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_id
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_amount = @p_amount	
	   ,@p_good_category_id = @v_good_category_id
	   ,@p_organization_id = @p_organization_id
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
		   max(id)
		  ,min(sys_status)
		  ,min(sys_comment)
		  ,min(sys_date_modified)
		  ,min(sys_date_created)
		  ,min(sys_user_modified)
		  ,min(sys_user_created)
		  ,min(warehouse_type_id)
		  ,sum(amount)
		  ,min(good_category_id)
		  ,min(good_mark)
		  ,min(good_category_sname)
		  ,min(good_category_fname)
		  ,min(unit)
		  ,min(good_category_type_id)
		  ,min(good_category_type_sname)
		  ,min(warehouse_type_sname)
		  ,avg(price)
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
group by organization_id
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
  if not exists( select 1 from dbo.CWRH_WAREHOUSE_ITEM
						  where warehouse_type_id = @p_warehouse_type_id
							and good_category_id = @p_good_category_id
							and organization_id = @p_organization_id)
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
		 amount =  case when @p_edit_state = 'E' then @p_amount
				when @p_edit_state = 'U' then amount + @p_amount
				   end
		,price	= @p_price
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		output inserted.amount  into @t_amount
		where  warehouse_type_id = @p_warehouse_type_id
		and good_category_id = @p_good_category_id
		and organization_id = @p_organization_id

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
		   max(id) as id
		  ,min(sys_status) as sys_status
		  ,min(sys_comment) as sys_comment
		  ,min(sys_date_modified) as sys_date_modified
		  ,min(sys_date_created) as sys_date_created
		  ,min(sys_user_modified) as sys_user_modified
		  ,min(sys_user_created) as sys_user_created
		  ,min(warehouse_type_id) as warehouse_type_id
		  ,sum(amount) as amount
		  ,min(good_category_id) as good_category_id
		  ,min(good_mark) as good_mark
		  ,min(good_category_sname) as good_category_sname
		  ,min(good_category_fname) as good_category_fname
		  ,min(unit) as unit
		  ,min(good_category_type_id) as good_category_type_id
		  ,min(good_category_type_sname) as good_category_type_sname
		  ,min(warehouse_type_sname) as warehouse_type_sname
		  ,avg(price) as price
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
group by organization_id
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


drop index [dbo].[CWRH_WAREHOUSE_ITEM].[u_wrh_type_id_gd_ctgry_id_wrh_item] 
go

CREATE UNIQUE NONCLUSTERED INDEX [u_wrh_type_id_gd_ctgry_id_org_id_wrh_item] ON [dbo].[CWRH_WAREHOUSE_ITEM] 
(
	[good_category_id] ASC,
	[warehouse_type_id] ASC,
	[organization_id] ASC
)
ON [$(fg_idx_name)]
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
  -- Мы должны уметь группировать организации в товаре и выводить общую сумму
  -- поэтому выводим с функциями
       SELECT  
		   max(id) as id
		  ,min(sys_status) as sys_status
		  ,min(sys_comment) as sys_comment
		  ,min(sys_date_modified) as sys_date_modified
		  ,min(sys_date_created) as sys_date_created
		  ,min(sys_user_modified) as sys_user_modified
		  ,min(sys_user_created) as sys_user_created
		  ,min(warehouse_type_id) as warehouse_type_id
		  ,sum(amount) as amount
		  ,min(good_category_id) as good_category_id
		  ,min(good_mark) as good_mark
		  ,min(good_category_sname) as good_category_sname
		  ,min(good_category_fname) as good_category_fname
		  ,min(unit) as unit
		  ,min(good_category_type_id) as good_category_type_id
		  ,min(good_category_type_sname) as good_category_type_sname
		  ,min(warehouse_type_sname) as warehouse_type_sname
		  ,avg(price) as price
		 --для редима редактирования выведем edit_state (нужно ли запоминать в бд?)
		  ,null as edit_state
		  ,max(organization_id)
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


