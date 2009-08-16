:r ./../_define.sql

:setvar dc_number 00313
:setvar dc_description "car exit report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.06.2008 VLavrentiev  car exit report fixed
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


SELECT GETDATE() as start_time
go

PRINT ' '
select SYSTEM_USER as "user"
go

/*
alter table dbo.CREP_CAR_HOUR 
add min_value decimal(18,9)
go


alter table dbo.CREP_CAR_HOUR 
add max_value decimal(18,9)
go



alter table dbo.CREP_CAR_DAY 
add min_value decimal(18,9)
go


alter table dbo.CREP_CAR_DAY 
add max_value decimal(18,9)
go





alter table dbo.CREP_CAR_MONTH 
add min_value decimal(18,9)
go


alter table dbo.CREP_CAR_MONTH 
add max_value decimal(18,9)
go
*/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set @v_value_id = dbo.usfConst('CAR_EXIT_AMOUNT')
  
select
	  month_created
	 ,organization_sname
	 ,organization_id
	 ,day_created
	 ,value_id
	 ,state_number
	 ,car_id
	 ,car_type_id
	 ,car_type_sname
	 ,car_state_id
	 ,car_state_sname
	 ,car_mark_id
	 ,car_mark_sname
	 ,car_model_id 
	 ,car_model_sname
	 ,begin_mntnc_date
	 ,fuel_type_id
	 ,fuel_type_sname
	 ,car_kind_id
	 ,car_kind_sname
	 ,convert(decimal(18,2),(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else day_1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else day_2
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else day_3
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else day_4
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else day_5
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else day_6
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else day_7
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else day_8
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else day_9
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else day_10
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else day_11
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else day_12
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else day_13
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else day_14
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else day_15
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else day_16
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else day_17
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else day_18
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else day_19
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else day_20
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else day_21
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else day_22
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else day_23
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else day_24
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else day_25
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else day_26
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else day_27
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else day_28
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else day_29
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else day_30
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else day_31
			end)
	/(case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else 1
			end
		+
      case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else 1
			end)) as average_value
	 ,day_1,day_2,day_3,day_4,day_5,day_6,day_7,day_8,day_9,day_10,day_11,day_12,day_13
	 ,day_14,day_15,day_16,day_17,day_18,day_19,day_20,day_21,day_22,day_23,day_24,day_25,day_26
	 ,day_27,day_28,day_29,day_30,day_31
     from
    (SELECT     
		   dbo.usfUtils_DayTo01(month_created) as month_created
		 , organization_sname
		 , organization_id 
		 , max(month_created) as day_created
		 , value_id
		 , (select top(1) state_number from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as state_number
		 , car_id
		 , (select top(1) car_type_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_type_id
		 , (select top(1) car_type_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_type_sname
		 , (select top(1) car_state_id	from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_state_id
		 , (select top(1) car_state_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_state_sname
		 , (select top(1) car_mark_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_mark_id
		 , (select top(1) car_mark_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_mark_sname
		 , (select top(1) car_model_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as  car_model_id
		 , (select top(1) car_model_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_model_sname
		 , (select top(1) begin_mntnc_date from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as begin_mntnc_date
		 , (select top(1) fuel_type_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as fuel_type_id
		 , (select top(1) fuel_type_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as fuel_type_sname
		 , (select top(1) car_kind_id from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_kind_id
		 , (select top(1) car_kind_sname from dbo.utfVREP_CAR_DAY() where car_id = a.car_id and value_id = a.value_id order by month_created desc) as car_kind_sname
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
	FROM dbo.utfVREP_CAR_DAY() as a
	where month_created between  @p_start_date and @p_end_date
	  and value_id = @v_value_id
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null) 
	  and (organization_id = @p_organization_id or @p_organization_id is null)
	group by 
		   dbo.usfUtils_DayTo01(month_created)
		 , organization_id
		 , organization_sname
		 , value_id
		 , car_id) as a
order by 
	  month_created
	 ,organization_sname
	 ,state_number

	RETURN



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


