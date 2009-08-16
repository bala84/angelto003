:r ./../_define.sql

:setvar dc_number 00356
:setvar dc_description "income det fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    08.08.2008 VLavrentiev  income det fixed
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_INCOME_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà ñîõğàíèòü äåòàëü ïğèõîäíîãî äîêóìåíòà
**
**  Âõîäíûå ïàğàìåòğû: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_income_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_good_category_price_id  numeric(38,0) = null
	,@p_amount					decimal(18,9)
	,@p_total					int
	,@p_price					decimal(18,9) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int
		  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
		  , @v_warehouse_type_id numeric(38,0)
		  , @v_organization_id  numeric(38,0)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
    --Ïğîñòàâèì ğåæèì îáğàáîòêè äëÿ òîâàğà ñî ñêëàäà â ğåæèì àïäåéòà
	set @v_edit_state = 'U'

    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 
       -- íàäî äîáàâëÿòü
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_DETAIL 
            ( wrh_income_master_id, good_category_id
			, good_category_price_id, amount
			, total, price
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_income_master_id, @p_good_category_id
			, @p_good_category_price_id, @p_amount
			, @p_total, @p_price
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- íàäî ïğàâèòü ñóùåñòâóşùèé
		update dbo.CWRH_WRH_INCOME_DETAIL set
		 wrh_income_master_id = @p_wrh_income_master_id
	    ,good_category_id = @p_good_category_id
		,good_category_price_id = @p_good_category_price_id
		,amount = @p_amount
		,total = @p_total
		,price = @p_price
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

  select @v_warehouse_type_id = c.warehouse_type_id 
		,@v_organization_id = c.organization_recieve_id
						from dbo.CWRH_WRH_INCOME_MASTER as c
					    where id = @p_wrh_income_master_id

  select @v_warehouse_item_id = a.id
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @v_warehouse_type_id
	 and a.organization_id = @v_organization_id

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @v_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id
	   ,@p_edit_state = @v_edit_state
	   ,@p_price = @p_price
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

--Îò÷åò äëÿ ñêëàäà
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_INCOME_Prepare
	    @p_wrh_income_master_id = @p_wrh_income_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id
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
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà ïîäñ÷èòûâàòü äàííûå äëÿ îò÷åòîâ î ñóììàğíûõ çàòğàòàõ íà àâòîìîáèëü
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      01.07.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
	 @p_date_created		datetime		
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_begin_mntnc_date	datetime		= null
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0)
	,@p_organization_sname  varchar(30)	 
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_hour_0				decimal(18,9)
	,@v_hour_1				decimal(18,9)	
	,@v_hour_2				decimal(18,9)
	,@v_hour_3				decimal(18,9)
	,@v_hour_4				decimal(18,9)
	,@v_hour_5				decimal(18,9)
	,@v_hour_6				decimal(18,9)
	,@v_hour_7				decimal(18,9)
	,@v_hour_8				decimal(18,9)
	,@v_hour_9				decimal(18,9)
	,@v_hour_10				decimal(18,9)
	,@v_hour_11				decimal(18,9)
	,@v_hour_12				decimal(18,9)
	,@v_hour_13				decimal(18,9)
	,@v_hour_14				decimal(18,9)
	,@v_hour_15				decimal(18,9)
	,@v_hour_16				decimal(18,9)
	,@v_hour_17				decimal(18,9)
	,@v_hour_18				decimal(18,9)
	,@v_hour_19				decimal(18,9)
	,@v_hour_20				decimal(18,9)
	,@v_hour_21				decimal(18,9)
	,@v_hour_22				decimal(18,9)
	,@v_hour_23				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry int
	,@v_exit_amnt  int
	,@v_hour				tinyint
	,@v_value_id			numeric(38,0)
	,@v_value				decimal(18,9)
	,@v_month_created		datetime
	,@v_year_created		datetime
	,@v_day_created			datetime
	,@v_fact_start_duty		datetime
	,@v_fact_end_duty		datetime
	,@v_speedometer_start_indctn decimal(18,9)
	,@v_speedometer_end_indctn	 decimal(18,9)
	,@v_fuel_start_left			 decimal(18,9)
	,@v_fuel_end_left			 decimal(18,9)
	


 set  @v_value_id = dbo.usfConst('CAR_WRH_ITEM_PRICE')
 set  @v_day_created = dbo.usfUtils_TimeToZero(@p_date_created)


  select
		 @v_fact_start_duty = min(fact_start_duty)
		,@v_fact_end_duty = max(fact_end_duty)
		,@v_speedometer_start_indctn = (select TOP(1) speedometer_start_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty asc)
		,@v_speedometer_end_indctn = (select TOP(1) speedometer_end_indctn from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty desc)
		,@v_fuel_start_left		= (select TOP(1) fuel_start_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty asc)
		,@v_fuel_end_left		= (select TOP(1) fuel_end_left from  dbo.CDRV_DRIVER_LIST as b
																			   where a.car_id = b.car_id
																				   and date_created > = @v_day_created
																				   and date_created < @v_day_created + 1
																				order by fact_start_duty desc)
 from dbo.CDRV_DRIVER_LIST as a
 where car_id = @p_car_id
   and date_created > = @v_day_created
   and date_created < @v_day_created + 1
 group by a.car_id

 

select 
@v_hour_0 = 
		sum(case datepart("Hh", a.date_created)
	   when 0 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_1 = 
		sum(case datepart("Hh", a.date_created)
	   when 1 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_2 = 
		sum(case datepart("Hh", a.date_created)
	   when 2 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_3 = 
		sum(case datepart("Hh", a.date_created)
	   when 3 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_4 = 
		sum(case datepart("Hh", a.date_created)
	   when 4 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_5 = 
		sum(case datepart("Hh", a.date_created)
	   when 5
	   then c.total_sum
	   else 0
		end)
	  ,@v_hour_6 = 
		sum(case datepart("Hh", a.date_created)
	   when 6 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_7 = 
		sum(case datepart("Hh", a.date_created)
	   when 7 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_8 = 
		sum(case datepart("Hh", a.date_created)
	   when 8 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_9 = 
		sum(case datepart("Hh", a.date_created)
	   when 9 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_10 = 
		sum(case datepart("Hh", a.date_created)
	   when 10 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_11 = 
		sum(case datepart("Hh", a.date_created)
	   when 11
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_12 = 
		sum(case datepart("Hh", a.date_created)
	   when 12 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_13 = 
		sum(case datepart("Hh", a.date_created)
	   when 13 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_14 = 
		sum(case datepart("Hh", a.date_created)
	   when 14 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_15 = 
		sum(case datepart("Hh", a.date_created)
	   when 15 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_16 = 
		sum(case datepart("Hh", a.date_created)
	   when 16
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_17 = 
		sum(case datepart("Hh", a.date_created)
	   when 17 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_18 = 
		sum(case datepart("Hh", a.date_created)
	   when 18 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_19 = 
		sum(case datepart("Hh", a.date_created)
	   when 19 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_20 = 
		sum(case datepart("Hh", a.date_created)
	   when 20
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_21 = 
		sum(case datepart("Hh", a.date_created)
	   when 21
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_22 = 
		sum(case datepart("Hh", a.date_created)
	   when 22 
	   then c.total_sum
	   else 0
	   end)
	  ,@v_hour_23 = 
		sum(case datepart("Hh", a.date_created)
	   when 23
	   then c.total_sum
	   else 0
	   end)
	from 
dbo.CWRH_WRH_DEMAND_MASTER as a
join dbo.CWRH_WRH_DEMAND_DETAIL as b
	on a.id = b.wrh_demand_master_id
outer apply (select TOP(1) price*b.amount as total_sum
					 from dbo.CHIS_WAREHOUSE_ITEM
					 where good_category_id = b.good_category_id 
					   and warehouse_type_id = b.warehouse_type_id
					   and organization_id = a.organization_giver_id
					   and date_created <= a.date_created
					   and price is not null
					 order by date_created desc) as c
where a.car_id = @p_car_id
and a.date_created >= @v_day_created
and a.date_created < @v_day_created + 1

  set @v_Error = 0
  set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 

  exec @v_Error = dbo.uspVREP_CAR_HOUR_SaveById
			 @p_day_created  = @v_day_created
			,@p_value_id	 = @v_value_id
			,@p_state_number = @p_state_number
			,@p_car_id = @p_car_id
			,@p_car_type_id = @p_car_type_id
			,@p_car_type_sname = @p_car_type_sname
			,@p_car_state_id = @p_car_state_id	
			,@p_car_state_sname = @p_car_state_sname
			,@p_car_mark_id = @p_car_mark_id
			,@p_car_mark_sname = @p_car_mark_sname
			,@p_car_model_id = @p_car_model_id
			,@p_car_model_sname = @p_car_model_sname
			,@p_begin_mntnc_date = @p_begin_mntnc_date
			,@p_fuel_type_id = @p_fuel_type_id
			,@p_fuel_type_sname = @p_fuel_type_sname
			,@p_car_kind_id = @p_car_kind_id
			,@p_car_kind_sname = @p_car_kind_sname
			,@p_hour_0 = @v_hour_0
			,@p_hour_1 = @v_hour_1
			,@p_hour_2 = @v_hour_2
			,@p_hour_3 = @v_hour_3
			,@p_hour_4 = @v_hour_4
			,@p_hour_5 = @v_hour_5
			,@p_hour_6 = @v_hour_6
			,@p_hour_7 = @v_hour_7
			,@p_hour_8 = @v_hour_8
			,@p_hour_9 = @v_hour_9
			,@p_hour_10 = @v_hour_10
			,@p_hour_11 = @v_hour_11
			,@p_hour_12 = @v_hour_12
			,@p_hour_13 = @v_hour_13
			,@p_hour_14 = @v_hour_14
			,@p_hour_15 = @v_hour_15
			,@p_hour_16 = @v_hour_16
			,@p_hour_17 = @v_hour_17
			,@p_hour_18 = @v_hour_18
			,@p_hour_19 = @v_hour_19
			,@p_hour_20 = @v_hour_20
			,@p_hour_21 = @v_hour_21
			,@p_hour_22 = @v_hour_22
			,@p_hour_23 = @v_hour_23
			,@p_speedometer_start_indctn = @v_speedometer_start_indctn
			,@p_speedometer_end_indctn = @v_speedometer_end_indctn
			,@p_fuel_start_left = @v_fuel_start_left
			,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 


   select @v_value = sum(hour_0) + sum(hour_1) + sum(hour_2)
					 + sum(hour_3) + sum(hour_4) + sum(hour_5) + sum(hour_6)
					 + sum(hour_7) + sum(hour_8) + sum(hour_9) + sum(hour_10)
					 + sum(hour_11) + sum(hour_12) + sum(hour_13) + sum(hour_14)
					 + sum(hour_15) + sum(hour_16) + sum(hour_17) + sum(hour_18)
					 + sum(hour_19) + sum(hour_20) + sum(hour_21) + sum(hour_22)
					 + sum(hour_23)
    from dbo.CREP_CAR_HOUR
  where car_id = @p_car_id
	and value_id = @v_value_id
	and day_created = @v_day_created

   set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_DAY_SaveById
				 @p_day_created			= @p_date_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_month_created 		= @v_day_created
				,@p_speedometer_start_indctn = @v_speedometer_start_indctn
				,@p_speedometer_end_indctn = @v_speedometer_end_indctn
				,@p_fuel_start_left = @v_fuel_start_left
				,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   set @v_year_created = dbo.usfUtils_MonthTo01(@v_month_created)

   exec @v_Error = 
		dbo.uspVREP_CAR_MONTH_SaveById
				 @p_month_created		= @v_month_created
				,@p_state_number		= @p_state_number
				,@p_value_id			= @v_value_id
				,@p_car_id				= @p_car_id
				,@p_car_type_id			= @p_car_type_id
				,@p_car_type_sname		= @p_car_type_sname
				,@p_car_state_id		= @p_car_state_id
				,@p_car_state_sname		= @p_car_state_sname
				,@p_car_mark_id			= @p_car_mark_id
				,@p_car_mark_sname		= @p_car_mark_sname
				,@p_car_model_id		= @p_car_model_id
				,@p_car_model_sname		= @p_car_model_sname
				,@p_begin_mntnc_date	= @p_begin_mntnc_date
				,@p_fuel_type_id		= @p_fuel_type_id
				,@p_fuel_type_sname		= @p_fuel_type_sname
				,@p_car_kind_id			= @p_car_kind_id
				,@p_car_kind_sname		= @p_car_kind_sname
				,@p_value 				= @v_value
		  		,@p_year_created 		= @v_month_created
				,@p_speedometer_start_indctn = @v_speedometer_start_indctn
				,@p_speedometer_end_indctn = @v_speedometer_end_indctn
				,@p_fuel_start_left = @v_fuel_start_left
				,@p_fuel_end_left = @v_fuel_end_left
				,@p_organization_id = @p_organization_id
				,@p_organization_sname = @p_organization_sname
			,@p_fact_start_duty = @v_fact_start_duty
			,@p_fact_end_duty = @v_fact_end_duty
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@trancount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

	   if (@@trancount > @v_TrancountOnEntry)
        commit

	RETURN

go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà ñîõğàíèòü äåòàëü òğåáîâàíèÿ
**
**  Âõîäíûå ïàğàìåòğû: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_demand_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				decimal(18,9) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int
		  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
		  , @v_organization_id numeric(38,0)
		  , @v_date_created    datetime
		  , @v_car_id numeric(38,0)
		  , @v_price	decimal(18,2)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    --Ïğîñòàâèì ğåæèì îáğàáîòêè äëÿ òîâàğà ñî ñêëàäà â ğåæèì àïäåéòà
	set @v_edit_state = 'U'

    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

       -- íàäî äîáàâëÿòü
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_DETAIL 
            ( wrh_demand_master_id, good_category_id
			, amount, warehouse_type_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- íàäî ïğàâèòü ñóùåñòâóşùèé
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id


  exec @v_Error = 
		dbo.uspVREP_WRH_DEMAND_Calculate
				 @p_id					= null
				,@p_wrh_demand_detail_id= @p_id
				,@p_wrh_demand_master_id= @p_wrh_demand_master_id
				,@p_good_category_id	= @p_good_category_id
				,@p_amount				= @p_amount
				,@p_warehouse_type_id	= @p_warehouse_type_id
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end


select @v_organization_id = a.organization_giver_id
	  ,@v_date_created	  = a.date_created
	  ,@v_car_id		  = a.car_id
from dbo.CWRH_WRH_DEMAND_MASTER as a
where id = @p_wrh_demand_master_id
 

select  @v_warehouse_item_id = a.id
		,@v_price = a.price
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id
	 and a.organization_id = @v_organization_id

--Îò÷åò äëÿ ñêëàäà
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare
	    @p_wrh_demand_master_id = @p_wrh_demand_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_warehouse_type_id	= @p_warehouse_type_id
	   ,@p_organization_id = @v_organization_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

--Îò÷åò ïî çàòğàòàì íà àâòîìîáèëè
 if (@v_car_id is not null)
  begin
   exec @v_Error = 
        dbo.uspVREP_CAR_WRH_ITEM_PRICE_Prepare
	    @p_date_created = @v_date_created
	   ,@p_car_id = @v_car_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

if (@p_last_amount is null) or (@p_last_amount = @p_amount)
	set @p_amount = -@p_amount
else
	set @p_amount = -(@p_amount - @p_last_amount)

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @p_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id 
	   ,@p_edit_state = @v_edit_state
	   ,@p_price = @v_price
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
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVWRH_WAREHOUSE_ITEM_SelectByType_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà èçâëåêàòü äàííûå î ñîäåğæèìîì ñêëàäà
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0) = null
 ,@p_warehouse_type_id	   numeric(38,0)
 ,@p_organization_id	   numeric(38,0) = null
 ,@p_Str				  varchar(100) = null
 ,@p_Srch_Type			   tinyint = null 
 ,@p_Top_n_by_rank		   smallint = null
)
AS
SET NOCOUNT ON

declare
      @v_Srch_Str      varchar(1000)
 
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.usfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @p_Top_n_by_rank = 1
  
  -- Ïğåîáğàçóåì ñòğîêó ïîèñêà
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  -- Ìû äîëæíû óìåòü ãğóïïèğîâàòü îğãàíèçàöèè â òîâàğå è âûâîäèòü îáùóş ñóììó
  -- ïîıòîìó âûâîäèì ñ ôóíêöèÿìè
       SELECT  
		   max(id) as id
		  ,min(sys_status) as sys_status
		  ,min(sys_comment) as sys_comment
		  ,min(sys_date_modified) as sys_date_modified
		  ,min(sys_date_created) as sys_date_created
		  ,min(sys_user_modified) as sys_user_modified
		  ,min(sys_user_created) as sys_user_created
		  ,min(warehouse_type_id) as warehouse_type_id
		  ,sum(amount) as amount
		  ,min(good_category_id) as good_category_id
		  ,min(good_mark) as good_mark
		  ,min(good_category_sname) as good_category_sname
		  ,min(good_category_fname) as good_category_fname
		  ,min(unit) as unit
		  ,min(good_category_type_id) as good_category_type_id
		  ,min(good_category_type_sname) as good_category_type_sname
		  ,min(warehouse_type_sname) as warehouse_type_sname
		  ,avg(price) as price
		 --äëÿ ğåäèìà ğåäàêòèğîâàíèÿ âûâåäåì edit_state (íóæíî ëè çàïîìèíàòü â áä?)
		  ,null as edit_state
		  ,max(organization_id)
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id
									,@p_organization_id) as a
    WHERE 
--ïîèñê
(((@p_Str != '')
		   and (rtrim(ltrim(upper(good_category_sname))) like rtrim(ltrim(upper(@p_Str + '%')))))
		or (@p_Str = ''))
/*(((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))
		or (@p_Str = '')) */
group by good_category_id

	RETURN
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà ñîõğàíèòü äåòàëü òğåáîâàíèÿ
**
**  Âõîäíûå ïàğàìåòğû: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_demand_master_id	numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_warehouse_type_id		numeric(38,0)
	,@p_last_amount				decimal(18,9) = null
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on

	declare @v_Error int
          	  , @v_TrancountOnEntry int
		  , @v_warehouse_item_id numeric(38,0)
		  , @v_edit_state char(1)
		  , @v_organization_id numeric(38,0)
		  , @v_date_created    datetime
		  , @v_car_id numeric(38,0)
		  , @v_price	decimal(18,2)

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    --Ïğîñòàâèì ğåæèì îáğàáîòêè äëÿ òîâàğà ñî ñêëàäà â ğåæèì àïäåéòà
	set @v_edit_state = 'U'

    set @v_Error = 0 
    set @v_TrancountOnEntry = @@tranCount

  if (@@tranCount = 0)
    begin transaction 

       -- íàäî äîáàâëÿòü
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_DEMAND_DETAIL 
            ( wrh_demand_master_id, good_category_id
			, amount, warehouse_type_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_wrh_demand_master_id, @p_good_category_id
			, @p_amount, @p_warehouse_type_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- íàäî ïğàâèòü ñóùåñòâóşùèé
		update dbo.CWRH_WRH_DEMAND_DETAIL set
		 wrh_demand_master_id = @p_wrh_demand_master_id
	    ,good_category_id = @p_good_category_id
		,amount = @p_amount
		,warehouse_type_id = @p_warehouse_type_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id


  exec @v_Error = 
		dbo.uspVREP_WRH_DEMAND_Calculate
				 @p_id					= null
				,@p_wrh_demand_detail_id= @p_id
				,@p_wrh_demand_master_id= @p_wrh_demand_master_id
				,@p_good_category_id	= @p_good_category_id
				,@p_amount				= @p_amount
				,@p_warehouse_type_id	= @p_warehouse_type_id
				,@p_sys_comment			= @p_sys_comment 
				,@p_sys_user			= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end


select @v_organization_id = a.organization_giver_id
	  ,@v_date_created	  = a.date_created
	  ,@v_car_id		  = a.car_id
from dbo.CWRH_WRH_DEMAND_MASTER as a
where id = @p_wrh_demand_master_id
 

select  @v_warehouse_item_id = a.id
		,@v_price = a.price
	from dbo.CWRH_WAREHOUSE_ITEM as a
   where a.good_category_id = @p_good_category_id
	 and a.warehouse_type_id = @p_warehouse_type_id
	 and a.organization_id = @v_organization_id

--Îò÷åò äëÿ ñêëàäà
  exec @v_Error = 
        dbo.uspVREP_WAREHOUSE_ITEM_OUTCOME_Prepare
	    @p_wrh_demand_master_id = @p_wrh_demand_master_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_warehouse_type_id	= @p_warehouse_type_id
	   ,@p_organization_id = @v_organization_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

--Îò÷åò ïî çàòğàòàì íà àâòîìîáèëè
 if (@v_car_id is not null)
  begin
   exec @v_Error = 
        dbo.uspVREP_CAR_WRH_ITEM_PRICE_Prepare
	    @p_date_created = @v_date_created
	   ,@p_car_id = @v_car_id
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
  end

if (@p_last_amount is null)
	set @p_amount = -@p_amount
else
  begin
	if (@p_last_amount = @p_amount)
		set @p_amount = 0 
	else
		set @p_amount = -(@p_amount - @p_last_amount)
  end

  exec @v_Error = 
        dbo.uspVWRH_WAREHOUSE_ITEM_SaveById
        @p_id = @v_warehouse_item_id
	   ,@p_amount = @p_amount
	   ,@p_warehouse_type_id = @p_warehouse_type_id
	   ,@p_good_category_id = @p_good_category_id
	   ,@p_organization_id = @v_organization_id 
	   ,@p_edit_state = @v_edit_state
	   ,@p_price = @v_price
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
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_OUTCOME_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Ïğîöåäóğà äîëæíà ïîäñ÷èòûâàòü äàííûå ïî âûäà÷å òîâàğîâ äëÿ îò÷åòîâ ïî ñêëàäó
**
**  Âõîäíûå ïàğàìåòğû:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.05.2008 VLavrentiev	Äîáàâèë íîâóş ïğîöåäóğó
*******************************************************************************/
(
	 @p_date_created		datetime	  
	,@p_good_category_id	 numeric(38,0)
	,@p_good_category_fname  varchar(60)
	,@p_good_mark			 varchar(30)
	,@p_warehouse_type_id	 numeric(38,0)
	,@p_warehouse_type_sname varchar(30)
	,@p_value_id			 numeric(38,0)
	,@p_organization_id		 numeric(38,0)
	,@p_organization_sname   varchar(30)
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
--set xact_abort on
  
  declare

	 @v_day_1				decimal(18,9)	
	,@v_day_2				decimal(18,9)
	,@v_day_3				decimal(18,9)
	,@v_day_4				decimal(18,9)
	,@v_day_5				decimal(18,9)
	,@v_day_6				decimal(18,9)
	,@v_day_7				decimal(18,9)
	,@v_day_8				decimal(18,9)
	,@v_day_9				decimal(18,9)
	,@v_day_10				decimal(18,9)
	,@v_day_11				decimal(18,9)
	,@v_day_12				decimal(18,9)
	,@v_day_13				decimal(18,9)
	,@v_day_14				decimal(18,9)
	,@v_day_15				decimal(18,9)
	,@v_day_16				decimal(18,9)
	,@v_day_17				decimal(18,9)
	,@v_day_18				decimal(18,9)
	,@v_day_19				decimal(18,9)
	,@v_day_20				decimal(18,9)
	,@v_day_21				decimal(18,9)
	,@v_day_22				decimal(18,9)
	,@v_day_23				decimal(18,9)
	,@v_day_24				decimal(18,9)
	,@v_day_25				decimal(18,9)
	,@v_day_26				decimal(18,9)
	,@v_day_27				decimal(18,9)
	,@v_day_28				decimal(18,9)
	,@v_day_29				decimal(18,9)
	,@v_day_30				decimal(18,9)
	,@v_day_31				decimal(18,9)
	,@v_Error				int
    ,@v_TrancountOnEntry	int
	,@v_value_amount_id		numeric(38,0)
	,@v_value_price_id		numeric(38,0)
	,@v_month_created		datetime
	,@v_day_created			datetime
	,@v_price			    decimal(18,9)
	
  
 set @v_value_amount_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_AMOUNT')
 set @v_value_price_id = dbo.usfConst('WAREHOUSE_ITEM_OUTCOME_PRICE')

 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)

select @v_price = price
	from dbo.CWRH_WAREHOUSE_ITEM
	where good_category_id = @p_good_category_id
	  and warehouse_type_id = @p_warehouse_type_id
	  and organization_id = @p_organization_id



select @v_day_1 = sum(case when datepart("Day", b.date_created) = 1
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_2 = sum(case when datepart("Day", b.date_created) = 2
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_3 = sum(case when datepart("Day", b.date_created) = 3
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_4 = sum(case when datepart("Day", b.date_created) = 4
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_5 = sum(case when datepart("Day", b.date_created) = 5
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_6 = sum(case when datepart("Day", b.date_created) = 6
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_7 = sum(case when datepart("Day", b.date_created) = 7
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_8 = sum(case when datepart("Day", b.date_created) = 8
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_9 = sum(case when datepart("Day", b.date_created) = 9
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_10 = sum(case when datepart("Day", b.date_created) = 10
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_11 = sum(case when datepart("Day", b.date_created) = 11
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_12 = sum(case when datepart("Day", b.date_created) = 12
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_13 = sum(case when datepart("Day", b.date_created) = 13
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_14 = sum(case when datepart("Day", b.date_created) = 14
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_15 = sum(case when datepart("Day", b.date_created) = 15
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_16 = sum(case when datepart("Day", b.date_created) = 16
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_17 = sum(case when datepart("Day", b.date_created) = 17
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_18 = sum(case when datepart("Day", b.date_created) = 18
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end) 
	  ,@v_day_19 = sum(case when datepart("Day", b.date_created) = 19
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_20 = sum(case when datepart("Day", b.date_created) = 20
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_21 = sum(case when datepart("Day", b.date_created) = 21
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_22 = sum(case when datepart("Day", b.date_created) = 22
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_23 = sum(case when datepart("Day", b.date_created) = 23
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_24 = sum(case when datepart("Day", b.date_created) = 24
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_25 = sum(case when datepart("Day", b.date_created) = 25
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_26 = sum(case when datepart("Day", b.date_created) = 26
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_27 = sum(case when datepart("Day", b.date_created) = 27
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_28 = sum(case when datepart("Day", b.date_created) = 28
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_29 = sum(case when datepart("Day", b.date_created) = 29
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_30 = sum(case when datepart("Day", b.date_created) = 30
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)
	  ,@v_day_31 = sum(case when datepart("Day", b.date_created) = 31
				then case when @p_value_id = @v_value_amount_id
						  then isnull(a.amount, 0)
						  when @p_value_id = @v_value_price_id
						  then isnull(@v_price, 0)
					 end
				else 0
		   end)  
  from dbo.CWRH_WRH_DEMAND_DETAIL as a
	join dbo.CWRH_WRH_DEMAND_MASTER as b
		on a.wrh_demand_master_id = b.id 
where a.good_category_id = @p_good_category_id
  and a.warehouse_type_id = @p_warehouse_type_id
  and b.organization_giver_id = @p_organization_id
   and b.date_created > = @v_month_created
   and b.date_created < dateadd("mm", 1, @v_month_created)


  exec @v_Error = dbo.uspVREP_WAREHOUSE_ITEM_DAY_SaveById
			 @p_value_id			= @p_value_id
			,@p_good_category_id	= @p_good_category_id
			,@p_good_category_fname	= @p_good_category_fname
			,@p_good_mark			= @p_good_mark
			,@p_warehouse_type_id	= @p_warehouse_type_id
			,@p_warehouse_type_sname= @p_warehouse_type_sname
			,@p_day_1 = @v_day_1
			,@p_day_2 = @v_day_2
			,@p_day_3 = @v_day_3
			,@p_day_4 = @v_day_4
			,@p_day_5 = @v_day_5
			,@p_day_6 = @v_day_6
			,@p_day_7 = @v_day_7
			,@p_day_8 = @v_day_8
			,@p_day_9 = @v_day_9
			,@p_day_10 = @v_day_10
			,@p_day_11 = @v_day_11
			,@p_day_12 = @v_day_12
			,@p_day_13 = @v_day_13
			,@p_day_14 = @v_day_14
			,@p_day_15 = @v_day_15
			,@p_day_16 = @v_day_16
			,@p_day_17 = @v_day_17
			,@p_day_18 = @v_day_18
			,@p_day_19 = @v_day_19
			,@p_day_20 = @v_day_20
			,@p_day_21 = @v_day_21
			,@p_day_22 = @v_day_22
			,@p_day_23 = @v_day_23
			,@p_day_24 = @v_day_24
			,@p_day_25 = @v_day_25
			,@p_day_26 = @v_day_26
			,@p_day_27 = @v_day_27
			,@p_day_28 = @v_day_28
			,@p_day_29 = @v_day_29
			,@p_day_30 = @v_day_30
			,@p_day_31 = @v_day_31
			,@p_month_created = @v_month_created
			,@p_organization_id	= @p_organization_id
			,@p_organization_sname = @p_organization_sname
			,@p_sys_comment = @p_sys_comment
			,@p_sys_user = @p_sys_user

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


