:r ./../_define.sql

:setvar dc_number 00328
:setvar dc_description "repair zone emp report fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.06.2008 VLavrentiev  repair zone emp report fixed
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

CREATE PROCEDURE [dbo].[uspVREP_MECH_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по сотрудникам механикам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_day_created			datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
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
	,@v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_id			numeric(38,0)
	,@v_value_total			decimal(18,9)
	,@v_value_day			decimal(18,9)
	,@v_value_night			decimal(18,9)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_TOTAL')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)


select @v_hour_0 = 
		sum(case datepart("Hh", a.date_ended)
	   when 0 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", a.date_ended)
	   when 1 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", a.date_ended)
	   when 2 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", a.date_ended)
	   when 3 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", a.date_ended)
	   when 4 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", a.date_ended) 
	   when 5
	   then 0 
		else datediff("mi",a.date_started, a.date_ended)
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", a.date_ended)
	   when 6 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", a.date_ended)
	   when 7 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", a.date_ended)
	   when 8 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", a.date_ended)
	   when 9 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", a.date_ended)
	   when 10 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", a.date_ended)
	   when 11
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", a.date_ended)
	   when 12 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", a.date_ended)
	   when 13 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", a.date_ended)
	   when 14 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", a.date_ended)
	   when 15 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", a.date_ended)
	   when 16
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", a.date_ended)
	   when 17 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", a.date_ended)
	   when 18 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", a.date_ended)
	   when 19 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", a.date_ended)
	   when 20
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", a.date_ended)
	   when 21
	   then 0 
	   else datediff("mi",a.date_started, a.date_ended)
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", a.date_ended)
	   when 22 
	   then datediff("mi",a.date_started, a.date_ended)
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", a.date_ended)
	   when 23
	   then 0 
	   else datediff("mi",a.date_started, a.date_ended)
	   end)
 from dbo.CRPR_REPAIR_ZONE_MASTER as a
    join dbo.CRPR_REPAIR_ZONE_DETAIL  as b
      on a.id = b.repair_zone_master_id
 where b.employee_worker_id = @p_employee_id
   and a.date_started > = @v_day_created
   and a.date_started < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_SaveById
			 @p_day_created			= @v_day_created	  
			,@p_value_id			= @v_value_id
			,@p_employee_id			= @p_employee_id
			,@p_person_id			= @p_person_id
			,@p_lastname			= @p_lastname
			,@p_name				= @p_name
			,@p_surname				= @p_surname
			,@p_organization_id		= @p_organization_id
			,@p_organization_sname	= @p_organization_sname
			,@p_employee_type_id	= @p_employee_type_id
			,@p_employee_type_sname	= @p_employee_type_sname
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
			,@p_month_created = @v_month_created
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

   select @v_value_total = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
		 ,@v_value_day = sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21)
		 ,@v_value_night = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5)+ sum(hour_22)
					 + sum(hour_23) 
    from dbo.CREP_EMPLOYEE_HOUR
  where employee_id = @p_employee_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_day_created
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
go

GRANT EXECUTE ON [dbo].[uspVREP_MECH_EMPLOYEE_HOUR_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_MECH_EMPLOYEE_HOUR_Calculate] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_MECH_EMPLOYEE_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготавливать данные для отчетов по сотрудникам механикам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      14.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_last_date_created	datetime		= null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
  
  declare
	 @v_person_id			numeric(38,0)
	,@v_lastname			varchar(100)
	,@v_name				varchar(60)
	,@v_surname				varchar(60)
	,@v_organization_id		numeric(38,0)
	,@v_organization_sname	varchar(30)
	,@v_employee_type_id	numeric(38,0)
	,@v_employee_type_sname	varchar(30)


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


  select @v_person_id = person_id
		,@v_organization_id = organization_id
		,@v_employee_type_id = employee_type_id
    from dbo.CPRT_EMPLOYEE
	where id = @p_employee_id

  select @v_lastname = lastname
		,@v_name = name
		,@v_surname = surname
	from dbo.CPRT_PERSON
	where id = @v_person_id

  select @v_organization_sname = name
	from dbo.CPRT_ORGANIZATION
	where id = @v_organization_id

  select @v_employee_type_sname = short_name
	from dbo.CPRT_EMPLOYEE_TYPE
	where id = @v_employee_type_id

      if (@@tranCount = 0)
        begin transaction 

exec @v_Error = dbo.uspVREP_MECH_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

if (@p_last_date_created is not null)
begin
  exec @v_Error = dbo.uspVREP_MECH_EMPLOYEE_HOUR_Calculate
	 @p_day_created			= @p_last_date_created	  
	,@p_employee_id			= @p_employee_id
	,@p_person_id			= @v_person_id
	,@p_lastname			= @v_lastname
	,@p_name				= @v_name
	,@p_surname				= @v_surname
	,@p_organization_id		= @v_organization_id	
	,@p_organization_sname	= @v_organization_sname
	,@p_employee_type_id	= @v_employee_type_id
	,@p_employee_type_sname	= @v_employee_type_sname
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 end

	   if (@@tranCount > @v_TrancountOnEntry)
        commit

return
go

GRANT EXECUTE ON [dbo].[uspVREP_MECH_EMPLOYEE_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_MECH_EMPLOYEE_Prepare] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь ремонтной зоны
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_repair_zone_master_id	numeric(38,0)
    ,@p_work_desc				varchar(2000) = '-//-'
	,@p_hour_amount				decimal(18,9)
	,@p_employee_worker_id		numeric(38,0) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  set xact_abort on
	declare
		 @v_order_state			smallint
		,@v_Error				int
        	,@v_TrancountOnEntry int
		,@v_date_created		datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
  
  if (@@tranCount = 0)
    begin transaction  

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CRPR_REPAIR_ZONE_DETAIL 
            ( repair_zone_master_id, work_desc
			, hour_amount, employee_worker_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_repair_zone_master_id, @p_work_desc
			, @p_hour_amount, @p_employee_worker_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CRPR_REPAIR_ZONE_DETAIL set
		 repair_zone_master_id = @p_repair_zone_master_id
		,work_desc = @p_work_desc
		,hour_amount = @p_hour_amount
		,employee_worker_id = @p_employee_worker_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

select @v_date_created = a.date_started
from dbo.CRPR_REPAIR_ZONE_MASTER as a
where a.id = @p_repair_zone_master_id


exec @v_Error = dbo.uspVREP_MECH_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @p_employee_worker_id
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 

  if (@@tranCount > @v_TrancountOnEntry)
  commit

    
  return 

end
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_MECH_EMPLOYEE_HOUR_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов по сотрудникам механикам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_day_created			datetime	  
	,@p_employee_id			numeric(38,0)
	,@p_person_id			numeric(38,0)
	,@p_lastname			varchar(100)
	,@p_name				varchar(60)
	,@p_surname				varchar(60)	  = null
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname	varchar(30)
	,@p_employee_type_id	numeric(38,0)
	,@p_employee_type_sname	varchar(30)
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
	,@v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_id			numeric(38,0)
	,@v_value_total			decimal(18,9)
	,@v_value_day			decimal(18,9)
	,@v_value_night			decimal(18,9)
	,@v_month_created		datetime
	,@v_day_created			datetime
	
  
 set  @v_value_id = dbo.usfConst('EMP_WORK_HOUR_AMOUNT_TOTAL')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_day_created)

 set @v_month_created = dbo.usfUtils_DayTo01(@p_day_created)


select @v_hour_0 = 
		sum(case datepart("Hh", a.date_ended)
	   when 0 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", a.date_ended)
	   when 1 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", a.date_ended)
	   when 2 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", a.date_ended)
	   when 3 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", a.date_ended)
	   when 4 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", a.date_ended) 
	   when 5
	   then hour_amount 
		else 0
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", a.date_ended)
	   when 6 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", a.date_ended)
	   when 7 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", a.date_ended)
	   when 8 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", a.date_ended)
	   when 9 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", a.date_ended)
	   when 10 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", a.date_ended)
	   when 11
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", a.date_ended)
	   when 12 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", a.date_ended)
	   when 13 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", a.date_ended)
	   when 14 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", a.date_ended)
	   when 15 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", a.date_ended)
	   when 16
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", a.date_ended)
	   when 17 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", a.date_ended)
	   when 18 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", a.date_ended)
	   when 19 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", a.date_ended)
	   when 20
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", a.date_ended)
	   when 21
	   then hour_amount 
	   else 0
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", a.date_ended)
	   when 22 
	   then hour_amount
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", a.date_ended)
	   when 23
	   then hour_amount 
	   else 0
	   end)
 from dbo.CRPR_REPAIR_ZONE_MASTER as a
    join dbo.CRPR_REPAIR_ZONE_DETAIL  as b
      on a.id = b.repair_zone_master_id
 where b.employee_worker_id = @p_employee_id
   and a.date_started > = @v_day_created
   and a.date_started < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_EMPLOYEE_HOUR_SaveById
			 @p_day_created			= @v_day_created	  
			,@p_value_id			= @v_value_id
			,@p_employee_id			= @p_employee_id
			,@p_person_id			= @p_person_id
			,@p_lastname			= @p_lastname
			,@p_name				= @p_name
			,@p_surname				= @p_surname
			,@p_organization_id		= @p_organization_id
			,@p_organization_sname	= @p_organization_sname
			,@p_employee_type_id	= @p_employee_type_id
			,@p_employee_type_sname	= @p_employee_type_sname
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
			,@p_month_created = @v_month_created
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

   select @v_value_total = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
		 ,@v_value_day = sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21)
		 ,@v_value_night = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5)+ sum(hour_22)
					 + sum(hour_23) 
    from dbo.CREP_EMPLOYEE_HOUR
  where employee_id = @p_employee_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   exec @v_Error = 
		dbo.uspVREP_EMPLOYEE_DAY_SaveById
				 @p_day_created			= @v_day_created
				,@p_value_id			= @v_value_id
				,@p_employee_id			= @p_employee_id
				,@p_person_id			= @p_person_id
				,@p_lastname			= @p_lastname
				,@p_name				= @p_name
				,@p_surname				= @p_surname
				,@p_organization_id		= @p_organization_id
				,@p_organization_sname	= @p_organization_sname
				,@p_employee_type_id	= @p_employee_type_id
				,@p_employee_type_sname	= @p_employee_type_sname
				,@p_value 				= @v_value_total
		  		,@p_month_created 		= @v_day_created
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
