:r ./../_define.sql

:setvar dc_number 00223
:setvar dc_description "organization full_name added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    06.05.2008 VLavrentiev  organization full_name added
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


alter table dbo.CPRT_ORGANIZATION
add full_name varchar(250)
go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVPRT_ORGANIZATION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности ORGANIZATION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
( @p_location_type_work_phone_id    numeric(38,0)
 ,@p_location_type_fact_id			numeric(38,0) 
 ,@p_location_type_jur_id			numeric(38,0)
 ,@p_table_name					    int
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
		  ,a.name
		  ,a.full_name
		  ,e1.location_string as work_phone
		  ,e2.location_string as fact_address
      FROM dbo.CPRT_ORGANIZATION as a
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_fact_id) as e2 on a.id = e2.record_id
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVPRT_ORGANIZATION_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные об организации
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
SET NOCOUNT ON
  
 
 declare  
 
  @p_location_type_fact_id		 numeric(38,0)
 ,@p_location_type_jur_id		 numeric(38,0)
 ,@p_location_type_work_phone_id numeric(38,0)
 ,@p_table_name int

 set @p_location_type_fact_id		= dbo.usfConst('LOC_FACT_ID')
 set @p_location_type_jur_id		= dbo.usfConst('LOC_JUR_ID')
 set @p_location_type_work_phone_id = dbo.usfConst('WORK_PHONE')

 set @p_table_name = dbo.usfConst('dbo.CPRT_ORGANIZATION')

       SELECT id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,name
		  ,full_name
		  ,work_phone
		  ,fact_address
	FROM dbo.utfVPRT_ORGANIZATION
				(@p_location_type_work_phone_id
				 ,@p_location_type_fact_id
				 ,@p_location_type_jur_id
				 ,@p_table_name)

	RETURN
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVPRT_ORGANIZATION_SaveById]
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
	,@p_full_name	varchar(250) = null
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

	if (@p_sys_comment is null)
	set @p_sys_comment = '-'

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
            (id, name, full_name, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_id, @p_name , @p_full_name, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	   if (@@tranCount > @v_TrancountOnEntry)
        commit
 
	 end 
 else
  -- надо править существующий
		update dbo.CPRT_ORGANIZATION set
		 Name =  @p_name
		,full_name = @p_full_name
        ,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
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


