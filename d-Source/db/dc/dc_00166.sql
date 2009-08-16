:r ./../_define.sql

:setvar dc_number 00166                  
:setvar dc_description "new report select added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.04.2008 VLavrentiev  new report select added
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

ALTER PROCEDURE [dbo].[uspVREP_CAR_HOUR_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о количестве проработанных часов и 
** и среднем количестве проработанных часов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
)
AS
SET NOCOUNT ON
	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
  
       SELECT  
		   month_created
		 , value_id
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , begin_mntnc_date
		 , fuel_type_id
		 , fuel_type_sname
		 , car_kind_id
		 , car_kind_sname
		 , convert(decimal(18,0),day_1/60) as day_1
		 , convert(decimal(18,0),day_2/60) as day_2, convert(decimal(18,0),day_3/60) as day_3
		 , convert(decimal(18,0),day_4/60) as day_4, convert(decimal(18,0),day_5/60) as day_5
		 , convert(decimal(18,0),day_6/60) as day_6, convert(decimal(18,0),day_7/60) as day_7
		 , convert(decimal(18,0),day_8/60) as day_8, convert(decimal(18,0),day_9/60) as day_9
		 , convert(decimal(18,0),day_10/60) as day_10, convert(decimal(18,0),day_11/60) as day_11
		 , convert(decimal(18,0),day_12/60) as day_12, convert(decimal(18,0),day_13/60) as day_13
		 , convert(decimal(18,0),day_14/60) as day_14, convert(decimal(18,0),day_15/60) as day_15
		 , convert(decimal(18,0),day_16/60) as day_16, convert(decimal(18,0),day_17/60) as day_17
		 , convert(decimal(18,0),day_18/60) as day_18, convert(decimal(18,0),day_19/60) as day_19
		 , convert(decimal(18,0),day_20/60) as day_20, convert(decimal(18,0),day_21/60) as day_21
		 , convert(decimal(18,0),day_22/60) as day_22, convert(decimal(18,0),day_23/60) as day_23
		 , convert(decimal(18,0),day_24/60) as day_24, convert(decimal(18,0),day_25/60) as day_25
		 , convert(decimal(18,0),day_26/60) as day_26, convert(decimal(18,0),day_27/60) as day_27
		 , convert(decimal(18,0),day_28/60) as day_28, convert(decimal(18,0),day_29/60) as day_29
		 , convert(decimal(18,0),day_30/60) as day_30, convert(decimal(18,0),day_31/60) as day_31
	FROM dbo.utfVREP_CAR_DAY()
	where month_created between  @p_start_date and @p_end_date
	  and value_id = @v_value_id

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_CAR_KM_AMOUNT_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о cуммарном пробеге и 
** и среднем пробеге
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_time_interval	smallint = null
)
AS
SET NOCOUNT ON

	declare
		@v_value_id numeric(38,0)

 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

 if (@p_time_interval is null)
  set @p_time_interval = dbo.usfConst('DAY_BY_MONTH_REPORT')

  set @v_value_id = dbo.usfConst('CAR_KM_AMOUNT')
  
       SELECT  
		   month_created
		 , value_id
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , begin_mntnc_date
		 , fuel_type_id
		 , fuel_type_sname
		 , car_kind_id
		 , car_kind_sname
		 , convert(decimal(18,0),day_1) as day_1
		 , convert(decimal(18,0),day_2) as day_2, convert(decimal(18,0),day_3) as day_3
		 , convert(decimal(18,0),day_4) as day_4, convert(decimal(18,0),day_5) as day_5
		 , convert(decimal(18,0),day_6) as day_6, convert(decimal(18,0),day_7) as day_7
		 , convert(decimal(18,0),day_8) as day_8, convert(decimal(18,0),day_9) as day_9
		 , convert(decimal(18,0),day_10) as day_10, convert(decimal(18,0),day_11) as day_11
		 , convert(decimal(18,0),day_12) as day_12, convert(decimal(18,0),day_13) as day_13
		 , convert(decimal(18,0),day_14) as day_14, convert(decimal(18,0),day_15) as day_15
		 , convert(decimal(18,0),day_16) as day_16, convert(decimal(18,0),day_17) as day_17
		 , convert(decimal(18,0),day_18) as day_18, convert(decimal(18,0),day_19) as day_19
		 , convert(decimal(18,0),day_20) as day_20, convert(decimal(18,0),day_21) as day_21
		 , convert(decimal(18,0),day_22) as day_22, convert(decimal(18,0),day_23) as day_23
		 , convert(decimal(18,0),day_24) as day_24, convert(decimal(18,0),day_25) as day_25
		 , convert(decimal(18,0),day_26) as day_26, convert(decimal(18,0),day_27) as day_27
		 , convert(decimal(18,0),day_28) as day_28, convert(decimal(18,0),day_29) as day_29
		 , convert(decimal(18,0),day_30) as day_30, convert(decimal(18,0),day_31) as day_31
	FROM dbo.utfVREP_CAR_DAY()
	where month_created between  @p_start_date and @p_end_date
	  and value_id = @v_value_id

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_CAR_KM_AMOUNT_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_KM_AMOUNT_SelectAll] TO [$(db_app_user)]
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

