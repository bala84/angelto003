:r ./../_define.sql

:setvar dc_number 00215
:setvar dc_description "month plan procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    03.05.2008 VLavrentiev  month plan procs added
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

CREATE FUNCTION [dbo].[utfVDRV_MONTH_PLAN] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CDRV_MONTH_PLAN
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,"month"
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
      FROM dbo.CDRV_MONTH_PLAN
	  where "month" between @p_start_date and @p_end_date
)
go


GRANT VIEW DEFINITION ON [dbo].[utfVDRV_MONTH_PLAN] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVDRV_MONTH_PLAN_SelectAll]
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
  
       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,"month"
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
		FROM dbo.utfVDRV_MONTH_PLAN(@p_start_date, @p_end_date)

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVDRV_MONTH_PLAN_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_MONTH_PLAN_SelectAll] TO [$(db_app_user)]
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_MONTH_PLAN_SaveById]
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
	,@p_month		datetime
    ,@p_day_1		tinyint
	,@p_day_2		tinyint
	,@p_day_3		tinyint
	,@p_day_4		tinyint
	,@p_day_5		tinyint
	,@p_day_6		tinyint
	,@p_day_7		tinyint
	,@p_day_8		tinyint
	,@p_day_9		tinyint
	,@p_day_10		tinyint
	,@p_day_11		tinyint
	,@p_day_12		tinyint
	,@p_day_13		tinyint
	,@p_day_14		tinyint
	,@p_day_15		tinyint
	,@p_day_16		tinyint
	,@p_day_17		tinyint
	,@p_day_18		tinyint
	,@p_day_19		tinyint
	,@p_day_20		tinyint
	,@p_day_21		tinyint
	,@p_day_22		tinyint
	,@p_day_23		tinyint
	,@p_day_24		tinyint
	,@p_day_25		tinyint		  
	,@p_day_26		tinyint
	,@p_day_27		tinyint
	,@p_day_28		tinyint		= null
	,@p_day_29		tinyint		= null
	,@p_day_30		tinyint		= null
	,@p_day_31		tinyint		= null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_MONTH_PLAN
            ("month", day_1, day_2, day_3, day_4 ,day_5 ,day_6 ,day_7 ,day_8
			,day_9 ,day_10 ,day_11 ,day_12 ,day_13 ,day_14 ,day_15 ,day_16
		    ,day_17 ,day_18 ,day_19 ,day_20 ,day_21 ,day_22 ,day_23 ,day_24
		    ,day_25	,day_26 ,day_27 ,day_28 ,day_29 ,day_30 ,day_31
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_month, @p_day_1, @p_day_2, @p_day_3, @p_day_4 ,@p_day_5 ,@p_day_6 ,@p_day_7 ,@p_day_8
			,@p_day_9 , @p_day_10 ,@p_day_11 ,@p_day_12 ,@p_day_13 ,@p_day_14 ,@p_day_15 ,@p_day_16
		    ,@p_day_17, @p_day_18 ,@p_day_19 ,@p_day_20 ,@p_day_21 ,@p_day_22 ,@p_day_23 ,@p_day_24
		    ,@p_day_25, @p_day_26 ,@p_day_27 ,@p_day_28 ,@p_day_29 ,@p_day_30 ,@p_day_31
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_MONTH_PLAN set
		 "month" = @p_month
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
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
GO

GRANT EXECUTE ON [dbo].[uspVDRV_MONTH_PLAN_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_MONTH_PLAN_SaveById] TO [$(db_app_user)]
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_MONTH_PLAN_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из планов выхода на линию
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CDRV_MONTH_PLAN
	where id = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVDRV_MONTH_PLAN_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_MONTH_PLAN_DeleteById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVDRV_DRIVER_PLAN] 
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
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVDRV_DRIVER_PLAN] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_SelectAll]
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
		  ,time
		  ,employee1_id
		  ,fio_driver1
		  ,employee2_id
		  ,fio_driver2
		  ,employee3_id
		  ,fio_driver3
		  ,employee4_id
		  ,fio_driver4
		FROM dbo.utfVDRV_DRIVER_PLAN()

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_SelectAll] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_DRIVER_PLAN_SaveById]
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
    ,@p_time			datetime
	,@p_employee1_id	numeric(38,0)
	,@p_employee2_id	numeric(38,0) = null
	,@p_employee3_id	numeric(38,0) = null
	,@p_employee4_id	numeric(38,0) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN
            (car_id, "time", employee1_id, employee2_id, employee3_id ,employee4_id
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_time, @p_employee1_id, @p_employee2_id, @p_employee3_id ,@p_employee4_id
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_PLAN set
		  car_id = @p_car_id
		, "time" = @p_time
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

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_DRIVER_PLAN_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из планов выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CDRV_DRIVER_PLAN
	where id = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_PLAN_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_PLAN_DeleteById] TO [$(db_app_user)]
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

