:r ./../_define.sql

:setvar dc_number 00238
:setvar dc_description "worker report tables added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.05.2008 VLavrentiev  worker report tables added
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
CREATE TABLE [dbo].[CREP_EMPLOYEE_HOUR](
	[id]		[numeric] (38,0)	identity(1000,1),
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000)   NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30)   NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30)   NOT NULL DEFAULT (user_name()),
	[value_id] [numeric](38, 0) NOT NULL,
	[employee_id] [numeric](38, 0) NOT NULL,
	[person_id] [numeric](38, 0) NOT NULL,
	[lastname] [varchar](100) NOT NULL,
	[name] [varchar](60)   NOT NULL,
	[surname] [varchar](60) NULL,
	[organization_id] [numeric](38, 0)   NULL,
	[organization_sname] [varchar](30) NOT NULL,
	[employee_type_id] [numeric](38, 0)   NOT NULL,
	[employee_type_sname] [varchar](30) NOT NULL,
	[hour_0] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_1] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_2] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_3] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_4] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_5] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_6] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_7] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_8] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_9] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_10] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_11] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_12] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_13] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_14] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_15] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_16] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_17] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_18] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_19] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_20] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_21] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_22] [decimal](18, 9) NOT NULL DEFAULT ('0'),
	[hour_23] [decimal](18, 9) NOT NULL DEFAULT ('0'),
 CONSTRAINT [CREP_EMPLOYEE_HOUR_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид рабочего' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'employee_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид значения' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'value_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид физ.лица' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'person_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Фамилия' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'lastname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отчество' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'surname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'organization_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'organization_sname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид должности' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'employee_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название должности' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'employee_type_sname'


GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 0 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_0'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 1 час' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_1'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 2 часа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_2'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 3 часа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_3'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 4 часа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_4'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 5 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_5'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 6 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_6'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 7 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_7'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 8 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_8'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 9 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_9'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 10 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_10'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 11 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_11'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 12 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_12'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 13 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_13'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 14 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_14'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 15 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_15'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 16 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_16'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 17 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_17'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 18 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_18'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 19 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_19'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 20 часов' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_20'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 21 час' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_21'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 22 часа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_22'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на 23 часа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR', @level2type=N'COLUMN', @level2name=N'hour_23'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица статистики рабочих по часам в дне' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_HOUR'

GO

ALTER TABLE [dbo].[CREP_EMPLOYEE_HOUR]  WITH CHECK ADD  CONSTRAINT [CREP_EMPLOYEE_HOUR_VALUE_ID_FK] FOREIGN KEY([value_id])
REFERENCES [dbo].[CREP_VALUE] ([id])
GO


create index ifk_value_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](value_id)
on $(fg_idx_name)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CREP_EMPLOYEE_DAY](
	[id]		[numeric] (38,0)	identity(1000,1),
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000)   NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30)   NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30)   NOT NULL DEFAULT (user_name()),
	[value_id] [numeric](38, 0) NOT NULL,
	[employee_id] [numeric](38, 0) NOT NULL,
	[person_id] [numeric](38, 0) NOT NULL,
	[lastname] [varchar](100) NOT NULL,
	[name] [varchar](60)   NOT NULL,
	[surname] [varchar](60) NULL,
	[organization_id] [numeric](38, 0)   NULL,
	[organization_sname] [varchar](30) NOT NULL,
	[employee_type_id] [numeric](38, 0)   NOT NULL,
	[employee_type_sname] [varchar](30) NOT NULL,
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
 CONSTRAINT [CREP_EMPLOYEE_DAY_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид рабочего' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'employee_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид значения' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'value_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид физ.лица' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'person_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Фамилия' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'lastname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Отчество' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'surname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'organization_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'organization_sname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид должности' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'employee_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название должности' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'employee_type_sname'


GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_1'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_2'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_3'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_4'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_5'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_6'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_7'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_8'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_9'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_10'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_11'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_12'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_13'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_14'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_15'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_16'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_17'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_18'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_19'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_20'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_21'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_22'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_23'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_24'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_25'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_26'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_27'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_28'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_29'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_30'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY', @level2type=N'COLUMN', @level2name=N'day_31'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица статистики автомобиля по дням в месяце' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_EMPLOYEE_DAY'

GO

ALTER TABLE [dbo].[CREP_EMPLOYEE_DAY]  WITH CHECK ADD  CONSTRAINT [CREP_EMPLOYEE_DAY_VALUE_ID_FK] FOREIGN KEY([value_id])
REFERENCES [dbo].[CREP_VALUE] ([id])
GO


create index ifk_value_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](value_id)
on $(fg_idx_name)
go


create index ifk_employee_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](employee_id)
on $(fg_idx_name)
go

create index ifk_employee_type_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](employee_type_id)
on $(fg_idx_name)
go


create index ifk_organization_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](organization_id)
on $(fg_idx_name)
go


create index ifk_person_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](person_id)
on $(fg_idx_name)
go


ccreate index ifk_employee_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](employee_id)
on $(fg_idx_name)
go

create index ifk_employee_type_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](employee_type_id)
on $(fg_idx_name)
go


create index ifk_organization_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](organization_id)
on $(fg_idx_name)
go


create index ifk_person_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](person_id)
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




