:r ./../_define.sql

:setvar dc_number 00429
:setvar dc_description "car no exit type procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.03.2009 VLavrentiev   car no exit type procs added
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
CREATE TABLE [dbo].[CCAR_RETURN_REASON_DETAIL](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[date] [datetime] NOT NULL,
	[time] [datetime] NULL,
	[comments] [varchar](1000) NULL,
	[mech_employee_id] [numeric](38, 0) NULL,
	[rownum] [int] NULL,
	[car_return_reason_type_id] [numeric](38, 0) NULL
) ON [$(fg_dat_name)]
SET ANSI_PADDING OFF



ALTER TABLE [dbo].[CCAR_RETURN_REASON_DETAIL] ADD  CONSTRAINT [CCAR_RETURN_REASON_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'date'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'time'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'comments'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид механика' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'mech_employee_id'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'rownum'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа возврата с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'car_return_reason_type_id'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица детального возврата с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_RETURN_REASON_DETAIL'

GO

ALTER TABLE [dbo].[CCAR_RETURN_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_RETURN_REASON_DETAIL_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
GO
ALTER TABLE [dbo].[CCAR_RETURN_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_RETURN_REASON_DETAIL_car_return_reason_type_ID_FK] FOREIGN KEY([car_return_reason_type_id])
REFERENCES [dbo].[CCAR_CAR_RETURN_REASON_TYPE] ([id])
GO

ALTER TABLE [dbo].[CCAR_RETURN_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_RETURN_REASON_DETAIL_MECH_EMP_ID_FK] FOREIGN KEY([mech_employee_id])
REFERENCES [dbo].[CPRT_EMPLOYEE] ([id])
GO

create index ifk_car_return_reason_detail_car_id on dbo.ccar_return_reason_detail (car_id)
on $(fg_idx_name)
go

create index ifk_car_return_reason_detail_car_return_reason_type_id on dbo.ccar_return_reason_detail (car_return_reason_type_id)
on $(fg_idx_name)
go

create index ifk_car_return_reason_detail_mech_employee_id on dbo.ccar_return_reason_detail(mech_employee_id)
on $(fg_idx_name)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CCAR_NOEXIT_REASON_DETAIL](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[date] [datetime] NOT NULL,
	[time] [datetime] NULL,
	[comments] [varchar](1000) NULL,
	[mech_employee_id] [numeric](38, 0) NULL,
	[rownum] [int] NULL,
	[car_noexit_reason_type_id] [numeric](38, 0) NULL
) ON [$(fg_dat_name)]
SET ANSI_PADDING OFF



ALTER TABLE [dbo].[CCAR_NOEXIT_REASON_DETAIL] ADD  CONSTRAINT [CCAR_NOEXIT_REASON_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'date'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'time'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'comments'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид механика' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'mech_employee_id'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'rownum'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа невыхода с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL', @level2type=N'COLUMN', @level2name=N'car_noexit_reason_type_id'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица детального возврата с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_NOEXIT_REASON_DETAIL'

GO

ALTER TABLE [dbo].[CCAR_NOEXIT_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_NOEXIT_REASON_DETAIL_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
GO
ALTER TABLE [dbo].[CCAR_NOEXIT_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_NOEXIT_REASON_DETAIL_car_noexit_reason_type_ID_FK] FOREIGN KEY([car_noexit_reason_type_id])
REFERENCES [dbo].[CCAR_CAR_NOEXIT_REASON_TYPE] ([id])
GO

ALTER TABLE [dbo].[CCAR_NOEXIT_REASON_DETAIL]  WITH CHECK ADD  CONSTRAINT [CCAR_NOEXIT_REASON_DETAIL_MECH_EMP_ID_FK] FOREIGN KEY([mech_employee_id])
REFERENCES [dbo].[CPRT_EMPLOYEE] ([id])
GO

create index ifk_car_return_reason_detail_car_id on dbo.CCAR_NOEXIT_REASON_DETAIL (car_id)
on $(fg_idx_name)
go

create index ifk_car_return_reason_detail_car_noexit_reason_type_id on dbo.CCAR_NOEXIT_REASON_DETAIL (car_noexit_reason_type_id)
on $(fg_idx_name)
go

create index ifk_car_return_reason_detail_mech_employee_id on dbo.CCAR_NOEXIT_REASON_DETAIL(mech_employee_id)
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



