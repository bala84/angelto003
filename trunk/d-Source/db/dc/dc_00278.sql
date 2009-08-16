:r ./../_define.sql

:setvar dc_number 00278
:setvar dc_description "hour amount select all fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    31.05.2008 VLavrentiev  hour amount select all fix
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

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ����� � c�������� ������� � 
** � ������� �������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
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

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (((@p_report_type != 'HR') and (@p_report_type != 'ALL')) or @p_report_type is null)
  set @p_report_type = 'ALL'
   
    
	SELECT dbo.usfUtils_DayTo01(month_created) as month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then '����'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then '����'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then '�����'
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
	FROM dbo.utfVREP_EMPLOYEE_DAY() as a
	where month_created between  @p_start_date and @p_end_date
	  and (     ((@p_report_type = 'ALL') and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL')
													)))
            or  ((@p_report_type = 'HR') and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  --,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
													)))
		  )
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null)
    group by dbo.usfUtils_DayTo01(month_created)
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then '����'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then '����'
			--	when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
			--		or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
			--	then '�����'
			end
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname 
	order by month_created, organization_sname, employee_type_sname, lastname, name, surname 
			  , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then '����'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then '����'
				--when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
				--	or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				--then '�����'
			    end

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� �� �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
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
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_id			numeric(38,0)
	,@v_value_total			decimal(18,9)
	,@v_value_day			decimal(18,9)
	,@v_value_night			decimal(18,9)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_TOTAL')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)


select @v_hour_0 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 0 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 1 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 2 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 3 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 4 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case 
	   when ((datepart("Hh", fact_end_duty) < 5 ) and (datepart("Hh", fact_end_duty) >= 0)) 
	   then 0 
		else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '00:00:00', '06:00:00')
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 6 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 7 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 8 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 9 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 10 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 11
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 12 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 13 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 14 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 15 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 16
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 17 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 18 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 19 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 20
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case 
	   when ((datepart("Hh", fact_end_duty) < 21) and (datepart("Hh", fact_end_duty) >= 6)) 
	   then 0 
	   else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '06:00:00', '22:00:00')
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", fact_end_duty)
	   when 22 
	   then dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case 
	   when ((datepart("Hh", fact_end_duty) < 23) and (datepart("Hh", fact_end_duty) >= 22) )
	   then 0 
	   else dbo.usfREP_EMPLOYEE_Day_Count(fact_start_duty, fact_end_duty, '22:00:00', '23:59:59')
	   end)
 from dbo.CDRV_DRIVER_LIST
 where employee1_id = @p_employee_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_SaveById
			 @p_day_created			= @v_day_created	  
			,@p_value_id			= @v_value_id
			,@p_employee_id			= @p_employee_id
			,@p_person_id			= @p_person_id
			,@p_lastname			= @p_lastname
			,@p_name				= @p_name
			,@p_surname				= @p_surname
			,@p_organization_id		= @p_organization_id
			,@p_organization_sname	= @p_organization_sname
			,@p_employee_type_id	= @p_employee_type_id
			,@p_employee_type_sname	= @p_employee_type_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_month_created = @v_month_created
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

   select @v_value_total = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
		 ,@v_value_day = sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21)
		 ,@v_value_night = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5)+ sum(hour_22)
					 + sum(hour_23) 
    from dbo.CREP_EMPLOYEE_HOUR
  where employee_id = @p_employee_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end
--������� ��� ������ ����� ��� ������ ������

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_TOTAL')
--����� ���-�� ����� �� ������ ���� ������ 12
--������ ����� ������ ���� �� ������ 6
if (@v_value_night > 6)
 set @v_value_night = 6

if (@v_value_total > 12)
 set @v_value_total = 12
--���� ����� ������ 12 - ������ ������� �������� ������ �����, ������ ��� ������ �������� ��� �� ����� ���� ������ 6
if (@v_value_day + @v_value_night) > 12
 set @v_value_day = 6

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_DAY')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_day
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_night
		  		,@p_month_created 		= @v_day_created
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end



	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
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


