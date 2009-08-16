:r ./../_define.sql
:setvar dc_number 00008
:setvar dc_description "CCAR tables added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.02.2008 VLavrentiev  CCAR tables added   
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
/* Table: CCAR_CAR                                              */
/*==============================================================*/
create table CCAR_CAR (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   state_number         varchar(20)          not null,
   speedometer_idctn    decimal              not null default 0.0,
   car_type_id          numeric(38,0)        not null,
   car_state_id         numeric(38,0)        not null,
   car_mark_id          numeric(38,0)        not null,
   car_model_id         numeric(38,0)        not null,
   begin_mntnc_date     datetime             null,
   fuel_type_id         numeric(38,0)        not null,
   constraint ccar_car_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица автомобилей',
   'user', @CurrentUser, 'table', 'CCAR_CAR'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Название',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'state_number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Показание спидометра',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'speedometer_idctn'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'car_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид состояния автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'car_state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'car_mark_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'car_model_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата начала эксплуатации',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'begin_mntnc_date'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа используемого топлива',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'fuel_type_id'
go

/*==============================================================*/
/* Table: CCAR_CAR_MARK                                         */
/*==============================================================*/
create table CCAR_CAR_MARK (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint ccar_car_mark_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица марок автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MARK', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CCAR_CAR_MODEL                                        */
/*==============================================================*/
create table CCAR_CAR_MODEL (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   mark_id              numeric(38,0)        not null,
   constraint ccar_car_model_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица моделей автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'full_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид марки',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'mark_id'
go

/*==============================================================*/
/* Table: CCAR_CAR_STATE                                        */
/*==============================================================*/
create table CCAR_CAR_STATE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint ccar_car_state_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица состояний автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_STATE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CCAR_CAR_TYPE                                         */
/*==============================================================*/
create table CCAR_CAR_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint ccar_car_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица типов автомобилей',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_CAR_TYPE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CCAR_FUEL_TYPE                                        */
/*==============================================================*/
create table CCAR_FUEL_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint ccar_fuel_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица типов топлива',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'full_name'
go

alter table CCAR_CAR
   add constraint CCAR_CAR_FUEL_TYPE_ID_FK foreign key (fuel_type_id)
      references CCAR_FUEL_TYPE (id)
go

alter table CCAR_CAR
   add constraint CCAR_CAR_MARK_ID_FK foreign key (car_mark_id)
      references CCAR_CAR_MARK (id)
go

alter table CCAR_CAR
   add constraint CCAR_CAR_MODEL_ID_FK foreign key (car_model_id)
      references CCAR_CAR_MODEL (id)
go

alter table CCAR_CAR
   add constraint CCAR_CAR_STATE_ID_FK foreign key (car_state_id)
      references CCAR_CAR_STATE (id)
go

alter table CCAR_CAR
   add constraint CCAR_CAR_TYPE_ID_FK foreign key (car_type_id)
      references CCAR_CAR_TYPE (id)
go

alter table CCAR_CAR_MODEL
   add constraint CCAR_CAR_MODEL_MARK_ID_FK foreign key (mark_id)
      references CCAR_CAR_MARK (id)
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

