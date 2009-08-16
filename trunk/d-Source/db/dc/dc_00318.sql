:r ./../_define.sql

:setvar dc_number 00318
:setvar dc_description "rep wrh order added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.06.2008 VLavrentiev  rep wrh order added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CREP_WRH_ORDER_MASTER](
	[id] [numeric](38, 0) not null,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	 state_number varchar(20) not null,
	 car_type_id numeric(38,0) not null,
	 car_type_sname varchar(30) not null,
     car_state_id numeric(38,0) not null,
     car_state_sname  varchar(30) not null,
	 car_mark_id  numeric(38,0) not null,
	 car_mark_sname   varchar(30) not null,
     car_model_id numeric(38,0) not null,
	 car_model_sname  varchar(30) not null,
     car_kind_id  numeric(38,0) not null,
	 car_kind_sname   varchar(30) not null,
	[number] [varchar](20) NOT NULL,
	[date_created] [datetime] NOT NULL,
	[employee_recieve_id] [numeric](38, 0) NULL,
    [fio_employee_recieve] [varchar](256) NULL,
	[employee_head_id] [numeric](38, 0) NULL,
    [fio_employee_head] [varchar](256) NULL,
	[employee_worker_id] [numeric](38, 0) NULL,
	[fio_employee_worker] [varchar](256) NULL,
	[order_state] [smallint] NOT NULL,
	[repair_type_id] [numeric](38, 0) NULL,
	[malfunction_desc] [varchar](4000) NOT NULL,
	[repair_zone_master_id] [numeric](38, 0) NULL,
	[date_started] datetime NULL,
	[date_ended] datetime NULL,
	[malfunction_disc] [varchar] (4000) NULL,
	[employee_output_worker_id] [numeric](38, 0) NULL,
    [fio_employee_output_worker] [varchar](256) NULL,
	[wrh_order_master_type_id] [numeric](38, 0) NULL,
	[wrh_order_master_type_sname] [varchar](30) NULL
 CONSTRAINT [CREP_WRH_ORDER_MASTER_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [$(fg_dat_name)]
) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'№ СТП' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'state_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_state_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Состояние автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_state_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_mark_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Марка автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_mark_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_model_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Модель автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_model_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_kind_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Вид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'car_kind_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер заказа-наряда' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата заказа-наряда' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сотрудника получателя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'employee_recieve_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО сотрудника получателя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'fio_employee_recieve'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сотрудника бригадира' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'employee_head_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО сотрудника бригадира' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'fio_employee_head'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сотрудника механика' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'employee_worker_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО сотрудника механика' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'fio_employee_worker'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Состояние заказа-наряда' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'order_state'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'repair_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Перечень неисправностей' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'malfunction_desc'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид ремонтной зоны' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'repair_zone_master_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата начала ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'date_started'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата окончания ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'date_ended'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид выпускающего механика' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'employee_output_worker_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ФИО выпускающего механика' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'fio_employee_output_worker'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа заказа-наряда' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'wrh_order_master_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа заказа-наряда' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER', @level2type=N'COLUMN',@level2name=N'wrh_order_master_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица для отчета по  заказам - нарядам' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_WRH_ORDER_MASTER'
GO


create index ifk_car_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_id)
on $(fg_idx_name)
go

create index ifk_car_type_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_type_id)
on $(fg_idx_name)
go


create index ifk_car_state_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_state_id)
on $(fg_idx_name)
go


create index ifk_car_mark_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_mark_id)
on $(fg_idx_name)
go



create index ifk_car_model_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_model_id)
on $(fg_idx_name)
go



create index ifk_car_kind_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(car_kind_id)
on $(fg_idx_name)
go



create index ifk_employee_recieve_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(employee_recieve_id)
on $(fg_idx_name)
go



create index ifk_employee_head_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(employee_head_id)
on $(fg_idx_name)
go



create index ifk_employee_worker_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(employee_worker_id)
on $(fg_idx_name)
go



create index ifk_repair_zone_master_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(repair_zone_master_id)
on $(fg_idx_name)
go



create index ifk_employee_output_worker_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(employee_output_worker_id)
on $(fg_idx_name)
go



create index ifk_wrh_order_master_type_id_crep_wrh_order_master on dbo.CREP_WRH_ORDER_MASTER(wrh_order_master_type_id)
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


