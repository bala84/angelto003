:r ./../_define.sql
:setvar dc_number 00025
:setvar dc_description "fuel_norm fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    22.02.2008 VLavrentiev  fuel_norm fixed   
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


DECLARE ref_cursor CURSOR
   FOR
select o.name from sys.sysobjects o 
			join sys.tables r on r.object_id = o.parent_obj
			join sys.columns f on r.object_id = f.object_id 
			join sys.sysconstraints g on f.column_id = g.colid
								and o.id = g.constid
where r.name = 'CDRV_DRIVER_LIST'
  and f.name = 'fuel_norm';
OPEN  ref_cursor;
DECLARE @v_object_name varchar(100)

        
FETCH NEXT FROM ref_cursor INTO @v_object_name;
WHILE (@@FETCH_STATUS <> -1)
BEGIN
 exec ('alter table dbo.CDRV_DRIVER_LIST drop ' + @v_object_name)

   FETCH NEXT FROM ref_cursor INTO @v_object_name;
END;
PRINT 'The ref have been dropped';
CLOSE ref_cursor;
DEALLOCATE ref_cursor;
GO


alter table dbo.CDRV_DRIVER_LIST
alter column fuel_norm decimal
go

alter table dbo.CDRV_DRIVER_LIST
drop column fuel_norm
go


alter table dbo.CCAR_CAR_MODEL
add fuel_norm decimal default 0.0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Норма расхода топлива',
   'user', @CurrentUser, 'table', 'CCAR_CAR_MODEL', 'column', 'fuel_norm'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR_MODEL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения моделей автомобилей
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.short_name
		  ,a.full_name
		  ,a.mark_id
		  ,b.short_name as car_mark_name
		  ,a.fuel_norm
      FROM dbo.CCAR_CAR_MODEL as a
		JOIN dbo.CCAR_CAR_MARK as b on a.mark_id = b.id	
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_MODEL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить модель автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) = null out
    ,@p_short_name  varchar(30)
    ,@p_full_name   varchar(60)
	,@p_mark_id		numeric(38,0)
	,@p_fuel_norm   decimal		  = 0.0
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_fuel_norm is null)
	set @p_fuel_norm = 0.0

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR_MODEL 
            (short_name, full_name, mark_id, fuel_norm, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_mark_id, @p_fuel_norm, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CAR_MODEL set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,mark_id = @p_mark_id
	    ,fuel_norm = @p_fuel_norm
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_MODEL_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о моделях автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,mark_id
		  ,car_mark_name
		  ,fuel_norm
	FROM dbo.utfVCAR_CAR_MODEL()

	RETURN
GO

print ' '
print 'Altering driver_list...'
go

alter table dbo.CDRV_DRIVER_LIST
drop column number
go

alter table dbo.CDRV_DRIVER_LIST
add number numeric(38,0) not null
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер п/л',
   'user', @CurrentUser, 'table', 'CDRV_DRIVER_LIST', 'column', 'number'
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
