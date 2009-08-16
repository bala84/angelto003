:r ./../_define.sql
:setvar dc_number 00001
:setvar dc_description "CPRT_USER procs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    16.02.2008 VLavrentiev  CPRT_USER procs added   
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.utfVPRT_USER 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения теблицы CPRT_USER
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
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
		  ,username
		  ,password
      FROM dbo.CPRT_USER
	
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVPRT_USER] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[uspVPRT_USER_Authentication]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна проверить существует ли пользователь с
** указанным SID или парой логин/пароль) в базе пользователей
** и возвратить данные пользователя (SID и логин) в случае его 
** существования.
**
**  Входные параметры:
**  @param p_Sid, 
**  @param p_Login, 
**  @param p_Password
**
**  В случае (1. ) просто возвращается пользователь по его SID
**  В случае (2.) проверяется существование пары логин/пароль. 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
	(
	@p_username varchar(60),
        @p_password varchar(60) = null
	)
AS
  
    SELECT     Id
              ,username
	      ,sys_status
	      ,sys_comment
	      ,sys_date_modified
	      ,sys_date_created
	      ,sys_user_modified
	      ,sys_user_created
	FROM dbo.utfVPRT_USER()
	WHERE username = @p_username 
      and password = @p_password;

	RETURN
go




GRANT EXECUTE ON [dbo].[uspVPRT_USER_Authentication] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_USER_Authentication] TO [$(db_app_user)]
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

