:r ./../_define.sql

:setvar dc_number 00157                  
:setvar dc_description "fuel_types fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    02.04.2008 VLavrentiev  fuel_types fixed
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


alter table dbo.CCAR_FUEL_MODEL
add season smallint
go


update  dbo.CCAR_FUEL_MODEL
    set season = (select season from dbo.CCAR_FUEL_TYPE as b
					where b.id = dbo.CCAR_FUEL_MODEL.fuel_type_id)




alter table dbo.CCAR_FUEL_MODEL
alter column season smallint not null
go


alter table dbo.CCAR_FUEL_TYPE
drop column season
go




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_FUEL_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения типов топлива
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT     a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.short_name
		  ,a.full_name
		  ,b.fuel_norm
		  ,b.car_model_id
		  ,c.mark_id
		  ,d.short_name + ' - ' + c.short_name as car_mark_model_sname
		  ,b.season
		  ,b.id as fuel_model_id
		  ,d.short_name as car_mark_sname
		  ,c.short_name as car_model_sname
      FROM dbo.CCAR_FUEL_MODEL as b
		JOIN dbo.CCAR_FUEL_TYPE as a on a.id = b.fuel_type_id
		JOIN dbo.CCAR_CAR_MODEL as c on  c.id = b.car_model_id
		JOIN dbo.CCAR_CAR_MARK as d on c.mark_id = d.id
	
)
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения сущности CAR
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
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
		  ,a.state_number
		  ,a.speedometer_idctn
		  ,a.begin_mntnc_date
		  ,a.car_type_id
		  ,b.short_name as car_type_sname
		  ,a.car_state_id
		  ,c.short_name as car_state_sname
		  ,a.car_mark_id 
		  ,d.short_name as car_mark_sname
		  ,a.car_model_id
		  ,e.short_name as car_model_sname
		  ,a.fuel_type_id	
		  ,f.short_name as fuel_type_sname
		  ,a.car_kind_id
		  ,g.short_name as car_kind_sname
		  ,a.begin_run
		  ,a.last_ts_verified
		  ,h.run as run
		  ,h.speedometer_start_indctn as speedometer_start_indctn
		  ,h.speedometer_end_indctn as speedometer_end_indctn
		  ,h.id as condition_id
		  ,h.fuel_start_left
		  ,h.fuel_end_left
		  ,h.employee_id
      FROM dbo.CCAR_CAR as a
		JOIN dbo.CCAR_CAR_KIND as g on a.car_kind_id = g.id
		JOIN dbo.CCAR_CAR_TYPE as b on a.car_type_id = b.id	
		JOIN dbo.CCAR_CAR_MARK as d on a.car_mark_id = d.id
		JOIN dbo.CCAR_CAR_MODEL as e on a.car_model_id = e.id
		JOIN dbo.CCAR_FUEL_TYPE as f on a.fuel_type_id = f.id
		LEFT OUTER JOIN dbo.CCAR_CAR_STATE as c on a.car_state_id = c.id
		LEFT OUTER JOIN dbo.CCAR_CONDITION as h on a.id = h.car_id
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVDRV_DRIVER_LIST] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения путевых листов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_start_date	datetime			
 ,@p_end_date	datetime	
 ,@p_car_type_id numeric(38,0)
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
		  ,a.date_created
		  ,a.number
		  ,a.car_id
		  ,b.state_number
		  ,c.short_name + ' - ' + d.short_name as car_mark_model_name
		  ,a.employee1_id
		  ,a.employee2_id
		  ,f.lastname + ' ' + substring(f.name,1,1) + '.' + isnull(substring(f.surname,1,1) + '.','') as FIO_DRIVER1
		  ,f2.lastname + ' ' + substring(f2.name,1,1) + '.' + isnull(substring(f2.surname,1,1) + '.','') as FIO_DRIVER2
		  ,k.fuel_norm
		  ,a.fact_start_duty
		  ,a.fact_end_duty
		  ,a.driver_list_state_id
		  ,g.short_name as driver_list_state_name
		  ,a.driver_list_type_id
		  ,h.short_name as driver_list_type_name
		  ,a.organization_id
		  ,i.name as org_name
		  ,a.fuel_type_id
		  ,j.short_name as fuel_type_name
		  ,a.fuel_exp
		  ,a.speedometer_start_indctn
		  ,a.speedometer_end_indctn
		  ,a.fuel_start_left
		  ,a.fuel_end_left
		  ,a.fuel_gived
		  ,a.fuel_return
		  ,a.fuel_addtnl_exp
		  ,null as last_run
		  ,a.run
		  ,a.fuel_consumption
		  ,l.id as condition_id
		  ,null as edit_state
		  ,l.employee_id
      FROM dbo.CDRV_DRIVER_LIST as a
		JOIN dbo.CCAR_CAR as b on  a.car_id = b.id
		JOIN dbo.CCAR_FUEL_TYPE as j on a.fuel_type_id = j.id
		JOIN dbo.CCAR_CAR_MARK as c on b.car_mark_id = c.id
		JOIN dbo.CCAR_CAR_MODEL as d on b.car_model_id = d.id
		JOIN dbo.CPRT_EMPLOYEE as e on a.employee1_id = e.id
		JOIN dbo.CPRT_PERSON as f on e.person_id = f.id
        JOIN dbo.CDRV_DRIVER_LIST_STATE as g on a.driver_list_state_id = g.id
		JOIN dbo.CDRV_DRIVER_LIST_TYPE as h on a.driver_list_type_id = h.id
		JOIN dbo.CPRT_ORGANIZATION as i on a.organization_id = i.id
		JOIN dbo.CCAR_FUEL_MODEL as k on (d.id = k.car_model_id 
									 and j.id = k.fuel_type_id
									 and k.season = case when month(a.date_created) in (11,12,1,2,3)
														 then dbo.usfConst('WINTER_SEASON')
														 when month(a.date_created) in (4,5,6,7,8,9,10)
														 then dbo.usfConst('SUMMER_SEASON')
													end)
		LEFT OUTER JOIN dbo.CPRT_EMPLOYEE as e2 on a.employee2_id = e2.id
		LEFT OUTER JOIN dbo.CPRT_PERSON as f2 on e2.person_id = f2.id
		LEFT OUTER JOIN dbo.CCAR_CONDITION as l on b.id = l.car_id
	  WHERE b.car_type_id = @p_car_type_id
	    AND a.date_created >= @p_start_date
	    AND a.date_created <= @p_end_date	

)
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
    ,@p_fuel_norm     decimal(18,9) = 0.0
	,@p_car_model_id  numeric(38,0)
	,@p_season		  smallint
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
            (fuel_type_id, fuel_norm, car_model_id, season, sys_comment, sys_user_created, sys_user_modified)
	   values(@p_fuel_type_id, @p_fuel_norm, @p_car_model_id, @p_season, @p_sys_comment, @p_sys_user, @p_sys_user)

       set @p_id = scope_identity()
	 end
       
	    
  else
  -- надо править существующий
		update dbo.CCAR_FUEL_MODEL set
		 fuel_type_id = @p_fuel_type_id
		,fuel_norm = @p_fuel_norm
		,car_model_id = @p_car_model_id
		,season	= @p_season
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
    ,@p_full_name        varchar(60) = null
    ,@p_fuel_norm		 decimal(18,9) = 0.0
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

     if (@p_full_name is null)
    set @p_full_name = @p_short_name

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
					(short_name, full_name,  sys_comment, sys_user_created, sys_user_modified)
			select @p_short_name , @p_full_name,  @p_sys_comment, @p_sys_user, @p_sys_user
			where not exists
			(select 1 from dbo.CCAR_FUEL_TYPE as b
			 where ltrim(rtrim(upper(b.short_name))) 
				 = ltrim(rtrim(upper(@p_short_name))))
			--Делаем так, потому что интерфейс сделан кривовато
			if (@@rowcount = 1)
			  set @p_id = scope_identity();
			else
			  select @p_id = id from dbo.CCAR_FUEL_TYPE as b 
			  where ltrim(rtrim(upper(b.short_name))) 
				  = ltrim(rtrim(upper(@p_short_name)))
		


    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_FUEL_TYPE set
        	 full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where ID = @p_id


	exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_SaveById
				 @p_id = @p_fuel_model_id
				,@p_fuel_type_id = @p_id
				,@p_fuel_norm = @p_fuel_norm
				,@p_car_model_id = @p_car_model_id
				,@p_season		= @p_season
				,@p_sys_comment = @p_sys_comment
				,@p_sys_user = @p_sys_user

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
GO


drop index dbo.CCAR_FUEL_MODEL.u_fuel_type_car_model_fuel_model
go

create unique index u_fuel_type_car_model_fuel_model 
on dbo.CCAR_FUEL_MODEL(fuel_type_id, car_model_id, season)
on $(fg_idx_name)
go 



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_FUEL_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов топлива
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				numeric(38,0)
    ,@p_fuel_model_id   numeric(38,0) 
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount
   
   if (@@tranCount = 0)
    begin transaction 


   exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_DeleteById
				 @p_id = @p_fuel_model_id

   if (@v_Error > 0)
	begin 
		if (@@tranCount > @v_TrancountOnEntry)
			rollback
		return @v_Error
	end 

   if not exists (select 1 from dbo.CCAR_FUEL_MODEL
					where fuel_type_id = @p_id)
	delete
	from dbo.CCAR_FUEL_TYPE
	where id = @p_id
   
    if (@@tranCount > @v_TrancountOnEntry)
    commit

  
 
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

