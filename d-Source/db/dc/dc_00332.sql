:r ./../_define.sql

:setvar dc_number 00332
:setvar dc_description "repair by car report table added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.06.2008 VLavrentiev  repair by car report table added
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

CREATE TABLE [dbo].[CREP_REPAIR_BY_CAR_DAY](
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
	[car_state_id] [numeric](38, 0) NULL,
	[car_state_sname] [varchar](30) NULL,
	[car_mark_id] [numeric](38, 0) NOT NULL,
	[car_mark_sname] [varchar](30) NOT NULL,
	[car_model_id] [numeric](38, 0) NOT NULL,
	[car_model_sname] [varchar](30) NOT NULL,
	[car_kind_id] [numeric](38, 0) NOT NULL,
	[car_kind_sname] [varchar](30) NOT NULL,
	[short_name] [varchar](30) NOT NULL,
	[repair_type_master_id] [numeric](38,0) NOT NULL,
	[organization_id] [numeric](38, 0) NOT NULL,
	[organization_sname] [varchar](30) NOT NULL,
	[amt] smallint NOT NULL,
 CONSTRAINT [CREP_REPAIR_BY_CAR_DAY_pk] PRIMARY KEY CLUSTERED 
(
	 car_id ASC
	,repair_type_master_id ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Гос номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'state_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа автомобия' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_state_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_state_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_model_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Модель автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_model_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'short_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество видов ремонтов по автомобилям' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'amt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'repair_type_master_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'organization_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'organization_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица количества ремонтов по автомобилям' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY'
go


create index i_date_created_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(date_created)
on $(fg_idx_name)
go

create index i_car_type_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(car_type_id)
on $(fg_idx_name)
go

create index i_car_state_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(car_state_id)
on $(fg_idx_name)
go

create index i_car_kind_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(car_kind_id)
on $(fg_idx_name)
go

create index i_car_mark_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(car_mark_id)
on $(fg_idx_name)
go


create index i_car_model_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(car_model_id)
on $(fg_idx_name)
go

create index i_organization_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(organization_id)
on $(fg_idx_name)
go



create index i_repair_type_master_id_rep_repair_by_car on dbo.CREP_REPAIR_BY_CAR_DAY(repair_type_master_id)
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
