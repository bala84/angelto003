:r ./../_define.sql

:setvar dc_number 00216
:setvar dc_description "month plan procs fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    03.05.2008 VLavrentiev  month plan procs fixed
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
		FROM dbo.utfVDRV_MONTH_PLAN(@p_start_date, @p_end_date)

	RETURN
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
		 when 'Январь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '01' 
																			+ '-' + '01'))
		 when 'Февраль' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '02' 
																			+ '-' + '01'))
		 when 'Март' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '03' 
																			+ '-' + '01'))
		 when 'Апрель' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '04' 
																			+ '-' + '01'))
		 when 'Май' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '05' 
																			+ '-' + '01'))
		 when 'Июнь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '06' 
																			+ '-' + '01'))
		 when 'Июль' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '07' 
																			+ '-' + '01'))
		 when 'Август' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '08' 
																			+ '-' + '01'))
		 when 'Сентябрь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '09' 
																			+ '-' + '01'))
		 when 'Октябрь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '10' 
																			+ '-' + '01'))
		 when 'Ноябрь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '11' 
																			+ '-' + '01'))
		 when 'Декабрь' then convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, getdate())) 
																			+ '-' + '12' 
																			+ '-' + '01'))
		 end

	

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
			(@v_month, @p_day_1, @p_day_2, @p_day_3, @p_day_4 ,@p_day_5 ,@p_day_6 ,@p_day_7 ,@p_day_8
			,@p_day_9 , @p_day_10 ,@p_day_11 ,@p_day_12 ,@p_day_13 ,@p_day_14 ,@p_day_15 ,@p_day_16
		    ,@p_day_17, @p_day_18 ,@p_day_19 ,@p_day_20 ,@p_day_21 ,@p_day_22 ,@p_day_23 ,@p_day_24
		    ,@p_day_25, @p_day_26 ,@p_day_27 ,@p_day_28 ,@p_day_29 ,@p_day_30 ,@p_day_31
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
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end
GO







alter table dbo.cdrv_month_plan
alter column day_1 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_2 tinyint
go

alter table dbo.cdrv_month_plan
alter column day_3 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_4 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_5 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_6 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_7 tinyint
go

alter table dbo.cdrv_month_plan
alter column day_8 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_9 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_10 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_11 tinyint
go

alter table dbo.cdrv_month_plan
alter column day_12 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_13 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_14 tinyint
go

alter table dbo.cdrv_month_plan
alter column day_15 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_16 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_17 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_18 tinyint
go

alter table dbo.cdrv_month_plan
alter column day_19 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_20 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_21 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_22 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_23 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_24 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_25 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_26 tinyint
go


alter table dbo.cdrv_month_plan
alter column day_27 tinyint
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

