:r ./../_define.sql

:setvar dc_number 00234
:setvar dc_description "demand type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.05.2008 VLavrentiev  demand type fixed
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


alter table dbo.CREP_WRH_DEMAND
add wrh_demand_master_type_id numeric(38,0)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '',
   'user', @CurrentUser, 'table', 'CREP_WRH_DEMAND', 'column', 'wrh_demand_master_type_id'
go


create index ifk_wrh_demand_master_type_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(wrh_demand_master_type_id)
on $(fg_idx_name)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_WRH_DEMAND_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о требовании
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) = null out
	,@p_wrh_demand_detail_id	numeric(38,0)
	,@p_wrh_demand_master_id	numeric(38,0)
	,@p_good_category_id		numeric(38,0)
	,@p_good_category_sname		varchar(30)
	,@p_amount					int
	,@p_warehouse_type_id		numeric(38,0)
	,@p_warehouse_type_sname	varchar(30)
	,@p_car_id					numeric(38,0) = null
	,@p_state_number			varchar(20) = null
	,@p_car_type_id				numeric(38,0) = null
	,@p_car_kind_id				numeric(38,0) = null
	,@p_car_mark_id				numeric(38,0) = null
	,@p_car_model_id			numeric(38,0) = null
	,@p_number					varchar(20)
	,@p_date_created			datetime
	,@p_employee_recieve_id		numeric(38,0)
	,@p_employee_recieve_fio	varchar(100)
	,@p_employee_head_id		numeric(38,0)
	,@p_employee_head_fio		varchar(100)
	,@p_employee_worker_id		numeric(38,0)
	,@p_employee_worker_fio		varchar(100)
	,@p_organization_recieve_id numeric(38,0)
	,@p_wrh_demand_master_type_id numeric(38,0)
	,@p_organization_head_id	numeric(38,0)
	,@p_organization_worker_id  numeric(38,0)
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
	
    insert into dbo.CREP_WRH_DEMAND
            (wrh_demand_master_id, wrh_demand_detail_id, good_category_id, good_category_sname
			,amount, warehouse_type_id, warehouse_type_sname, car_id
			,state_number, car_type_id, car_kind_id, car_mark_id, car_model_id
			,number, date_created, employee_recieve_id, employee_recieve_fio
			,employee_head_id, employee_head_fio, employee_worker_id
			,employee_worker_fio, organization_recieve_id, wrh_demand_master_type_id
			,organization_head_id, organization_worker_id, sys_comment, sys_user_created, sys_user_modified)
	select   @p_wrh_demand_master_id, @p_wrh_demand_detail_id, @p_good_category_id, @p_good_category_sname
			,@p_amount, @p_warehouse_type_id, @p_warehouse_type_sname, @p_car_id
			,@p_state_number, @p_car_type_id, @p_car_kind_id, @p_car_mark_id, @p_car_model_id
			,@p_number, @p_date_created, @p_employee_recieve_id, @p_employee_recieve_fio
			,@p_employee_head_id, @p_employee_head_fio, @p_employee_worker_id
			,@p_employee_worker_fio, @p_organization_recieve_id, @p_wrh_demand_master_type_id
			,@p_organization_head_id, @p_organization_worker_id, @p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_WRH_DEMAND as b
		 where b.wrh_demand_detail_id = @p_wrh_demand_detail_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_WRH_DEMAND
		 set
			 wrh_demand_master_id	= @p_wrh_demand_master_id
			,wrh_demand_detail_id   = @p_wrh_demand_detail_id
			,good_category_id		= @p_good_category_id
			,good_category_sname	= @p_good_category_sname
			,amount					= @p_amount
			,warehouse_type_id		= @p_warehouse_type_id
			,warehouse_type_sname	= @p_warehouse_type_sname
			,car_id					= @p_car_id
			,state_number			= @p_state_number
			,car_type_id			= @p_car_type_id
			,car_kind_id			= @p_car_kind_id
			,car_mark_id			= @p_car_mark_id
			,car_model_id			= @p_car_model_id
			,number					= @p_number
			,date_created			= @p_date_created
			,employee_recieve_id	= @p_employee_recieve_id
			,employee_recieve_fio	= @p_employee_recieve_fio
			,employee_head_id		= @p_employee_head_id
			,employee_head_fio		= @p_employee_head_fio
			,employee_worker_id		= @p_employee_worker_id
			,employee_worker_fio	= @p_employee_worker_fio
			,organization_recieve_id= @p_organization_recieve_id
			,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
			,organization_head_id	= @p_organization_head_id
			,organization_worker_id	= @p_organization_worker_id
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where wrh_demand_detail_id = @p_wrh_demand_detail_id


    
  return 

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по требованиям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id						numeric(38,0) = null out
	,@p_wrh_demand_master_id	numeric(38,0)
	,@p_good_category_id		numeric(38,0)
	,@p_amount					int
	,@p_warehouse_type_id		numeric(38,0)
	,@p_wrh_demand_detail_id	numeric(38,0)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare
	   @v_warehouse_type_sname	varchar(30)
	  ,@v_car_id					numeric(38,0)
	  ,@v_state_number			varchar(20)
	  ,@v_car_type_id			numeric(38,0)
	  ,@v_car_kind_id			numeric(38,0)
	  ,@v_car_mark_id			numeric(38,0)
	  ,@v_car_model_id			numeric(38,0)
	  ,@v_number					varchar(20)
	  ,@v_date_created			datetime
	  ,@v_employee_recieve_id	numeric(38,0)
	  ,@v_employee_recieve_fio	varchar(100)
	  ,@v_employee_head_id		numeric(38,0)
	  ,@v_employee_head_fio		varchar(100)
	  ,@v_employee_worker_id		numeric(38,0)
	  ,@v_employee_worker_fio	varchar(100)
	  ,@v_organization_recieve_id numeric(38,0)
	  ,@v_organization_head_id	 numeric(38,0)
	  ,@v_organization_worker_id  numeric(38,0)
	  ,@v_good_category_sname	varchar(30)
	  ,@v_wrh_demand_master_type_id numeric(38,0)
	  ,@v_Error int

  select @v_number = number 
		,@v_car_id = car_id
		,@v_date_created = date_created
		,@v_employee_recieve_id = employee_recieve_id
		,@v_employee_head_id = employee_head_id
		,@v_employee_worker_id = employee_worker_id
		,@v_wrh_demand_master_type_id = wrh_demand_master_type_id
	from dbo.CWRH_WRH_DEMAND_MASTER
	where id = @p_wrh_demand_master_id

  select @v_state_number = state_number
		,@v_car_type_id = car_type_id
		,@v_car_kind_id = car_kind_id
		,@v_car_mark_id = @v_car_mark_id
		,@v_car_model_id = car_model_id
	from dbo.CCAR_CAR
	where id = @v_car_id

  select @v_good_category_sname = short_name
	from dbo.CWRH_GOOD_CATEGORY
	where id = @p_good_category_id

  select @v_warehouse_type_sname = short_name
	from dbo.CWRH_WAREHOUSE_TYPE
	where id = @p_warehouse_type_id

  select @v_employee_recieve_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_recieve_id = a.organization_id
	from dbo.CPRT_EMPLOYEE as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id
 
	where a.id = @v_employee_recieve_id

  select @v_employee_head_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_head_id = a.organization_id
	from dbo.CPRT_EMPLOYEE as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id 
	where a.id = @v_employee_head_id

  select @v_employee_worker_fio = ltrim(rtrim(
									b.lastname + ' ' + substring(b.name,1,1) + '. '
									+ isnull(substring(b.surname,1,1),'') + '.'))
		,@v_organization_worker_id = a.organization_id
	from dbo.CPRT_EMPLOYEE
		as a
	  join dbo.CPRT_PERSON as b on a.person_id = b.id 
	where a.id = @v_employee_worker_id

	
 /* set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction */

  exec @v_Error = 
	dbo.uspVREP_WRH_DEMAND_SaveById
	 @p_id						= @p_id out
	,@p_wrh_demand_detail_id	= @p_wrh_demand_detail_id
	,@p_wrh_demand_master_id	= @p_wrh_demand_master_id
	,@p_good_category_id		= @p_good_category_id
	,@p_good_category_sname		= @v_good_category_sname
	,@p_amount					= @p_amount
	,@p_warehouse_type_id		= @p_warehouse_type_id
	,@p_warehouse_type_sname	= @v_warehouse_type_sname
	,@p_car_id					= @v_car_id
	,@p_state_number			= @v_state_number
	,@p_car_type_id				= @v_car_type_id
	,@p_car_kind_id				= @v_car_kind_id
	,@p_car_mark_id				= @v_car_mark_id
	,@p_car_model_id			= @v_car_model_id
	,@p_number					= @v_number
	,@p_date_created			= @v_date_created
	,@p_employee_recieve_id		= @v_employee_recieve_id
	,@p_employee_recieve_fio	= @v_employee_recieve_fio
	,@p_employee_head_id		= @v_employee_head_id
	,@p_employee_head_fio		= @v_employee_head_fio
	,@p_employee_worker_id		= @v_employee_worker_id
	,@p_employee_worker_fio		= @v_employee_worker_fio
	,@p_organization_recieve_id = @v_organization_recieve_id
	,@p_organization_head_id	= @v_organization_head_id
	,@p_organization_worker_id  = @v_organization_worker_id
	,@p_wrh_demand_master_type_id  = @v_wrh_demand_master_type_id
	,@p_sys_comment				= @p_sys_comment
	,@p_sys_user				= @p_sys_user

    /*   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end */


   
	 --  if (@@tranCount > @v_TrancountOnEntry)
     --   commit

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVREP_WRH_DEMAND] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по требованиям по автомобилям
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT   a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.car_type_id
			,a.car_mark_id
			,a.car_model_id
			,a.number
			,a.date_created
			,a.employee_recieve_id
			,a.employee_recieve_fio
			,a.employee_head_id
			,a.employee_head_fio
			,a.employee_worker_id
			,a.employee_worker_fio
			,a.organization_recieve_id
			,a.organization_head_id
			,a.organization_worker_id
			,a.car_kind_id
			,a.wrh_demand_master_type_id
      FROM dbo.CREP_WRH_DEMAND as a	
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_BY_RECIEVER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_employee_recieve_id numeric(38,0) = null

)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 
			 a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.employee_recieve_id
			,a.employee_recieve_fio
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and (a.employee_recieve_id = @p_employee_recieve_id or @p_employee_recieve_id is null)
	group by a.wrh_demand_master_id, a.good_category_id, a.good_category_sname
			,a.employee_recieve_id, a.employee_recieve_fio, a.warehouse_type_id, a.warehouse_type_sname
	order by a.employee_recieve_fio

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVREP_WRH_DEMAND_MONTH_BY_RECIEVER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_DEMAND_MONTH_BY_RECIEVER_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_MONTH_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 
			a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,sum(a.amount) as amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	group by a.wrh_demand_master_id, a.good_category_id, a.good_category_sname
			,a.car_id,a.state_number, a.warehouse_type_id, a.warehouse_type_sname
	order by a.state_number

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WRH_DEMAND_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о требованиях за день
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_wrh_demand_master_type_id numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

  
       SELECT  
			 a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,a.good_category_sname
			,a.amount
			,a.warehouse_type_id
			,a.warehouse_type_sname
			,a.car_id
			,a.state_number
			,a.car_type_id
			,a.car_mark_id
			,a.car_model_id
			,a.number
			,a.date_created
			,a.employee_recieve_id
			,a.employee_recieve_fio
			,a.employee_head_id
			,a.employee_head_fio
			,a.employee_worker_id
			,a.employee_worker_fio
			,a.organization_recieve_id
			,a.organization_head_id
			,a.organization_worker_id
			,a.car_kind_id
	FROM dbo.utfVREP_WRH_DEMAND() as a
	where a.date_created between  @p_start_date and @p_end_date
	  and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (a.wrh_demand_master_type_id = @p_wrh_demand_master_type_id or @p_wrh_demand_master_type_id is null)
	order by a.state_number, a.date_created, a.number

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




