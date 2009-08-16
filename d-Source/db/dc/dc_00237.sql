:r ./../_define.sql

:setvar dc_number 00237
:setvar dc_description "driver plan organization added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.05.2008 VLavrentiev  driver plan organization added
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


alter table dbo.CDRV_DRIVER_PLAN
add organization_id numeric(38,0)
go



declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'organization_id'
go


create index ifk_organization_id_cdrv_driver_plan on CDRV_DRIVER_PLAN(organization_id)
on $(fg_idx_name)
go



alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_ORGANIZATION_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
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
		  ,a.organization_id
		  ,e.name as organization_sname  
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
		left outer join dbo.CPRT_ORGANIZATION as e on e.id = a.organization_id
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
		  ,organization_id
		  ,organization_sname
		FROM dbo.utfVDRV_DRIVER_PLAN(@p_start_date, @p_end_date)

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_Select_DriverById]
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
						 end 
				from dbo.CDRV_MONTH_PLAN where "month" = dbo.usfUtils_DayTo01(@p_date_created)


  
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
		   ,organization_id
		   ,organization_sname
		FROM dbo.utfVDRV_DRIVER_PLAN(dbo.usfUtils_DayTo01(@p_date_created), dbo.usfUtils_DayTo01(@p_date_created) + 1)
		where car_id = @p_car_id
		  and "time" >= dbo.usfUtils_DayTo01(@p_date_created)
		  and "time" <  dbo.usfUtils_DayTo01(@p_date_created) + 1
		

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0) = null out
	,@p_car_id			numeric(38,0)
    ,@p_time			varchar(10)
	,@p_employee1_id	numeric(38,0)
	,@p_employee2_id	numeric(38,0) = null
	,@p_employee3_id	numeric(38,0) = null
	,@p_employee4_id	numeric(38,0) = null
	,@p_month			char(2)
	,@p_organization_id	numeric(38,0) = null
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
)
as
begin
  set nocount on
	declare
	@v_time datetime, @v_month tinyint, @v_year char(4)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  set @v_month = convert(tinyint, @p_month)

  set @v_year = convert(nvarchar(4), datepart(yyyy, getdate()))

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT @v_year +
													 + '-' + @p_month + '-' + '01' + ' 01:00:00'))
						 when '02:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 02:00:00'))
						 when '03:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 03:00:00'))
						 when '04:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 04:00:00'))
						 when '05:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 05:00:00'))
						 when '06:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 06:00:00'))
						 when '07:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 07:00:00'))
						 when '08:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 08:00:00'))
						 when '09:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 09:00:00'))
						 when '10:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 10:00:00'))
						 when '11:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 11:00:00'))
						 when '12:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 12:00:00'))
						 when '13:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 13:00:00'))
						 when '14:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 14:00:00'))
						 when '15:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 15:00:00'))
						 when '16:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 16:00:00'))
						 when '17:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 17:00:00'))
						 when '18:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 18:00:00'))
						 when '19:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 19:00:00'))
						 when '20:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 20:00:00'))
						 when '21:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 21:00:00'))
						 when '22:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 22:00:00'))
						 when '23:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 23:00:00'))
						 when '00:00'
						 then convert(datetime, (SELECT @v_year+
													 + '-' + @p_month + '-' + '01' + ' 00:00:00'))
						  end

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN
            (car_id, "time", employee1_id, employee2_id, employee3_id ,employee4_id, month_year_index
			,organization_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @v_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id, @p_month + '.' + @v_year
		    ,@p_organization_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_PLAN set
		  car_id = @p_car_id
		, "time" = @v_time
		, employee1_id = @p_employee1_id
		, employee2_id = @p_employee2_id
		, employee3_id = @p_employee3_id
		, employee4_id = @p_employee4_id
		, month_year_index = @p_month + '.' + @v_year
		, organization_id = @p_organization_id
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
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




