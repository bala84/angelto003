
:r ./../_define.sql

:setvar dc_number 00440
:setvar dc_description "warehouse type id demand detail fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   02.04.2009 VLavrentiev   warehouse type id demand detail fixed
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


alter table dbo.cwrh_wrh_demand_detail
alter column warehouse_type_id numeric(38,0) null
go

alter table dbo.crep_wrh_demand
alter column warehouse_type_id numeric(38,0) null
go

alter table dbo.crep_wrh_demand
alter column warehouse_type_sname varchar(30) null
go


alter table dbo.crep_warehouse_item_day
alter column warehouse_type_id numeric(38,0) null
go

alter table dbo.crep_warehouse_item_day
alter column warehouse_type_sname varchar(30) null
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVWRH_WRH_DEMAND_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_demand_master_id numeric(38,0)
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
		  ,a.wrh_demand_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,a.warehouse_type_id
		  ,c.short_name as warehouse_type_sname
		  ,convert(decimal(18,2), a.price) as price
		  ,a.wrh_income_detail_id
      FROM dbo.CWRH_WRH_DEMAND_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
		left outer JOIN dbo.CWRH_WAREHOUSE_TYPE as c
			on a.warehouse_type_id = c.id
	  where a.wrh_demand_master_id = @p_wrh_demand_master_id
	
)
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


