:r ./../_define.sql

:setvar dc_number 00129                  
:setvar dc_description "car kind added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    24.03.2008 VLavrentiev  car kind added
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


set identity_insert dbo.CCAR_CAR_KIND on
insert into dbo.CCAR_CAR_KIND (id, short_name, full_name)
values(52, 'Дежурный', 'Дежурный')
insert into dbo.CCAR_CAR_KIND (id, short_name, full_name)
values(53, 'VIP-трансфер', 'VIP-трансфер')
set identity_insert dbo.CCAR_CAR_KIND off
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
