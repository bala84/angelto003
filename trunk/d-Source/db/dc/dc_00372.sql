:r ./../_define.sql

:setvar dc_number 00372
:setvar dc_description "employee report fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    01.09.2008 VLavrentiev  employee report fix
*******************************************************************************/ 
use [$(db_name)]
GO

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

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о cуммарном пробеге и 
** и среднем пробеге
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		 datetime
,@p_end_date		 datetime
,@p_employee_id		 numeric(38,0) = null
,@p_employee_type_id numeric(38,0) = null
,@p_organization_id  numeric(38,0) = null
,@p_report_type		 varchar(10)   = 'ALL'
)
AS
SET NOCOUNT ON

	declare
		 @v_value_id numeric(38,0)
		,@v_location_type_mobile_phone_id numeric(38,0)
		,@v_location_type_home_phone_id numeric(38,0)
		,@v_location_type_work_phone_id numeric(38,0)
		,@v_table_name int
		,@v_job_title_driver_id			numeric(38,0)	
		,@v_job_title_mto_id			numeric(38,0)
		,@v_job_title_evacuator_id		numeric(38,0)
		,@v_job_title_dutier_id			numeric(38,0)

 set @v_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @v_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @v_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')
 set @v_job_title_driver_id = dbo.usfConst('DRIVER') 
 set @v_job_title_mto_id = dbo.usfConst('MTO') 
 set @v_job_title_evacuator_id = dbo.usfConst('EVACUATOR') 
 set @v_job_title_dutier_id = dbo.usfConst('DUTIER') 

 set @v_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (((@p_report_type != 'HR') and (@p_report_type != 'ALL')) or @p_report_type is null)
  set @p_report_type = 'ALL'
--TODO: обработка неработающих водителей    
select 
	 month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
	,month_sum
	,first_half_month_sum
	,scnd_half_month_sum
from 	
(
select
	 case when month_created = convert(datetime, '01.01.2099') then null
		  else month_created
	  end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,case when day_1 = 0 then null else day_1 end as day_1
	,case when day_2 = 0 then null else day_2 end as day_2
	,case when day_3 = 0 then null else day_3 end as day_3
	,case when day_4 = 0 then null else day_4 end as day_4
	,case when day_5 = 0 then null else day_5 end as day_5
	,case when day_6 = 0 then null else day_6 end as day_6
	,case when day_7 = 0 then null else day_7 end as day_7
	,case when day_8 = 0 then null else day_8 end as day_8
	,case when day_9 = 0 then null else day_9 end as day_9
	,case when day_10 = 0 then null else day_10 end as day_10
	,case when day_11 = 0 then null else day_11 end as day_11
	,case when day_12 = 0 then null else day_12 end as day_12
	,case when day_13 = 0 then null else day_13 end as day_13
	,case when day_14 = 0 then null else day_14 end as day_14
	,case when day_15 = 0 then null else day_15 end as day_15
	,case when day_16 = 0 then null else day_16 end as day_16
	,case when day_17 = 0 then null else day_17 end as day_17
	,case when day_18 = 0 then null else day_18 end as day_18
	,case when day_19 = 0 then null else day_19 end as day_19
	,case when day_20 = 0 then null else day_20 end as day_20
	,case when day_21 = 0 then null else day_21 end as day_21
	,case when day_22 = 0 then null else day_22 end as day_22
	,case when day_23 = 0 then null else day_23 end as day_23
	,case when day_24 = 0 then null else day_24 end as day_24
	,case when day_25 = 0 then null else day_25 end as day_25
	,case when day_26 = 0 then null else day_26 end as day_26
	,case when day_27 = 0 then null else day_27 end as day_27
	,case when day_28 = 0 then null else day_28 end as day_28
	,case when day_29 = 0 then null else day_29 end as day_29
	,case when day_30 = 0 then null else day_30 end as day_30
	,case when day_31 = 0 then null else day_31 end as day_31
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 + day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as month_sum
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 as first_half_month_sum
	, day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as scnd_half_month_sum
from 
(SELECT dbo.usfUtils_DayTo01(month_created) as month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
			end as "value"
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else convert(decimal(18,0),day_1)
			end) as day_1 
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else convert(decimal(18,0),day_2)
			end) as day_2
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else convert(decimal(18,0),day_3)
			end) as day_3
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else convert(decimal(18,0),day_4)
			end) as day_4
, sum(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else convert(decimal(18,0),day_5)
			end) as day_5
, sum(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else convert(decimal(18,0),day_6)
			end) as day_6
, sum(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else convert(decimal(18,0),day_7)
			end) as day_7
, sum(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else convert(decimal(18,0),day_8)
			end) as day_8
, sum(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else convert(decimal(18,0),day_9)
			end) as day_9
, sum(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else convert(decimal(18,0),day_10)
			end) as day_10
, sum(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else convert(decimal(18,0),day_11)
			end) as day_11
, sum(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else convert(decimal(18,0),day_12)
			end) as day_12
, sum(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else convert(decimal(18,0),day_13)
			end) as day_13
, sum(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else convert(decimal(18,0),day_14)
			end) as day_14
, sum(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else convert(decimal(18,0),day_15)
			end) as day_15
, sum(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else convert(decimal(18,0),day_16)
			end) as day_16
, sum(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else convert(decimal(18,0),day_17)
			end) as day_17
, sum(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else convert(decimal(18,0),day_18)
			end) as day_18
, sum(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else convert(decimal(18,0),day_19)
			end) as day_19
, sum(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else convert(decimal(18,0),day_20)
			end) as day_20
, sum(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else convert(decimal(18,0),day_21)
			end) as day_21
, sum(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else convert(decimal(18,0),day_22)
			end) as day_22
, sum(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else convert(decimal(18,0),day_23)
			end) as day_23
, sum(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else convert(decimal(18,0),day_24)
			end) as day_24
, sum(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else convert(decimal(18,0),day_25)
			end) as day_25
, sum(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else convert(decimal(18,0),day_26)
			end) as day_26
, sum(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else convert(decimal(18,0),day_27)
			end) as day_27
, sum(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else convert(decimal(18,0),day_28)
			end) as day_28
, sum(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else convert(decimal(18,0),day_29)
			end) as day_29
, sum(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else convert(decimal(18,0),day_30)
			end) as day_30
, sum(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else convert(decimal(18,0),day_31)
			end) as day_31
	FROM (
select 
month_created
	,employee_id
	,person_id
	,value_id
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
from
dbo.utfVREP_EMPLOYEE_DAY()
where month_created between  @p_start_date and @p_end_date
	  and (     ((@p_report_type = 'ALL') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL')
													) or value_id is null)))
            or  ((@p_report_type = 'HR') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
													)or value_id is null)))
		  )
	  and (employee_type_id = @v_job_title_driver_id
		or employee_type_id = @v_job_title_mto_id
		or employee_type_id = @v_job_title_evacuator_id
		or employee_type_id = @v_job_title_dutier_id)
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
--TODO: считать только по отчетным таблицам
--Выберем тех сотрудников, которые не ездили
union all
select 
	 convert(datetime, '01.01.2099') as month_created
	,b.id as employee_id
	,person_id
	,null as value_id
	,lastname
	,name
	,surname
	,organization_id
	,org_name as organization_sname
	,employee_type_id
	,job_title as employee_type_sname
	,null as day_1
	,null as day_2
	,null as day_3
	,null as day_4
	,null as day_5
	,null as day_6
	,null as day_7
	,null as day_8
	,null as day_9
	,null as day_10
	,null as day_11
	,null as day_12
	,null as day_13
	,null as day_14
	,null as day_15
	,null as day_16
	,null as day_17
	,null as day_18
	,null as day_19
	,null as day_20
	,null as day_21
	,null as day_22
	,null as day_23
	,null as day_24
	,null as day_25
	,null as day_26
	,null as day_27
	,null as day_28
	,null as day_29
	,null as day_30
	,null as day_31
from dbo.utfVPRT_EMPLOYEE(@v_location_type_mobile_phone_id
				 ,@v_location_type_home_phone_id
				 ,@v_location_type_work_phone_id
				 ,@v_table_name) as b
where (employee_type_id = @v_job_title_driver_id
		or employee_type_id = @v_job_title_mto_id
		or employee_type_id = @v_job_title_evacuator_id
		or employee_type_id = @v_job_title_dutier_id)
	  and (id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and not exists
		(select 1 from dbo.utfVREP_EMPLOYEE_DAY() as c
			where c.employee_id = b.id
			 and c.month_created between  @p_start_date and @p_end_date)) as a
    group by dbo.usfUtils_DayTo01(month_created)
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then 'Общее'
			end
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname) as a
) as a
	order by month_created, organization_sname, employee_type_sname, lastname, name, surname 
			  , "value"

	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_MECH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о cуммарном пробеге и 
** и среднем пробеге
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		 datetime
,@p_end_date		 datetime
,@p_employee_id		 numeric(38,0) = null
,@p_employee_type_id numeric(38,0) = null
,@p_organization_id  numeric(38,0) = null
,@p_report_type		 varchar(10)   = 'ALL'
)
AS
SET NOCOUNT ON

	declare
		 @v_value_id numeric(38,0)
		,@v_location_type_mobile_phone_id numeric(38,0)
		,@v_location_type_home_phone_id numeric(38,0)
		,@v_location_type_work_phone_id numeric(38,0)
		,@v_table_name int
		,@v_job_title_mech_id			numeric(38,0)	
		,@v_job_title_mto_id			numeric(38,0)
		,@v_job_title_evacuator_id		numeric(38,0)
		,@v_job_title_dutier_id			numeric(38,0)

 set @v_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @v_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @v_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')
 set @v_job_title_mech_id = dbo.usfConst('MECH_WORKER')  

 set @v_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (((@p_report_type != 'HR') and (@p_report_type != 'ALL')) or @p_report_type is null)
  set @p_report_type = 'ALL'
--TODO: обработка неработающих водителей    
select 
	 month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
	,month_sum
	,first_half_month_sum
	,scnd_half_month_sum
from 	
(
select
	 case when month_created = convert(datetime, '01.01.2099') then null
		  else month_created
	  end as month_created
	,employee_id
	,person_id
	,"value"
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,case when day_1 = 0 then null else day_1 end as day_1
	,case when day_2 = 0 then null else day_2 end as day_2
	,case when day_3 = 0 then null else day_3 end as day_3
	,case when day_4 = 0 then null else day_4 end as day_4
	,case when day_5 = 0 then null else day_5 end as day_5
	,case when day_6 = 0 then null else day_6 end as day_6
	,case when day_7 = 0 then null else day_7 end as day_7
	,case when day_8 = 0 then null else day_8 end as day_8
	,case when day_9 = 0 then null else day_9 end as day_9
	,case when day_10 = 0 then null else day_10 end as day_10
	,case when day_11 = 0 then null else day_11 end as day_11
	,case when day_12 = 0 then null else day_12 end as day_12
	,case when day_13 = 0 then null else day_13 end as day_13
	,case when day_14 = 0 then null else day_14 end as day_14
	,case when day_15 = 0 then null else day_15 end as day_15
	,case when day_16 = 0 then null else day_16 end as day_16
	,case when day_17 = 0 then null else day_17 end as day_17
	,case when day_18 = 0 then null else day_18 end as day_18
	,case when day_19 = 0 then null else day_19 end as day_19
	,case when day_20 = 0 then null else day_20 end as day_20
	,case when day_21 = 0 then null else day_21 end as day_21
	,case when day_22 = 0 then null else day_22 end as day_22
	,case when day_23 = 0 then null else day_23 end as day_23
	,case when day_24 = 0 then null else day_24 end as day_24
	,case when day_25 = 0 then null else day_25 end as day_25
	,case when day_26 = 0 then null else day_26 end as day_26
	,case when day_27 = 0 then null else day_27 end as day_27
	,case when day_28 = 0 then null else day_28 end as day_28
	,case when day_29 = 0 then null else day_29 end as day_29
	,case when day_30 = 0 then null else day_30 end as day_30
	,case when day_31 = 0 then null else day_31 end as day_31
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 + day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as month_sum
	, day_1 + day_2 + day_3 + day_4 + day_5 + day_6 + day_7 + day_8
	+ day_9 + day_10 + day_11 + day_12 + day_13 + day_14 + day_15 as first_half_month_sum
	, day_16
	+ day_17 + day_18 + day_19 + day_20 + day_21 + day_22 + day_23 + day_24
	+ day_25 + day_26 + day_27 + day_28 + day_29 + day_30 + day_31 as scnd_half_month_sum
from 
(SELECT dbo.usfUtils_DayTo01(month_created) as month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
			end as "value"
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else convert(decimal(18,0),day_1)
			end) as day_1 
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else convert(decimal(18,0),day_2)
			end) as day_2
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else convert(decimal(18,0),day_3)
			end) as day_3
		 , sum(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else convert(decimal(18,0),day_4)
			end) as day_4
, sum(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else convert(decimal(18,0),day_5)
			end) as day_5
, sum(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else convert(decimal(18,0),day_6)
			end) as day_6
, sum(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else convert(decimal(18,0),day_7)
			end) as day_7
, sum(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else convert(decimal(18,0),day_8)
			end) as day_8
, sum(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else convert(decimal(18,0),day_9)
			end) as day_9
, sum(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else convert(decimal(18,0),day_10)
			end) as day_10
, sum(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else convert(decimal(18,0),day_11)
			end) as day_11
, sum(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else convert(decimal(18,0),day_12)
			end) as day_12
, sum(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else convert(decimal(18,0),day_13)
			end) as day_13
, sum(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else convert(decimal(18,0),day_14)
			end) as day_14
, sum(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else convert(decimal(18,0),day_15)
			end) as day_15
, sum(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else convert(decimal(18,0),day_16)
			end) as day_16
, sum(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else convert(decimal(18,0),day_17)
			end) as day_17
, sum(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else convert(decimal(18,0),day_18)
			end) as day_18
, sum(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else convert(decimal(18,0),day_19)
			end) as day_19
, sum(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else convert(decimal(18,0),day_20)
			end) as day_20
, sum(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else convert(decimal(18,0),day_21)
			end) as day_21
, sum(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else convert(decimal(18,0),day_22)
			end) as day_22
, sum(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else convert(decimal(18,0),day_23)
			end) as day_23
, sum(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else convert(decimal(18,0),day_24)
			end) as day_24
, sum(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else convert(decimal(18,0),day_25)
			end) as day_25
, sum(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else convert(decimal(18,0),day_26)
			end) as day_26
, sum(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else convert(decimal(18,0),day_27)
			end) as day_27
, sum(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else convert(decimal(18,0),day_28)
			end) as day_28
, sum(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else convert(decimal(18,0),day_29)
			end) as day_29
, sum(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else convert(decimal(18,0),day_30)
			end) as day_30
, sum(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else convert(decimal(18,0),day_31)
			end) as day_31
	FROM (
select 
month_created
	,employee_id
	,person_id
	,value_id
	,lastname
	,name
	,surname
	,organization_id
	,organization_sname
	,employee_type_id
	,employee_type_sname
	,day_1
	,day_2
	,day_3
	,day_4
	,day_5
	,day_6
	,day_7
	,day_8
	,day_9
	,day_10
	,day_11
	,day_12
	,day_13
	,day_14
	,day_15
	,day_16
	,day_17
	,day_18
	,day_19
	,day_20
	,day_21
	,day_22
	,day_23
	,day_24
	,day_25
	,day_26
	,day_27
	,day_28
	,day_29
	,day_30
	,day_31
from
dbo.utfVREP_EMPLOYEE_DAY()
where month_created between  @p_start_date and @p_end_date
	  and (     ((@p_report_type = 'ALL') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL')
													) or value_id is null)))
            or  ((@p_report_type = 'HR') and ((value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
													)or value_id is null)))
		  )
	  and (employee_type_id = @v_job_title_mech_id)
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
--TODO: считать только по отчетным таблицам
--Выберем тех сотрудников, которые не ездили
union all
select 
	 convert(datetime, '01.01.2099') as month_created
	,b.id as employee_id
	,person_id
	,null as value_id
	,lastname
	,name
	,surname
	,organization_id
	,org_name as organization_sname
	,employee_type_id
	,job_title as employee_type_sname
	,null as day_1
	,null as day_2
	,null as day_3
	,null as day_4
	,null as day_5
	,null as day_6
	,null as day_7
	,null as day_8
	,null as day_9
	,null as day_10
	,null as day_11
	,null as day_12
	,null as day_13
	,null as day_14
	,null as day_15
	,null as day_16
	,null as day_17
	,null as day_18
	,null as day_19
	,null as day_20
	,null as day_21
	,null as day_22
	,null as day_23
	,null as day_24
	,null as day_25
	,null as day_26
	,null as day_27
	,null as day_28
	,null as day_29
	,null as day_30
	,null as day_31
from dbo.utfVPRT_EMPLOYEE(@v_location_type_mobile_phone_id
				 ,@v_location_type_home_phone_id
				 ,@v_location_type_work_phone_id
				 ,@v_table_name) as b
where (employee_type_id = @v_job_title_mech_id)
	  and (id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	  and not exists
		(select 1 from dbo.utfVREP_EMPLOYEE_DAY() as c
			where c.employee_id = b.id
			 and c.month_created between  @p_start_date and @p_end_date)) as a
    group by dbo.usfUtils_DayTo01(month_created)
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				else 'Общее'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then 'Общее'
			end
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname) as a
) as a
	order by month_created, organization_sname, employee_type_sname, lastname, name, surname 
			  , "value"

	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_DRIVER_LIST_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о дне по автомобилю
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0)
	,@p_date_created		datetime
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0) = null
	,@p_car_state_sname		varchar(30)	  = null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_driver_list_state_id numeric(38,0)
	,@p_driver_list_state_sname varchar(30)
	,@p_driver_list_type_id numeric(38,0)
	,@p_driver_list_type_sname varchar(30)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_exp			decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname  varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_employee1_id		numeric(38,0)
	,@p_fio_employee1		varchar(256) = 0
	,@p_fuel_gived			decimal(18,9) = 0
	,@p_fuel_return			decimal(18,9) = 0
	,@p_fuel_addtnl_exp		decimal(18,9) = 0
	,@p_run					decimal(18,9) = 0
	,@p_fuel_consumption	decimal(18,9) = 0
	,@p_number				numeric(38,0)
	,@p_last_date_created   datetime	  = null
	,@p_power_trailer_hour	decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

 if (@p_speedometer_start_indctn is null)
  set @p_speedometer_start_indctn = 0
 if (@p_speedometer_end_indctn is null)
  set @p_speedometer_end_indctn = 0
 if (@p_fuel_start_left	is null)
  set @p_fuel_start_left = 0
 if (@p_fuel_end_left is null)
  set @p_fuel_end_left = 0	
 if (@p_fuel_gived is null)
  set @p_fuel_gived = 0
 if (@p_fuel_return is null)
  set @p_fuel_return = 0
 if (@p_fuel_addtnl_exp is null)
  set @p_fuel_addtnl_exp = 0
 if (@p_fuel_consumption is null)
  set @p_fuel_consumption = 0
 if (@p_fuel_exp is null)
  set @p_fuel_exp = 0
 if (@p_power_trailer_hour is null)
  set @p_power_trailer_hour = 0
 if (@p_run is null)
  set @p_run = 0

    insert into dbo.CREP_DRIVER_LIST
            (id, date_created, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, driver_list_state_id, driver_list_state_sname
			,driver_list_type_id, driver_list_type_sname
			,speedometer_start_indctn, speedometer_end_indctn
			,fuel_exp, fuel_start_left, fuel_end_left
			,organization_id, organization_sname
		    ,fact_start_duty, fact_end_duty
			,employee1_id, fio_employee1
			,fuel_gived, fuel_return, fuel_addtnl_exp
			,run, fuel_consumption, number, last_date_created, power_trailer_hour 
			,sys_comment, sys_user_created, sys_user_modified)
	select   @p_id, @p_date_created, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_driver_list_state_id, @p_driver_list_state_sname
			,@p_driver_list_type_id, @p_driver_list_type_sname
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_exp, @p_fuel_start_left, @p_fuel_end_left
			,@p_organization_id, @p_organization_sname
		    ,@p_fact_start_duty, @p_fact_end_duty
			,@p_employee1_id, @p_fio_employee1
			,@p_fuel_gived, @p_fuel_return, @p_fuel_addtnl_exp
			,@p_run, @p_fuel_consumption, @p_number, @p_last_date_created, @p_power_trailer_hour 
			,@p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_DRIVER_LIST as b
		 where b.id = @p_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_DRIVER_LIST
		 set
			date_created = @p_date_created
			,state_number = @p_state_number
			,car_id = @p_car_id
			,car_type_id = @p_car_type_id
			,car_type_sname = @p_car_type_sname
			,car_state_id = @p_car_state_id	
			,car_state_sname = @p_car_state_sname
			,car_mark_id = @p_car_mark_id
			,car_mark_sname = @p_car_mark_sname
			,car_model_id = @p_car_model_id
			,car_model_sname = @p_car_model_sname
			,fuel_type_id = @p_fuel_type_id
			,fuel_type_sname = @p_fuel_type_sname
			,car_kind_id = @p_car_kind_id
			,car_kind_sname = @p_car_kind_sname
			,driver_list_state_id = @p_driver_list_state_id
			,driver_list_state_sname = @p_driver_list_state_sname
			,driver_list_type_id = @p_driver_list_type_id
			,driver_list_type_sname = @p_driver_list_type_sname
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_exp = @p_fuel_exp
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
			,organization_id = @p_organization_id
			,organization_sname = @p_organization_sname
			,fact_start_duty = @p_fact_start_duty
			,fact_end_duty = @p_fact_end_duty
			,employee1_id = @p_employee1_id
			,fuel_gived = @p_fuel_gived
			,fuel_return = @p_fuel_return
			,fuel_addtnl_exp = @p_fuel_addtnl_exp
			,run = @p_run
			,fuel_consumption = @p_fuel_consumption
			,number = @p_number
			,last_date_created = @p_last_date_created
			,power_trailer_hour = @p_power_trailer_hour
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where id	= @p_id


    
  return 

end
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
)
AS
SET NOCOUNT ON

declare
  @v_item_amount_id numeric(38,0)
 ,@v_item_price_id numeric(38,0)
 ,@v_item_income_amount_id numeric(38,0)
 ,@v_item_income_price_id numeric(38,0)
 ,@v_item_outcome_amount_id numeric(38,0)
 ,@v_item_outcome_price_id numeric(38,0)
 ,@v_start_date_to_01 datetime
 ,@v_end_date_to_01 datetime

set @v_item_amount_id = dbo.usfConst('WAREHOUSE_ITEM_AMOUNT')
set @v_item_price_id = dbo.usfConst('WAREHOUSE_ITEM_PRICE')
set @v_item_income_amount_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_AMOUNT')
set @v_item_income_price_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_PRICE')
set @v_item_outcome_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
set @v_item_outcome_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()
   

set @v_start_date_to_01 = dbo.usfUtils_DayTo01(@p_start_date)
set @v_end_date_to_01 = dbo.usfUtils_DayTo01(@p_end_date)



select 
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,a.begin_amount
  ,a.begin_price
  ,convert(decimal(18,4), a.begin_amount*a.begin_price
) as begin_sum
  ,a.income_amount
  ,a.income_price
  ,convert(decimal(18,4), a.income_amount*a.income_price
) as income_sum
  ,a.outcome_amount
  ,a.outcome_price
  ,convert(decimal(18,4), a.outcome_amount*a.outcome_price
) as outcome_sum
  ,a.end_amount
  ,a.end_price
  ,convert(decimal(18,4), a.end_amount*a.end_price
) as end_sum
from
(select   
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,convert(decimal(18,4),sum(a.begin_amount)) as begin_amount
  ,convert(decimal(18,4),max(a.begin_price)) as begin_price
  ,convert(decimal(18,4),sum(a.income_amount)) as income_amount
  ,convert(decimal(18,4),max(a.income_price)) as income_price
  ,convert(decimal(18,4),sum(a.outcome_amount)) as outcome_amount
  ,convert(decimal(18,4),max(a.outcome_price)) as outcome_price
  ,convert(decimal(18,4),sum(a.end_amount)) as end_amount
  ,convert(decimal(18,4),max(a.end_price)) as end_price
  from
(select
   a.warehouse_type_id
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,case when a.value_id = @v_item_amount_id then isnull(b.amount, 0) 
		else 0
	end as begin_amount
  ,case when a.value_id = @v_item_price_id then isnull(b.price, 0) 
		else 0
	end as begin_price
  ,case when a.value_id = @v_item_income_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as income_amount
  ,case when a.value_id = @v_item_income_price_id then isnull(f.avg_price, 0)
		else 0
	end as income_price
  ,case when a.value_id = @v_item_outcome_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as outcome_amount
  ,case when a.value_id = @v_item_outcome_price_id then isnull(f.avg_price, 0)
		else 0
	end as outcome_price
  ,case when a.value_id = @v_item_amount_id then isnull(d.amount, 0) 
		else 0
	end as end_amount
  ,case when a.value_id = @v_item_price_id then isnull(d.price, 0) 
		else 0
	end as end_price
from dbo.CREP_WAREHOUSE_ITEM_DAY as a
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_start_date
				order by c.date_created desc) as b
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_end_date
				order by c.date_created desc) as d
outer apply 
		(select (case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
					  then 0
			    else day_1
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
					  then 0
			    else day_2
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
					  then 0
			    else day_3
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
					  then 0
			    else day_4
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
					  then 0
			    else day_5
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
					  then 0
			    else day_6
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
					  then 0
			    else day_7
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
					  then 0
			    else day_8
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
					  then 0
			    else day_9
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
					  then 0
			    else day_10
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
					  then 0
			    else day_11
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
					  then 0
			    else day_12
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
					  then 0
			    else day_13
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
					  then 0
			    else day_14
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
					  then 0
			    else day_15
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
					  then 0
			    else day_16
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
					  then 0
			    else day_17
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
					  then 0
			    else day_18
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
					  then 0
			    else day_19
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
					  then 0
			    else day_20
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
					  then 0
			    else day_21
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
					  then 0
			    else day_22
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
					  then 0
			    else day_23
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
					  then 0
			    else day_24
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
					  then 0
			    else day_25
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
					  then 0
			    else day_26
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
					  then 0
			    else day_27
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
					  then 0
			    else day_28
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
					  then 0
			    else day_29
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
					  then 0
			    else day_30
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
					  then 0
			    else day_31
				end) as month_sum
			from dbo.CREP_WAREHOUSE_ITEM_DAY as b
			WHERE b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.month_created = a.month_created
			  and b.value_id = a.value_id) as e
outer apply (select avg(c.price) as avg_price
			from CHIS_WAREHOUSE_ITEM as c 
			where c.warehouse_type_id = a.warehouse_type_id
			and c.good_category_id = a.good_category_id
			and c.date_created between @p_start_date and @p_end_date) as f
where a.month_created >= @v_start_date_to_01
  and a.month_created <= @v_end_date_to_01
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)) as a
group by    
   a.month_created
  ,a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.organization_id
  ,a.organization_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname) as a
order by a.month_created
		,a.warehouse_type_sname
	    ,a.organization_sname
		,a.good_mark
		,a.good_category_fname

	RETURN
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectCar]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии легкового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
DECLARE
   @v_car_type_id numeric(38,0)
  ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('CAR')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
    SET NOCOUNT ON
  
       SELECT 
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,ts_type_master_id
		  ,ts_type_name
		  ,car_mark_model_name
		  ,car_mark_id
		  ,car_model_id
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,last_ts_type_master_id
	      ,edit_state
		  ,convert(decimal(18,0), fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,sent_to
		  ,convert(decimal(18,0), last_run, 128) as last_run
		  ,convert(decimal(18,0), overrun, 128) as overrun
		  ,in_tolerance
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */
	
  RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CONDITION_SelectFreight]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии грузового автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null	
)
AS
SET NOCOUNT ON
DECLARE
   @v_car_type_id numeric(38,0)
	   ,@v_Srch_Str      varchar(1000)

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
	set @v_car_type_id = dbo.usfConst('FREIGHT')

if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
	
 
       SELECT 
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,ts_type_master_id
		  ,ts_type_name
		  ,car_mark_model_name
		  ,car_mark_id
		  ,car_model_id
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,convert(decimal(18,0), run, 128) as run
		  ,last_ts_type_master_id
		  ,edit_state
		  ,convert(decimal(18,0), fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0), fuel_end_left, 128) as fuel_end_left
		  ,convert(decimal(18,0), speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0), speedometer_end_indctn, 128) as speedometer_end_indctn
		  ,sent_to
		  ,convert(decimal(18,0), last_run, 128) as last_run
		  ,convert(decimal(18,0), overrun, 128) as overrun
		  ,in_tolerance	
		  ,ts_type_route_detail_id
		  ,last_ts_type_route_detail_id
	FROM dbo.utfVCAR_CONDITION
				(@p_start_date, @p_end_date, @v_car_type_id) as a
    WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.car_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/

	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
)
AS
SET NOCOUNT ON

declare
  @v_item_amount_id numeric(38,0)
 ,@v_item_price_id numeric(38,0)
 ,@v_item_income_amount_id numeric(38,0)
 ,@v_item_income_price_id numeric(38,0)
 ,@v_item_outcome_amount_id numeric(38,0)
 ,@v_item_outcome_price_id numeric(38,0)
 ,@v_start_date_to_01 datetime
 ,@v_end_date_to_01 datetime

set @v_item_amount_id = dbo.usfConst('WAREHOUSE_ITEM_AMOUNT')
set @v_item_price_id = dbo.usfConst('WAREHOUSE_ITEM_PRICE')
set @v_item_income_amount_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_AMOUNT')
set @v_item_income_price_id = dbo.usfConst('WAREHOUSE_ITEM_INCOME_PRICE')
set @v_item_outcome_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
set @v_item_outcome_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()
   

set @v_start_date_to_01 = dbo.usfUtils_DayTo01(@p_start_date)
set @v_end_date_to_01 = dbo.usfUtils_DayTo01(@p_end_date)



select 
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,a.begin_amount
  ,a.begin_price
  ,convert(decimal(18,4), a.begin_amount*a.begin_price
) as begin_sum
  ,a.income_amount
  ,a.income_price
  ,convert(decimal(18,4), a.income_amount*a.income_price
) as income_sum
  ,a.outcome_amount
  ,a.outcome_price
  ,convert(decimal(18,4), a.outcome_amount*a.outcome_price
) as outcome_sum
  ,a.end_amount
  ,a.end_price
  ,convert(decimal(18,4), a.end_amount*a.end_price
) as end_sum
from
(select   
   a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,convert(decimal(18,4),sum(a.begin_amount)) as begin_amount
  ,convert(decimal(18,4),max(a.begin_price)) as begin_price
  ,convert(decimal(18,4),sum(a.income_amount)) as income_amount
  ,convert(decimal(18,4),max(a.income_price)) as income_price
  ,convert(decimal(18,4),sum(a.outcome_amount)) as outcome_amount
  ,convert(decimal(18,4),max(a.outcome_price)) as outcome_price
  ,convert(decimal(18,4),sum(a.end_amount)) as end_amount
  ,convert(decimal(18,4),max(a.end_price)) as end_price
  from
(select
   a.warehouse_type_id
  ,a.warehouse_type_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname
  ,a.month_created
  ,a.organization_id
  ,a.organization_sname
  ,case when a.value_id = @v_item_amount_id then isnull(b.amount, 0) 
		else 0
	end as begin_amount
  ,case when a.value_id = @v_item_price_id then isnull(b.price, 0) 
		else 0
	end as begin_price
  ,case when a.value_id = @v_item_income_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as income_amount
  ,case when a.value_id = @v_item_income_price_id then isnull(f.avg_price, 0)
		else 0
	end as income_price
  ,case when a.value_id = @v_item_outcome_amount_id then isnull(e.month_sum, 0) 
		else 0
	end as outcome_amount
  ,case when a.value_id = @v_item_outcome_price_id then isnull(f.avg_price, 0)
		else 0
	end as outcome_price
  ,case when a.value_id = @v_item_amount_id then isnull(d.amount, 0) 
		else 0
	end as end_amount
  ,case when a.value_id = @v_item_price_id then isnull(d.price, 0) 
		else 0
	end as end_price
from dbo.CREP_WAREHOUSE_ITEM_DAY as a
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_start_date
				order by c.date_created desc) as b
outer apply 
		(select TOP(1) c.amount, c.price
				from CHIS_WAREHOUSE_ITEM as c
				where c.warehouse_type_id = a.warehouse_type_id
				  and c.good_category_id = a.good_category_id
				  and c.date_created <= @p_end_date
				order by c.date_created desc) as d
outer apply 
		(select (case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
					  then 0
			    else day_1
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
					  then 0
			    else day_2
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
					  then 0
			    else day_3
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
					  then 0
			    else day_4
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
					  then 0
			    else day_5
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
					  then 0
			    else day_6
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
					  then 0
			    else day_7
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
					  then 0
			    else day_8
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
					  then 0
			    else day_9
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
					  then 0
			    else day_10
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
					  then 0
			    else day_11
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
					  then 0
			    else day_12
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
					  then 0
			    else day_13
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
					  then 0
			    else day_14
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
					  then 0
			    else day_15
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
					  then 0
			    else day_16
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
					  then 0
			    else day_17
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
					  then 0
			    else day_18
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
					  then 0
			    else day_19
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
					  then 0
			    else day_20
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
					  then 0
			    else day_21
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
					  then 0
			    else day_22
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
					  then 0
			    else day_23
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
					  then 0
			    else day_24
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
					  then 0
			    else day_25
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
					  then 0
			    else day_26
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
					  then 0
			    else day_27
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
					  then 0
			    else day_28
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
					  then 0
			    else day_29
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
					  then 0
			    else day_30
				end)
				+
				(case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date 
					  then 0
					 when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
					  then 0
			    else day_31
				end) as month_sum
			from dbo.CREP_WAREHOUSE_ITEM_DAY as b
			WHERE b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.month_created = a.month_created
			  and b.value_id = a.value_id) as e
outer apply (select isnull(avg(c.price), (select top(1) c2.price 
										   from  CHIS_WAREHOUSE_ITEM as c2 
										where c2.warehouse_type_id = a.warehouse_type_id
										and c2.good_category_id = a.good_category_id
										  order by date_created desc))
										as avg_price
			from CHIS_WAREHOUSE_ITEM as c 
			where c.warehouse_type_id = a.warehouse_type_id
			and c.good_category_id = a.good_category_id
			and c.date_created between @p_start_date and @p_end_date) as f
where a.month_created >= @v_start_date_to_01
  and a.month_created <= @v_end_date_to_01
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)) as a
group by    
   a.month_created
  ,a.warehouse_type_id	
  ,a.warehouse_type_sname
  ,a.organization_id
  ,a.organization_sname
  ,a.good_mark
  ,a.good_category_id
  ,a.good_category_fname) as a
order by a.month_created
		,a.warehouse_type_sname
	    ,a.organization_sname
		,a.good_mark
		,a.good_category_fname

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


