:r ./../_define.sql

:setvar dc_number 00350
:setvar dc_description "reports order canceled"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.07.2008 VLavrentiev  reports order canceled
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_CNMPTN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о расходе топлива и 
** и среднем расходе топлива
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
,@p_car_id		numeric(38,0) = null
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

  set @v_value_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
  
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
--order by 
--	  month_created
	-- ,organization_sname
	-- ,state_number

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве проработанных часов и 
** и среднем количестве проработанных часов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id		numeric(38,0) = null
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

  set @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
  
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
		 , sum(convert(decimal(18,0),day_1/60)) as day_1
		 , sum(convert(decimal(18,0),day_2/60)) as day_2, sum(convert(decimal(18,0),day_3/60)) as day_3
		 , sum(convert(decimal(18,0),day_4/60)) as day_4, sum(convert(decimal(18,0),day_5/60)) as day_5
		 , sum(convert(decimal(18,0),day_6/60)) as day_6, sum(convert(decimal(18,0),day_7/60)) as day_7
		 , sum(convert(decimal(18,0),day_8/60)) as day_8, sum(convert(decimal(18,0),day_9/60)) as day_9
		 , sum(convert(decimal(18,0),day_10/60)) as day_10, sum(convert(decimal(18,0),day_11/60)) as day_11
		 , sum(convert(decimal(18,0),day_12/60)) as day_12, sum(convert(decimal(18,0),day_13/60)) as day_13
		 , sum(convert(decimal(18,0),day_14/60)) as day_14, sum(convert(decimal(18,0),day_15/60)) as day_15
		 , sum(convert(decimal(18,0),day_16/60)) as day_16, sum(convert(decimal(18,0),day_17/60)) as day_17
		 , sum(convert(decimal(18,0),day_18/60)) as day_18, sum(convert(decimal(18,0),day_19/60)) as day_19
		 , sum(convert(decimal(18,0),day_20/60)) as day_20, sum(convert(decimal(18,0),day_21/60)) as day_21
		 , sum(convert(decimal(18,0),day_22/60)) as day_22, sum(convert(decimal(18,0),day_23/60)) as day_23
		 , sum(convert(decimal(18,0),day_24/60)) as day_24, sum(convert(decimal(18,0),day_25/60)) as day_25
		 , sum(convert(decimal(18,0),day_26/60)) as day_26, sum(convert(decimal(18,0),day_27/60)) as day_27
		 , sum(convert(decimal(18,0),day_28/60)) as day_28, sum(convert(decimal(18,0),day_29/60)) as day_29
		 , sum(convert(decimal(18,0),day_30/60)) as day_30, sum(convert(decimal(18,0),day_31/60)) as day_31
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
--order by 
--	  month_created
--	 ,organization_sname
--	 ,state_number
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_KM_AMOUNT_SelectAll]
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
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id		numeric(38,0) = null
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

  set @v_value_id = dbo.usfConst('CAR_KM_AMOUNT')
  
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
--order by 
--	  month_created
	-- ,organization_sname
	-- ,state_number

	RETURN
GO

 
update dbo.CSYS_CONST
set id = 1008
where name = 'MECH_WORKER'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_RUN_TIME_AFTER_TO_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о времени наработки на отказ
** после ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_month_created		datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error				int
    	,@v_TrancountOnEntry int
	,@v_value_id			numeric(38,0)
	,@v_month_created		datetime
	,@v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_ts_type_route_master_id		numeric(38,0)
	
  
 set  @v_value_id = dbo.usfConst('CAR_RUN_TIME_AFTER_TO')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_month_created)

 select @v_ts_type_route_master_id = ts_type_route_master_id
	from dbo.CCAR_CAR_MODEL
	where id = (select car_model_id from dbo.CCAR_CAR
				where id = @p_car_id)


select @v_day_1 = sum(case when datepart("Day", a.date_created) = 1
				then j.val
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", a.date_created) = 2
				then j.val
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", a.date_created) = 3
				then j.val
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", a.date_created) = 4
				then j.val
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", a.date_created) = 5
				then j.val
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", a.date_created) = 6
				then j.val
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", a.date_created) = 7
				then j.val
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", a.date_created) = 8
				then j.val
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", a.date_created) = 9
				then j.val
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", a.date_created) = 10
				then j.val
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", a.date_created) = 11
				then j.val
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", a.date_created) = 12
				then j.val
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", a.date_created) = 13
				then j.val
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", a.date_created) = 14
				then j.val
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", a.date_created) = 15
				then j.val
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", a.date_created) = 16
				then j.val
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", a.date_created) = 17
				then j.val
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", a.date_created) = 18
				then j.val
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", a.date_created) = 19
				then j.val
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", a.date_created) = 20
				then j.val
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", a.date_created) = 21
				then j.val
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", a.date_created) = 22
				then j.val
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", a.date_created) = 23
				then j.val
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", a.date_created) = 24
				then j.val
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", a.date_created) = 25
				then j.val
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", a.date_created) = 26
				then j.val
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", a.date_created) = 27
				then j.val
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", a.date_created) = 28
				then j.val
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", a.date_created) = 29
				then j.val
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", a.date_created) = 30
				then j.val
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", a.date_created) = 31
				then j.val
				else 0
		   end)  
   from dbo.CWRH_WRH_ORDER_MASTER as a
    outer apply
			(select sum(datediff("mi", c2.fact_start_duty, c2.fact_end_duty)) as val
			  from dbo.CDRV_DRIVER_LIST as c2
			where c2.car_id = a.car_id
			  and c2.date_created >= 
				(select top(1) c.date_ended
							from dbo.CWRH_WRH_ORDER_MASTER as b
							 join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e
							  on b.id = e.wrh_order_master_id
							 join dbo.CRPR_REPAIR_ZONE_MASTER as c
							  on b.repair_zone_master_id = c.id 
						  where b.car_id = a.car_id
							and b.date_created <= a.date_created
							and b.id != (select top(1) b2.id  from dbo.CWRH_WRH_ORDER_MASTER as b2
										  	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as e2
												on b2.id = e2.wrh_order_master_id
										   where b2.car_id = a.car_id
											 and b2.date_created <= a.date_created
											 and exists
											(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as h
												where h.ts_type_route_master_id = @v_ts_type_route_master_id
												  and h.ts_type_master_id = e2.repair_type_master_id)
										   order by b2.date_created desc)
							and b.order_state = 1
							and exists
								(select 1 from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as h
									where h.ts_type_route_master_id = @v_ts_type_route_master_id
									  and h.ts_type_master_id = e.repair_type_master_id)
							order by b.date_created desc)
		and c2.date_created <= (
								select top(1) h2.date_created from dbo.CWRH_WRH_ORDER_MASTER as h2
										   where h2.car_id = a.car_id
											 and h2.date_created <= a.date_created
										   order by h2.date_created desc)) as j
where a.car_id = @p_car_id
   and date_created > = @v_month_created
   and date_created < dateadd("mm", 1, @v_month_created)

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_SaveById
			 @p_month_created  = @v_month_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_organization_id = @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user



       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

(
  @p_start_date datetime
 ,@p_end_date   datetime
 ,@p_Str	varchar(100) = null
)
AS
BEGIN

	SET NOCOUNT ON

select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,message_code
	from dbo.utfVREP_SERIAL_LOG()
	where date_created between @p_start_date and @p_end_date
	  and (upper(rtrim(ltrim(message_code))) like upper(rtrim(ltrim('%' + @p_Str + '%'))) or @p_Str is null)
	  order by date_created desc
 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspVREP_SERIAL_LOG_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)
)
AS
BEGIN

delete from dbo.CREP_SERIAL_LOG
where id = @p_id
 
END
GO

GRANT EXECUTE ON [dbo].[uspVREP_SERIAL_LOG_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_SERIAL_LOG_DeleteById] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранять отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)	  = null out
 ,@p_date_created	datetime		  = null
 ,@p_device_name	varchar(256)	  = null
 ,@p_message_code   varchar(256)	  = null
 ,@p_card_number	varchar(128)	  = null 
 ,@p_sys_comment	varchar(2000)	  = '-'
 ,@p_sys_user		varchar(30)		  = null
)
AS
BEGIN

declare 
	@v_message_code		varchar(1024)
   ,@v_fio_employee_id	numeric(38,0)
   ,@v_fio_employee		varchar(256)
   ,@v_car_id			numeric(38,0)
   ,@v_state_number		varchar(20)
   ,@v_device_id		numeric(38,0)

if (@p_sys_user is null)
	set @p_sys_user = user_name()

if (@p_sys_comment is null)
	set @p_sys_comment = '-'

if (@p_date_created is null)
	set @p_date_created = getdate()

if (@p_message_code is null)
 begin
	select @v_car_id = id
		  ,@v_state_number = state_number
	  from dbo.CCAR_CAR
	  where card_number = @p_card_number
  
	select TOP(1) 
	  @v_fio_employee_id = employee1_id
      from dbo.CDRV_DRIVER_LIST
	  where car_id = @v_car_id
		order by date_created desc, fact_end_duty desc 

	select 
	  @v_fio_employee = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
      from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b
		on a.person_id = b.id
	  where a.id = @v_fio_employee_id

	select @v_device_id = id from dbo.CDEV_DEVICE
	where short_name = @p_device_name 

	set @v_message_code = isnull(@v_fio_employee, '') + ' ' +
							   case 
							   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE') then 'вышел на линию'
							   when @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE') then 'вернулся с линии'
							   else ''
							   end
										  + ' ' +
						  '№ СТП: ' +  isnull(@v_state_number , '') + '.'
 end
else
    set @v_message_code = @p_message_code

if (@p_id is null)
 begin
	insert into dbo.CREP_SERIAL_LOG(date_created, message_code, sys_comment, sys_user_modified, sys_user_created)
	values(@p_date_created, @v_message_code, @p_sys_comment, @p_sys_user, @p_sys_user)
	
	set @p_id = scope_identity()
 end
else
    update dbo.CREP_SERIAL_LOG
	 set
	    message_code		= @v_message_code
	   ,date_created		= @p_date_created
	   ,sys_comment			= @p_sys_comment
	   ,sys_user_modified	= @p_sys_user	
	where id = @p_id
 
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

(
  @p_start_date datetime
 ,@p_end_date   datetime
 ,@p_Str	varchar(100) = null
)
AS
BEGIN

	SET NOCOUNT ON

select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,message_code
	from dbo.utfVREP_SERIAL_LOG()
	where dbo.usfUtils_TimeToZero(date_created) between @p_start_date and @p_end_date
	  and (upper(rtrim(ltrim(message_code))) like upper(rtrim(ltrim('%' + @p_Str + '%'))) or @p_Str is null)
	  order by date_created desc
 
END
GO



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


