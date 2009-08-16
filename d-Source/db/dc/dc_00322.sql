:r ./../_define.sql

:setvar dc_number 00322
:setvar dc_description "repair time procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.06.2008 VLavrentiev  repair time procs added
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


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(80, 'CAR_REPAIR_TIME', 'Значение времени ремонта')
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(81, 'CAR_RUN_TIME', 'Значение времени наработки на отказ')
insert into dbo.CREP_VALUE(id, short_name, full_name)
values(82, 'CAR_RUN_TIME_AFTER_TO', 'Значение времени наработки на отказ после ТО')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values(80, 'CAR_REPAIR_TIME', 'Значение времени ремонта')
insert into dbo.CSYS_CONST(id, name, description)
values(81, 'CAR_RUN_TIME', 'Значение времени наработки на отказ')
insert into dbo.CSYS_CONST(id, name, description)
values(82, 'CAR_RUN_TIME_AFTER_TO', 'Значение времени наработки на отказ после ТО')
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVREP_CAR_REPAIR_TIME_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о времени ремонта и времени наработки на отказ
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_month_created		datetime	  = null
	,@p_value_id			numeric(38,0)
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0) = null
	,@p_car_state_sname		varchar(30)	  = null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_day_1				 decimal(18,9) = 0
	,@p_day_2				 decimal(18,9) = 0
	,@p_day_3				 decimal(18,9) = 0
	,@p_day_4				 decimal(18,9) = 0
	,@p_day_5				 decimal(18,9) = 0
	,@p_day_6				 decimal(18,9) = 0
	,@p_day_7				 decimal(18,9) = 0
	,@p_day_8				 decimal(18,9) = 0
	,@p_day_9			     decimal(18,9) = 0
	,@p_day_10				 decimal(18,9) = 0
	,@p_day_11				 decimal(18,9) = 0
	,@p_day_12				 decimal(18,9) = 0
	,@p_day_13				 decimal(18,9) = 0
	,@p_day_14				 decimal(18,9) = 0
	,@p_day_15				 decimal(18,9) = 0
	,@p_day_16				 decimal(18,9) = 0
	,@p_day_17				 decimal(18,9) = 0
	,@p_day_18				 decimal(18,9) = 0
	,@p_day_19				 decimal(18,9) = 0
	,@p_day_20				 decimal(18,9) = 0
	,@p_day_21				 decimal(18,9) = 0
	,@p_day_22				 decimal(18,9) = 0
	,@p_day_23				 decimal(18,9) = 0
	,@p_day_24				 decimal(18,9) = 0
	,@p_day_25				 decimal(18,9) = 0
	,@p_day_26				 decimal(18,9) = 0
	,@p_day_27				 decimal(18,9) = 0
	,@p_day_28				 decimal(18,9) = 0
	,@p_day_29				 decimal(18,9) = 0
	,@p_day_30				 decimal(18,9) = 0
	,@p_day_31				 decimal(18,9) = 0
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_month_created = dbo.usfUtils_TimeToZero(@p_month_created)
 

insert into dbo.CREP_CAR_REPAIR_TIME_DAY
	  (month_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, organization_id, organization_sname
			, sys_comment, sys_user_created, sys_user_modified)
select @p_month_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_day_1, @p_day_2, @p_day_3, @p_day_4
			,@p_day_5, @p_day_6, @p_day_7, @p_day_8, @p_day_9, @p_day_10
			,@p_day_11, @p_day_12, @p_day_13, @p_day_14, @p_day_15, @p_day_16
			,@p_day_17, @p_day_18, @p_day_19, @p_day_20, @p_day_21, @p_day_22
			,@p_day_23, @p_day_24, @p_day_25, @p_day_26, @p_day_27, @p_day_28
			,@p_day_29, @p_day_30, @p_day_31
			,@p_organization_id, @p_organization_sname
	        ,@p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_REPAIR_TIME_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_CAR_REPAIR_TIME_DAY
		 set
		    state_number = @p_state_number
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,day_1 = @p_day_1
		   ,day_2 = @p_day_2
		   ,day_3 = @p_day_3
		   ,day_4 = @p_day_4
		   ,day_5 = @p_day_5
		   ,day_6 = @p_day_6
		   ,day_7 = @p_day_7
		   ,day_8 = @p_day_8
		   ,day_9 = @p_day_9
		   ,day_10 = @p_day_10
		   ,day_11 = @p_day_11
		   ,day_12 = @p_day_12
		   ,day_13 = @p_day_13
		   ,day_14 = @p_day_14
		   ,day_15 = @p_day_15
		   ,day_16 = @p_day_16
		   ,day_17 = @p_day_17
		   ,day_18 = @p_day_18
		   ,day_19 = @p_day_19
		   ,day_20 = @p_day_20
		   ,day_21 = @p_day_21
		   ,day_22 = @p_day_22
		   ,day_23 = @p_day_23
		   ,day_24 = @p_day_24
		   ,day_25 = @p_day_25
		   ,day_26 = @p_day_26
		   ,day_27 = @p_day_27
		   ,day_28 = @p_day_28
		   ,day_29 = @p_day_29
		   ,day_30 = @p_day_30
		   ,day_31 = @p_day_31
			,organization_id = @p_organization_id
			,organization_sname = @p_organization_sname
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVREP_CAR_REPAIR_TIME_DAY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_CAR_REPAIR_TIME_DAY_SaveById] TO [$(db_app_user)]
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




