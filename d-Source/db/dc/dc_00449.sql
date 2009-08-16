
:r ./../_define.sql

:setvar dc_number 00449
:setvar dc_description "rep wrh income fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   rep wrh income fix
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
		  ,case when a.account_type = 1
				then convert(decimal(18,2),a.total) 
				else convert(decimal(18,2),(convert(decimal(18,2),a.price*0.18) + convert(decimal(18,2),a.price))*a.amount)
		    end as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,case when a.account_type = 1
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
	 -- and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (a.organization_recieve_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_sname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	ORDER BY a.organization_recieve_id, a.warehouse_type_id,a.date_created, a.number

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



