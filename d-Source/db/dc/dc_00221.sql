:r ./../_define.sql

:setvar dc_number 00221
:setvar dc_description "good_category_fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    05.05.2008 VLavrentiev  good_category_fixed
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


alter table dbo.CWRH_GOOD_CATEGORY
alter column organization_id numeric(38,0)
go


alter table dbo.CWRH_GOOD_CATEGORY
alter column good_category_type_id numeric(38,0)
go



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
	,@p_full_name				varchar(60)
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

ALTER FUNCTION [dbo].[utfVWRH_GOOD_CATEGORY] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения категорий товаров
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 

(	SELECT a.id
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
		  ,a.organization_id
		  ,b.name as organization_name
		  ,a.good_category_type_id
		  ,c.short_name as good_category_type_sname
		  FROM dbo.CWRH_GOOD_CATEGORY as a
			LEFT OUTER JOIN dbo.CPRT_ORGANIZATION as b
				on a.organization_id = b.id
			LEFT OUTER JOIN dbo.CWRH_GOOD_CATEGORY_TYPE as c
				on a.good_category_type_id = c.id)
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


