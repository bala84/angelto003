:r ./../_define.sql
:setvar dc_number 00080
:setvar dc_description "indexes added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    05.03.2008 VLavrentiev  indexes added
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

/*==============================================================*/
/* Index: u_state_number_car                                    */
/*==============================================================*/
create unique index u_state_number_car on CCAR_CAR (
state_number ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_type_id_car                                   */
/*==============================================================*/
create index ifk_car_type_id_car on CCAR_CAR (
car_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_state_id_car                                  */
/*==============================================================*/
create index ifk_car_state_id_car on CCAR_CAR (
car_state_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_mark_id_car                                   */
/*==============================================================*/
create index ifk_car_mark_id_car on CCAR_CAR (
car_mark_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_model_id_car                                  */
/*==============================================================*/
create index ifk_car_model_id_car on CCAR_CAR (
car_model_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_fuel_type_id_car                                  */
/*==============================================================*/
create index ifk_fuel_type_id_car on CCAR_CAR (
fuel_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_kind_id_car                                   */
/*==============================================================*/
create index ifk_car_kind_id_car on CCAR_CAR (
car_kind_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_car_kind                                 */
/*==============================================================*/
create unique index u_short_name_car_kind on CCAR_CAR_KIND (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_car_mark                                 */
/*==============================================================*/
create unique index u_short_name_car_mark on CCAR_CAR_MARK (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_mark_id_car_model                                 */
/*==============================================================*/
create index ifk_mark_id_car_model on CCAR_CAR_MODEL (
mark_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_mark_id_car_model                        */
/*==============================================================*/
create unique index u_short_name_mark_id_car_model on CCAR_CAR_MODEL (
short_name ASC,
mark_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_car_state                                */
/*==============================================================*/
create unique index u_short_name_car_state on CCAR_CAR_STATE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_car_type                                 */
/*==============================================================*/
create unique index u_short_name_car_type on CCAR_CAR_TYPE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_id_car_condition                              */
/*==============================================================*/
create index ifk_car_id_car_condition on CCAR_CONDITION (
car_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_ts_type_master_id_car_condition                   */
/*==============================================================*/
create index ifk_ts_type_master_id_car_condition on CCAR_CONDITION (
ts_type_master_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_employee_id_car_condition                         */
/*==============================================================*/
create index ifk_employee_id_car_condition on CCAR_CONDITION (
employee_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_fuel_type_id_fuel_model                           */
/*==============================================================*/
create index ifk_fuel_type_id_fuel_model on CCAR_FUEL_MODEL (
fuel_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_model_id_fuel_model                           */
/*==============================================================*/
create index ifk_car_model_id_fuel_model on CCAR_FUEL_MODEL (
car_model_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_season_fuel_type                         */
/*==============================================================*/
create unique index u_short_name_season_fuel_type on CCAR_FUEL_TYPE (
short_name ASC,
season ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_ts_type_good_ctgry_ts_type_dtl                      */
/*==============================================================*/
create unique index u_ts_type_good_ctgry_ts_type_dtl on CCAR_TS_TYPE_DETAIL (
ts_type_master_id ASC,
good_category_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_car_mark_model_ts_type                   */
/*==============================================================*/
create unique index u_short_name_car_mark_model_ts_type on CCAR_TS_TYPE_MASTER (
short_name ASC,
car_mark_id ASC,
car_model_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_device                                   */
/*==============================================================*/
create unique index u_short_name_device on CDEV_DEVICE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_control_type                             */
/*==============================================================*/
create unique index u_short_name_control_type on CDRV_CONTROL_TYPE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_car_id_driver_list                                */
/*==============================================================*/
create index ifk_car_id_driver_list on CDRV_DRIVER_LIST (
car_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_number_driver_list                                  */
/*==============================================================*/
create unique index u_number_driver_list on CDRV_DRIVER_LIST (
number ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_driver_list_state_id_drv_list                     */
/*==============================================================*/
create index ifk_driver_list_state_id_drv_list on CDRV_DRIVER_LIST (
driver_list_state_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_driver_list_type_id_drv_list                      */
/*==============================================================*/
create index ifk_driver_list_type_id_drv_list on CDRV_DRIVER_LIST (
driver_list_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_fuel_type_id_driver_list                          */
/*==============================================================*/
create index ifk_fuel_type_id_driver_list on CDRV_DRIVER_LIST (
fuel_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_organization_id_driver_list                       */
/*==============================================================*/
create index ifk_organization_id_driver_list on CDRV_DRIVER_LIST (
organization_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_employee1_id_driver_list                          */
/*==============================================================*/
create index ifk_employee1_id_driver_list on CDRV_DRIVER_LIST (
employee1_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: ifk_employee2_id_driver_list                          */
/*==============================================================*/
create index ifk_employee2_id_driver_list on CDRV_DRIVER_LIST (
employee2_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_drv_list_state                           */
/*==============================================================*/
create unique index u_short_name_drv_list_state on CDRV_DRIVER_LIST_STATE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_drv_list_type                            */
/*==============================================================*/
create unique index u_short_name_drv_list_type on CDRV_DRIVER_LIST_TYPE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_employee                                            */
/*==============================================================*/
create unique index u_employee on CPRT_EMPLOYEE (
organization_id ASC,
person_id ASC,
employee_type_id ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_short_name_emp_type                                 */
/*==============================================================*/
create unique index u_short_name_emp_type on CPRT_EMPLOYEE_TYPE (
short_name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_name_group                                          */
/*==============================================================*/
create unique index u_name_group on CPRT_GROUP (
name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_name_organization                                   */
/*==============================================================*/
create unique index u_name_organization on CPRT_ORGANIZATION (
name ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_username_user                                       */
/*==============================================================*/
create unique index u_username_user on CPRT_USER (
username ASC
)
on "$(db_name)_IDX"
go

/*==============================================================*/
/* Index: u_good_mark_short_name_gd_ctgry                       */
/*==============================================================*/
create unique index u_good_mark_short_name_gd_ctgry on CWRH_GOOD_CATEGORY (
good_mark ASC,
short_name ASC
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
