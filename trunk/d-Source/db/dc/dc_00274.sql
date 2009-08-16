:r ./../_define.sql

:setvar dc_number 00274
:setvar dc_description "ts_type_detail and orders fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.05.2008 VLavrentiev  ts_type_detail and orders fix
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

drop index [dbo].[CWRH_WRH_ORDER_MASTER].u_number_wrh_order_m
go

CREATE NONCLUSTERED INDEX [i_number_wrh_order_m] ON dbo.CWRH_WRH_ORDER_MASTER (number)
on $(fg_idx_name)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ](
	[number] [numeric](38, 0) NOT NULL,
	[sys_comment] [varchar](10) NULL 
) ON [$(fg_dat_name)]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ](
	[number] [numeric](38, 0) NOT NULL,
	[sys_comment] [varchar](10) NULL 
) ON [$(fg_dat_name)]

GO

create clustered index i_number_csys_wrh_order_to_number on dbo.CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ(number)
on $(fg_idx_name)
go


create clustered index i_number_csys_wrh_order_usual_number on dbo.CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<VLavrentiev>
-- Create date: <28.05.2008>
-- Description:	<Триггер для обработки номеров заказов нарядов>
-- =============================================
create TRIGGER [TIU_CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   ON  [dbo].[CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
  declare
	  @v_number numeric(38,0)

  select @v_number = number
	from inserted

  if @v_number  = 2
   begin
    exec ('truncate table dbo.CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ')
   end
    

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<VLavrentiev>
-- Create date: <28.05.2008>
-- Description:	<Триггер для обработки номеров заказов нарядов>
-- =============================================
create TRIGGER [TIU_CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ]
   ON  [dbo].[CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
  declare
	  @v_number numeric(38,0)

  select @v_number = number
	from inserted

  if @v_number  = 2
   begin
    exec ('truncate table dbo.CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ')

   end
    

END
GO

GRANT ALTER ON [dbo].[CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ] TO [$(db_app_user)]
GO

GRANT ALTER ON [dbo].[CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ] TO [$(db_app_user)]
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


