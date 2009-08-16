:r ./../_define.sql

:setvar dc_number 00430
:setvar dc_description "income order added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.03.2009 VLavrentiev   income order added
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
CREATE TABLE [dbo].[CWRH_WRH_INCOME_ORDER_MASTER](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000)  NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[number] [varchar](150) NOT NULL,
	[date_created] [datetime] NOT NULL,
	[total] [decimal](18, 9) NULL,
	[is_verified] [bit] NULL DEFAULT ((0)),
 CONSTRAINT [CWRH_WRH_INCOME_ORDER_MASTER_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер документа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'number'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата поступления' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Сумма' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'total'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Проверен документ или нет' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER', @level2type=N'COLUMN', @level2name=N'is_verified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица-мастер заявок на закупку на склад' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_MASTER'

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CWRH_WRH_INCOME_ORDER_DETAIL](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[wrh_income_order_master_id] [numeric](38, 0) NOT NULL,
	[good_category_id] [numeric](38, 0) NOT NULL,
	[car_id] [numeric](38, 0) NOT NULL,
	[amount] [decimal](18, 9) NOT NULL,
	[total] [decimal](18, 9) NULL,
	[price] [decimal](18, 9) NULL,
 CONSTRAINT [CWRH_WRH_INCOME_ORDER_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид мастер таблицы заявок на закупку на склад' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'wrh_income_order_master_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид категории товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'good_category_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'amount'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Сумма' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'total'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Цена' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL', @level2type=N'COLUMN', @level2name=N'price'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Детальная таблица заявок на закупку на склад' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_INCOME_ORDER_DETAIL'

GO

ALTER TABLE [dbo].[CWRH_WRH_INCOME_ORDER_DETAIL]  WITH CHECK ADD  CONSTRAINT [CWRH_WRH_INCOME_O_D_GD_CTGRY_ID_FK] FOREIGN KEY([good_category_id])
REFERENCES [dbo].[CWRH_GOOD_CATEGORY] ([id])
GO

ALTER TABLE [dbo].[CWRH_WRH_INCOME_ORDER_DETAIL]  WITH CHECK ADD  CONSTRAINT [CWRH_WRH_INCOME_O_D_INCOME_M_ID_FK] FOREIGN KEY([wrh_income_order_master_id])
REFERENCES [dbo].[CWRH_WRH_INCOME_ORDER_MASTER] ([id])
go

ALTER TABLE [dbo].[CWRH_WRH_INCOME_ORDER_DETAIL]  WITH CHECK ADD  CONSTRAINT [CWRH_WRH_INCOME_O_D_CAR_ID_FK] FOREIGN KEY([car_id])
REFERENCES [dbo].[CCAR_CAR] ([id])
go


create index ifk_wrh_income_order_detail_good_category_id on dbo.cwrh_wrh_income_order_detail (good_category_id)
on $(fg_idx_name)
go

create index ifk_wrh_income_order_detail_wrh_income_order_master_id on dbo.cwrh_wrh_income_order_detail (wrh_income_order_master_id)
on $(fg_idx_name)
go


create index ifk_wrh_income_order_detail_car_id on dbo.cwrh_wrh_income_order_detail (car_id)
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



