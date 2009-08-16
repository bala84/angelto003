:r ./../_define.sql

:setvar dc_number 00265
:setvar dc_description "report warehouse item day added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.05.2008 VLavrentiev  report warehouse item day added
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
CREATE TABLE [dbo].[CREP_WAREHOUSE_ITEM_DAY](
	id	     numeric(38,0)	identity(1000,1),
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[month_created] [datetime] NOT NULL,
	[value_id] [numeric](38, 0) NOT NULL,
    good_category_id	 numeric(38, 0) not null,
	good_category_fname	 varchar(60)    not null,
	good_mark			 varchar(30)	not null,
	warehouse_type_id	 numeric(38, 0) not null,
	warehouse_type_sname varchar(30)	not null,	
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
 CONSTRAINT [crep_warehouse_item_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)
WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Месяц создания записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'month_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид значения' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'value_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'good_category_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Полное название товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'good_category_fname'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Артикул' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'good_mark'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'warehouse_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'warehouse_type_sname'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_1'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_2'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_3'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_4'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_5'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_6'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_7'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_8'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_9'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_10'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_11'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_12'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_13'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_14'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_15'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_16'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_17'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_18'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_19'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_20'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_21'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_22'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_23'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_24'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_25'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_26'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_27'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_28'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_29'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_30'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значение на соответствующий день' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_WAREHOUSE_ITEM_DAY', @level2type=N'COLUMN', @level2name=N'day_31'

GO

ALTER TABLE [dbo].[CREP_WAREHOUSE_ITEM_DAY]  WITH CHECK ADD  CONSTRAINT [CREP_WAREHOUSE_ITEM_DAY_VALUE_ID_FK] FOREIGN KEY([value_id])
REFERENCES [dbo].[CREP_VALUE] ([id])
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

