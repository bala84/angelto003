:r ./../_define.sql

:setvar dc_number 00355
:setvar dc_description "user auth fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    05.08.2008 VLavrentiev  user auth fixed
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

ALTER PROCEDURE [dbo].[uspVPRT_USER_Authentication]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ѕроцедура должна проверить существует ли пользователь с
** указанным SID или парой логин/пароль) в базе пользователей
** и возвратить данные пользовател€ (SID и логин) в случае его 
** существовани€.
**
**  ¬ходные параметры:
**  @param p_Sid, 
**  @param p_Login, 
**  @param p_Password
**
**  ¬ случае (1. ) просто возвращаетс€ пользователь по его SID
**  ¬ случае (2.) провер€етс€ существование пары логин/пароль. 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	ƒобавил новую процедуру
*******************************************************************************/
	(
	@p_username varchar(60),
        @p_password varchar(60) = null
	)
AS
SET NOCOUNT ON
/*--ѕроставим по умолчанию пользовател€ - ћеханик
if (@p_username is null) or (@p_username = '')
  set @p_username = 'meh'
if (@p_password is null)  or (@p_password = '')
  set @p_password = 'meh1'*/
    
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


