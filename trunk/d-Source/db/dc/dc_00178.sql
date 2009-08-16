:r ./../_define.sql

:setvar dc_number 00178                  
:setvar dc_description "repair_type_detail added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    11.04.2008 VLavrentiev  repair_type_detail added
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


EXEC sp_rename 'dbo.CRPR_REPAIR_TYPE', 'CRPR_REPAIR_TYPE_MASTER';
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
on "$(fg_dat_name)"
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
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_wrh_o_d                               */
/*==============================================================*/
create index ifk_gd_ctgry_id_wrh_o_d on CRPR_REPAIR_TYPE_DETAIL (
good_category_id ASC
)
on "$(fg_idx_name)"
go

/*==============================================================*/
/* Index: ifk_rpr_type_master_id_rpr_type_d                     */
/*==============================================================*/
create index ifk_rpr_type_master_id_rpr_type_d on CRPR_REPAIR_TYPE_DETAIL (
repair_type_master_id ASC
)
on "$(fg_idx_name)"
go

alter table CRPR_REPAIR_TYPE_DETAIL
   add constraint CRPR_REPAIR_TYPE_D_REPAIR_TYPE_M_ID_FK foreign key (repair_type_master_id)
      references CRPR_REPAIR_TYPE_MASTER (id)
go


drop index dbo.CRPR_REPAIR_TYPE_DETAIL.ifk_gd_ctgry_id_wrh_o_d
go

/*==============================================================*/
/* Index: ifk_gd_ctgry_id_rpr_type_d                            */
/*==============================================================*/
create index ifk_gd_ctgry_id_rpr_type_d on CRPR_REPAIR_TYPE_DETAIL (
good_category_id ASC
)
on "$(fg_idx_name)"
go


alter table CRPR_REPAIR_TYPE_DETAIL
   add constraint CRPR_REPAIR_TYPE_D_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
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
