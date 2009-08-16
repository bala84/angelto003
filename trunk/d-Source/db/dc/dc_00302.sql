:r ./../_define.sql

:setvar dc_number 00302
:setvar dc_description "order master - repair type master select fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    10.06.2008 VLavrentiev  order master - repair type master select fixed
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

ALTER PROCEDURE [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SelectByWrh_order_master_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о видах ремонта в заказе-наряде
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
		  , repair_type_master_id
		  , repair_type_master_sname
		  , wrh_order_master_id
		  , number
	FROM dbo.utfVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER() as a
	where wrh_order_master_id = @p_wrh_order_master_id

	RETURN
GO

drop table dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
go

alter table dbo.CWRH_WRH_DEMAND_MASTER
add wrh_order_master_id numeric(38,0)
go

create index ifk_wrh_order_master_id_wrh_dmd_master on dbo.CWRH_WRH_DEMAND_MASTER(wrh_order_master_id)
on $(fg_idx_name)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид заказа-наряда',
   'user', @CurrentUser, 'table', 'CWRH_WRH_DEMAND_MASTER', 'column', 'wrh_order_master_id'
go
  


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_DETAIL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей заказов-нарядов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_wrh_order_master_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,isnull(convert(decimal(18,2), c.left_to_demand), convert(decimal(18,2), a.amount)) as left_to_demand
      FROM dbo.CWRH_WRH_ORDER_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
      outer apply(
		   select sum(e.amount) as left_to_demand
			from dbo.CWRH_WRH_DEMAND_MASTER as d
		left outer join dbo.CWRH_WRH_DEMAND_DETAIL as e
			on d.id = e.wrh_demand_master_id 
			where a.wrh_order_master_id = d.wrh_order_master_id
			  and e.good_category_id = a.good_category_id
			group by e.good_category_id) as c
	  where a.wrh_order_master_id = @p_wrh_order_master_id
	
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях заказов-нарядов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_wrh_order_master_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,wrh_order_master_id
		  ,good_category_id
		  ,amount
		  ,good_mark
		  ,good_category_sname
		  ,unit
		  ,left_to_demand
	FROM dbo.utfVWRH_WRH_ORDER_DETAIL(@p_wrh_order_master_id)

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
	,@p_wrh_demand_master_type_id numeric(38,0) = null
	,@p_organization_giver_id	numeric(38,0) = null
	,@p_wrh_order_master_id	numeric(38,0) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	 declare
		 @v_number varchar(20)
		,@v_Error int
        ,@v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      

       -- надо добавлять
  if (@p_id is null)
    begin

if (@@tranCount = 0)
        begin transaction  

		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_DEMAND_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number
	
	   insert into
			     dbo.CWRH_WRH_DEMAND_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id
			, employee_worker_id, wrh_demand_master_type_id, organization_giver_id, wrh_order_master_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @v_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id, @p_wrh_demand_master_type_id, @p_organization_giver_id, @p_wrh_order_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

if (@@tranCount > @v_TrancountOnEntry)
        commit

    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
		,organization_giver_id = @p_organization_giver_id
		,wrh_order_master_id = @p_wrh_order_master_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

	   
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
