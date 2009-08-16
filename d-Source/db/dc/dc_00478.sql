
:r ./../_define.sql

:setvar dc_number 00478
:setvar dc_description "new repair_type count report added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   13.07.2009 VLavrentiev   new repair_type count report added
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


CREATE FUNCTION [dbo].[usfConstDecimal] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения констант CSYS_CONST, которые возвращают дробное число
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_name varchar(60)
)
RETURNS decimal(18,2)
AS
BEGIN	
DECLARE @p_Result_id decimal(18,2);

	SELECT @p_Result_id = convert(decimal(18,2), id) from dbo.utfVSYS_CONST()
	WHERE name = @p_name;

	RETURN @p_Result_id
END
go


GRANT VIEW DEFINITION ON [dbo].[usfConstDecimal] TO [$(db_app_user)]
GO


insert into dbo.csys_const(id, name, description)
values('0.18', 'ACCOUNT_TAX', 'Налог НДС')
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве ремонтов с затратами по видам и
** маркам автомобилей
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
,@p_wo_remaggregates    bit = 0
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

  with src 
	(car_kind_id
	,car_kind_sname
	,car_mark_id
	,car_mark_sname
	,repair_type_id
	,repair_type_sname
    ,total
	,account_kind)
as
(select b.car_kind_id
	  ,c.short_name as car_kind_sname
	  ,b.car_mark_id
	  ,d.short_name as car_mark_sname
	  ,f.id as repair_type_id
	  ,f.full_name as repair_type_sname
	  ,isnull(g.total, 0) as total
	  ,isnull(g.account_kind, 'Без списания') as account_kind
 from dbo.cwrh_wrh_order_master as a
 join dbo.ccar_car as b
	on a.car_id = b.id
 join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
 join dbo.ccar_car_mark as d
	on b.car_mark_id = d.id
 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
	on a.id = e.wrh_order_master_id
 join dbo.CRPR_REPAIR_TYPE_MASTER as f
	on e.repair_type_master_id = f.id
outer apply
(select 
			 case when a2.wrh_income_detail_id is not null
				  then case when c2.account_type = 1
							then convert(decimal(18,2), b2.total/b2.amount)*a2.amount
						    else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
					    end 
				  else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
			  end as total
			,case when a2.warehouse_type_id = dbo.usfConst('WRH_REMAGGREGATES')
				  then 'Наличный р.'
				  else 'Безналичный р.'
			  end as account_kind
 from 
dbo.utfVREP_WRH_DEMAND() as a2
left outer join dbo.cwrh_wrh_income_detail as b2
		on a2.wrh_income_detail_id = b2.id
	left outer join dbo.cwrh_wrh_income_master as c2
		on b2.wrh_income_master_id = c2.id
where a2.wrh_order_master_id = a.id
  and a2.is_verified = 'Проверен'
  and (@p_wo_remaggregates = 0 
		or (a2.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			))) as g
where a.order_state = 1
  and a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
  and (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and b.sys_status = 1
  and f.sys_status = 1) 
select
	 a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,a.kol
    ,a.total
	,b.account_kind
	,b.kol_detail
	,b.total_detail
 from
(select
     a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	--,a.account_kind
	,count(*) as kol
    ,sum(total) as total
  from
src as a
group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname) as a
join
   (select
     a.car_kind_id
	,a.car_mark_id
	,a.repair_type_id
	,a.account_kind
	,count(*) as kol_detail
    ,sum(total) as total_detail
  from
	src as a
	group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname
	  ,a.account_kind) as b
	on   a.car_kind_id = b.car_kind_id
	 and a.car_mark_id = b.car_mark_id
	 and a.repair_type_id = b.repair_type_id
order by 
	 a.car_kind_id
	,a.car_mark_id
	,a.kol desc
    ,a.repair_type_id
	,b.account_kind desc
	,b.kol_detail desc

	RETURN
go


GRANT EXECUTE ON [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве ремонтов с затратами по видам и
** маркам автомобилей
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
,@p_wo_remaggregates    bit = 0
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

  with src 
	(car_kind_id
	,car_kind_sname
	,car_mark_id
	,car_mark_sname
	,repair_type_id
	,repair_type_sname
    ,total
	,account_kind)
as
(select b.car_kind_id
	  ,c.short_name as car_kind_sname
	  ,b.car_mark_id
	  ,d.short_name + ' - ' + h.short_name as car_mark_sname
	  ,f.id as repair_type_id
	  ,f.full_name as repair_type_sname
	  ,isnull(g.total, 0) as total
	  ,isnull(g.account_kind, 'Без списания') as account_kind
 from dbo.cwrh_wrh_order_master as a
 join dbo.ccar_car as b
	on a.car_id = b.id
 join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
 join dbo.ccar_car_mark as d
	on b.car_mark_id = d.id
 join dbo.ccar_car_model as h
	on h.id = b.car_model_id
 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
	on a.id = e.wrh_order_master_id
 join dbo.CRPR_REPAIR_TYPE_MASTER as f
	on e.repair_type_master_id = f.id
outer apply
(select 
			 case when a2.wrh_income_detail_id is not null
				  then case when c2.account_type = 1
							then convert(decimal(18,2), b2.total/b2.amount)*a2.amount
						    else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
					    end 
				  else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
			  end as total
			,case when a2.warehouse_type_id = dbo.usfConst('WRH_REMAGGREGATES')
				  then 'Наличный р.'
				  else 'Безналичный р.'
			  end as account_kind
 from 
dbo.utfVREP_WRH_DEMAND() as a2
left outer join dbo.cwrh_wrh_income_detail as b2
		on a2.wrh_income_detail_id = b2.id
	left outer join dbo.cwrh_wrh_income_master as c2
		on b2.wrh_income_master_id = c2.id
where a2.wrh_order_master_id = a.id
  and a2.is_verified = 'Проверен'
  and (@p_wo_remaggregates = 0 
		or (a2.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			))) as g
where a.order_state = 1
  and a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
  and (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and b.sys_status = 1
  and f.sys_status = 1) 
select
	 a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,a.kol
    ,a.total
	,b.account_kind
	,b.kol_detail
	,b.total_detail
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select
     a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	--,a.account_kind
	,count(*) as kol
    ,sum(total) as total
  from
src as a
group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname) as a
join
   (select
     a.car_kind_id
	,a.car_mark_id
	,a.repair_type_id
	,a.account_kind
	,count(*) as kol_detail
    ,sum(total) as total_detail
  from
	src as a
	group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname
	  ,a.account_kind) as b
	on   a.car_kind_id = b.car_kind_id
	 and a.car_mark_id = b.car_mark_id
	 and a.repair_type_id = b.repair_type_id
order by 
	 a.car_kind_id
	,a.car_mark_id
	,a.kol desc
    ,a.repair_type_id
	,b.account_kind desc
	,b.kol_detail desc

	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве ремонтов с затратами по видам и
** маркам автомобилей
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
,@p_wo_remaggregates    bit = 0
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();


with src_detail (total, account_kind, wrh_order_master_id)
as
(select 
			 case when a2.wrh_income_detail_id is not null
				  then case when c2.account_type = 1
							then convert(decimal(18,2), b2.total/b2.amount)*a2.amount
						    else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
					    end 
				  else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
			  end as total
			,case when a2.warehouse_type_id = dbo.usfConst('WRH_REMAGGREGATES')
				  then 'Наличный р.'
				  else 'Безналичный р.'
			  end as account_kind
			,a2.wrh_order_master_id
 from 
dbo.utfVREP_WRH_DEMAND() as a2
left outer join dbo.cwrh_wrh_income_detail as b2
		on a2.wrh_income_detail_id = b2.id
	left outer join dbo.cwrh_wrh_income_master as c2
		on b2.wrh_income_master_id = c2.id
where  a2.is_verified = 'Проверен'
  and (@p_wo_remaggregates = 0 
		or (a2.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			)))
,src 
	(car_kind_id
	,car_kind_sname
	,car_mark_id
	,car_mark_sname
	,repair_type_id
	,repair_type_sname
    ,total
    ,wrh_order_master_id
	--,account_kind
)
as
(select b.car_kind_id
	  ,c.short_name as car_kind_sname
	  ,b.car_mark_id
	  ,d.short_name as car_mark_sname
	  ,f.id as repair_type_id
	  ,f.full_name as repair_type_sname
	  ,isnull(g.total, 0) as total
	  ,a.id as wrh_order_master_id
	 -- ,isnull(g.account_kind, 'Без списания') as account_kind
 from dbo.cwrh_wrh_order_master as a
 join dbo.ccar_car as b
	on a.car_id = b.id
 join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
 join dbo.ccar_car_mark as d
	on b.car_mark_id = d.id
 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
	on a.id = e.wrh_order_master_id
 join dbo.CRPR_REPAIR_TYPE_MASTER as f
	on e.repair_type_master_id = f.id
outer apply
(select 
	 sum(total) as total
	--,account_kind
   from src_detail as a3
where a3.wrh_order_master_id = a.id) as g
where a.order_state = 1
  and a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
  and (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and b.sys_status = 1
  and f.sys_status = 1) 
select
	 a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,a.kol
    ,a.total
	,b.account_kind
	,b.kol_detail
	,b.total_detail
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select
     a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	--,a.account_kind
	,count(*) as kol
    ,sum(total) as total
  from
src as a
group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname) as a
join
   (select
     a.car_kind_id
	,a.car_mark_id
	,a.repair_type_id
	,b.account_kind
	,count(*) as kol_detail
    ,sum(b.total) as total_detail
  from
	src as a
	join src_detail as b
	  on a.wrh_order_master_id = b.wrh_order_master_id
	group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname
	  ,b.account_kind) as b
	on   a.car_kind_id = b.car_kind_id
	 and a.car_mark_id = b.car_mark_id
	 and a.repair_type_id = b.repair_type_id
order by 
	 a.car_kind_id
	,a.car_mark_id
	,a.kol desc
    ,a.repair_type_id
	,b.account_kind desc
	,b.kol_detail desc




	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_REPAIR_TYPE_COUNT_SUM_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве ремонтов с затратами по видам и
** маркам автомобилей
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
,@p_wo_remaggregates    bit = 0
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();


with src_detail (total, account_kind, wrh_order_master_id)
as
(select 
			 case when a2.wrh_income_detail_id is not null
				  then case when c2.account_type = 1
							then convert(decimal(18,2), b2.total/b2.amount)*a2.amount
						    else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
					    end 
				  else convert(decimal(18,2),(a2.amount*a2.price) + (a2.amount*a2.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
			  end as total
			,case when a2.warehouse_type_id = dbo.usfConst('WRH_REMAGGREGATES')
				  then 'Наличный р.'
				  else 'Безналичный р.'
			  end as account_kind
			,a2.wrh_order_master_id
 from 
dbo.utfVREP_WRH_DEMAND() as a2
left outer join dbo.cwrh_wrh_income_detail as b2
		on a2.wrh_income_detail_id = b2.id
	left outer join dbo.cwrh_wrh_income_master as c2
		on b2.wrh_income_master_id = c2.id
where  a2.is_verified = 'Проверен'
  and (@p_wo_remaggregates = 0 
		or (a2.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			)))
,src 
	(car_kind_id
	,car_kind_sname
	,car_mark_id
	,car_mark_sname
	,repair_type_id
	,repair_type_sname
    ,total
    ,wrh_order_master_id
	--,account_kind
)
as
(select b.car_kind_id
	  ,c.short_name as car_kind_sname
	  ,b.car_mark_id
	  ,d.short_name as car_mark_sname
	  ,f.id as repair_type_id
	  ,f.full_name as repair_type_sname
	  ,isnull(g.total, 0) as total
	  ,a.id as wrh_order_master_id
	 -- ,isnull(g.account_kind, 'Без списания') as account_kind
 from dbo.cwrh_wrh_order_master as a
 join dbo.ccar_car as b
	on a.car_id = b.id
 join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
 join dbo.ccar_car_mark as d
	on b.car_mark_id = d.id
 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
	on a.id = e.wrh_order_master_id
 join dbo.CRPR_REPAIR_TYPE_MASTER as f
	on e.repair_type_master_id = f.id
outer apply
(select 
	 sum(total) as total
	--,account_kind
   from src_detail as a3
where a3.wrh_order_master_id = a.id) as g
where a.order_state = 1
  and a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
  and (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and b.sys_status = 1
  and f.sys_status = 1) 
select
	 a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,a.kol
    ,a.total
	,b.account_kind
	,b.kol_detail
	,b.total_detail
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select
     a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	--,a.account_kind
	,count(*) as kol
    ,sum(total) as total
  from
src as a
group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname) as a
join
   (select
     a.car_kind_id
	,a.car_mark_id
	,a.repair_type_id
	,b.account_kind
	,count(*) as kol_detail
    ,sum(b.total) as total_detail
  from
	src as a
	join src_detail as b
	  on a.wrh_order_master_id = b.wrh_order_master_id
	group by 
	   a.car_kind_id
	  ,a.car_kind_sname
	  ,a.car_mark_id
	  ,a.car_mark_sname
	  ,a.repair_type_id
	  ,a.repair_type_sname
	  ,b.account_kind) as b
	on   a.car_kind_id = b.car_kind_id
	 and a.car_mark_id = b.car_mark_id
	 and a.repair_type_id = b.repair_type_id
order by 
	 a.car_kind_id
	,a.car_mark_id
	,a.kol desc
    ,a.repair_type_id
	,b.account_kind desc
	,b.kol_detail desc




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




