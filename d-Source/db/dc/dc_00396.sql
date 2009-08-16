:r ./../_define.sql

:setvar dc_number 00396
:setvar dc_description "added consts for tables"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.11.2008 VLavrentiev  added consts for tables
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



insert into dbo.csys_const(id, name, description)   values (601, 'dbo.CCAR_ADDTNL_TS_TYPE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (602, 'dbo.CCAR_CAR', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (603, 'dbo.CCAR_CAR_KIND', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (604, 'dbo.CCAR_CAR_MARK', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (605, 'dbo.CCAR_CAR_RETURN', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (606, 'dbo.CCAR_CAR_RETURN_REASON_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (607, 'dbo.CCAR_CAR_STATE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (608, 'dbo.CCAR_CAR_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (609, 'dbo.CCAR_CONDITION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (610, 'dbo.CCAR_FUEL_MODEL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (611, 'dbo.CCAR_FUEL_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (612, 'dbo.CCAR_REPAIR_TYPE_RELATION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (613, 'dbo.CCAR_TS_TYPE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (614, 'dbo.CCAR_TS_TYPE_RELATION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (615, 'dbo.CCAR_TS_TYPE_ROUTE_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (616, 'dbo.CCAR_TS_TYPE_ROUTE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (617, 'dbo.CDEV_DEVICE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (618, 'dbo.CDRV_CONTROL_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (619, 'dbo.CDRV_DRIVER_CONTROL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (620, 'dbo.CDRV_DRIVER_LIST', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (621, 'dbo.CDRV_DRIVER_LIST_STATE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (622, 'dbo.CDRV_DRIVER_LIST_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (623, 'dbo.CDRV_DRIVER_PLAN', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (624, 'dbo.CDRV_DRIVER_PLAN_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (625, 'dbo.CDRV_MONTH_PLAN', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (626, 'dbo.CDRV_TRAILER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (627, 'dbo.CLOC_ABBREVIATION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (628, 'dbo.CLOC_COUNTRY', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (629, 'dbo.CLOC_DISTRICT', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (630, 'dbo.CLOC_LOCATION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (631, 'dbo.CLOC_LOCATION_LINK', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (632, 'dbo.CLOC_LOCATION_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (633, 'dbo.CLOC_REGION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (634, 'dbo.CLOC_SETTLEMENT', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (635, 'dbo.CLOC_STATE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (636, 'dbo.CLOC_STREET', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (637, 'dbo.CNOT_NOTE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (638, 'dbo.CNOT_NOTE_LINK', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (639, 'dbo.CNOT_NOTE_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (640, 'dbo.CPRT_EMPLOYEE_EVENT', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (641, 'dbo.CPRT_EMPLOYEE_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (642, 'dbo.CPRT_GROUP', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (643, 'dbo.CPRT_PARTY', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (644, 'dbo.CPRT_USER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (645, 'dbo.CPRT_USER_GROUP', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (646, 'dbo.CRPR_REPAIR_BILL_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (647, 'dbo.CRPR_REPAIR_BILL_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (648, 'dbo.CRPR_REPAIR_TYPE_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (649, 'dbo.CRPR_REPAIR_TYPE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (650, 'dbo.CRPR_REPAIR_TYPE_MASTER_KIND', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (651, 'dbo.CRPR_REPAIR_ZONE_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (652, 'dbo.CRPR_REPAIR_ZONE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (653, 'dbo.CUSR_AUTHENTICATION', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (654, 'dbo.CWRH_GOOD_CATEGORY', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (655, 'dbo.CWRH_GOOD_CATEGORY_PRICE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (656, 'dbo.CWRH_GOOD_CATEGORY_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (657, 'dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (658, 'dbo.CWRH_WAREHOUSE_ITEM', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (659, 'dbo.CWRH_WAREHOUSE_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (660, 'dbo.CWRH_WRH_DEMAND_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (661, 'dbo.CWRH_WRH_DEMAND_MASTER_TYPE', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (662, 'dbo.CWRH_WRH_INCOME_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (663, 'dbo.CWRH_WRH_INCOME_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (664, 'dbo.CWRH_WRH_ORDER_DETAIL', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (665, 'dbo.CWRH_WRH_ORDER_MASTER', 'Generated ids for table')
insert into dbo.csys_const(id, name, description)   values (666, 'dbo.CWRH_WRH_ORDER_MASTER_TYPE', 'Generated ids for table')
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql


