:r ./../_define.sql

:setvar dc_number 00400
:setvar dc_description "reason type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   26.11.2008 VLavrentiev  reason type added
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



insert into dbo.CCAR_CAR_RETURN_REASON_TYPE(short_name, full_name)
values('Неисправность автомобиля', 'Неисправность автомобиля')
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей заказов-нарядов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_order_master_id numeric(38,0)
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
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,isnull(convert(decimal(18,2), a.amount) - convert(decimal(18,2), c.left_to_demand), convert(decimal(18,2), a.amount)) as left_to_demand
      FROM dbo.CWRH_WRH_ORDER_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
      outer apply(
		   select sum(e.amount) as left_to_demand
			from dbo.CWRH_WRH_DEMAND_MASTER as d
		left outer join dbo.CWRH_WRH_DEMAND_DETAIL as e
			on d.id = e.wrh_demand_master_id 
			where a.wrh_order_master_id = d.wrh_order_master_id
			  and e.good_category_id = a.good_category_id
			group by e.good_category_id) as c
	  where a.wrh_order_master_id = @p_wrh_order_master_id
	  union all
	  select null
			,null
			,null
			,null
			,null
			,null
			,null
			,a2.wrh_order_master_id
		    ,a.good_category_id
		    ,0 as amount
		    ,c.good_mark
		    ,c.short_name as good_category_sname
		    ,c.unit
		    ,- sum(convert(decimal(18,2), a.amount)) as left_to_demand
	  from dbo.cwrh_wrh_demand_detail as a
		join dbo.cwrh_wrh_demand_master as a2 on a.wrh_demand_master_id = a2.id
		join dbo.cwrh_wrh_order_master as b on a2.wrh_order_master_id = b.id
		JOIN dbo.CWRH_GOOD_CATEGORY as c
			on a.good_category_id = c.id
	  where not exists
		(select 1 from dbo.cwrh_wrh_order_detail as d
			where d.wrh_order_master_id = a2.wrh_order_master_id
			  and d.good_category_id = a.good_category_id)
		and b.id = @p_wrh_order_master_id
	  group by 
			 a2.wrh_order_master_id
		    ,a.good_category_id
		    ,c.good_mark
		    ,c.short_name
		    ,c.unit
	
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

:r _add_chis_all_objects.sql


