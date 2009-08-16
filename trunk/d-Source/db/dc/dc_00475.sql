
:r ./../_define.sql

:setvar dc_number 00475
:setvar dc_description "rem aggregates choice added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   06.07.2009 VLavrentiev   rem aggregates choice added
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

insert into dbo.csys_const(id, name, description)
values('1013', 'WRH_REMAGGREGATES', 'Èä äëÿ ñêëàäà ĞÅÌÀÃĞÅÃÀÒÛ')
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
,@p_organization_id     numeric(38,0) = null
,@p_wo_remaggregates    bit = 0
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
  and a.is_verified = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (c.id = @p_organization_id or @p_organization_id is null)
  and (@p_wo_remaggregates = 0 
		or (a.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			))
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



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
,@p_organization_id     numeric(38,0) = null
,@p_wo_remaggregates    bit = 0
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
  and a.is_verified = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
 and (c.id = @p_organization_id or @p_organization_id is null)
  and (@p_wo_remaggregates = 0 
		or (b.warehouse_type_id != dbo.usfConst('WRH_REMAGGREGATES')
		    and @p_wo_remaggregates = 1
			))
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname

return 
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




