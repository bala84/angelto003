:r ./../_define.sql

:setvar dc_number 00431
:setvar dc_description "reason procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   28.03.2009 VLavrentiev   reason procs added
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




CREATE PROCEDURE [dbo].[uspVCAR_RETURN_REASON_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о детальном плане выхода на линию по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,a.time
	  ,a.comments
	  ,a.mech_employee_id
	  ,g.id as organization_id
	  ,g.name as organization_sname
	  ,f.id as car_kind_id
	  ,f.short_name as car_kind_sname
	  ,a.rownum
	  ,e.id as car_return_reason_type_id
	  ,e.short_name as car_return_reason_type_sname
  from dbo.CCAR_RETURN_REASON_DETAIL as a
	join dbo.ccar_car as b
	  on a.car_id = b.id
	join dbo.ccar_car_return_reason_type as e
	  on e.id = a.car_return_reason_type_id
	join dbo.ccar_car_kind as f
	  on b.car_kind_id = f.id
	join dbo.cprt_organization as g
	  on b.organization_id = g.id
  where e.sys_status = 1
	and b.sys_status = 1
	and f.sys_status = 1
	and g.sys_status = 1
    and a.date = @p_date
	and b.car_kind_id = @p_car_kind_id
	and b.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_SelectByDate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_SelectByDate] TO [$(db_app_user)]
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go








create procedure [dbo].[uspVCAR_RETURN_REASON_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить детальный план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 	 datetime	   = null
	,@p_comments		 	varchar(1000) = null
	,@p_mech_employee_id 		numeric(38,0) = null
	,@p_car_return_reason_type_id	numeric(38,0)
	,@p_rownum			int
    	,@p_sys_comment		varchar(2000)  = '-'
    	,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_RETURN_REASON_DETAIL
            (car_id, date, "time",  comments ,mech_employee_id, car_return_reason_type_id
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_comments ,@p_mech_employee_id, @p_car_return_reason_type_id
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_RETURN_REASON_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, car_return_reason_type_id     = @p_car_return_reason_type_id
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return  

end

go

GRANT EXECUTE ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_SaveById] TO [$(db_app_user)]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



create procedure [dbo].[uspVCAR_RETURN_REASON_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из детальных планов выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) 
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
	set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

      if (@@tranCount = 0)
        begin transaction  

   update dbo.CCAR_RETURN_REASON_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.CCAR_RETURN_REASON_DETAIL
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_RETURN_REASON_DETAIL_DeleteById] TO [$(db_app_user)]
GO

create unique index u_car_return_reason_detail_car_id_time on dbo.ccar_return_reason_detail(car_id, time)
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



