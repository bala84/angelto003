:r ./../_define.sql

:setvar dc_number 00170                  
:setvar dc_description "wrh added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    10.04.2008 VLavrentiev  wrh added
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


alter table dbo.CCAR_TS_TYPE_DETAIL
drop constraint CCAR_TS_TYPE_DETAL_GD_CTGRY_ID_FK
go

drop table dbo.CWRH_GOOD_CATEGORY
go

/*==============================================================*/
/* Table: CCAR_REPAIR_TYPE_RELATION                             */
/*==============================================================*/
create table CCAR_REPAIR_TYPE_RELATION (
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
   'Таблица отношений видов ремонта',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид потомка',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'child_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид родителя',
   'user', @CurrentUser, 'table', 'CCAR_REPAIR_TYPE_RELATION', 'column', 'parent_id'
go

alter table CCAR_REPAIR_TYPE_RELATION
   add constraint ccar_repair_type_relation_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ccar_rep_type_rel_parent_id_ifk                       */
/*==============================================================*/
create index ccar_rep_type_rel_parent_id_ifk on CCAR_REPAIR_TYPE_RELATION (
parent_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ccar_rep_type_rel_child_id_ifk                        */
/*==============================================================*/
create index ccar_rep_type_rel_child_id_ifk on CCAR_REPAIR_TYPE_RELATION (
child_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Table: CCAR_TS_TYPE_ROUTE_DETAIL                             */
/*==============================================================*/
create table CCAR_TS_TYPE_ROUTE_DETAIL (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   ts_type_master_id    numeric(38,0)        not null,
   ordered              smallint                 not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица деталей маршрутов видов ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'ts_type_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Порядок',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_DETAIL', 'column', 'ordered'
go

alter table CCAR_TS_TYPE_ROUTE_DETAIL
   add constraint ccar_ts_type_route_d_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_ccar_ts_type_route_d_route_m                      */
/*==============================================================*/
create index ifk_ccar_ts_type_route_d_route_m on CCAR_TS_TYPE_ROUTE_DETAIL (
ts_type_master_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CCAR_TS_TYPE_ROUTE_MASTER                             */
/*==============================================================*/
create table CCAR_TS_TYPE_ROUTE_MASTER (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица мастер маршрутов ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_ROUTE_MASTER', 'column', 'full_name'
go

alter table CCAR_TS_TYPE_ROUTE_MASTER
   add constraint ccar_ts_type_route_master_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: u_short_name_ts_type_route_master                     */
/*==============================================================*/
create unique index u_short_name_ts_type_route_master on CCAR_TS_TYPE_ROUTE_MASTER (
short_name ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CRPR_REPAIR_TYPE                                      */
/*==============================================================*/
create table CRPR_REPAIR_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   code                 varchar(20)          not null,
   time_to_repair_in_minutes int                  not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица видов ремонта',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'full_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Код',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Время починки в минутах',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE', 'column', 'time_to_repair_in_minutes'
go

alter table CRPR_REPAIR_TYPE
   add constraint crpr_repair_type_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: u_short_name_repair_type                              */
/*==============================================================*/
create unique index u_short_name_repair_type on CRPR_REPAIR_TYPE (
short_name ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: i_code_repair_type                                    */
/*==============================================================*/
create index i_code_repair_type on CRPR_REPAIR_TYPE (
code ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CRPR_REPAIR_ZONE_DETAIL                               */
/*==============================================================*/
create table CRPR_REPAIR_ZONE_DETAIL (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   work_desc            varchar(2000)        not null,
   hour_amount          int                  not null,
   repair_zone_master_id numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Детальная таблица ремонтной зоны',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Наименование работ',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'work_desc'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество часов',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'hour_amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид ремонтной зоны',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_DETAIL', 'column', 'repair_zone_master_id'
go

alter table CRPR_REPAIR_ZONE_DETAIL
   add constraint crpr_rpr_zone_detail_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_rpr_zone_m_rpr_zone_d                             */
/*==============================================================*/
create index ifk_rpr_zone_m_rpr_zone_d on CRPR_REPAIR_ZONE_DETAIL (
repair_zone_master_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CRPR_REPAIR_ZONE_MASTER                               */
/*==============================================================*/
create table CRPR_REPAIR_ZONE_MASTER (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id               numeric(38,0)        not null,
   date_started         datetime             not null,
   date_ended           datetime             not null,
   repair_type_id       numeric(38,0)        not null,
   employee_h_id        numeric(38,0)        not null,
   employee_mech_id     numeric(38,0)        not null,
   malfunction_disc     varchar(4000)        null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица-мастер  ремонтной зоны',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата нач. ремонтных работ',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'date_started'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата оконч. ремонтных работ',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'date_ended'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ремонта',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'repair_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид бригадира ',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'employee_h_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид механика',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'employee_mech_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Обнаруженные неисправности',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_ZONE_MASTER', 'column', 'malfunction_disc'
go

alter table CRPR_REPAIR_ZONE_MASTER
   add constraint crpr_repair_zone_master_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_car_id_rpr_zone_m                                 */
/*==============================================================*/
create index ifk_car_id_rpr_zone_m on CRPR_REPAIR_ZONE_MASTER (
car_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_m_id_rpr_zone_m                          */
/*==============================================================*/
create index ifk_employee_m_id_rpr_zone_m on CRPR_REPAIR_ZONE_MASTER (
employee_mech_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_h_id_rpr_zone_m                          */
/*==============================================================*/
create index ifk_employee_h_id_rpr_zone_m on CRPR_REPAIR_ZONE_MASTER (
employee_h_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_repair_type_id_rpr_zone_m                         */
/*==============================================================*/
create index ifk_repair_type_id_rpr_zone_m on CRPR_REPAIR_ZONE_MASTER (
repair_type_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_GOOD_CATEGORY                                    */
/*==============================================================*/
create table CWRH_GOOD_CATEGORY (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   good_mark            varchar(30)          not null,
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   unit                 varchar(20)          not null,
   parent_id            numeric(38,0)        null,
   organization_id      numeric(38,0)        not null,
   good_category_type_id numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица категорий товаров',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Артикул',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'good_mark'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'full_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ед. измерения',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'unit'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид родительской записи',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'parent_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'organization_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа категории товара',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY', 'column', 'good_category_type_id'
go

alter table CWRH_GOOD_CATEGORY
   add constraint cwrh_good_category_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: u_good_mark_short_name_gd_ctgry                       */
/*==============================================================*/
create unique index u_good_mark_short_name_gd_ctgry on CWRH_GOOD_CATEGORY (
good_mark ASC,
short_name ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: i_parent_id_gd_ctgry                                  */
/*==============================================================*/
create index i_parent_id_gd_ctgry on CWRH_GOOD_CATEGORY (
parent_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_org_id_gd_ctgry                                   */
/*==============================================================*/
create index ifk_org_id_gd_ctgry on CWRH_GOOD_CATEGORY (
organization_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_type_id_gd_ctgry                         */
/*==============================================================*/
create index ifk_gd_ctgry_type_id_gd_ctgry on CWRH_GOOD_CATEGORY (
good_category_type_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_GOOD_CATEGORY_PRICE                              */
/*==============================================================*/
create table CWRH_GOOD_CATEGORY_PRICE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   good_category_id     numeric(38,0)        not null,
   price                decimal(18,9)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица цен на товары',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Цена',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_PRICE', 'column', 'price'
go

alter table CWRH_GOOD_CATEGORY_PRICE
   add constraint cwrh_good_ctgry_price_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_gd_ctgry_price                        */
/*==============================================================*/
create index ifk_gd_ctgry_id_gd_ctgry_price on CWRH_GOOD_CATEGORY_PRICE (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_GOOD_CATEGORY_TYPE                               */
/*==============================================================*/
create table CWRH_GOOD_CATEGORY_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)	     not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица типов категорий товаров',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CWRH_GOOD_CATEGORY_TYPE', 'column', 'full_name'
go

alter table CWRH_GOOD_CATEGORY_TYPE
   add constraint cwrh_good_category_type_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: u_good_mark_short_name_gd_ctgry_type                  */
/*==============================================================*/
create unique index u_good_mark_short_name_gd_ctgry_type on CWRH_GOOD_CATEGORY_TYPE (
short_name ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WAREHOUSE_ITEM                                   */
/*==============================================================*/
create table CWRH_WAREHOUSE_ITEM (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   warehouse_type_id    numeric(38,0)        not null,
   amount               int                  not null,
   good_category_id     numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица склада',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид склада',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'warehouse_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество товара',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_ITEM', 'column', 'good_category_id'
go

alter table CWRH_WAREHOUSE_ITEM
   add constraint cwrh_warehouse_item_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_item                              */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_item on CWRH_WAREHOUSE_ITEM (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_type_id_wrh_item                              */
/*==============================================================*/
create index ifk_wrh_type_id_wrh_item on CWRH_WAREHOUSE_ITEM (
warehouse_type_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WAREHOUSE_TYPE                                   */
/*==============================================================*/
create table CWRH_WAREHOUSE_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица справочника складов',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CWRH_WAREHOUSE_TYPE', 'column', 'full_name'
go

alter table CWRH_WAREHOUSE_TYPE
   add constraint cwrh_wrh_type_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: u_short_name_wrh_type                                 */
/*==============================================================*/
create unique index u_short_name_wrh_type on CWRH_WAREHOUSE_TYPE (
short_name ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WRH_DEMAND_DETAIL                                */
/*==============================================================*/
create table CWRH_WRH_DEMAND_DETAIL (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   wrh_demand_master_id numeric(38,0)        not null,
   good_category_id     numeric(38,0)        not null,
   amount               int                  not null,
   warehouse_type_id    numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Детальная таблица требования',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид мастер таблицы требования на склад',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'wrh_demand_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид склада',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_DETAIL', 'column', 'warehouse_type_id'
go

alter table CWRH_WRH_DEMAND_DETAIL
   add constraint cwrh_wrh_demand_detail_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_d_d                               */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_d_d on CWRH_WRH_DEMAND_DETAIL (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_demand_master_id_wrh_d_d                      */
/*==============================================================*/
create index ifk_wrh_demand_master_id_wrh_d_d on CWRH_WRH_DEMAND_DETAIL (
wrh_demand_master_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_type_id_wrh_d_d                               */
/*==============================================================*/
create index ifk_wrh_type_id_wrh_d_d on CWRH_WRH_DEMAND_DETAIL (
warehouse_type_id ASC
)
go

/*==============================================================*/
/* Table: CWRH_WRH_DEMAND_MASTER                                */
/*==============================================================*/
create table CWRH_WRH_DEMAND_MASTER (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id               numeric(38,0)        not null,
   number               varchar(20)          not null,
   date_created         datetime             not null,
   employee_recieve_id  numeric(38,0)        not null,
   employee_head_id     numeric(38,0)        not null,
   employee_worker_id   numeric(38,0)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица-мастер  требования',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер требования',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата требования',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника получателя',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'employee_recieve_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника бригадира',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'employee_head_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника кладовщика',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'employee_worker_id'
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint cwrh_wrh_demand_master_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_car_id_wrh_demand_m                               */
/*==============================================================*/
create index ifk_car_id_wrh_demand_m on CWRH_WRH_DEMAND_MASTER (
car_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_rec_id_wrh_demand_m                      */
/*==============================================================*/
create index ifk_employee_rec_id_wrh_demand_m on CWRH_WRH_DEMAND_MASTER (
employee_recieve_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_w_id_wrh_demand_m                        */
/*==============================================================*/
create index ifk_employee_w_id_wrh_demand_m on CWRH_WRH_DEMAND_MASTER (
employee_worker_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_h_id_wrh_demand                          */
/*==============================================================*/
create index ifk_employee_h_id_wrh_demand on CWRH_WRH_DEMAND_MASTER (
employee_head_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WRH_INCOME_DETAIL                                */
/*==============================================================*/
create table CWRH_WRH_INCOME_DETAIL (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   wrh_income_master_id numeric(38,0)        not null,
   good_category_id     numeric(38,0)        not null,
   good_category_price_id numeric(38,0)        not null,
   amount               int                  not null,
   total                decimal(18,9)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Детальная таблица прихода на склад',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид мастер таблицы прихода на склад',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'wrh_income_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид цены на товар',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'good_category_price_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Сумма',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_DETAIL', 'column', 'total'
go

alter table CWRH_WRH_INCOME_DETAIL
   add constraint cwrh_wrh_income_detail_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_price_id_wrh_income_d                    */
/*==============================================================*/
create index ifk_gd_ctgry_price_id_wrh_income_d on CWRH_WRH_INCOME_DETAIL (
good_category_price_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_income_d                          */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_income_d on CWRH_WRH_INCOME_DETAIL (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_income_master_id_wrh_i_d                      */
/*==============================================================*/
create index ifk_wrh_income_master_id_wrh_i_d on CWRH_WRH_INCOME_DETAIL (
wrh_income_master_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WRH_INCOME_MASTER                                */
/*==============================================================*/
create table CWRH_WRH_INCOME_MASTER (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   number               varchar(150)         not null,
   organization_id      numeric(38,0)        not null,
   warehouse_type_id    numeric(38,0)        not null,
   date_created         datetime             not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица-мастер прихода на склад',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер документа',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид поставщика',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'organization_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид склада',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'warehouse_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата поступления',
   'user', @CurrentUser, 'table', 'CWRH_WRH_INCOME_MASTER', 'column', 'date_created'
go

alter table CWRH_WRH_INCOME_MASTER
   add constraint cwrh_wrh_income_master_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_org_id_wrh_income                                 */
/*==============================================================*/
create index ifk_org_id_wrh_income on CWRH_WRH_INCOME_MASTER (
organization_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_type_id_wrh_income                            */
/*==============================================================*/
create index ifk_wrh_type_id_wrh_income on CWRH_WRH_INCOME_MASTER (
warehouse_type_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WRH_ORDER_DETAIL                                 */
/*==============================================================*/
create table CWRH_WRH_ORDER_DETAIL (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   wrh_order_master_id  numeric(38,0)        not null,
   good_category_id     numeric(38,0)        not null,
   amount               int                  not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Детальная таблица заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид мастер таблицы заказа-наряда на склад',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'wrh_order_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_DETAIL', 'column', 'amount'
go

alter table CWRH_WRH_ORDER_DETAIL
   add constraint cwrh_wrh_order_detail_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_o_d                               */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_o_d on CWRH_WRH_ORDER_DETAIL (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_wrh_order_master_id_wrh_o_d                       */
/*==============================================================*/
create index ifk_wrh_order_master_id_wrh_o_d on CWRH_WRH_ORDER_DETAIL (
wrh_order_master_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Table: CWRH_WRH_ORDER_MASTER                                 */
/*==============================================================*/
create table CWRH_WRH_ORDER_MASTER (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id               numeric(38,0)        not null,
   number               varchar(20)          not null,
   date_created         datetime             not null,
   employee_recieve_id  numeric(38,0)        not null,
   employee_head_id     numeric(38,0)        not null,
   employee_worker_id   numeric(38,0)        not null,
   order_state          smallint             not null,
   repair_type_id       numeric(38,0)        not null,
   malfunction_desc     varchar(4000)        not null
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица-мастер  заказа - наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника получателя',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'employee_recieve_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника бригадира',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'employee_head_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника механика',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'employee_worker_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Состояние заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'order_state'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ремонта',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'repair_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Перечень неисправностей',
   'user', @CurrentUser, 'table', 'CWRH_WRH_ORDER_MASTER', 'column', 'malfunction_desc'
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint cwrh_wrh_order_master_pk primary key (id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_car_id_wrh_order_m                                */
/*==============================================================*/
create index ifk_car_id_wrh_order_m on CWRH_WRH_ORDER_MASTER (
car_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_rec_id_wrh_order_m                       */
/*==============================================================*/
create index ifk_employee_rec_id_wrh_order_m on CWRH_WRH_ORDER_MASTER (
employee_recieve_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_repair_type_id_wrh_order_m                        */
/*==============================================================*/
create index ifk_repair_type_id_wrh_order_m on CWRH_WRH_ORDER_MASTER (
repair_type_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_w_id_wrh_order_m                         */
/*==============================================================*/
create index ifk_employee_w_id_wrh_order_m on CWRH_WRH_ORDER_MASTER (
employee_worker_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_employee_h_id_wrh_order                           */
/*==============================================================*/
create index ifk_employee_h_id_wrh_order on CWRH_WRH_ORDER_MASTER (
employee_head_id ASC
)
on "$(fg_idx_name)"
go

alter table CCAR_REPAIR_TYPE_RELATION
   add constraint CCAR_REP_TYPE_REL_CHILD_ID_REP_TYPE_FK foreign key (child_id)
      references CRPR_REPAIR_TYPE (id)
go

alter table CCAR_REPAIR_TYPE_RELATION
   add constraint CCAR_REP_TYPE_REL_PARENT_ID_REP_TYPE_FK foreign key (parent_id)
      references CRPR_REPAIR_TYPE (id)
go

alter table CCAR_TS_TYPE_ROUTE_DETAIL
   add constraint CCAR_TS_TYPE_R_D_R_M_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_ROUTE_MASTER (id)
go

alter table CRPR_REPAIR_ZONE_DETAIL
   add constraint CRPR_RPR_ZONE_D_RPR_ZONE_M_ID_FK foreign key (repair_zone_master_id)
      references CRPR_REPAIR_ZONE_MASTER (id)
go

alter table CRPR_REPAIR_ZONE_MASTER
   add constraint CRPR_RPR_ZONE_M_EMP_H_ID_FK foreign key (employee_h_id)
      references CPRT_EMPLOYEE (id)
go

alter table CRPR_REPAIR_ZONE_MASTER
   add constraint CRPR_RPR_ZONE_M_EMP_M_ID_FK foreign key (employee_mech_id)
      references CPRT_EMPLOYEE (id)
go

alter table CRPR_REPAIR_ZONE_MASTER
   add constraint CRPR_RPR_ZONE_M_RPR_TYPE_ID_FK foreign key (repair_type_id)
      references CRPR_REPAIR_TYPE (id)
go

alter table CRPR_REPAIR_ZONE_MASTER
   add constraint FK_CRPR_REP_REFERENCE_CCAR_CAR foreign key (id)
      references CCAR_CAR (id)
go

alter table CWRH_GOOD_CATEGORY
   add constraint CWRH_GD_CTGRY_GD_CTGRY_TYPE_ID_FK foreign key (good_category_type_id)
      references CWRH_GOOD_CATEGORY_TYPE (id)
go

alter table CWRH_GOOD_CATEGORY
   add constraint CWRH_GD_CTGRY_ID_FK foreign key (parent_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_GOOD_CATEGORY
   add constraint CWRH_GD_CTGRY_ORG_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

alter table CWRH_GOOD_CATEGORY_PRICE
   add constraint CWRH_GD_CTGRY_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_WAREHOUSE_ITEM
   add constraint CWRH_WRH_ITEM_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_WAREHOUSE_ITEM
   add constraint CWRH_WRH_ITEM_WRH_TYPE_ID_FK foreign key (warehouse_type_id)
      references CWRH_WAREHOUSE_TYPE (id)
go

alter table CWRH_WRH_DEMAND_DETAIL
   add constraint CWRH_WRH_DEMAND_D_DEMAND_M_ID_FK foreign key (wrh_demand_master_id)
      references CWRH_WRH_DEMAND_MASTER (id)
go

alter table CWRH_WRH_DEMAND_DETAIL
   add constraint CWRH_WRH_DEMAND_D_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_WRH_DEMAND_DETAIL
   add constraint CWRH_WRH_DEMAND_D_WRH_TYPE_ID_FK foreign key (warehouse_type_id)
      references CWRH_WAREHOUSE_TYPE (id)
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_EMP_W_ID_FK foreign key (employee_worker_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_M_CAR_ID_FK foreign key (car_id)
      references CCAR_CAR (id)
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_M_EMP_H_ID_FK foreign key (employee_head_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_M_EMP_R_ID_FK foreign key (employee_recieve_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_INCOME_DETAIL
   add constraint CWRH_WRH_INCOME_D_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_WRH_INCOME_DETAIL
   add constraint CWRH_WRH_INCOME_D_GD_PRICE_ID_FK foreign key (good_category_price_id)
      references CWRH_GOOD_CATEGORY_PRICE (id)
go

alter table CWRH_WRH_INCOME_DETAIL
   add constraint CWRH_WRH_INCOME_D_INCOME_M_ID_FK foreign key (wrh_income_master_id)
      references CWRH_WRH_INCOME_MASTER (id)
go

alter table CWRH_WRH_INCOME_MASTER
   add constraint CWRH_WRH_INCOME_M_ORG_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

alter table CWRH_WRH_INCOME_MASTER
   add constraint CWRH_WRH_INCOME_M_WRH_TYPE_ID_FK foreign key (warehouse_type_id)
      references CWRH_WAREHOUSE_TYPE (id)
go

alter table CWRH_WRH_ORDER_DETAIL
   add constraint CWRH_WRH_ORDER_D_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CWRH_WRH_ORDER_DETAIL
   add constraint CWRH_WRH_ORDER_D_ORDER_M_ID_FK foreign key (wrh_order_master_id)
      references CWRH_WRH_ORDER_MASTER (id)
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_CAR_ID_FK foreign key (car_id)
      references CCAR_CAR (id)
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_EMP_H_ID_FK foreign key (employee_head_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_EMP_ID_FK foreign key (employee_recieve_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_EMP_W_ID_FK foreign key (employee_worker_id)
      references CPRT_EMPLOYEE (id)
go

alter table CWRH_WRH_ORDER_MASTER
   add constraint CWRH_WRH_ORDER_M_REP_TYPE_ID_FK foreign key (repair_type_id)
      references CRPR_REPAIR_TYPE (id)
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
