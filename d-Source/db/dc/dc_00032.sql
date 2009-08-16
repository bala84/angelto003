:r ./../_define.sql
:setvar dc_number 00032
:setvar dc_description "uspVCAR_CONDITION_SelectbyCar_Type_Id proc added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    23.02.2008 VLavrentiev  uspVCAR_CONDITION_SelectbyCar_Type_Id proc added   
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

PRINT ' '
PRINT 'Вставка констант'
GO

set identity_insert dbo.CCAR_CAR_TYPE on
insert into dbo.CCAR_CAR_TYPE (id, short_name, full_name)
values(30, 'Легковой','Легковой')
insert into dbo.CCAR_CAR_TYPE (id, short_name, full_name)
values(31, 'Грузовой','Грузовой')
set identity_insert dbo.CCAR_CAR_TYPE off
go

insert into dbo.CSYS_CONST (id,name,description)
values(30,'CAR','Ид типа легкового автомобиля')
go

insert into dbo.CSYS_CONST (id,name,description)
values(31,'FREIGHT','Ид типа грузового автомобиля')
go



PRINT ' '
PRINT 'Adding uspVCAR_CONDITION_SelectbyCar_Type_Id...'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVCAR_CONDITION_SelectbyCar_Type_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о состоянии автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date	datetime			
,@p_end_date	datetime
,@p_car_type_id numeric(38,0)	
)
AS

    set @p_start_date = getdate() - 7
    set @p_end_date   = getdate() 		
	
    SET NOCOUNT ON
  
       SELECT 
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id	  
		  ,state_number
		  ,ts_type_master_id
		  ,ts_type_name
		  ,car_mark_model_name
		  ,employee_id
		  ,FIO
		  ,car_state_id
		  ,car_state_name
		  ,car_type_id
		  ,run
	FROM dbo.utfVCAR_CONDITION
				()
	WHERE car_type_id = @p_car_type_id
	  AND sys_date_modified >= @p_start_date
	  AND sys_date_modified <= @p_end_date	 

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_CONDITION_SelectbyCar_Type_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_CONDITION_SelectbyCar_Type_Id] TO [$(db_app_user)]
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
