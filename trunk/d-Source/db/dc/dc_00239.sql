:r ./../_define.sql

:setvar dc_number 00239
:setvar dc_description "worker report tables save procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    12.05.2008 VLavrentiev  worker report tables save procs added
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


alter table dbo.CREP_EMPLOYEE_HOUR
add day_created datetime
go


alter table dbo.CREP_EMPLOYEE_DAY
add month_created datetime
go

drop index [dbo].[CREP_EMPLOYEE_DAY].ifk_organization_id_crep_employee_day
go

drop index [dbo].[CREP_EMPLOYEE_HOUR].ifk_organization_id_crep_employee_hour
go



alter table dbo.CREP_EMPLOYEE_DAY
alter column organization_id numeric(38,0) not null
go


alter table dbo.CREP_EMPLOYEE_HOUR
alter column organization_id numeric(38,0) not null
go


create index ifk_month_created_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](month_created)
on $(fg_idx_name)
go


create index ifk_day_created_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](day_created)
on $(fg_idx_name)
go

create index ifk_organization_id_crep_employee_day on [dbo].[CREP_EMPLOYEE_DAY](organization_id)
on $(fg_idx_name)
go


create index ifk_organization_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](organization_id)
on $(fg_idx_name)
go



declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CREP_EMPLOYEE_HOUR', 'column', 'day_created'
go




declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Месяц создания',
   'user', @CurrentUser, 'table', 'CREP_EMPLOYEE_DAY', 'column', 'month_created'
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (65, 'EMP_WORK_HOUR_AMOUNT_DAY', 'Суммарное количество рабочих часов днем')
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (66, 'EMP_WORK_HOUR_AMOUNT_NIGHT', 'Суммарное количество рабочих часов ночью')
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (67, 'EMP_WORK_HOUR_AMOUNT_HR_DAY', 'Суммарное количество рабочих часов днем для отдела кадров')
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (68, 'EMP_WORK_HOUR_AMOUNT_HR_NIGHT', 'Суммарное количество рабочих часов ночью для отдела кадров')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values (65, 'EMP_WORK_HOUR_AMOUNT_DAY', 'Суммарное количество рабочих часов днем')

insert into dbo.CSYS_CONST(id, name, description)
values (66, 'EMP_WORK_HOUR_AMOUNT_NIGHT', 'Суммарное количество рабочих часов ночью')

insert into dbo.CSYS_CONST(id, name, description)
values (67, 'EMP_WORK_HOUR_AMOUNT_HR_DAY', 'Суммарное количество рабочих часов днем для отдела кадров')

insert into dbo.CSYS_CONST(id, name, description)
values (68, 'EMP_WORK_HOUR_AMOUNT_HR_NIGHT', 'Суммарное количество рабочих часов ночью для отдела кадров')
go






SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVREP_EMPLOYEE_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о месяце по рабочему времени
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) = null out
	,@p_value_id			numeric(38,0)
	,@p_month_created		datetime
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id		numeric(38,0)
	,@p_employee_type_sname		varchar(30)
	,@p_value				decimal(18,9)
	,@p_day_created			datetime
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

insert into dbo.CREP_EMPLOYEE_DAY
	  (		month_created, value_id, employee_id, person_id
			,lastname, name, surname	
			,organization_id, organization_sname, employee_type_id
			,employee_type_sname, day_1, day_2, day_3, day_4
			, day_5, day_6, day_7, day_8, day_9, day_10
			, day_11, day_12, day_13, day_14, day_15, day_16
			, day_17, day_18, day_19, day_20, day_21, day_22
			, day_23, day_24, day_25, day_26, day_27, day_28
			, day_29, day_30, day_31
			, sys_comment, sys_user_created, sys_user_modified)
select		@p_month_created, @p_value_id, @p_employee_id, @p_person_id
			,@p_lastname, @p_name, @p_surname	
			,@p_organization_id, @p_organization_sname, @p_employee_type_id
			,@p_employee_type_sname, @v_day_1, @v_day_2, @v_day_3, @v_day_4
			,@v_day_5, @v_day_6, @v_day_7, @v_day_8, @v_day_9, @v_day_10
			,@v_day_11, @v_day_12, @v_day_13, @v_day_14, @v_day_15, @v_day_16
			,@v_day_17, @v_day_18, @v_day_19, @v_day_20, @v_day_21, @v_day_22
			,@v_day_23, @v_day_24, @v_day_25, @v_day_26, @v_day_27, @v_day_28
			,@v_day_29, @v_day_30, @v_day_31
	       , @p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_EMPLOYEE_DAY as b
  where b.month_created = @p_month_created
	and b.value_id = @p_value_id
	and b.employee_id = @p_employee_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_EMPLOYEE_DAY 
		 set
		    person_id = @p_person_id
		   ,lastname = @p_lastname
		   ,name = @p_name
		   ,surname = @p_surname	
		   ,organization_id = @p_organization_id
		   ,organization_sname = @p_organization_sname
		   ,employee_type_id = @p_employee_type_id
		   ,employee_type_sname = @p_employee_type_sname
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
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where month_created = @p_month_created
		   and value_id = @p_value_id
		   and employee_id	= @p_employee_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVREP_EMPLOYEE_DAY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_EMPLOYEE_DAY_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVREP_EMPLOYEE_HOUR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о дне по рабочему
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id					numeric(38,0) = null out 
	,@p_day_created			datetime	  
	,@p_value_id			numeric(38,0)
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
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


    insert into dbo.CREP_EMPLOYEE_HOUR
            (day_created,  value_id, employee_id, person_id
			,lastname, name, surname	
			,organization_id, organization_sname, employee_type_id
			,employee_type_sname, hour_0, hour_1, hour_2
			,hour_3, hour_4, hour_5, hour_6
			,hour_7, hour_8, hour_9, hour_10
			,hour_11, hour_12, hour_13, hour_14
			,hour_15, hour_16, hour_17, hour_18
			,hour_19, hour_20, hour_21, hour_22
			,hour_23, sys_comment, sys_user_created, sys_user_modified)
	select   @p_day_created, @p_value_id, @p_employee_id, @p_person_id
			,@p_lastname, @p_name, @p_surname	
			,@p_organization_id, @p_organization_sname, @p_employee_type_id
			,@p_employee_type_sname, @p_hour_0, @p_hour_1, @p_hour_2
			,@p_hour_3, @p_hour_4, @p_hour_5, @p_hour_6
			,@p_hour_7, @p_hour_8, @p_hour_9, @p_hour_10
			,@p_hour_11, @p_hour_12, @p_hour_13, @p_hour_14
			,@p_hour_15, @p_hour_16, @p_hour_17, @p_hour_18
			,@p_hour_19, @p_hour_20, @p_hour_21, @p_hour_22
			,@p_hour_23, @p_sys_comment, @p_sys_user, @p_sys_user 
    where not exists
		(select 1 from dbo.CREP_EMPLOYEE_HOUR as b
		 where b.day_created = @p_day_created
		   and b.value_id = @p_value_id
		   and b.employee_id = @p_employee_id) 
       
  if (@@rowcount = 0)
		update dbo.CREP_EMPLOYEE_HOUR 
		 set
		     person_id = @p_person_id
		    ,lastname = @p_lastname
		    ,name = @p_name
		    ,surname = @p_surname	
		    ,organization_id = @p_organization_id
		    ,organization_sname = @p_organization_sname
		    ,employee_type_id = @p_employee_type_id
		    ,employee_type_sname = @p_employee_type_sname
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
			,sys_comment = @p_sys_comment
			,sys_user_modified = @p_sys_user
		where day_created = @p_day_created
		   and value_id = @p_value_id
		   and employee_id	= @p_employee_id


    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVREP_EMPLOYEE_HOUR_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_EMPLOYEE_HOUR_SaveById] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[usfUtils_TimeToValue](@p_date_with_time datetime, @p_value char(8))
/*
Функция возвращает значение времени для определенного дня
*/
RETURNS datetime
AS
BEGIN
   RETURN convert(datetime, (SELECT convert(nvarchar(4), datepart(yyyy, @p_date_with_time)) +
      + '-' + convert(nvarchar(2), datepart(mm, @p_date_with_time)) +
      + '-' + convert(nvarchar(2), datepart(dd, @p_date_with_time))
      + ' ' + @p_value)); 
END
GO


GRANT VIEW DEFINITION ON [dbo].[usfUtils_TimeToValue] TO [$(db_app_user)]
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




