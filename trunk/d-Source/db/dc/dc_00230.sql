:r ./../_define.sql

:setvar dc_number 00230
:setvar dc_description "demands type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.05.2008 VLavrentiev  demands type added
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
CREATE TABLE [dbo].[CWRH_WRH_DEMAND_MASTER_TYPE](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000)  NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[short_name] [varchar](30) NOT NULL,
	[full_name] [varchar](60)  NOT NULL,
 CONSTRAINT [CWRH_WRH_DEMAND_MASTER_TYPE_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Краткое название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'short_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Полное название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE', @level2type=N'COLUMN', @level2name=N'full_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица типов требований' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER_TYPE'
GO


alter table dbo.CWRH_WRH_DEMAND_MASTER
add wrh_demand_master_type_id numeric(38,0)
go



alter table dbo.CWRH_WRH_DEMAND_MASTER
   add constraint CWRH_WRH_DEMAND_MASTER_DMD_MASTER_TYPE_ID_FK foreign key (wrh_demand_master_type_id)
      references dbo.CWRH_WRH_DEMAND_MASTER_TYPE (id)
go


create index ifk_wrh_demand_master_type_demand_master on dbo.CWRH_WRH_DEMAND_MASTER(wrh_demand_master_type_id)
on $(fg_idx_name)
go

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа требования' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CWRH_WRH_DEMAND_MASTER', @level2type=N'COLUMN', @level2name=N'wrh_demand_master_type_id'
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




