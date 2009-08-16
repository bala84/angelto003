
:r ./../_define.sql

:setvar dc_number 00465
:setvar dc_description "count repairs fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   13.05.2009 VLavrentiev   count repairs fix
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



ALTER PROCEDURE [dbo].[uspVREP_Count_repairs_by_head_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет по количеству ремонтов, обработанных бригадирами
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_start_date			datetime
 ,@p_end_date			datetime
)
AS
BEGIN

if (@p_start_date is null)
 set @p_start_date = dbo.usfUtils_MonthTo01(getdate())

if (@p_end_date is null)
 set @p_end_date = dateadd("Month", 1, dbo.usfUtils_MonthTo01(getdate()))

 set @p_start_date = dbo.usfUtils_TimeToZero(@p_start_date)

 set @p_end_date = dateadd("Day", 1, dbo.usfUtils_TimeToZero(@p_end_date))

select
	 fio
	,short_name
	,count(*) as kol
	    ,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
from
(select a.employee_head_id
	  ,rtrim(rtrim(ltrim(c.lastname)) + ' ' + isnull(substring(rtrim(ltrim(c.name)),1,1),'') + '. ' + isnull(substring(rtrim(ltrim(c.surname)),1,1),'') + '.') as fio
	  ,case when (f.id = dbo.usfConst('Дополнительное ТО')) 
			  or (f.id = dbo.usfConst('Осн. рем. работы в ремзоне'))
			  or (f.id = dbo.usfConst('Доп. рем. работы вне ремзоны'))
			then e.short_name
			else f.short_name
		end as short_name
from dbo.cwrh_wrh_order_master as a
join dbo.cprt_employee as b
	on a.employee_head_id = b.id
join dbo.cprt_person as c
    on c.id = b.person_id
join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as d
	on a.id = d.wrh_order_master_id
join dbo.CRPR_REPAIR_TYPE_MASTER as e
	on d.repair_type_master_id = e.id
join dbo.CRPR_REPAIR_TYPE_MASTER_KIND as f
	on e.repair_type_master_kind_id = f.id
where a.order_state in (1,4)
 and a.date_created >= @p_start_date
 and a.date_created < @p_end_date) as a
group by 
     employee_head_id 
	,fio
	,short_name
order by fio
	,short_name

end


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



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
											 when 'Корректировка'
											 then 6
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
  if (@v_order_state = 0)
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
					      and car_id = @p_car_id
						order by date_created desc))
	  update dbo.CCAR_CAR
		set car_state_id = dbo.usfCONST('IN_PARK')
	    where id = @p_car_id
 end

if (@p_car_id is not null)
 begin
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
 end

  /*exec @v_error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_Prepare
   @p_car_id						= @p_car_id
  ,@p_date_created					= @p_date_created
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end */
  --Если заказ в корректировке - то и требования должны быть в корректировке
  if (@v_order_state = 6)

   update dbo.cwrh_wrh_demand_master
	  set is_verified = 2
	 where wrh_order_master_id = @p_id
  /*else
   update dbo.cwrh_wrh_demand_master
	  set is_verified = 0
	 where wrh_order_master_id = @p_id   
	   and is_verified = 2*/

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



