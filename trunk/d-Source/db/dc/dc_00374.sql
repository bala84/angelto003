:r ./../_define.sql

:setvar dc_number 00374
:setvar dc_description "employee select by id added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.09.2008 VLavrentiev  employee select by id added
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVPRT_Employee_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о сотруднике
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
 
 declare  
 
  @p_location_type_mobile_phone_id numeric(38,0)
 ,@p_location_type_home_phone_id numeric(38,0)
 ,@p_location_type_work_phone_id numeric(38,0)
 ,@p_table_name int

 set @p_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @p_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @p_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')

 set @p_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')
 

       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,organization_id
		  ,person_id
		  ,employee_type_id
		  ,sex
          	  ,FIO
		  ,short_FIO
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
	      	  ,org_name
		  ,job_title
		  ,lastname
		  ,name
		  ,surname
		  ,driver_license
	FROM dbo.utfVPRT_EMPLOYEE(@p_location_type_mobile_phone_id
				 ,@p_location_type_home_phone_id
				 ,@p_location_type_work_phone_id
				 ,@p_table_name) as a
	WHERE id = @p_id

	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVPRT_Employee_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_Employee_SelectById] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить открытую путевку
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on


	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id


    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить открытую путевку
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount



 if (@@tranCount = 0)
	  begin transaction 

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id

if (@@tranCount > @v_TrancountOnEntry)
    commit


    
  return 

end
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить открытую путевку
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount



 if (@@tranCount = 0)
	  begin transaction 

	select @v_car_id = car_id
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id

	update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

if (@@tranCount > @v_TrancountOnEntry)
    commit


    
  return 

end
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_Delete_OpenById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить открытую путевку
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount



 if (@@tranCount = 0)
	  begin transaction 

	select @v_car_id = car_id
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

	delete 
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id


	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id 


	update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

if (@@tranCount > @v_TrancountOnEntry)
    commit


    
  return 

end
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
