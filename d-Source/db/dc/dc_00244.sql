:r ./../_define.sql

:setvar dc_number 00244
:setvar dc_description "employee day reports added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    14.05.2008 VLavrentiev  employee day reports added
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

ALTER procedure [dbo].[uspVREP_EMPLOYEE_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о месяце по рабочему времени
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_value_id			numeric(38,0)
	,@p_month_created		datetime
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id		numeric(38,0)
	,@p_employee_type_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_day_created			datetime
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	declare
	  @v_day_1		decimal(18,9)
	, @v_day_2		decimal(18,9)
	, @v_day_3		decimal(18,9)
	, @v_day_4		decimal(18,9)
	, @v_day_5		decimal(18,9)
	, @v_day_6		decimal(18,9)
	, @v_day_7		decimal(18,9)
	, @v_day_8		decimal(18,9)
	, @v_day_9		decimal(18,9)
	, @v_day_10		decimal(18,9)
	, @v_day_11		decimal(18,9)
	, @v_day_12		decimal(18,9)
	, @v_day_13		decimal(18,9)
	, @v_day_14		decimal(18,9)
	, @v_day_15		decimal(18,9)
	, @v_day_16		decimal(18,9)
	, @v_day_17		decimal(18,9)
	, @v_day_18		decimal(18,9)
	, @v_day_19		decimal(18,9)
	, @v_day_20		decimal(18,9)
	, @v_day_21		decimal(18,9)
	, @v_day_22		decimal(18,9)
	, @v_day_23		decimal(18,9)
	, @v_day_24		decimal(18,9)
	, @v_day_25		decimal(18,9)
	, @v_day_26		decimal(18,9)
	, @v_day_27		decimal(18,9)
	, @v_day_28		decimal(18,9)
	, @v_day_29		decimal(18,9)
	, @v_day_30		decimal(18,9)
	, @v_day_31		decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_MonthTo01(getdate())
	 --else
	 -- set @p_month_created = dbo.usfUtils_TimeToZero(@p_day_created)
 
	 if (datepart("Day", @p_day_created) = 1)
		set @v_day_1 = @p_value
	 else
		set @v_day_1 = 0
	 if (datepart("Day", @p_day_created) = 2)
		set @v_day_2 = @p_value
	 else
		set @v_day_2 = 0
	 if (datepart("Day", @p_day_created) = 3)
		set @v_day_3 = @p_value
	 else
		set @v_day_3 = 0
	 if (datepart("Day", @p_day_created) = 4)
		set @v_day_4 = @p_value
	 else
		set @v_day_4 = 0
	 if (datepart("Day", @p_day_created) = 5)
		set @v_day_5 = @p_value
	 else
		set @v_day_5 = 0
	 if (datepart("Day", @p_day_created) = 6)
		set @v_day_6 = @p_value
	 else
		set @v_day_6 = 0
	 if (datepart("Day", @p_day_created) = 7)
		set @v_day_7 = @p_value
	 else
		set @v_day_7 = 0
	 if (datepart("Day", @p_day_created) = 8)
		set @v_day_8 = @p_value
	 else
		set @v_day_8 = 0
	 if (datepart("Day", @p_day_created) = 9)
		set @v_day_9 = @p_value
	 else
		set @v_day_9 = 0
	 if (datepart("Day", @p_day_created) = 10)
		set @v_day_10 = @p_value
	 else
		set @v_day_10 = 0
	 if (datepart("Day", @p_day_created) = 11)
		set @v_day_11 = @p_value
	 else
		set @v_day_11 = 0
	 if (datepart("Day", @p_day_created) = 12)
		set @v_day_12 = @p_value
	 else
		set @v_day_12 = 0
	 if (datepart("Day", @p_day_created) = 13)
		set @v_day_13 = @p_value
	 else
		set @v_day_13 = 0
	 if (datepart("Day", @p_day_created) = 14)
		set @v_day_14 = @p_value
	 else
		set @v_day_14 = 0
	 if (datepart("Day", @p_day_created) = 15)
		set @v_day_15 = @p_value
	 else
		set @v_day_15 = 0
	 if (datepart("Day", @p_day_created) = 16)
		set @v_day_16 = @p_value
	 else
		set @v_day_16 = 0
	 if (datepart("Day", @p_day_created) = 17)
		set @v_day_17 = @p_value
	 else
		set @v_day_17 = 0
	 if (datepart("Day", @p_day_created) = 18)
		set @v_day_18 = @p_value
	 else
		set @v_day_18 = 0
	 if (datepart("Day", @p_day_created) = 19)
		set @v_day_19 = @p_value
	 else
		set @v_day_19 = 0
	 if (datepart("Day", @p_day_created) = 20)
		set @v_day_20 = @p_value
	 else
		set @v_day_20 = 0
	 if (datepart("Day", @p_day_created) = 21)
		set @v_day_21 = @p_value
	 else
		set @v_day_21 = 0
	 if (datepart("Day", @p_day_created) = 22)
		set @v_day_22 = @p_value
	 else
		set @v_day_22 = 0
	 if (datepart("Day", @p_day_created) = 23)
		set @v_day_23 = @p_value
	 else
		set @v_day_23 = 0
	 if (datepart("Day", @p_day_created) = 24)
		set @v_day_24 = @p_value
	 else
		set @v_day_24 = 0
	 if (datepart("Day", @p_day_created) = 25)
		set @v_day_25 = @p_value
	 else
		set @v_day_25 = 0
	 if (datepart("Day", @p_day_created) = 26)
		set @v_day_26 = @p_value
	 else
		set @v_day_26 = 0
	 if (datepart("Day", @p_day_created) = 27)
		set @v_day_27 = @p_value
	 else
		set @v_day_27 = 0
	 if (datepart("Day", @p_day_created) = 28)
		set @v_day_28 = @p_value
	 else
		set @v_day_28 = 0
	 if (datepart("Day", @p_day_created) = 29)
		set @v_day_29 = @p_value
	 else
		set @v_day_29 = 0
	 if (datepart("Day", @p_day_created) = 30)
		set @v_day_30 = @p_value
	 else
		set @v_day_30 = 0
	 if (datepart("Day", @p_day_created) = 31)
		set @v_day_31 = @p_value
	 else
		set @v_day_31 = 0

insert into dbo.CREP_EMPLOYEE_DAY
	  (		month_created, value_id, employee_id, person_id
			,lastname, name, surname	
			,organization_id, organization_sname, employee_type_id
			,employee_type_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, sys_comment, sys_user_created, sys_user_modified)
select		@p_month_created, @p_value_id, @p_employee_id, @p_person_id
			,@p_lastname, @p_name, @p_surname	
			,@p_organization_id, @p_organization_sname, @p_employee_type_id
			,@p_employee_type_sname, @v_day_1, @v_day_2, @v_day_3, @v_day_4
			,@v_day_5, @v_day_6, @v_day_7, @v_day_8, @v_day_9, @v_day_10
			,@v_day_11, @v_day_12, @v_day_13, @v_day_14, @v_day_15, @v_day_16
			,@v_day_17, @v_day_18, @v_day_19, @v_day_20, @v_day_21, @v_day_22
			,@v_day_23, @v_day_24, @v_day_25, @v_day_26, @v_day_27, @v_day_28
			,@v_day_29, @v_day_30, @v_day_31
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_EMPLOYEE_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.employee_id = @p_employee_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_EMPLOYEE_DAY 
		 set
		    person_id = @p_person_id
		   ,lastname = @p_lastname
		   ,name = @p_name
		   ,surname = @p_surname	
		   ,organization_id = @p_organization_id
		   ,organization_sname = @p_organization_sname
		   ,employee_type_id = @p_employee_type_id
		   ,employee_type_sname = @p_employee_type_sname
		   ,day_1 = @v_day_1
		   ,day_2 = @v_day_2
		   ,day_3 = @v_day_3
		   ,day_4 = @v_day_4
		   ,day_5 = @v_day_5
		   ,day_6 = @v_day_6
		   ,day_7 = @v_day_7
		   ,day_8 = @v_day_8
		   ,day_9 = @v_day_9
		   ,day_10 = @v_day_10
		   ,day_11 = @v_day_11
		   ,day_12 = @v_day_12
		   ,day_13 = @v_day_13
		   ,day_14 = @v_day_14
		   ,day_15 = @v_day_15
		   ,day_16 = @v_day_16
		   ,day_17 = @v_day_17
		   ,day_18 = @v_day_18
		   ,day_19 = @v_day_19
		   ,day_20 = @v_day_20
		   ,day_21 = @v_day_21
		   ,day_22 = @v_day_22
		   ,day_23 = @v_day_23
		   ,day_24 = @v_day_24
		   ,day_25 = @v_day_25
		   ,day_26 = @v_day_26
		   ,day_27 = @v_day_27
		   ,day_28 = @v_day_28
		   ,day_29 = @v_day_29
		   ,day_30 = @v_day_30
		   ,day_31 = @v_day_31
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and employee_id	= @p_employee_id
    
  return 

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVREP_EMPLOYEE_DAY] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по рабочим часам сотрудников
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT month_created
		 , value_id
		 , employee_id
		 , person_id
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , day_1, day_2, day_3, day_4
		 , day_5, day_6, day_7, day_8, day_9, day_10
		 , day_11, day_12, day_13, day_14, day_15, day_16
		 , day_17, day_18, day_19, day_20, day_21, day_22
		 , day_23, day_24, day_25, day_26, day_27, day_28
		 , day_29, day_30, day_31
      FROM dbo.CREP_EMPLOYEE_DAY
	
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVREP_EMPLOYEE_DAY] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[usfUtils_DayToValue](@p_date_with_time datetime, @p_value char(2))
/*
Функция возвращает значение определенного дня
*/
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, @p_date_with_time)) +
      + '-' + convert(nvarchar(2), datepart(mm, @p_date_with_time)) +
      + '-' + @p_value
      + ' ' + '00:00:00')); 
END
GO


GRANT VIEW DEFINITION ON [dbo].[usfUtils_DayToValue] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll]
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
,@p_report_type		 varchar(10)   = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
    
	SELECT month_created
		 , employee_id
		 , person_id
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else day_1
			end as day_1 
		 , case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else day_2
			end as day_2
		 , case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else day_3
			end as day_3
		 , case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else day_4
			end as day_4
, case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else day_5
			end as day_5
, case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else day_6
			end as day_6
, case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else day_7
			end as day_7
, case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else day_8
			end as day_8
, case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else day_9
			end as day_9
, case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else day_10
			end as day_10
, case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else day_11
			end as day_11
, case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else day_12
			end as day_12
, case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else day_13
			end as day_13
, case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else day_14
			end as day_14
, case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else day_15
			end as day_15
, case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else day_16
			end as day_16
, case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else day_17
			end as day_17
, case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else day_18
			end as day_18
, case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else day_19
			end as day_19
, case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else day_20
			end as day_20
, case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else day_21
			end as day_21
, case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else day_22
			end as day_22
, case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else day_23
			end as day_23
, case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else day_24
			end as day_24
, case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else day_25
			end as day_25
, case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else day_26
			end as day_26
, case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else day_27
			end as day_27
, case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else day_28
			end as day_28
, case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else day_29
			end as day_29
, case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else day_30
			end as day_30
, case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else day_31
			end as day_31
	FROM dbo.utfVREP_EMPLOYEE_DAY() as a
	where month_created between  dbo.usfUtils_MonthTo01(@p_start_date) and dbo.usfUtils_MonthTo01(@p_end_date)
	  and (     ((@p_report_type is null) and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL'))))
            or  ((@p_report_type = 'HR') and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL'))))
		  )
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null) 
	order by lastname, name, surname, month_created

	RETURN
GO



GRANT EXECUTE ON [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_EMPLOYEE_HOUR_AMOUNT_SelectAll] TO [$(db_app_user)]
GO





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
,@p_report_type		 varchar(10)   = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
    
	SELECT month_created
		 , employee_id
		 , person_id
		 , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				then 'Общее'
			end as "value"
		 , lastname
		 , name
		 , surname
		 , organization_id
		 , organization_sname
		 , employee_type_id
		 , employee_type_sname
		 , case when dbo.usfUtils_DayToValue(month_created, '01') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '01') > @p_end_date
				then 0
				else convert(decimal(18,0),day_1)
			end as day_1 
		 , case when dbo.usfUtils_DayToValue(month_created, '02') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '02') > @p_end_date
				then 0
				else convert(decimal(18,0),day_2)
			end as day_2
		 , case when dbo.usfUtils_DayToValue(month_created, '03') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '03') > @p_end_date
				then 0
				else convert(decimal(18,0),day_3)
			end as day_3
		 , case when dbo.usfUtils_DayToValue(month_created, '04') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '04') > @p_end_date
				then 0
				else convert(decimal(18,0),day_4)
			end as day_4
, case when dbo.usfUtils_DayToValue(month_created, '05') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '05') > @p_end_date
				then 0
				else convert(decimal(18,0),day_5)
			end as day_5
, case when dbo.usfUtils_DayToValue(month_created, '06') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '06') > @p_end_date
				then 0
				else convert(decimal(18,0),day_6)
			end as day_6
, case when dbo.usfUtils_DayToValue(month_created, '07') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '07') > @p_end_date
				then 0
				else convert(decimal(18,0),day_7)
			end as day_7
, case when dbo.usfUtils_DayToValue(month_created, '08') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '08') > @p_end_date
				then 0
				else convert(decimal(18,0),day_8)
			end as day_8
, case when dbo.usfUtils_DayToValue(month_created, '09') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '09') > @p_end_date
				then 0
				else convert(decimal(18,0),day_9)
			end as day_9
, case when dbo.usfUtils_DayToValue(month_created, '10') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '10') > @p_end_date
				then 0
				else convert(decimal(18,0),day_10)
			end as day_10
, case when dbo.usfUtils_DayToValue(month_created, '11') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '11') > @p_end_date
				then 0
				else convert(decimal(18,0),day_11)
			end as day_11
, case when dbo.usfUtils_DayToValue(month_created, '12') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '12') > @p_end_date
				then 0
				else convert(decimal(18,0),day_12)
			end as day_12
, case when dbo.usfUtils_DayToValue(month_created, '13') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '13') > @p_end_date
				then 0
				else convert(decimal(18,0),day_13)
			end as day_13
, case when dbo.usfUtils_DayToValue(month_created, '14') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '14') > @p_end_date
				then 0
				else convert(decimal(18,0),day_14)
			end as day_14
, case when dbo.usfUtils_DayToValue(month_created, '15') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '15') > @p_end_date
				then 0
				else convert(decimal(18,0),day_15)
			end as day_15
, case when dbo.usfUtils_DayToValue(month_created, '16') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '16') > @p_end_date
				then 0
				else convert(decimal(18,0),day_16)
			end as day_16
, case when dbo.usfUtils_DayToValue(month_created, '17') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '17') > @p_end_date
				then 0
				else convert(decimal(18,0),day_17)
			end as day_17
, case when dbo.usfUtils_DayToValue(month_created, '18') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '18') > @p_end_date
				then 0
				else convert(decimal(18,0),day_18)
			end as day_18
, case when dbo.usfUtils_DayToValue(month_created, '19') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '19') > @p_end_date
				then 0
				else convert(decimal(18,0),day_19)
			end as day_19
, case when dbo.usfUtils_DayToValue(month_created, '20') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '20') > @p_end_date
				then 0
				else convert(decimal(18,0),day_20)
			end as day_20
, case when dbo.usfUtils_DayToValue(month_created, '21') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '21') > @p_end_date
				then 0
				else convert(decimal(18,0),day_21)
			end as day_21
, case when dbo.usfUtils_DayToValue(month_created, '22') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '22') > @p_end_date
				then 0
				else convert(decimal(18,0),day_22)
			end as day_22
, case when dbo.usfUtils_DayToValue(month_created, '23') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '23') > @p_end_date
				then 0
				else convert(decimal(18,0),day_23)
			end as day_23
, case when dbo.usfUtils_DayToValue(month_created, '24') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '24') > @p_end_date
				then 0
				else convert(decimal(18,0),day_24)
			end as day_24
, case when dbo.usfUtils_DayToValue(month_created, '25') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '25') > @p_end_date
				then 0
				else convert(decimal(18,0),day_25)
			end as day_25
, case when dbo.usfUtils_DayToValue(month_created, '26') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '26') > @p_end_date
				then 0
				else convert(decimal(18,0),day_26)
			end as day_26
, case when dbo.usfUtils_DayToValue(month_created, '27') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '27') > @p_end_date
				then 0
				else convert(decimal(18,0),day_27)
			end as day_27
, case when dbo.usfUtils_DayToValue(month_created, '28') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '28') > @p_end_date
				then 0
				else convert(decimal(18,0),day_28)
			end as day_28
, case when dbo.usfUtils_DayToValue(month_created, '29') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '29') > @p_end_date
				then 0
				else convert(decimal(18,0),day_29)
			end as day_29
, case when dbo.usfUtils_DayToValue(month_created, '30') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '30') > @p_end_date
				then 0
				else convert(decimal(18,0),day_30)
			end as day_30
, case when dbo.usfUtils_DayToValue(month_created, '31') < @p_start_date
				then 0
				when dbo.usfUtils_DayToValue(month_created, '31') > @p_end_date
				then 0
				else convert(decimal(18,0),day_31)
			end as day_31
	FROM dbo.utfVREP_EMPLOYEE_DAY() as a
	where month_created between  dbo.usfUtils_DayTo01(@p_start_date) and dbo.usfUtils_DayTo01(@p_end_date)
	  and (     ((@p_report_type is null) and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL'))))
            or  ((@p_report_type = 'HR') and (value_id in ( dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT')
													  ,dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL'))))
		  )
	  and (employee_id = @p_employee_id or @p_employee_id is null)
	  and (employee_type_id = @p_employee_type_id or @p_employee_type_id is null)
	  and (organization_id = @p_organization_id or @p_organization_id is null) 
	order by lastname, name, surname, month_created
			  , case when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_DAY') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_DAY') 
				then 'День'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_NIGHT') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_NIGHT') 
				then 'Ночь'
				when   value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_TOTAL') 
					or value_id = dbo.usfCONST('EMP_WORK_HOUR_AMOUNT_HR_TOTAL') 
				then 'Общее'
			    end

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




