:r ./../_define.sql

:setvar dc_number 00405
:setvar dc_description "common repairs report added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   25.12.2008 VLavrentiev  common repairs report added
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

CREATE PROCEDURE [dbo].[uspVREP_COMMON_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет об основных ремонтах в ремзоне
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id
	 , e.short_name as car_kind_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id
	 , e.short_name as car_mark_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id
	 , d.state_number
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN
go


GRANT EXECUTE ON [dbo].[uspVREP_COMMON_REPAIRS_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_COMMON_REPAIRS_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_ADDTNL_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет об доп ремонтах (вне ремзоны)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id
	 , e.short_name as car_kind_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id
	 , e.short_name as car_mark_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id
	 , d.state_number
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN

go

GRANT EXECUTE ON [dbo].[uspVREP_ADDTNL_REPAIRS_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_ADDTNL_REPAIRS_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_TS_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id
	 , e.short_name as car_kind_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id
	 , e.short_name as car_mark_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id
	 , d.state_number
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN
go

GRANT EXECUTE ON [dbo].[uspVREP_TS_REPAIRS_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_TS_REPAIRS_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_ADDTNL_TS_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о дополнительных ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id
	 , e.short_name as car_kind_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id
	 , e.short_name as car_mark_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id
	 , d.state_number
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN
go



GRANT EXECUTE ON [dbo].[uspVREP_ADDTNL_TS_REPAIRS_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_ADDTNL_TS_REPAIRS_SelectAll] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_COMMON_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет об основных ремонтах в ремзоне
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 0)
select 1 as organization_id
	 , 'По автоколонне в целом' as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by c.short_name
order by c.short_name

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id as organization_id
	 , e.short_name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id as organization_id
	 , e.short_name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id as organization_id
	 , d.state_number as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 412
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_ADDTNL_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет об доп ремонтах (вне ремзоны)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 0)
select 1 as organization_id
	 , 'По автоколонне в целом' as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by c.short_name
order by c.short_name

if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, c.short_name
order by e.name, c.short_name



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id as organization_id
	 , e.short_name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, c.short_name
order by e.short_name, c.short_name

if (@p_report_type = 3)
select d.car_mark_id as organization_id
	 , e.short_name as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, c.short_name
order by e.short_name, c.short_name


if (@p_report_type = 4)
select d.id as organization_id
	 , d.state_number as organization_sname
	 , c.short_name as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 413
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, c.short_name
order by d.state_number, c.short_name




	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_TS_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 0)
select 1 as organization_id
	 , 'В целом по автоколонне' as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  
order by g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 


if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id as organization_id
	 , e.short_name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 

if (@p_report_type = 3)
select d.car_mark_id as organization_id
	 , e.short_name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 

if (@p_report_type = 4)
select d.id as organization_id
	 , d.state_number as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 410
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by d.state_number, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 




	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_ADDTNL_TS_REPAIRS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о дополнительных ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 0)
select 1 as organization_id
	 , 'В целом по автоколонне' as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  
order by g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 


if (@p_report_type = 1)
select d.organization_id
	 , e.name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.cprt_organization as e on d.organization_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.organization_id, e.name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 



--Если отчет по видам ремонта, то следующий выбор
if (@p_report_type = 2  )
    select d.car_kind_id as organization_id
	 , e.short_name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_kind as e on d.car_kind_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_kind_id, e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 

if (@p_report_type = 3)
select d.car_mark_id as organization_id
	 , e.short_name as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_car_mark as e on d.car_mark_id = e.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and e.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.car_mark_id, e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by e.short_name, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 

if (@p_report_type = 4)
select d.id as organization_id
	 , d.state_number as organization_sname
	 , g.short_name + ' - ' + h.short_name + ' - ' + c.short_name  as repair_type_sname
	 , count(*) as kol
  from dbo.cwrh_wrh_order_master as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b on a.id = b.wrh_order_master_id
	join dbo.crpr_repair_type_master as c on b.repair_type_master_id = c.id
	join dbo.ccar_car as d on a.car_id = d.id
	join dbo.ccar_ts_type_master as f on c.id = f.id
	join dbo.ccar_car_mark as g on f.car_mark_id = g.id
	join dbo.ccar_car_model as h on f.car_model_id = h.id
  where a.sys_status = 1
	and b.sys_status = 1
	and c.sys_status = 1
	and d.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
	and h.sys_status = 1
	and a.order_state = 1
	and c.repair_type_master_kind_id = 411
	and a.date_created >= @p_start_date
	and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
group by d.id, d.state_number, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 
order by d.state_number, g.short_name + ' - ' + h.short_name + ' - ' + c.short_name 




	RETURN

go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_report_type		smallint
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

if (@p_report_type = 0)
select 1 as organization_id
	 , 'В целом по автоколонне' as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)

if (@p_report_type = 1)
select c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
order by c.name
  

if (@p_report_type = 2  )
select c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
order by c.short_name
  

if (@p_report_type = 3)
select c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
order by c.short_name
  
  
if (@p_report_type = 4)
select b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
order by b.state_number




	RETURN

go




GRANT EXECUTE ON [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select *
 from
(select 0 as report_type
	 , 'В целом по автоколонне' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'По организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'По видам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'По маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'По эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'По VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'По машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname




	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select *
 from
(select 0 as report_type
	 , 'Средние значения по путевым листам(в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по МТО' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN

go




GRANT EXECUTE ON [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll] TO [$(db_app_user)]
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения по путевым листам(в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по МТО' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(a.date_created), dateadd("mm", 1, dbo.usfUtils_DayTo01(a.date_created)))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVREP_SUM_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select *
 from
(select 0 as report_type
	 , 'В целом по автоколонне' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'По организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'По видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end  as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'По маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'По эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'По VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'По машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,0),sum(run)) as run
	 , convert(decimal(18,0),sum(fuel_consumption)) as cnsmptn
	 , count(*) as kol
	 , sum(datediff("MI", fact_start_duty, fact_end_duty))/60 as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname




	RETURN


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/max(day_count)) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",dbo.usfUtils_DayTo01(@p_start_date), dbo.usfUtils_DayTo01(@p_end_date))
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN



go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,0),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,0),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_AVG_DRIVER_LIST_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о путевых листах (средние значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,case when run = 0 then null else run end as run
	  ,case when cnsmptn = 0 then null else cnsmptn end as cnsmptn
	  ,case when kol = 0 then null else kol end as kol
	  ,case when time_on_line = 0 then null else time_on_line end as time_on_line
 from
(select 0 as report_type
	 , 'Средние значения (в целом по автоколонне)' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'Средние значения по организации' as header
	 , c.id as organization_id
	 , c.name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.cprt_organization as c on b.organization_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.name
--order by c.name
union all
select 2 as report_type
	 , 'Средние значения по видам автомобилей' as header
	 , c.id as organization_id
	 , case c.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_kind as c on b.car_kind_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
--order by c.short_name
union all
select 3 as report_type
	 , 'Средние значения по маркам автомобилей' as header
	 , c.id as organization_id
	 , c.short_name as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , convert(decimal(18,2),count(*)/case when max(day_count) = 0 then 1 else max(day_count) end) as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 join dbo.ccar_car_mark as c on b.car_mark_id = c.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by c.id, c.short_name
---order by c.short_name
union all
select 4 as report_type
	 , 'Средние значения по эвакуаторам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 50
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 5 as report_type
	 , 'Средние значения по техничкам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 51
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 6 as report_type
	 , 'Средние значения по VIP-трансферам' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 53
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number
--order by b.state_number
union all
select 7 as report_type
	 , 'Средние значения по машинам обспечения' as header
	 , b.id as organization_id
	 , b.state_number as organization_sname	
	 , convert(decimal(18,2),sum(run)/count(*)) as run
	 , convert(decimal(18,2),sum(fuel_consumption)/count(*)) as cnsmptn
	 , 0 as kol
	 , convert(decimal(18,2),(sum(datediff("MI", fact_start_duty, fact_end_duty))/60)/count(*)) as time_on_line
from dbo.cdrv_driver_list as a
 join dbo.ccar_car as b on a.car_id = b.id
 outer apply
	(select datediff("Day",@p_start_date, @p_end_date)
	 as day_count) as z
where a.sys_status = 1
  and b.sys_status = 1
  and b.car_kind_id = 52
  and a.driver_list_state_id = dbo.usfCOnst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by b.id, b.state_number) as a
order by report_type, organization_sname



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


