:r ./../_define.sql

:setvar dc_number 00403
:setvar dc_description "wrh_demands fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.12.2008 VLavrentiev  wrh_demands fixed
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


ALTER FUNCTION [dbo].[utfVREP_WRH_DEMAND] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по требованиям по автомобилям
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
		SELECT   a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,c.full_name as good_category_fname
			,convert(decimal(18,2), a.amount) as amount
			,a.warehouse_type_id
			,d.short_name as warehouse_type_sname
			,b.car_id
			,e.state_number
			,e.car_type_id
			,e.car_mark_id
			,e.car_model_id
			,b.number
			,b.date_created
			,b.employee_recieve_id
			,ltrim(rtrim(
									h1.lastname + ' ' + substring(h1.name,1,1) + '. '
									+ isnull(substring(h1.surname,1,1),'') + '.')) as employee_recieve_fio
			,b.employee_head_id
			,ltrim(rtrim(
									h2.lastname + ' ' + substring(h2.name,1,1) + '. '
									+ isnull(substring(h2.surname,1,1),'') + '.')) as employee_head_fio
			,b.employee_worker_id
			,ltrim(rtrim(
									h3.lastname + ' ' + substring(h3.name,1,1) + '. '
									+ isnull(substring(h3.surname,1,1),'') + '.')) as employee_worker_fio
			,g1.id as organization_recieve_id
			,g2.id as organization_head_id
			,g3.id as organization_worker_id
			,e.car_kind_id
			,b.wrh_demand_master_type_id
			,b.organization_giver_id
			,f.name as organization_giver_sname
      FROM dbo.CWRH_WRH_DEMAND_DETAIL as a
		join dbo.CWRH_WRH_DEMAND_MASTER as b on a.wrh_demand_master_id = b.id
		join dbo.CWRH_GOOD_CATEGORY as c on a.good_category_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d on a.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as f on b.organization_giver_id = f.id
		left outer join dbo.CCAR_CAR as e on b.car_id = e.id
		left outer join dbo.CPRT_EMPLOYEE as g1 on b.employee_recieve_id = g1.id
		left outer join dbo.CPRT_PERSON as h1 on g1.person_id = h1.id
		left outer join dbo.CPRT_EMPLOYEE as g2 on b.employee_head_id = g2.id
		left outer join dbo.CPRT_PERSON as h2 on g2.person_id = h2.id
		left outer join dbo.CPRT_EMPLOYEE as g3 on b.employee_worker_id = g3.id
		left outer join dbo.CPRT_PERSON as h3 on g3.person_id = h3.id
	  where	(	a.sys_status = 1
			or  a.sys_status = 3)		
		and (	b.sys_status = 1
			or  b.sys_status = 3)	
		and c.sys_status = 1	
		and d.sys_status = 1
		and isnull(e.sys_status, 1) = 1
		and f.sys_status = 1
		and isnull(h1.sys_status, 1) = 1
		and isnull(g1.sys_status, 1) = 1
		and isnull(h2.sys_status, 1) = 1
		and isnull(g2.sys_status, 1) = 1
		and isnull(h3.sys_status, 1) = 1
		and isnull(g3.sys_status, 1) = 1
)

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_wrh_demand_master_type_id numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id	numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
,@p_state_number	varchar(30)   = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.car_type_id
			,a.car_mark_id
			,a.car_model_id
			,a.number
			,a.date_created
			,a.employee_recieve_id
			,a.employee_recieve_fio
			,a.employee_head_id
			,a.employee_head_fio
			,a.employee_worker_id
			,a.employee_worker_fio
			,a.organization_recieve_id
			,a.organization_head_id
			,a.organization_worker_id
			,a.car_kind_id
			,a.organization_giver_id
			,a.organization_giver_sname
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	order by a.organization_giver_sname, a.state_number, a.date_created, a.number

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


create FUNCTION [dbo].[utfVREP_WRH_INCOME_MASTER] 
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
		  ,(e.amount*e.price) + (e.amount*e.price*0.18) as total
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


GRANT VIEW DEFINITION ON [dbo].[utfVREP_WRH_INCOME_MASTER] TO [$(db_app_user)]
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


create PROCEDURE [dbo].[uspVREP_WRH_INCOME_MASTER_SelectAll]
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
		  ,warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,a.organization_recieve_name
		  ,convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,convert(decimal(18,2),a.price) as price
		  ,convert(decimal(18,2),a.amount) as price
	FROM utfVREP_WRH_INCOME_MASTER() as a
	WHERE   date_created between @p_start_date and @p_end_date
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (a.organization_recieve_id = @p_organization_recieve_id or @p_organization_recieve_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_sname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')

	RETURN
go


GRANT EXECUTE ON [dbo].[uspVREP_WRH_INCOME_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_INCOME_MASTER_SelectAll] TO [$(db_app_user)]
GO

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
		  ,warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,a.organization_recieve_name
		  ,convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,convert(decimal(18,2),a.price) as price
		  ,convert(decimal(18,2),a.amount) as amount
	FROM utfVREP_WRH_INCOME_MASTER() as a
	WHERE   date_created between @p_start_date and @p_end_date
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	  and (a.organization_recieve_id = @p_organization_recieve_id or @p_organization_recieve_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(a.good_category_sname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')

	RETURN

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
		  ,convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) as total
		  ,convert(decimal(18,2),(a.amount*a.price)) as summa
		  ,a.good_category_sname
		  ,a.good_category_id
		  ,convert(decimal(18,2),a.price) as price
		  ,convert(decimal(18,2),a.amount) as amount
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


