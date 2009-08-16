:r ./../_define.sql
:setvar dc_number 00106                   
:setvar dc_description "check_ts_type fixed#4"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.03.2008 VLavrentiev  check_ts_type fixed#4
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
** ������� ��������� ����������� ��
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	������� ����� �������
*******************************************************************************/
(
 @p_run						decimal
,@p_car_id					numeric (38,0)
,@p_last_ts_type_master_id	numeric (38,0) = null			
)
RETURNS numeric(38,0)
AS
BEGIN

DECLARE @p_Result_id numeric(38,0), @v_periodicity numeric(38,0)
    
		SELECT @p_Result_id = id, @v_periodicity = periodicity
		FROM
		(SELECT TOP(1) id, periodicity, tolerance
		FROM dbo.utfVCAR_TS_TYPE_MASTER() as a
       WHERE /*(case when @p_run/a.periodicity <= 1
				   then @p_run 
				   when @p_run/a.periodicity > 1
				   then (@p_run - (floor(@p_run/a.periodicity)*a.periodicity))
			    end >= (a.periodicity - a.tolerance))*/
			(
			(((ceiling(@p_run/a.periodicity)*a.periodicity) - a.tolerance) <= @p_run)
			--or
		---	((floor(@p_run/a.periodicity)*a.periodicity) >= @p_run)
			)
	    AND 
		EXISTS
		(select 1 from dbo.utfVCAR_CAR() as b
		   where b.id = @p_car_id
		    and a.car_mark_id = b.car_mark_id
		    and a.car_model_id = b.car_model_id)	   
		ORDER BY periodicity desc) as a
		WHERE NOT EXISTS
		(select 1 from dbo.CHIS_CONDITION as c
		where c.car_id = @p_car_id
		and c.date_created <= getdate()
		and c.last_ts_type_master_id is not null 
		and c.last_ts_type_master_id = a.id
		and c.run >= (@p_run - a.tolerance) 
		and c.run <= (ceiling(@p_run/a.periodicity)*a.periodicity)
		)
		--and c.run >= @p_run)


RETURN @p_Result_id

END
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
