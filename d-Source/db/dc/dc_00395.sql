:r ./../_define.sql

:setvar dc_number 00395
:setvar dc_description "history fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.11.2008 VLavrentiev  history fix
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



declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'id'
go


EXEC sp_rename 'CHIS_ALL.row_id', 'row_id1', 'COLUMN'
go



alter table dbo.CHIS_ALL
add row_id2 numeric(38,0)
go


create index i_chis_all_row_id2 on dbo.CHIS_ALL(row_id2)
on $(fg_idx_name)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид строки (составное)',
   'user', @CurrentUser, 'table', 'CHIS_ALL', 'column', 'row_id2'
go



alter table dbo.CHIS_ALL
add row_id3 numeric(38,0)
go

create index i_chis_all_row_id3 on dbo.CHIS_ALL(row_id3)
on $(fg_idx_name)
go



declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид строки (составное)',
   'user', @CurrentUser, 'table', 'CHIS_ALL', 'column', 'row_id3'
go



alter table dbo.CHIS_ALL
add row_id4 numeric(38,0)
go

create index i_chis_all_row_id4 on dbo.CHIS_ALL(row_id4)
on $(fg_idx_name)
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид строки (составное)',
   'user', @CurrentUser, 'table', 'CHIS_ALL', 'column', 'row_id4'
go


alter table dbo.CHIS_ALL
add row_id5 numeric(38,0)
go

create index i_chis_all_row_id5 on dbo.CHIS_ALL(row_id5)
on $(fg_idx_name)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид строки (составное)',
   'user', @CurrentUser, 'table', 'CHIS_ALL', 'column', 'row_id5'
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspCHIS_ALL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить лог
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) out
    ,@p_tablename_id	 numeric(38,0)
	,@p_row_id1			 numeric(38,0) 
	,@p_row_id2			 numeric(38,0) = null
	,@p_row_id3			 numeric(38,0) = null
	,@p_row_id4			 numeric(38,0) = null
	,@p_row_id5			 numeric(38,0) = null
    ,@p_action			 smallint
	,@p_data			 xml
	,@p_party_id		 numeric(38,0)
	,@p_message_level_id smallint
	,@p_subsystem_id	 smallint
	,@p_date_created	 datetime
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
	 if (@p_party_id is null)
	set @p_party_id = dbo.usfConst('SYSTEM_PARTY')

if (@p_message_level_id != dbo.usfConst('NO_LOG_MESSAGE_LEVEL'))
 begin
       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CHIS_ALL 
            (tablename_id, row_id1, row_id2, row_id3, row_id4, row_id5, action, data, party_id, message_level_id, subsystem_id, date_created, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_tablename_id, @p_row_id1, @p_row_id2, @p_row_id3, @p_row_id4, @p_row_id5, @p_action, @p_data, @p_party_id, @p_message_level_id, @p_subsystem_id, @p_date_created, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
  else
  -- надо править существующий
		update dbo.CHIS_ALL set
		 tablename_id = @p_tablename_id
		,row_id1	  = @p_row_id1
		,row_id2	  = @p_row_id2
		,row_id3	  = @p_row_id3
		,row_id4	  = @p_row_id4
		,row_id5	  = @p_row_id5
		,action		  = @p_action
		,data		  = @p_data
		,party_id	  = @p_party_id
		,message_level_id = @p_message_level_id
		,subsystem_id	  = @p_subsystem_id
		,date_created = @p_date_created
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
 end
    
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

:r _add_chis_all_objects.sql
