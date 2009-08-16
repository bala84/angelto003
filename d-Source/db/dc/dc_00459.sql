
:r ./../_define.sql

:setvar dc_number 00459
:setvar dc_description "drv plan detail adding fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.04.2009 VLavrentiev   drv plan detail adding fixed
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











ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_CreateBy_prevdate]
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
	,@p_curr_date		 datetime
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

    select  @p_date =      dbo.usfUtils_TimeToZero(@p_date)
	select  @p_curr_date = dbo.usfUtils_TimeToZero(@p_curr_date)
 
															


	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   select car_id, @p_curr_date, dateadd("Day", datediff("Day", @p_date, @p_curr_date), "time"), employee_id, shift_number, comments ,mech_employee_id, 0
			,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, @p_sys_user, @p_sys_user
	     from dbo.CDRV_DRIVER_PLAN_DETAIL
	   where date = @p_date
		 and organization_id = @p_organization_id
		 and car_kind_id = @p_car_kind_id


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



