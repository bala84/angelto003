:r ./../_define.sql
:setvar dc_number 00058
:setvar dc_description "VCAR fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    28.02.2008 VLavrentiev  VCAR fixed   
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


alter table dbo.CCAR_CAR
add begin_run decimal not  null default 0.0
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������',
   'user', @CurrentUser, 'table', 'CCAR_CAR', 'column', 'begin_run'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ����������� �������� CAR
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	������� ����� �������
*******************************************************************************/
()
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
		  ,a.state_number
		  ,a.speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,b.short_name as car_type_sname
		  ,a.car_state_id
		  ,c.short_name as car_state_sname
		  ,a.car_mark_id 
		  ,d.short_name as car_mark_sname
		  ,a.car_model_id
		  ,e.short_name as car_model_sname
		  ,a.fuel_type_id	
		  ,f.short_name as fuel_type_sname
		  ,a.car_kind_id
		  ,g.short_name as car_kind_sname
		  ,a.begin_run
      FROM dbo.CCAR_CAR as a
		JOIN dbo.CCAR_CAR_KIND as g on a.car_kind_id = g.id
		JOIN dbo.CCAR_CAR_TYPE as b on a.car_type_id = b.id	
		JOIN dbo.CCAR_CAR_MARK as d on a.car_mark_id = d.id
		JOIN dbo.CCAR_CAR_MODEL as e on a.car_model_id = e.id
		JOIN dbo.CCAR_FUEL_TYPE as f on a.fuel_type_id = f.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on a.car_state_id = c.id
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/

AS
SET NOCOUNT ON
  

       SELECT 
			a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.state_number
		  ,a.speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,a.car_type_sname
		  ,a.car_state_id
		  ,a.car_state_sname
		  ,a.car_mark_id 
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
		  ,a.fuel_type_id	
		  ,a.fuel_type_sname
		  ,a.car_kind_id
		  ,a.car_kind_sname
		  ,b.fuel_norm
		  ,a.begin_run
	FROM dbo.utfVCAR_CAR() as a
	JOIN dbo.utfVCAR_FUEL_TYPE() as b on a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (12,1,2)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (3,4,5)
														   then dbo.usfConst('SPRING_SEASON')
														   when month(getdate()) in (6,7,8)
														   then dbo.usfConst('SUMMER_SEASON')
														   when month(getdate()) in (9,10,11)
														   then dbo.usfConst('AUTUMN_SEASON')
													  end

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ �� ����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_state_number		varchar(20)
    ,@p_speedometer_idctn   decimal         = 0.0
    ,@p_car_type_id			numeric(38,0)
	,@p_car_state_id		numeric(38,0)   = null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_model_id		numeric(38,0)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_car_kind_id			numeric(38,0)
	,@p_begin_run			decimal			= 0.0
	,@p_sys_comment			varchar(2000)	= '-'
    ,@p_sys_user			varchar(30)		= null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_begin_run is null)
	set @p_begin_run = 0.0

	 if (@p_speedometer_idctn is null)
	set @p_speedometer_idctn = 0.0

       -- ���� ���������
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date
			,fuel_type_id, car_kind_id, begin_run, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- ���� ������� ������������
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		,car_state_id = @p_car_state_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
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