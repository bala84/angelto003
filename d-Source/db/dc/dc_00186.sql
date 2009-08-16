:r ./../_define.sql

:setvar dc_number 00186
:setvar dc_description "repair zone master added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.04.2008 VLavrentiev  repair zone master added
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

create FUNCTION [dbo].[utfVRPR_REPAIR_ZONE_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения ремонтной зоны
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
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
		  ,d.state_number
		  ,f.short_name as car_mark_sname
		  ,g.short_name as car_model_sname
		  ,a.employee_h_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + substring(c.surname, 1, 1) as FIO_employee_h
		  ,a.employee_mech_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + substring(c2.surname, 1, 1) as FIO_employee_mech
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_disc	
		  ,a.date_started
		  ,a.date_ended		
      FROM dbo.CRPR_REPAIR_ZONE_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_h_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CPRT_EMPLOYEE as b2
			on a.employee_mech_id = b.id
		join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		join dbo.CCAR_CAR as d
			on a.car_id = d.id
		join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CRPR_REPAIR_TYPE_MASTER as h
			on a.repair_type_id = h.id
	  WHERE a.date_started between @p_start_date
							   and @p_end_date
		
		
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVRPR_REPAIR_ZONE_MASTER] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о ремонтных зонах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
)
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
		  ,car_mark_sname
		  ,car_model_sname
		  ,employee_h_id
		  ,FIO_employee_h
		  ,employee_mech_id
		  ,FIO_employee_mech 
		  ,repair_type_id
		  ,repair_type_sname
		  ,malfunction_disc	
		  ,date_started
		  ,date_ended 
	FROM dbo.utfVRPR_REPAIR_ZONE_MASTER(@p_start_date, @p_end_date)

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить ремонтную зону
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
	,@p_car_id				numeric(38,0)
	,@p_employee_h_id		numeric(38,0)
	,@p_employee_mech_id	numeric(38,0)
	,@p_date_started		datetime
	,@p_date_ended			datetime	  = null
	,@p_repair_type_id		numeric(38,0)
	,@p_malfunction_disc	varchar(4000) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
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
			     dbo.CRPR_REPAIR_ZONE_MASTER
            ( car_id, date_started, date_ended, employee_h_id
			, employee_mech_id, repair_type_id, malfunction_disc
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_date_started, @p_date_ended, @p_employee_h_id
			, @p_employee_mech_id, @p_repair_type_id, @p_malfunction_disc
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_MASTER set
		 @p_car_id = @p_car_id
		,@p_date_started = @p_date_started
		,@p_date_ended = @p_date_ended
		,@p_employee_h_id = @p_employee_h_id
		,@p_employee_mech_id = @p_employee_mech_id
		,@p_repair_type_id = @p_repair_type_id
		,@p_malfunction_disc = @p_malfunction_disc
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из ремонтных зон
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.crpr_repair_zone_master
	where id = @p_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById] TO [$(db_app_user)]
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

