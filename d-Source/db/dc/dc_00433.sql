:r ./../_define.sql

:setvar dc_number 00433
:setvar dc_description "income order procs fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   29.03.2009 VLavrentiev   income order procs fixed
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


ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_ORDER_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях заявок на закупку запчастей
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_wrh_income_order_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_income_order_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,convert(decimal(18,2), a.total) as total
		  ,convert(decimal(18,2), a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,a.car_id
		  ,c.state_number
	FROM dbo.CWRH_WRH_INCOME_ORDER_DETAIL as a
	join dbo.CWRH_GOOD_CATEGORY as b
	on a.good_category_id = b.id
	join dbo.ccar_car as c
	on a.car_id = c.id
	 where a.wrh_income_order_master_id = @p_wrh_income_order_master_id
	   and b.sys_status = 1
	   and c.sys_status = 1

	RETURN

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go










ALTER procedure [dbo].[uspVCAR_RETURN_REASON_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить причины возврата
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 	 datetime	   = null
	,@p_comments		 	varchar(1000) = null
	,@p_mech_employee_id 		numeric(38,0) = null
	,@p_car_return_reason_type_id	numeric(38,0)
	,@p_rownum			int
	,@p_is_verified		varchar(30) = null
    	,@p_sys_comment		varchar(2000)  = '-'
    	,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_is_verified bit


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'

	if (@p_is_verified = 'Не проверен')
	set @v_is_verified = 0
	else
	set @v_is_verified = 1

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_RETURN_REASON_DETAIL
            (car_id, date, "time",  comments ,mech_employee_id, car_return_reason_type_id, is_verified, rownum
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @p_time, @p_comments ,@p_mech_employee_id, @p_car_return_reason_type_id, @v_is_verified, @p_rownum
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_RETURN_REASON_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @p_time
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, car_return_reason_type_id     = @p_car_return_reason_type_id
	    , is_verified = @v_is_verified
		, rownum = @p_rownum
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



