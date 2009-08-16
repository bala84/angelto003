:r ./../_define.sql

:setvar dc_number 00393
:setvar dc_description "plan detail and return reason added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.11.2008 VLavrentiev  plan detail and return reason added
*******************************************************************************/ 
use [$(db_name)]
GO


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _drop_chis_all_objects.sql                         ='
PRINT '==============================================================================='
PRINT ' '
go

:r _drop_chis_all_objects.sql


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CDRV_DRIVER_PLAN_DETAIL](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[date] datetime NOT NULL,
	[time] datetime NOT NULL,
	[employee_id]  [numeric](38, 0) NOT NULL,
	[shift_number] [tinyint] NULL,
	[comments] [varchar] (1000) NULL,
 CONSTRAINT [CDRV_DRIVER_PLAN_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'date'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'time'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сотрудника' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'employee_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер смены' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'shift_number'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'comments'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица детального плана выхода на линию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL'

GO
ALTER TABLE [dbo].[CDRV_DRIVER_PLAN_DETAIL]  WITH CHECK ADD  CONSTRAINT [CDRV_DRIVER_PLAN_DETAIL_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
GO
ALTER TABLE [dbo].[CDRV_DRIVER_PLAN_DETAIL]  WITH CHECK ADD  CONSTRAINT [CDRV_DRIVER_PLAN_DETAIL_EMP_ID_FK] FOREIGN KEY([employee_id])
REFERENCES [dbo].[CPRT_EMPLOYEE] ([id])
GO

create unique index u_cdrv_driver_plan_detail_car_id_emp_id_datetime on dbo.CDRV_DRIVER_PLAN_DETAIL(car_id, date, "time", employee_id)
on $(fg_idx_name)
go

create index ifk_cdrv_driver_plan_detail_car_id on dbo.CDRV_DRIVER_PLAN_DETAIL(car_id)
on $(fg_idx_name)
go


create index ifk_cdrv_driver_plan_detail_emp_id on dbo.CDRV_DRIVER_PLAN_DETAIL(employee_id)
on $(fg_idx_name)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CCAR_CAR_RETURN_REASON_TYPE](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[short_name] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[full_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NOT NULL,
 CONSTRAINT [CCAR_CAR_RETURN_REASON_TYPE_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Краткое название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'short_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Полное название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'full_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица типов возвратов автомобилей с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN_REASON_TYPE'
go

create unique index u_CCAR_CAR_RETURN_REASON_TYPE_short_name on dbo.CCAR_CAR_RETURN_REASON_TYPE(short_name)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CCAR_CAR_RETURN](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[date_created] datetime NOT NULL,
	[car_return_reason_type_id] [numeric](38, 0) NOT NULL,
 CONSTRAINT [CCAR_CAR_RETURN_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата возврата' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид причины возврата' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN', @level2type=N'COLUMN', @level2name=N'car_return_reason_type_id'

GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица возвратов автомобилей' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_RETURN'

GO

ALTER TABLE [dbo].[CCAR_CAR_RETURN]  WITH CHECK ADD  CONSTRAINT [CCAR_CAR_RETURN_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
GO
ALTER TABLE [dbo].[CCAR_CAR_RETURN]  WITH CHECK ADD  CONSTRAINT [CCAR_CAR_RETURN_REASON_TYPE_ID_FK] FOREIGN KEY([car_return_reason_type_id])
REFERENCES [dbo].[CCAR_CAR_RETURN_REASON_TYPE] ([id])
GO

create unique index u_CCAR_CAR_RETURN_car_id_date_created_reason_type_id on dbo.CCAR_CAR_RETURN(car_id, date_created, car_return_reason_type_id)
on $(fg_idx_name)
go


create index ifk_CCAR_CAR_RETURN_car_id on dbo.CCAR_CAR_RETURN(car_id)
on $(fg_idx_name)
go


create index ifk_CCAR_CAR_RETURN_return_type_id on dbo.CCAR_CAR_RETURN(car_return_reason_type_id)
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql
