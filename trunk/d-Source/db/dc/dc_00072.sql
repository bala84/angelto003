:r ./../_define.sql
:setvar dc_number 00072
:setvar dc_description "driver_list delete run fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.03.2008 VLavrentiev  driver_list delete run fixed
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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
    ,@p_car_id			 numeric(38,0) 
    ,@p_condition_id    	 numeric(38,0)
    ,@p_speedometer_start_indctn decimal = 0.0
    ,@p_speedometer_end_indctn	 decimal = 0.0
    ,@p_run			 decimal       = 0.0
    ,@p_sys_comment		 varchar(2000) = '-'
    ,@p_sys_user		 varchar(30)   = null
	
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount

   if (@p_sys_comment is null)
   set @p_sys_comment = '-'

   if  (@p_sys_user is null)
   set @p_sys_user = user_name()

   if (@p_run is null)
   set @p_run = 0.0

   if (@p_speedometer_start_indctn is null)
   set @p_speedometer_start_indctn = 0.0

   if (@p_speedometer_end_indctn is null)
   set @p_speedometer_end_indctn = 0.0

   --Изменим на обратную величину пробег перед удалением путевого листа
   set @p_run = -@p_run



   if (@@tranCount = 0)
	  begin transaction 

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id


  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= null
    		,@p_run				= @p_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

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
