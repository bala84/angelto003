:r ./../_define.sql
:setvar dc_number 00004
:setvar dc_description "VPRT_EMPLOYEE added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    18.02.2008 VLavrentiev  VPRT_EMPLOYEE added   
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

PRINT ' '
PRINT 'Adding const values...'
go

insert into dbo.CSYS_CONST(id,name,description) values (10,'MOBILE_PHONE','Тип - мобильный телефон');

insert into dbo.CSYS_CONST(id,name,description) values (11,'HOME_PHONE','Тип - домашний телефон');

insert into dbo.CSYS_CONST(id,name,description) values (12,'WORK_PHONE','Тип - рабочий телефон');

insert into dbo.CSYS_CONST(id,name,description) values (20,'dbo.CPRT_EMPLOYEE','Тип - таблица EMPLOYEE');

PRINT ' '
PRINT 'Adding utfVLOC_LOCATION...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVLOC_LOCATION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности LOCATION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_table_name int
 ,@p_location_type_id numeric(38,0)
)
RETURNS TABLE 
AS
RETURN 
(
 SELECT    a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.location_id
		  ,a.location_type_id
		  ,a.table_name
		  ,a.record_id
          ,a.is_default
		  ,b.short_name
		  ,c.location_string
   FROM dbo.CLOC_LOCATION_LINK as a
    JOIN dbo.CLOC_LOCATION_TYPE as b on a.location_type_id = b.id
    JOIN dbo.CLOC_LOCATION as c on a.location_id = c.id
  where a.table_name = @p_table_name
    and a.location_type_id = @p_location_type_id
)
GO

GRANT VIEW DEFINITION ON [dbo].[utfVLOC_LOCATION] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Adding utfVPRT_EMPLOYEE...'
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVPRT_EMPLOYEE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности EMPLOYEE
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_location_type_mobile_phone_id  numeric(38,0)
 ,@p_location_type_home_phone_id    numeric(38,0)
 ,@p_location_type_work_phone_id    numeric(38,0)
 ,@p_table_name 		    int
)
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
		  ,a.organization_id
		  ,a.person_id
		  ,a.employee_type_id
		  ,b.sex
          	  ,b.lastname+' '+b.name+' '+isnull(b.surname,'') as FIO
		  ,b.birthdate
		  ,e1.location_string as mobile_phone
		  ,e2.location_string as home_phone
		  ,e3.location_string as work_phone
	      	  ,c.name as org_name
		  ,d.short_name as job_title
      FROM dbo.CPRT_EMPLOYEE as a
      JOIN dbo.CPRT_PERSON as b on a.person_id = b.id
	  JOIN dbo.CPRT_ORGANIZATION as c on a.organization_id = c.id
      JOIN dbo.CPRT_EMPLOYEE_TYPE as d on a.employee_type_id = d.id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
)


go

GRANT VIEW DEFINITION ON [dbo].[utfVPRT_EMPLOYEE] TO [$(db_app_user)]
GO

print ' '
print 'Adding uspVPRT_Employee_SelectAll'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVPRT_Employee_SelectAll]
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
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
	      	  ,org_name
		  ,job_title
	FROM dbo.utfVPRT_EMPLOYEE(@p_location_type_mobile_phone_id
				 ,@p_location_type_home_phone_id
				 ,@p_location_type_work_phone_id
				 ,@p_table_name)

	RETURN
go


GRANT EXECUTE ON [dbo].[uspVPRT_Employee_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_Employee_SelectAll] TO [$(db_app_user)]
GO

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

print ' '
print 'Alter table dbo.cprt_person...'
go

alter table dbo.cprt_person
alter column name varchar(60) not null
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

