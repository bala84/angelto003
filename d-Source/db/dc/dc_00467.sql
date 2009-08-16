
:r ./../_define.sql

:setvar dc_number 00467
:setvar dc_description "unique index on card number fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   20.05.2009 VLavrentiev   unique index on card number fixed
*******************************************************************************/ 
use [$(db_name)]
GO


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _drop_chis_all_objects.sql                         ='
PRINT '==============================================================================='
PRINT ' '
go

:r _drop_chis_all_objects.sql



PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


drop INDEX [dbo].[CCAR_CAR].[u_ccar_car_state_number_card_number]
go

CREATE UNIQUE NONCLUSTERED INDEX [u_ccar_car_card_number] ON [dbo].[CCAR_CAR] 
(
	[card_number] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF)
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




