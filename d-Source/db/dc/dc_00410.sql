:r ./../_define.sql

:setvar dc_number 00410
:setvar dc_description "wrh demand day wrh type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   26.01.2009 VLavrentiev  wrh demand day wrh type added
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





ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î òğåáîâàíèÿõ çà äåíü
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
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
			,convert(decimal(18,2),(a.amount*a.price) + (a.amount*a.price*0.18)) as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
		,convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created_str
	FROM dbo.utfVREP_WRH_DEMAND() as a
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
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î òğåáîâàíèÿõ çà äåíü ïî ìàøèíàì
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
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

  
       SELECT  
			 
			max(a.wrh_demand_master_id) as wrh_demand_master_id
			,a.good_category_id
			,a.good_category_fname as good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.organization_giver_id
			,a.organization_giver_sname
			,convert(decimal(18,2),sum((a.amount*a.price) + (a.amount*a.price*0.18))) as total
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	FROM dbo.utfVREP_WRH_DEMAND() as a
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
	group by a.good_category_id, a.good_category_fname
			,a.car_id,a.state_number, a.warehouse_type_id, a.warehouse_type_sname
			,a.organization_giver_id
			,a.organization_giver_sname
	order by a.organization_giver_sname, a.state_number

	RETURN



go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò ïî ñóììàğíûì âåëè÷èíàì ğàñõîäà ñî ñêëàäà
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_demand_master as a
		join dbo.cwrh_wrh_demand_detail as b on a.id = b.wrh_demand_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_giver_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò ïî ñóììàğíûì âåëè÷èíàì ïğèõîäà íà ñêëàä
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_income_master as a
		join dbo.cwrh_wrh_income_detail as b on a.id = b.wrh_income_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_recieve_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



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





