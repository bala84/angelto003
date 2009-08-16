:r ./../_define.sql

:setvar dc_number 00301
:setvar dc_description "order repair zone fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.06.2008 VLavrentiev  order repair zone fix
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


alter table dbo.CRPR_REPAIR_ZONE_DETAIL
add employee_worker_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид механика',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'employee_worker_id'
go


create index ifk_rpr_zone_detail_employee_worker_id on dbo.CRPR_REPAIR_ZONE_DETAIL(employee_worker_id)
on $(fg_idx_name)
go


alter table dbo.CRPR_REPAIR_ZONE_DETAIL
   add constraint CRPR_REPAIR_ZONE_DETAIL_EMPLOYEE_ID_FK foreign key (employee_worker_id)
      references CPRT_EMPLOYEE (id)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVRPR_REPAIR_ZONE_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей ремонтной зоны
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_repair_zone_master_id numeric(38,0)
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
		  ,a.repair_zone_master_id
		  ,a.work_desc
		  ,a.hour_amount
		  ,a.employee_worker_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. ' + substring(c.surname, 1, 1) + '.' as FIO_employee_worker	  			
      FROM dbo.CRPR_REPAIR_ZONE_DETAIL as a
		left outer join dbo.CPRT_EMPLOYEE as b
			on a.employee_worker_id = b.id
		left outer join dbo.CPRT_PERSON as c
			on b.person_id = c.id
	  where a.repair_zone_master_id = @p_repair_zone_master_id
	
)
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях ремонтной зоны
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_repair_zone_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,repair_zone_master_id
		  ,work_desc
		  ,hour_amount
		  ,employee_worker_id
		  ,fio_employee_worker
	FROM dbo.utfVRPR_REPAIR_ZONE_DETAIL(@p_repair_zone_master_id)

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь ремонтной зоны
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_repair_zone_master_id	numeric(38,0)
    ,@p_work_desc				varchar(2000) = '-//-'
	,@p_hour_amount				int
	,@p_employee_worker_id		numeric(38,0) = null
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
			     dbo.CRPR_REPAIR_ZONE_DETAIL 
            ( repair_zone_master_id, work_desc
			, hour_amount, employee_worker_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_repair_zone_master_id, @p_work_desc
			, @p_hour_amount, @p_employee_worker_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_DETAIL set
		 repair_zone_master_id = @p_repair_zone_master_id
		,work_desc = @p_work_desc
		,hour_amount = @p_hour_amount
		,employee_worker_id = @p_employee_worker_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
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
