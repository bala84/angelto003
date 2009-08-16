:r ./../_define.sql
:setvar dc_number 00006
:setvar dc_description "VPRT_ORGANIZATION insert, update, delete added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.02.2008 VLavrentiev  VPRT_ORGANIZATION insert, update, delete added   
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
print 'Adding utfVPRT_ORGANIZATION...'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[utfVPRT_ORGANIZATION] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ����������� �������� ORGANIZATION
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	������� ����� �������
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
		  ,e1.location_string as work_phone
		  ,e2.location_string as fact_address
      FROM dbo.CPRT_ORGANIZATION as a
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_fact_id) as e2 on a.id = e2.record_id
)
go


GRANT VIEW DEFINITION ON [dbo].[utfVPRT_ORGANIZATION] TO [$(db_app_user)]
GO

insert into dbo.CSYS_CONST(id,name,description)
values (21,'dbo.CPRT_ORGANIZATION','��� - ������� ORGANIZATION')

insert into dbo.CSYS_CONST(id,name,description)
values (13,'LOC_FACT_ID','��� - ����������� �����')

insert into dbo.CSYS_CONST(id,name,description)
values (14,'LOC_JUR_ID','��� - ����������� �����')

go

print ' '
print 'Adding uspVPRT_ORGANIZATION_SelectAll...'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVPRT_ORGANIZATION_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ �� �����������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	������� ����� ���������
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
		  ,work_phone
		  ,fact_address
	FROM dbo.utfVPRT_ORGANIZATION
				(@p_location_type_work_phone_id
				 ,@p_location_type_fact_id
				 ,@p_location_type_jur_id
				 ,@p_table_name)

	RETURN
go

GRANT EXECUTE ON [dbo].[uspVPRT_ORGANIZATION_SelectAll] TO [$(db_app_user)]
GO


GRANT VIEW DEFINITION ON [dbo].[uspVPRT_ORGANIZATION_SelectAll] TO [$(db_app_user)]
GO


print ' '
print 'Adding uspVPRT_PARTY_DeleteById...'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[uspVPRT_PARTY_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������� ������ �� ��������� �������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.cprt_party
	where id = @p_id
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_PARTY_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_PARTY_DeleteById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating uspVPRT_ORGANIZATION_DeleteById...'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[uspVPRT_ORGANIZATION_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ������� �����������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
	set nocount on
	set xact_abort on
  

	declare	@v_Error int
			, @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   
    if (@@tranCount = 0)
        begin transaction  
    
	delete
	from dbo.cprt_organization
	where id = @p_id


	exec @v_Error = 
        dbo.uspVPRT_Party_DeleteById
        @p_id = @p_id

    if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end

	if (@@tranCount > @v_TrancountOnEntry)
		commit
    
  return 

end
go

GRANT EXECUTE ON [dbo].[uspVPRT_ORGANIZATION_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVPRT_ORGANIZATION_DeleteById] TO [$(db_app_user)]
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
