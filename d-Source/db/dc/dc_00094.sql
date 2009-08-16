:r ./../_define.sql
:setvar dc_number 00094
:setvar dc_description "chis_history added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    06.03.2008 VLavrentiev  driver_list delete fix
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


/*==============================================================*/
/* Table: CHIS_CONDITION                                        */
/*==============================================================*/
create table CHIS_CONDITION (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id               numeric(38,0)        not null,
   ts_type_master_id    numeric(38,0)        null,
   employee_id          numeric(38,0)        null,
   run                  decimal		     not null,
   speedometer_start_indctn decimal          not null,
   speedometer_end_indctn   decimal          not null,
   last_run             decimal              not null,
   edit_state		char		     null,
   date_created         datetime             not null,
   action               smallint             not null,
   fuel_start_left	decimal		     not null,
   fuel_end_left 	decimal		     not null,
   last_ts_type_master_id numeric (38,0)     null
)
on "$(db_name)_dat"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица историй состояний автомобиля',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида ТО',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'ts_type_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид сотрудника',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'employee_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пробег',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'run'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Показание при выезде',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'speedometer_start_indctn'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Показание при въезде',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'speedometer_end_indctn'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Прошлый пробег',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'last_run'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Событие',
   'user', @CurrentUser, 'table', 'CHIS_CONDITION', 'column', 'action'
go

alter table CHIS_CONDITION
   add constraint chis_condition_pk primary key (id, date_created, action)
      on $(db_name)_idx
go

/*==============================================================*/
/* Index: i_run_chis_condition                                  */
/*==============================================================*/
create index i_run_chis_condition on CHIS_CONDITION (
run DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_car_id_chis_condition                               */
/*==============================================================*/
create index i_car_id_chis_condition on CHIS_CONDITION (
car_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_ts_type_master_id_chis_condition                    */
/*==============================================================*/
create index i_ts_type_master_id_chis_condition on CHIS_CONDITION (
ts_type_master_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_employee_id_chis_condition                          */
/*==============================================================*/
create index i_employee_id_chis_condition on CHIS_CONDITION (
employee_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_speedometer_start_indctn_chis_condition             */
/*==============================================================*/
create index i_speedometer_start_indctn_chis_condition on CHIS_CONDITION (
speedometer_start_indctn DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_speedometer_end_indctn_chis_condition               */
/*==============================================================*/
create index i_speedometer_end_indctn_chis_condition on CHIS_CONDITION (
speedometer_end_indctn DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_last_run_chis_condition                             */
/*==============================================================*/
create index i_last_run_chis_condition on CHIS_CONDITION (
last_run DESC
)
on "$(db_name)_IDX"
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
