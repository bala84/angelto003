
:r ./../_define.sql

:setvar dc_number 00460
:setvar dc_description "drv plan detail select fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.04.2009 VLavrentiev   drv plan detail select fixed
*******************************************************************************/ 
use [$(db_name)]
GO


PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _drop_chis_all_objects.sql                         ='
PRINT '==============================================================================='
PRINT ' '
go

:r _drop_chis_all_objects.sql



PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


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
,@p_date		  datetime = null
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

 if (@p_date is null)
    set @p_date = getdate()
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

SELECT
		   id
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
		  ,a.driver_license
	from
	(SELECT a.id
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
		  ,b.lastname+' '+isnull(substring(b.name,1,2),'') +'. '+ isnull(substring(b.surname,1,2),'')+ '.' as short_FIO
		  ,isnull(a3.is_fired, 'N') as is_fired
      FROM dbo.CPRT_EMPLOYEE as a
      JOIN dbo.CPRT_PERSON as b on a.person_id = b.id
	  JOIN dbo.CPRT_ORGANIZATION as c on a.organization_id = c.id
      JOIN dbo.CPRT_EMPLOYEE_TYPE as d on a.employee_type_id = d.id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_mobile_phone_id) as e1 on a.id = e1.record_id
	  LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_home_phone_id) as e2 on a.id = e2.record_id
      LEFT OUTER JOIN dbo.utfVLOC_LOCATION(@p_table_name, @p_location_type_work_phone_id) as e3 on a.id = e3.record_id
	  outer apply
		(select 'Y' as is_fired
		   from dbo.CPRT_EMPLOYEE_EVENT as a2
		  where event = dbo.usfConst('FIRED')
		    and date_started <= (@p_date)
			and (date_ended is null
				or date_ended >= @p_date)
		    and a2.employee_id = a.id) as a3) as a
	  Where (is_fired = 'N')
        and (((@p_Str != '')
		   and (rtrim(ltrim(upper(lastname))) like rtrim(ltrim(upper(@p_Str + '%')))
				or rtrim(ltrim(upper(name))) like rtrim(ltrim(upper(@p_Str + '%')))
				or rtrim(ltrim(upper(surname))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))

	RETURN

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVCAR_CAR_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о автомобилях
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
,@p_date		  datetime = null
)
AS
SET NOCOUNT ON

declare
      @v_Srch_Str      varchar(1000)
 
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1

 if (@p_date is null)
	set @p_date = getdate()
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

  

      SELECT
			id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,state_number
		  ,last_speedometer_idctn
		  ,speedometer_idctn
		  ,begin_mntnc_date
		  ,car_type_id
		  ,car_type_sname
		  ,car_state_id
		  ,car_state_sname
		  ,car_mark_id 
		  ,car_mark_sname
		  ,car_model_id
		  ,car_model_sname
		  ,fuel_type_id	
		  ,fuel_type_sname
		  ,car_kind_id
		  ,car_kind_sname
		  ,fuel_norm
		  ,last_begin_run
		  ,begin_run
		  ,run
		  ,speedometer_start_indctn
		  ,speedometer_end_indctn 
		  ,condition_id
		  ,fuel_start_left
		  ,fuel_end_left
		  ,employee_id
		  ,last_ts_verified
		  ,card_number
		  ,organization_id
		  ,organization_sname
		  ,car_passport
		  ,driver_list_type_id
		  ,driver_list_type_sname
FROM 
(SELECT 
			a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.state_number
		  ,null as last_speedometer_idctn
		  ,convert(decimal(18,0),a.speedometer_idctn,128) as speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,a.car_type_sname
		  ,a.car_state_id
		  ,a.car_state_sname
		  ,a.car_mark_id 
		  ,a.car_mark_sname
		  ,a.car_model_id
		  ,a.car_model_sname
		  ,a.fuel_type_id	
		  ,a.fuel_type_sname
		  ,a.car_kind_id
		  ,a.car_kind_sname
		  ,convert(decimal(18,3), b.fuel_norm, 128) as fuel_norm
		  ,null as last_begin_run
		  ,convert(decimal(18,0),a.begin_run, 128) as begin_run
		  ,convert(decimal(18,0),a.run, 128) as run
		  ,convert(decimal(18,0),a.speedometer_start_indctn, 128) as speedometer_start_indctn
		  ,convert(decimal(18,0),a.speedometer_end_indctn, 128) as speedometer_end_indctn 
		  ,a.condition_id
		  ,convert(decimal(18,0),a.fuel_start_left, 128) as fuel_start_left
		  ,convert(decimal(18,0),a.fuel_end_left, 128) as fuel_end_left
		  ,a.employee_id
		  ,a.last_ts_verified
		  ,a.card_number
		  ,a.organization_id
		  ,a.organization_sname
		  ,a.car_passport
		  ,a.driver_list_type_id
		  ,a.driver_list_type_sname	
		  ,a3.is_fired
	FROM dbo.utfVCAR_CAR() as a 
	LEFT OUTER JOIN dbo.utfVCAR_FUEL_TYPE() as b on 
										   a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (11,12,1,2,3)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (4,5,6,7,8,9,10)
														   then dbo.usfConst('SUMMER_SEASON')
													  end
	  outer apply
		(select 'Y' as is_fired
		   from dbo.CCAR_CAR_EVENT as a2
		  where event in (dbo.usfConst('CAR_OUTDATED'),dbo.usfConst('CAR_LOANED'))
		    and date_started <= (@p_date)
			and (date_ended is null
				or date_ended >= @p_date)
		    and a2.car_id = a.id) as a3) as a
    WHERE a.is_fired = 'N'
        and (((@p_Str != '')
		   and (rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))

	/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.Id = KEY_TBL.[KEY]))
        OR (@p_Str = '')) */

	RETURN

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



