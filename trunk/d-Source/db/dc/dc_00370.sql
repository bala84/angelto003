:r ./../_define.sql

:setvar dc_number 00370
:setvar dc_description "car save state fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    01.09.2008 VLavrentiev  car save state fixed
*******************************************************************************/ 
use [$(db_name)]
GO

PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script dc_$(dc_number).sql                                ='
PRINT '==============================================================================='
PRINT ' '
go


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
** ѕроцедура должна сохранить данные об автомобиле
**
**  ¬ходные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      19.02.2008 VLavrentiev	ƒобавил новую процедуру
*******************************************************************************/
(
     @p_id						 numeric(38,0) = null out
    ,@p_state_number			 varchar(20)
	,@p_last_speedometer_idctn	 decimal(18,9)		 = 0.0
    ,@p_speedometer_idctn		 decimal(18,9)      = 0.0
    ,@p_car_type_id				 numeric(38,0)
	,@p_car_state_id			 numeric(38,0)   = null
	,@p_car_mark_id				 numeric(38,0)
	,@p_car_model_id			 numeric(38,0)
	,@p_begin_mntnc_date		 datetime		= null
	,@p_fuel_type_id			 numeric(38,0)
	,@p_car_kind_id				 numeric(38,0)
	,@p_last_begin_run			 decimal(18,9)			= 0.0
	,@p_begin_run				 decimal(18,9)			= 0.0
	,@p_run						 decimal(18,9)		= 0.0
	,@p_speedometer_start_indctn decimal(18,9)			= 0.0
	,@p_speedometer_end_indctn	 decimal(18,9)			= 0.0
	,@p_fuel_start_left			 decimal(18,9)			= 0.0
	,@p_fuel_end_left			 decimal(18,9)			= 0.0
	,@p_condition_id			 numeric(38,0)	= null out
	,@p_employee_id				 numeric(38,0)	= null
	,@p_card_number				 varchar(128)	= null
	,@p_organization_id			 numeric(38,0)	= null
	,@p_driver_list_type_id		 numeric(38,0)	= null
	,@p_car_passport			 varchar(100)	= null
	,@p_sys_comment				 varchar(2000)	= '-'
    ,@p_sys_user				 varchar(30)		= null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int
		 , @v_last_ts_verified tinyint
		 , @v_car_state_id	   numeric(38,0)

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
	 
	 if (@p_run is null)
	set @p_run = 0.0

	 if (@p_speedometer_start_indctn is null)
	set @p_speedometer_start_indctn = 0.0
     
         if (@p_speedometer_end_indctn is null)
	set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left is null)
	set @p_fuel_start_left = 0.0

	 if (@p_fuel_end_left is null)
	set @p_fuel_end_left = 0.0
	 
	 if (@p_last_speedometer_idctn is null)
	set @p_last_speedometer_idctn = 0.0

     
     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



	 if (@@tranCount = 0)
	  begin transaction 



       -- надо добавл€ть
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR 
            (state_number, speedometer_idctn, car_type_id, car_state_id
			,car_mark_id, car_model_id, begin_mntnc_date, organization_id
			,fuel_type_id, car_kind_id, begin_run, last_ts_verified, card_number
			,driver_list_type_id, car_passport
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_state_number, @p_speedometer_idctn, @p_car_type_id, @p_car_state_id
			,@p_car_mark_id, @p_car_model_id, @p_begin_mntnc_date, @p_organization_id
			,@p_fuel_type_id, @p_car_kind_id, @p_begin_run, 0, @p_card_number
			,@p_driver_list_type_id, @p_car_passport
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end

		update dbo.CCAR_CAR
		   set last_ts_verified = @v_last_ts_verified
		 where id = @p_id
    end   
       
	    
 else
	begin

		exec @v_Error =  dbo.uspVCAR_CAR_Check_last_ts
						 @p_car_id = @p_id
						,@p_last_ts_verified = @v_last_ts_verified out

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
			end 
  -- надо править существующий
		update dbo.CCAR_CAR set
		 state_number = @p_state_number
        ,speedometer_idctn = @p_speedometer_idctn
		,car_type_id = @p_car_type_id
		--немен€ем состо€ние автомобил€ в справочнике, если оно уже есть
		,car_state_id = isnull(car_state_id, @p_car_state_id)
		,car_mark_id = @p_car_mark_id
		,car_model_id = @p_car_model_id
		,begin_mntnc_date = @p_begin_mntnc_date
		,fuel_type_id = @p_fuel_type_id
		,car_kind_id = @p_car_kind_id
		,last_ts_verified = @v_last_ts_verified
		,organization_id = @p_organization_id
		,card_number = @p_card_number
		,driver_list_type_id = @p_driver_list_type_id
	    ,car_passport = @p_car_passport
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end

   --если у нас еще нет сосото€ни€ автомобил€ мы должны выставить правильное конечное показание спидометра равное начальному показанию спидометра
   --проверим правильное состо€ние
   if (@p_condition_id is null)
	select @p_condition_id = id 
	from dbo.CCAR_CONDITION 
	where car_id = @p_id


	
		exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id							= @p_condition_id
    		,@p_car_id						= @p_id
    		,@p_ts_type_master_id			= null
    		,@p_employee_id					= @p_employee_id
    		,@p_run							= @p_run
    		,@p_last_run					= null
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 		= @p_speedometer_end_indctn 
			,@p_fuel_start_left				= @p_fuel_start_left
			,@p_fuel_end_left				= @p_fuel_end_left
			,@p_edit_state					= 'E'   
    		,@p_sys_comment					= @p_sys_comment  
  		,@p_sys_user 						= @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
			return @v_Error
		end 
--	end

  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return 

end
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ѕроцедура должна сохранить устройство
**
**  ¬ходные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	ƒобавил новую процедуру
*******************************************************************************/
(
     @p_car_type_id      numeric(38,0)
    ,@p_organization_id	 numeric(38,0)
	,@p_number			 varchar(20)   = null out
    ,@p_sys_comment		 varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate())
													   and organization_id = @p_organization_id
													   and driver_list_type_id = @p_car_type_id)
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ	

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate())
													   and organization_id = @p_organization_id
													   and driver_list_type_id = @p_car_type_id)
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ	


      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate())
													   and organization_id = @p_organization_id
													   and driver_list_type_id = @p_car_type_id)
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate())
													   and organization_id = @p_organization_id
													   and driver_list_type_id = @p_car_type_id)
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ	
	
      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end

 if (@p_number is null)
  begin
	insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ (sys_comment)
	values ('-')
    set @p_number = scope_identity()
  end  
    
  return  

end
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ѕроцедура должна сохранить устройство
**
**  ¬ходные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	ƒобавил новую процедуру
*******************************************************************************/
(
     @p_number      varchar(20)   = null out
    ,@p_sent_to		char(1)   = 'N'
    ,@p_sys_comment varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)
	,@v_number varchar(4)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

   if @p_sent_to = 'N'	
    begin

	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CWRH_WRH_ORDER_MASTER
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ
	
      if (not exists (select 1 
						from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ
						where number = 1))	
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_WAREHOUSE_ORDER_USUAL_NUMBER_SEQ

    set @v_number = convert(varchar(4), @v_number_tmp)
	set @p_number = @v_number + '/' + convert(varchar(2), datepart("mm", getdate()))
									+ '/'
									+ convert(varchar(4), datepart("year", getdate()))
	end
  if @p_sent_to = 'Y'
   begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CWRH_WRH_ORDER_MASTER
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ

	 if (not exists (select 1 
						from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ
						where number = 1))	
	   	insert into CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ(number, sys_comment)
		values(1, 'seq_gen')

      else
		insert into CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ

		select  @v_number_tmp = max(number)
		from CSYS_WAREHOUSE_ORDER_TO_NUMBER_SEQ

	    set @p_number = convert(varchar(4), @v_number_tmp)
   end
   
    
  return  

end
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
** ѕроцедура должна сохранить тип заметки
**
**  ¬ходные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	ƒобавил новую процедуру
*******************************************************************************/
(
    @p_id							numeric(38,0) = null out
    ,@p_date_created				datetime
	,@p_number						bigint
	,@p_car_id						numeric(38,0)
	,@p_fact_start_duty				datetime
	,@p_fact_end_duty				datetime
	,@p_driver_list_state_id		numeric(38,0)
	,@p_driver_list_type_id			numeric(38,0)
	,@p_fuel_exp					decimal(18,9)
	,@p_fuel_type_id				numeric(38,0)
	,@p_organization_id				numeric(38,0)
	,@p_employee1_id				numeric(38,0)
	,@p_employee2_id				numeric(38,0)
	,@p_speedometer_start_indctn	decimal(18,9) = 0.0	
	,@p_speedometer_end_indctn		decimal(18,9) = 0.0
	,@p_fuel_start_left				decimal(18,9) = 0.0
	,@p_fuel_end_left				decimal(18,9) = 0.0
	,@p_fuel_gived					decimal(18,9) = 0.0
	,@p_fuel_return					decimal(18,9) = 0.0
	,@p_fuel_addtnl_exp				decimal(18,9) = 0.0
	,@p_last_run					decimal(18,9) = 0.0
	,@p_run							decimal(18,9)= 0.0
	,@p_fuel_consumption			decimal(18,9) = 0.0
	,@p_condition_id				numeric (38,0) = null out
	,@p_edit_state					char(1) = null
	,@p_employee_id					numeric (38,0) = null
	,@p_last_date_created			datetime	= null
	,@p_pw_trailer_amount			decimal(18,9) = 0.0
    ,@p_sys_comment					varchar(2000) = '-'
    ,@p_sys_user					varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error			   int
         , @v_TrancountOnEntry int
		 , @v_action		   char(1)
		 , @v_trailer_id	   numeric(38,0)
		 , @v_last_car_id	   numeric(38,0)
		 , @v_last_emp_id	   numeric(38,0)
		 , @v_error_run		   decimal(18,9) 
		 , @v_condition_id     numeric(38,0)
		 , @v_error_date_created datetime
		 , @v_error_number	     numeric(38,0)
		 , @v_error_fact_start_duty datetime
		 , @v_error_fact_end_duty   datetime
		 , @v_error_fuel_exp		decimal(18,9)
		 , @v_error_fuel_type_id    numeric(38,0)
		 , @v_error_organization_id numeric(38,0)
		 , @v_error_speedometer_start_indctn decimal(18,9)
		 , @v_error_speedometer_end_indctn	 decimal(18,9)
		 , @v_error_fuel_start_left			 decimal(18,9)			 
		 , @v_error_fuel_end_left			 decimal(18,9)
		 , @v_error_fuel_gived				 decimal(18,9)
		 , @v_error_fuel_return				 decimal(18,9)	
		 , @v_error_fuel_addtnl_exp			 decimal(18,9)
		 , @v_last_run						 decimal(18,9)
		 , @v_error_fuel_consumption		 decimal(18,9)


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	-- if (@p_fuel_exp is null)
   -- set @p_fuel_exp = 0.0

	 if (@p_speedometer_start_indctn is null)
    set @p_speedometer_start_indctn = 0.0	

	-- if (@p_speedometer_end_indctn is null)		
   -- set @p_speedometer_end_indctn = 0.0

	 if (@p_fuel_start_left	is null)
    set @p_fuel_start_left = 0.0

	-- if (@p_fuel_end_left is null) 
	--set @p_fuel_end_left = 0.0

	-- if (@p_fuel_gived is null)
   -- set @p_fuel_gived = 0.0

	-- if (@p_fuel_return	is null)
	--set @p_fuel_return = 0.0

	-- if (@p_fuel_addtnl_exp is null)
   -- set @p_fuel_addtnl_exp = 0.0

	-- if (@p_run is null)
   -- set @p_run = 0.0

	-- if (@p_fuel_consumption is null)
	--set @p_fuel_consumption = 0.0


	-- if (@p_last_run is null)
	--set @p_last_run = 0.0

     if (@p_edit_state is null)
	set @p_edit_state = '-'

	 if (@p_pw_trailer_amount is null)
	set @p_pw_trailer_amount = 0.0

	set @v_trailer_id = dbo.usfConst('Ёнергоустановка')

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount


     if (@@tranCount = 0)
	begin transaction  


      -- надо добавл€ть
 if (@p_id is null)
    begin

	    if (@p_number is null)
			begin   

			
			 exec @v_Error = dbo.uspVDRV_DRIVER_LIST_SEQ_Generate 
				 @p_car_type_id = @p_driver_list_type_id
				,@p_organization_id = @p_organization_id
				,@p_number = @p_number OUTPUT
			    ,@p_sys_comment = @p_sys_comment


			if (@v_Error > 0)
			 begin 
			  if (@@tranCount > @v_TrancountOnEntry)
				 rollback
			  return @v_Error	
			 end
			end 
	 	
	   		insert into
			     dbo.CDRV_DRIVER_LIST 
            		(date_created, number, car_id, fact_start_duty, fact_end_duty
			,driver_list_state_id, driver_list_type_id, fuel_exp
			,fuel_type_id, organization_id, employee1_id, employee2_id
			,speedometer_start_indctn,speedometer_end_indctn
		    ,fuel_start_left, fuel_end_left, fuel_gived, fuel_return
			,fuel_addtnl_exp, run, fuel_consumption, last_date_created
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_date_created, @p_number, @p_car_id, @p_fact_start_duty, @p_fact_end_duty
			,@p_driver_list_state_id, @p_driver_list_type_id, @p_fuel_exp
			,@p_fuel_type_id, @p_organization_id, @p_employee1_id, @p_employee2_id
			,@p_speedometer_start_indctn, @p_speedometer_end_indctn
		    ,@p_fuel_start_left, @p_fuel_end_left, @p_fuel_gived, @p_fuel_return
			,@p_fuel_addtnl_exp, @p_run, @p_fuel_consumption, @p_last_date_created
			,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
	--«апомним совершенное действие
	  set @v_action = 'I'
    end   
       
	    
 else
	begin
  -- запомним последние значени€ машины и водител€	
	select  @v_last_car_id = car_id
		   ,@v_last_emp_id = employee1_id
		   ,@v_error_date_created = date_created
		   ,@v_error_number = number
		   ,@v_error_fact_start_duty = fact_start_duty
		   ,@v_error_fact_end_duty = fact_end_duty
		   ,@v_error_fuel_exp = fuel_exp
		   ,@v_error_fuel_type_id = fuel_type_id
		   ,@v_error_organization_id = organization_id
		   ,@v_error_speedometer_start_indctn	= speedometer_start_indctn
		   ,@v_error_speedometer_end_indctn = speedometer_end_indctn
		   ,@v_error_fuel_start_left = fuel_start_left
		   ,@v_error_fuel_end_left = fuel_end_left
		   ,@v_error_fuel_gived = fuel_gived
		   ,@v_error_fuel_return = fuel_return	
		   ,@v_error_fuel_addtnl_exp = fuel_addtnl_exp	
		   ,@v_last_run = run	
		   ,@v_error_fuel_consumption	= fuel_consumption
	  from dbo.CDRV_DRIVER_LIST
	where id = @p_id
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
	  , last_date_created = @p_last_date_created
	  , sys_comment = @p_sys_comment
      , sys_user_modified = @p_sys_user
	where ID = @p_id
--«апомним совершенное действие
	set @v_action = 'E'

	end

  exec  @v_Error = dbo.uspVDRV_TRAILER_SaveById 
   @p_device_id			= @v_trailer_id
  ,@p_work_hour_amount	= @p_pw_trailer_amount
  ,@p_driver_list_id	= @p_id 
  ,@p_sys_comment		= @p_sys_comment
  ,@p_sys_user			= @p_sys_user

if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end



--ѕостроим отчет по путевому листу
  exec @v_Error = 
        dbo.uspVREP_DRIVER_LIST_Prepare
	 @p_id							=  @p_id
    ,@p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty	
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_driver_list_state_id		= @p_driver_list_state_id
	,@p_driver_list_type_id			= @p_driver_list_type_id
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn	
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp
	,@p_last_run					= @p_last_run
	,@p_run							= @p_run
	,@p_fuel_consumption			= @p_fuel_consumption
	,@p_last_date_created			= @p_last_date_created 
    ,@p_sys_comment			= @p_sys_comment  
  	,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error	
    end

if ((@p_driver_list_state_id = dbo.usfConst('LIST_OPEN')) and (@p_speedometer_end_indctn is null))
 update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('ON_DUTY') 
	where id = @p_car_id
else
  if (not exists (select TOP(1) 1 from dbo.CDRV_DRIVER_LIST where speedometer_end_indctn is null
															  and car_id = @p_car_id))	
  update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_PARK') 
	where id = @p_car_id
-- »зменим состо€ние автомобил€, если известны значени€ по приезду
-- например, показание спидометра
if (@p_speedometer_end_indctn is not null)
begin
-- ѕри редактировании удостоверимс€, что мы прибавили дельту пробега (между старым пробегом и новым)
  if (@p_car_id = @v_last_car_id)
   begin
	if (@v_action = 'E') and (@p_last_run <> 0)
		set @p_run = @p_run - @p_last_run
	else
     begin
-- ”бедимс€, что при отсутствии изменений пробега мы не увеличим пробег
	if (@v_action = 'E') and (@p_last_run = 0) and (@p_condition_id is not null)
		set @p_run = 0
	 end
   end

  
  exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @p_condition_id
    		,@p_car_id		        = @p_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @p_run
    		,@p_last_run			= @p_last_run
    		,@p_speedometer_start_indctn 	= @p_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @p_speedometer_end_indctn
			,@p_fuel_start_left = @p_fuel_start_left
			,@p_fuel_end_left = @p_fuel_end_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
 -- ≈сли помен€лась машина, то мы должны вычесть у ошибочной машины прибавленный пробег
 if ((@p_car_id <> @v_last_car_id) and (@v_last_car_id is not null))
 begin

   set @v_error_run = -@v_last_run

   select @v_condition_id = id
	 from dbo.CCAR_CONDITION
	where car_id = @v_last_car_id

   exec @v_Error = 
        dbo.uspVCAR_CONDITION_SaveById
        	 @p_id				= @v_condition_id
    		,@p_car_id		        = @v_last_car_id
    		,@p_ts_type_master_id		= null
    		,@p_employee_id			= @p_employee_id	
    		,@p_run				= @v_error_run
    		,@p_last_run			= null
    		,@p_speedometer_start_indctn 	= @v_error_speedometer_start_indctn 
    		,@p_speedometer_end_indctn 	= @v_error_speedometer_start_indctn
			,@p_fuel_start_left = @v_error_fuel_start_left
			,@p_fuel_end_left = @v_error_fuel_start_left    
    		,@p_sys_comment			= @p_sys_comment  
  		,@p_sys_user 			= @p_sys_user

    if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
 end
--ѕосчитаем отчеты, если у нас закрытый п/л
if (@p_driver_list_state_id = dbo.usfConst('LIST_CLOSED'))
begin
--Ќезачем пересчитывать на прошлый и текущий день, если не было редактировани€
 if (@p_edit_state <> 'E')
 set @p_last_date_created = null
--ќтчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @p_date_created
	,@p_number						= @p_number
	,@p_car_id						= @p_car_id
	,@p_fact_start_duty				= @p_fact_start_duty
	,@p_fact_end_duty				= @p_fact_end_duty
	,@p_fuel_exp					= @p_fuel_exp
	,@p_fuel_type_id				= @p_fuel_type_id
	,@p_organization_id				= @p_organization_id
	,@p_employee1_id				= @p_employee1_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @p_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @p_speedometer_end_indctn
	,@p_fuel_start_left				= @p_fuel_start_left
	,@p_fuel_end_left				= @p_fuel_end_left
	,@p_fuel_gived					= @p_fuel_gived
	,@p_fuel_return					= @p_fuel_return	
	,@p_fuel_addtnl_exp				= @p_fuel_addtnl_exp	
	,@p_run							= @p_run	
	,@p_fuel_consumption			= @p_fuel_consumption
	,@p_last_date_created			= @p_last_date_created
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
-- пересчитаем измененный автомобиль на вс€кий случай
if ((@p_car_id <> @v_last_car_id) and (@v_last_car_id is not null))
 begin
   --ќтчеты
 exec @v_Error = dbo.uspVREP_CAR_Prepare
     @p_date_created				= @v_error_date_created
	,@p_number						= @v_error_number
	,@p_car_id						= @v_last_car_id
	,@p_fact_start_duty				= @v_error_fact_start_duty
	,@p_fact_end_duty				= @v_error_fact_end_duty
	,@p_fuel_exp					= @v_error_fuel_exp
	,@p_fuel_type_id				= @v_error_fuel_type_id
	,@p_organization_id				= @v_error_organization_id
	,@p_employee1_id				= @v_last_emp_id
	,@p_employee2_id				= @p_employee2_id
	,@p_speedometer_start_indctn	= @v_error_speedometer_start_indctn
	,@p_speedometer_end_indctn		= @v_error_speedometer_end_indctn
	,@p_fuel_start_left				= @v_error_fuel_start_left
	,@p_fuel_end_left				= @v_error_fuel_end_left
	,@p_fuel_gived					= @v_error_fuel_gived
	,@p_fuel_return					= @v_error_fuel_return	
	,@p_fuel_addtnl_exp				= @v_error_fuel_addtnl_exp	
	,@p_run							= @v_error_run	
	,@p_fuel_consumption			= @v_error_fuel_consumption
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
 end

 
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @p_date_created	  
	,@p_employee_id			= @p_employee1_id
	,@p_last_date_created			= @p_last_date_created
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  
--пересчитаем измененного водител€
 if ((@p_employee1_id <> @v_last_emp_id) and (@v_last_emp_id is not null))
 begin
  exec @v_Error = dbo.uspVREP_EMPLOYEE_Prepare
	 @p_date_created		= @v_error_date_created	  
	,@p_employee_id			= @v_last_emp_id
	,@p_last_date_created			= null
    ,@p_sys_comment					= @p_sys_comment
    ,@p_sys_user					= @p_sys_user

  if (@v_Error > 0)
    begin 
      if (@@tranCount > @v_TrancountOnEntry)
         rollback
    return @v_Error
    end 
  end
 end





  if (@@tranCount > @v_TrancountOnEntry)
    commit
    
  return  

end
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


