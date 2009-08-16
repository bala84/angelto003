:r ./../_define.sql

:setvar dc_number 00342
:setvar dc_description "time conversion fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    04.07.2008 VLavrentiev  time conversion fixed
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

ALTER FUNCTION [dbo].[usfUtils_DayTo01](@date_with_time datetime)
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (SELECT '01' + '.' + convert(nvarchar(2), datepart(mm, @date_with_time)) + '.' 
										 +  convert(nvarchar(4), datepart(yyyy, @date_with_time))));  
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usfUtils_DayToValue](@p_date_with_time datetime, @p_value char(2))
/*
Функция возвращает значение определенного дня
*/
RETURNS datetime
AS
BEGIN
  declare
	 @v_day_limit int
	,@v_value datetime
 --Вычислим количество дней в месяце
  set @v_day_limit = datepart("Day", dateadd("mm", 1, dbo.usfUtils_DayTo01(@p_date_with_time)) - 1)
  --Если @p_value не больше максимального количества дней вернем результат
 if (@p_value <= @v_day_limit)
   set @v_value = convert(datetime, (SELECT @p_value + '.' + convert(nvarchar(2), datepart(mm, @p_date_with_time))
										+ '.' + convert(nvarchar(4), datepart(yyyy, @p_date_with_time))
										+ ' ' + '00:00:00'))  
  --иначе значение по умолчанию
else
   set @v_value = convert(datetime, '01.01.1900')

return @v_value

END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usfUtils_MonthTo01](@date_with_time datetime)
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (SELECT '01' + '.' + '01' + '.' + convert(nvarchar(4), datepart(yyyy, @date_with_time))));  
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[usfUtils_TimeToValue](@p_date_with_time datetime, @p_value char(8))
/*
Функция возвращает значение времени для определенного дня
*/
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (select convert(nvarchar(2), datepart(dd, @p_date_with_time))
						 + '.' + convert(nvarchar(2), datepart(mm, @p_date_with_time))
						 + '.' + convert(nvarchar(4), datepart(yyyy, @p_date_with_time))
						 + ' ' + @p_value)); 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[usfUtils_TimeToZero](@date_with_time datetime)
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (SELECT convert(nvarchar(2), datepart(dd, @date_with_time))
							+ '.' + convert(nvarchar(2), datepart(mm, @date_with_time)) 
							+ '.' + convert(nvarchar(4), datepart(yyyy, @date_with_time))
							 + ' 00:00:00'));  /* добавлять 00:00:00 не обязательно */
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @v_month = 
		 case @p_month
		 when 'Январь' then convert(datetime, (SELECT '01' + '.' + '01' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Февраль' then convert(datetime, (SELECT '01' + '.' + '02' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Март' then convert(datetime, (SELECT '01' + '.' + '03' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Апрель' then convert(datetime, (SELECT '01' + '.' + '04' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Май' then convert(datetime, (SELECT '01' + '.' + '05' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Июнь' then convert(datetime, (SELECT '01' + '.' + '06' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Июль' then convert(datetime, (SELECT '01' + '.' + '07' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Август' then convert(datetime, (SELECT '01' + '.' + '08' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Сентябрь' then convert(datetime, (SELECT '01' + '.' + '09' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Октябрь' then convert(datetime, (SELECT '01' + '.' + '10' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Ноябрь' then convert(datetime, (SELECT '01' + '.' + '11' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
		 when 'Декабрь' then convert(datetime, (SELECT '01' + '.' + '12' + '.' + convert(nvarchar(4), datepart(yyyy, getdate()))))
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
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 01:00:00'),113)
						 when '02:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 02:00:00'),113)
						 when '03:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 03:00:00'),113)
						 when '04:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 04:00:00'),113)
						 when '05:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 05:00:00'),113)
						 when '06:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 06:00:00'),113)
						 when '07:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 07:00:00'),113)
						 when '08:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 08:00:00'),113)
						 when '09:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 09:00:00'),113)
						 when '10:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 10:00:00'),113)
						 when '11:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 11:00:00'),113)
						 when '12:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 12:00:00'),113)
						 when '13:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 13:00:00'),113)
						 when '14:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 14:00:00'),113)
						 when '15:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 15:00:00'),113)
						 when '16:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 16:00:00'),113)
						 when '17:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 17:00:00'),113)
						 when '18:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 18:00:00'),113)
						 when '19:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 19:00:00'),113)
						 when '20:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 20:00:00'),113)
						 when '21:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 21:00:00'),113)
						 when '22:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 22:00:00'),113)
						 when '23:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 23:00:00'),113)
						 when '00:00'
						 then convert(datetime, (SELECT '01' + '.' + @p_month + '.' + @v_year + ' 00:00:00'),113)
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


