:r ./../_define.sql

:setvar dc_number 00335
:setvar dc_description "rep order master fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.07.2008 VLavrentiev  rep order master fixed
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


alter table dbo.CREP_WRH_ORDER_MASTER
add organization_id numeric(38,0)
go

alter table dbo.CREP_WRH_ORDER_MASTER
add organization_sname varchar(30)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CREP_WRH_ORDER_MASTER', 'column', 'organization_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Название организации',
   'user', @CurrentUser, 'table', 'CREP_WRH_ORDER_MASTER', 'column', 'organization_sname'
go



create index i_organization_id_rep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(organization_id)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о заказе-наряде
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0)
	,@p_date_created		datetime
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)
	,@p_car_state_sname		varchar(30)
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)	
	,@p_employee_recieve_id numeric(38, 0)
	,@p_fio_employee_recieve varchar(256)
	,@p_employee_head_id	numeric(38, 0)
	,@p_fio_employee_head	varchar(256)
	,@p_employee_worker_id  numeric(38, 0)
	,@p_fio_employee_worker varchar(256)
	,@p_order_state			smallint
	,@p_repair_type_id		numeric(38, 0)
	,@p_malfunction_desc	varchar(4000)
	,@p_repair_zone_master_id numeric(38, 0)
	,@p_date_started		datetime
	,@p_date_ended			datetime
	,@p_malfunction_disc	varchar(4000)
	,@p_employee_output_worker_id	numeric(38, 0)
	,@p_fio_employee_output_worker	varchar(256)
	,@p_wrh_order_master_type_id	numeric(38, 0)
	,@p_wrh_order_master_type_sname varchar(30)
	,@p_organization_id	numeric(38, 0)
	,@p_organization_sname varchar(30)
	,@p_number				varchar(20)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on


    insert into dbo.CREP_WRH_ORDER_MASTER
            (id, date_created, state_number, car_id ,car_type_id
			,car_type_sname, car_state_id, car_state_sname
			,car_mark_id, car_mark_sname, car_model_id
			,car_model_sname
			,car_kind_id, car_kind_sname, employee_recieve_id
			,fio_employee_recieve, employee_head_id, fio_employee_head
			,employee_worker_id, fio_employee_worker, order_state
			,repair_type_id, malfunction_desc, repair_zone_master_id
			,date_started, date_ended, malfunction_disc, employee_output_worker_id
			,fio_employee_output_worker, wrh_order_master_type_id
			,wrh_order_master_type_sname, number, organization_id, organization_sname
			,sys_comment, sys_user_created, sys_user_modified)
	select   @p_id, @p_date_created, @p_state_number, @p_car_id ,@p_car_type_id
			,@p_car_type_sname, @p_car_state_id, @p_car_state_sname
			,@p_car_mark_id, @p_car_mark_sname, @p_car_model_id
			,@p_car_model_sname
			,@p_car_kind_id, @p_car_kind_sname, @p_employee_recieve_id
			,@p_fio_employee_recieve, @p_employee_head_id, @p_fio_employee_head
			,@p_employee_worker_id, @p_fio_employee_worker, @p_order_state
			,@p_repair_type_id, @p_malfunction_desc, @p_repair_zone_master_id
			,@p_date_started, @p_date_ended, @p_malfunction_disc, @p_employee_output_worker_id
			,@p_fio_employee_output_worker, @p_wrh_order_master_type_id
			,@p_wrh_order_master_type_sname, @p_number, @p_organization_id, @p_organization_sname
			,@p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_WRH_ORDER_MASTER as b
		 where b.id = @p_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_WRH_ORDER_MASTER
		 set
			  date_created = @p_date_created
			, state_number = @p_state_number
			, car_id = @p_car_id 
			, car_type_id = @p_car_type_id
			, car_type_sname = @p_car_type_sname
			, car_state_id = @p_car_state_id
			, car_state_sname = @p_car_state_sname
			, car_mark_id = @p_car_mark_id
			, car_mark_sname = @p_car_mark_sname
			, car_model_id = @p_car_model_id
			, car_model_sname = @p_car_model_sname
			, car_kind_id = @p_car_kind_id
			, car_kind_sname = @p_car_kind_sname
			, employee_recieve_id = @p_employee_recieve_id
			, fio_employee_recieve = @p_fio_employee_recieve
			, employee_head_id = @p_employee_head_id
			, fio_employee_head = @p_fio_employee_head
			, employee_worker_id = @p_employee_worker_id
			, fio_employee_worker = @p_fio_employee_worker
			, order_state = @p_order_state
			, repair_type_id = @p_repair_type_id
			, malfunction_desc = @p_malfunction_desc
			, repair_zone_master_id = @p_repair_zone_master_id
			, date_started = @p_date_started
			, date_ended = @p_date_ended
			, malfunction_disc = @p_malfunction_disc
			, employee_output_worker_id = @p_employee_output_worker_id
			, fio_employee_output_worker = @p_fio_employee_output_worker
			, wrh_order_master_type_id = @p_wrh_order_master_type_id
			, wrh_order_master_type_sname = @p_wrh_order_master_type_sname
			, number = @p_number
			, organization_id = @p_organization_id
			, organization_sname = @p_organization_sname
			, sys_comment = @p_sys_comment
			, sys_user_modified = @p_sys_user
		where id	= @p_id


    
  return 

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по заказам-нарядам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(    @p_id					numeric(38,0)
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0) = null
	,@p_employee_worker_id		   numeric(38,0) = null
	,@p_employee_output_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			smallint
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc			varchar(4000)
	,@p_repair_zone_master_id		numeric(38,0) = null
	,@p_wrh_order_master_type_id	numeric(38,0) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
AS
SET NOCOUNT ON
  
  
  declare
	 @v_car_type_id			 numeric(38,0)
	,@v_car_type_sname		 varchar(30)
	,@v_car_kind_id			 numeric(38,0)
	,@v_car_kind_sname		 varchar(30)
	,@v_car_mark_id			 numeric(38,0)
	,@v_car_mark_sname		 varchar(30)
	,@v_car_model_id		 numeric(38,0)
	,@v_car_model_sname		 varchar(30)
	,@v_car_state_id		 numeric(38,0)
	,@v_car_state_sname		 varchar(30)
	,@v_state_number		 varchar(20)
	,@v_fio_employee_recieve varchar(256)
	,@v_fio_employee_head    varchar(256)
	,@v_fio_employee_worker  varchar(256)
	,@v_fio_employee_output_worker varchar(256)
	,@v_date_started		 datetime
	,@v_date_ended			 datetime
	,@v_malfunction_disc	 varchar(4000)
	,@v_wrh_order_master_type_sname varchar(30)
	,@v_organization_id		 numeric(38,0)
	,@v_organization_sname	 varchar(30)
	,@v_Error		 int


  select 
	 @v_car_type_id		= car_type_id
	,@v_car_type_sname	= car_type_sname
	,@v_car_kind_id		= car_kind_id
	,@v_car_kind_sname	= car_kind_sname
	,@v_car_mark_id		= car_mark_id
	,@v_car_mark_sname	= car_mark_sname
	,@v_car_model_id	= car_model_id
	,@v_car_model_sname	= car_model_sname
	,@v_car_state_id	= car_state_id
	,@v_car_state_sname	= car_state_sname
	,@v_car_kind_id		= car_kind_id
	,@v_car_kind_sname	= car_kind_sname
	,@v_state_number	= state_number
    from dbo.utfVCAR_CAR()
	where id = @p_car_id

  select @v_date_started = date_started
		,@v_date_ended = date_ended
		,@v_malfunction_disc = malfunction_disc
	from dbo.CRPR_REPAIR_ZONE_MASTER
	where id = @p_repair_zone_master_id

  select @v_wrh_order_master_type_sname = short_name
	from dbo.CWRH_WRH_ORDER_MASTER_TYPE
	where id = @p_wrh_order_master_type_id


  select @v_fio_employee_recieve = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
	from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b on a.person_id = b.id
	where a.id = @p_employee_recieve_id

  select @v_fio_employee_head = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
	from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b on a.person_id = b.id
	where a.id = @p_employee_head_id


  select @v_fio_employee_worker = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
	from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b on a.person_id = b.id
	where a.id = @p_employee_worker_id


  select @v_fio_employee_output_worker = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
	from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b on a.person_id = b.id
	where a.id = @p_employee_output_worker_id

  select top(1) @v_organization_id = organization_id
    from dbo.CDRV_DRIVER_PLAN
  where car_id = @p_car_id
	order by month_year_index desc

  select @v_organization_sname = name
    from dbo.CPRT_ORGANIZATION
	where id = @v_organization_id


exec @v_Error = dbo.uspVREP_WRH_ORDER_MASTER_SaveById
   @p_id					= @p_id
  ,@p_date_created			= @p_date_created
  ,@p_state_number			= @v_state_number
  ,@p_car_id				= @p_car_id
  ,@p_car_type_id			= @v_car_type_id
  ,@p_car_type_sname		= @v_car_type_sname
  ,@p_car_state_id			= @v_car_state_id
  ,@p_car_state_sname		= @v_car_state_sname
  ,@p_car_mark_id			= @v_car_mark_id
  ,@p_car_mark_sname		= @v_car_mark_sname
  ,@p_car_model_id			= @v_car_model_id
  ,@p_car_model_sname		= @v_car_model_sname
  ,@p_car_kind_id			= @v_car_kind_id
  ,@p_car_kind_sname		= @v_car_kind_sname
  ,@p_employee_recieve_id	= @p_employee_recieve_id
  ,@p_fio_employee_recieve	= @v_fio_employee_recieve
  ,@p_employee_head_id		= @p_employee_head_id
  ,@p_fio_employee_head		= @v_fio_employee_head
  ,@p_employee_worker_id	= @p_employee_worker_id
  ,@p_fio_employee_worker	= @v_fio_employee_worker
  ,@p_order_state			= @p_order_state
  ,@p_repair_type_id		= @p_repair_type_id
  ,@p_malfunction_desc		= @p_malfunction_desc
  ,@p_repair_zone_master_id = @p_repair_zone_master_id
  ,@p_date_started			= @v_date_started
  ,@p_date_ended			= @v_date_ended
  ,@p_malfunction_disc		= @v_malfunction_disc
  ,@p_employee_output_worker_id = @p_employee_output_worker_id
  ,@p_fio_employee_output_worker = @v_fio_employee_output_worker
  ,@p_wrh_order_master_type_id	 = @p_wrh_order_master_type_id
  ,@p_wrh_order_master_type_sname	= @v_wrh_order_master_type_sname
  ,@p_number				= @p_number
  ,@p_organization_id		= @v_organization_id
  ,@p_organization_sname	= @v_organization_sname
  ,@p_sys_comment			= @p_sys_comment			
  ,@p_sys_user				= @p_sys_user



return
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVREP_WRH_ORDER_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по заказам-нарядам
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		 id
		,date_created
		,state_number
		,car_id
		,car_type_id
		,car_type_sname
		,car_state_id
		,car_state_sname
		,car_mark_id
		,car_mark_sname
		,car_model_id
		,car_model_sname
		,car_kind_id
		,car_kind_sname
		,employee_recieve_id
		,fio_employee_recieve
		,employee_head_id
		,fio_employee_head
		,employee_worker_id
		,fio_employee_worker
		,order_state
		,repair_type_id
		,malfunction_desc
		,repair_zone_master_id
		,date_started
		,date_ended
		,malfunction_disc
		,employee_output_worker_id
		,fio_employee_output_worker
		,wrh_order_master_type_id
		,wrh_order_master_type_sname
		,number 
		,organization_id
		,organization_sname
from dbo.CREP_WRH_ORDER_MASTER
	
)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по заведенным заказам-нарядам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date					  datetime
,@p_end_date					  datetime
,@p_car_mark_id					  numeric(38,0) = null
,@p_car_kind_id					  numeric(38,0) = null
,@p_car_id						  numeric(38,0) = null
,@p_employee_recieve_id			  numeric(38,0) = null
,@p_rpr_zone_d_employee_worker_id numeric(38,0) = null
,@p_employee_output_worker_id	  numeric(38,0) = null
,@p_employee_worker_id			  numeric(38,0) = null
,@p_repair_type_id				  numeric(38,0) = null
,@p_organization_id				  numeric(38,0) = null
)
AS
SET NOCOUNT ON

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

   
   select
		 dbo.usfUtils_DayTo01(date_created) as month_created
		,a.date_created
		,a.state_number
		,a.car_id
		,a.car_type_id
		,a.car_type_sname
		,a.car_state_id
		,a.car_state_sname
		,a.car_mark_id
		,a.car_mark_sname
		,a.car_model_id
		,a.car_model_sname
		,a.car_kind_id
		,a.car_kind_sname
		,a.employee_recieve_id
		,a.fio_employee_recieve
		,a.employee_head_id
		,a.fio_employee_head
		,a.employee_worker_id
		,a.fio_employee_worker
		,a.order_state
		,a.repair_type_id
		,a.malfunction_desc
		,a.repair_zone_master_id
		,a.date_started
		,a.date_ended
		,a.malfunction_disc
		,a.employee_output_worker_id
		,a.fio_employee_output_worker
		,a.wrh_order_master_type_id
		,a.wrh_order_master_type_sname
		,a.number
		,a.organization_id
		,a.organization_sname
	FROM dbo.utfVREP_WRH_ORDER_MASTER() as a
	left outer join dbo.CRPR_REPAIR_ZONE_DETAIL as b
		on a.repair_zone_master_id = b.repair_zone_master_id
	left outer join dbo.utfVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER() as c
		on a.id = c.wrh_order_master_id
	where a.date_created between  dbo.usfUtils_TimeToZero(@p_start_date) 
							and dbo.usfUtils_TimeToZero(@p_end_date)
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	  and (b.employee_worker_id = @p_rpr_zone_d_employee_worker_id or @p_rpr_zone_d_employee_worker_id is null)
	  and (a.employee_output_worker_id = @p_employee_output_worker_id or @p_employee_output_worker_id is null)
	  and (a.employee_worker_id = @p_employee_worker_id or @p_employee_worker_id is null)
	  and (c.repair_type_master_id = @p_repair_type_id or @p_repair_type_id is null)
	  and (a.organization_id = @p_organization_id or @p_organization_id is null)
	order by a.organization_sname, a.date_created, a.car_type_sname, a.car_mark_sname, a.state_number

	RETURN
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

