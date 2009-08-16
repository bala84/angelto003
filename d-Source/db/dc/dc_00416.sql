:r ./../_define.sql

:setvar dc_number 00416
:setvar dc_description "datatype to consts added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.03.2009 VLavrentiev   datatype to consts added
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




alter table dbo.csys_const
add datatype varchar(30) default null
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Тип данных значения',
   'user', @CurrentUser, 'table', 'csys_const', 'column', 'datatype'
go


update dbo.csys_const
set datatype = 'int'
where name = 'Принятое количество рабочих часов автомобиля за смену'
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVSYS_CONST] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы CSYS_CONST
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,name
		  ,description
		  ,subsystem
		  ,datatype
      FROM dbo.CSYS_CONST
	
)
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVSYS_CONST_SelectBySubsystem]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о настройках подсистемы
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_subsystem varchar(60)
)
AS

    SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,name
		  ,description
		  ,subsystem
		  ,datatype
	FROM dbo.utfVSYS_CONST()
	where subsystem = @p_subsystem

	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVSYS_CONST_SaveByName]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить настройку системной переменной
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      09.03.2009 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_name          varchar(60) 
	,@p_id			  varchar(100)
    ,@p_description	  varchar(2000)
    ,@p_sys_comment   varchar(2000) = '-'
    ,@p_sys_user      varchar(30) = null
	,@p_datatype	  varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
--Проверим на тип данных - если он указан
     if (@p_datatype is not null)
	exec ('select convert(' + @p_datatype + ', ' + @p_id + ')')

    update dbo.csys_const
	   set id = @p_id
		  ,description = @p_description
		  ,sys_user_modified = @p_sys_user
	where name = @p_name
    
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



