:r ./../_define.sql

:setvar dc_number 00309
:setvar dc_description "driver list report table added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.06.2008 VLavrentiev  driver list report table added
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
CREATE TABLE [dbo].[CREP_DRIVER_LIST](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[date_created] [datetime] NOT NULL,
	[car_id] [numeric](38, 0) NOT NULL,
	[state_number] [varchar](20) NOT NULL,
	[car_type_id] [numeric](38, 0) NOT NULL,
	[car_type_sname] [varchar](30) NOT NULL,
	[car_state_id] [numeric](38, 0) NOT NULL,
	[car_state_sname] [varchar](30) NOT NULL,
	[car_mark_id] [numeric](38, 0) NOT NULL,
	[car_mark_sname] [varchar](30) NOT NULL,
	[car_model_id] [numeric](38, 0) NOT NULL,
	[car_model_sname] [varchar](30) NOT NULL,
	[car_kind_id] [numeric](38, 0) NOT NULL,
	[car_kind_sname] [varchar](30) NOT NULL,
	[fact_start_duty] [datetime] NOT NULL,
	[fact_end_duty] [datetime] NOT NULL,
	[driver_list_state_id] [numeric](38, 0) NOT NULL,
	[driver_list_state_sname] [varchar](30) NOT NULL,
	[driver_list_type_id] [numeric](38, 0) NOT NULL,
	[driver_list_type_sname] [varchar](30) NOT NULL,
	[fuel_exp] [decimal](18, 9) NOT NULL DEFAULT ((0.0)),
	[fuel_type_id] [numeric](38, 0) NOT NULL,
	[fuel_type_sname] [varchar](30) NOT NULL,
	[organization_id] [numeric](38, 0) NOT NULL,
	[organization_sname] [varchar](30) NOT NULL,
	[employee1_id] [numeric](38, 0) NOT NULL,
	[fio_employee1] [varchar](256) NOT NULL,
	[speedometer_start_indctn] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[speedometer_end_indctn] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[fuel_start_left] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[fuel_end_left] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[fuel_gived] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[fuel_return] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[fuel_addtnl_exp] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[run] [decimal](18, 9) NOT NULL DEFAULT ((0.0)),
	[fuel_consumption] [decimal](18, 9) NULL DEFAULT ((0.0)),
	[number] [numeric](38, 0) NOT NULL,
	[id] [numeric](38, 0)  NOT NULL,
	[last_date_created] [datetime] NULL,
	[power_trailer_hour][decimal](18, 9) NULL DEFAULT ((0.0))
 CONSTRAINT [crep_driver_list_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) on $(fg_idx_name)
) ON $(fg_idx_name)

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Гос номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'state_number'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа автомобия' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_type_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_type_sname'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_state_id'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_state_sname'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_mark_id'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_mark_sname'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_model_id'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Модель автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_model_sname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_kind_id'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'car_kind_sname'
GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время выезда факт.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fact_start_duty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время въезда факт.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fact_end_duty'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния путевого листа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'driver_list_state_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название состояния путевого листа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'driver_list_state_sname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа путевого листа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'driver_list_type_id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа путевого листа' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'driver_list_type_sname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Расход топлива на 100км' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_exp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_type_sname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'organization_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'organization_sname'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид водителя 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'employee1_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название водителя 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fio_employee1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Показание спидометра при выезде' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'speedometer_start_indctn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Показание спидометра при въезде' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'speedometer_end_indctn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Остаток топлива при выезде' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_start_left'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Остаток топлива при въезде' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_end_left'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Выдано топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_gived'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Возврат топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_return'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дополнительный расход горючего' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_addtnl_exp'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пробег' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'run'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Расход топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'fuel_consumption'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер п/л' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Последняя дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST', @level2type=N'COLUMN',@level2name=N'last_date_created'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица путевых листов' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_DRIVER_LIST'
GO


create index i_car_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_id)
on $(fg_idx_name)
go

create index i_car_type_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_type_id)
on $(fg_idx_name)
go                                                                                                                                                                                                                                      

create index i_car_state_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_state_id)
on $(fg_idx_name)
go


create index i_car_mark_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_mark_id)
on $(fg_idx_name)
go


create index i_car_model_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_model_id)
on $(fg_idx_name)
go


create index i_car_kind_id_crep_driver_list on dbo.CREP_DRIVER_LIST(car_kind_id)
on $(fg_idx_name)
go


create index i_driver_list_state_id_crep_driver_list on dbo.CREP_DRIVER_LIST(driver_list_state_id)
on $(fg_idx_name)
go


create index i_driver_list_type_id_crep_driver_list on dbo.CREP_DRIVER_LIST(driver_list_type_id)
on $(fg_idx_name)
go


create index i_fuel_type_id_crep_driver_list on dbo.CREP_DRIVER_LIST(fuel_type_id)
on $(fg_idx_name)
go


create index i_organization_id_crep_driver_list on dbo.CREP_DRIVER_LIST(organization_id)
on $(fg_idx_name)
go


create index i_employee1_id_crep_driver_list on dbo.CREP_DRIVER_LIST(employee1_id)
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
