:r ./../_define.sql
:setvar dc_number 00097                   
:setvar dc_description "condition check type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    07.03.2008 VLavrentiev  condition check type fixed
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

ALTER FUNCTION [dbo].[usfVCAR_CONDITION_Check_ts_type] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция проверяет предстоящее ТО
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_run						decimal
,@p_car_id					numeric (38,0)
,@p_last_ts_type_master_id	numeric (38,0) = null			
)
RETURNS numeric(38,0)
AS
BEGIN

DECLARE @p_Result_id numeric(38,0);
    

SELECT TOP(1)
			 @p_Result_id = a.id
		FROM dbo.utfVCAR_TS_TYPE_MASTER() as a
       WHERE (case when @p_run/a.periodicity <= 1
				   then @p_run 
				   when @p_run/a.periodicity > 1
				   then (@p_run - (floor(@p_run/a.periodicity)*a.periodicity))
			    end >= (a.periodicity - a.tolerance))
	    AND 
		EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id)
		--AND (a.id <> @p_last_ts_type_master_id or @p_last_ts_type_master_id is null) 
		AND NOT EXISTS
		(select 1 from dbo.CHIS_CONDITION as c
			where c.car_id = @p_car_id
			  and c.date_created <= getdate()
			  and c.run <= @p_run
			  and c.last_ts_type_master_id = a.id)
	   ORDER BY periodicity desc

	RETURN @p_Result_id
END
GO


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

  

   if (@@tranCount = 0)
	  begin transaction 

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

 
   if (@p_condition_id is not null) 
    update dbo.CCAR_CONDITION
	    set run = run - @p_run
		   ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user  
	where id = @p_condition_id

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
