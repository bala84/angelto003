:r ./../_define.sql

:setvar dc_number 00435
:setvar dc_description "rep driver plan fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   29.03.2009 VLavrentiev   rep driver plan fixed
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна заполнить план на основе предыдущего дня
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      31.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date			 datetime
	,@p_organization_id	 numeric(38,0) 
	,@p_car_kind_id		numeric(38,0)
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)
															


	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   select car_id, dateadd("Day", 1, @p_date), "time", employee_id, shift_number, comments ,mech_employee_id, 0
			,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, @p_sys_user, @p_sys_user
	     from dbo.CDRV_DRIVER_PLAN_DETAIL
	   where date = @p_date
		 and organization_id = @p_organization_id
		 and car_kind_id = @p_car_kind_id


end

go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go











ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о детальном плане выхода на линию по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


/*if (not exists (select 1 from dbo.cdrv_driver_plan_detail as a
				 where date = @p_date 
				   and exists
						(select 1 from dbo.ccar_car as b
							where a.car_id = b.id
							  and b.car_kind_id = @p_car_kind_id
							  and b.organization_id = @p_organization_id)))
select null as id
	 , null as sys_status
	 , null as sys_comment
	 , null as sys_date_modified
	 , null as sys_date_created
	 , null as sys_user_modified
	 , null as sys_user_created
	 , b.car_id
	 , c.state_number
	 , @p_date as date
	 , null as time
	 , b.employee_id 
	 , e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as fio_driver
	 , d.driver_license
	 , null as shift_number
	 , null as comments
	 , null as mech_employee_id
	 , 0 as is_completed
	  ,f.id as organization_id
	  ,f.name as organization_sname
	  ,g.id as car_kind_id
	  ,g.short_name as car_kind_sname
	  ,null as dt_time
	  ,null as is_night_work
 from
(select car_id, case when schema_schedule = 1 then employee1_id
					when schema_schedule = 2 then employee2_id
					when schema_schedule = 3 then employee3_id
					when schema_schedule = 4 then employee4_id
				end as employee_id
from
(select b.car_id, employee1_id, employee2_id, employee3_id, employee4_id
				 ,case  when Day(@p_date) = 1
		         then a.day_1
				 when Day(@p_date) = 2
		         then a.day_2
				 when Day(@p_date) = 3
		         then a.day_3
				 when Day(@p_date) = 4
		         then a.day_4
				 when Day(@p_date) = 5
		         then a.day_5
				 when Day(@p_date) = 6
		         then a.day_6
				 when Day(@p_date) = 7
		         then a.day_7
				 when Day(@p_date) = 8
		         then a.day_9
				 when Day(@p_date) = 10
		         then a.day_10
				 when Day(@p_date) = 11
		         then a.day_11
				 when Day(@p_date) = 12
		         then a.day_12
				 when Day(@p_date) = 13
		         then a.day_13
				 when Day(@p_date) = 14
		         then a.day_14
				 when Day(@p_date) = 15
		         then a.day_15
				 when Day(@p_date) = 16
		         then a.day_16
				 when Day(@p_date) = 17
		         then a.day_17
			     when Day(@p_date) = 18
		         then a.day_18
				 when Day(@p_date) = 19
		         then a.day_19
				 when Day(@p_date) = 20
		         then a.day_20
				 when Day(@p_date) = 21
		         then a.day_21
				 when Day(@p_date) = 22
		         then a.day_22
				 when Day(@p_date) = 23
		         then a.day_23
				 when Day(@p_date) = 24
		         then a.day_24
				 when Day(@p_date) = 25
		         then a.day_25
				 when Day(@p_date) = 26
		         then a.day_26
				 when Day(@p_date) = 27
		         then a.day_27
				 when Day(@p_date) = 28
		         then a.day_28
				 when Day(@p_date) = 29
		         then a.day_29
				 when Day(@p_date) = 30
		         then a.day_30
				 when Day(@p_date) = 31
		         then a.day_31
			 end as schema_schedule
from dbo.cdrv_month_plan as a
		join dbo.cdrv_driver_plan as b
		  on  a.month = dbo.usfUtils_TimeToZero(b.time)
where a.month = dbo.usfUtils_DayTo01(@p_date)) as a) as b
join dbo.ccar_car as c
  on b.car_id = c.id
join dbo.cprt_employee as d
  on b.employee_id = d.id
join dbo.cprt_person as e
  on d.person_id = e.id
join dbo.cprt_organization as f
  on f.id = c.organization_id
	join dbo.ccar_car_kind as g
	  on c.car_kind_id = g.id
where c.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and f.sys_status = 1
  and g.sys_status = 1
  and c.car_kind_id = @p_car_kind_id
  and c.organization_id = @p_organization_id

else*/
/*if (exists
		(select 1 
		  where dbo.usfUtils_TimeToZero(getdate()) > @p_date))

select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,case when datepart("Hh", a.time) < 10
			then '0' + convert(varchar(1), datepart("Hh", a.time))
			else convert(varchar(2), datepart("Hh", a.time))
		end + ':' +
			case when datepart("Minute", a.time) < 10
			then '0' + convert(varchar(1), datepart("Minute", a.time))
			else convert(varchar(2), datepart("Minute", a.time))
			end as time
	  ,a.employee_id
	  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as fio_driver
	  ,c.driver_license
	  ,a.shift_number
	  ,a.comments
	  ,a.mech_employee_id
	  ,a.is_completed
	  ,a.id as organization_id
	  ,a.organization_sname
	  ,a.id as car_kind_id
	  ,a.car_kind_sname
	  ,a.time as dt_time
	  ,case when datepart("Hh", a.time )< dbo.usfConst('Начало ночной смены')
		then 0
	    else 1
	    end as is_night_work
	  ,a.rownum
  from dbo.CREP_DRIVER_PLAN_DETAIL as a
	left outer join dbo.ccar_car as b
	  on a.car_id = b.id
	left outer join dbo.cprt_employee as c
	  on a.employee_id = c.id
	left outer join dbo.cprt_person as d
	  on c.person_id = d.id
  where isnull(b.sys_status, 1) = 1
	and isnull(c.sys_status, 1) = 1
    and isnull(d.sys_status, 1) = 1
    and a.date = @p_date
	and a.car_kind_id = @p_car_kind_id
	and a.organization_id = @p_organization_id
   order by a.rownum, a.time

else*/

select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,case when datepart("Hh", a.time) < 10
			then '0' + convert(varchar(1), datepart("Hh", a.time))
			else convert(varchar(2), datepart("Hh", a.time))
		end + ':' +
			case when datepart("Minute", a.time) < 10
			then '0' + convert(varchar(1), datepart("Minute", a.time))
			else convert(varchar(2), datepart("Minute", a.time))
			end as time
	  ,a.employee_id
	  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as fio_driver
	  ,c.driver_license
	  ,a.shift_number
	  ,a.comments
	  ,a.mech_employee_id
	  ,a.is_completed
	  ,a.organization_id
	  ,a.organization_sname
	  ,a.car_kind_id
	  ,a.car_kind_sname
	  ,a.time as dt_time
	  ,case when datepart("Hh", a.time )< dbo.usfConst('Начало ночной смены')
		then 0
	    else 1
	    end as is_night_work
	  ,a.rownum
  from dbo.CDRV_DRIVER_PLAN_DETAIL as a
	left outer join dbo.ccar_car as b
	  on a.car_id = b.id
	left outer join dbo.cprt_employee as c
	  on a.employee_id = c.id
	left outer join dbo.cprt_person as d
	  on c.person_id = d.id
  where isnull(b.sys_status, 1) = 1
	and isnull(c.sys_status, 1) = 1
    and isnull(d.sys_status, 1) = 1
    and a.date = @p_date
	and a.car_kind_id = @p_car_kind_id
	and a.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









alter procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна заполнить план на основе предыдущего дня
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      31.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date			 datetime
	,@p_organization_id	 numeric(38,0) 
	,@p_car_kind_id		numeric(38,0)
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    select  @p_date = dateadd("Day", -1, dbo.usfUtils_TimeToZero(@p_date))
															


	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   select car_id, dateadd("Day", 1, @p_date), "time", employee_id, shift_number, comments ,mech_employee_id, 0
			,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, @p_sys_user, @p_sys_user
	     from dbo.CDRV_DRIVER_PLAN_DETAIL
	   where date = @p_date
		 and organization_id = @p_organization_id
		 and car_kind_id = @p_car_kind_id


end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE procedure [dbo].[uspVDRV_DRIVER_PLAN_CreateBy_currmonth]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна заполнить план на основе предыдущего дня
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      31.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_date	datetime
		 , @v_next_month_year_index varchar(10)
		 , @v_month_year_index varchar(10)

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    select   @v_date = dateadd("Month", 1, dbo.usfUtils_DayTo01(getdate()))
			,@v_month_year_index = case when datepart("Month", getdate()) < 10
											then '0' + convert(varchar(2), datepart("Month", getdate()))
											else convert(varchar(2), datepart("Month", getdate()))
									end
									   + '.' + convert(varchar(4),datepart("Year", getdate()))
			,@v_next_month_year_index = case when datepart("Month", dateadd("Month", 1, dateadd("Month", 1, getdate()))) < 10
											then '0' + convert(varchar(2), datepart("Month", dateadd("Month", 1, getdate())))
											else convert(varchar(2), datepart("Month", dateadd("Month", 1, getdate())))
									end
									   + '.' + convert(varchar(4),datepart("Year", dateadd("Month", 1, getdate())))
															
      if (@@tranCount = 0)
        begin transaction 

	    insert into dbo.cdrv_month_plan(month, month_index, sys_user_modified,  sys_user_created) 
		select @v_date, datepart("Month", @v_date), @p_sys_user, @p_sys_user
		 where not exists
			(select 1 from dbo.cdrv_month_plan
			   where month = @v_date) 


		insert into dbo.cdrv_driver_plan(car_id, "time",employee1_id, employee2_id, employee3_id, employee4_id, month_year_index, sys_user_modified,  sys_user_created)
		select car_id, dateadd("Month", 1, "time"),employee1_id, employee2_id, employee3_id, employee4_id, @v_next_month_year_index, @p_sys_user, @p_sys_user
		  from dbo.cdrv_driver_plan
		 where month_year_index = @v_month_year_index

       
	   if (@@tranCount > @v_TrancountOnEntry)
        commit


end
go


GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_CreateBy_currmonth] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_CreateBy_currmonth] TO [$(db_app_user)]
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

