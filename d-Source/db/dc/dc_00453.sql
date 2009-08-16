
:r ./../_define.sql

:setvar dc_number 00453
:setvar dc_description "demand detail wrh income fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   demand detail wrh income fix
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


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь требования
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id							numeric(38,0) out
    ,@p_wrh_demand_master_id		numeric(38,0)
    ,@p_good_category_id			numeric(38,0)
	,@p_amount						decimal(18,9)
	,@p_warehouse_type_id			numeric(38,0)
	,@p_last_amount					decimal(18,9) = null
	,@p_price						decimal(18,9) = null
	,@p_last_organization_giver_id  numeric(38,0) = null
	,@p_wrh_income_detail_id		numeric(38,0) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  -- Если ид прихода не известно и статус - проверен - вернем ошибку
  if ((@p_wrh_income_detail_id is null)
      and (exists
	(select 1 from dbo.cwrh_wrh_demand_master
		  where id = @p_wrh_demand_master_id
                     and is_verified = 1)))
	begin
         RAISERROR ('Нельзя указывать статус "Проверен", если у товара еще не указан приходный документ.', 16, 1)
         
	 update dbo.cwrh_wrh_demand_master
	    set is_verified = 0
	  where id = @p_wrh_demand_master_id
            and is_verified = 1
	end
	declare @v_Error int
          	  , @v_TrancountOnEntry int
	 	  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
		  , @v_organization_id numeric(38,0)
		  , @v_date_created    datetime
		  , @v_car_id numeric(38,0)
		  ,	@v_last_amount decimal(18,9)
		  , @v_last_price  decimal(18,9)
		  , @v_last_good_category_id numeric(38,0)
		  , @v_last_organization_id	  numeric(38,0)
		  , @v_last_warehouse_type_id numeric(38,0)
		  , @v_last_warehouse_item_id numeric(38,0)

	declare @v_data				xml
		   ,@v_tablename_id		numeric(38,0)
		   ,@v_action		    tinyint
		   ,@v_message_level_id numeric(38,0)
		   ,@v_subsystem_id		numeric(38,0)		
		   ,@v_system_date_created	datetime 
		   ,@v_system_user_id		numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_price is null)
    set @p_price = 0
	

    --Проставим режим обработки для товара со склада в режим апдейта
	set @v_edit_state = 'U'

	set @v_system_date_created  = getdate()


    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_DETAIL 
            ( wrh_demand_master_id, good_category_id
			, amount, warehouse_type_id, price, wrh_income_detail_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id, @p_price, @p_wrh_income_detail_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)

       
	  set @p_id = scope_identity();
--	  set @v_action = dbo.usfConst('ACTION_INSERT')
    end   
       
	    
 else
  begin

  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,price = @p_price
		,wrh_income_detail_id = @p_wrh_income_detail_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

	  --  set @v_action = dbo.usfConst('ACTION_UPDATE')

  end


  exec @v_Error = 
		dbo.uspVREP_WRH_DEMAND_Calculate
				 @p_id					= null
				,@p_wrh_demand_detail_id= @p_id
				,@p_wrh_demand_master_id= @p_wrh_demand_master_id
				,@p_good_category_id	= @p_good_category_id
				,@p_amount				= @p_amount
				,@p_warehouse_type_id	= @p_warehouse_type_id
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end


select @v_organization_id = a.organization_giver_id
	  ,@v_date_created	  = a.date_created
	  ,@v_car_id		  = a.car_id
from dbo.CWRH_WRH_DEMAND_MASTER as a
where id = @p_wrh_demand_master_id
 

--Отчет для склада
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare
	    @p_wrh_demand_master_id = @p_wrh_demand_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_warehouse_type_id	= @p_warehouse_type_id
	   ,@p_organization_id = @v_organization_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 



	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
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



