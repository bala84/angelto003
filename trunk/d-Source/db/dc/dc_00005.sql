:r ./../_define.sql
:setvar dc_number 00005
:setvar dc_description "VPRT_EMPLOYEE insert, update, delete added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.02.2008 VLavrentiev  VPRT_EMPLOYEE insert, update, delete added   
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
		  ,case when b.sex = 1 then 'М' 
			    when b.sex = 0 then 'Ж'
           else ''
		   end as sex
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
GO



PRINT ' '
PRINT 'Creating  uspCPRT_PARTY_SaveById...'
go


CREATE procedure [dbo].[uspVPRT_PARTY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**  Входные параметры:
**  @param p_id, 
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          numeric(38,0) out,
    @p_sys_comment varchar(2000) = '-',
    @p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  if (@p_sys_user is null)
    set @p_sys_user = user_name()
    -- надо добавлять
		insert into
			dbo.CPRT_PARTY 
            (sys_comment, sys_user_created, sys_user_modified)
		values
			(@p_sys_comment, @p_sys_user,  @p_sys_user)

         set @p_id = SCOPE_IDENTITY();

  return
   
end
go

GRANT EXECUTE ON [dbo].[uspVPRT_PARTY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_PARTY_SaveById] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating uspVPRT_PERSON_SaveById...'
go

CREATE procedure [dbo].[uspVPRT_PERSON_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить физ. лицо
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) out
    ,@p_name        varchar(60)
    ,@p_lastname    varchar(100)
    ,@p_surname     varchar(60) = null
    ,@p_sex         char(1) = 'M'
    ,@p_birthdate   datetime = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
         , @v_sex bit

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name()

	set @v_sex = case when @p_sex = 'М'
					  then 1
					  when @p_sex = 'Ж'
					  then 0
			     end  
 
       -- надо добавлять
  if (@p_id is null)

   begin
      if (@@tranCount = 0)
        begin transaction  
     -- добавим запись в связочную таблицу 

        exec @v_Error = 
        dbo.uspVPRT_Party_SaveById
        @p_id = @p_id out
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   insert into
			     dbo.CPRT_PERSON 
            (id, name, lastname, surname, sex
			, birthdate ,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_id, @p_name, @p_lastname, @p_surname, @v_sex
			, @p_birthdate ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	   if (@@tranCount > @v_TrancountOnEntry)
        commit
 
	 end 
 else
  -- надо править существующий
		update dbo.CPRT_PERSON set
		 Name =  @p_name
		,lastname = @p_lastname
        ,surname = @p_surname
        ,sex  = @v_sex
        ,birthdate  = @p_birthdate
        ,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_PERSON_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_PERSON_SaveById] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating uspVPRT_ORGANIZATION_SaveById...'
go

CREATE procedure [dbo].[uspVPRT_ORGANIZATION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить юр. лицо
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) out
    ,@p_name        varchar(100)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
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

       -- надо добавлять
  if (@p_id is null)

   begin
      if (@@tranCount = 0)
        begin transaction  
     -- добавим запись в связочную таблицу 

        exec @v_Error = 
        dbo.uspVPRT_Party_SaveById
        @p_id = @p_id out
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   insert into
			     dbo.CPRT_ORGANIZATION 
            (id, name, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_id, @p_name ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	   if (@@tranCount > @v_TrancountOnEntry)
        commit
 
	 end 
 else
  -- надо править существующий
		update dbo.CPRT_ORGANIZATION set
		 Name =  @p_name
        ,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_ORGANIZATION_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_ORGANIZATION_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating uspVPRT_EMPLOYEE_TYPE_SaveById...'
go

CREATE procedure [dbo].[uspVPRT_EMPLOYEE_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить должность
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) out
    ,@p_short_name       varchar(30)
    ,@p_full_name        varchar(60)
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CPRT_EMPLOYEE_TYPE 
            (short_name, full_name, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CPRT_EMPLOYEE_TYPE set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_EMPLOYEE_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_EMPLOYEE_TYPE_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating uspVPRT_EMPLOYEE_SaveById...'
go

CREATE procedure [dbo].[uspVPRT_EMPLOYEE_SaveById]
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
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_organization_id		numeric(38,0)
	,@p_person_id			numeric(38,0)
    ,@p_employee_type_id	numeric(38,0)
	,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CPRT_EMPLOYEE 
            (organization_id, person_id, employee_type_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_organization_id , @p_person_id, @p_employee_type_id, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CPRT_EMPLOYEE set
		 organization_id =  @p_organization_id
        ,person_id =  @p_person_id
		,employee_type_id = @p_employee_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 
end
go

GRANT EXECUTE ON [dbo].[uspVPRT_EMPLOYEE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_EMPLOYEE_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating uspVPRT_EMPLOYEE_DeleteById...'
go

CREATE procedure [dbo].[uspVPRT_EMPLOYEE_DeleteById]
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
)
as
begin
  set nocount on

	delete
	from dbo.cprt_employee
	where id = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_EMPLOYEE_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_EMPLOYEE_DeleteById] TO [$(db_app_user)]
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

