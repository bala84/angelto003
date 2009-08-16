:r ./../_define.sql

:setvar dc_number 00259
:setvar dc_description "save report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    24.05.2008 VLavrentiev  save report fixed
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_CAR_HOUR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ����� � ��� �� ����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_day_created			datetime	  = null
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
	,@p_begin_mntnc_date	datetime	  = null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_hour_0				decimal(18,9) = 0
	,@p_hour_1				decimal(18,9) = 0	
	,@p_hour_2				decimal(18,9) = 0
	,@p_hour_3				decimal(18,9) = 0
	,@p_hour_4				decimal(18,9) = 0
	,@p_hour_5				decimal(18,9) = 0
	,@p_hour_6				decimal(18,9) = 0
	,@p_hour_7				decimal(18,9) = 0
	,@p_hour_8				decimal(18,9) = 0
	,@p_hour_9				decimal(18,9) = 0
	,@p_hour_10				decimal(18,9) = 0
	,@p_hour_11				decimal(18,9) = 0
	,@p_hour_12				decimal(18,9) = 0
	,@p_hour_13				decimal(18,9) = 0
	,@p_hour_14				decimal(18,9) = 0
	,@p_hour_15				decimal(18,9) = 0
	,@p_hour_16				decimal(18,9) = 0
	,@p_hour_17				decimal(18,9) = 0
	,@p_hour_18				decimal(18,9) = 0
	,@p_hour_19				decimal(18,9) = 0
	,@p_hour_20				decimal(18,9) = 0
	,@p_hour_21				decimal(18,9) = 0
	,@p_hour_22				decimal(18,9) = 0
	,@p_hour_23				decimal(18,9) = 0
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

	declare @v_value decimal(18,9)
		   ,@v_month_created datetime

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_day_created is null)
	  set @p_day_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_day_created = dbo.usfUtils_TimeToZero(@p_day_created) 
	 if (@p_hour_0 is null)
	set @p_hour_0 = 0
	 if (@p_hour_1 is null)
	set @p_hour_1 = 0
	 if (@p_hour_2 is null)
	set @p_hour_2 = 0
	 if (@p_hour_3 is null)
	set @p_hour_3 = 0
	 if (@p_hour_4 is null)
	set @p_hour_4 = 0
	 if (@p_hour_5 is null)
	set @p_hour_5 = 0
	 if (@p_hour_6 is null)
	set @p_hour_6 = 0
	 if (@p_hour_7 is null)
	set @p_hour_7 = 0
	 if (@p_hour_8 is null)
	set @p_hour_8 = 0
	 if (@p_hour_9 is null)
	set @p_hour_9 = 0
	 if (@p_hour_10 is null)
	set @p_hour_10 = 0
	 if (@p_hour_11 is null)
	set @p_hour_11 = 0
	 if (@p_hour_12 is null)
	set @p_hour_12 = 0
	 if (@p_hour_13 is null)
	set @p_hour_13 = 0
	 if (@p_hour_14 is null)
	set @p_hour_14 = 0
	 if (@p_hour_15 is null)
	set @p_hour_15 = 0
	 if (@p_hour_16 is null)
	set @p_hour_16 = 0
	 if (@p_hour_17 is null)
	set @p_hour_17 = 0
	 if (@p_hour_18 is null)
	set @p_hour_18 = 0
	 if (@p_hour_19 is null)
	set @p_hour_19 = 0
	 if (@p_hour_20 is null)
	set @p_hour_20 = 0
	 if (@p_hour_21 is null)
	set @p_hour_21 = 0
	 if (@p_hour_22 is null)
	set @p_hour_22 = 0
	 if (@p_hour_23 is null)
	set @p_hour_23 = 0


    insert into dbo.CREP_CAR_HOUR
            (day_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, hour_0, hour_1, hour_2
			,hour_3, hour_4, hour_5, hour_6
			,hour_7, hour_8, hour_9, hour_10
			,hour_11, hour_12, hour_13, hour_14
			,hour_15, hour_16, hour_17, hour_18
			,hour_19, hour_20, hour_21, hour_22
			,hour_23, speedometer_start_indctn, speedometer_end_indctn
			,fuel_start_left, fuel_end_left
			,sys_comment, sys_user_created, sys_user_modified)
	select   @p_day_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @p_hour_0, @p_hour_1, @p_hour_2
			,@p_hour_3, @p_hour_4, @p_hour_5, @p_hour_6
			,@p_hour_7, @p_hour_8, @p_hour_9, @p_hour_10
			,@p_hour_11, @p_hour_12, @p_hour_13, @p_hour_14
			,@p_hour_15, @p_hour_16, @p_hour_17, @p_hour_18
			,@p_hour_19, @p_hour_20, @p_hour_21, @p_hour_22
			,@p_hour_23, @p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_start_left, @p_fuel_end_left
			,@p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_CAR_HOUR as b
		 where b.day_created = @p_day_created
		   and b.value_id = @p_value_id
		   and b.car_id = @p_car_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_CAR_HOUR 
		 set
			 state_number = @p_state_number
			,car_id = @p_car_id
			,car_type_id = @p_car_type_id
			,car_type_sname = @p_car_type_sname
			,car_state_id = @p_car_state_id	
			,car_state_sname = @p_car_state_sname
			,car_mark_id = @p_car_mark_id
			,car_mark_sname = @p_car_mark_sname
			,car_model_id = @p_car_model_id
			,car_model_sname = @p_car_model_sname
			,begin_mntnc_date = @p_begin_mntnc_date
			,fuel_type_id = @p_fuel_type_id
			,fuel_type_sname = @p_fuel_type_sname
			,car_kind_id = @p_car_kind_id
			,car_kind_sname = @p_car_kind_sname
			,hour_0 = @p_hour_0
			,hour_1 = @p_hour_1
			,hour_2 = @p_hour_2
			,hour_3 = @p_hour_3
			,hour_4 = @p_hour_4
			,hour_5 = @p_hour_5
			,hour_6 = @p_hour_6
			,hour_7 = @p_hour_7
			,hour_8 = @p_hour_8
			,hour_9 = @p_hour_9
			,hour_10 = @p_hour_10
			,hour_11 = @p_hour_11
			,hour_12 = @p_hour_12
			,hour_13 = @p_hour_13
			,hour_14 = @p_hour_14
			,hour_15 = @p_hour_15
			,hour_16 = @p_hour_16
			,hour_17 = @p_hour_17
			,hour_18 = @p_hour_18
			,hour_19 = @p_hour_19
			,hour_20 = @p_hour_20
			,hour_21 = @p_hour_21
			,hour_22 = @p_hour_22
			,hour_23 = @p_hour_23
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where day_created = @p_day_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id


    
  return 

end
GO





SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_CAR_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ����� � ������ �� ����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	������� ����� ���������
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
	,@p_begin_mntnc_date	datetime	  = null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_day_created			datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	declare
	  @v_day_1		decimal(18,9)
	, @v_day_2		decimal(18,9)
	, @v_day_3		decimal(18,9)
	, @v_day_4		decimal(18,9)
	, @v_day_5		decimal(18,9)
	, @v_day_6		decimal(18,9)
	, @v_day_7		decimal(18,9)
	, @v_day_8		decimal(18,9)
	, @v_day_9		decimal(18,9)
	, @v_day_10		decimal(18,9)
	, @v_day_11		decimal(18,9)
	, @v_day_12		decimal(18,9)
	, @v_day_13		decimal(18,9)
	, @v_day_14		decimal(18,9)
	, @v_day_15		decimal(18,9)
	, @v_day_16		decimal(18,9)
	, @v_day_17		decimal(18,9)
	, @v_day_18		decimal(18,9)
	, @v_day_19		decimal(18,9)
	, @v_day_20		decimal(18,9)
	, @v_day_21		decimal(18,9)
	, @v_day_22		decimal(18,9)
	, @v_day_23		decimal(18,9)
	, @v_day_24		decimal(18,9)
	, @v_day_25		decimal(18,9)
	, @v_day_26		decimal(18,9)
	, @v_day_27		decimal(18,9)
	, @v_day_28		decimal(18,9)
	, @v_day_29		decimal(18,9)
	, @v_day_30		decimal(18,9)
	, @v_day_31		decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_month_created is null)
	  set @p_month_created = dbo.usfUtils_TimeToZero(getdate())
	 else
	  set @p_month_created = dbo.usfUtils_TimeToZero(@p_day_created)
 
	 if (datepart("Day", @p_day_created) = 1)
		set @v_day_1 = @p_value
	 else
		set @v_day_1 = 0
	 if (datepart("Day", @p_day_created) = 2)
		set @v_day_2 = @p_value
	 else
		set @v_day_2 = 0
	 if (datepart("Day", @p_day_created) = 3)
		set @v_day_3 = @p_value
	 else
		set @v_day_3 = 0
	 if (datepart("Day", @p_day_created) = 4)
		set @v_day_4 = @p_value
	 else
		set @v_day_4 = 0
	 if (datepart("Day", @p_day_created) = 5)
		set @v_day_5 = @p_value
	 else
		set @v_day_5 = 0
	 if (datepart("Day", @p_day_created) = 6)
		set @v_day_6 = @p_value
	 else
		set @v_day_6 = 0
	 if (datepart("Day", @p_day_created) = 7)
		set @v_day_7 = @p_value
	 else
		set @v_day_7 = 0
	 if (datepart("Day", @p_day_created) = 8)
		set @v_day_8 = @p_value
	 else
		set @v_day_8 = 0
	 if (datepart("Day", @p_day_created) = 9)
		set @v_day_9 = @p_value
	 else
		set @v_day_9 = 0
	 if (datepart("Day", @p_day_created) = 10)
		set @v_day_10 = @p_value
	 else
		set @v_day_10 = 0
	 if (datepart("Day", @p_day_created) = 11)
		set @v_day_11 = @p_value
	 else
		set @v_day_11 = 0
	 if (datepart("Day", @p_day_created) = 12)
		set @v_day_12 = @p_value
	 else
		set @v_day_12 = 0
	 if (datepart("Day", @p_day_created) = 13)
		set @v_day_13 = @p_value
	 else
		set @v_day_13 = 0
	 if (datepart("Day", @p_day_created) = 14)
		set @v_day_14 = @p_value
	 else
		set @v_day_14 = 0
	 if (datepart("Day", @p_day_created) = 15)
		set @v_day_15 = @p_value
	 else
		set @v_day_15 = 0
	 if (datepart("Day", @p_day_created) = 16)
		set @v_day_16 = @p_value
	 else
		set @v_day_16 = 0
	 if (datepart("Day", @p_day_created) = 17)
		set @v_day_17 = @p_value
	 else
		set @v_day_17 = 0
	 if (datepart("Day", @p_day_created) = 18)
		set @v_day_18 = @p_value
	 else
		set @v_day_18 = 0
	 if (datepart("Day", @p_day_created) = 19)
		set @v_day_19 = @p_value
	 else
		set @v_day_19 = 0
	 if (datepart("Day", @p_day_created) = 20)
		set @v_day_20 = @p_value
	 else
		set @v_day_20 = 0
	 if (datepart("Day", @p_day_created) = 21)
		set @v_day_21 = @p_value
	 else
		set @v_day_21 = 0
	 if (datepart("Day", @p_day_created) = 22)
		set @v_day_22 = @p_value
	 else
		set @v_day_22 = 0
	 if (datepart("Day", @p_day_created) = 23)
		set @v_day_23 = @p_value
	 else
		set @v_day_23 = 0
	 if (datepart("Day", @p_day_created) = 24)
		set @v_day_24 = @p_value
	 else
		set @v_day_24 = 0
	 if (datepart("Day", @p_day_created) = 25)
		set @v_day_25 = @p_value
	 else
		set @v_day_25 = 0
	 if (datepart("Day", @p_day_created) = 26)
		set @v_day_26 = @p_value
	 else
		set @v_day_26 = 0
	 if (datepart("Day", @p_day_created) = 27)
		set @v_day_27 = @p_value
	 else
		set @v_day_27 = 0
	 if (datepart("Day", @p_day_created) = 28)
		set @v_day_28 = @p_value
	 else
		set @v_day_28 = 0
	 if (datepart("Day", @p_day_created) = 29)
		set @v_day_29 = @p_value
	 else
		set @v_day_29 = 0
	 if (datepart("Day", @p_day_created) = 30)
		set @v_day_30 = @p_value
	 else
		set @v_day_30 = 0
	 if (datepart("Day", @p_day_created) = 31)
		set @v_day_31 = @p_value
	 else
		set @v_day_31 = 0

insert into dbo.CREP_CAR_DAY
	  (month_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, speedometer_start_indctn, speedometer_end_indctn
			, fuel_start_left, fuel_end_left
			, sys_comment, sys_user_created, sys_user_modified)
select @p_month_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @v_day_1, @v_day_2, @v_day_3, @v_day_4
			,@v_day_5, @v_day_6, @v_day_7, @v_day_8, @v_day_9, @v_day_10
			,@v_day_11, @v_day_12, @v_day_13, @v_day_14, @v_day_15, @v_day_16
			,@v_day_17, @v_day_18, @v_day_19, @v_day_20, @v_day_21, @v_day_22
			,@v_day_23, @v_day_24, @v_day_25, @v_day_26, @v_day_27, @v_day_28
			,@v_day_29, @v_day_30, @v_day_31
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_start_left, @p_fuel_end_left
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- ���� ������� ������������
		update dbo.CREP_CAR_DAY 
		 set
			month_created = @p_month_created
		   ,value_id = @p_value_id
		   ,state_number = @p_state_number
		   ,car_id = @p_car_id
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,begin_mntnc_date = @p_begin_mntnc_date
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,day_1 = @v_day_1
		   ,day_2 = @v_day_2
		   ,day_3 = @v_day_3
		   ,day_4 = @v_day_4
		   ,day_5 = @v_day_5
		   ,day_6 = @v_day_6
		   ,day_7 = @v_day_7
		   ,day_8 = @v_day_8
		   ,day_9 = @v_day_9
		   ,day_10 = @v_day_10
		   ,day_11 = @v_day_11
		   ,day_12 = @v_day_12
		   ,day_13 = @v_day_13
		   ,day_14 = @v_day_14
		   ,day_15 = @v_day_15
		   ,day_16 = @v_day_16
		   ,day_17 = @v_day_17
		   ,day_18 = @v_day_18
		   ,day_19 = @v_day_19
		   ,day_20 = @v_day_20
		   ,day_21 = @v_day_21
		   ,day_22 = @v_day_22
		   ,day_23 = @v_day_23
		   ,day_24 = @v_day_24
		   ,day_25 = @v_day_25
		   ,day_26 = @v_day_26
		   ,day_27 = @v_day_27
		   ,day_28 = @v_day_28
		   ,day_29 = @v_day_29
		   ,day_30 = @v_day_30
		   ,day_31 = @v_day_31
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return 

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVREP_CAR_MONTH_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ����� � ���� �� ����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_year_created		datetime	  = null
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
	,@p_begin_mntnc_date	datetime	  = null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_month_created		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	declare
	  @v_month_1		decimal(18,9)
	, @v_month_2		decimal(18,9)
	, @v_month_3		decimal(18,9)
	, @v_month_4		decimal(18,9)
	, @v_month_5		decimal(18,9)
	, @v_month_6		decimal(18,9)
	, @v_month_7		decimal(18,9)
	, @v_month_8		decimal(18,9)
	, @v_month_9		decimal(18,9)
	, @v_month_10		decimal(18,9)
	, @v_month_11		decimal(18,9)
	, @v_month_12		decimal(18,9)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_year_created is null)
	  set @p_year_created = dbo.usfUtils_DayTo01(getdate())
	 else
	  set @p_year_created = dbo.usfUtils_DayTo01(@p_month_created)
 
	 if (datepart("Month", @p_month_created) = 1)
		set @v_month_1 = @p_value
	 else
		set @v_month_1 = 0
	 if (datepart("Month", @p_month_created) = 2)
		set @v_month_2 = @p_value
	 else
		set @v_month_2 = 0
	 if (datepart("Month", @p_month_created) = 3)
		set @v_month_3 = @p_value
	 else
		set @v_month_3 = 0
	 if (datepart("Month", @p_month_created) = 4)
		set @v_month_4 = @p_value
	 else
		set @v_month_4 = 0
	 if (datepart("Month", @p_month_created) = 5)
		set @v_month_5 = @p_value
	 else
		set @v_month_5 = 0
	 if (datepart("Month", @p_month_created) = 6)
		set @v_month_6 = @p_value
	 else
		set @v_month_6 = 0
	 if (datepart("Month", @p_month_created) = 7)
		set @v_month_7 = @p_value
	 else
		set @v_month_7 = 0
	 if (datepart("Month", @p_month_created) = 8)
		set @v_month_8 = @p_value
	 else
		set @v_month_8 = 0
	 if (datepart("Month", @p_month_created) = 9)
		set @v_month_9 = @p_value
	 else
		set @v_month_9 = 0
	 if (datepart("Month", @p_month_created) = 10)
		set @v_month_10 = @p_value
	 else
		set @v_month_10 = 0
	 if (datepart("Month", @p_month_created) = 11)
		set @v_month_11 = @p_value
	 else
		set @v_month_11 = 0
	 if (datepart("Month", @p_month_created) = 12)
		set @v_month_12 = @p_value
	 else
		set @v_month_12 = 0
	 

insert into dbo.CREP_CAR_MONTH
	  (year_created, value_id, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname, begin_mntnc_date
			,fuel_type_id, fuel_type_sname, car_kind_id
			,car_kind_sname, month_1, month_2, month_3, month_4
			, month_5, month_6, month_7, month_8, month_9, month_10
			, month_11, month_12
			, speedometer_start_indctn, speedometer_end_indctn
			, fuel_start_left, fuel_end_left
			, sys_comment, sys_user_created, sys_user_modified)
select @p_year_created, @p_value_id, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_fuel_type_sname, @p_car_kind_id
			,@p_car_kind_sname, @v_month_1, @v_month_2, @v_month_3, @v_month_4
			,@v_month_5, @v_month_6, @v_month_7, @v_month_8, @v_month_9, @v_month_10
			,@v_month_11, @v_month_12
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
			,@p_fuel_start_left, @p_fuel_end_left
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_CAR_MONTH as b
  where b.year_created = @p_year_created
	and b.value_id = @p_value_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- ���� ������� ������������
		update dbo.CREP_CAR_MONTH
		 set
			year_created = @p_year_created
		   ,value_id = @p_value_id
		   ,state_number = @p_state_number
		   ,car_id = @p_car_id
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,begin_mntnc_date = @p_begin_mntnc_date
		   ,fuel_type_id = @p_fuel_type_id
           ,fuel_type_sname = @p_fuel_type_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,month_1 = @v_month_1
		   ,month_2 = @v_month_2
		   ,month_3 = @v_month_3
		   ,month_4 = @v_month_4
		   ,month_5 = @v_month_5
		   ,month_6 = @v_month_6
		   ,month_7 = @v_month_7
		   ,month_8 = @v_month_8
		   ,month_9 = @v_month_9
		   ,month_10 = @v_month_10
		   ,month_11 = @v_month_11
		   ,month_12 = @v_month_12
			,speedometer_start_indctn = @p_speedometer_start_indctn
			,speedometer_end_indctn = @p_speedometer_end_indctn
			,fuel_start_left = @p_fuel_start_left
			,fuel_end_left = @p_fuel_end_left
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where year_created = @p_year_created
		   and value_id = @p_value_id
		   and car_id	= @p_car_id
    
  return

end
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_EXIT_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ���������� ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_exit_amnt  int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('CAR_EXIT_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_exit_amnt = count(*)
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_exit_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_exit_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_exit_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_exit_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_exit_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_exit_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_exit_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_exit_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_exit_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_exit_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_exit_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_exit_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_exit_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_exit_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_exit_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_exit_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_exit_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_exit_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_exit_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_exit_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_exit_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_exit_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_exit_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_exit_amnt
else
  set @v_hour_23 = 0

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @p_speedometer_start_indctn
			,@p_speedometer_end_indctn = @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_CNMPTN_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ������� ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_fuel_consumption	decimal(18,9)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_fuel_cnmptn_amnt int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('CAR_FUEL_CNMPTN_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_fuel_cnmptn_amnt = sum(fuel_consumption)
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_fuel_cnmptn_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_fuel_cnmptn_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_fuel_cnmptn_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_fuel_cnmptn_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_fuel_cnmptn_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_fuel_cnmptn_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_fuel_cnmptn_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_fuel_cnmptn_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_fuel_cnmptn_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_fuel_cnmptn_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_fuel_cnmptn_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_fuel_cnmptn_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_fuel_cnmptn_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_fuel_cnmptn_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_fuel_cnmptn_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_fuel_cnmptn_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_fuel_cnmptn_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_fuel_cnmptn_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_fuel_cnmptn_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_fuel_cnmptn_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_fuel_cnmptn_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_fuel_cnmptn_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_fuel_cnmptn_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_fuel_cnmptn_amnt
else
  set @v_hour_23 = 0

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @p_speedometer_start_indctn
			,@p_speedometer_end_indctn = @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_FUEL_GIVED_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ������ ������� �� �����������  
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_fuel_gived_amnt int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('CAR_FUEL_GIVED_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_fuel_gived_amnt = sum(fuel_gived)
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_fuel_gived_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_fuel_gived_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_fuel_gived_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_fuel_gived_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_fuel_gived_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_fuel_gived_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_fuel_gived_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_fuel_gived_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_fuel_gived_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_fuel_gived_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_fuel_gived_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_fuel_gived_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_fuel_gived_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_fuel_gived_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_fuel_gived_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_fuel_gived_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_fuel_gived_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_fuel_gived_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_fuel_gived_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_fuel_gived_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_fuel_gived_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_fuel_gived_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_fuel_gived_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_fuel_gived_amnt
else
  set @v_hour_23 = 0

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @p_speedometer_start_indctn
			,@p_speedometer_end_indctn = @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_car_work_hour_amnt  int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('CAR_WORK_MINUTE_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_car_work_hour_amnt = sum(datediff("mi", fact_start_duty, fact_end_duty))
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_car_work_hour_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_car_work_hour_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_car_work_hour_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_car_work_hour_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_car_work_hour_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_car_work_hour_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_car_work_hour_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_car_work_hour_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_car_work_hour_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_car_work_hour_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_car_work_hour_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_car_work_hour_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_car_work_hour_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_car_work_hour_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_car_work_hour_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_car_work_hour_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_car_work_hour_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_car_work_hour_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_car_work_hour_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_car_work_hour_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_car_work_hour_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_car_work_hour_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_car_work_hour_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_car_work_hour_amnt
else
  set @v_hour_23 = 0

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @p_speedometer_start_indctn
			,@p_speedometer_end_indctn = @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
	--TODO: R�ࠡR⪠ �-��_-�c
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_KM_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � ����������� �� ���������� 
** �������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_run					decimal(18,9)
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_car_km_amnt  int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('CAR_KM_AMOUNT')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 select  @v_car_km_amnt = sum(run)
 from dbo.CDRV_DRIVER_LIST
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
  
 set  @v_hour = datepart("Hh", @p_fact_end_duty)

if (@v_hour = 0)
  set @v_hour_0 = @v_car_km_amnt
else
  set @v_hour_0 = 0
if (@v_hour = 1)
  set @v_hour_1 = @v_car_km_amnt
else
  set @v_hour_1 = 0
if (@v_hour = 2)
  set @v_hour_2 = @v_car_km_amnt
else
  set @v_hour_2 = 0
if (@v_hour = 3)
  set @v_hour_3 = @v_car_km_amnt
else
  set @v_hour_3 = 0
if (@v_hour = 4)
  set @v_hour_4 = @v_car_km_amnt
else
  set @v_hour_4 = 0
if (@v_hour = 5)
  set @v_hour_5 = @v_car_km_amnt
else
  set @v_hour_5 = 0
if (@v_hour = 6)
  set @v_hour_6 = @v_car_km_amnt
else
  set @v_hour_6 = 0
if (@v_hour = 7)
  set @v_hour_7 = @v_car_km_amnt
else
  set @v_hour_7 = 0
if (@v_hour = 8)
  set @v_hour_8 = @v_car_km_amnt
else
  set @v_hour_8 = 0
if (@v_hour = 9)
  set @v_hour_9 = @v_car_km_amnt
else
  set @v_hour_9 = 0
if (@v_hour = 10)
  set @v_hour_10  = @v_car_km_amnt
else
  set @v_hour_10 = 0
if (@v_hour = 11)
  set @v_hour_11  = @v_car_km_amnt
else
  set @v_hour_11 = 0
if (@v_hour = 12)
  set @v_hour_12  = @v_car_km_amnt
else
  set @v_hour_12 = 0
if (@v_hour = 13)
  set @v_hour_13  = @v_car_km_amnt
else
  set @v_hour_13 = 0
if (@v_hour = 14)
  set @v_hour_14  = @v_car_km_amnt
else
  set @v_hour_14 = 0
if (@v_hour = 15)
  set @v_hour_15  = @v_car_km_amnt
else
  set @v_hour_15 = 0 
if (@v_hour = 16)
  set @v_hour_16  = @v_car_km_amnt
else
  set @v_hour_16 = 0
if (@v_hour = 17)
  set @v_hour_17  = @v_car_km_amnt
else
  set @v_hour_17 = 0
if (@v_hour = 18)
  set @v_hour_18  = @v_car_km_amnt
else
  set @v_hour_18 = 0
if (@v_hour = 19)
  set @v_hour_19  = @v_car_km_amnt
else
  set @v_hour_19 = 0 
if (@v_hour = 20)
  set @v_hour_20  = @v_car_km_amnt
else
  set @v_hour_20 = 0
if (@v_hour = 21)
  set @v_hour_21  = @v_car_km_amnt
else
  set @v_hour_21 = 0
if (@v_hour = 22)
  set @v_hour_22  = @v_car_km_amnt
else
  set @v_hour_22 = 0
if (@v_hour = 23)
  set @v_hour_23  = @v_car_km_amnt
else
  set @v_hour_23 = 0

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @p_speedometer_start_indctn
			,@p_speedometer_end_indctn = @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������������ ������ ��� ������� � �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_day_created			datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_fact_start_duty		datetime
	,@p_fact_end_duty		datetime
	,@p_run					decimal(18,9)	= null
	,@p_fuel_consumption    decimal(18,9)
	,@p_last_date_created	datetime		= null
	,@p_speedometer_start_indctn decimal(18,9) = 0
	,@p_speedometer_end_indctn decimal(18,9) = 0
	,@p_fuel_start_left		decimal(18,9) = 0
	,@p_fuel_end_left		decimal(18,9) = 0
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	@v_Error			int
    ,@v_TrancountOnEntry int


  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = 
		dbo.uspVREP_CAR_HOUR_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_HOUR_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

  exec @v_Error = 
		dbo.uspVREP_CAR_KM_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_KM_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  end

  exec @v_Error = 
		dbo.uspVREP_CAR_EXIT_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_EXIT_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

  exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_CNMPTN_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_fuel_consumption    = @p_fuel_consumption
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

 if (@p_last_date_created) is not null
 begin
	exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_CNMPTN_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_fuel_consumption    = @p_fuel_consumption
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 end


exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_GIVED_Calculate
				 @p_day_created			= @p_day_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@p_last_date_created) is not null
  begin
	exec @v_Error = 
		dbo.uspVREP_CAR_FUEL_GIVED_Calculate
				 @p_day_created			= @p_last_date_created
				,@p_state_number		= @p_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ����������� ������ ��� ������� �� �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
	 @p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9)
	,@p_speedometer_end_indctn		decimal(18,9)
	,@p_fuel_start_left				decimal(18,9)
	,@p_fuel_end_left				decimal(18,9)
	,@p_fuel_gived					decimal(18,9)
	,@p_fuel_return					decimal(18,9)
	,@p_fuel_addtnl_exp				decimal(18,9)
	,@p_run							decimal(18,9)
	,@p_fuel_consumption			decimal(18,9)
	,@p_last_date_created			datetime = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	@v_Error			int
    ,@v_TrancountOnEntry int

  declare    
	 @v_car_type_id					numeric(38,0)
	,@v_car_type_sname				varchar(30)
	,@v_car_state_id				numeric(38,0)	
	,@v_car_state_sname				varchar(30)
	,@v_car_mark_id					numeric(38,0)
	,@v_car_mark_sname				varchar(30)
	,@v_car_model_id				numeric(38,0)
	,@v_car_model_sname				varchar(30)
	,@v_begin_mntnc_date			datetime
	,@v_fuel_type_sname				varchar(30)
	,@v_car_kind_id					numeric(38,0)
	,@v_car_kind_sname				varchar(30)
	,@v_state_number				varchar(20)
    ,@v_sys_comment					varchar(2000)
    ,@v_sys_user					varchar(30)					

--if (@@rowcount = 1)
--begin
select 
		  
		   @v_state_number = b.state_number
		  ,@v_car_type_id = b.car_type_id 
		  ,@v_car_type_sname = b.car_type_sname
		  ,@v_car_state_id = b.car_state_id
		  ,@v_car_state_sname = b.car_state_sname	
		  ,@v_car_mark_id = b.car_mark_id
		  ,@v_car_mark_sname = b.car_mark_sname
		  ,@v_car_model_id = b.car_model_id
		  ,@v_car_model_sname = b.car_model_sname
		  ,@v_begin_mntnc_date = b.begin_mntnc_date
	      ,@v_fuel_type_sname = b.fuel_type_sname
		  ,@v_car_kind_id = b.car_kind_id
		  ,@v_car_kind_sname = b.car_kind_sname
	from  dbo.utfVCAR_CAR() as b
	 where  b.id = @p_car_id

exec @v_Error = 
		dbo.uspVREP_Calculate
				 @p_day_created			= @p_date_created
				,@p_state_number		= @v_state_number
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @v_car_type_id
				,@p_car_type_sname		= @v_car_type_sname
				,@p_car_state_id		= @v_car_state_id
				,@p_car_state_sname		= @v_car_state_sname
				,@p_car_mark_id			= @v_car_mark_id
				,@p_car_mark_sname		= @v_car_mark_sname
				,@p_car_model_id		= @v_car_model_id
				,@p_car_model_sname		= @v_car_model_sname
				,@p_begin_mntnc_date	= @v_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @v_fuel_type_sname
				,@p_car_kind_id			= @v_car_kind_id
				,@p_car_kind_sname		= @v_car_kind_sname
				,@p_fact_start_duty 	= @p_fact_start_duty
		  		,@p_fact_end_duty 		= @p_fact_end_duty
				,@p_run					= @p_run
				,@p_fuel_consumption	= @p_fuel_consumption
				,@p_last_date_created	= @p_last_date_created
				,@p_speedometer_start_indctn = @p_speedometer_start_indctn
				,@p_speedometer_end_indctn = @p_speedometer_end_indctn
				,@p_fuel_start_left = @p_fuel_start_left
				,@p_fuel_end_left = @p_fuel_end_left
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user
--end			


	RETURN
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



