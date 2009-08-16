:r ./../_define.sql

:setvar dc_number 00367
:setvar dc_description "driver license added to procs"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    26.08.2008 VLavrentiev  driver license added to procs
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

ALTER FUNCTION [dbo].[utfVPRT_EMPLOYEE] 
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
** 1.1      19.02.2008 VLavrentiev	Добавил обработку sex
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
		  ,a.driver_license
		  ,case when b.sex = 1 then 'М' 
			    when b.sex = 0 then 'Ж'
           else ''
		   end as sex
          	  ,b.lastname+' '+b.name+' '+isnull(b.surname,'') as FIO
		  ,b.lastname 
		  ,b.name
		  ,b.surname
		  ,b.birthdate
		  ,e1.location_string as mobile_phone
		  ,e2.location_string as home_phone
		  ,e3.location_string as work_phone
	      	  ,c.name as org_name
		  ,d.short_name as job_title
		  ,b.lastname+' '+isnull(substring(b.name,1,1),'') +'. '+ isnull(substring(b.surname,1,1),'')+ '.' as short_FIO
      FROM dbo.CPRT_EMPLOYEE as a
      JOIN dbo.CPRT_PERSON as b on a.person_id = b.id
	  JOIN dbo.CPRT_ORGANIZATION as c on a.organization_id = c.id
      JOIN dbo.CPRT_EMPLOYEE_TYPE as d on a.employee_type_id = d.id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
)
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
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVPRT_EMPLOYEE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить работника
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      21.02.2008 VLavrentiev	Изменил обработку @p_id
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) =null out
    ,@p_organization_id		numeric(38,0)
	,@p_person_id			numeric(38,0)
    ,@p_employee_type_id	numeric(38,0)
	,@p_driver_license		varchar(100)
	,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
   
     if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CPRT_EMPLOYEE 
            (organization_id, person_id, employee_type_id, driver_license, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_organization_id , @p_person_id, @p_employee_type_id, @p_driver_license, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CPRT_EMPLOYEE set
		 organization_id =  @p_organization_id
        ,person_id =  @p_person_id
		,employee_type_id = @p_employee_type_id
		,driver_license = @p_driver_license
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
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


