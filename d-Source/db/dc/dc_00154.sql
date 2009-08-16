:r ./../_define.sql

:setvar dc_number 00154                  
:setvar dc_description "rep tables added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    01.04.2008 VLavrentiev  rep tables added
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
/* Table: CREP_CAR_DAY                                          */
/*==============================================================*/
create table CREP_CAR_DAY (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   month_created        datetime             not null,
   value_id             numeric(38,0)        not null,
   state_number         varchar(20)          not null,
   car_id               decimal(18,9)         not null,
   car_type_id          numeric(38,0)        not null,
   car_type_sname       varchar(30)          not null,
   car_state_id         numeric(38,0)        null,
   car_state_sname      varchar(30)          null,
   car_mark_id          numeric(38,0)        not null,
   car_mark_sname       varchar(30)          not null,
   car_model_id         numeric(38,0)        not null,
   car_model_sname      varchar(30)          not null,
   begin_mntnc_date     datetime             null,
   fuel_type_id         numeric(38,0)        not null,
   fuel_type_sname      varchar(30)          not null,
   car_kind_id          numeric(38,0)        not null,
   car_kind_sname       varchar(30)          not null,
   day_1                decimal(18,9)         not null default '0',
   day_2                decimal(18,9)         not null default '0',
   day_3                decimal(18,9)         not null default '0',
   day_4                decimal(18,9)         not null default '0',
   day_5                decimal(18,9)         not null default '0',
   day_6                decimal(18,9)         not null default '0',
   day_7                decimal(18,9)         not null default '0',
   day_8                decimal(18,9)         not null default '0',
   day_9                decimal(18,9)         not null default '0',
   day_10               decimal(18,9)         not null default '0',
   day_11               decimal(18,9)         not null default '0',
   day_12               decimal(18,9)         not null default '0',
   day_13               decimal(18,9)         not null default '0',
   day_14               decimal(18,9)         not null default '0',
   day_15               decimal(18,9)         not null default '0',
   day_16               decimal(18,9)         not null default '0',
   day_17               decimal(18,9)         not null default '0',
   day_18               decimal(18,9)         not null default '0',
   day_19               decimal(18,9)         not null default '0',
   day_20               decimal(18,9)         not null default '0',
   day_21               decimal(18,9)         not null default '0',
   day_22               decimal(18,9)         not null default '0',
   day_23               decimal(18,9)         not null default '0',
   day_24               decimal(18,9)         not null default '0',
   day_25               decimal(18,9)         not null default '0',
   day_26               decimal(18,9)         not null default '0',
   day_27               decimal(18,9)         not null default '0',
   day_28               decimal(18,9)         not null default '0',
   day_29               decimal(18,9)         not null default '0',
   day_30               decimal(18,9)         not null default '0',
   day_31               decimal(18,9)         not null default '0'
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица статистики автомобиля по дням в месяце',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Месяц создания записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'month_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид значения',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'value_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'state_number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Состояние автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_state_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_mark_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Марка автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_mark_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_model_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Модель автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_model_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата начала эксплуатации',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'begin_mntnc_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа используемого топлива',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'fuel_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип топлива автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'fuel_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_kind_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Вид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'car_kind_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_1'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_2'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_3'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_4'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_5'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_6'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_7'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_8'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_9'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_10'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_11'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_12'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_13'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_14'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_15'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_16'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_17'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_18'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_19'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_20'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_21'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_22'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_23'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_24'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_25'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_26'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_27'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_28'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_29'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_30'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на соответствующий день',
   'user', @CurrentUser, 'table', 'CREP_CAR_DAY', 'column', 'day_31'
go

alter table CREP_CAR_DAY
   add constraint crep_car_day_pk primary key (month_created, car_id, value_id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_state_number                           */
/*==============================================================*/
create index i_crep_car_day_state_number on CREP_CAR_DAY (
state_number ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_car_type_id                            */
/*==============================================================*/
create index i_crep_car_day_car_type_id on CREP_CAR_DAY (
car_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_car_state_id                           */
/*==============================================================*/
create index i_crep_car_day_car_state_id on CREP_CAR_DAY (
car_state_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_car_mark_id                            */
/*==============================================================*/
create index i_crep_car_day_car_mark_id on CREP_CAR_DAY (
car_mark_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_car_model_id                           */
/*==============================================================*/
create index i_crep_car_day_car_model_id on CREP_CAR_DAY (
car_model_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_fuel_type_id                           */
/*==============================================================*/
create index i_crep_car_day_fuel_type_id on CREP_CAR_DAY (
fuel_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_day_car_kind_id                            */
/*==============================================================*/
create index i_crep_car_day_car_kind_id on CREP_CAR_DAY (
car_kind_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Table: CREP_CAR_HOUR                                         */
/*==============================================================*/
create table CREP_CAR_HOUR (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   day_created          datetime             not null,
   value_id             numeric(38,0)        not null,
   state_number         varchar(20)          not null,
   car_id               decimal(18,9)         not null,
   car_type_id          numeric(38,0)        not null,
   car_type_sname       varchar(30)          not null,
   car_state_id         numeric(38,0)        null,
   car_state_sname      varchar(30)          null,
   car_mark_id          numeric(38,0)        not null,
   car_mark_sname       varchar(30)          not null,
   car_model_id         numeric(38,0)        not null,
   car_model_sname      varchar(30)          not null,
   begin_mntnc_date     datetime             null,
   fuel_type_id         numeric(38,0)        not null,
   fuel_type_sname      varchar(30)          not null,
   car_kind_id          numeric(38,0)        not null,
   car_kind_sname       varchar(30)          not null,
   hour_0               decimal(18,9)         not null default '0',
   hour_1               decimal(18,9)         not null default '0',
   hour_2               decimal(18,9)         not null default '0',
   hour_3               decimal(18,9)         not null default '0',
   hour_4               decimal(18,9)         not null default '0',
   hour_5               decimal(18,9)         not null default '0',
   hour_6               decimal(18,9)         not null default '0',
   hour_7               decimal(18,9)         not null default '0',
   hour_8               decimal(18,9)         not null default '0',
   hour_9               decimal(18,9)         not null default '0',
   hour_10              decimal(18,9)         not null default '0',
   hour_11              decimal(18,9)         not null default '0',
   hour_12              decimal(18,9)         not null default '0',
   hour_13              decimal(18,9)         not null default '0',
   hour_14              decimal(18,9)         not null default '0',
   hour_15              decimal(18,9)         not null default '0',
   hour_16              decimal(18,9)         not null default '0',
   hour_17              decimal(18,9)         not null default '0',
   hour_18              decimal(18,9)         not null default '0',
   hour_19              decimal(18,9)         not null default '0',
   hour_20              decimal(18,9)         not null default '0',
   hour_21              decimal(18,9)         not null default '0',
   hour_22              decimal(18,9)         not null default '0',
   hour_23              decimal(18,9)         not null default '0'
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица статистики автомобиля по часам в дне',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'День создания записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'day_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид значения',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'value_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'state_number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Состояние автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_state_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_mark_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Марка автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_mark_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_model_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Модель автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_model_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата начала эксплуатации',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'begin_mntnc_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа используемого топлива',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'fuel_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип топлива автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'fuel_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_kind_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Вид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'car_kind_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 0 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_0'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 1 час',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_1'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 2 часа',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_2'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 3 часа',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_3'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 4 часа',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_4'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 5 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_5'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 6 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_6'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 7 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_7'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 8 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_8'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 9 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_9'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 10 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_10'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 11 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_11'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 12 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_12'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 13 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_13'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 14 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_14'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 15 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_15'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 16 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_16'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 17 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_17'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 18 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_18'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 19 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_19'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 20 часов',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_20'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 21 час',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_21'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 22 часа',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_22'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на 23 часа',
   'user', @CurrentUser, 'table', 'CREP_CAR_HOUR', 'column', 'hour_23'
go

alter table CREP_CAR_HOUR
   add constraint crep_car_hour_pk primary key (day_created, car_id, value_id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_state_number                          */
/*==============================================================*/
create index i_crep_car_hour_state_number on CREP_CAR_HOUR (
state_number ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_car_type_id                           */
/*==============================================================*/
create index i_crep_car_hour_car_type_id on CREP_CAR_HOUR (
car_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_car_state_id                          */
/*==============================================================*/
create index i_crep_car_hour_car_state_id on CREP_CAR_HOUR (
car_state_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_car_mark_id                           */
/*==============================================================*/
create index i_crep_car_hour_car_mark_id on CREP_CAR_HOUR (
car_mark_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_car_model_id                          */
/*==============================================================*/
create index i_crep_car_hour_car_model_id on CREP_CAR_HOUR (
car_model_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_fuel_type_id                          */
/*==============================================================*/
create index i_crep_car_hour_fuel_type_id on CREP_CAR_HOUR (
fuel_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_hour_car_kind_id                           */
/*==============================================================*/
create index i_crep_car_hour_car_kind_id on CREP_CAR_HOUR (
car_kind_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Table: CREP_CAR_MONTH                                        */
/*==============================================================*/
create table CREP_CAR_MONTH (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   year_created         datetime             not null,
   value_id             numeric(38,0)        not null,
   state_number         varchar(20)          not null,
   car_id               decimal(18,9)         not null,
   car_type_id          numeric(38,0)        not null,
   car_type_sname       varchar(30)          not null,
   car_state_id         numeric(38,0)        null,
   car_state_sname      varchar(30)          null,
   car_mark_id          numeric(38,0)        not null,
   car_mark_sname       varchar(30)          not null,
   car_model_id         numeric(38,0)        not null,
   car_model_sname      varchar(30)          not null,
   begin_mntnc_date     datetime             null,
   fuel_type_id         numeric(38,0)        not null,
   fuel_type_sname      varchar(30)          not null,
   car_kind_id          numeric(38,0)        not null,
   car_kind_sname       varchar(30)          not null,
   month_1              decimal(18,9)         not null default '0',
   month_2              decimal(18,9)         not null default '0',
   month_3              decimal(18,9)         not null default '0',
   month_4              decimal(18,9)         not null default '0',
   month_5              decimal(18,9)         not null default '0',
   month_6              decimal(18,9)         not null default '0',
   month_7              decimal(18,9)         not null default '0',
   month_8              decimal(18,9)         not null default '0',
   month_9              decimal(18,9)         not null default '0',
   month_10             decimal(18,9)         not null default '0',
   month_11             decimal(18,9)         not null default '0',
   month_12             decimal(18,9)         not null default '0'
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица статистики автомобиля по месяцам в году',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'День создания записи',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'year_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид значения',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'value_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'state_number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Состояние автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_state_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_mark_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Марка автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_mark_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_model_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Модель автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_model_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата начала эксплуатации',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'begin_mntnc_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа используемого топлива',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'fuel_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип топлива автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'fuel_type_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид вида автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_kind_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Вид автомобиля',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'car_kind_sname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на январь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_1'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на февраль',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_2'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на март',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_3'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на апрель',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_4'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на май',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_5'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на июнь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_6'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на июль',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_7'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на август',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_8'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на сентябрь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_9'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на октябрь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_10'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на ноябрь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_11'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Значение на декабрь',
   'user', @CurrentUser, 'table', 'CREP_CAR_MONTH', 'column', 'month_12'
go

alter table CREP_CAR_MONTH
   add constraint crep_car_month_pk primary key (year_created, car_id, value_id)
      on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_state_number                         */
/*==============================================================*/
create index i_crep_car_month_state_number on CREP_CAR_MONTH (
state_number ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_car_type_id                          */
/*==============================================================*/
create index i_crep_car_month_car_type_id on CREP_CAR_MONTH (
car_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_car_state_id                         */
/*==============================================================*/
create index i_crep_car_month_car_state_id on CREP_CAR_MONTH (
car_state_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_car_mark_id                          */
/*==============================================================*/
create index i_crep_car_month_car_mark_id on CREP_CAR_MONTH (
car_mark_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_car_model_id                         */
/*==============================================================*/
create index i_crep_car_month_car_model_id on CREP_CAR_MONTH (
car_model_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_fuel_type_id                         */
/*==============================================================*/
create index i_crep_car_month_fuel_type_id on CREP_CAR_MONTH (
fuel_type_id ASC
)
on $(fg_idx_name)
go

/*==============================================================*/
/* Index: i_crep_car_month_car_kind_id                          */
/*==============================================================*/
create index i_crep_car_month_car_kind_id on CREP_CAR_MONTH (
car_kind_id ASC
)
on $(fg_idx_name)
go


/*==============================================================*/
/* Table: CREP_VALUE                                            */
/*==============================================================*/
create table CREP_VALUE (
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
   'Таблица значений для отчетов',
   'user', @CurrentUser, 'table', 'CREP_VALUE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CREP_VALUE', 'column', 'full_name'
go

alter table CREP_VALUE
   add constraint crep_value_pk primary key (id)
      on $(fg_idx_name)
go


/*==============================================================*/
/* Index: u_short_name_rep_value                                */
/*==============================================================*/
create unique index u_short_name_rep_value on CREP_VALUE (
short_name ASC
)
go

alter table CREP_CAR_DAY
   add constraint CREP_CAR_DAY_VALUE_ID_FK foreign key (value_id)
      references CREP_VALUE (id)
go

alter table CREP_CAR_HOUR
   add constraint CREP_CAR_HOUR_VALUE_ID_FK foreign key (value_id)
      references CREP_VALUE (id)
go

alter table CREP_CAR_MONTH
   add constraint CREP_CAR_MONTH_VALUE_ID_FK foreign key (value_id)
      references CREP_VALUE (id)
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

