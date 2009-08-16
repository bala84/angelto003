:r ./../_define.sql

:setvar dc_number 00387
:setvar dc_description "repair bill added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   23.09.2008 VLavrentiev  repair bill added
*******************************************************************************/ 
use [$(db_name)]
GO

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
CREATE TABLE [dbo].[CRPR_REPAIR_BILL_MASTER](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[full_name] [varchar](60) NOT NULL,
	[repair_type_master_id] [numeric](38,0) NOT NULL,
 CONSTRAINT [crpr_repair_bill_master_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
) ON $(fg_idx_name)

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Полное название' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'full_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER', @level2type=N'COLUMN',@level2name=N'repair_type_master_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица списков запчастей для ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_MASTER'
go


ALTER TABLE [dbo].[CRPR_REPAIR_BILL_MASTER]  WITH CHECK ADD  CONSTRAINT [CRPR_REPAIR_BILL_M_REPAIR_TYPE_M_ID_FK] FOREIGN KEY([repair_type_master_id])
REFERENCES [dbo].[CRPR_REPAIR_TYPE_MASTER] ([id])
GO

create index ifk_repair_type_master_id_crpr_bill_master on CRPR_REPAIR_BILL_MASTER(repair_type_master_id)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CRPR_REPAIR_BILL_DETAIL](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[repair_bill_master_id] [numeric](38, 0) NOT NULL,
	[good_category_id] [numeric](38, 0) NOT NULL,
	[amount] [decimal](18, 9) NOT NULL,
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
 CONSTRAINT [CRPR_REPAIR_BILL_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид мастер таблицы вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'repair_bill_master_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид категории товара' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'good_category_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'amount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Детальная таблица видов ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRPR_REPAIR_BILL_DETAIL'
GO
ALTER TABLE [dbo].[CRPR_REPAIR_BILL_DETAIL]  WITH CHECK ADD  CONSTRAINT [CRPR_REPAIR_BILL_D_GD_CTGRY_ID_FK] FOREIGN KEY([good_category_id])
REFERENCES [dbo].[CWRH_GOOD_CATEGORY] ([id])
GO
ALTER TABLE [dbo].[CRPR_REPAIR_BILL_DETAIL] CHECK CONSTRAINT [CRPR_REPAIR_BILL_D_GD_CTGRY_ID_FK]
GO
ALTER TABLE [dbo].[CRPR_REPAIR_BILL_DETAIL]  WITH CHECK ADD  CONSTRAINT [CRPR_REPAIR_BILL_D_REPAIR_BILL_M_ID_FK] FOREIGN KEY([repair_bill_master_id])
REFERENCES [dbo].[CRPR_REPAIR_BILL_MASTER] ([id])
GO
ALTER TABLE [dbo].[CRPR_REPAIR_BILL_DETAIL] CHECK CONSTRAINT [CRPR_REPAIR_BILL_D_REPAIR_BILL_M_ID_FK]
go


create index ifk_repair_bill_master_id_crpr_bill_detail on CRPR_REPAIR_BILL_DETAIL(repair_bill_master_id)
on $(fg_idx_name)
go

create index ifk_good_category_id_crpr_bill_detail on CRPR_REPAIR_BILL_DETAIL(good_category_id)
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


