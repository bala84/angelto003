:r ./../_define.sql
:setvar dc_number 00074
:setvar dc_description "condition saved fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.03.2008 VLavrentiev  condition saved fixed
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

ALTER procedure [dbo].[uspVCAR_CONDITION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ��������� ����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id				numeric(38,0) = null out
    ,@p_car_id		        	numeric(38,0)
    ,@p_ts_type_master_id   		numeric(38,0) = null
    ,@p_employee_id			numeric(38,0) = null
    ,@p_run 			    	decimal
    ,@p_last_run			decimal	      = 0.0
    ,@p_speedometer_start_indctn	decimal	      = 0.0
    ,@p_speedometer_end_indctn		decimal	      = 0.0    
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30)   = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    	set @p_sys_user = user_name()

     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     if (@p_run is null)
	set @p_run = 0.0
	    
     if (@p_last_run is null)
	set @p_last_run = @p_run

     if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0

     if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0	

       -- ���� ���������
  if (@p_id is null)
    begin
	   insert into dbo.CCAR_CONDITION 
            (car_id, ts_type_master_id, employee_id
	   ,run, last_run, speedometer_start_indctn, speedometer_end_indctn, sys_comment, sys_user_created, sys_user_modified)
	   values
	(@p_car_id, dbo.usfVCAR_CONDITION_Check_ts_type(@p_run, @p_car_id), @p_employee_id
	,@p_run, @p_last_run, @p_speedometer_start_indctn, @p_speedometer_end_indctn, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- ���� ������� ������������
		update dbo.CCAR_CONDITION set
	 	 car_id = @p_car_id
		,ts_type_master_id = dbo.usfVCAR_CONDITION_Check_ts_type(run + @p_run, @p_car_id)
		,employee_id = @p_employee_id
		,run = run + @p_run
		,last_run = @p_last_run
		,speedometer_start_indctn = @p_speedometer_start_indctn
		,speedometer_end_indctn = @p_speedometer_end_indctn
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
