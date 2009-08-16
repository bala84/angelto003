:r ./../_define.sql

:setvar dc_number 00232
:setvar dc_description "rep wrh_demand fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.05.2008 VLavrentiev  rep wrh_demand fixed
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
add wrh_demand_detail_id numeric(38,0)
go


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид детали требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'wrh_demand_detail_id'
GO




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
			,employee_worker_fio, organization_recieve_id
			,organization_head_id, organization_worker_id, sys_comment, sys_user_created, sys_user_modified)
	select   @p_wrh_demand_master_id, @p_wrh_demand_detail_id, @p_good_category_id, @p_good_category_sname
			,@p_amount, @p_warehouse_type_id, @p_warehouse_type_sname, @p_car_id
			,@p_state_number, @p_car_type_id, @p_car_kind_id, @p_car_mark_id, @p_car_model_id
			,@p_number, @p_date_created, @p_employee_recieve_id, @p_employee_recieve_fio
			,@p_employee_head_id, @p_employee_head_fio, @p_employee_worker_id
			,@p_employee_worker_fio, @p_organization_recieve_id
			,@p_organization_head_id, @p_organization_worker_id, @p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_WRH_DEMAND as b
		 where b.wrh_demand_master_id = @p_wrh_demand_master_id) 
       
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
			,organization_head_id	= @p_organization_head_id
			,organization_worker_id	= @p_organization_worker_id
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where wrh_demand_master_id = @p_wrh_demand_master_id


    
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
	  ,@v_Error int

  select @v_number = number 
		,@v_car_id = car_id
		,@v_date_created = date_created
		,@v_employee_recieve_id = employee_recieve_id
		,@v_employee_head_id = employee_head_id
		,@v_employee_worker_id = employee_worker_id
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

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь требования
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_demand_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					int
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				int = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int
		  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    --Проставим режим обработки для товара со склада в режим апдейта
	set @v_edit_state = 'U'

    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_DETAIL 
            ( wrh_demand_master_id, good_category_id
			, amount, warehouse_type_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id


  exec @v_Error = 
		dbo.uspVREP_WRH_DEMAND_Calculate
				 @p_id					= null
				,@p_wrh_demand_detail_id= @p_id
				,@p_wrh_demand_master_id= @p_wrh_demand_master_id
				,@p_good_category_id	= @p_good_category_id
				,@p_amount				= @p_amount
				,@p_warehouse_type_id	= @p_warehouse_type_id
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id

if (@p_last_amount is null) or (@p_last_amount = @p_amount)
	set @p_amount = -@p_amount
else
	set @p_amount = -(@p_amount - @p_last_amount)

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @p_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_edit_state = @v_edit_state
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

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
GO



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
			,employee_worker_fio, organization_recieve_id
			,organization_head_id, organization_worker_id, sys_comment, sys_user_created, sys_user_modified)
	select   @p_wrh_demand_master_id, @p_wrh_demand_detail_id, @p_good_category_id, @p_good_category_sname
			,@p_amount, @p_warehouse_type_id, @p_warehouse_type_sname, @p_car_id
			,@p_state_number, @p_car_type_id, @p_car_kind_id, @p_car_mark_id, @p_car_model_id
			,@p_number, @p_date_created, @p_employee_recieve_id, @p_employee_recieve_fio
			,@p_employee_head_id, @p_employee_head_fio, @p_employee_worker_id
			,@p_employee_worker_fio, @p_organization_recieve_id
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
			,organization_head_id	= @p_organization_head_id
			,organization_worker_id	= @p_organization_worker_id
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where wrh_demand_detail_id = @p_wrh_demand_detail_id


    
  return 

end
GO


create index ifk_wrh_demand_detail_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(wrh_demand_detail_id)
on $(fg_idx_name)
go


DROP INDEX [u_wrh_demand_master_id_crep_demand] ON [dbo].[CREP_WRH_DEMAND]
go

create index ifk_wrh_demand_master_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(wrh_demand_master_id)
on $(fg_idx_name)
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




