:r ./../_define.sql

:setvar dc_number 00219
:setvar dc_description "driver plan month index fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    05.05.2008 VLavrentiev  driver plan month index fixed
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
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
)
as
begin
  set nocount on
	declare
	@v_time datetime, @v_month tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  set @v_month = convert(tinyint, @p_month)

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:01:00'))
						 when '02:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:02:00'))
						 when '03:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:03:00'))
						 when '04:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:04:00'))
						 when '05:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:05:00'))
						 when '06:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:06:00'))
						 when '07:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:07:00'))
						 when '08:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:08:00'))
						 when '09:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:09:00'))
						 when '10:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:10:00'))
						 when '11:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:11:00'))
						 when '12:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:12:00'))
						 when '13:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:13:00'))
						 when '14:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:14:00'))
						 when '15:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:15:00'))
						 when '16:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:16:00'))
						 when '17:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:17:00'))
						 when '18:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:18:00'))
						 when '19:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:19:00'))
						 when '20:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:20:00'))
						 when '21:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:21:00'))
						 when '22:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:22:00'))
						 when '23:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:23:00'))
						 when '00:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + '01' + '-' + @p_month + ' 00:00:00'))
						  end

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN
            (car_id, "time", employee1_id, employee2_id, employee3_id ,employee4_id
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @v_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVPRT_Employee_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о сотрудниках
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
  
 
 declare  
 
  @p_location_type_mobile_phone_id numeric(38,0)
 ,@p_location_type_home_phone_id numeric(38,0)
 ,@p_location_type_work_phone_id numeric(38,0)
 ,@p_table_name int
 ,@v_Srch_Str      varchar(1000)

 set @p_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @p_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @p_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')

 set @p_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,organization_id
		  ,person_id
		  ,employee_type_id
		  ,sex
          	  ,FIO
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
	      	  ,org_name
		  ,job_title
		  ,lastname
		  ,name
		  ,surname
	FROM dbo.utfVPRT_EMPLOYEE(@p_location_type_mobile_phone_id
				 ,@p_location_type_home_phone_id
				 ,@p_location_type_work_phone_id
				 ,@p_table_name) as a
	WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CPRT_PERSON, (name, lastname, surname), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.person_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))
	order by job_title asc, org_name asc

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
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
)
as
begin
  set nocount on
	declare
	@v_time datetime, @v_month tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  set @v_month = convert(tinyint, @p_month)

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:01:00'))
						 when '02:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:02:00'))
						 when '03:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:03:00'))
						 when '04:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:04:00'))
						 when '05:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:05:00'))
						 when '06:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:06:00'))
						 when '07:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:07:00'))
						 when '08:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:08:00'))
						 when '09:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:09:00'))
						 when '10:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:10:00'))
						 when '11:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:11:00'))
						 when '12:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:12:00'))
						 when '13:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:13:00'))
						 when '14:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:14:00'))
						 when '15:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:15:00'))
						 when '16:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:16:00'))
						 when '17:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:17:00'))
						 when '18:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:18:00'))
						 when '19:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:19:00'))
						 when '20:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:20:00'))
						 when '21:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:21:00'))
						 when '22:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:22:00'))
						 when '23:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:23:00'))
						 when '00:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:00:00'))
						  end

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN
            (car_id, "time", employee1_id, employee2_id, employee3_id ,employee4_id
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @v_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
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
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
)
as
begin
  set nocount on
	declare
	@v_time datetime, @v_month tinyint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  set @v_month = convert(tinyint, @p_month)

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 01:00:00'))
						 when '02:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 02:00:00'))
						 when '03:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 03:00:00'))
						 when '04:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 04:00:00'))
						 when '05:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 05:00:00'))
						 when '06:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 06:00:00'))
						 when '07:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 07:00:00'))
						 when '08:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 08:00:00'))
						 when '09:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 09:00:00'))
						 when '10:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 10:00:00'))
						 when '11:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 11:00:00'))
						 when '12:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 12:00:00'))
						 when '13:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 13:00:00'))
						 when '14:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 14:00:00'))
						 when '15:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 15:00:00'))
						 when '16:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 16:00:00'))
						 when '17:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 17:00:00'))
						 when '18:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 18:00:00'))
						 when '19:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 19:00:00'))
						 when '20:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 20:00:00'))
						 when '21:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 21:00:00'))
						 when '22:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 22:00:00'))
						 when '23:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 23:00:00'))
						 when '00:00'
						 then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) +
													 + '-' + @p_month + '-' + '01' + ' 00:00:00'))
						  end

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN
            (car_id, "time", employee1_id, employee2_id, employee3_id ,employee4_id
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @v_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
GO

create unique index u_month_plan on dbo.CDRV_MONTH_PLAN(month)
on $(fg_idx_name)
go

alter table dbo.CDRV_DRIVER_PLAN
add month_year_index char(7)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Индекс месяца',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'month_year_index'
go


create unique index u_car_id_month_driver_plan on dbo.CDRV_DRIVER_PLAN(car_id, month_year_index)
on $(fg_idx_name)
go



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
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @v_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id, @p_month + '.' + @v_year
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
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


