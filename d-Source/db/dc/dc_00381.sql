:r ./../_define.sql

:setvar dc_number 00381
:setvar dc_description "wfe procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.09.2008 VLavrentiev  wfe procs added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uspVWFE_Inquire_ts_by_car_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о предстоящем ТО
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_car_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
select top(1) 
  id, ts_type_master_id
from(
select id, ts_type_master_id, ordered from(
select top(1) ts_type_master_id, a.ordered, id 
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (
select b2.ordered, b2.ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as b2
				  where b2.id = (select ts_type_route_detail_id
								from dbo.ccar_condition
								where car_id = @p_car_id)
					and ts_type_route_master_id = a.ts_type_route_master_id
) as b
where a.ordered > b.ordered
order by a.ordered asc) as c
union
select id, ts_type_master_id, a.ordered
from dbo.CCAR_TS_TYPE_ROUTE_DETAIL as a
outer apply (select ordered, ts_type_route_master_id
				  from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
				  where id = (select ts_type_route_detail_id
								from dbo.ccar_condition
								where car_id = @p_car_id)
					and ts_type_route_master_id = a.ts_type_route_master_id) as b
where a.ordered = 1) as d
order by ordered desc	

	RETURN
go



GRANT EXECUTE ON [dbo].[uspVWFE_Inquire_ts_by_car_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWFE_Inquire_ts_by_car_id] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWFE_CONDITION_Update_ts_ByCar_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные о ТО автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      21.09.2008 VLavrentiev  Добавил новую процедуру
*******************************************************************************/
(
     @p_car_id		        		numeric(38,0)
	,@p_ts_type_master_id		    numeric(38,0)
	,@p_ts_type_route_detail_id		numeric(38,0)
)
as
begin
   set nocount on
   set xact_abort on
  

   declare @v_Error					  int
         , @v_TrancountOnEntry		  int
	     , @v_action				  smallint
		 , @v_last_ts_type_master_id  numeric(38,0)
		 , @v_employee_id			  numeric(38,0)
		 , @v_run					  decimal(18,9)
		 , @v_last_run				  decimal(18,9)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_speedometer_end_indctn   decimal(18,9)
		 , @v_edit_state			   char(1) 
		 , @v_fuel_start_left		   decimal(18,9)
		 , @v_fuel_end_left			   decimal(18,9)
		 , @v_overrun			       decimal(18,9)
		 , @v_in_tolerance			   bit
		 , @v_ts_type_route_detail_id  numeric(38,0)	
		 , @v_last_ts_type_route_detail_id numeric(38,0)
		 , @v_sys_comment			   varchar(2000)
		 , @v_sys_user				   varchar(30)
 

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount






	 if (@@tranCount = 0)
	  begin transaction 

 

	update dbo.CCAR_CONDITION
	set ts_type_master_id = @p_ts_type_master_id
	   ,ts_type_route_detail_id = @p_ts_type_route_detail_id
	   ,last_ts_type_route_detail_id = ts_type_route_detail_id
	where car_id = @p_car_id
		

		set @v_action = dbo.usfConst('ACTION_UPDATE')



	select 	 
			 @v_last_ts_type_master_id		= last_ts_type_master_id
    		,@v_employee_id					= employee_id
    		,@v_run							= run
    		,@v_last_run					= last_run
    		,@v_speedometer_start_indctn 	= speedometer_start_indctn 
    		,@v_speedometer_end_indctn 		= speedometer_end_indctn
			,@v_fuel_start_left				= fuel_start_left
			,@v_fuel_end_left				= fuel_end_left
			,@v_overrun						= overrun
			,@v_in_tolerance				= in_tolerance
			,@v_ts_type_route_detail_id		= ts_type_route_detail_id	
			,@v_last_ts_type_route_detail_id= last_ts_type_route_detail_id
			,@v_sys_comment					= sys_comment  
  			,@v_sys_user					= sys_user_modified
 from dbo.CCAR_CONDITION
 where car_id = @p_car_id

	  exec @v_Error = 
        dbo.uspVHIS_CONDITION_SaveById
        	 @p_action						= @v_action
			,@p_car_id						= @p_car_id
    		,@p_ts_type_master_id			= @p_ts_type_master_id
			,@p_last_ts_type_master_id		= @v_last_ts_type_master_id
    		,@p_employee_id					= @v_employee_id
    		,@p_run							= @v_run
    		,@p_last_run					= @v_last_run
    		,@p_speedometer_start_indctn 	= @v_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @v_speedometer_end_indctn
			,@p_edit_state					= 'E' 
			,@p_fuel_start_left				= @v_fuel_start_left
			,@p_fuel_end_left				= @v_fuel_end_left
			,@p_sent_to						= 'Y'
			,@p_overrun						= @v_overrun
			,@p_in_tolerance				= @v_in_tolerance
			,@p_ts_type_route_detail_id		= @v_ts_type_route_detail_id	
			,@p_last_ts_type_route_detail_id= @v_ts_type_route_detail_id
			,@p_sys_comment					= @v_sys_comment  
  			,@p_sys_user					= @v_sys_user

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

GRANT EXECUTE ON [dbo].[uspVWFE_CONDITION_Update_ts_ByCar_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWFE_CONDITION_Update_ts_ByCar_Id] TO [$(db_app_user)]
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
