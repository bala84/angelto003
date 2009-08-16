:r ./../_define.sql

:setvar dc_number 00236
:setvar dc_description "income fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.05.2008 VLavrentiev  income fixed
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

alter table dbo.CWRH_WRH_INCOME_MASTER
add organization_recieve_id numeric(38,0)
go


create index ifk_organization_recieve_id_wrh_income_master on dbo.CWRH_WRH_INCOME_MASTER(organization_recieve_id)
on $(fg_idx_name)
go

alter table CWRH_WRH_INCOME_MASTER
   add constraint CWRH_WRH_INCOME_MASTER_ORGANIZATON_RECIEVE_ID_FK foreign key (organization_recieve_id)
      references CPRT_ORGANIZATION (id)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации - получившей товар',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'organization_recieve_id'
go



alter table dbo.CWRH_WRH_DEMAND_MASTER
add organization_giver_id numeric(38,0)
go


create index ifk_organization_giver_id_wrh_demand_master on dbo.CWRH_WRH_DEMAND_MASTER(organization_giver_id)
on $(fg_idx_name)
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_MASTER_ORGANIZATON_giver_ID_FK foreign key (organization_giver_id)
      references CPRT_ORGANIZATION (id)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации - выдавшей товар',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'organization_giver_id'
go


alter table dbo.CREP_WRH_DEMAND
add organization_giver_id numeric(38,0)
go


create index ifk_organization_giver_id_rep_wrh_demand on dbo.CREP_WRH_DEMAND(organization_giver_id)
on $(fg_idx_name)
go



declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации - выдавшей товар',
   'user', @CurrentUser, 'table', 'CREP_WRH_DEMAND', 'column', 'organization_giver_id'
go


alter table dbo.CREP_WRH_DEMAND
add organization_giver_sname varchar(30)
go




declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Название организации - выдавшей товар',
   'user', @CurrentUser, 'table', 'CREP_WRH_DEMAND', 'column', 'organization_giver_sname'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения приходных документов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,warehouse_type_id
		  ,date_created
		  ,organization_recieve_id
		  ,total
      FROM dbo.CWRH_WRH_INCOME_MASTER
	
)
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,warehouse_type_id
		  ,organization_recieve_id	
		  ,date_created
		  ,total
	FROM dbo.utfVWRH_WRH_INCOME_MASTER()

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById]
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
    ,@p_number				varchar(150)
	,@p_organization_id		numeric(38,0)
    ,@p_warehouse_type_id   numeric(38,0)
	,@p_date_created		datetime
	,@p_total				decimal(18,9)
	,@p_organization_recieve_id numeric(38,0)
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
			     dbo.CWRH_WRH_INCOME_MASTER 
            ( number, organization_id
			, warehouse_type_id
			, date_created, total, organization_recieve_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_number, @p_organization_id
			, @p_warehouse_type_id
			, @p_date_created, @p_total, @p_organization_recieve_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_MASTER set
		 number = @p_number
	    ,organization_id = @p_organization_id
		,warehouse_type_id = @p_warehouse_type_id
		,date_created = @p_date_created
		,total = @p_total
		,organization_recieve_id = @p_organization_recieve_id
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

ALTER FUNCTION [dbo].[utfVWRH_WRH_DEMAND_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую функцию
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
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. '+ substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
		  ,a.date_created
		  ,a.wrh_demand_master_type_id
		  ,e.short_name as wrh_demand_master_type_sname	
		  ,a.organization_giver_id
		  ,h.name as organization_giver_sname		
      FROM dbo.CWRH_WRH_DEMAND_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CPRT_EMPLOYEE as b2
			on a.employee_head_id = b2.id
		join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		join dbo.CPRT_EMPLOYEE as b3
			on a.employee_worker_id = b3.id
		join dbo.CPRT_PERSON as c3
			on b3.person_id = c3.id
		left outer join dbo.CCAR_CAR as d
			on a.car_id = d.id
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CWRH_WRH_DEMAND_MASTER_TYPE as e
			on a.wrh_demand_master_type_id = e.id
		left outer join dbo.CPRT_ORGANIZATION as h
			on a.organization_giver_id = h.id
	  WHERE a.date_created between @p_start_date
							   and @p_end_date
		
		
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о требованиях
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
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
		  ,number
		  ,employee_recieve_id
		  ,FIO_employee_recieve
		  ,employee_head_id
		  ,FIO_employee_head 
		  ,employee_worker_id
		  ,FIO_employee_worker
		  ,date_created
		  ,wrh_demand_master_type_id
		  ,wrh_demand_master_type_sname
		  ,organization_giver_id
		  ,organization_giver_sname
	FROM dbo.utfVWRH_WRH_DEMAND_MASTER(@p_start_date, @p_end_date)
	order by date_created desc

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для склада
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
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
	,@p_wrh_demand_master_type_id numeric(38,0) = null
	,@p_organization_giver_id	numeric(38,0)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	 declare
		 @v_number varchar(20)
		,@v_Error int
        ,@v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

       -- надо добавлять
  if (@p_id is null)
    begin

      if (@@tranCount = 0)
        begin transaction  

		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_DEMAND_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number
	
	   insert into
			     dbo.CWRH_WRH_DEMAND_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id
			, employee_worker_id, wrh_demand_master_type_id, organization_giver_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @v_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id, @p_wrh_demand_master_type_id, @p_organization_giver_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
		,organization_giver_id = @p_organization_giver_id
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
	,@p_organization_giver_id	numeric(38,0)
	,@p_organization_giver_sname varchar(30)
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
			,organization_head_id, organization_worker_id, organization_giver_id, organization_giver_sname
			, sys_comment, sys_user_created, sys_user_modified)
	select   @p_wrh_demand_master_id, @p_wrh_demand_detail_id, @p_good_category_id, @p_good_category_sname
			,@p_amount, @p_warehouse_type_id, @p_warehouse_type_sname, @p_car_id
			,@p_state_number, @p_car_type_id, @p_car_kind_id, @p_car_mark_id, @p_car_model_id
			,@p_number, @p_date_created, @p_employee_recieve_id, @p_employee_recieve_fio
			,@p_employee_head_id, @p_employee_head_fio, @p_employee_worker_id
			,@p_employee_worker_fio, @p_organization_recieve_id, @p_wrh_demand_master_type_id
			,@p_organization_head_id, @p_organization_worker_id, @p_organization_giver_id, @p_organization_giver_sname
			, @p_sys_comment, @p_sys_user, @p_sys_user 
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
			,organization_giver_id	= @p_organization_giver_id
			,organization_giver_sname = @p_organization_giver_sname
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
	  ,@v_organization_giver_id	numeric(38,0)
	  ,@v_organization_giver_sname varchar(30)
	  ,@v_Error int

  select @v_number = number 
		,@v_car_id = car_id
		,@v_date_created = date_created
		,@v_employee_recieve_id = employee_recieve_id
		,@v_employee_head_id = employee_head_id
		,@v_employee_worker_id = employee_worker_id
		,@v_wrh_demand_master_type_id = wrh_demand_master_type_id
		,@v_organization_giver_id = organization_giver_id
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

  select @v_organization_giver_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @v_organization_giver_id

	
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
	,@p_organization_giver_id   = @v_organization_giver_id
	,@p_organization_giver_sname	= @v_organization_giver_sname
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




