:r ./../_define.sql

:setvar dc_number 00398
:setvar dc_description "delete update user added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   23.11.2008 VLavrentiev  delete update user added
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_ADDTNL_TS_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить дополнительный тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.10.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
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


   update dbo.CCAR_ADDTNL_TS_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CCAR_ADDTNL_TS_TYPE_MASTER
	where id = @p_id


   update dbo.CRPR_REPAIR_TYPE_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id

   delete
	from dbo.CRPR_REPAIR_TYPE_DETAIL
	where repair_type_master_id = @p_id


   update dbo.CRPR_REPAIR_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id

   delete
	from dbo.CRPR_REPAIR_TYPE_MASTER
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVCAR_CAR_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из CAR
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.ccar_car
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.ccar_car
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVCAR_CAR_MARK_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из марок
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.ccar_car_mark
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.ccar_car_mark
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_CAR_MODEL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из моделей
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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


   update dbo.ccar_car_model
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.CCAR_CAR_MODEL
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVCAR_CAR_STATE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов состояний
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CCAR_CAR_STATE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_CAR_STATE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVCAR_CAR_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CCAR_CAR_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_CAR_TYPE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_FUEL_MODEL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связочной таблицы типов топлива и модели
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id	numeric(38,0)
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

   update dbo.CCAR_FUEL_MODEL
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_FUEL_MODEL
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit

    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_FUEL_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов топлива
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0)
    ,@p_fuel_model_id   numeric(38,0) 
,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
   
   if (@@tranCount = 0)
    begin transaction 


   exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_DeleteById
				 @p_id = @p_fuel_model_id

   if (@v_Error > 0)
	begin 
		if (@@tranCount > @v_TrancountOnEntry)
			rollback
		return @v_Error
	end 

   if not exists (select 1 from dbo.CCAR_FUEL_MODEL
					where fuel_type_id = @p_id)

   update dbo.CCAR_FUEL_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_FUEL_TYPE
	where id = @p_id
   
    if (@@tranCount > @v_TrancountOnEntry)
    commit

  
 
  return 

end
go

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

  if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

      if (@@tranCount = 0)
        begin transaction  

   update dbo.CCAR_TS_TYPE_RELATION
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete from dbo.CCAR_TS_TYPE_RELATION
	where child_id = @p_id
		or parent_id = @p_id 

   update dbo.CCAR_TS_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CCAR_TS_TYPE_MASTER
	where id = @p_id

   update dbo.CRPR_REPAIR_TYPE_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CRPR_REPAIR_TYPE_DETAIL
	where repair_type_master_id = @p_id

   update dbo.CRPR_REPAIR_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CRPR_REPAIR_TYPE_MASTER
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_TS_TYPE_RELATION_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из отношений между ТО
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0)
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

   update dbo.CCAR_TS_TYPE_RELATION
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.CCAR_TS_TYPE_RELATION
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
 
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_TS_TYPE_ROUTE_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей маршрутов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
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

   update dbo.CCAR_TS_TYPE_ROUTE_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
	where id = @p_id

if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVCAR_TS_TYPE_ROUTE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из  маршрутов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CCAR_TS_TYPE_ROUTE_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.CCAR_TS_TYPE_ROUTE_DETAIL
	where ts_type_route_master_id = @p_id

   update dbo.CCAR_TS_TYPE_ROUTE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CCAR_TS_TYPE_ROUTE_MASTER
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDEV_DEVICE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из устройств
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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


   update dbo.CDEV_DEVICE
	set sys_user_modified = @p_sys_user
	where id = @p_id 

	delete
	from dbo.CDEV_DEVICE
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDRV_CONTROL_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов контроля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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


   update dbo.CDRV_CONTROL_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CDRV_CONTROL_TYPE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDRV_DRIVER_CONTROL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_control_type_id numeric(38,0)
    ,@p_employee_id		numeric(38,0)
	,@p_driver_list_id  numeric(38,0)
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


   update dbo.CDRV_DRIVER_CONTROL
	set sys_user_modified = @p_sys_user
	where control_type_id = @p_control_type_id
			and employee_id = @p_employee_id
			and driver_list_id = @p_driver_list_id

	delete
	from dbo.CDRV_DRIVER_CONTROL
	where control_type_id = @p_control_type_id
			and employee_id = @p_employee_id
			and driver_list_id = @p_driver_list_id
    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)
	 , @v_speedometer_end_indctn numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount



 if (@@tranCount = 0)
	  begin transaction 

	select @v_car_id = car_id
		  ,@v_speedometer_end_indctn = speedometer_end_indctn
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id 

    if (@v_speedometer_end_indctn is null)
     begin

	   update dbo.CDRV_TRAILER
		set sys_user_modified = @p_sys_user
		where driver_list_id = @p_id




		delete 
		from dbo.CDRV_TRAILER
		where driver_list_id = @p_id


	   update dbo.CDRV_DRIVER_LIST
		set sys_user_modified = @p_sys_user
		where id = @p_id




		delete
		from dbo.CDRV_DRIVER_LIST
		where id = @p_id


	   update dbo.CREP_DRIVER_LIST
		set sys_user_modified = @p_sys_user
		where id = @p_id



		delete
		from dbo.CREP_DRIVER_LIST
		where id = @p_id 


		update dbo.CCAR_CAR
		set car_state_id = dbo.usfConst('IN_PARK')
		where id = @v_car_id


	 end

if (@@tranCount > @v_TrancountOnEntry)
    commit


    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          		 numeric(38,0)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_car_id numeric(38,0)
		 , @v_run	 decimal(18,9)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_emp_id	   numeric(38,0) 
		 , @v_condition_id     numeric(38,0)
		 , @v_date_created datetime
		 , @v_last_date_created datetime
		 , @v_number	     numeric(38,0)
		 , @v_fact_start_duty datetime
		 , @v_fact_end_duty   datetime
		 , @v_fuel_exp		decimal(18,9)
		 , @v_fuel_type_id    numeric(38,0)
		 , @v_organization_id numeric(38,0)
		 , @v_speedometer_start_indctn decimal(18,9)
		 , @v_speedometer_end_indctn	 decimal(18,9)
		 , @v_fuel_start_left			 decimal(18,9)			 
		 , @v_fuel_end_left			 decimal(18,9)
		 , @v_fuel_gived				 decimal(18,9)
		 , @v_fuel_return				 decimal(18,9)	
		 , @v_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_fuel_consumption		 decimal(18,9)
		 , @v_driver_list_state_id	 numeric(38,0)


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount


  

   if (@@tranCount = 0)
	  begin transaction 

	select  @v_car_id = car_id
		   ,@v_emp_id = employee1_id
		   ,@v_date_created = date_created
		   ,@v_last_date_created = last_date_created
		   ,@v_number = number
		   ,@v_fact_start_duty = fact_start_duty
		   ,@v_fact_end_duty = fact_end_duty
		   ,@v_fuel_exp = fuel_exp
		   ,@v_fuel_type_id = fuel_type_id
		   ,@v_organization_id = organization_id
		   ,@v_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_fuel_start_left = fuel_start_left
		   ,@v_fuel_end_left = fuel_end_left
		   ,@v_fuel_gived = fuel_gived
		   ,@v_fuel_return = fuel_return	
		   ,@v_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_run = run	
		   ,@v_fuel_consumption	= fuel_consumption
		   ,@v_driver_list_state_id = driver_list_state_id
		from dbo.CDRV_DRIVER_LIST
	 where id = @p_id

   update dbo.CDRV_TRAILER
	set sys_user_modified = @p_sys_user
	where driver_list_id = @p_id

	delete 
	from dbo.CDRV_TRAILER
	where driver_list_id = @p_id

   update dbo.CDRV_DRIVER_LIST
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.CDRV_DRIVER_LIST
	where id = @p_id

   update dbo.CREP_DRIVER_LIST
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CREP_DRIVER_LIST
	where id = @p_id 

if (not exists (select TOP(1) 1 from dbo.CDRV_DRIVER_LIST
				where driver_list_state_id = dbo.usfConst('LIST_OPEN')
				  and speedometer_end_indctn is null
				  and car_id = @v_car_id))
 update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK')
	where id = @v_car_id

 
   if (@v_run > 0)
    update dbo.CCAR_CONDITION
	    set run = run - @v_run
	where car_id = @v_car_id

--Посчитаем отчеты, если у нас закрытый п/л
if (@v_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Отчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_date_created
	,@p_number						= @v_number
	,@p_car_id						= @v_car_id
	,@p_fact_start_duty				= @v_fact_start_duty
	,@p_fact_end_duty				= @v_fact_end_duty
	,@p_fuel_exp					= @v_fuel_exp
	,@p_fuel_type_id				= @v_fuel_type_id
	,@p_organization_id				= @v_organization_id
	,@p_employee1_id				= @v_emp_id
	,@p_employee2_id				= @v_emp_id
	,@p_speedometer_start_indctn	= @v_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_speedometer_end_indctn
	,@p_fuel_start_left				= @v_fuel_start_left
	,@p_fuel_end_left				= @v_fuel_end_left
	,@p_fuel_gived					= @v_fuel_gived
	,@p_fuel_return					= @v_fuel_return	
	,@p_fuel_addtnl_exp				= @v_fuel_addtnl_exp	
	,@p_run							= @v_run	
	,@p_fuel_consumption			= @v_fuel_consumption
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 


 
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_date_created	  
	,@p_employee_id			= @v_emp_id
	,@p_last_date_created			= @v_last_date_created
    ,@p_sys_comment					= '-'
    ,@p_sys_user					= '-'

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

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_STATE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку состояния путевого листа
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
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

   update dbo.CDRV_DRIVER_LIST_STATE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CDRV_DRIVER_LIST_STATE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку тип путевого листа
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CDRV_DRIVER_LIST_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CDRV_DRIVER_LIST_TYPE
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из планов выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CDRV_DRIVER_PLAN
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.CDRV_DRIVER_PLAN
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVDRV_MONTH_PLAN_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из планов выхода на линию
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CDRV_MONTH_PLAN
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CDRV_MONTH_PLAN
	where id = @p_id
    



	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVDRV_TRAILER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_device_id          numeric(38,0)
    ,@p_driver_list_id     numeric(38,0)
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

   update dbo.CDRV_TRAILER
	set sys_user_modified = @p_sys_user
	where device_id = @p_device_id
	  and driver_list_id = @p_driver_list_id


	delete
	from dbo.CDRV_TRAILER
	where device_id = @p_device_id
	  and driver_list_id = @p_driver_list_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVLOC_LOCATION_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип адреса
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CLOC_LOCATION_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.CLOC_LOCATION_TYPE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVNOT_NOTE_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CNOT_NOTE_TYPE
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CNOT_NOTE_TYPE
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVPRT_EMPLOYEE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить работника
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cprt_employee
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cprt_employee
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVPRT_EMPLOYEE_EVENT_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить событие работника
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.10.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cprt_employee_event
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.cprt_employee_event
	where id = @p_id
    

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVPRT_EMPLOYEE_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из должностей
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cprt_employee_type
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cprt_employee_type
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[uspVPRT_ORGANIZATION_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить организацию
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
	set nocount on
	set xact_abort on
  

	declare	@v_Error int
			, @v_TrancountOnEntry int

  -- обработка системных записей
  if ((@p_id <> dbo.usfConst('ORG1')) and (@p_id <> dbo.usfConst('ORG2'))
		and (@p_id <> dbo.usfConst('ORG1')) and (@p_id <> dbo.usfConst('ORG1')))
begin


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   
    if (@@tranCount = 0)
        begin transaction  

   update dbo.cprt_organization
	set sys_user_modified = @p_sys_user
	where id = @p_id


    
	delete
	from dbo.cprt_organization
	where id = @p_id


	exec @v_Error = 
        dbo.uspVPRT_Party_DeleteById
        @p_id = @p_id

    if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

	if (@@tranCount > @v_TrancountOnEntry)
		commit

end
    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVPRT_PARTY_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связочной таблицы
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cprt_party
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cprt_party
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVPRT_PERSON_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить физ. лицо
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cprt_person
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.cprt_person
	where id = @p_id
    


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
AS
BEGIN

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

   update dbo.CREP_SERIAL_LOG
	set sys_user_modified = @p_sys_user
	where id = @p_id


delete from dbo.CREP_SERIAL_LOG
where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
 
END

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_BILL_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить ведомость запчастей для ремонта
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
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

 update dbo.CRPR_REPAIR_BILL_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id





delete
	from dbo.CRPR_REPAIR_BILL_DETAIL
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_BILL_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить ведомость запчастей для ремонта
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.09.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CRPR_REPAIR_BILL_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id



   delete
	from dbo.CRPR_REPAIR_BILL_DETAIL
	where repair_bill_master_id = @p_id 



   update dbo.CRPR_REPAIR_BILL_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id




delete
	from dbo.CRPR_REPAIR_BILL_MASTER
	where id = @p_id



	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_TYPE_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО деталь
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
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

   update dbo.CRPR_REPAIR_TYPE_DETAIL
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CRPR_REPAIR_TYPE_DETAIL
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    

    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из складов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
set nocount on
  set xact_abort on

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


      if (@@tranCount = 0)
        begin transaction  


   update dbo.CCAR_TS_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CCAR_TS_TYPE_MASTER
	where id = @p_id


   update dbo.CRPR_REPAIR_TYPE_DETAIL
	set sys_user_modified = @p_sys_user
	where repair_type_master_id = @p_id


   delete
	from dbo.CRPR_REPAIR_TYPE_DETAIL
	where repair_type_master_id = @p_id


   update dbo.CRPR_REPAIR_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where id = @p_id


   delete
	from dbo.CRPR_REPAIR_TYPE_MASTER
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVRPR_REPAIR_TYPE_MASTER_KIND_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов ремонтов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.10.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.CRPR_REPAIR_TYPE_MASTER_KIND
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.CRPR_REPAIR_TYPE_MASTER_KIND
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей ремонтной зоны
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.crpr_repair_zone_detail
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.crpr_repair_zone_detail
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVRPR_REPAIR_ZONE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из ремонтных зон
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      13.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.crpr_repair_zone_detail
	set sys_user_modified = @p_sys_user
	where repair_zone_master_id = @p_id 

   delete
	from dbo.crpr_repair_zone_detail
	where repair_zone_master_id = @p_id 

   update dbo.CWRH_WRH_ORDER_MASTER
	set repair_zone_master_id = null
	where repair_zone_master_id = @p_id


   update dbo.crpr_repair_zone_master
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.crpr_repair_zone_master
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[uspVSYS_SERIAL_LOG_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить данные из лога ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
AS
BEGIN

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

   update dbo.CSYS_SERIAL_LOG
	set sys_user_modified = @p_sys_user
	where id = @p_id


delete from dbo.CSYS_SERIAL_LOG
where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
END

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_GOOD_CATEGORY_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить тип ТО деталь
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_id numeric(38,0)
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

   update dbo.CWRH_GOOD_CATEGORY
	set sys_user_modified = @p_sys_user
	where id = @p_id




	delete
	from dbo.CWRH_GOOD_CATEGORY
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из категорий товаров
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cwrh_good_category_type
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.cwrh_good_category_type
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
    
  return 

end

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_DEMAND_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связи заказов-нарядов и требования
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id         numeric(38,0) 
	,@p_wrh_demand_master_id		numeric(38,0)
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

   update dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
	set sys_user_modified = @p_sys_user
	where wrh_order_master_id  = @p_wrh_order_master_id  
	  and wrh_demand_master_id = @p_wrh_demand_master_id


   delete
	from dbo.CWRH_ORDER_MASTER_DEMAND_MASTER
	where wrh_order_master_id  = @p_wrh_order_master_id  
	  and wrh_demand_master_id = @p_wrh_demand_master_id

    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_ORDER_MASTER_REPAIR_TYPE_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связи заказов-нарядов и видов ремонта
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_wrh_order_master_id         numeric(38,0) 
	,@p_repair_type_master_id		numeric(38,0)
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

   update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where wrh_order_master_id  = @p_wrh_order_master_id  
	  and repair_type_master_id = @p_repair_type_master_id





   delete
	from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	where wrh_order_master_id  = @p_wrh_order_master_id  
	  and repair_type_master_id = @p_repair_type_master_id



	if (@@tranCount > @v_TrancountOnEntry)
        commit

    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WAREHOUSE_ITEM_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из содержимого складов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cwrh_warehouse_item
	set sys_user_modified = @p_sys_user
	where id = @p_id



	delete
	from dbo.cwrh_warehouse_item
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WAREHOUSE_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из складов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cwrh_warehouse_type
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cwrh_warehouse_type
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей требований
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
	,@p_sys_user	varchar(30) = null
	,@p_sys_comment varchar(2000) = '-'
	,@p_last_organization_giver_id numeric(38,0) = null
)
as
begin
  set nocount on  
  set xact_abort on

	declare
			 @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
	  	  , @v_last_amount decimal(18,9)
		  , @v_last_price  decimal(18,9)
		  , @v_last_good_category_id numeric(38,0)
		  , @v_last_organization_id	  numeric(38,0)
		  , @v_last_warehouse_type_id numeric(38,0)
		  , @v_last_warehouse_item_id numeric(38,0)


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

   update dbo.cwrh_wrh_demand_detail
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cwrh_wrh_demand_detail
	where id = @p_id

   update dbo.crep_wrh_demand
	set sys_user_modified = @p_sys_user
	where wrh_demand_detail_id = @p_id

	delete from dbo.crep_wrh_demand
	where wrh_demand_detail_id = @p_id


   if (@@tranCount > @v_TrancountOnEntry)
        commit

    
  return 

end


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из требований
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
	,@p_sys_user	varchar(30) = null
	,@p_sys_comment varchar(2000) = '-'
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


   update dbo.cwrh_wrh_demand_detail
	set sys_user_modified = @p_sys_user
	where wrh_demand_master_id = @p_id

	delete from dbo.cwrh_wrh_demand_detail
	where wrh_demand_master_id = @p_id

   update dbo.cwrh_wrh_demand_master
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.cwrh_wrh_demand_master
	where id = @p_id

   update dbo.crep_wrh_demand
	set sys_user_modified = @p_sys_user
	where wrh_demand_master_id = @p_id


	delete from dbo.crep_wrh_demand
	where wrh_demand_master_id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end


go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_INCOME_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей приходных документов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
	,@p_last_organization_recieve_id numeric(38,0) = null
	,@p_last_warehouse_type_id	   numeric(38,0) = null 
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
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

   update dbo.cwrh_wrh_income_detail
	set sys_user_modified = @p_sys_user
	where id = @p_id

 

	delete
	from dbo.cwrh_wrh_income_detail
	where id = @p_id



	   if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из приходных документов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
	,@p_sys_user	varchar(30) = null
	,@p_sys_comment varchar(2000) = '-'
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

   update dbo.cwrh_wrh_income_detail
	set sys_user_modified = @p_sys_user
	where wrh_income_master_id = @p_id

	delete from dbo.cwrh_wrh_income_detail
	where wrh_income_master_id = @p_id


   update dbo.cwrh_wrh_income_master
	set sys_user_modified = @p_sys_user
	where id = @p_id


	delete
	from dbo.cwrh_wrh_income_master
	where id = @p_id


	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 
end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_ORDER_DETAIL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из деталей заказов-нарядов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   update dbo.cwrh_wrh_order_detail
	set sys_user_modified = @p_sys_user
	where id = @p_id

	delete
	from dbo.cwrh_wrh_order_detail
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
    
  return 

end

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из заказов-нарядов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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


   update dbo.CWRH_WRH_ORDER_DETAIL
	set sys_user_modified = @p_sys_user
	where wrh_order_master_id = @p_id 



   delete
	from dbo.CWRH_WRH_ORDER_DETAIL
	where wrh_order_master_id = @p_id 


   update dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	set sys_user_modified = @p_sys_user
	where wrh_order_master_id = @p_id



delete
	from dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER
	where wrh_order_master_id = @p_id


   update dbo.cwrh_wrh_order_master
	set sys_user_modified = @p_sys_user
	where id = @p_id




	delete
	from dbo.cwrh_wrh_order_master
	where id = @p_id


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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

:r _add_chis_all_objects.sql


