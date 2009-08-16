:r ./../_define.sql

:setvar dc_number 00380
:setvar dc_description "delete condition his added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   18.09.2008 VLavrentiev  delete condition his added
*******************************************************************************/ 
use [$(db_name)]
GO

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

create procedure [dbo].[uspVHIS_CONDITION_DeleteBy_CarId]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку о ТО из истории состояния автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_car_id          numeric(38,0)
)
as
begin

  
delete from dbo.chis_condition
where exists
 (select 1 from dbo.chis_condition as a
		 join (select top(1) b.ts_type_route_detail_id, b.last_ts_type_route_detail_id, b.date_created 
				from dbo.chis_condition as b
				where b.car_id = @p_car_id
				  and b.sent_to = 'Y'
				order by b.date_created desc) as b on b.ts_type_route_detail_id = a.ts_type_route_detail_id
												  and b.last_ts_type_route_detail_id = a.last_ts_type_route_detail_id
where a.car_id = @p_car_id
  and a.sent_to = 'Y'
  and a.date_created >= b.date_created
  and a.id = dbo.chis_condition.id)
    
  

return 
end

go


GRANT EXECUTE ON [dbo].[uspVHIS_CONDITION_DeleteBy_CarId] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVHIS_CONDITION_DeleteBy_CarId] TO [$(db_app_user)]
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
