:r ./../_define.sql

:setvar dc_number 00294
:setvar dc_description "order master type consts added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    07.06.2008 VLavrentiev  order master type consts added
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



set identity_insert dbo.CWRH_WRH_ORDER_MASTER_TYPE on
insert into dbo.CWRH_WRH_ORDER_MASTER_TYPE (id, short_name, full_name)
values(401, 'По машине','По машине')
insert into dbo.CWRH_WRH_ORDER_MASTER_TYPE (id, short_name, full_name)
values(402, 'Для механиков','Для механиков')
insert into dbo.CWRH_WRH_ORDER_MASTER_TYPE (id, short_name, full_name)
values(403, 'Расход','Расход')
insert into dbo.CWRH_WRH_ORDER_MASTER_TYPE (id, short_name, full_name)
values(404, 'Моторный цех','Моторный цех')
set identity_insert dbo.CWRH_WRH_ORDER_MASTER_TYPE off
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[wrh_order_master_id] [numeric](38, 0) NOT NULL,
	[repair_type_master_id] [numeric](38, 0) NOT NULL,
 CONSTRAINT [order_master_repair_type_master_pk] PRIMARY KEY CLUSTERED 
(
	[repair_type_master_id] ASC,
	[wrh_order_master_id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид заказа-наряда' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'wrh_order_master_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида ремонта' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', @level2type=N'COLUMN', @level2name=N'repair_type_master_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица связей заказов-нарядов и видов ремонта' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER'

GO

ALTER TABLE [dbo].[CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER]  WITH CHECK ADD  CONSTRAINT [CWRH_ORDER_M_RPR_TYPE_M_REPAIR_TYPE_M_ID_FK] FOREIGN KEY([repair_type_master_id])
REFERENCES [dbo].[CRPR_REPAIR_TYPE_MASTER] ([id])
GO
ALTER TABLE [dbo].[CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER]  WITH CHECK ADD  CONSTRAINT [CWRH_ORDER_M_RPR_TYPE_M_ORDER_M_ID_FK] FOREIGN KEY([wrh_order_master_id])
REFERENCES [dbo].[CWRH_WRH_ORDER_MASTER] ([id]) 
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




