:r ./../_define.sql

:setvar dc_number 00228
:setvar dc_description "demands select all fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    09.05.2008 VLavrentiev  demands select all fixed
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

ALTER PROCEDURE [dbo].[uspVWRH_WRH_DEMAND_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о требованиях
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
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
		  ,car_id
		  ,state_number
		  ,car_mark_sname
		  ,car_model_sname
		  ,number
		  ,employee_recieve_id
		  ,FIO_employee_recieve
		  ,employee_head_id
		  ,FIO_employee_head 
		  ,employee_worker_id
		  ,FIO_employee_worker
		  ,date_created
	FROM dbo.utfVWRH_WRH_DEMAND_MASTER(@p_start_date, @p_end_date)
	order by date_created desc

	RETURN
GO



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
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CPRT_PERSON, (name, lastname, surname), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.person_Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))
	order by fio asc

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


