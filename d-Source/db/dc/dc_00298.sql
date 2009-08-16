:r ./../_define.sql

:setvar dc_number 00298
:setvar dc_description "order master demand master procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.06.2008 VLavrentiev  order master demand master procs added
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

CREATE FUNCTION [dbo].[utfVWRH_ORDER_MASTER_DEMAND_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения привязки заказов-нарядов и требованиях
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.06.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_demand_master_id
		  ,b.number as wrh_demand_master_number
		  ,a.wrh_order_master_id
		  ,c.number	
		FROM dbo.CWRH_ORDER_MASTER_DEMAND_MASTER as a
		join dbo.CWRH_WRH_DEMAND_MASTER as b
			on a.wrh_demand_master_id = b.id
		join dbo.CWRH_WRH_ORDER_MASTER as c
			on a.wrh_order_master_id = c.id
		
		
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVWRH_ORDER_MASTER_DEMAND_MASTER] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SelectByWrh_order_master_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о требованиях в заказе-наряде
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_wrh_order_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  
			sys_status
		  , sys_comment
		  , sys_date_modified
		  , sys_date_created
		  , sys_user_modified
		  , sys_user_created
		  , wrh_demand_master_id
		  , wrh_demand_master_number
		  , wrh_order_master_id
		  , number
	FROM dbo.utfVWRH_ORDER_MASTER_DEMAND_MASTER() as a

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SelectByWrh_order_master_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SelectByWrh_order_master_id] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связи заказов-нарядов и требования
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id         numeric(38,0) 
	,@p_wrh_demand_master_id		numeric(38,0)
)
as
begin
  set nocount on

   delete
	from dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
	where wrh_order_master_id  = @p_wrh_order_master_id  
	  and wrh_demand_master_id = @p_wrh_demand_master_id

    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_DeleteById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из заказов-нарядов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction 

   delete
	from dbo.CWRH_WRH_ORDER_DETAIL
	where wrh_order_master_id = @p_id 


delete
	from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	where wrh_order_master_id = @p_id

delete
	from dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
	where wrh_order_master_id = @p_id


	delete
	from dbo.cwrh_wrh_order_master
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для заказа - наряда
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id		numeric(38,0)
	,@p_wrh_demand_master_id	numeric(38,0)
    ,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


	   insert into
			     dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
            ( wrh_order_master_id,  wrh_demand_master_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_wrh_demand_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_DEMAND_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.wrh_demand_master_id = @p_wrh_demand_master_id) 
       
       
  
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_SaveById] TO [$(db_app_user)]
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
