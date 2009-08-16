:r ./../_define.sql

:setvar dc_number 00173                  
:setvar dc_description "good category type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    10.04.2008 VLavrentiev  good category type added
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

CREATE FUNCTION [dbo].[utfVWRH_GOOD_CATEGORY_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ����������� ����������� ��������� �������
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	������� ����� �������
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
		  ,short_name
		  ,full_name
      FROM dbo.CWRH_GOOD_CATEGORY_TYPE
	
)
GO


GRANT VIEW DEFINITION ON [dbo].[utfVWRH_GOOD_CATEGORY_TYPE] TO [$(db_app_user)]
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ���������� ������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
	FROM dbo.utfVWRH_GOOD_CATEGORY_TYPE()

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SelectAll] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ��������� ������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	������� ����� ���������
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

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

       -- ���� ���������
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_GOOD_CATEGORY_TYPE
            (short_name, full_name, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- ���� ������� ������������
		update dbo.CWRH_GOOD_CATEGORY_TYPE set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_DeleteById]
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
** 1.0      10.04.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id          numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.cwrh_good_category_type
	where id = @p_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVWRH_GOOD_CATEGORY_TYPE_DeleteById] TO [$(db_app_user)]
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
