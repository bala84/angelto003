:r ./../_define.sql

:setvar dc_number 00220
:setvar dc_description "driver list plan added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    05.05.2008 VLavrentiev  driver list plan added
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

PRINT ' '
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVDRV_DRIVER_PLAN] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CDRV_DRIVER_PLAN
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.car_id
		  ,b.state_number
		  ,a.time
		  ,a.employee1_id
		  ,d1.lastname + ' ' + substring(d1.name,1,1) + '.' + isnull(substring(d1.surname,1,1) + '.','') as fio_driver1
		  ,a.employee2_id
		  ,d2.lastname + ' ' + substring(d2.name,1,1) + '.' + isnull(substring(d2.surname,1,1) + '.','') as fio_driver2
		  ,a.employee3_id
		  ,d3.lastname + ' ' + substring(d3.name,1,1) + '.' + isnull(substring(d3.surname,1,1) + '.','') as fio_driver3
		  ,a.employee4_id
		  ,d4.lastname + ' ' + substring(d4.name,1,1) + '.' + isnull(substring(d4.surname,1,1) + '.','') as fio_driver4
      FROM dbo.CDRV_DRIVER_PLAN as a
		join dbo.CCAR_CAR as b on a.car_id = b.id
		join dbo.CPRT_EMPLOYEE as c1 on a.employee1_id = c1.id
		join dbo.CPRT_PERSON as d1 on c1.person_id = d1.id
		left outer join dbo.CPRT_EMPLOYEE as c2 on a.employee2_id = c2.id
		left outer join dbo.CPRT_PERSON as d2 on c2.person_id = d2.id
		left outer join dbo.CPRT_EMPLOYEE as c3 on a.employee3_id = c3.id
		left outer join dbo.CPRT_PERSON as d3 on c3.person_id = d3.id
		left outer join dbo.CPRT_EMPLOYEE as c4 on a.employee4_id = c4.id
		left outer join dbo.CPRT_PERSON as d4 on c4.person_id = d4.id
		where "time" between @p_start_date and @p_end_date 

)
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о плане выхода на линию по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date datetime
)
AS
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
		  ,case when datepart("hh",time) = 1
				then '01:00'
				when datepart("hh",time) = 2
				then '02:00'
				when datepart("hh",time) = 3
				then '03:00'
				when datepart("hh",time) = 4
				then '04:00'
				when datepart("hh",time) = 5
				then '05:00'
				when datepart("hh",time) = 6
				then '06:00'
				when datepart("hh",time) = 7
				then '07:00'
				when datepart("hh",time) = 8
				then '08:00'
				when datepart("hh",time) = 9
				then '09:00'
				when datepart("hh",time) = 10
				then '10:00'
				when datepart("hh",time) = 11
				then '11:00'
				when datepart("hh",time) = 12
				then '12:00'
				when datepart("hh",time) = 13
				then '13:00'
				when datepart("hh",time) = 14
				then '14:00'
				when datepart("hh",time) = 15
				then '15:00'
				when datepart("hh",time) = 16
				then '16:00'
				when datepart("hh",time) = 17
				then '17:00'
				when datepart("hh",time) = 18
				then '18:00'
				when datepart("hh",time) = 19				
				then '19:00'
				when datepart("hh",time) = 20				
				then '20:00'
				when datepart("hh",time) = 21				
				then '21:00'
				when datepart("hh",time) = 22				
				then '22:00'
				when datepart("hh",time) = 23				
				then '23:00'
				when datepart("hh",time) = 0				
				then '00:00'
			end as "time"
		  ,case when month(time) = 1
				then '01'
				when month(time) = 2
				then '02'
				when month(time) = 3
				then '03'
				when month(time) = 4
				then '04'
				when month(time) = 5
				then '05'
				when month(time) = 6
				then '06'
				when month(time) = 7
				then '07'
				when month(time) = 8
				then '08'
				when month(time) = 9
				then '09'
				when month(time) = 10
				then '10'
				when month(time) = 11
				then '11'
				when month(time) = 12
				then '12'
		   end as "month"
		  ,employee1_id
		  ,fio_driver1
		  ,employee2_id
		  ,fio_driver2
		  ,employee3_id
		  ,fio_driver3
		  ,employee4_id
		  ,fio_driver4
		FROM dbo.utfVDRV_DRIVER_PLAN(@p_start_date, @p_end_date)

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_Select_DriverById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о плане выхода на линию по машине на день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      05.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date_created datetime
,@p_car_id		 numeric(38,0)
)
AS
SET NOCOUNT ON

	declare
	@v_day tinyint, @v_plan_choice tinyint

  set @v_day = datepart(dd, @p_date_created)

  select @v_plan_choice = case when @v_day = 1
							 then day_1
							 when @v_day = 2
							 then day_2
							 when @v_day = 3
							 then day_3
							 when @v_day = 4
							 then day_4
							 when @v_day = 5
							 then day_5
							 when @v_day = 6
							 then day_6
							 when @v_day = 7
							 then day_7
							 when @v_day = 8
							 then day_8
							 when @v_day = 9
							 then day_9
							 when @v_day = 10
							 then day_10
							 when @v_day = 11
							 then day_11
							 when @v_day = 12
							 then day_12
							 when @v_day = 13
							 then day_13
							 when @v_day = 14
							 then day_14
							 when @v_day = 15
							 then day_15
							 when @v_day = 16
							 then day_16
							 when @v_day = 17
							 then day_17
							 when @v_day = 18
							 then day_18
							 when @v_day = 19
							 then day_19
							 when @v_day = 20
							 then day_20
							 when @v_day = 21
							 then day_21
							 when @v_day = 22
							 then day_22
							 when @v_day = 23
							 then day_23
							 when @v_day = 24
							 then day_24
							 when @v_day = 25
							 then day_25
							 when @v_day = 26
							 then day_26
							 when @v_day = 27
							 then day_27
							 when @v_day = 28
							 then day_28
							 when @v_day = 29
							 then day_29
							 when @v_day = 30
							 then day_30
							 when @v_day = 31
							 then day_31
						 end from dbo.CDRV_MONTH_PLAN where "month" = dbo.usfUtils_DayTo01(@p_date_created)


  
       SELECT  
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,case (@v_plan_choice)
						 when 1
						 then employee1_id
						 when 2
						 then employee2_id
						 when 3
						 then employee3_id
						 when 4
						 then employee4_id
					 end as employee_id
		  ,case (@v_plan_choice)
						 when 1
						 then fio_driver1
						 when 2
						 then fio_driver2
						 when 3
						 then fio_driver3
						 when 4
						 then fio_driver4
					 end as fio_driver
		FROM dbo.utfVDRV_DRIVER_PLAN(dbo.usfUtils_DayTo01(@p_date_created), dbo.usfUtils_DayTo01(@p_date_created) + 1)
		where car_id = @p_car_id
		  and "time" >= dbo.usfUtils_DayTo01(@p_date_created)
		  and "time" <  dbo.usfUtils_DayTo01(@p_date_created) + 1
		

	RETURN
GO



GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_Select_DriverById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_Select_DriverById] TO [$(db_app_user)]
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


