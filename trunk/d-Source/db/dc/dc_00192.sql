:r ./../_define.sql

:setvar dc_number 00192
:setvar dc_description "unique indexed added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    14.04.2008 VLavrentiev  unique indexed added
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



create unique index u_rpr_type_master_gd_ctgry_id_rpr_type_d
on dbo.CRPR_REPAIR_TYPE_DETAIL(repair_type_master_id, good_category_id)
on $(fg_idx_name)
go

create unique index u_number_wrh_type_id_wrh_inc_m
on dbo.CWRH_WRH_INCOME_MASTER(number, warehouse_type_id)
on $(fg_idx_name)
go


create unique index u_wrh_inc_master_gd_ctgry_id_wrh_inc_d
on dbo.CWRH_WRH_INCOME_DETAIL(wrh_income_master_id, good_category_id)
on $(fg_idx_name)
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


