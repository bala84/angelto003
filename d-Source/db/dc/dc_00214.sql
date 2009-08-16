:r ./../_define.sql

:setvar dc_number 00214
:setvar dc_description "month plan added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.05.2008 VLavrentiev  month plan added
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
/* Table: CDRV_MONTH_PLAN                                   */
/*==============================================================*/
create table CDRV_MONTH_PLAN (
   id					numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   month			datetime			 not null,
   day_1		        tinyint				 not null,
   day_2		        tinyint				 not null,
   day_3		        tinyint				 not null,
   day_4				tinyint				 not null,
   day_5		        tinyint				 not null,
   day_6		        tinyint				 not null,
   day_7		        tinyint				 not null,
   day_8		        tinyint				 not null,
   day_9		        tinyint				 not null,
   day_10				tinyint				 not null,
   day_11		        tinyint				 not null,
   day_12		        tinyint				 not null,
   day_13				tinyint				 not null,
   day_14		        tinyint				 not null,
   day_15		        tinyint				 not null,
   day_16		        tinyint				 not null,
   day_17		        tinyint				 not null,
   day_18		        tinyint				 not null,
   day_19		        tinyint				 not null,
   day_20		        tinyint				 not null,
   day_21		        tinyint				 not null,
   day_22		        tinyint				 not null,
   day_23		        tinyint				 not null,
   day_24		        tinyint				 not null,
   day_25		        tinyint				 not null,
   day_26				tinyint				 not null,
   day_27		        tinyint				 null,
   day_28		        tinyint				 null,
   day_29		        tinyint				 null,
   day_30		        tinyint				 null,
   day_31		        tinyint				 null,
   constraint cdrv_month_plan_pk primary key (id)
         on $(fg_idx_name)
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица плана выхода водителей на смену',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, изменивший запись',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Месяц плана',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'month'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на первый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_1'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на второй день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_2'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на третий день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_3'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на четвертый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_4'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на пятый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_5'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на шестой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_6'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на седьмой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_7'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на восьмой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_8'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на девятый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_9'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на десятый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_10'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на одинадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_11'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двенадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_12'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на тринадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_13'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на четырнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_14'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на пятнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_15'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на шестнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_16'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на семнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_17'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на восемнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_18'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на девятнадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_19'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_20'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать первый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_21'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать второй день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_22'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать третий день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_23'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать четвертый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_24'

go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать пятый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_25'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать шестой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_26'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать седьмой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_27'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать восьмой день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_28'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на двадцать девятый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_29'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на тридцатый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_30'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Данные о плане на тридцать первый день',
   'user', @CurrentUser, 'table', 'CDRV_MONTH_PLAN', 'column', 'day_31'
go



/*==============================================================*/
/* Table: CDRV_DRIVER_PLAN                                   */
/*==============================================================*/
create table CDRV_DRIVER_PLAN (
   id					numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   car_id				numeric(38,0)		 not null,
   time				datetime			 not null,
   employee1_id		    numeric(38,0)		 not null,
   employee2_id		    numeric(38,0)		 null,
   employee3_id		    numeric(38,0)		 null,
   employee4_id		    numeric(38,0)		 null,
   constraint cdrv_driver_plan_pk primary key (id)
         on $(fg_idx_name)
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица плана выхода водителей на смену в день'
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, изменивший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид машины',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'car_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Время выхода',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'time'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид первого водителя',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'employee1_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид второго водителя',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'employee2_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид третьего водителя',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'employee3_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид четвертого водителя',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_PLAN', 'column', 'employee4_id'
go

alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_CAR_ID_FK foreign key (car_id)
      references CCAR_CAR (id)
go


alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_EMPLOYEE1_ID_FK foreign key (employee1_id)
      references CPRT_EMPLOYEE (id)
go


alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_EMPLOYEE2_ID_FK foreign key (employee2_id)
      references CPRT_EMPLOYEE (id)
go



alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_EMPLOYEE3_ID_FK foreign key (employee3_id)
      references CPRT_EMPLOYEE (id)
go


alter table CDRV_DRIVER_PLAN
   add constraint CDRV_DRIVER_PLAN_EMPLOYEE4_ID_FK foreign key (employee4_id)
      references CPRT_EMPLOYEE (id)
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

