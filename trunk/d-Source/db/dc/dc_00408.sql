:r ./../_define.sql

:setvar dc_number 00408
:setvar dc_description "end year fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   31.12.2008 VLavrentiev  end year fixed
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


ALTER PROCEDURE [dbo].[uspVDRV_MONTH_PLAN_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о плане выхода на линию в месяце
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
)
AS
SET NOCOUNT ON
 declare
	@v_end_year int

 select @v_end_year = datepart("MM",getdate())

 if (@v_end_year = 12)
  begin
    set @p_start_date = dateadd("MM",1,@p_start_date)
    set @p_end_date = dateadd("MM",1,@p_end_date)
  end
  
       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,case when month("month") = 1
				then 'Январь'
				when month("month") = 2
				then 'Февраль'
				when month("month") = 3
				then 'Март'
				when month("month") = 4
				then 'Апрель'
				when month("month") = 5
				then 'Май'
				when month("month") = 6
				then 'Июнь'
				when month("month") = 7
				then 'Июль'
				when month("month") = 8
				then 'Август'
				when month("month") = 9
				then 'Сентябрь'
				when month("month") = 10
				then 'Октябрь'
				when month("month") = 11
				then 'Ноябрь'
				when month("month") = 12
				then 'Декабрь'
		   end as "month"
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
		  ,month_index
		FROM dbo.utfVDRV_MONTH_PLAN(@p_start_date, @p_end_date)

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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

 declare
	 @v_end_year int
	,@v_jan_select int

 select @v_end_year = datepart("MM",getdate())
 select @v_jan_select = datepart("MM",@p_end_date)


 if ((@v_end_year = 12) and (@v_jan_select = 1))
  begin
    set @p_start_date = dateadd("MM",12,@p_start_date)
    set @p_end_date = dateadd("MM",12,@p_end_date)
  end

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

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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

  set @v_year = convert(nvarchar(4), datepart(yyyy, @p_time))

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 01:00:00'))
						 when '02:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 02:00:00'))
						 when '03:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 03:00:00'))
						 when '04:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 04:00:00'))
						 when '05:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 05:00:00'))
						 when '06:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 06:00:00'))
						 when '07:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 07:00:00'))
						 when '08:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 08:00:00'))
						 when '09:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 09:00:00'))
						 when '10:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 10:00:00'))
						 when '11:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 11:00:00'))
						 when '12:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 12:00:00'))
						 when '13:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 13:00:00'))
						 when '14:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 14:00:00'))
						 when '15:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 15:00:00'))
						 when '16:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 16:00:00'))
						 when '17:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 17:00:00'))
						 when '18:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 18:00:00'))
						 when '19:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 19:00:00'))
						 when '20:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 20:00:00'))
						 when '21:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 21:00:00'))
						 when '22:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 22:00:00'))
						 when '23:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 23:00:00'))
						 when '00:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 00:00:00'))
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

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVDRV_MONTH_PLAN_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить план выхода на линию
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) = null out
	,@p_month		varchar(30)
    ,@p_day_1		tinyint		= null
	,@p_day_2		tinyint		= null
	,@p_day_3		tinyint		= null
	,@p_day_4		tinyint		= null
	,@p_day_5		tinyint		= null
	,@p_day_6		tinyint		= null
	,@p_day_7		tinyint		= null
	,@p_day_8		tinyint		= null
	,@p_day_9		tinyint		= null
	,@p_day_10		tinyint		= null
	,@p_day_11		tinyint		= null
	,@p_day_12		tinyint		= null
	,@p_day_13		tinyint		= null
	,@p_day_14		tinyint		= null
	,@p_day_15		tinyint		= null
	,@p_day_16		tinyint		= null
	,@p_day_17		tinyint		= null
	,@p_day_18		tinyint		= null
	,@p_day_19		tinyint		= null
	,@p_day_20		tinyint		= null
	,@p_day_21		tinyint		= null
	,@p_day_22		tinyint		= null
	,@p_day_23		tinyint		= null
	,@p_day_24		tinyint		= null
	,@p_day_25		tinyint		= null		  
	,@p_day_26		tinyint		= null
	,@p_day_27		tinyint		= null
	,@p_day_28		tinyint		= null
	,@p_day_29		tinyint		= null
	,@p_day_30		tinyint		= null
	,@p_day_31		tinyint		= null
	,@p_month_index char(2)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  declare
	  @v_month datetime
	 ,@v_curr_month int
	 ,@v_year int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  select @v_curr_month = datepart("MM",getdate())
  
  if ((@v_curr_month = 12) and (@p_month = 'Январь'))
	set @v_year = datepart(yyyy, dateadd(yyyy, 1, getdate()))
  else
	set @v_year = datepart(yyyy, getdate())


	set @v_month = 
		 case @p_month
		 when 'Январь' then convert(datetime, (SELECT '01' + '.' + '01' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Февраль' then convert(datetime, (SELECT '01' + '.' + '02' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Март' then convert(datetime, (SELECT '01' + '.' + '03' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Апрель' then convert(datetime, (SELECT '01' + '.' + '04' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Май' then convert(datetime, (SELECT '01' + '.' + '05' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Июнь' then convert(datetime, (SELECT '01' + '.' + '06' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Июль' then convert(datetime, (SELECT '01' + '.' + '07' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Август' then convert(datetime, (SELECT '01' + '.' + '08' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Сентябрь' then convert(datetime, (SELECT '01' + '.' + '09' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Октябрь' then convert(datetime, (SELECT '01' + '.' + '10' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Ноябрь' then convert(datetime, (SELECT '01' + '.' + '11' + '.' + convert(nvarchar(4), @v_year)))
		 when 'Декабрь' then convert(datetime, (SELECT '01' + '.' + '12' + '.' + convert(nvarchar(4), @v_year)))
		 end

	

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_MONTH_PLAN
            ("month", day_1, day_2, day_3, day_4 ,day_5 ,day_6 ,day_7 ,day_8
			,day_9 ,day_10 ,day_11 ,day_12 ,day_13 ,day_14 ,day_15 ,day_16
		    ,day_17 ,day_18 ,day_19 ,day_20 ,day_21 ,day_22 ,day_23 ,day_24
		    ,day_25	,day_26 ,day_27 ,day_28 ,day_29 ,day_30 ,day_31, month_index
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@v_month, @p_day_1, @p_day_2, @p_day_3, @p_day_4 ,@p_day_5 ,@p_day_6 ,@p_day_7 ,@p_day_8
			,@p_day_9 , @p_day_10 ,@p_day_11 ,@p_day_12 ,@p_day_13 ,@p_day_14 ,@p_day_15 ,@p_day_16
		    ,@p_day_17, @p_day_18 ,@p_day_19 ,@p_day_20 ,@p_day_21 ,@p_day_22 ,@p_day_23 ,@p_day_24
		    ,@p_day_25, @p_day_26 ,@p_day_27 ,@p_day_28 ,@p_day_29 ,@p_day_30 ,@p_day_31, @p_month_index
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_MONTH_PLAN set
		 "month" = @v_month
		, day_1 = @p_day_1
		, day_2 = @p_day_2
		, day_3 = @p_day_3
		, day_4 = @p_day_4
		, day_5 = @p_day_5 
		, day_6 = @p_day_6 
		, day_7 = @p_day_7 
		, day_8 = @p_day_8
		, day_9 = @p_day_9 
		, day_10 = @p_day_10 
		, day_11 = @p_day_11 
		, day_12 = @p_day_12 
		, day_13 = @p_day_13 
		, day_14 = @p_day_14 
		, day_15 = @p_day_15 
		, day_16 = @p_day_16
		, day_17 = @p_day_17 
		, day_18 = @p_day_18 
		, day_19 = @p_day_19 
		, day_20 = @p_day_20 
		, day_21 = @p_day_21 
		, day_22 = @p_day_22 
		, day_23 = @p_day_23 
		, day_24 = @p_day_24
		, day_25 = @p_day_25	
		, day_26 = @p_day_26 
		, day_27 = @p_day_27 
		, day_28 = @p_day_28 
		, day_29 = @p_day_29
		, day_30 = @p_day_30 
		, day_31 = @p_day_31
		, month_index = @p_month_index
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



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
	@v_time datetime, @v_month tinyint, @v_year char(4), @v_curr_month int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

  set @v_month = convert(tinyint, @p_month)

  select @v_curr_month = datepart("MM",getdate())

  
  if ((@v_curr_month = 12) and (@v_month = 1))
   set @v_year = convert(nvarchar(4), datepart(yyyy, dateadd(yyyy,1,getdate())))
  else
   set @v_year = convert(nvarchar(4), datepart(yyyy, getdate()))

  if (@v_month < 10)
  set @p_month = '0' + @p_month

  set @v_time = case @p_time when '01:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 01:00:00'))
						 when '02:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 02:00:00'))
						 when '03:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 03:00:00'))
						 when '04:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 04:00:00'))
						 when '05:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 05:00:00'))
						 when '06:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 06:00:00'))
						 when '07:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 07:00:00'))
						 when '08:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 08:00:00'))
						 when '09:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 09:00:00'))
						 when '10:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 10:00:00'))
						 when '11:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 11:00:00'))
						 when '12:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 12:00:00'))
						 when '13:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 13:00:00'))
						 when '14:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 14:00:00'))
						 when '15:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 15:00:00'))
						 when '16:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 16:00:00'))
						 when '17:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 17:00:00'))
						 when '18:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 18:00:00'))
						 when '19:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 19:00:00'))
						 when '20:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 20:00:00'))
						 when '21:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 21:00:00'))
						 when '22:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 22:00:00'))
						 when '23:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 23:00:00'))
						 when '00:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 00:00:00'))
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql



