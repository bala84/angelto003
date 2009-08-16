:r ./../_define.sql
:setvar dc_number 00076
:setvar dc_description "car save fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    03.03.2008 VLavrentiev  car save fixed
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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип заметки
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     	 @p_id						numeric(38,0) = null out
    	,@p_date_created				datetime
	,@p_number					bigint
	,@p_car_id					numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id			numeric(38,0)
	,@p_driver_list_type_id				numeric(38,0)
	,@p_fuel_exp					decimal
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn			decimal = 0.0	
	,@p_speedometer_end_indctn			decimal = 0.0
	,@p_fuel_start_left				decimal = 0.0
	,@p_fuel_end_left				decimal = 0.0
	,@p_fuel_gived					decimal = 0.0
	,@p_fuel_return					decimal = 0.0
	,@p_fuel_addtnl_exp				decimal = 0.0
	,@p_last_run					decimal = 0.0
	,@p_run						decimal = 0.0
	,@p_fuel_consumption				decimal = 0.0
	,@p_condition_id				numeric (38,0) = null out
    	,@p_sys_comment					varchar(2000) = '-'
    	,@p_sys_user					varchar(30) = null
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

	 if (@p_fuel_exp is null)
    set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	 if (@p_speedometer_end_indctn is null)		
    set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null) 
	set @p_fuel_end_left = 0.0

	 if (@p_fuel_gived is null)
    set @p_fuel_gived = 0.0

	 if (@p_fuel_return	is null)
	set @p_fuel_return = 0.0

	 if (@p_fuel_addtnl_exp is null)
    set @p_fuel_addtnl_exp = 0.0

	 if (@p_run is null)
    set @p_run = 0.0

	 if (@p_fuel_consumption is null)
	set @p_fuel_consumption = 0.0


	 if (@p_last_run is null)
	set @p_last_run = 0.0

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавлять
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   
				
				insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ(sys_comment)
				values('seq_gen')

				set @p_number = scope_identity()
			end 
	 	
	   		insert into
			     dbo.CDRV_DRIVER_LIST 
            		(date_created, number, car_id, fact_start_duty, fact_end_duty
			,driver_list_state_id, driver_list_type_id, fuel_exp
			,fuel_type_id, organization_id, employee1_id, employee2_id
			,speedometer_start_indctn,speedometer_end_indctn
		    ,fuel_start_left, fuel_end_left, fuel_gived, fuel_return
			,fuel_addtnl_exp, run, fuel_consumption
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_LIST set
		date_created = @p_date_created
	  , number = @p_number
	  , car_id = @p_car_id
	  , fact_start_duty = @p_fact_start_duty
	  , fact_end_duty = @p_fact_end_duty
	  , driver_list_state_id = @p_driver_list_state_id
	  , driver_list_type_id = @p_driver_list_type_id
	  , fuel_exp = @p_fuel_exp
	  , fuel_type_id = @p_fuel_type_id
	  , organization_id = @p_organization_id
	  , employee1_id = @p_employee1_id
      , employee2_id = @p_employee2_id
	  , speedometer_start_indctn = @p_speedometer_start_indctn
	  , speedometer_end_indctn = @p_speedometer_end_indctn
	  , fuel_start_left = @p_fuel_start_left
	  , fuel_end_left = @p_fuel_end_left
	  , fuel_gived = @p_fuel_gived
	  , fuel_return = @p_fuel_return
	  , fuel_addtnl_exp = @p_fuel_addtnl_exp
	  , run = @p_run
	  , fuel_consumption = @p_fuel_consumption
	  , sys_comment = @p_sys_comment
      , sys_user_modified = @p_sys_user
	where ID = @p_id
-- При редактировании удостоверимся, что мы прибавили дельту пробега (между старым пробегом и новым)

 if (@p_last_run <> 0)
  set @p_run = @p_run - @p_last_run
  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= null
    		,@p_run				= @p_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные об автомобиле
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						 numeric(38,0) = null out
    ,@p_state_number			 varchar(20)
	,@p_last_speedometer_idctn	 decimal		 = 0.0
    ,@p_speedometer_idctn		 decimal         = 0.0
    ,@p_car_type_id				 numeric(38,0)
	,@p_car_state_id			 numeric(38,0)   = null
	,@p_car_mark_id				 numeric(38,0)
	,@p_car_model_id			 numeric(38,0)
	,@p_begin_mntnc_date		 datetime		= null
	,@p_fuel_type_id			 numeric(38,0)
	,@p_car_kind_id				 numeric(38,0)
	,@p_last_begin_run			 decimal			= 0.0
	,@p_begin_run				 decimal			= 0.0
	,@p_speedometer_start_indctn decimal			= 0.0
	,@p_speedometer_end_indctn	 decimal			= 0.0
	,@p_condition_id			 numeric(38,0)	= null out
	,@p_sys_comment				 varchar(2000)	= '-'
    ,@p_sys_user				 varchar(30)		= null
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

	 if (@p_begin_run is null)
	set @p_begin_run = 0.0

	 if (@p_speedometer_idctn is null)
	set @p_speedometer_idctn = 0.0

	 if (@p_last_begin_run is null)
	set @p_last_begin_run = 0.0
	
	 if (@p_last_speedometer_idctn is null)
	set @p_last_speedometer_idctn = 0.0
     
     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction  

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date
			,fuel_type_id, car_kind_id, begin_run, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		,car_state_id = @p_car_state_id
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

    -- Если мы редактировали начальный пробег удостоверимся, что мы прибавим дельту
   if (@p_last_begin_run <> 0) 
	set @p_begin_run = @p_begin_run  - @p_last_begin_run



    -- Если мы изменили начальное показание, то мы должны откорректировать пробег и все показания
--	set @p_speedometer_start_indctn = @p_speedometer_start_indctn + (@p_speedometer_idctn - @p_last_speedometer_idctn) 
--	set @p_speedometer_end_indctn = @p_speedometer_end_indctn + (@p_speedometer_idctn - @p_last_speedometer_idctn)
   if (@p_last_speedometer_idctn <> 0) 
    set @p_begin_run = @p_begin_run + (@p_speedometer_idctn - @p_last_speedometer_idctn)

   --если у нас еще нет сосотояния автомобиля мы должны выставить правильное конечное показание спидометра равное начальному показанию спидометра
  
   if (@p_condition_id is null)
   set @p_speedometer_end_indctn = @p_speedometer_idctn
  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id							= @p_condition_id
    		,@p_car_id						= @p_id
    		,@p_ts_type_master_id			= null
    		,@p_employee_id					= null
    		,@p_run							= @p_begin_run
    		,@p_last_run					= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn    
    		,@p_sys_comment					= @p_sys_comment  
  		,@p_sys_user 						= @p_sys_user

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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVPRT_PARTY_SaveById]
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

  if (@p_sys_comment is null)
	set @p_sys_comment = '-'
    -- надо добавлять
		insert into
			dbo.CPRT_PARTY 
            (sys_comment, sys_user_created, sys_user_modified)
		values
			(@p_sys_comment, @p_sys_user,  @p_sys_user)

         set @p_id = SCOPE_IDENTITY();

  return
   
end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVPRT_PERSON_SaveById]
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

	if (@p_sys_comment is null)

	set @p_sys_comment = '-'

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
		  ,isnull(h.run, a.begin_run) as run
		  ,h.speedometer_start_indctn as speedometer_start_indctn
		  ,h.speedometer_end_indctn as speedometer_end_indctn
		  ,h.id as condition_id
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
									 and j.season = case when month(a.date_created) in (12,1,2,3,4,5)
														 then dbo.usfConst('WINTER_SEASON')
														 when month(a.date_created) in (6,7,8,9,10,11)
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
