
:r ./../_define.sql

:setvar dc_number 00462
:setvar dc_description "rep count cars fixed#3"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   24.04.2009 VLavrentiev   rep count cars fixed#3
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


CREATE trigger [TAIUD_CDRV_DRIVER_LIST]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для регистрации созданного плана выхода на линию
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CDRV_DRIVER_LIST]
after insert, update, delete
as
begin
  
  
  -- Если время позже шести - проставим статус плана - завершен
  if (datepart("Hh", getdate()) > 6) 
  begin
    update dbo.cdrv_driver_plan_detail
	   set is_completed = 1
	  where is_completed = 0
		and date = dbo.usfUtils_TimeToZero(getdate())
  end
  -- Если плана нет в отчетных планах добавим отчет
  if (not exists (select 1 from dbo.crep_driver_plan_detail where date = dbo.usfUtils_TimeToZero(getdate())))
  begin
	insert into dbo.crep_driver_plan_detail( car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
											,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname)
	select car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
		  ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname
	  from dbo.cdrv_driver_plan_detail
	  where date = dbo.usfUtils_TimeToZero(getdate())
  end	 


end
go

DROP TRIGGER [dbo].[TAIUD_CDRV_DRIVER_PLAN_DETAIL]
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



