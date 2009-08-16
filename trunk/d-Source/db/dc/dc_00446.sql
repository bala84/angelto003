
:r ./../_define.sql

:setvar dc_number 00446
:setvar dc_description "rep count cars fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   rep count cars fixed#2
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



alter table dbo.ccar_car_kind
add is_comm_duty_car bit default 0
go

create index i_ccar_car_kind_is_comm_duty_car on dbo.ccar_car_kind(is_comm_duty_car)
on $(fg_idx_name)
go

execute sp_addextendedproperty 'MS_Description', 
   'Боевая машина или нет',
   'user', 'dbo', 'table', 'ccar_car_kind', 'column', 'is_comm_duty_car'
go


update dbo.ccar_car_kind
   set is_comm_duty_car = 1
where id in (50,51,53)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CCAR_CAR_EVENT](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[event] [smallint] NOT NULL,
	[date_started] [datetime] NOT NULL,
	[date_ended] [datetime] NULL,
 CONSTRAINT [CCAR_CAR_EVENT_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид машины' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Событие' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'event'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата начала события' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'date_started'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата окончания события' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT', @level2type=N'COLUMN', @level2name=N'date_ended'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица событий машин' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_EVENT'

GO

ALTER TABLE [dbo].[CCAR_CAR_EVENT]  WITH CHECK ADD  CONSTRAINT [CCAR_CAR_EVENT_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
go

create index i_ccar_car_event_car_id on dbo.ccar_car_event(car_id)
on $(fg_idx_name)
go

create index i_ccar_car_event_date_ended on dbo.ccar_car_event(date_ended)
on $(fg_idx_name)
go

create unique index u_ccar_car_event_car_id_event_date_started on dbo.ccar_car_event(car_id, event, date_started)
on $(fg_idx_name)
go




create index i_cprt_emp_event_date_ended on dbo.CPRT_EMPLOYEE_EVENT(date_ended)
on $(fg_idx_name)
go



insert into dbo.csys_const (id, name, description)
values('3', 'CAR_OUTDATED', 'Машина списана')
go



insert into dbo.csys_const (id, name, description)
values('2', 'CAR_LOANED', 'Машина арендована')
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


