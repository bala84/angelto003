
:r ./../_define.sql

:setvar dc_number 00471
:setvar dc_description "car exit amount added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   07.06.2009 VLavrentiev   car exit amount added
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


ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве выходов и 
** и среднем количестве выходов автомобилей
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      06.06.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_organization_id numeric(38,0) = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
select
	  convert(varchar(10),dbo.usfUtils_DayTo01(a.date_created), 104) + ' ' + convert(varchar(5),dbo.usfUtils_DayTo01(a.date_created), 108) as month_created 
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	, b.state_number
	, b.car_kind_id
	, c.short_name as car_kind_sname
	, b.car_mark_id
	, e.short_name as car_mark_sname
    , b.car_model_id
	, f.short_name as car_model_sname
    , b.organization_id
	, g.name as organization_sname
    , sum(convert(decimal(18,0),day_1)) as day_1
    , sum(convert(decimal(18,0),day_2)) as day_2, sum(convert(decimal(18,0),day_3)) as day_3
    , sum(convert(decimal(18,0),day_4)) as day_4, sum(convert(decimal(18,0),day_5)) as day_5
    , sum(convert(decimal(18,0),day_6)) as day_6, sum(convert(decimal(18,0),day_7)) as day_7
    , sum(convert(decimal(18,0),day_8)) as day_8, sum(convert(decimal(18,0),day_9)) as day_9
    , sum(convert(decimal(18,0),day_10)) as day_10, sum(convert(decimal(18,0),day_11)) as day_11
    , sum(convert(decimal(18,0),day_12)) as day_12, sum(convert(decimal(18,0),day_13)) as day_13
    , sum(convert(decimal(18,0),day_14)) as day_14, sum(convert(decimal(18,0),day_15)) as day_15
    , sum(convert(decimal(18,0),day_16)) as day_16, sum(convert(decimal(18,0),day_17)) as day_17
    , sum(convert(decimal(18,0),day_18)) as day_18, sum(convert(decimal(18,0),day_19)) as day_19
    , sum(convert(decimal(18,0),day_20)) as day_20, sum(convert(decimal(18,0),day_21)) as day_21
    , sum(convert(decimal(18,0),day_22)) as day_22, sum(convert(decimal(18,0),day_23)) as day_23
    , sum(convert(decimal(18,0),day_24)) as day_24, sum(convert(decimal(18,0),day_25)) as day_25
    , sum(convert(decimal(18,0),day_26)) as day_26, sum(convert(decimal(18,0),day_27)) as day_27
    , sum(convert(decimal(18,0),day_28)) as day_28, sum(convert(decimal(18,0),day_29)) as day_29
    , sum(convert(decimal(18,0),day_30)) as day_30, sum(convert(decimal(18,0),day_31)) as day_31
 from
(select 
      a.date_created
	, a.car_id
	, case when (datepart("Day", date_created) = 1)
			then count(id)
			else 0
		end as day_1
	, case when (datepart("Day", date_created) = 2)
			then count(id)
			else 0
		end as day_2
	, case when (datepart("Day", date_created) = 3)
			then count(id)
			else 0
		end as day_3
	, case when (datepart("Day", date_created) = 4)
			then count(id)
			else 0
		end as day_4
	, case when (datepart("Day", date_created) = 5)
			then count(id)
			else 0
		end as day_5
	, case when (datepart("Day", date_created) = 6)
			then count(id)
			else 0
		end as day_6
	, case when (datepart("Day", date_created) = 7)
			then count(id)
			else 0
		end as day_7
	, case when (datepart("Day", date_created) = 8)
			then count(id)
			else 0
		end as day_8
	, case when (datepart("Day", date_created) = 9)
			then count(id)
			else 0
		end as day_9
	, case when (datepart("Day", date_created) = 10)
			then count(id)
			else 0
		end as day_10
	, case when (datepart("Day", date_created) = 11)
			then count(id)
			else 0
		end as day_11
	, case when (datepart("Day", date_created) = 12)
			then count(id)
			else 0
		end as day_12
	, case when (datepart("Day", date_created) = 13)
			then count(id)
			else 0
		end as day_13
	, case when (datepart("Day", date_created) = 14)
			then count(id)
			else 0
		end as day_14
	, case when (datepart("Day", date_created) = 15)
			then count(id)
			else 0
		end as day_15
	, case when (datepart("Day", date_created) = 16)
			then count(id)
			else 0
		end as day_16
	, case when (datepart("Day", date_created) = 17)
			then count(id)
			else 0
		end as day_17
	, case when (datepart("Day", date_created) = 18)
			then count(id)
			else 0
		end as day_18
	, case when (datepart("Day", date_created) = 19)
			then count(id)
			else 0
		end as day_19
	, case when (datepart("Day", date_created) = 20)
			then count(id)
			else 0
		end as day_20
	, case when (datepart("Day", date_created) = 21)
			then count(id)
			else 0
		end as day_21
	, case when (datepart("Day", date_created) = 22)
			then count(id)
			else 0
		end as day_22
	, case when (datepart("Day", date_created) = 23)
			then count(id)
			else 0
		end as day_23
	  ,case when (datepart("Day", date_created) = 24)
			then count(id)
			else 0
		end as day_24
	  ,case when (datepart("Day", date_created) = 25)
			then count(id)
			else 0
		end as day_25
	  ,case when (datepart("Day", date_created) = 26)
			then count(id)
			else 0
		end as day_26
	  ,case when (datepart("Day", date_created) = 27)
			then count(id)
			else 0
		end as day_27
	  ,case when (datepart("Day", date_created) = 28)
			then count(id)
			else 0
		end as day_28
	  ,case when (datepart("Day", date_created) = 29)
			then count(id)
			else 0
		end as day_29
	  ,case when (datepart("Day", date_created) = 30)
			then count(id)
			else 0
		end as day_30
	  ,case when (datepart("Day", date_created) = 31)
			then count(id)
			else 0
		end as day_31
from dbo.cdrv_driver_list as a
where a.driver_list_state_id = dbo.usfConst('LIST_CLOSED')
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("Day", 1, @p_end_date)
group by date_created, car_id) as a
join dbo.ccar_car as b
	on a.car_id = b.id
join dbo.ccar_car_kind as c
	on b.car_kind_id = c.id
join dbo.ccar_car_mark as e
	on b.car_mark_id = e.id
join dbo.ccar_car_model as f
	on b.car_model_id = f.id
join dbo.cprt_organization as g
    on b.organization_id = g.id
where (b.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
  and (b.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
  and (b.organization_id = @p_organization_id or @p_organization_id is null)
group by  convert(varchar(10),dbo.usfUtils_DayTo01(a.date_created), 104) + ' ' + convert(varchar(5),dbo.usfUtils_DayTo01(a.date_created), 108)
	, b.state_number
	, b.car_kind_id
	, c.short_name
	, b.car_mark_id
	, e.short_name
    , b.car_model_id
	, f.short_name
    , b.organization_id
	, g.name
	order by state_number

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
		    ,b.wrh_order_master_id
			,j.number as wrh_order_master_number
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
		left outer join dbo.cwrh_wrh_order_master as j on b.wrh_order_master_id = j.id
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
		    ,c.number as income_master_number
		    ,a.wrh_order_master_number
	FROM dbo.utfVREP_WRH_DEMAND() as a
	left outer join dbo.cwrh_wrh_income_detail as b
		on a.wrh_income_detail_id = b.id
	left outer join dbo.cwrh_wrh_income_master as c
		on b.wrh_income_master_id = c.id
	where a.date_created >= dbo.usfUtils_TimeToZero(@p_start_date) 
	  and a.date_created < dateadd("DD", 1, dbo.usfUtils_TimeToZero(@p_end_date))
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




