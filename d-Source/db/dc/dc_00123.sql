:r ./../_define.sql

:setvar dc_number 00123                  
:setvar dc_description "decimal fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.03.2008 VLavrentiev  decimal fixed
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




alter table dbo.CCAR_CONDITION
alter column run decimal(18,13) not null
go

alter table dbo.CCAR_CONDITION
alter column speedometer_start_indctn decimal(18,13) not null
go

alter table dbo.CCAR_CONDITION
alter column speedometer_end_indctn decimal(18,13) not null
go


alter table dbo.CCAR_CONDITION
alter column last_run decimal(18,13) not null
go


alter table dbo.CCAR_CONDITION
alter column fuel_start_left decimal(18,13) not null
go


alter table dbo.CCAR_CONDITION
alter column fuel_end_left decimal(18,13) not null
go


alter table dbo.CCAR_CONDITION
alter column overrun decimal(18,13) null
go


alter table dbo.CCAR_FUEL_MODEL
alter column fuel_norm decimal(18,13) not null
go


alter table dbo.CDRV_DRIVER_LIST
alter column fuel_exp decimal(18,13) not null
go


alter table dbo.CDRV_DRIVER_LIST
alter column speedometer_start_indctn decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column speedometer_end_indctn decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column fuel_start_left decimal(18,13)
go

alter table dbo.CDRV_DRIVER_LIST
alter column fuel_end_left decimal(18,13)
go

alter table dbo.CDRV_DRIVER_LIST
alter column fuel_gived decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column fuel_return decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column fuel_addtnl_exp decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column run decimal(18,13)
go

alter table dbo.CDRV_DRIVER_LIST
alter column fuel_consumption decimal(18,13)
go


alter table dbo.CDRV_DRIVER_LIST
alter column run decimal(18,13) not null
go


alter table dbo.CDRV_DRIVER_LIST
alter column run decimal(18,13) not null
go


drop index dbo.chis_condition.i_run_chis_condition
go

drop index dbo.chis_condition.i_speedometer_start_indctn_chis_condition
go

drop index dbo.chis_condition.i_speedometer_end_indctn_chis_condition
go

drop index dbo.chis_condition.i_last_run_chis_condition
go


drop index dbo.chis_condition.i_overrun_chis_condition
go




alter table dbo.CHIS_CONDITION
alter column speedometer_start_indctn decimal(18,13) not null
go

alter table dbo.CHIS_CONDITION
alter column speedometer_end_indctn decimal(18,13) not null
go


alter table dbo.CHIS_CONDITION
alter column last_run decimal(18,13) not null
go


alter table dbo.CHIS_CONDITION
alter column fuel_start_left decimal(18,13) not null
go


alter table dbo.CHIS_CONDITION
alter column fuel_end_left decimal(18,13) not null
go


alter table dbo.CHIS_CONDITION
alter column overrun decimal(18,13)
go


/*==============================================================*/
/* Index: i_run_chis_condition                                  */
/*==============================================================*/
create index i_run_chis_condition on CHIS_CONDITION (
run DESC
)
on "$(db_name)_IDX"
go


/*==============================================================*/
/* Index: i_speedometer_start_indctn_chis_condition             */
/*==============================================================*/
create index i_speedometer_start_indctn_chis_condition on CHIS_CONDITION (
speedometer_start_indctn DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_speedometer_end_indctn_chis_condition               */
/*==============================================================*/
create index i_speedometer_end_indctn_chis_condition on CHIS_CONDITION (
speedometer_end_indctn DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_last_run_chis_condition                             */
/*==============================================================*/
create index i_last_run_chis_condition on CHIS_CONDITION (
last_run DESC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: i_fuel_start_left_chis_condition                      */
/*==============================================================*/
create index i_fuel_start_left_chis_condition on CHIS_CONDITION (
last_run DESC
)
on "$(db_name)_IDX"
go


/*==============================================================*/
/* Index: i_fuel_end_left_chis_condition   		        */
/*==============================================================*/
create index i_fuel_end_left_chis_condition on CHIS_CONDITION (
last_run DESC
)
on "$(db_name)_IDX"
go




/*==============================================================*/
/* Index: i_overrun_chis_condition                             */
/*==============================================================*/
create index i_overrun_chis_condition on CHIS_CONDITION (
last_run DESC
)
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
