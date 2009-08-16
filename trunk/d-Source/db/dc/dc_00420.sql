:r ./../_define.sql

:setvar dc_number 00420
:setvar dc_description "rem agregats flow changed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   12.03.2009 VLavrentiev   rem agregats flow changed
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


insert into dbo.csys_const(id, name, description)
values(1013, 'WRH_REMAGREGAT', 'Ид склада ремагрегатов')
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVREP_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция для отображения отчета по приходным документам
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
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.number
		  ,a.organization_id
		  ,b.name as organization_name 
		  ,a.warehouse_type_id
		  ,c.short_name as warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,d.name as organization_recieve_name
		  ,case when a.warehouse_type_id = dbo.usfConst('WRH_REMAGREGAT')
				then e.total 
				else (e.amount*e.price) + (e.amount*e.price*0.18)
			end  as total
		  ,(e.amount*e.price) as summa
		  ,f.full_name as good_category_sname
		  ,e.price
		  ,e.amount
		  ,e.good_category_id
      FROM dbo.CWRH_WRH_INCOME_MASTER as a
		join dbo.cwrh_WRH_INCOME_DETAIL as e on a.id = e.wrh_income_master_id
		join dbo.CPRT_ORGANIZATION as b on a.organization_id = b.id
		join dbo.CWRH_WAREHOUSE_TYPE as c on a.warehouse_type_id = c.id
		join dbo.CPRT_ORGANIZATION as d on a.organization_recieve_id = d.id
		join dbo.CWRH_GOOD_CATEGORY as f on e.good_category_id = f.id 
	  where (a.sys_status = 1 or a.sys_status = 3)
		and (e.sys_status = 1 or e.sys_status = 3)
		and b.sys_status = 1
		and c.sys_status = 1
		and d.sys_status = 1
		and f.sys_status = 1 
)

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_WRH_INCOME_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные для отчета о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_organization_id	numeric(38,0) = null
,@p_organization_recieve_id	numeric(38,0) = null
,@p_good_category_id	numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON
  
       SELECT  
		   a.number
		  ,a.organization_id
		  ,a.organization_name 
		  ,a.warehouse_type_id
		  ,a.warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,a.organization_recieve_name
		  ,case when a.warehouse_type_id = dbo.usfConst('WRH_REMAGREGAT')
				then convert(decimal(18,2),a.total) 
				else convert(decimal(18,2),(convert(decimal(18,2),a.price*0.18) + convert(decimal(18,2),a.price))*a.amount)
		    end as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,case when a.warehouse_type_id = dbo.usfConst('WRH_REMAGREGAT')
				then convert(decimal(18,2), a.total/a.amount)
				else
				convert(decimal(18,2),a.price*0.18) + convert(decimal(18,2),a.price) 
			 end as price
		  ,convert(decimal(18,2),a.amount) as amount
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created_str
	FROM utfVREP_WRH_INCOME_MASTER() as a
	WHERE   date_created between @p_start_date and @p_end_date
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (a.organization_recieve_id = @p_organization_recieve_id or @p_organization_recieve_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_sname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	ORDER BY a.organization_recieve_id, a.warehouse_type_id, a.number

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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql




