
:r ./../_define.sql

:setvar dc_number 00456
:setvar dc_description "warehouse demand detail fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.04.2009 VLavrentiev   warehouse demand detail fix
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










create procedure [dbo].[uspVWRH_DEMAND_DETAIL_check_correctnes]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна заполнить план на основе предыдущего дня
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      31.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	@p_wrh_order_master_id	 numeric(38,0) 
	,@p_is_correct_demanded  char(1) = 'Y' out
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
  
    set @p_is_correct_demanded = 'Y'

    If (exists
		(select 1 from dbo.cwrh_wrh_demand_master
		   where wrh_order_master_id = @p_wrh_order_master_id
			 and is_verified = 0))
      set @p_is_correct_demanded = 'N'
	


end
go

GRANT EXECUTE ON [dbo].[uspVWRH_DEMAND_DETAIL_check_correctnes] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_DEMAND_DETAIL_check_correctnes] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях заказов-нарядов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_wrh_order_master_id numeric(38,0)
,@p_type				smallint = 1
)
AS
SET NOCOUNT ON

declare @v_date datetime

select top(1) @v_date = date_created
  from dbo.cwrh_wrh_demand_master
where wrh_order_master_id = @p_wrh_order_master_id
  order by date_created desc
--Если дата нулл - попробуем найти
if (@v_date is null)
select @v_date = b.date_started
from dbo.cwrh_wrh_order_master as a
 join dbo.CRPR_REPAIR_ZONE_MASTER as b
   on a.repair_zone_master_id = b.id
where a.id = @p_wrh_order_master_id
--Если опять нулл
set @v_date = getdate()
--Если обычный вывод	    
if (@p_type = 1)  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,a.amount
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.left_to_demand
		  ,dbo.usfWRH_ITEM_SelectBy_date_gd_id(@v_date, a.good_category_id)  
			as left_in_warehouse
		  ,dbo.usfWRH_DEMAND_SelectBy_date_gd_id(@p_wrh_order_master_id, a.good_category_id)  
			as demanded
	FROM dbo.utfVWRH_WRH_ORDER_DETAIL(@p_wrh_order_master_id) as a
--Попробуем вывести по тем, запчастям, которые еще не выдали
if (@p_type = 2)
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,a.amount
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.left_to_demand
		  ,dbo.usfWRH_ITEM_SelectBy_date_gd_id(@v_date, a.good_category_id)  
			as left_in_warehouse
		  ,dbo.usfWRH_DEMAND_SelectBy_date_gd_id(@p_wrh_order_master_id, a.good_category_id)  
			as demanded
	FROM dbo.utfVWRH_WRH_ORDER_DETAIL(@p_wrh_order_master_id) as a
    WHERE a.left_to_demand > 0

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



