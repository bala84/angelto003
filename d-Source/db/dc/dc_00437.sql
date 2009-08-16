:r ./../_define.sql

:setvar dc_number 00437
:setvar dc_description "income order number fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   01.04.2009 VLavrentiev   income order number fix
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
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSYS_INCOME_ORDER_MASTER_NUMBER_SEQ](
	[number] [numeric](38, 0) IDENTITY(1,1) NOT NULL,
	[sys_comment] [varchar](10) NULL,
 CONSTRAINT [CSYS_INCOME_ORDER_MASTER_NUMBER_pk] PRIMARY KEY CLUSTERED 
(
	[number] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SaveById]
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
  set xact_abort on

  declare
    @v_is_verified bit
   ,@v_account_type smallint
   ,@v_number varchar(150)
		,@v_Error int
        ,@v_TrancountOnEntry int


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



     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


       -- надо добавлять
  if (@p_id is null)
    begin

		if (@@tranCount = 0)
         begin transaction  


		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_INCOME_ORDER_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number

	   insert into
			     dbo.CWRH_WRH_INCOME_ORDER_MASTER 
            ( number 
			, date_created, total, is_verified
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @v_number
			, @p_date_created, @p_total,  @v_is_verified
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();


	  if (@@tranCount > @v_TrancountOnEntry)
        commit

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
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_ORDER_MASTER_SelectAll]
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id]
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
		  ,d.number
		  ,d.date_created
		  ,d.total
	FROM dbo.CWRH_WRH_INCOME_ORDER_DETAIL as a
	join dbo.CWRH_GOOD_CATEGORY as b
	on a.good_category_id = b.id
	join dbo.ccar_car as c
	on a.car_id = c.id
	join dbo.cwrh_wrh_income_order_master as d
	on a.wrh_income_order_master_id = d.id
	 where a.wrh_income_order_master_id = @p_wrh_income_order_master_id
	   and b.sys_status = 1
	   and c.sys_status = 1
	   and a.sys_status = 1
	   and d.sys_status = 1
   order by c.state_number, b.short_name

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

alter PROCEDURE [dbo].[uspVREP_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id]
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
		  ,convert(decimal(18,2), a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,a.car_id
		  ,c.state_number
		  ,d.number
		  ,d.date_created
		  ,convert(decimal(18,2), d.total) as total
	FROM dbo.CWRH_WRH_INCOME_ORDER_DETAIL as a
	join dbo.CWRH_GOOD_CATEGORY as b
	on a.good_category_id = b.id
	join dbo.ccar_car as c
	on a.car_id = c.id
	join dbo.cwrh_wrh_income_order_master as d
	on a.wrh_income_order_master_id = d.id
	 where a.wrh_income_order_master_id = @p_wrh_income_order_master_id
	   and b.sys_status = 1
	   and c.sys_status = 1
	   and a.sys_status = 1
	   and d.sys_status = 1
   order by c.state_number, b.short_name

	RETURN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_DeleteAll_ByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить план за определенную дату
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_date					datetime 
	,@p_organization_id			numeric(38,0)
	,@p_car_kind_id			numeric(38,0)
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

   update dbo.CDRV_DRIVER_PLAN_DETAIL
	set sys_user_modified = @p_sys_user
	where date =  @p_date
	  and organization_id = @p_organization_id
	  and car_kind_id = @p_car_kind_id

	delete
	from dbo.CDRV_DRIVER_PLAN_DETAIL
	where date =  @p_date
	  and organization_id = @p_organization_id
	  and car_kind_id = @p_car_kind_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_DeleteAll_ByDate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_DeleteAll_ByDate] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из детальных планов выхода на линию по машинам
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

  --Чтобы всегда срабатывал триггер до изменений - проапдейтим любую запись

  update top(1) dbo.CDRV_DRIVER_PLAN_DETAIL
	set sys_comment = '-'

      if (@@tranCount = 0)
        begin transaction  

   update dbo.CDRV_DRIVER_PLAN_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.CDRV_DRIVER_PLAN_DETAIL
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SaveById]
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
    ,@p_time			 varchar(5)	   = null
	,@p_employee_id		 numeric(38,0) = null
	,@p_shift_number	 tinyint	   = null
	,@p_comments		 varchar(1000) = null
	,@p_mech_employee_id numeric(38,0) = null
	,@p_is_completed	 bit		   = 0
	,@p_rownum			 int		
	,@p_organization_id	 numeric(38,0) 
	,@p_organization_sname	varchar(100)
	,@p_car_kind_id		numeric(38,0)
	,@p_car_kind_sname	varchar(30)
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

    select @v_time = convert(datetime, substring(convert(varchar(30), @p_date), 1, 11) + ' ' + @p_time + ':00')
															
    

   if (@p_is_completed is null)
    set @p_is_completed = 0

  --Чтобы всегда срабатывал триггер до изменений - проапдейтим любую запись

  update top(1) dbo.CDRV_DRIVER_PLAN_DETAIL
	set sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_employee_id, @p_shift_number, @p_comments ,@p_mech_employee_id, @p_is_completed
		    ,@p_rownum, @p_organization_id, @p_organization_sname, @p_car_kind_id, @p_car_kind_sname 	
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_PLAN_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, employee_id = @p_employee_id
		, shift_number = @p_shift_number
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, is_completed     = @p_is_completed
		, rownum = @p_rownum
		, organization_id = @p_organization_id
		, organization_sname = @p_organization_sname
		, car_kind_id = @p_car_kind_id
		, car_kind_sname = @p_car_kind_sname
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





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
    ,@p_short_name				varchar(120)
	,@p_full_name				varchar(120)
	,@p_unit					varchar(20)
	,@p_parent_id				numeric(38,0)
	,@p_organization_id			numeric(38,0) = null
	,@p_good_category_type_id	numeric(38,0) = null
	,@p_car_mark_id			    numeric(38,0) = null
	,@p_car_model_id			numeric(38,0) = null    
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

	set @p_short_name = @p_full_name

	 if (@p_unit is null)
	set @p_unit = 'шт.'

  if (@p_id is null)
   begin   
    insert into
			     dbo.CWRH_GOOD_CATEGORY 
            ( good_mark, short_name, full_name, organization_id, good_category_type_id, unit, parent_id, car_mark_id, car_model_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_good_mark, @p_short_name, @p_full_name, @p_organization_id, @p_good_category_type_id, @p_unit, @p_parent_id,  @p_car_mark_id, @p_car_model_id, @p_sys_comment, @p_sys_user, @p_sys_user)
	 
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
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,good_category_type_id  = @p_good_category_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end

go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из CAR
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.ccar_car
	set sys_user_modified = @p_sys_user
	where id = @p_id

   update dbo.ccar_condition
	set sys_user_modified = @p_sys_user
	where car_id = @p_id

    delete from dbo.ccar_condition
	where car_id = @p_id

	delete
	from dbo.ccar_car
	where id = @p_id


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


