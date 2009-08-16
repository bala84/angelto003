:r ./../_define.sql

:setvar dc_number 00149                  
:setvar dc_description "ts type and condition save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.03.2008 VLavrentiev  ts type and condition save fixed
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

alter table dbo.CCAR_TS_TYPE_MASTER
   drop constraint CCAR_TS_TYPE_MASTER_PARENT_ID_FK 
go

/*==============================================================*/
/* Index: i_parent_id_ccar_ts_type_master		        */
/*==============================================================*/
drop index dbo.CCAR_TS_TYPE_MASTER.i_parent_id_ccar_ts_type_master 
go


alter table dbo.CCAR_TS_TYPE_MASTER
drop column parent_id
go




/*==============================================================*/
/* Table: CCAR_TS_TYPE_RELATION                                 */
/*==============================================================*/
create table CCAR_TS_TYPE_RELATION (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   child_id             numeric(38,0)        not null,
   parent_id            numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица отношений видов ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид потомка',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'child_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид родителя',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_RELATION', 'column', 'parent_id'
go

alter table CCAR_TS_TYPE_RELATION
   add constraint ccar_ts_type_relation_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ccar_ts_type_rel_parent_id_ifk                        */
/*==============================================================*/
create index ccar_ts_type_rel_parent_id_ifk on CCAR_TS_TYPE_RELATION (
parent_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ccar_ts_type_rel_child_id_ifk                         */
/*==============================================================*/
create index ccar_ts_type_rel_child_id_ifk on CCAR_TS_TYPE_RELATION (
child_id ASC
)
on $(fg_idx_name)
go

alter table CCAR_TS_TYPE_RELATION
   add constraint CCAR_TS_TYPE_REL_CHILD_ID_FK foreign key (child_id)
      references CCAR_TS_TYPE_MASTER (id)
go

alter table CCAR_TS_TYPE_RELATION
   add constraint FK_CCAR_TS__CCAR_TS_T_CCAR_TS_ foreign key (parent_id)
      references CCAR_TS_TYPE_MASTER (id)
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

