:r ./../_define.sql

:setvar dc_number 00305
:setvar dc_description "employee search fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.06.2008 VLavrentiev  employee search fixed
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

ALTER PROCEDURE [dbo].[uspVPRT_Employee_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о сотрудниках
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
)
AS
SET NOCOUNT ON
  
 
 declare  
 
  @p_location_type_mobile_phone_id numeric(38,0)
 ,@p_location_type_home_phone_id numeric(38,0)
 ,@p_location_type_work_phone_id numeric(38,0)
 ,@p_table_name int
 ,@v_Srch_Str      varchar(1000)

 set @p_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @p_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @p_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')

 set @p_table_name = dbo.usfConst('dbo.CPRT_EMPLOYEE')

 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

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
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
	      	  ,org_name
		  ,job_title
		  ,lastname
		  ,name
		  ,surname
	FROM dbo.utfVPRT_EMPLOYEE(@p_location_type_mobile_phone_id
				 ,@p_location_type_home_phone_id
				 ,@p_location_type_work_phone_id
				 ,@p_table_name) as a
	WHERE (((@p_Str != '')
		   and (rtrim(ltrim(upper(lastname))) like rtrim(ltrim(upper(@p_Str + '%')))
				or rtrim(ltrim(upper(name))) like rtrim(ltrim(upper(@p_Str + '%')))
				or rtrim(ltrim(upper(surname))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))
	  /*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CPRT_PERSON, (name, lastname, surname), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.person_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))*/
	order by fio asc

	RETURN
GO

create index i_lastname_prt_person on dbo.CPRT_PERSON (lastname)
on $(fg_idx_name)
go


create index i_name_prt_person on dbo.CPRT_PERSON (name)
on $(fg_idx_name)
go

create index i_surname_prt_person on dbo.CPRT_PERSON (surname)
on $(fg_idx_name)
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
SET NOCOUNT ON
--Проставим по умолчанию пользователя - Механик
if (@p_username is null) or (@p_username = '')
  set @p_username = 'meh'
if (@p_password is null)  or (@p_password = '')
  set @p_password = 'meh1'
    
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
