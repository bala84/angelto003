:r ./../_define.sql

:setvar dc_number 00379
:setvar dc_description "car state const added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.09.2008 VLavrentiev  car state const added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go




set identity_insert dbo.CCAR_CAR_STATE on
insert into dbo.CCAR_CAR_STATE (id, short_name, full_name)
values(304, 'В ожидании ремонта', 'В ожидании ремонта')
set identity_insert dbo.CCAR_CAR_STATE off
go

insert into dbo.csys_const (id , name, description)
values(304, 'IN_WAIT_FOR_REPAIR', 'Состояние машины в ожидании ремонта')
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
** Процедура должна сохранить заказ-наряд
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
	,@p_employee_worker_id		   numeric(38,0) = null
	,@p_employee_output_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			varchar(20)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc			varchar(4000)
	,@p_repair_zone_master_id		numeric(38,0) = null
	,@p_wrh_order_master_type_id	numeric(38,0) = null
	,@p_run				    decimal(18,9) = null
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
--Небольшой маршрут состояний заказа-наряда
    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
											 when 'Взят на ремонт, сведений о необх. запчастях нет'
											 then 2
											 when 'Взят на ремонт, есть сведения о необх. запчастях'
											 then 3
											 when 'Обработан'
											 then 4 
											 when 'Отклонен'
											 then 5
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
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, run, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
			, @p_repair_zone_master_id, @p_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
		,run = @p_run
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
 --Если у машины нет открытого путевого листа 
 
 if (not exists (select top(1) 1 from dbo.cdrv_driver_list
  												where car_id = @p_car_id and speedometer_end_indctn is null))
 begin 
  if (@v_order_state = 0) or (@v_order_state = 5) 
 --Если заказ наряд открыт - проставим у машины состояние в ожидании ремонта
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfCONST('IN_WAIT_FOR_REPAIR')
   where id = @p_car_id
  if (@v_order_state = 2) or (@v_order_state = 3)
 --Если заказ-наряд в обработке - проставим у машины состояние в ремзоне
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_REPAIR_ZONE')
   where id = @p_car_id
 --Если закрыт и больше нет других открытых уберем
  if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0 
						   or order_state = 2 
						   or order_state = 3
						   or order_state = 5
					      and car_id = @p_car_id
						order by date_created desc))
	  update dbo.CCAR_CAR
		set car_state_id = dbo.usfCONST('IN_PARK')
	    where id = @p_car_id
 end


  exec @v_error = dbo.uspVREP_WRH_ORDER_MASTER_Prepare
   @p_id							= @p_id
  ,@p_number						= @p_number
  ,@p_car_id						= @p_car_id
  ,@p_employee_recieve_id			= @p_employee_recieve_id
  ,@p_employee_head_id				= @p_employee_head_id
  ,@p_employee_worker_id			= @p_employee_worker_id
  ,@p_employee_output_worker_id		= @p_employee_output_worker_id
  ,@p_date_created					= @p_date_created
  ,@p_order_state					= @v_order_state
  ,@p_repair_type_id				= @p_repair_type_id
  ,@p_malfunction_desc				= @p_malfunction_desc
  ,@p_repair_zone_master_id			= @p_repair_zone_master_id
  ,@p_wrh_order_master_type_id		= @p_wrh_order_master_type_id
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  exec @v_error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_Prepare
   @p_car_id						= @p_car_id
  ,@p_date_created					= @p_date_created
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
  return 

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения заказов-нарядов
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
		  ,a.number
		  ,a.employee_recieve_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. ' + substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
		  ,a.date_created
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_desc
		  ,a.run
		  ,case order_state when 0 
							then 'Открыт'
							when 1
							then 'Закрыт'
							when 2
						    then 'Взят на ремонт, сведений о необх. запчастях нет'
						    when 3
						    then 'Взят на ремонт, есть сведения о необх. запчастях'
						    when 4 
						    then 'Обработан'
						    when 5 
						    then 'Отклонен'
		   end as order_state 
		  ,a.repair_zone_master_id
		  ,a.employee_output_worker_id
		  ,c4.lastname + ' ' + substring(c4.name, 1, 1) + '. ' + substring(c4.surname, 1, 1) + '.' as FIO_employee_output_worker	  			
		  ,a.wrh_order_master_type_id
		  ,j.short_name as wrh_order_master_type_sname	
		FROM dbo.CWRH_WRH_ORDER_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		left outer join dbo.CPRT_EMPLOYEE as b2
			on a.employee_head_id = b2.id
		left outer join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		left outer join dbo.CPRT_EMPLOYEE as b3
			on a.employee_worker_id = b3.id
		left outer join dbo.CPRT_PERSON as c3
			on b3.person_id = c3.id
		left outer join dbo.CCAR_CAR as d
			on a.car_id = d.id
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CRPR_REPAIR_TYPE_MASTER as h
			on a.repair_type_id = h.id
		left outer join dbo.CPRT_EMPLOYEE as b4
			on a.employee_output_worker_id = b4.id
		left outer join dbo.CPRT_PERSON as c4
			on b4.person_id = c4.id
		left outer join dbo.CWRH_WRH_ORDER_MASTER_TYPE as j
			on a.wrh_order_master_type_id = j.id
	  WHERE a.date_created between @p_start_date
							   and @p_end_date
		
		
)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из заказов-нарядов
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
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 

   delete
	from dbo.CWRH_WRH_ORDER_DETAIL
	where wrh_order_master_id = @p_id 


delete
	from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	where wrh_order_master_id = @p_id



	delete
	from dbo.cwrh_wrh_order_master
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
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
** Процедура должна сохранить заказ-наряд
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
	,@p_employee_worker_id		   numeric(38,0) = null
	,@p_employee_output_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			varchar(100)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc			varchar(4000)
	,@p_repair_zone_master_id		numeric(38,0) = null
	,@p_wrh_order_master_type_id	numeric(38,0) = null
	,@p_run				    decimal(18,9) = null
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
--Небольшой маршрут состояний заказа-наряда
    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
											 when 'Взят на ремонт, сведений о необх. запчастях нет'
											 then 2
											 when 'Взят на ремонт, есть сведения о необх. запчастях'
											 then 3
											 when 'Обработан'
											 then 4 
											 when 'Отклонен'
											 then 5
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
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, run, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
			, @p_repair_zone_master_id, @p_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
		,run = @p_run
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
 --Если у машины нет открытого путевого листа 
 
 if (not exists (select top(1) 1 from dbo.cdrv_driver_list
  												where car_id = @p_car_id and speedometer_end_indctn is null))
 begin 
  if (@v_order_state = 0) or (@v_order_state = 5) 
 --Если заказ наряд открыт - проставим у машины состояние в ожидании ремонта
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfCONST('IN_WAIT_FOR_REPAIR')
   where id = @p_car_id
  if (@v_order_state = 2) or (@v_order_state = 3)
 --Если заказ-наряд в обработке - проставим у машины состояние в ремзоне
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_REPAIR_ZONE')
   where id = @p_car_id
 --Если закрыт и больше нет других открытых уберем
  if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0 
						   or order_state = 2 
						   or order_state = 3
						   or order_state = 5
					      and car_id = @p_car_id
						order by date_created desc))
	  update dbo.CCAR_CAR
		set car_state_id = dbo.usfCONST('IN_PARK')
	    where id = @p_car_id
 end


  exec @v_error = dbo.uspVREP_WRH_ORDER_MASTER_Prepare
   @p_id							= @p_id
  ,@p_number						= @p_number
  ,@p_car_id						= @p_car_id
  ,@p_employee_recieve_id			= @p_employee_recieve_id
  ,@p_employee_head_id				= @p_employee_head_id
  ,@p_employee_worker_id			= @p_employee_worker_id
  ,@p_employee_output_worker_id		= @p_employee_output_worker_id
  ,@p_date_created					= @p_date_created
  ,@p_order_state					= @v_order_state
  ,@p_repair_type_id				= @p_repair_type_id
  ,@p_malfunction_desc				= @p_malfunction_desc
  ,@p_repair_zone_master_id			= @p_repair_zone_master_id
  ,@p_wrh_order_master_type_id		= @p_wrh_order_master_type_id
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  exec @v_error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_Prepare
   @p_car_id						= @p_car_id
  ,@p_date_created					= @p_date_created
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
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
