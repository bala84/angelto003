:r ./../_define.sql

:setvar dc_number 00198
:setvar dc_description "repair_zone fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    15.04.2008 VLavrentiev  repair_zone fixed
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

create FUNCTION [dbo].[utfVRPR_REPAIR_ZONE_DETAIL] 
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
      FROM dbo.CRPR_REPAIR_ZONE_DETAIL as a
	  where a.repair_zone_master_id = @p_repair_zone_master_id
	
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVRPR_REPAIR_ZONE_DETAIL] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById]
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
    ,@p_work_desc				varchar(2000)
	,@p_hour_amount				int
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
			, hour_amount
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_repair_zone_master_id, @p_work_desc
			, @p_hour_amount
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_DETAIL set
		 repair_zone_master_id = @p_repair_zone_master_id
		,work_desc = @p_work_desc
		,hour_amount = @p_hour_amount
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id]
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
	FROM dbo.utfVRPR_REPAIR_ZONE_DETAIL(@p_repair_zone_master_id)

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SelectByMaster_Id] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей ремонтной зоны
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.crpr_repair_zone_detail
	where id = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_DeleteById] TO [$(db_app_user)]
GO




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
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '.' + substring(c.surname, 1, 1)+ '.' as FIO_employee_h
		  ,a.employee_mech_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '.' + substring(c2.surname, 1, 1)+ '.' as FIO_employee_mech
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
	  WHERE a.date_started between @p_start_date
							   and @p_end_date
		
		
)
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


alter table dbo.CRPR_REPAIR_ZONE_MASTER
alter column date_ended datetime
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById]
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
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 
   delete
	from dbo.crpr_repair_zone_detail
	where repair_zone_master_id = @p_id 


	delete
	from dbo.crpr_repair_zone_master
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
GO


alter table dbo.CWRH_WRH_ORDER_MASTER
add repair_zone_master_id numeric(38,0)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид ремонтной зоны',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'repair_zone_master_id'
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_REPAIR_ZONE_M_ID_FK foreign key (repair_zone_master_id)
      references CRPR_REPAIR_ZONE_MASTER (id)
go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить приходный документ на складе
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0) = null
	,@p_employee_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			varchar(20)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc	varchar(4000)
	,@p_repair_zone_master_id numeric(38,0) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	declare
		 @v_order_state smallint
		,@v_Error int
        ,@v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
						 end

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
  
  if (@@tranCount = 0)
    begin transaction  
       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_ORDER_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc
			, repair_zone_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc
			, @p_repair_zone_master_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_ORDER_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

 --Если заказ наряд открыт проставим у машины состояние в ремзоне
  if (@v_order_state = 0)

  update dbo.CCAR_CAR
	set car_state_id = dbo.usfCONST('IN_REPAIR_ZONE')
  where id = @p_car_id
 --Если закрыт уберем
  else
    update dbo.CCAR_CAR
	set car_state_id = null
  where id = @p_car_id

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
  return 

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById]
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
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 
   delete
	from dbo.crpr_repair_zone_detail
	where repair_zone_master_id = @p_id 

   update dbo.CWRH_WRH_ORDER_MASTER
	set repair_zone_master_id = null
	where repair_zone_master_id = @p_id


	delete
	from dbo.crpr_repair_zone_master
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
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

