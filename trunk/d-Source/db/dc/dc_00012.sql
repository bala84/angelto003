:r ./../_define.sql
:setvar dc_number 00012
:setvar dc_description "CDRV tables added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.02.2008 VLavrentiev  CDRV tables added   
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

print ' '
print 'Adding tables...'
go


/*==============================================================*/
/* Table: CCAR_CONDITION                                        */
/*==============================================================*/
create table CCAR_CONDITION (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id               numeric(38,0)        not null,
   ts_type_master_id    numeric(38,0)        not null,
   employee_id          numeric(38,0)        not null,
   car_state_id         numeric(38,0)	     not null,
   car_type_id          numeric(38,0)        not null,
   run                  decimal		     not null default 0.0,
   constraint ccar_condition_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица состояний автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ТО',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'ts_type_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'employee_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'car_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'car_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пробег',
   'user', @CurrentUser, 'table', 'CCAR_CONDITION', 'column', 'run'
go

/*==============================================================*/
/* Table: CCAR_TS_TYPE_DETAIL                                   */
/*==============================================================*/
create table CCAR_TS_TYPE_DETAIL (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   ts_type_master_id    numeric(38,0)        not null,
   good_category_id     numeric(38,0)        not null,
   amount               smallint             not null,
   constraint ccar_ts_type_detail_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица видов ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'ts_type_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид категории товара',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'good_category_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_DETAIL', 'column', 'amount'
go

/*==============================================================*/
/* Table: CCAR_TS_TYPE_MASTER                                   */
/*==============================================================*/
create table CCAR_TS_TYPE_MASTER (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   periodicity          int                  not null,
   car_mark_id          numeric(38,0)        not null,
   car_model_id         numeric(38,0)        not null,
   tolerance            smallint             not null,
   constraint ccar_ts_type_master_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица видов ТО',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'full_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Периодичность',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'periodicity'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'car_mark_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'car_model_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Допуск',
   'user', @CurrentUser, 'table', 'CCAR_TS_TYPE_MASTER', 'column', 'tolerance'
go

/*==============================================================*/
/* Table: CDEV_DEVICE                                           */
/*==============================================================*/
create table CDEV_DEVICE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cdev_device_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица устройств',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CDEV_DEVICE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CDRV_CONTROL_TYPE                                     */
/*==============================================================*/
create table CDRV_CONTROL_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cdrv_control_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица типов контроля за путевым листом',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CDRV_CONTROL_TYPE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CDRV_DRIVER_CONTROL                                   */
/*==============================================================*/
create table CDRV_DRIVER_CONTROL (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   control_type_id      numeric(38,0)        not null,
   employee_id          numeric(38,0)        not null,
   driver_list_id       numeric(38,0)        not null,
   constraint cdrv_driver_control_pk primary key (control_type_id, employee_id, driver_list_id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица контроля за выездом/возвратом',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа контроля',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'control_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'employee_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_CONTROL', 'column', 'driver_list_id'
go

/*==============================================================*/
/* Table: CDRV_DRIVER_LIST                                      */
/*==============================================================*/
create table CDRV_DRIVER_LIST (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   date_created         datetime             not null,
   number               bigint               identity(1,1),
   car_id               numeric(38,0)        not null,
   fact_start_duty      datetime             not null,
   fact_end_duty        datetime             not null,
   driver_list_state_id numeric(38,0)        not null,
   driver_list_type_id  numeric(38,0)        not null,
   fuel_norm            decimal              not null default 0.0,
   fuel_exp             decimal              not null default 0.0,
   fuel_type_id         numeric(38,0)        not null,
   organization_id      numeric(38,0)        not null,
   employee1_id         numeric(38,0)        not null,
   employee2_id         numeric(38,0)        null,
   speedometer_start_indctn decimal              null default 0.0,
   speedometer_end_indctn decimal              null default 0.0,
   fuel_start_left      decimal              null default 0.0,
   fuel_end_left        decimal              null default 0.0,
   fuel_gived           decimal              null default 0.0,
   fuel_return          decimal              null default 0.0,
   run                  AS (speedometer_start_indctn - speedometer_end_indctn),
   fuel_consumption     AS (((fuel_start_left - fuel_end_left) + (fuel_gived - fuel_return)) + fuel_addtnl_exp),
   fuel_addtnl_exp      decimal              null default 0.0,
   constraint cdrv_driver_list_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица путевых листов',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Время выезда факт.',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fact_start_duty'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Время въезда факт.',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fact_end_duty'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'driver_list_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'driver_list_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Норма расхода топлива',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_norm'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Расход топлива на 100км',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_exp'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа топлива',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид организации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'organization_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид водителя 1',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'employee1_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид водителя 2',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'employee2_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Показание спидометра при выезде',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'speedometer_start_indctn'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Показание спидометра при въезде',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'speedometer_end_indctn'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Остаток топлива при выезде',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_start_left'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Остаток топлива при въезде',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_end_left'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Выдано топлива',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_gived'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Возврат топлива',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_return'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пробег',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'run'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Расход горючего',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_consumption'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дополнительный расход горючего',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_addtnl_exp'
go

/*==============================================================*/
/* Table: CDRV_DRIVER_LIST_STATE                                */
/*==============================================================*/
create table CDRV_DRIVER_LIST_STATE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cdrv_driver_list_state_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица состояний путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_STATE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CDRV_DRIVER_LIST_TYPE                                 */
/*==============================================================*/
create table CDRV_DRIVER_LIST_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cdrv_driver_list_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица типов путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST_TYPE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CDRV_TRAILER                                          */
/*==============================================================*/
create table CDRV_TRAILER (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   device_id            numeric(38,0)        not null,
   work_hour_amount     int                  not null,
   driver_list_id       numeric(38,0)        not null,
   constraint cdrv_trailer_pk primary key (device_id, driver_list_id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица дополнительных механизмов',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид устройства',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'device_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Количество проработанных часов',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'work_hour_amount'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид путевого листа',
   'user', @CurrentUser, 'table', 'CDRV_TRAILER', 'column', 'driver_list_id'
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
   constraint cwrh_good_category_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
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

alter table CCAR_CONDITION
   add constraint CCAR_CNDTN_CAR_STATE_ID_FK foreign key (car_state_id)
      references CCAR_CAR_STATE (id)
go

alter table CCAR_CONDITION
   add constraint CCAR_CNDTN_CAR_TYPE_ID_FK foreign key (car_type_id)
      references CCAR_CAR_TYPE (id)
go

alter table CCAR_CONDITION
   add constraint CCAR_CNDTN_EMPLOYEE_ID_FK foreign key (employee_id)
      references CPRT_EMPLOYEE (id)
go

alter table CCAR_CONDITION
   add constraint CCAR_CNDTN_TS_TYPE_MASTER_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
go

alter table CCAR_CONDITION
   add constraint CCAR_CONDITION_CAR_ID_FK foreign key (car_id)
      references CCAR_CAR (id)
go

alter table CCAR_TS_TYPE_DETAIL
   add constraint CCAR_TS_TYPE_DETAL_GD_CTGRY_ID_FK foreign key (good_category_id)
      references CWRH_GOOD_CATEGORY (id)
go

alter table CCAR_TS_TYPE_DETAIL
   add constraint CCAR_TS_TYPE_DETAL_MASTER_ID_FK foreign key (ts_type_master_id)
      references CCAR_TS_TYPE_MASTER (id)
go

alter table CCAR_TS_TYPE_MASTER
   add constraint CCAR_TS_TYPE_MASTER_CAR_MARK_ID_FK foreign key (car_mark_id)
      references CCAR_CAR_MARK (id)
go

alter table CCAR_TS_TYPE_MASTER
   add constraint CCAR_TS_TYPE_MASTER_CAR_MODEL_ID_FK foreign key (car_model_id)
      references CCAR_CAR_MODEL (id)
go

alter table CDRV_DRIVER_CONTROL
   add constraint CDRV_DRIVER_CONTROL_DRV_LIST_ID_FK foreign key (driver_list_id)
      references CDRV_DRIVER_LIST (id)
go

alter table CDRV_DRIVER_CONTROL
   add constraint CDRV_DRIVER_CONTROL_EMP_ID_FK foreign key (employee_id)
      references CPRT_EMPLOYEE (id)
go

alter table CDRV_DRIVER_CONTROL
   add constraint CDRV_DRV_CNTRL_TYPE_ID_FK foreign key (control_type_id)
      references CDRV_CONTROL_TYPE (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRIVER_LIST_CAR_ID_FK foreign key (car_id)
      references CCAR_CAR (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRIVER_LIST_EMP1_ID_FK foreign key (employee1_id)
      references CPRT_EMPLOYEE (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRIVER_LIST_EMP2_ID_FK foreign key (employee2_id)
      references CPRT_EMPLOYEE (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRIVER_LIST_ORG_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRIVER_LIST_TYPE_ID_FK foreign key (driver_list_type_id)
      references CDRV_DRIVER_LIST_TYPE (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRV_LIST_FUEL_TYPE_ID_FK foreign key (fuel_type_id)
      references CCAR_FUEL_TYPE (id)
go

alter table CDRV_DRIVER_LIST
   add constraint CDRV_DRV_LIST_STATE_ID_FK foreign key (driver_list_state_id)
      references CDRV_DRIVER_LIST_STATE (id)
go

alter table CDRV_TRAILER
   add constraint CDRV_TRAILER_DEVICE_ID_FK foreign key (device_id)
      references CDEV_DEVICE (id)
go

alter table CDRV_TRAILER
   add constraint CDRV_TRAILER_DRIVER_LIST_ID_FK foreign key (driver_list_id)
      references CDRV_DRIVER_LIST (id)
go

alter table CWRH_GOOD_CATEGORY
   add constraint CWRH_GD_CTGRY_ID_FK foreign key (parent_id)
      references CWRH_GOOD_CATEGORY (id)
go


alter table dbo.CDRV_DRIVER_LIST
drop column run
go

alter table dbo.CDRV_DRIVER_LIST
add run decimal default 0.0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пробег',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'run'
go


alter table dbo.CDRV_DRIVER_LIST
drop column fuel_consumption
go

alter table dbo.CDRV_DRIVER_LIST
add fuel_consumption decimal default 0.0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Расход топлива',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'fuel_consumption'
go


alter table dbo.CCAR_CONDITION
alter column ts_type_master_id numeric(38,0) null
go

alter table dbo.CCAR_CONDITION
   drop constraint CCAR_CNDTN_CAR_STATE_ID_FK
go


alter table dbo.CCAR_CONDITION
drop column car_state_id
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



