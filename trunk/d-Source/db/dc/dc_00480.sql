
:r ./../_define.sql

:setvar dc_number 00480
:setvar dc_description "report_type kind fix#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.07.2009 VLavrentiev   report_type kind fix#2
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
,@p_with_gd_id			bit = 0
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

if (@p_with_gd_id is null)
set @p_with_gd_id = 0;


with src 
	(car_kind_id
	,car_kind_sname
	,car_mark_id
	,car_mark_sname
	,repair_type_id
	,repair_type_sname
	,good_category_id
	,good_category_sname
    ,wrh_order_master_id
	,total
	,account_kind
)
as
(select b.car_kind_id
	  ,c.short_name as car_kind_sname
	  ,b.car_mark_id
	  ,d.short_name as car_mark_sname
	  ,h.id as repair_type_id
	  ,h.full_name as repair_type_sname
	  ,case when @p_with_gd_id = 0 then null
			else g.id
		end as good_category_id
	  ,case when @p_with_gd_id = 0 then null
			else g.short_name
		end as good_category_sname
	  ,a.id as wrh_order_master_id
	  ,case when f.wrh_income_detail_id is not null
				  then case when c2.account_type = 1
							then convert(decimal(18,2), b2.total/b2.amount)*f.amount
						    else convert(decimal(18,2),(f.amount*f.price) + (f.amount*f.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
					    end 
				  else convert(decimal(18,2),(f.amount*f.price) + (f.amount*f.price*dbo.usfConstDecimal ('ACCOUNT_TAX'))) 
			  end as total
	   ,case when f.warehouse_type_id = dbo.usfConst('WRH_REMAGGREGATES')
				  then 'Наличный р.'
				  else 'Безналичный р.'
			  end as account_kind
 from dbo.cwrh_wrh_order_master as a
 join dbo.ccar_car as b
	on a.car_id = b.id
 join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
 join dbo.ccar_car_mark as d
	on b.car_mark_id = d.id
 join dbo.cwrh_wrh_demand_master as e
	on a.id = e.wrh_order_master_id
 join dbo.cwrh_wrh_demand_detail as f
	on e.id = f.wrh_demand_master_id
 join dbo.cwrh_good_category as g
	on f.good_category_id = g.id
 join dbo.cwrh_good_category_type as h
	on g.good_category_type_id = h.id
left outer join dbo.cwrh_wrh_income_detail as b2
		on f.wrh_income_detail_id = b2.id
left outer join dbo.cwrh_wrh_income_master as c2
		on b2.wrh_income_master_id = c2.id
where (a.order_state = 1 or a.order_state = 4)
  and a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
  and (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and b.sys_status = 1
  and f.sys_status = 1)
select a.car_kind_id
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,convert(decimal(18,2), a.kol) as kol
    ,convert(decimal(18,2),a.total) as total
	,--c.account_kind
	null as account_gd_kind
	,--convert(decimal(18,2),c.kol_gd_detail)
	null as kol_gd_detail
	,--convert(decimal(18,2),c.total_gd_detail)
    null as total_gd_detail
	,b.good_category_id
	,b.good_category_sname
	,b.account_kind
	,convert(decimal(18,2),b.kol_detail) as kol_detail
	,convert(decimal(18,2),b.total_detail) as total_detail
	,case when @p_with_gd_id = 0 then 0
		  else 1
	   end as with_gd_id
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
	,null as good_category_id
	,null as good_category_sname
	,null as account_kind
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
	,a.car_kind_sname
	,a.car_mark_id
	,a.car_mark_sname
	,a.repair_type_id
	,a.repair_type_sname
	,a.good_category_id
	,a.good_category_sname
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
	  ,a.account_kind
      ,a.good_category_id
	  ,a.good_category_sname) as b
on a.car_kind_id = b.car_kind_id
 and a.car_mark_id = b.car_mark_id
 and a.repair_type_id = b.repair_type_id
/*join
(select
     a.car_kind_id
	,a.car_mark_id
	,a.repair_type_id
	,a.account_kind
	,count(*) as kol_gd_detail
	,sum(total) as total_gd_detail
  from
src as a
group by 
	   a.car_kind_id
	  ,a.car_mark_id
	  ,a.repair_type_id
	  ,a.account_kind) as c
on a.car_kind_id = c.car_kind_id
 and a.car_mark_id = c.car_mark_id
 and a.repair_type_id = c.repair_type_id*/
order by 
	 a.car_kind_id
	,a.car_mark_id
	,a.kol desc
	,a.repair_type_sname 
	,b.good_category_sname
	,b.account_kind desc
	
	--,a.kol_detail desc*/




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











