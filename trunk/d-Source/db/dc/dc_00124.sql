:r ./../_define.sql

:setvar dc_number 00124                  
:setvar dc_description "decimal fixed#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    19.03.2008 VLavrentiev  decimal fixed#2
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
)
AS
SET NOCOUNT ON

declare
      @v_Srch_Str      varchar(1000)
 
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

  

       SELECT 
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
	FROM dbo.utfVCAR_CAR() as a 
	LEFT OUTER JOIN dbo.utfVCAR_FUEL_TYPE() as b on 
										   a.car_model_id = b.car_model_id
									   and a.fuel_type_id = b.id
									   and b.season = case when month(getdate()) in (11,12,1,2,3)
														   then dbo.usfConst('WINTER_SEASON')
														   when month(getdate()) in (4,5,6,7,8,9,10)
														   then dbo.usfConst('SUMMER_SEASON')
													  end
    WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CCAR_CAR, (state_number), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.Id = KEY_TBL.[KEY]))
        OR (@p_Str = ''))

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_FUEL_TYPE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах топлива
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
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
		  ,convert(decimal(18,3), fuel_norm, 128) as fuel_norm
		  ,car_model_id
		  ,mark_id
		  ,car_mark_model_sname
		  ,case season when dbo.usfConst('WINTER_SEASON')
					   then 'Зима'
					   when dbo.usfConst('SUMMER_SEASON')
					   then 'Лето'
		  end as season
		 ,fuel_model_id
		 ,car_mark_sname
		 ,car_model_sname
	FROM dbo.utfVCAR_FUEL_TYPE()

	RETURN
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_FUEL_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить о тип топлива
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_fuel_model_id	 numeric(38,0) = null out
    ,@p_short_name       varchar(30)
    ,@p_full_name        varchar(60)
    ,@p_fuel_norm		 decimal(18,13) = 0.0
	,@p_car_model_id	 numeric(38,0)
	,@p_season			 varchar(10)
    ,@p_sys_comment		 varchar(2000) = '-'
    ,@p_sys_user		 varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @p_season = case when @p_season = 'Зима'
						 then dbo.usfConst('WINTER_SEASON')
						 when @p_season = 'Лето'
						 then dbo.usfConst('SUMMER_SEASON')
					end

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 
       -- надо добавлять
  if (@p_id is null)
    begin
			insert into
			     dbo.CCAR_FUEL_TYPE 
					(short_name, full_name, season, sys_comment, sys_user_created, sys_user_modified)
			values
					(@p_short_name , @p_full_name, @p_season, @p_sys_comment, @p_sys_user, @p_sys_user)
       
			set @p_id = scope_identity();
			
			exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_SaveById
				 @p_id = @p_fuel_model_id
				,@p_fuel_type_id = @p_id
				,@p_fuel_norm = @p_fuel_norm
				,@p_car_model_id = @p_car_model_id
				,@p_sys_comment = @p_sys_comment
				,@p_sys_user = @p_sys_user

			if (@v_Error > 0)
				begin 
					if (@@tranCount > @v_TrancountOnEntry)
						rollback
					return @v_Error
				end 


    end   
       
	    
 else
	begin
  -- надо править существующий
		update dbo.CCAR_FUEL_TYPE set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,season = @p_season
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

		exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_SaveById
				 @p_id = @p_fuel_model_id
				,@p_fuel_type_id = @p_id
				,@p_fuel_norm = @p_fuel_norm
				,@p_car_model_id = @p_car_model_id
				,@p_sys_comment = @p_sys_comment
				,@p_sys_user = @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
				return @v_Error
			end 
    end

   
  if (@@tranCount > @v_TrancountOnEntry)
    commit


  return  

end
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_FUEL_MODEL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить о связь топлива с моделью
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id			  numeric(38,0) = null out
	,@p_fuel_type_id  numeric(38,0)
    ,@p_fuel_norm     decimal(18,13) = 0.0
	,@p_car_model_id  numeric(38,0)
    ,@p_sys_comment	  varchar(2000) = '-'
    ,@p_sys_user	  varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_fuel_norm is null)
	set @p_fuel_norm = 0.0

       -- надо добавлять
	if (@p_id is null)
	 begin
	   insert into
			     dbo.CCAR_FUEL_MODEL 
            (fuel_type_id, fuel_norm, car_model_id, sys_comment, sys_user_created, sys_user_modified)
	   values(@p_fuel_type_id, @p_fuel_norm, @p_car_model_id, @p_sys_comment, @p_sys_user, @p_sys_user)

       set @p_id = scope_identity()
	 end
       
	    
  else
  -- надо править существующий
		update dbo.CCAR_FUEL_MODEL set
		 fuel_type_id = @p_fuel_type_id
		,fuel_norm = @p_fuel_norm
		,car_model_id = @p_car_model_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where id = @p_id
    
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
