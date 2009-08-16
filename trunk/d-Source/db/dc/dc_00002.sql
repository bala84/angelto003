:r ./../_define.sql
:setvar dc_number 00002
:setvar dc_description "CPRT_EMPLOYEE fix:EMPLOYEE_TYPE added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.02.2008 VLavrentiev  CPRT_EMPLOYEE fix:EMPLOYEE_TYPE added   
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVPRT_USER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CPRT_USER
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,username
		  ,password
      FROM dbo.CPRT_USER
	
)
GO

/*==============================================================*/
/* Table: CPRT_EMPLOYEE_TYPE                                    */
/*==============================================================*/
create table CPRT_EMPLOYEE_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cprt_employee_type_pk primary key (id)
         on $(db_name)_IDX
)
on $(db_name)_DAT
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица должностей работников',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Краткое название должности',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Полное название должности',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE_TYPE', 'column', 'full_name'
go

print ' '
print 'Adding column to cprt_employee'
go

alter table dbo.cprt_employee
add employee_type_id numeric(38,0) not null
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид должности',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'employee_type_id'
go

print ' '
print 'Adding ref to cprt_employee from employee_type'
go

alter table CPRT_EMPLOYEE
   add constraint CPRT_EMPLOYEE_EMP_TYPE_ID_FK foreign key (employee_type_id)
      references CPRT_EMPLOYEE_TYPE (id)
go

print ' '
print 'Altering person_id...'
go

alter table dbo.cprt_employee
alter column person_id numeric(38,0) not null
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

