:r ./../_define.sql

:setvar dc_number 00199
:setvar dc_description "order_m_demand_m added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    15.04.2008 VLavrentiev  order_m_demand_m added
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
/* Table: CWRH_ORDER_MASTER_DEMAND_MASTER                                        */
/*==============================================================*/
create table CWRH_ORDER_MASTER_DEMAND_MASTER (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   wrh_order_master_id  numeric(38,0)          not null,
   wrh_demand_master_id numeric(38,0)          not null,
   constraint order_master_demand_master_pk primary key (wrh_demand_master_id, wrh_order_master_id)
         on $(fg_idx_name)
)
on "$(fg_dat_name)"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица связей заказов-нарядов и требований',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER'
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'wrh_order_master_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид требования',
   'user', @CurrentUser, 'table', 'CWRH_ORDER_MASTER_DEMAND_MASTER', 'column', 'wrh_demand_master_id'
go


alter table CWRH_ORDER_MASTER_DEMAND_MASTER
   add constraint CWRH_ORDER_M_DEMAND_M_ORDER_M_ID_FK foreign key (wrh_order_master_id)
      references CWRH_WRH_ORDER_MASTER (id)
go



alter table CWRH_ORDER_MASTER_DEMAND_MASTER
   add constraint CWRH_ORDER_M_DEMAND_M_DEMAND_M_ID_FK foreign key (wrh_demand_master_id)
      references CWRH_WRH_DEMAND_MASTER (id)
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

