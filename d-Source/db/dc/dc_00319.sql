:r ./../_define.sql

:setvar dc_number 00319
:setvar dc_description "rep wrh order save added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.06.2008 VLavrentiev  rep wrh order save added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById]
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
	,@p_number				numeric(38,0)
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
			,wrh_order_master_type_sname, number
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
			,@p_wrh_order_master_type_sname, @p_number
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
			, sys_comment = @p_sys_comment
			, sys_user_modified = @p_sys_user
		where id	= @p_id


    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVREP_WRH_ORDER_MASTER_Prepare]
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
	,@p_order_state			varchar(20)
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
	from dbo.CWRH_ORDER_MASTER_TYPE
	where id = wrh_order_master_type_id


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
  ,@p_sys_comment			= @p_sys_comment			
  ,@p_sys_user				= @p_sys_user



return
go

GRANT EXECUTE ON [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_WRH_ORDER_MASTER_SaveById] TO [$(db_app_user)]
GO


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
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
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
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
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
    if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0
					      and car_id = @p_car_id
						order by date_created desc))
	 update dbo.CCAR_CAR
		set car_state_id = null
	    where id = @p_car_id


  exec @v_error = dbo.uspVREP_WRH_ORDER_MASTER_Prepare
   @p_id							= @p_id
  ,@p_number						= @p_number
  ,@p_car_id						= @p_car_id
  ,@p_employee_recieve_id			= @p_employee_recieve_id
  ,@p_employee_head_id				= @p_employee_head_id
  ,@p_employee_worker_id			= @p_employee_worker_id
  ,@p_employee_output_worker_id		= @p_employee_output_worker_id
  ,@p_date_created					= @p_date_created
  ,@p_order_state					= @p_order_state
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

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
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
	,@p_order_state			varchar(20)
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
  ,@p_sys_comment			= @p_sys_comment			
  ,@p_sys_user				= @p_sys_user



return
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
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
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
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
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
    if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0
					      and car_id = @p_car_id
						order by date_created desc))
	 update dbo.CCAR_CAR
		set car_state_id = null
	    where id = @p_car_id


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

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
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
  ,@p_sys_comment			= @p_sys_comment			
  ,@p_sys_user				= @p_sys_user



return
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
			,wrh_order_master_type_sname, number
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
			,@p_wrh_order_master_type_sname, @p_number
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
			, sys_comment = @p_sys_comment
			, sys_user_modified = @p_sys_user
		where id	= @p_id


    
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


