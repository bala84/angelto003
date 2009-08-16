:r ./../_define.sql

:setvar dc_number 00240
:setvar dc_description "demand master save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.05.2008 VLavrentiev  demand master save fixed
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
			, employee_worker_id, wrh_demand_master_type_id, organization_giver_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @v_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id, @p_wrh_demand_master_type_id, @p_organization_giver_id
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




