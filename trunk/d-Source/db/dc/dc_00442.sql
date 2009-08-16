
:r ./../_define.sql

:setvar dc_number 00442
:setvar dc_description "car exit rep fix#3"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   06.04.2009 VLavrentiev   car exit rep fix#3
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





ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о выходе автомобилей за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date			datetime
)
AS
SET NOCOUNT ON

 if (@p_date is null)
  set @p_date = getdate();
   
with exit_stmt (date_exit, id, message_code, state_number) as
(select c.date_created as date_exit, id, message_code, state_number
		   from dbo.crep_serial_log as c
		where c.message_code like ('%вышел%')
		  and c.date_created  <= dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date))
		  and c.date_created > dbo.usfUtils_TimeToZero(@p_date))
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_date)))
select
TOP(100) PERCENT 
 convert(varchar(10),a.date_created, 104) + ' ' + convert(varchar(5),a.date_created, 108) as date_created 
,a.state_number
,a.fio
,convert(varchar(10),a.date_planned, 104) + ' ' + convert(varchar(5),a.date_planned, 108) as date_planned 
,convert(varchar(10),a.date_exit, 104) + ' ' + convert(varchar(5),a.date_exit, 108) as date_exit
,isnull(convert(varchar(10),j3.date_return, 104) + ' ' + convert(varchar(5),j3.date_return, 108)
	   ,(select top(1) convert(varchar(10),c.date_created, 104) + ' ' + convert(varchar(5),c.date_created, 108)
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	order by c.date_created desc)) as date_return
,convert(varchar(10),@p_date, 104) + ' ' + convert(varchar(5),@p_date, 108) as date
,case when (a.date_planned is not null
	   and a.date_exit is not null
		--and a.date_planned < a.date_exit
		)
	  then --case when datediff("mi", a.date_planned, a.date_exit) > 480
				--then null
				--else 
				datediff("mi", a.date_planned, a.date_exit)
			--end
	  else null
  end as wait_time
 from
(select 
	 dbo.usfUtils_TimeToZero(b.date_created) as date_created 
	,b.state_number
	,b.fio
	--,j.time
	,isnull((select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
	and time <= j2.date_exit
	 order by time desc)
	,(select top(1)
	 time from dbo.crep_driver_plan_detail as a
		join dbo.ccar_car as c on a.car_id = c.id
	where date = dbo.usfUtils_TimeToZero(b.date_created)
	and c.state_number = b.state_number
     and time > j2.date_exit
	 order by time asc)) as date_planned
	,j2.date_exit
	from dbo.crep_serial_log as b
	outer apply
		(select top(1) date_exit
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc) as j2
	where b.id = (select top(1) id 
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc)) as a
outer apply
	(select top(1) c.date_created as date_return
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	  and c.date_created < (select top(1) date_exit 
							from exit_next_stmt
							where state_number = a.state_number
							order by date_exit asc)
	order by c.date_created desc) as j3
where a.date_planned is not null
order by a.date_created desc
,a.date_planned asc 
,a.state_number asc
,a.date_exit asc


	RETURN


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[utfVPRT_EMPLOYEE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности EMPLOYEE
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      19.02.2008 VLavrentiev	Добавил обработку sex
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_location_type_mobile_phone_id  numeric(38,0)
 ,@p_location_type_home_phone_id    numeric(38,0)
 ,@p_location_type_work_phone_id    numeric(38,0)
 ,@p_table_name 		    int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,organization_id
		  ,person_id
		  ,employee_type_id
		  ,a.driver_license
		  ,sex
          ,FIO
		  ,lastname 
		  ,name
		  ,surname
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
	      ,org_name
		  ,job_title
		  ,short_FIO
	from
	(SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.organization_id
		  ,a.person_id
		  ,a.employee_type_id
		  ,a.driver_license
		  ,case when b.sex = 1 then 'М' 
			    when b.sex = 0 then 'Ж'
           else ''
		   end as sex
          	  ,b.lastname+' '+b.name+' '+isnull(b.surname,'') as FIO
		  ,b.lastname 
		  ,b.name
		  ,b.surname
		  ,b.birthdate
		  ,e1.location_string as mobile_phone
		  ,e2.location_string as home_phone
		  ,e3.location_string as work_phone
	      	  ,c.name as org_name
		  ,d.short_name as job_title
		  ,b.lastname+' '+isnull(substring(b.name,1,2),'') +'. '+ isnull(substring(b.surname,1,2),'')+ '.' as short_FIO
		  ,isnull(a3.is_fired, 'N') as is_fired
      FROM dbo.CPRT_EMPLOYEE as a
      JOIN dbo.CPRT_PERSON as b on a.person_id = b.id
	  JOIN dbo.CPRT_ORGANIZATION as c on a.organization_id = c.id
      JOIN dbo.CPRT_EMPLOYEE_TYPE as d on a.employee_type_id = d.id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
	  outer apply
		(select 'Y' as is_fired
		   from dbo.CPRT_EMPLOYEE_EVENT as a2
		  where event = dbo.usfConst('FIRED')
		    and date_started <= (getdate())
			and (date_ended is null
				or date_ended >= getdate())
		    and a2.employee_id = a.id) as a3) as a
	  Where is_fired = 'N'
	
) 
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


