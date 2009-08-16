:r ./../_define.sql

:setvar dc_number 00432
:setvar dc_description "income order procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.03.2009 VLavrentiev   income order procs added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
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
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,date_created
		  ,total
		  ,convert(decimal(18,2), total) as total
		  ,case when is_verified = 0 then 'Не проверен'
				else 'Проверен'
			end as is_verified
	FROM dbo.CWRH_WRH_INCOME_ORDER_MASTER
	WHERE   date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		  and (rtrim(ltrim(upper(number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	   

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll] TO [$(db_app_user)]
GO




set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить заявку на закупку на склад
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(150)
	,@p_date_created		datetime
	,@p_total				decimal(18,9)
	,@p_is_verified			varchar(30) = 'Не проверен'
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  declare
    @v_is_verified bit
   ,@v_account_type smallint



     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'


	if (@p_is_verified = 'Не проверен')
	 set @v_is_verified = 0
	else
	 set @v_is_verified = 1



       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_ORDER_MASTER 
            ( number 
			, date_created, total, is_verified
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_number
			, @p_date_created, @p_total,  @v_is_verified
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_ORDER_MASTER set
		 number = @p_number
		,date_created = @p_date_created
		,total = @p_total
		,is_verified = @v_is_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end

go

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из заявок на закупку
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
	,@p_sys_user	varchar(30) = null
	,@p_sys_comment varchar(2000) = '-'
)
as
begin
  set nocount on
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 

   update dbo.cwrh_wrh_income_order_detail
	set sys_user_modified = @p_sys_user
	where wrh_income_order_master_id = @p_id

	delete from dbo.cwrh_wrh_income_order_detail
	where wrh_income_order_master_id = @p_id


   update dbo.cWRH_WRH_INCOME_ORDER_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.cWRH_WRH_INCOME_ORDER_MASTER
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 
end

go

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_DeleteById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях заявок на закупку запчастей
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_wrh_income_order_master_id numeric(38,0)
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
		  ,a.wrh_income_order_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,convert(decimal(18,2), a.total) as total
		  ,convert(decimal(18,2), a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,a.car_id
		  ,c.state_number
	FROM dbo.СWRH_WRH_INCOME_ORDER_DETAIL as a
	join dbo.CWRH_GOOD_CATEGORY as b
	on a.good_category_id = b.id
	join dbo.ccar_car as c
	on a.car_id = c.id
	 where a.wrh_income_order_master_id = @p_wrh_income_order_master_id
	   and b.sys_status = 1
	   and c.sys_status = 1

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SaveById]
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
    ,@p_wrh_income_order_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
    ,@p_car_id					numeric(38,0)
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


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_ORDER_DETAIL 
            ( wrh_income_order_master_id, good_category_id
			, car_id, amount
			, total, price
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_income_order_master_id, @p_good_category_id
			, @p_car_id, @p_amount
			, @p_total, @p_price
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
   begin
	
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_ORDER_DETAIL set
		 wrh_income_order_master_id = @p_wrh_income_order_master_id
	    ,good_category_id = @p_good_category_id
		,car_id = @p_car_id
		,amount = @p_amount
		,total = @p_total
		,price = @p_price
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
   end	


  return 

end
go

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей заявок на за
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

   update dbo.cWRH_WRH_INCOME_ORDER_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id

 

	delete
	from dbo.cWRH_WRH_INCOME_ORDER_DETAIL
	where id = @p_id



	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_DeleteById] TO [$(db_app_user)]
GO




alter table dbo.ccar_return_reason_detail
add is_verified bit default 0
go

create index i_ccar_return_reason_detail_is_verified on dbo.ccar_return_reason_detail(is_verified)
on $(fg_idx_name)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Проверена запись или нет' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ccar_return_reason_detail', @level2type=N'COLUMN', @level2name=N'is_verified'

GO

alter table dbo.ccar_noexit_reason_detail
add is_verified bit default 0
go

create index i_ccar_noexit_reason_detail_is_verified on dbo.ccar_noexit_reason_detail(is_verified)
on $(fg_idx_name)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Проверена запись или нет' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'ccar_noexit_reason_detail', @level2type=N'COLUMN', @level2name=N'is_verified'

GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVCAR_RETURN_REASON_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о причинах возврата
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,a.time
	  ,a.comments
	  ,a.mech_employee_id
	  ,g.id as organization_id
	  ,g.name as organization_sname
	  ,f.id as car_kind_id
	  ,f.short_name as car_kind_sname
	  ,a.rownum
	  ,e.id as car_return_reason_type_id
	  ,e.short_name as car_return_reason_type_sname
	  ,case when a.is_verified = 0 then 'Не проверен'
			else 'Проверен'
		end as is_verified
  from dbo.CCAR_RETURN_REASON_DETAIL as a
	join dbo.ccar_car as b
	  on a.car_id = b.id
	join dbo.ccar_car_return_reason_type as e
	  on e.id = a.car_return_reason_type_id
	join dbo.ccar_car_kind as f
	  on b.car_kind_id = f.id
	join dbo.cprt_organization as g
	  on b.organization_id = g.id
  where e.sys_status = 1
	and b.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
    and a.date = @p_date
	and b.car_kind_id = @p_car_kind_id
	and b.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go









ALTER procedure [dbo].[uspVCAR_RETURN_REASON_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить причины возврата
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 	 datetime	   = null
	,@p_comments		 	varchar(1000) = null
	,@p_mech_employee_id 		numeric(38,0) = null
	,@p_car_return_reason_type_id	numeric(38,0)
	,@p_rownum			int
	,@p_is_verified		varchar(30) = null
    	,@p_sys_comment		varchar(2000)  = '-'
    	,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime
	       ,@v_is_verified bit


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'

	if (@p_is_verified = 'Не проверен')
	set @v_is_verified = 0
	else
	set @v_is_verified = 1

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_RETURN_REASON_DETAIL
            (car_id, date, "time",  comments ,mech_employee_id, car_return_reason_type_id, is_verified
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_comments ,@p_mech_employee_id, @p_car_return_reason_type_id, @v_is_verified
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_RETURN_REASON_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, car_return_reason_type_id     = @p_car_return_reason_type_id
	    , is_verified = @v_is_verified
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о невыходе на линию
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,a.time
	  ,a.comments
	  ,a.mech_employee_id
	  ,g.id as organization_id
	  ,g.name as organization_sname
	  ,f.id as car_kind_id
	  ,f.short_name as car_kind_sname
	  ,a.rownum
	  ,e.id as car_noexit_reason_type_id
	  ,e.short_name as car_noexit_reason_type_sname
	  ,case when a.is_verified = 0 then 'Не проверен'
			else 'Проверен'
		end as is_verified
  from dbo.CCAR_NOEXIT_REASON_DETAIL as a
	join dbo.ccar_car as b
	  on a.car_id = b.id
	join dbo.ccar_car_noexit_reason_type as e
	  on e.id = a.car_noexit_reason_type_id
	join dbo.ccar_car_kind as f
	  on b.car_kind_id = f.id
	join dbo.cprt_organization as g
	  on b.organization_id = g.id
  where e.sys_status = 1
	and b.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
    and a.date = @p_date
	and b.car_kind_id = @p_car_kind_id
	and b.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN

go

GRANT EXECUTE ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SelectByDate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SelectByDate] TO [$(db_app_user)]
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE procedure [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить детальный план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 	 datetime	   = null
	,@p_comments		 	varchar(1000) = null
	,@p_mech_employee_id 		numeric(38,0) = null
	,@p_car_noexit_reason_type_id	numeric(38,0)
	,@p_rownum			int
	,@p_is_verified		varchar(30) = null
    	,@p_sys_comment		varchar(2000)  = '-'
    	,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime
	       ,@v_is_verified bit


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'

	if (@p_is_verified = 'Не проверен')
	set @v_is_verified = 0
	else
	set @v_is_verified = 1

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_NOEXIT_REASON_DETAIL
            (car_id, date, "time",  comments ,mech_employee_id, car_noexit_reason_type_id, is_verified
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_comments ,@p_mech_employee_id, @p_car_noexit_reason_type_id, @v_is_verified
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_NOEXIT_REASON_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, car_noexit_reason_type_id     = @p_car_noexit_reason_type_id
	    , is_verified = @v_is_verified
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из причин невыхода
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) 
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
	set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction  

   update dbo.CCAR_NOEXIT_REASON_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.CCAR_NOEXIT_REASON_DETAIL
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_NOEXIT_REASON_DETAIL_DeleteById] TO [$(db_app_user)]
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



