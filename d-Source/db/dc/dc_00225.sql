:r ./../_define.sql

:setvar dc_number 00225
:setvar dc_description "warehouse demand added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    07.05.2008 VLavrentiev  warehouse demand added
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
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CREP_WRH_DEMAND](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[wrh_demand_master_id] [numeric](38, 0) NOT NULL,
	[good_category_id] [numeric](38, 0) NOT NULL,
	[good_category_sname] [varchar] (30) NOT NULL,
	[amount] [int] NOT NULL,
	[warehouse_type_id] [numeric](38, 0) NOT NULL,
	[warehouse_type_sname] [varchar] (30) not null,
	[car_id] [numeric](38, 0) NULL,
	[state_number] [varchar] (20) null,
	[car_type_id] [numeric] (38,0) null,
	[car_mark_id] [numeric] (38,0) null,
	[car_model_id] [numeric] (38,0) null,
	[number] [varchar](20) NOT NULL,
	[date_created] [datetime] NOT NULL,
	[employee_recieve_id] [numeric](38, 0) NOT NULL,
	[employee_recieve_fio]	[varchar] (100) not null,
	[employee_head_id] [numeric](38, 0) NOT NULL,
    	[employee_head_fio]	[varchar] (100) not null,
	[employee_worker_id] [numeric](38, 0) NOT NULL,
    	[employee_worker_fio]	[varchar] (100) not null,
	[organization_recieve_id] [numeric](38, 0) NOT NULL,
	[organization_head_id] [numeric](38, 0) NOT NULL,
	[organization_worker_id] [numeric](38, 0) NOT NULL,
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
 CONSTRAINT [CREP_WRH_DEMAND_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид мастер таблицы требования на склад' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'wrh_demand_master_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид категории товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'good_category_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название категории товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'good_category_sname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'amount'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'warehouse_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'warehouse_type_sname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'state_number'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'car_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'car_mark_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'car_model_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'number'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид получателя требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_recieve_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО получателя требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_recieve_fio'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид разрешившего требование' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_head_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО разрешившего требование' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_head_fio'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид выдавшего товар по требованию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_worker_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО выдавшего товар по требованию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'employee_worker_fio'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации получившего товар по требованию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'organization_recieve_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации разрешившего товар по требованию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'organization_head_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации выдавшего товар по требованию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND', @level2type=N'COLUMN', @level2name=N'organization_worker_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица по требованиям' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WRH_DEMAND'
GO



create index i_date_created_crep_wrh_demand on dbo.CREP_WRH_DEMAND(date_created)
on $(fg_idx_name)
go

create index i_car_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(car_id)
on $(fg_idx_name)
go

create index i_wrh_type_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(warehouse_type_id)
on $(fg_idx_name)
go

create index i_car_type_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(car_type_id)
on $(fg_idx_name)
go

create index i_car_mark_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(car_mark_id)
on $(fg_idx_name)
go

create index i_car_model_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(car_model_id)
on $(fg_idx_name)
go

create index i_good_category_id_crep_wrh_demand on dbo.CREP_WRH_DEMAND(good_category_id)
on $(fg_idx_name)
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


