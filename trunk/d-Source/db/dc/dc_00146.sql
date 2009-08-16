:r ./../_define.sql

:setvar dc_number 00146                  
:setvar dc_description "ts type master parent_id added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    30.03.2008 VLavrentiev  ts type master parent_id added
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


alter table dbo.CCAR_TS_TYPE_MASTER
add parent_id numeric(38,0)
go


alter table dbo.CCAR_TS_TYPE_MASTER
   add constraint CCAR_TS_TYPE_MASTER_PARENT_ID_FK foreign key (parent_id)
      references CCAR_TS_TYPE_MASTER (id)
go

/*==============================================================*/
/* Index: i_parent_id_ccar_ts_type_master		        */
/*==============================================================*/
create index i_parent_id_ccar_ts_type_master 
on dbo.CCAR_TS_TYPE_MASTER (parent_id)
on "$(fg_idx_name)"
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_TS_TYPE_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ����������� ��
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	������� ����� �������
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 

(	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.short_name
		  ,a.full_name
		  ,a.periodicity
		  ,a.car_mark_id
		  ,b.short_name + ' - ' + c.short_name as car_mark_model_name
		  ,a.car_model_id
		  ,a.tolerance	
		  ,b.short_name as car_mark_sname
		  ,c.short_name as car_model_sname	
		  ,a.parent_id
		  FROM dbo.CCAR_TS_TYPE_MASTER as a
		JOIN dbo.CCAR_CAR_MARK as b on a.car_mark_id = b.id
		JOIN dbo.CCAR_CAR_MODEL as c on a.car_model_id = c.id

)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_TS_TYPE_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ��� ��
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
     @p_id				numeric(38,0) = null out
	,@p_short_name		varchar(30)
    ,@p_full_name		varchar(60)	  = null
	,@p_periodicity		int
	,@p_car_mark_id		numeric(38,0)
	,@p_car_model_id	numeric(38,0)
	,@p_tolerance		smallint	  = 0
	,@p_parent_id		numeric(38,0) = null
    ,@p_sys_comment		varchar(2000) = '-'
    ,@p_sys_user		varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	 if (@p_full_name is null)
	set @p_full_name = @p_short_name

	 if (@p_tolerance is null)
	set @p_tolerance = 0

  if (@p_id is null)
   begin   
    insert into
			     dbo.CCAR_TS_TYPE_MASTER 
            (short_name, full_name, periodicity, car_mark_id, car_model_id
			, tolerance, parent_id, sys_comment, sys_user_created, sys_user_modified)
	values( @p_short_name, @p_full_name, @p_periodicity, @p_car_mark_id, @p_car_model_id
			, @p_tolerance, @p_parent_id, @p_sys_comment, @p_sys_user, @p_sys_user)

   end
  else    
  -- ���� ������� ������������
		update dbo.CCAR_TS_TYPE_MASTER set
		 short_name = @p_short_name
		,full_name = @p_full_name
		,periodicity = @p_periodicity
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,tolerance = @p_tolerance
		,parent_id = @p_parent_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
  return  

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVCAR_TS_TYPE_MASTER_SelectByParent_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � �������� ����� ��
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      30.03.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
(
@p_parent_id numeric(38,0)
)
AS
SET NOCOUNT ON
  
       SELECT  
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,periodicity
		  ,car_mark_id
		  ,car_mark_model_name
		  ,car_model_id
		  ,tolerance	
		  ,car_mark_sname
		  ,car_model_sname
		  ,parent_id	
	FROM dbo.utfVCAR_TS_TYPE_MASTER()
	WHERE parent_id = @p_parent_id

	RETURN
GO


GRANT EXECUTE ON [dbo].[uspVCAR_TS_TYPE_MASTER_SelectByParent_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_TS_TYPE_MASTER_SelectByParent_Id] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_TS_TYPE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ����� ��
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.02.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
AS
SET NOCOUNT ON
  
       SELECT  
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,periodicity
		  ,car_mark_id
		  ,car_mark_model_name
		  ,car_model_id
		  ,tolerance	
		  ,car_mark_sname
		  ,car_model_sname
		  ,parent_id	
	FROM dbo.utfVCAR_TS_TYPE_MASTER()

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

