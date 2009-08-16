:r ./../_define.sql

:setvar dc_number 00189
:setvar dc_description "ts_type_master fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    14.04.2008 VLavrentiev  ts_type_master fixed
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


drop index dbo.CRPR_REPAIR_TYPE_MASTER.u_short_name_repair_type
go

set identity_insert dbo.CRPR_REPAIR_TYPE_MASTER on
insert into dbo.CRPR_REPAIR_TYPE_MASTER (id, short_name, full_name, code, time_to_repair_in_minutes)
select id, short_name, full_name, '1000', 999999 from dbo.CCAR_TS_TYPE_MASTER
set identity_insert dbo.CRPR_REPAIR_TYPE_MASTER off

alter table dbo.CCAR_TS_TYPE_MASTER
add id2 numeric(38,0)
go

update dbo.CCAR_TS_TYPE_MASTER
set id2 = id
go

alter table dbo.CCAR_CONDITION
drop constraint CCAR_CNDTN_TS_TYPE_MASTER_ID_FK
go

alter table dbo.CCAR_TS_TYPE_RELATION
drop constraint CCAR_TS_TYPE_REL_CHILD_ID_FK
go

alter table dbo.CCAR_TS_TYPE_RELATION
drop constraint FK_CCAR_TS__CCAR_TS_T_CCAR_TS_
go


alter table dbo.CCAR_TS_TYPE_MASTER
drop constraint ccar_ts_type_master_pk
go

alter table dbo.CCAR_TS_TYPE_MASTER
drop column id
go

EXEC sp_rename 'CCAR_TS_TYPE_MASTER.id2', 'id', 'COLUMN'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'id'
go


alter table dbo.CCAR_TS_TYPE_MASTER
alter column id numeric(38,0) not null
go

alter table dbo.CCAR_TS_TYPE_MASTER
add constraint ccar_ts_type_master_pk
primary key (id)
on $(fg_idx_name)
go

alter table dbo.CCAR_CONDITION
add constraint CCAR_CNDTN_TS_TYPE_MASTER_ID_FK
foreign key (ts_type_master_id)
references dbo.CCAR_TS_TYPE_MASTER(id)
go

alter table dbo.CCAR_TS_TYPE_RELATION
add constraint CCAR_TS_TYPE_REL_CHILD_ID_FK
foreign key (child_id)
references dbo.CCAR_TS_TYPE_MASTER(id)
go

alter table dbo.CCAR_TS_TYPE_RELATION
add constraint CCAR_TS_TYPE_REL_PARENT_ID_FK
foreign key (parent_id)
references dbo.CCAR_TS_TYPE_MASTER(id)
go


alter table CCAR_TS_TYPE_MASTER
   add constraint CCAR_TS_TYPE_MASTER_ID_FK foreign key (id)
      references CRPR_REPAIR_TYPE_MASTER (id)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_short_name			varchar(30)
    ,@p_full_name			varchar(60)	  = null
	,@p_periodicity			int
	,@p_car_mark_id			numeric(38,0)
	,@p_car_model_id		numeric(38,0)
	,@p_tolerance			smallint	  = 0
	,@p_parent_id			numeric(38,0) = null
	,@p_child_ts_type_array xml			  = null
	,@p_code				varchar(20)	  = null
	,@p_time_to_repair_in_minutes int	  = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_code int


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

	 if (@p_tolerance is null)
	set @p_tolerance = 0
     if (@p_code is null)
	set @p_code = '1000' 
	 if (@p_time_to_repair_in_minutes is null)
	set @p_time_to_repair_in_minutes = 999999

     if (@@tranCount = 0)
      begin transaction 

  exec @v_error = 
		dbo.uspVRPR_REPAIR_TYPE_MASTER_SaveById
			 @p_id = @p_id out
			,@p_short_name = @p_short_name
			,@p_full_name = @p_full_name
			,@p_code = @p_code
			,@p_time_to_repair_in_minutes = @p_time_to_repair_in_minutes
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user


     if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


		  
    insert into
			     dbo.CCAR_TS_TYPE_MASTER 
            (id, short_name, full_name, periodicity, car_mark_id, car_model_id
			, tolerance, sys_comment, sys_user_created, sys_user_modified)
	select  @p_id, @p_short_name, @p_full_name, @p_periodicity, @p_car_mark_id, @p_car_model_id
			, @p_tolerance, @p_sys_comment, @p_sys_user, @p_sys_user
    where not exists
	(select 1 from dbo.CCAR_TS_TYPE_MASTER
		where id = @p_id)

 if (@@rowcount = 0)  
  -- надо править существующий
		update dbo.CCAR_TS_TYPE_MASTER set
		 short_name = @p_short_name
		,full_name = @p_full_name
		,periodicity = @p_periodicity
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,tolerance = @p_tolerance
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id

    if (@p_child_ts_type_array is not null)

	   insert into dbo.CCAR_TS_TYPE_RELATION
		(child_id, parent_id)
	   select ts_type_id.id.value('.','numeric(38,0)'), @p_id
		from @p_child_ts_type_array.nodes('/ts_type/id') 
			as ts_type_id(id)
		where not exists
			(select 1 from dbo.CCAR_TS_TYPE_RELATION as b
			  where ts_type_id.id.value('.','numeric(38,0)') 
					 = b.child_id
				and b.parent_id = @p_id)
		   


	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
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
	from dbo.CCAR_TS_TYPE_MASTER
	where id = @p_id

   exec @v_Error = 
		dbo.uspVRPR_REPAIR_TYPE_MASTER_DeleteById
			@p_id = @p_id	

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

