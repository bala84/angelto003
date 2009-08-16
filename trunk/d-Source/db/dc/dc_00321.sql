:r ./../_define.sql

:setvar dc_number 00321
:setvar dc_description "repair time day added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.06.2008 VLavrentiev  repair time day added
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
CREATE TABLE [dbo].[CREP_CAR_REPAIR_TIME_DAY](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[month_created] [datetime] NOT NULL,
	[value_id] [numeric](38, 0) NOT NULL,
	[state_number] [varchar](20) NOT NULL,
	[car_id] [numeric](38, 0) NOT NULL,
	[car_type_id] [numeric](38, 0) NOT NULL,
	[car_type_sname] [varchar](30) NOT NULL,
	[car_state_id] [numeric](38, 0) NULL,
	[car_state_sname] [varchar](30) NULL,
	[car_mark_id] [numeric](38, 0) NOT NULL,
	[car_mark_sname] [varchar](30) NOT NULL,
	[car_model_id] [numeric](38, 0) NOT NULL,
	[car_model_sname] [varchar](30) NOT NULL,
	[begin_mntnc_date] [datetime] NULL,
	[fuel_type_id] [numeric](38, 0) NOT NULL,
	[fuel_type_sname] [varchar](30) NOT NULL,
	[car_kind_id] [numeric](38, 0) NOT NULL,
	[car_kind_sname] [varchar](30) NOT NULL,
	[day_1] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_2] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_3] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_4] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_5] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_6] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_7] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_8] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_9] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_10] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_11] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_12] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_13] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_14] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_15] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_16] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_17] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_18] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_19] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_20] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_21] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_22] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_23] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_24] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_25] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_26] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_27] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_28] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_29] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_30] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[day_31] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[organization_id] [numeric](38, 0) NULL,
	[organization_sname] [varchar](30) NULL
 CONSTRAINT [CREP_CAR_REPAIR_TIME_DAY_pk] PRIMARY KEY CLUSTERED 
(
	[month_created] ASC,
	[car_id] ASC,
	[value_id] ASC
) ON [$(fg_dat_name)]
) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Месяц создания записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'month_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид значения' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'value_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'state_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_state_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Состояние автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_state_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Марка автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_model_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Модель автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_model_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата начала эксплуатации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'begin_mntnc_date'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа используемого топлива' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'fuel_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип топлива автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'fuel_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Вид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_6'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_7'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_8'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_9'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_10'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_11'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_12'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_13'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_14'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_15'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_16'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_17'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_18'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_19'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_20'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_21'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_22'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_23'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_24'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_25'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_26'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_27'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_28'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_29'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_30'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'day_31'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'organization_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY', @level2type=N'COLUMN',@level2name=N'organization_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица статистики автомобиля по дням в месяце' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_CAR_REPAIR_TIME_DAY'
GO
ALTER TABLE [dbo].[CREP_CAR_REPAIR_TIME_DAY]  WITH CHECK ADD  CONSTRAINT [CREP_CAR_REPAIR_TIME_DAY_VALUE_ID_FK] FOREIGN KEY([value_id])
REFERENCES [dbo].[CREP_VALUE] ([id])
GO
ALTER TABLE [dbo].[CREP_CAR_REPAIR_TIME_DAY] CHECK CONSTRAINT [CREP_CAR_REPAIR_TIME_DAY_VALUE_ID_FK]
GO


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




