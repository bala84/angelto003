:r ./../_define.sql

:setvar dc_number 00275
:setvar dc_description "wrh_order seq generate added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.05.2008 VLavrentiev  wrh_order seq generate added
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

CREATE procedure [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_number      varchar(20)   = null out
    ,@p_sent_to		char(1)   = 'N'
    ,@p_sys_comment varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)
	,@v_number varchar(4)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

   if @p_sent_to = 'N'	
    begin			
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

		select  @v_number_tmp = max(number)
		from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

	    set @v_number = convert(varchar(4), @v_number_tmp)
		set @p_number = @v_number + '/' + convert(varchar(2), datepart("mm", getdate()))
										+ '/'
										+ convert(varchar(4), datepart("year", getdate()))
	end
   
    
  return  

end
GO


GRANT EXECUTE ON [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_number      varchar(20)   = null out
    ,@p_sent_to		char(1)   = 'N'
    ,@p_sys_comment varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)
	,@v_number varchar(4)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

   if @p_sent_to = 'N'	
    begin	
      if (not exists (select 1 
						from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ
						where number = 1))	
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

    set @v_number = convert(varchar(4), @v_number_tmp)
	set @p_number = @v_number + '/' + convert(varchar(2), datepart("mm", getdate()))
									+ '/'
									+ convert(varchar(4), datepart("year", getdate()))
	end
   
    
  return  

end
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
ALTER TRIGGER [TIU_CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ]
   ON  [dbo].[CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
  declare
	  @v_number numeric(38,0)

  select @v_number = number
	from inserted

  if @v_number  = 9001
   begin
    exec ('truncate table dbo.CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ')

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
ALTER TRIGGER [TIU_CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   ON  [dbo].[CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
  declare
	  @v_number numeric(38,0)

  select @v_number = number
	from inserted

  if @v_number  = 9001
   begin
    exec ('truncate table dbo.CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ')
   end
    

END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_number      varchar(20)   = null out
    ,@p_sent_to		char(1)   = 'N'
    ,@p_sys_comment varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)
	,@v_number varchar(4)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

   if @p_sent_to = 'N'	
    begin	
      if (not exists (select 1 
						from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ
						where number = 1))	
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

    set @v_number = convert(varchar(4), @v_number_tmp)
	set @p_number = @v_number + '/' + convert(varchar(2), datepart("mm", getdate()))
									+ '/'
									+ convert(varchar(4), datepart("year", getdate()))
	end
  if @p_sent_to = 'Y'
   begin
	 if (not exists (select 1 
						from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ
						where number = 1))	
	   	insert into CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ(number, sys_comment)
		values(1, 'seq_gen')

      else
		insert into CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ

		select  @v_number_tmp = max(number)
		from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ

	    set @p_number = convert(varchar(4), @v_number_tmp)
   end
   
    
  return  

end
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
ALTER TRIGGER [TIU_CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   ON  [dbo].[CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ]
   AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON
  declare
	  @v_number numeric(38,0)

  select @v_number = number
	from inserted

  if (datepart("Day", getdate()) = 1
		and not exists (select 1 from dbo.CWRH_WRH_ORDER_MASTER
						where date_created = dbo.usfUtils_DayTo01(getdate())))
   begin
    exec ('truncate table dbo.CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ')
   end
    

END
GO




create index i_date_created_wrh_order_master on dbo.CWRH_WRH_ORDER_MASTER(date_created)
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


