:r ./../_define.sql

:setvar dc_number 00263
:setvar dc_description "warehouse item history added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.05.2008 VLavrentiev  warehouse item history added
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
CREATE TABLE [dbo].[CHIS_WAREHOUSE_ITEM](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[warehouse_type_id] [numeric](38, 0) NOT NULL,
	[amount] [int] NOT NULL,
	[good_category_id] [numeric](38, 0) NOT NULL,
	[price] [decimal](18, 9) NULL,
	[action] [smallint] NOT NULL,
	[date_created] [datetime] NOT NULL,
 CONSTRAINT [chis_warehouse_item_pk] PRIMARY KEY CLUSTERED 
(
	id, date_created, action
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'warehouse_type_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'amount'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид категории товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'good_category_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Цена товара' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'price'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Действие' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'action'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM', @level2type=N'COLUMN', @level2name=N'date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица склада' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CHIS_WAREHOUSE_ITEM'

GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVHIS_WAREHOUSE_ITEM_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об истории состояний автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) = null out
	,@p_date_created				datetime      = null
	,@p_action						smallint
    ,@p_warehouse_type_id			numeric(38,0)
    ,@p_amount						int
	,@p_good_category_id			numeric(38,0)
	,@p_edit_state					char(1)		  = 'E'
	,@p_price						decimal(18,9) = null
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30)   = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

     if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_date_created is null)
	set @p_date_created = getdate();

   if (@p_id is null)
	begin
	insert into dbo.CHIS_WAREHOUSE_ITEM 
     (date_created, action, warehouse_type_id, amount, price, good_category_id
	  , sys_comment, sys_user_created, sys_user_modified)
	select @p_date_created, @p_action, @p_warehouse_type_id, @p_amount, @p_price, @p_good_category_id
	  , @p_sys_comment, @p_sys_user, @p_sys_user
	
	  set @p_id = scope_identity();
	end
	return 

end
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

