:r ./../_define.sql
:setvar dc_number 00007
:setvar dc_description "VPRT_PERSON insert, update, delete added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.02.2008 VLavrentiev  VPRT_PERSON insert, update, delete added   
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


print ' '
print 'Adding utfVPRT_PERSON...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVPRT_PERSON] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности PERSON
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_location_type_mobile_phone_id  numeric(38,0)
 ,@p_location_type_home_phone_id    numeric(38,0)
 ,@p_location_type_work_phone_id    numeric(38,0)
 ,@p_location_type_fact_id		    numeric(38,0)
 ,@p_location_type_jur_id		    numeric(38,0) 
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
		  ,case when a.sex = 1 then 'М' 
			    when a.sex = 0 then 'Ж'
           else ''
		   end as sex
          	  ,a.lastname+' '+a.name+' '+isnull(a.surname,'') as FIO
		  ,a.birthdate
		  ,e1.location_string as mobile_phone
		  ,e2.location_string as home_phone
		  ,e3.location_string as work_phone
		  ,e4.location_string as fact_address
		  ,e5.location_string as jur_address
      FROM dbo.CPRT_PERSON as a
	LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      	LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
	LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_fact_id) as e4 on a.id = e4.record_id
      	LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_jur_id) as e5 on a.id = e5.record_id
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVPRT_PERSON] TO [$(db_app_user)]
GO



print ' '
print 'Adding const values...'
go



insert into dbo.CSYS_CONST(id,name,description)
values (22,'dbo.CPRT_PERSON','Тип - таблица PERSON')
go



print ' '
print 'Adding uspVPRT_PERSON_SelectAll...'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[uspVPRT_PERSON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о физ. лицах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS

    SET NOCOUNT ON
  
 
 declare  
 
  @p_location_type_mobile_phone_id numeric(38,0)
 ,@p_location_type_home_phone_id numeric(38,0)
 ,@p_location_type_work_phone_id numeric(38,0)
 ,@p_location_type_fact_id		 numeric(38,0)
 ,@p_location_type_jur_id		 numeric(38,0)
 ,@p_table_name int

 set @p_location_type_mobile_phone_id = dbo.usfConst('MOBILE_PHONE')
 set @p_location_type_home_phone_id = dbo.usfConst('HOME_PHONE')
 set @p_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')
 set @p_location_type_fact_id		= dbo.usfConst('LOC_FACT_ID')
 set @p_location_type_jur_id		= dbo.usfConst('LOC_JUR_ID')

 set @p_table_name = dbo.usfConst('dbo.CPRT_PERSON')

       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,sex
			,FIO
		  ,birthdate
		  ,mobile_phone
		  ,home_phone
		  ,work_phone
		  ,fact_address
		  ,jur_address
	FROM dbo.utfVPRT_PERSON
				(@p_location_type_mobile_phone_id
				,@p_location_type_home_phone_id
				,@p_location_type_work_phone_id
				,@p_location_type_fact_id
				,@p_location_type_jur_id
				,@p_table_name)

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVPRT_PERSON_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_PERSON_SelectAll] TO [$(db_app_user)]
GO


print ' '
print 'Adding uspVPRT_PERSON_DeleteById...'
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVPRT_PERSON_DeleteById]
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
)
as
begin
  set nocount on

	delete
	from dbo.cprt_person
	where id = @p_id
    
  return 

end
go


GRANT EXECUTE ON [dbo].[uspVPRT_PERSON_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_PERSON_DeleteById] TO [$(db_app_user)]
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

