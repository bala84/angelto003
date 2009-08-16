/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2005                    */
/* Created on:     11.04.2008 13:36:55                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CRPR_REPAIR_TYPE_DETAIL') and o.name = 'CRPR_REPAIR_TYPE_D_REPAIR_TYPE_M_ID_FK')
alter table CRPR_REPAIR_TYPE_DETAIL
   drop constraint CRPR_REPAIR_TYPE_D_REPAIR_TYPE_M_ID_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CRPR_REPAIR_TYPE_DETAIL')
            and   name  = 'ifk_rpr_type_master_id_rpr_type_d'
            and   indid > 0
            and   indid < 255)
   drop index CRPR_REPAIR_TYPE_DETAIL.ifk_rpr_type_master_id_rpr_type_d
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CRPR_REPAIR_TYPE_DETAIL')
            and   name  = 'ifk_gd_ctgry_id_wrh_o_d'
            and   indid > 0
            and   indid < 255)
   drop index CRPR_REPAIR_TYPE_DETAIL.ifk_gd_ctgry_id_wrh_o_d
go

alter table CRPR_REPAIR_TYPE_DETAIL
   drop constraint crpr_repair_type_detail_pk
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CRPR_REPAIR_TYPE_DETAIL')
            and   type = 'U')
   drop table CRPR_REPAIR_TYPE_DETAIL
go

/*==============================================================*/
/* Table: CRPR_REPAIR_TYPE_DETAIL                               */
/*==============================================================*/
create table CRPR_REPAIR_TYPE_DETAIL (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   repair_type_master_id numeric(38,0)        not null,
   good_category_id     numeric(38,0)        not null,
   amount               int                  not null
)
on "DEFAULT_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Детальная таблица видов ремонта',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид мастер таблицы вида ремонта',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'repair_type_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество',
   'user', @CurrentUser, 'table', 'CRPR_REPAIR_TYPE_DETAIL', 'column', 'amount'
go

alter table CRPR_REPAIR_TYPE_DETAIL
   add constraint crpr_repair_type_detail_pk primary key (id)
      on DEFAULT_IDX
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_o_d                               */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_o_d on CRPR_REPAIR_TYPE_DETAIL (
good_category_id ASC
)
on "DEFAULT"
go

/*==============================================================*/
/* Index: ifk_rpr_type_master_id_rpr_type_d                     */
/*==============================================================*/
create index ifk_rpr_type_master_id_rpr_type_d on CRPR_REPAIR_TYPE_DETAIL (
repair_type_master_id ASC
)
on "DEFAULT"
go

alter table CRPR_REPAIR_TYPE_DETAIL
   add constraint CRPR_REPAIR_TYPE_D_REPAIR_TYPE_M_ID_FK foreign key (repair_type_master_id)
      references CRPR_REPAIR_TYPE_MASTER (id)
go

