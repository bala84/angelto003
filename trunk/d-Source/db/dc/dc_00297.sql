:r ./../_define.sql

:setvar dc_number 00297
:setvar dc_description "rpr zone master fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.06.2008 VLavrentiev  rpr zone master fixed
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


alter table dbo.CRPR_REPAIR_ZONE_MASTER
add wrh_order_master_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид заказа-наряда',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'wrh_order_master_id'
go


alter table dbo.CRPR_REPAIR_ZONE_MASTER
   add constraint CRPR_REPAIR_ZONE_MASTER_ORDER_MASTER_ID_FK foreign key (wrh_order_master_id)
      references CWRH_WRH_ORDER_MASTER (id)
go



create index ifk_order_master_id_rpr_zone_master on dbo.CRPR_REPAIR_ZONE_MASTER(wrh_order_master_id)
on $(fg_idx_name)
go


alter table dbo.CRPR_REPAIR_ZONE_MASTER
alter column  repair_type_id numeric(38,0)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVRPR_REPAIR_ZONE_MASTER] 
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
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '.' + substring(c.surname, 1, 1)+ '.' as FIO_employee_h
		  ,a.employee_mech_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '.' + substring(c2.surname, 1, 1)+ '.' as FIO_employee_mech
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_disc	
		  ,a.date_started
		  ,a.date_ended	
		  ,a.wrh_order_master_id	
      FROM dbo.CRPR_REPAIR_ZONE_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_h_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CPRT_EMPLOYEE as b2
			on a.employee_mech_id = b2.id
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

		
		
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectById]
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
@p_id numeric(38,0)
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
		  ,wrh_order_master_id
	FROM dbo.utfVRPR_REPAIR_ZONE_MASTER()
	where id = @p_id

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SelectAll]
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
		  ,wrh_order_master_id
	FROM dbo.utfVRPR_REPAIR_ZONE_MASTER()
	  WHERE date_started between @p_start_date
							   and @p_end_date

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_SaveById]
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
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_disc	varchar(4000) = null
	,@p_wrh_order_master_id	numeric(38,0) = null
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
			, employee_mech_id, repair_type_id, malfunction_disc, wrh_order_master_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_date_started, @p_date_ended, @p_employee_h_id
			, @p_employee_mech_id, @p_repair_type_id, @p_malfunction_disc, @p_wrh_order_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_MASTER set
		 car_id = @p_car_id
		,date_started = @p_date_started
		,date_ended = @p_date_ended
		,employee_h_id = @p_employee_h_id
		,employee_mech_id = @p_employee_mech_id
		,repair_type_id = @p_repair_type_id
		,malfunction_disc = @p_malfunction_disc
		,wrh_order_master_id = @p_wrh_order_master_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта для заказа - наряда
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id		numeric(38,0)
	,@p_repair_type_master_id	numeric(38,0)
    ,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 
       
       
  
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
