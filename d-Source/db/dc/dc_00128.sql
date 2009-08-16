:r ./../_define.sql

:setvar dc_number 00128                  
:setvar dc_description "fuel_type fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    24.03.2008 VLavrentiev  fuel_type fixed
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


drop index dbo.CCAR_FUEL_TYPE.u_short_name_season_fuel_type
go



/*==============================================================*/
/* Index: u_fuel_type_car_model_fuel_model                      */
/*==============================================================*/
create unique index u_fuel_type_car_model_fuel_model 
on dbo.CCAR_FUEL_MODEL (fuel_type_id, car_model_id)
on "$(db_name)_IDX"
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
