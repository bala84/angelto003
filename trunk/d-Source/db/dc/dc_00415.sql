:r ./../_define.sql

:setvar dc_number 00415
:setvar dc_description "return reason type procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.03.2009 VLavrentiev   return reason type procs added
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



drop table dbo.csys_value
go

ALTER TABLE [dbo].[CSYS_CONST]
drop constraint csys_const_pk
go

alter table dbo.csys_const
alter column id varchar(100) not null
go


ALTER TABLE [dbo].[CSYS_CONST] ADD  CONSTRAINT [csys_const_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[name] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [$(fg_idx_name)]
go

insert into dbo.csys_const(id, name, description)
values('10', 'LOG_MESSAGE_LEVEL', 'Уровень сообщений лога')
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[usfConst] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения констант CSYS_CONST
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_name varchar(60)
)
RETURNS int
AS
BEGIN	
DECLARE @p_Result_id int;

	SELECT @p_Result_id = convert(int, id) from dbo.utfVSYS_CONST()
	WHERE name = @p_name;

	RETURN @p_Result_id
END

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER FUNCTION [dbo].[usfValue] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения значений CSYS_VALUE
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.10.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_name varchar(60)
)
RETURNS int
AS
BEGIN	
DECLARE @p_Result_id int;

	SELECT @p_Result_id = convert(int, id) from dbo.utfVSYS_CONST()
	WHERE name = @p_name;

	RETURN @p_Result_id
END
go


alter table dbo.csys_const
add subsystem varchar(60) default 'system' not null
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Подсистема, для которой предназначена константа/значение',
   'user', @CurrentUser, 'table', 'csys_const', 'column', 'subsystem'
go


create index i_csys_const_subsystem on dbo.csys_const(subsystem)
on [$(fg_idx_name)]
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVSYS_CONST_SaveByName]
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

    update dbo.csys_const
	   set id = @p_id
		  ,description = @p_description
		  ,sys_user_modified = @p_sys_user
	where name = @p_name
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVSYS_CONST_SaveByName] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVSYS_CONST_SaveByName] TO [$(db_app_user)]
GO


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
      FROM dbo.CSYS_CONST
	
)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVSYS_CONST_SelectBySubsystem]
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
	FROM dbo.utfVSYS_CONST()
	where subsystem = @p_subsystem

	RETURN
go


GRANT EXECUTE ON [dbo].[uspVSYS_CONST_SelectBySubsystem] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVSYS_CONST_SelectBySubsystem] TO [$(db_app_user)]
GO


insert into dbo.csys_const(id, name, description, subsystem)
values('8', 'Принятое количество рабочих часов автомобиля за смену','Данная настройка определяет принятое количество рабочего времени, которое должен проработать автомобиль', 'general')
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


