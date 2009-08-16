:r ./../_define.sql

:setvar dc_number 00177                  
:setvar dc_description "warehouse income detail added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    11.04.2008 VLavrentiev  warehouse income detail added
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
PRINT ' '
go


alter table dbo.CWRH_WRH_INCOME_DETAIL
add price decimal(18,9)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Цена',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'price'
go


alter table dbo.CWRH_WRH_INCOME_DETAIL
alter column good_category_price_id numeric(38,0)
go


alter table dbo.CWRH_WRH_INCOME_MASTER
add total decimal(18,9)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Сумма',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'total'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[utfVWRH_WRH_INCOME_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей приходных документов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_income_master_id numeric(38,0)
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
		  ,a.wrh_income_master_id
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,a.amount
		  ,a.total
		  ,a.price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
      FROM dbo.CWRH_WRH_INCOME_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
	  where a.wrh_income_master_id = @p_wrh_income_master_id
	
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVWRH_WRH_INCOME_DETAIL] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях приходных документов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_wrh_income_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,wrh_income_master_id
		  ,good_category_id
		  ,good_category_price_id
		  ,amount
		  ,total
		  ,price
		  ,good_mark
		  ,good_category_sname
		  ,unit
	FROM dbo.utfVWRH_WRH_INCOME_DETAIL(@p_wrh_income_master_id)

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_WRH_INCOME_DETAIL_SaveById]
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
	,@p_amount					int
	,@p_total					int
	,@p_price					decimal(18,9) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

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
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_WRH_INCOME_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей приходных документов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.cwrh_wrh_income_detail
	where id = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_INCOME_DETAIL_DeleteById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения приходных документов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,warehouse_type_id
		  ,date_created
		  ,total
      FROM dbo.CWRH_WRH_INCOME_MASTER
	
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll]
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

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,warehouse_type_id	
		  ,date_created
		  ,total
	FROM dbo.utfVWRH_WRH_INCOME_MASTER()

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить приходный документ на складе
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(150)
	,@p_organization_id		numeric(38,0)
    ,@p_warehouse_type_id   numeric(38,0)
	,@p_date_created		datetime
	,@p_total				decimal(18,9)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_MASTER 
            ( number, organization_id
			, warehouse_type_id
			, date_created, total
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_number, @p_organization_id
			, @p_warehouse_type_id
			, @p_date_created, @p_total
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_MASTER set
		 number = @p_number
	    ,organization_id = @p_organization_id
		,warehouse_type_id = @p_warehouse_type_id
		,date_created = @p_date_created
		,total = @p_total
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
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
