
:r ./../_define.sql

:setvar dc_number 00466
:setvar dc_description "rep demand fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   13.05.2009 VLavrentiev   rep demand fix
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
		    ,convert(decimal(18,2),a.price) as price
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
			,a.wrh_income_detail_id
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
		and b.is_verified = 1
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
,@p_warehouse_type_id	numeric(38,0) = null
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
			,case when a.wrh_income_detail_id is not null
				  then case when c.account_type = 1
							then convert(decimal(18,2), b.total/b.amount)*a.amount
						    else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
					    end 
				  else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
			  end as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created_str
	FROM dbo.utfVREP_WRH_DEMAND() as a
	left outer join dbo.cwrh_wrh_income_detail as b
		on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
		on b.wrh_income_master_id = c.id
	where a.date_created >= @p_start_date 
	  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	  and isnull(c.is_verified, 1) = 1
	order by a.organization_giver_sname, a.state_number, a.date_created, a.number

	RETURN
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день по машинам
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
,@p_organization_id numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_state_number	varchar(30)	  = null
,@p_good_category_sname varchar(100) = null
,@p_warehouse_type_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select
			max(a.wrh_demand_master_id) as wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.organization_giver_id
			,a.organization_giver_sname
			,sum(a.total) as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	    from
       (SELECT  
			 a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.organization_giver_id
			,a.organization_giver_sname
			,case when a.wrh_income_detail_id is not null
				  then case when c.account_type = 1
							then convert(decimal(18,2), b.total/b.amount)*a.amount
						    else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
					    end 
				  else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
			  end as total
	FROM dbo.utfVREP_WRH_DEMAND() as a
	left outer join dbo.cwrh_wrh_income_detail as b
		on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
		on b.wrh_income_master_id = c.id
	where  a.date_created >= @p_start_date 
	  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and a.car_id is not null
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
  and isnull(c.is_verified, 1) = 1) as a
	group by a.good_category_id, a.good_category_sname
			,a.car_id,a.state_number, a.warehouse_type_id, a.warehouse_type_sname
			,a.organization_giver_id
			,a.organization_giver_sname
	order by a.organization_giver_sname, a.state_number

	RETURN
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
		    ,convert(decimal(18,2),a.price) as price
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
			,a.wrh_income_detail_id
			,case when b.is_verified = 0
			      then 'Не проверен'
			      when b.is_verified = 1
			      then 'Проверен'
			  end as is_verified
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
		and b.is_verified != 2
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
		  ,case when a.account_type = 1
				then e.total 
				else (e.amount*e.price) + (e.amount*e.price*0.18)
			end  as total
		  ,(e.amount*e.price) as summa
		  ,f.full_name as good_category_sname
		  ,e.price
		  ,e.amount
		  ,e.good_category_id
		  ,a.account_type
		  ,case when a.is_verified = 0
			then 'Не проверен'
			when a.is_verified = 1
			then 'Проверен'
		    end  as is_verified
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
		and a.is_verified != 2
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
,@p_warehouse_type_id	numeric(38,0) = null
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
			,case when a.wrh_income_detail_id is not null
				  then case when c.account_type = 1
							then convert(decimal(18,2), b.total/b.amount)*a.amount
						    else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
					    end 
				  else convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) 
			  end as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created_str
	        ,a.is_verified
	FROM dbo.utfVREP_WRH_DEMAND() as a
	left outer join dbo.cwrh_wrh_income_detail as b
		on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
		on b.wrh_income_master_id = c.id
	where a.date_created >= @p_start_date 
	  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	  and (a.organization_giver_id = @p_organization_id or @p_organization_id is null)
	  and (a.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	  and (upper(a.good_category_fname) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
	  and isnull(c.is_verified, 1) != 2
	order by a.organization_giver_sname, a.state_number, a.date_created, a.number

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
	    ,a.is_verified
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



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVWRH_WAREHOUSE_ITEM_SelectByType_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о содержимом склада
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0) = null
 ,@p_warehouse_type_id	   numeric(38,0) = null
 ,@p_organization_id	   numeric(38,0) = null
 ,@p_Str				  varchar(100) = null
 ,@p_Srch_Type			   tinyint = null 
 ,@p_Top_n_by_rank		   smallint = null
)
AS
SET NOCOUNT ON

declare
      @v_Srch_Str      varchar(1000)
 
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1

 if (@p_Str is null)
    set @p_Str = ''
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  -- Мы должны уметь группировать организации в товаре и выводить общую сумму
  -- поэтому выводим с функциями
       SELECT  
		   max(id) as id
		  ,min(sys_status) as sys_status
		  ,min(sys_comment) as sys_comment
		  ,min(sys_date_modified) as sys_date_modified
		  ,min(sys_date_created) as sys_date_created
		  ,min(sys_user_modified) as sys_user_modified
		  ,min(sys_user_created) as sys_user_created
		  ,min(warehouse_type_id) as warehouse_type_id
		  ,sum(amount) as amount
		  ,min(good_category_id) as good_category_id
		  ,min(good_mark) as good_mark
		  ,min(good_category_sname) as good_category_sname
		  ,min(good_category_fname) as good_category_fname
		  ,min(unit) as unit
		  ,min(good_category_type_id) as good_category_type_id
		  ,min(good_category_type_sname) as good_category_type_sname
		  ,min(warehouse_type_sname) as warehouse_type_sname
		  ,avg(price) as price
		 --для режима редактирования выведем edit_state (нужно ли запоминать в бд?)
		  ,null as edit_state
		  ,max(organization_id) as organization_id
		  ,case when @p_organization_id is null  then 'Все организации'
				else max(organization_sname)
		    end as organization_sname
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id
									,@p_organization_id) as a
    WHERE 
--поиск
(((@p_Str != '')
		   and (rtrim(ltrim(upper(good_category_sname))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))
		or (@p_Str = '')) */
group by good_category_id
	having sum(amount) <> 0 


	RETURN
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER FUNCTION [dbo].[utfVWRH_WAREHOUSE_ITEM] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения содержимого склада
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0)
 ,@p_warehouse_type_id	   numeric(38,0)
 ,@p_organization_id	   numeric(38,0)	
)
RETURNS TABLE 
AS
RETURN 
(
select 
		   b2.id
		  ,b2.sys_status
		  ,b2.sys_comment
		  ,b2.sys_date_modified
		  ,b2.sys_date_created
		  ,b2.sys_user_modified
		  ,b2.sys_user_created
		  ,b2.short_name as good_category_sname
		  ,b2.full_name as good_category_fname
		  ,b2.unit
		  ,b2.good_category_type_id
		  ,d2.short_name as good_category_type_sname
		  ,c2.short_name as warehouse_type_sname
		  ,b2.good_mark
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.organization_id
		  ,e2.name as organization_sname
from 
(select sum(a.amount) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,a.organization_id  from 
(select sum(a.amount) as amount, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,b.organization_recieve_id  as organization_id 
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
group by b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,b.organization_giver_id as organization_id from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
group by b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price)
as a
group by a.organization_id,  a.warehouse_type_id, a.good_category_id,a.price) as a
	   join dbo.CWRH_GOOD_CATEGORY as b2
			on a.good_category_id = b2.id
	   join dbo.CWRH_WAREHOUSE_TYPE as c2
			on a.warehouse_type_id = c2.id
	   left outer join dbo.CWRH_GOOD_CATEGORY_TYPE as d2
			on b2.good_category_type_id = d2.id
	   left outer join dbo.CPRT_ORGANIZATION as e2
			on a.organization_id = e2.id
WHERE		(a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
	   AND (b2.good_category_type_id = @p_good_category_type_id
			or @p_good_category_type_id is null)
	   AND (a.organization_id = @p_organization_id
			or @p_organization_id is null)	
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




