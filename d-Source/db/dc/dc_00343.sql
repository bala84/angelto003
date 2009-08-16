:r ./../_define.sql

:setvar dc_number 00343
:setvar dc_description "repair by car report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    04.07.2008 VLavrentiev  repair by car report fixed
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

ALTER PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü îò÷åò î ğåìîíòàõ ïî àâòîìîáèëÿì
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.07.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()
  
select
	
		   date_created
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , car_kind_id
		 , car_kind_sname
		 , short_name
		 , repair_type_master_id
		 , amt
		 , organization_id
		 , organization_sname
	FROM dbo.utfVREP_REPAIR_BY_CAR_DAY() as a
	where ((date_created >= @p_start_date
		and date_created <= @p_end_date) or date_created = dbo.usfUtils_DayTo01(@p_start_date)
										  or date_created = dbo.usfUtils_DayTo01(@p_end_date))
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null) 
	  and (organization_id = @p_organization_id or @p_organization_id is null)
order by 
	  date_created
	 ,organization_sname
	 ,state_number

	RETURN
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


