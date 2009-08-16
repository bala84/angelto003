:r ./../_define.sql

:setvar dc_number 00341
:setvar dc_description "repair by car report added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    04.07.2008 VLavrentiev  repair by car report added
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

CREATE PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Prepare]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подготовить данные для отчетов о ремонтах по автомобилях
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.07.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created				datetime
	,@p_car_id						numeric(38,0)
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
	,@v_fuel_type_id				numeric(38,0)
	,@v_fuel_type_sname				varchar(30)
	,@v_car_kind_id					numeric(38,0)
	,@v_car_kind_sname				varchar(30)
	,@v_state_number				varchar(20)
    ,@v_sys_comment					varchar(2000)
    ,@v_sys_user					varchar(30)	
	,@v_organization_id				numeric(38,0)	
	,@v_organization_sname			varchar(30)				

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
	      ,@v_fuel_type_id = b.fuel_type_id
	      ,@v_fuel_type_sname = b.fuel_type_sname
		  ,@v_car_kind_id = b.car_kind_id
		  ,@v_car_kind_sname = b.car_kind_sname
	from  dbo.utfVCAR_CAR() as b
	 where  b.id = @p_car_id

--TODO: данные об организации должны браться из справочника организаций, а не плана выхода на линию

select TOP(1) @v_organization_id = organization_id
	from dbo.CDRV_DRIVER_PLAN
	where car_id = @p_car_id
order by sys_date_created desc


select @v_organization_sname = name
	from dbo.CPRT_ORGANIZATION
where id = @v_organization_id


exec @v_Error = 
		dbo.uspVREP_REPAIR_BY_CAR_DAY_Calculate 
				   @p_date_created		    = @p_date_created
				  ,@p_state_number			= @v_state_number
				  ,@p_car_id				= @p_car_id
				  ,@p_car_type_id			= @v_car_type_id
				  ,@p_car_type_sname		= @v_car_type_sname
				  ,@p_car_state_id			= @v_car_state_id
				  ,@p_car_state_sname		= @v_car_state_sname
				  ,@p_car_mark_id			= @v_car_mark_id
				  ,@p_car_mark_sname		= @v_car_mark_sname
				  ,@p_car_model_id			= @v_car_model_id
				  ,@p_car_model_sname		= @v_car_model_sname
				  ,@p_fuel_type_id			= @v_fuel_type_id
				  ,@p_fuel_type_sname		= @v_fuel_type_sname
				  ,@p_car_kind_id			= @v_car_kind_id
				  ,@p_car_kind_sname		= @v_car_kind_sname
				  ,@p_organization_id		= @v_organization_id
				  ,@p_organization_sname	= @v_organization_sname
				  ,@p_sys_comment			= @p_sys_comment 
				  ,@p_sys_user			= @p_sys_user		


	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Prepare] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Prepare] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVREP_REPAIR_BY_CAR_DAY] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета о ремонтах по автомобилям
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT date_created
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , car_kind_id
		 , car_kind_sname
		 , short_name
		 , repair_type_master_id
		 , amt
		 , organization_id
		 , organization_sname
      FROM dbo.CREP_REPAIR_BY_CAR_DAY
	
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVREP_REPAIR_BY_CAR_DAY] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о ремонтах по автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime		= null
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error			 int
    ,@v_TrancountOnEntry int
	,@v_month_created	 datetime
	,@v_state_number	 varchar(20)
	,@v_short_name		 varchar(30)
	,@v_amt				 smallint
	,@v_repair_type_master_id numeric(38,0)
 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)
	
  
select  @v_state_number = d.state_number
	   ,@v_short_name = c.short_name
	   ,@v_amt = count(b.repair_type_master_id)
	   ,@v_repair_type_master_id = b.repair_type_master_id 
from dbo.CWRH_WRH_ORDER_MASTER as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b
	on a.id = b.wrh_order_master_id
	join dbo.CRPR_REPAIR_TYPE_MASTER as c
	on b.repair_type_master_id = c.id
	join dbo.CCAR_CAR as d
	on a.car_id = d.id
where a.car_id = @p_car_id
   and a.date_created > = @v_month_created
   and a.date_created < dateadd("mm", 1, @v_month_created)
group by a.car_id, d.state_number,  c.short_name, b.repair_type_master_id

exec @v_Error = dbo.uspVREP_REPAIR_BY_CAR_DAY_SaveById
   @p_date_created = @v_month_created
  ,@p_state_number = @v_state_number
  ,@p_car_id = @p_car_id
  ,@p_car_type_id = @p_car_type_id
  ,@p_car_type_sname = @p_car_type_sname
  ,@p_car_state_id = @p_car_state_id
  ,@p_car_state_sname = @p_car_state_sname
  ,@p_car_mark_id = @p_car_mark_id
  ,@p_car_mark_sname = @p_car_mark_sname
  ,@p_car_model_id = @p_car_model_id
  ,@p_car_model_sname = @p_car_model_sname
  ,@p_car_kind_id = @p_car_kind_id
  ,@p_car_kind_sname = @p_car_kind_sname
  ,@p_short_name = @v_short_name
  ,@p_repair_type_master_id = @v_repair_type_master_id
  ,@p_organization_id = @p_organization_id
  ,@p_organization_sname = @p_organization_sname
  ,@p_amt = @v_amt
  ,@p_sys_comment = @p_sys_comment
  ,@p_sys_user = @p_sys_user


	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о ремонтах по автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.07.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()
  
select
	
		   date_created
		 , state_number
		 , car_id
		 , car_type_id
		 , car_type_sname
		 , car_state_id	
		 , car_state_sname
		 , car_mark_id
		 , car_mark_sname
		 , car_model_id
		 , car_model_sname
		 , car_kind_id
		 , car_kind_sname
		 , short_name
		 , repair_type_master_id
		 , amt
		 , organization_id
		 , organization_sname
	FROM dbo.utfVREP_REPAIR_BY_CAR_DAY() as a
	where ((date_created >= @p_start_date
		and date_created <= @p_end_date) or date_created = dbo.usfUtils_DayTo01(@p_start_date)
										  or date_created = dbo.usfUtils_DayTo01(@p_end_date))
	  and (car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (car_kind_id = @p_car_kind_id or @p_car_kind_id is null) 
	  and (car_id = @p_car_id or @p_car_id is null) 
	  and (organization_id = @p_organization_id or @p_organization_id is null)
order by 
	  date_created
	 ,organization_sname
	 ,state_number

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SelectAll] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить вид ремонта для заказа - наряда
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id		numeric(38,0)
	,@p_repair_type_master_id	numeric(38,0)
    ,@p_sys_comment				varchar(2000) = '-'
    ,@p_sys_user				varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_date_created datetime
		 , @v_car_id	   numeric(38,0) 


	select @v_date_created = date_created
		  ,@v_car_id	   = car_id
	  from dbo.CWRH_WRH_ORDER_MASTER
	where id = @p_wrh_order_master_id


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


      if (@@tranCount = 0)
        begin transaction 

	   insert into
			     dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
            ( wrh_order_master_id,  repair_type_master_id
			 , sys_comment, sys_user_created, sys_user_modified)
	   select  @p_wrh_order_master_id, @p_repair_type_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
		(select 1 from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as c
			where c.wrh_order_master_id = @p_wrh_order_master_id
			  and c.repair_type_master_id = @p_repair_type_master_id) 


	exec @v_Error = dbo.uspVREP_REPAIR_BY_CAR_DAY_Prepare 
   @p_date_created = @v_date_created
  ,@p_car_id = @v_car_id
  ,@p_sys_comment = @p_sys_comment
  ,@p_sys_user = @p_sys_user

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
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о ремонтах по автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime		= null
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
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error			 int
    ,@v_TrancountOnEntry int
	,@v_month_created	 datetime
	,@v_state_number	 varchar(20)
	,@v_short_name		 varchar(30)
	,@v_amt				 smallint
	,@v_repair_type_master_id numeric(38,0)
 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)
	
  
select  @v_short_name = c.short_name
	   ,@v_amt = count(b.repair_type_master_id)
	   ,@v_repair_type_master_id = b.repair_type_master_id 
from dbo.CWRH_WRH_ORDER_MASTER as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b
	on a.id = b.wrh_order_master_id
	join dbo.CRPR_REPAIR_TYPE_MASTER as c
	on b.repair_type_master_id = c.id
	join dbo.CCAR_CAR as d
	on a.car_id = d.id
where a.car_id = @p_car_id
   and a.date_created > = @v_month_created
   and a.date_created < dateadd("mm", 1, @v_month_created)
group by a.car_id, d.state_number,  c.short_name, b.repair_type_master_id

exec @v_Error = dbo.uspVREP_REPAIR_BY_CAR_DAY_SaveById
   @p_date_created = @v_month_created
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
  ,@p_car_kind_id = @p_car_kind_id
  ,@p_car_kind_sname = @p_car_kind_sname
  ,@p_short_name = @v_short_name
  ,@p_repair_type_master_id = @v_repair_type_master_id
  ,@p_organization_id = @p_organization_id
  ,@p_organization_sname = @p_organization_sname
  ,@p_amt = @v_amt
  ,@p_sys_comment = @p_sys_comment
  ,@p_sys_user = @p_sys_user


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


