
:r ./../_define.sql

:setvar dc_number 00451
:setvar dc_description "noexit fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   09.04.2009 VLavrentiev   noexit fix
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

declare
	 @v_name varchar(100)



select @v_name = c.name 
 from sys.all_columns as a
		join sys.all_objects as b
		  on a.object_id = b.object_id
		join sys.default_constraints as c
		  on a.column_id = c.parent_column_id
		   and b.object_id = c.parent_object_id
where a.name = 'is_verified'
  and b.name = 'CWRH_WRH_DEMAND_MASTER'

exec ('alter table dbo.CWRH_WRH_DEMAND_MASTER
		drop constraint ' + @v_name);
go

drop index dbo.CWRH_WRH_DEMAND_MASTER.i_cwrh_wrh_demand_master_is_verified
go


alter table dbo.CWRH_WRH_DEMAND_MASTER
drop column is_verified 
go

alter table dbo.cwrh_wrh_demand_master
add is_verified smallint default 0
go

create index i_cwrh_wrh_demand_master_is_verified on dbo.CWRH_WRH_DEMAND_MASTER(is_verified)
go


declare
	 @v_name varchar(100)



select @v_name = c.name 
 from sys.all_columns as a
		join sys.all_objects as b
		  on a.object_id = b.object_id
		join sys.default_constraints as c
		  on a.column_id = c.parent_column_id
		   and b.object_id = c.parent_object_id
where a.name = 'is_verified'
  and b.name = 'CWRH_WRH_INCOME_MASTER'

exec ('alter table dbo.CWRH_WRH_INCOME_MASTER
		drop constraint ' + @v_name);
go


drop index dbo.CWRH_WRH_INCOME_MASTER.i_cwrh_wrh_income_master_is_verified
go


alter table dbo.CWRH_WRH_INCOME_MASTER
drop column is_verified 
go

alter table dbo.cwrh_wrh_income_master
add is_verified smallint default 0
go

create index i_cwrh_wrh_income_master_is_verified on dbo.CWRH_WRH_INCOME_MASTER(is_verified)
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить приходный документ на складе
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(150)
	,@p_organization_id		numeric(38,0)
    ,@p_warehouse_type_id   numeric(38,0)
	,@p_date_created		datetime
	,@p_total				decimal(18,9)
	,@p_summa				decimal(18,9)
	,@p_organization_recieve_id numeric(38,0)
	,@p_is_verified			varchar(30) = 'Не проверен'
	,@p_account_type		varchar(50) = 'Цена без НДС'
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  declare
    @v_is_verified smallint
   ,@v_account_type smallint



     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'

	 if (@p_account_type is null)
	set @p_account_type = 'Цена без НДС'


	if (@p_is_verified = 'Не проверен')
	 set @v_is_verified = 0
	if (@p_is_verified = 'Проверен')
	 set @v_is_verified = 1
	if (@p_is_verified = 'Корректировка')
	 set @v_is_verified = 2



	if (@p_account_type = 'Цена без НДС')
	 set @v_account_type = 0
	if (@p_account_type = 'Сумма с НДС')
	 set @v_account_type = 1

   

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_INCOME_MASTER 
            ( number, organization_id
			, warehouse_type_id
			, date_created, total, summa, organization_recieve_id, is_verified, account_type
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_number, @p_organization_id
			, @p_warehouse_type_id
			, @p_date_created, @p_total, @p_summa, @p_organization_recieve_id, @v_is_verified, @v_account_type
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_INCOME_MASTER set
		 number = @p_number
	    ,organization_id = @p_organization_id
		,warehouse_type_id = @p_warehouse_type_id
		,date_created = @p_date_created
		,total = @p_total
		,summa = @p_summa
		,organization_recieve_id = @p_organization_recieve_id
		,is_verified = @v_is_verified
		,account_type = @v_account_type
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[uspVWRH_WRH_DEMAND_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить требование для склада
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
	,@p_wrh_demand_master_type_id numeric(38,0) = null
	,@p_organization_giver_id	numeric(38,0) = null
	,@p_wrh_order_master_id	numeric(38,0) = null
	,@p_is_verified			varchar(30) = 'Не проверен'
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	 declare
		 @v_number varchar(20)
		,@v_Error int
        ,@v_TrancountOnEntry int
	,@v_is_verified smallint


     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_is_verified is null)
	set @p_is_verified = 'Не проверен'


     if (@p_is_verified = 'Не проверен')
	  set @v_is_verified = 0
     if (@p_is_verified = 'Проверен')
	  set @v_is_verified = 1	
    if (@p_is_verified = 'Корректировка')
	  set @v_is_verified = 2

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount



if (@@tranCount = 0)
        begin transaction  
      
		if ((@p_number is null) or (@p_number = ''))
		 begin
			insert into dbo.CSYS_DEMAND_MASTER_NUMBER_SEQ	(sys_comment)
			values (@p_sys_comment)

			set @v_number = convert(varchar, scope_identity())	
		 end
		else
			set @v_number = @p_number

       -- надо добавлять
  if (@p_id is null)
    begin



	
	   insert into
			     dbo.CWRH_WRH_DEMAND_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id, is_verified
			, employee_worker_id, wrh_demand_master_type_id, organization_giver_id, wrh_order_master_id
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @v_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @v_is_verified
			, @p_employee_worker_id, @p_wrh_demand_master_type_id, @p_organization_giver_id, @p_wrh_order_master_id
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity()



    end   
       
	    
 else
  begin

  -- надо править существующий
		update dbo.CWRH_WRH_DEMAND_MASTER set
		 car_id = @p_car_id
		,number = @v_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,wrh_demand_master_type_id = @p_wrh_demand_master_type_id
		,organization_giver_id = @p_organization_giver_id
		,wrh_order_master_id = @p_wrh_order_master_id
		,is_verified = @v_is_verified
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
	end


if (@@tranCount > @v_TrancountOnEntry)
        commit
	   
  return 

end
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить заказ-наряд
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id					numeric(38,0) out
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0) = null
	,@p_employee_worker_id		   numeric(38,0) = null
	,@p_employee_output_worker_id  numeric(38,0) = null
	,@p_date_created		datetime
	,@p_order_state			varchar(100)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc			varchar(4000)
	,@p_repair_zone_master_id		numeric(38,0) = null
	,@p_wrh_order_master_type_id	numeric(38,0) = null
	,@p_run				    decimal(18,9) = null
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
	declare
		 @v_order_state smallint
		,@v_Error int
        ,@v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
--Небольшой маршрут состояний заказа-наряда
    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
											 when 'Взят на ремонт, сведений о необх. запчастях нет'
											 then 2
											 when 'Взят на ремонт, есть сведения о необх. запчастях'
											 then 3
											 when 'Обработан'
											 then 4 
											 when 'Отклонен'
											 then 5
											 when 'Корректировка'
											 then 6
						 end


     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
  
  if (@@tranCount = 0)
    begin transaction  
       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_ORDER_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id, employee_output_worker_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc, wrh_order_master_type_id
			, repair_zone_master_id, run, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id, @p_employee_output_worker_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc, @p_wrh_order_master_type_id
			, @p_repair_zone_master_id, @p_run, @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CWRH_WRH_ORDER_MASTER set
		 car_id = @p_car_id
		,number = @p_number
	    ,date_created = @p_date_created
		,employee_recieve_id = @p_employee_recieve_id
		,employee_head_id = @p_employee_head_id
		,employee_worker_id = @p_employee_worker_id
		,employee_output_worker_id = @p_employee_output_worker_id
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
		,repair_zone_master_id = @p_repair_zone_master_id
		,wrh_order_master_type_id = @p_wrh_order_master_type_id
		,run = @p_run
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id
 --Если у машины нет открытого путевого листа 
 
 if (not exists (select top(1) 1 from dbo.cdrv_driver_list
  												where car_id = @p_car_id and speedometer_end_indctn is null))
 begin 
  if (@v_order_state = 0)
 --Если заказ наряд открыт - проставим у машины состояние в ожидании ремонта
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfCONST('IN_WAIT_FOR_REPAIR')
   where id = @p_car_id
  if (@v_order_state = 2) or (@v_order_state = 3)
 --Если заказ-наряд в обработке - проставим у машины состояние в ремзоне
   update dbo.CCAR_CAR
	set car_state_id = dbo.usfConst('IN_REPAIR_ZONE')
   where id = @p_car_id
 --Если закрыт и больше нет других открытых уберем
  if (not exists (select TOP(1) 1 from dbo.CWRH_WRH_ORDER_MASTER
						where order_state = 0 
						   or order_state = 2 
						   or order_state = 3
					      and car_id = @p_car_id
						order by date_created desc))
	  update dbo.CCAR_CAR
		set car_state_id = dbo.usfCONST('IN_PARK')
	    where id = @p_car_id
 end

if (@p_car_id is not null)
 begin
  exec @v_error = dbo.uspVREP_WRH_ORDER_MASTER_Prepare
   @p_id							= @p_id
  ,@p_number						= @p_number
  ,@p_car_id						= @p_car_id
  ,@p_employee_recieve_id			= @p_employee_recieve_id
  ,@p_employee_head_id				= @p_employee_head_id
  ,@p_employee_worker_id			= @p_employee_worker_id
  ,@p_employee_output_worker_id		= @p_employee_output_worker_id
  ,@p_date_created					= @p_date_created
  ,@p_order_state					= @v_order_state
  ,@p_repair_type_id				= @p_repair_type_id
  ,@p_malfunction_desc				= @p_malfunction_desc
  ,@p_repair_zone_master_id			= @p_repair_zone_master_id
  ,@p_wrh_order_master_type_id		= @p_wrh_order_master_type_id
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
 end

  /*exec @v_error = dbo.uspVREP_CAR_REPAIR_TIME_DAY_Prepare
   @p_car_id						= @p_car_id
  ,@p_date_created					= @p_date_created
  ,@p_sys_comment					= @p_sys_comment
  ,@p_sys_user						= @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end */
  --Если заказ в корректировке - то и требования должны быть в корректировке
  if (@v_order_state = 6)

   update dbo.cwrh_wrh_demand_master
	  set is_verified = 2
	 where wrh_order_master_id = @p_id
  else
   update dbo.cwrh_wrh_demand_master
	  set is_verified = 0
	 where wrh_order_master_id = @p_id   
	   and is_verified = 2

  if (@@tranCount > @v_TrancountOnEntry)
  commit

  
  return 

end
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о приходных документах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date  datetime
,@p_end_date	datetime
,@p_Str varchar(100) = null
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
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,number
		  ,organization_id
		  ,organization_name
		  ,warehouse_type_id
		  ,warehouse_type_name
		  ,organization_recieve_id
		  ,organization_recieve_name	
		  ,date_created
		  ,convert(decimal(18,2), total) as total
		  ,convert(decimal(18,2), summa) as summa
		  ,case when is_verified = 0 then 'Не проверен'
				when is_verified = 1 then 'Проверен'
				when is_verified = 2 then 'Корректировка'
			end as is_verified
		  ,case when account_type = 0 then 'Цена без НДС'
				when account_type = 1 then 'Сумма с НДС'
			end as account_type
	FROM dbo.utfVWRH_WRH_INCOME_MASTER()
	WHERE   date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		  and (rtrim(ltrim(upper(number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	   

	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




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
,@p_Str varchar(100) = null
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
		   id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,car_id
		  ,car_organization_id
		  ,car_organization_name
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
		  ,wrh_demand_master_type_id
		  ,wrh_demand_master_type_sname
		  ,organization_giver_id
		  ,organization_giver_sname
		  ,wrh_order_master_id
		  ,wrh_order_master_number
		  ,case when is_verified = 0 then 'Не проверен'
				when is_verified = 1 then 'Проверен'
				when is_verified = 2 then 'Корректировка' 
			end is_verified
	FROM dbo.utfVWRH_WRH_DEMAND_MASTER(@p_start_date, @p_end_date)
	where (((@p_Str != '')
		   and ((rtrim(ltrim(upper(state_number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))
				or (rtrim(ltrim(upper(number))) like rtrim(ltrim(upper('%' + @p_Str + '%'))))))
		or (@p_Str = ''))
	order by date_created desc

	RETURN

go

update dbo.cwrh_wrh_income_master
   set is_verified = 1
where is_verified is null
  and date_created <= convert(datetime, '31.03.2009')
go


update dbo.cwrh_wrh_demand_master
   set is_verified = 1
where is_verified is null
  and date_created <= convert(datetime, '31.03.2009')
go




update dbo.cwrh_wrh_income_master
   set is_verified = 0
where is_verified is null
go


update dbo.cwrh_wrh_demand_master
   set is_verified = 0
where is_verified is null
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER procedure [dbo].[uspVWRH_WRH_ORDER_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить деталь заказа-наряда
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id						numeric(38,0) out
    ,@p_wrh_order_master_id		numeric(38,0)
    ,@p_good_category_id		numeric(38,0)
	,@p_amount					decimal(18,9)
	,@p_left_to_demand			decimal(18,9) = null
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
-- Если товар без указания по количеству (либо еще не выдан), которое надо выдать - запишем его - иначе - это просто товар, который списали по ошибке 
  if (((@p_left_to_demand >= 0) or (@p_left_to_demand is null))
	--Если товар выдан с ошибкой и есть указание на количество необходимое для выдачи - тоже запишем
	or ((@p_left_to_demand < 0) and (@p_amount > 0)))
   begin
			  -- надо добавлять
		  if (@p_id is null)
			begin
			   insert into
						 dbo.CWRH_WRH_ORDER_DETAIL 
					( wrh_order_master_id, good_category_id
					, amount
					, sys_comment, sys_user_created, sys_user_modified)
			   values
					( @p_wrh_order_master_id, @p_good_category_id
					, @p_amount
					, @p_sys_comment, @p_sys_user, @p_sys_user)
		       
			  set @p_id = scope_identity();
			end   
		       
			    
		 else
		  -- надо править существующий
				update dbo.CWRH_WRH_ORDER_DETAIL set
				 wrh_order_master_id = @p_wrh_order_master_id
				,good_category_id = @p_good_category_id
				,amount = @p_amount
				,sys_comment = @p_sys_comment
				,sys_user_modified = @p_sys_user
				where ID = @p_id
   end
  return 

end


go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVREP_CAR_WRH_ITEM_PRICE_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о суммарных затратах на автомобиль
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      01.07.2008 VLavrentiev	Добавил новую процедуру
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
					   and date_created < (a.date_created + 1)
					 order by date_created desc) as c
where a.car_id = @p_car_id
and a.date_created >= @v_day_created
and a.date_created < @v_day_created + 1
and a.is_verified = 1

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


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER PROCEDURE [dbo].[uspVREP_REPAIR_DETAILS_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_car_mark_id		numeric(38,0) = null
,@p_car_kind_id		numeric(38,0) = null
,@p_car_id			numeric(38,0) = null
,@p_organization_id	numeric(38,0) = null
,@p_good_category_id numeric(38,0) = null
,@p_good_category_sname varchar(100) = null
,@p_state_number		varchar(20) = null
,@p_top_n			 numeric(3,0)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();

 if (@p_top_n is null)
  set @p_top_n = 100 

if (@p_top_n = 100)
   
select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
    ,reason
	from
(select a.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , a.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",a.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , d.state_number
	 , e.short_name
     , convert(decimal(18,2), c2.amount) as amount
     , convert(decimal(18,2), c2.price) as price
     , convert(decimal(18,1),(c2.price*c2.amount*0.18) + (c2.price*c2.amount)) as total
     , b2.number as demand_number
     , dbo.usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name (a.id) as reason
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = a.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1
		and b3.is_verified = 1) as sum_demanded
  from dbo.cwrh_wrh_order_master as a
   join dbo.crpr_repair_zone_master as c on a.repair_zone_master_id = c.id
   join dbo.ccar_car as d on a.car_id = d.id
   join dbo.cprt_organization as g on d.organization_id = g.id
   join dbo.ccar_car_kind as h on d.car_kind_id = h.id
   left outer join dbo.cwrh_wrh_demand_master as b2 on a.id = b2.wrh_order_master_id
   left outer join dbo.cwrh_wrh_demand_detail as c2 on b2.id = c2.wrh_demand_master_id
   left outer join dbo.cwrh_good_category as e on c2.good_category_id = e.id
where a.sys_status = 1
  and c.sys_status = 1
  and g.sys_status = 1
  and h.sys_status = 1
  and isnull(b2.sys_status,1) = 1
  and isnull(c2.sys_status,1) = 1
  and isnull(b2.is_verified, 1) = 1
  and d.sys_status = 1
  and isnull(e.sys_status,1) = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
	  and (d.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
	  and (d.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
	  and (a.car_id = @p_car_id or @p_car_id is null)
	  and (d.organization_id = @p_organization_id or @p_organization_id is null)
	  and (c2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	  and (upper(e.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	  and (upper(d.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name


if (@p_top_n = 5)

 select 
	 convert(varchar(10),date_created, 104) + ' ' + convert(varchar(5),date_created, 108) as date_created
	,org_name
	,kind_name
	,number
	,convert(varchar(10),date_started, 104) + ' ' + convert(varchar(5),date_started, 108)  as date_started
	,convert(varchar(10),date_ended, 104) + ' ' + convert(varchar(5),date_ended, 108) as date_ended
	,work_time
	,wait_time
	,state_number
	,short_name
	,amount
	,price
	,total
	,sum_demanded
	,demand_number
	,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
    ,reason
	from
(select 
	   b2.date_created
	 , g.name as org_name
	 , case h.short_name when 'Дежурный' then 'Машины обеспечения'
                	     when 'Эвакуатор' then 'Эвакуаторы' 
			     else h.short_name
	    end as kind_name
	 , b2.number
	 , c.date_started
	 , c.date_ended
	 , isnull(case when convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) < 0 
			then 0
			else convert(decimal(18,2),datediff("MI",c.date_started, c.date_ended)/60) 
			end,0) as work_time
	 , isnull(case when convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) < 0
		then 0
		else convert(decimal(18,2),datediff("MI",b2.date_created, c.date_started)/60) 
	    end,0) as wait_time
	 , a.state_number
	 , e2.short_name
     , convert(decimal(18,2), d2.amount) as amount
     , convert(decimal(18,2), d2.price) as price
     , convert(decimal(18,1),(d2.price*d2.amount*0.18) + (d2.price*d2.amount)) as total
     , c2.number as demand_number
	 , dbo.usfREP_WRH_ORDER_REPAIR_TYPE_MASTER_SelectShort_name (b2.id) as reason
     , (select sum(isnull((price*0.18*amount) + (amount * price),0)) as val
	from dbo.CWRH_WRH_DEMAND_DETAIL as a3
	join dbo.CWRH_WRH_DEMAND_MASTER as b3 on a3.wrh_demand_master_id = b3.id
	where b3.wrh_order_master_id = b2.id
    	and a3.sys_status = 1
    	and b3.sys_status = 1
		and b3.is_verified = 1) as sum_demanded
 from  
(select top(5) 
             a2.id
			,a2.organization_id
			,a2.car_kind_id
			,a2.car_mark_id
			,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
        join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 50
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
  union all
  select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
	      and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 51
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
				,a2.car_mark_id
				,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 52
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1011
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc
   union all
   select top(5) a2.id
			    ,a2.organization_id
			    ,a2.car_kind_id
			    ,a2.car_mark_id
			    ,a2.state_number
	   	from dbo.ccar_car as a2
	   	join dbo.cwrh_wrh_order_master as b2 on a2.id = b2.car_id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
	   	where a2.car_kind_id = 53
		  and a2.organization_id = 1015
		  and a2.sys_status = 1
		  and b2.sys_status = 1
		  and b2.order_state = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
          and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a2.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a2.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a2.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')
		group by a2.id, a2.organization_id, a2.car_kind_id, a2.car_mark_id, a2.state_number
		order by sum((d2.amount*d2.price) + (d2.amount*d2.price*0.18)) desc) as a
        join dbo.cwrh_wrh_order_master as b2 on a.id = b2.car_id
		join dbo.crpr_repair_zone_master as c on b2.repair_zone_master_id = c.id
		join dbo.cprt_organization as g on a.organization_id = g.id
		join dbo.ccar_car_kind as h on a.car_kind_id = h.id
		join dbo.cwrh_wrh_demand_master as c2 on c2.wrh_order_master_id = b2.id
		join dbo.cwrh_wrh_demand_detail as d2 on c2.id = d2.wrh_demand_master_id
		join dbo.cwrh_good_category as e2 on d2.good_category_id = e2.id
		where b2.sys_status = 1
		  and b2.order_state = 1
		  and c.sys_status = 1
		  and g.sys_status = 1
		  and h.sys_status = 1
		  and c2.sys_status = 1
		  and d2.sys_status = 1
		  and e2.sys_status = 1
		  and c2.is_verified = 1
		  and b2.date_created >= @p_start_date
		  and b2.date_created < dateadd("DD", 1, @p_end_date)
          and (a.car_mark_id = @p_car_mark_id or @p_car_mark_id is null)
          and (a.car_kind_id = @p_car_kind_id or @p_car_kind_id is null)
          and (b2.car_id = @p_car_id or @p_car_id is null)
          and (d2.good_category_id = @p_good_category_id or @p_good_category_id is null)
	      and (upper(e2.full_name) like ('%' + upper(@p_good_category_sname) + '%') or @p_good_category_sname is null or @p_good_category_sname = '')
	      and (upper(a.state_number) like ('%' + upper(@p_state_number) + '%') or @p_state_number is null or @p_state_number = '')) as a
order by org_name, kind_name, state_number, sum_demanded desc, number, date_created, demand_number, short_name

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE [dbo].[uspVREP_SUM_ORDER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет о заявках (суммарные значения)
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date		datetime
,@p_end_date		datetime
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate()

select report_type
	  ,header
	  ,organization_id
	  ,organization_sname
	  ,kol
	  ,sum_order
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
 from
(select
	 0 as report_type
	 , 'В целом по автоколонне' as header
	 , 1 as organization_id
	 , 'Всего' as organization_sname	 
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and e.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
union all
select 1 as report_type
	 , 'По организации' as header
	 , d.id as organization_id
	 , d.name as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by d.id, d.name
union all
select 2 as report_type
	 , 'По видам автомобилей' as header
	 , g.id as organization_id
	 , case g.short_name when 'МТО' then 'Технички'
						 when 'Эвакуатор' then 'Эвакуаторы'
						 when 'VIP-трансфер' then 'VIP-трансферы'
						 when 'Дежурный' then 'Машины обеспечения'
		end  as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by g.id, g.short_name
union all
select 3 as report_type
	 , 'По маркам автомобилей' as header
	 , g.id as organization_id
	 , g.short_name as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_mark as g on g.id = e.car_mark_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by g.id, g.short_name
union all
select 4 as report_type
	 , 'По эвакуаторам' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 50
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 5 as report_type
	 , 'по техничкам' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 51
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 6 as report_type
	 , 'По VIP-трансферам' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname		
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 53
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number
union all
select 7 as report_type
	 , 'По машинам обспечения' as header
	 , e.id as organization_id
	 , e.state_number as organization_sname	
	 , count(a.id) as kol
	 , sum(dem.sum_order) as sum_order
from dbo.cwrh_wrh_order_master as a
join dbo.ccar_car as e on a.car_id = e.id
join dbo.cprt_organization as d on d.id = e.organization_id
join dbo.ccar_car_kind as g on g.id = e.car_kind_id
outer apply 
(select isnull(convert(decimal(18,2),sum((c.amount*c.price) + (c.amount*c.price*0.18))), 0) as sum_order
		  from dbo.cwrh_wrh_demand_master as b 
		  join dbo.cwrh_wrh_demand_detail as c on b.id = c.wrh_demand_master_id
		  where b.wrh_order_master_id = a.id
		    and b.sys_status = 1
	        and c.sys_status = 1
			and b.is_verified = 1) as dem
where a.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and g.sys_status = 1
  and g.id = 52
  and a.order_state = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
group by e.id, e.state_number) as a
order by report_type, organization_sname


	RETURN
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_DEMAND_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по суммарным величинам расхода со склада
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id     numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_demand_master as a
		join dbo.cwrh_wrh_demand_detail as b on a.id = b.wrh_demand_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_giver_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1 
  and a.is_verified = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (b.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
 and (c.id = @p_organization_id or @p_organization_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname

return 

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_INCOME_COMMON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать отчет по суммарным величинам прихода на склад
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      24.12.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id     numeric(38,0) = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   
select good_category_sname
	  ,sum(count_l1) as count_l1
	  ,sum(count_l2) as count_l2
	  ,sum(sum_l1) as sum_l1
	  ,sum(sum_l2) as sum_l2
	  ,sum(count_l1 + count_l2) as gd_count
	  ,sum(sum_l1 + sum_l2) as gd_sum
			,convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
		,convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
  from
(select d.full_name as good_category_sname
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum(b.amount)
			else 0 
		end) as count_l1
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum(b.amount)
			else 0 
		end) as count_l2
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG1') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l1 
	 , convert(decimal(18,2),case when c.id = dbo.usfConst('ORG2') then sum((b.amount*b.price) + (b.amount*b.price*0.18))
			else 0 
		end) as sum_l2 
		from dbo.cwrh_wrh_income_master as a
		join dbo.cwrh_wrh_income_detail as b on a.id = b.wrh_income_master_id
		join dbo.CPRT_ORGANIZATION as c on c.id = a.organization_recieve_id
		join dbo.CWRH_GOOD_CATEGORY as d on d.id = b.good_category_id
where a.sys_status = 1
  and b.sys_status = 1
  and c.sys_status = 1
  and d.sys_status = 1
  and a.is_verified = 1
  and a.date_created >= @p_start_date
  and a.date_created < dateadd("DD", 1, @p_end_date)
  and (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (c.id = @p_organization_id or @p_organization_id is null)
 group by c.id, d.full_name) as a
 group by good_category_sname
 order by good_category_sname



	RETURN

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER PROCEDURE [dbo].[uspVREP_WAREHOUSE_ITEM_DAY_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать оборотную ведомость по складам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_start_date			datetime
,@p_end_date			datetime
,@p_warehouse_type_id	numeric(38,0) = null
,@p_organization_id		numeric(38,0) = null
,@p_good_category_sname varchar(100)  = null
)
AS
SET NOCOUNT ON


 if (@p_start_date is null)
  set @p_start_date = dateadd("mm", -1, getdate())
 if (@p_end_date is null)
  set @p_end_date = getdate();
   


with wrh_left (total_start, warehouse_type_id, good_category_id, price, organization_id, amount_start, total_end, amount_end, month_created) as
(select	   isnull(convert(decimal(18,2), sum(a.amount_start)*a.price*0.18 + sum(a.amount_start)*a.price),0) as total_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,a.organization_id
		  ,isnull(convert(decimal(18,2), sum(a.amount_start)),0) as amount_start
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)*a.price*0.18 + sum(a.amount_end)*a.price),0) as total_end  
		  ,isnull(convert(decimal(18,2), sum(a.amount_end)),0) as amount_end
		  , month_created from 
(select sum(a.amount) as amount_start, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
 -- and a.good_category_id = 1011
  and b.date_created < @p_start_date
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount_start, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,null as amount_end                                                                       
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
  and b.date_created < @p_start_date
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select sum(a.amount) as amount_start, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,null as amount_end
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
 -- and a.good_category_id = 1011
  and (b.is_verified = 1 or b.is_verified = 2)
  and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount_start, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,null as amount_end                                                                       
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
  and b.date_created < @p_start_date
 -- and a.good_category_id = 1011
and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select  null as amount_start
	  , b.warehouse_type_id
	  , a.good_category_id
	  , a.price as price
	  , b.organization_recieve_id  as organization_id
	  , sum(a.amount) as amount_end 
	  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
--  and a.good_category_id = 1011
  and (b.is_verified = 1 or b.is_verified = 2)
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select     null as amount_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,-sum(a.amount) as amount_end
		  ,dbo.usfUtils_DayTo01(@p_end_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
 -- and a.good_category_id = 1011
  and  b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
union all
select  null as amount_start
	  , b.warehouse_type_id
	  , a.good_category_id
	  , a.price as price
	  , b.organization_recieve_id  as organization_id
	  , sum(a.amount) as amount_end 
	  , dbo.usfUtils_DayTo01(@p_start_date) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
--  and a.good_category_id = 1011
  and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select     null as amount_start
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id as organization_id 
		  ,-sum(a.amount) as amount_end
		  ,dbo.usfUtils_DayTo01(@p_start_date) as month_created
from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
 -- and a.good_category_id = 1011
and datepart("mm",(@p_start_date)) < datepart("mm",(@p_end_date)) 
  and b.date_created < dbo.usfUtils_DayTo01(@p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price
)
as a
group by a.month_created, a.organization_id,  a.warehouse_type_id, a.good_category_id,a.price)
,income_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as
(
select     isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount
		  ,b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_recieve_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  --and a.good_category_id = 1011
  and (b.is_verified = 1 or b.is_verified = 2)
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
)
,demand_month (total, amount, warehouse_type_id, good_category_id, price, organization_id, month_created) as 
(select 
		   isnull(convert(decimal(18,2), sum(a.amount)*a.price*0.18 + sum(a.amount)*a.price),0) as total
		  ,isnull(sum(a.amount),0) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price as price
		  ,b.organization_giver_id  as organization_id
		  ,dbo.usfUtils_DayTo01(b.date_created) as month_created
			from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and (b.is_verified = 1 or b.is_verified = 2)
  and b.date_created >= @p_start_date
  and b.date_created < dateadd("DD", 1,  @p_end_date)
 -- and a.good_category_id = 1011
group by dbo.usfUtils_DayTo01(b.date_created), b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price)
select-- TOP(100) PERCENT
	  a.warehouse_type_id
	, b.short_name as warehouse_type_sname
	, a.good_category_id
	, c.full_name as good_category_sname
  	, a.month_created
	, a.organization_id
	, d.name as organization_sname
	, convert(decimal(18,2),sum(a.amount_start)) as begin_amount
	, convert(decimal(18,2),sum(a.total_start)) as begin_sum
	, convert(decimal(18,2),isnull((select sum(c.amount)
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as income_amount
, convert(decimal(18,2),isnull( (select sum(c.total) 
				from income_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as income_sum
	, convert(decimal(18,2),isnull((select sum(c.amount)
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as outcome_amount
	, convert(decimal(18,2),isnull( (select sum(c.total) 
				from demand_month as c 
				where  c.good_category_id =  a.good_category_id
					and c.warehouse_type_id = a.warehouse_type_id
					and c.organization_id = a.organization_id
					and c.month_created = a.month_created),0)) as outcome_sum
	, convert(decimal(18,2),sum(a.amount_end)) as end_amount
	, convert(decimal(18,2),sum(a.total_end)) as end_sum 
	, convert(varchar(10),@p_start_date, 104) + ' ' + convert(varchar(5),@p_start_date, 108) as start_date
	, convert(varchar(10),@p_end_date, 104) + ' ' + convert(varchar(5),@p_end_date, 108) as end_date
	, convert(varchar(10),a.month_created, 104) + ' ' + convert(varchar(5),a.month_created, 108) as month_created_str
from wrh_left as a 
join dbo.cwrh_warehouse_type as b on a.warehouse_type_id = b.id
join dbo.cwrh_good_category as c on a.good_category_id = c.id
join dbo.cprt_organization as d on a.organization_id = d.id
where (a.warehouse_type_id = @p_warehouse_type_id or @p_warehouse_type_id is null)
  and (a.organization_id = @p_organization_id or @p_organization_id is null)
  and ((upper(c.full_name) like upper('%' + @p_good_category_sname + '%')) or @p_good_category_sname is null)
  and (@p_start_date < @p_end_date) 
  and (not exists(select 1 where datepart("mm",@p_start_date) != datepart("mm", @p_end_date)))
group by a.month_created, a.organization_id, d.name, a.warehouse_type_id, b.short_name, a.good_category_id 
	, c.full_name
order by a.month_created, d.name,b.short_name,c.full_name


	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER FUNCTION [dbo].[utfVREP_WRH_DEMAND] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения таблицы отчета по требованиям по автомобилям
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      07.05.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
		SELECT   a.id
		    ,a.sys_status
		    ,a.sys_comment
		    ,a.sys_date_modified
		    ,a.sys_date_created
		    ,a.sys_user_modified
		    ,a.sys_user_created
			,a.wrh_demand_master_id
			,a.good_category_id
			,c.full_name as good_category_fname
			,convert(decimal(18,2), a.amount) as amount
		    ,convert(decimal(18,2),a.price) as price
			,a.warehouse_type_id
			,d.short_name as warehouse_type_sname
			,b.car_id
			,e.state_number
			,e.car_type_id
			,e.car_mark_id
			,e.car_model_id
			,b.number
			,b.date_created
			,b.employee_recieve_id
			,ltrim(rtrim(
									h1.lastname + ' ' + substring(h1.name,1,1) + '. '
									+ isnull(substring(h1.surname,1,1),'') + '.')) as employee_recieve_fio
			,b.employee_head_id
			,ltrim(rtrim(
									h2.lastname + ' ' + substring(h2.name,1,1) + '. '
									+ isnull(substring(h2.surname,1,1),'') + '.')) as employee_head_fio
			,b.employee_worker_id
			,ltrim(rtrim(
									h3.lastname + ' ' + substring(h3.name,1,1) + '. '
									+ isnull(substring(h3.surname,1,1),'') + '.')) as employee_worker_fio
			,g1.id as organization_recieve_id
			,g2.id as organization_head_id
			,g3.id as organization_worker_id
			,e.car_kind_id
			,b.wrh_demand_master_type_id
			,b.organization_giver_id
			,f.name as organization_giver_sname
      FROM dbo.CWRH_WRH_DEMAND_DETAIL as a
		join dbo.CWRH_WRH_DEMAND_MASTER as b on a.wrh_demand_master_id = b.id
		join dbo.CWRH_GOOD_CATEGORY as c on a.good_category_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d on a.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as f on b.organization_giver_id = f.id
		left outer join dbo.CCAR_CAR as e on b.car_id = e.id
		left outer join dbo.CPRT_EMPLOYEE as g1 on b.employee_recieve_id = g1.id
		left outer join dbo.CPRT_PERSON as h1 on g1.person_id = h1.id
		left outer join dbo.CPRT_EMPLOYEE as g2 on b.employee_head_id = g2.id
		left outer join dbo.CPRT_PERSON as h2 on g2.person_id = h2.id
		left outer join dbo.CPRT_EMPLOYEE as g3 on b.employee_worker_id = g3.id
		left outer join dbo.CPRT_PERSON as h3 on g3.person_id = h3.id
	  where	(	a.sys_status = 1
			or  a.sys_status = 3)		
		and (	b.sys_status = 1
			or  b.sys_status = 3)	
		and c.sys_status = 1	
		and d.sys_status = 1
		and b.is_verified = 1
		and isnull(e.sys_status, 1) = 1
		and f.sys_status = 1
		and isnull(h1.sys_status, 1) = 1
		and isnull(g1.sys_status, 1) = 1
		and isnull(h2.sys_status, 1) = 1
		and isnull(g2.sys_status, 1) = 1
		and isnull(h3.sys_status, 1) = 1
		and isnull(g3.sys_status, 1) = 1
)

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





ALTER FUNCTION [dbo].[utfVREP_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция для отображения отчета по приходным документам
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
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
		  ,a.number
		  ,a.organization_id
		  ,b.name as organization_name 
		  ,a.warehouse_type_id
		  ,c.short_name as warehouse_type_name
		  ,a.date_created
		  ,a.organization_recieve_id
		  ,d.name as organization_recieve_name
		  ,case when a.account_type = 1
				then e.total 
				else (e.amount*e.price) + (e.amount*e.price*0.18)
			end  as total
		  ,(e.amount*e.price) as summa
		  ,f.full_name as good_category_sname
		  ,e.price
		  ,e.amount
		  ,e.good_category_id
		  ,a.account_type
      FROM dbo.CWRH_WRH_INCOME_MASTER as a
		join dbo.cwrh_WRH_INCOME_DETAIL as e on a.id = e.wrh_income_master_id
		join dbo.CPRT_ORGANIZATION as b on a.organization_id = b.id
		join dbo.CWRH_WAREHOUSE_TYPE as c on a.warehouse_type_id = c.id
		join dbo.CPRT_ORGANIZATION as d on a.organization_recieve_id = d.id
		join dbo.CWRH_GOOD_CATEGORY as f on e.good_category_id = f.id 
	  where (a.sys_status = 1 or a.sys_status = 3)
		and (e.sys_status = 1 or e.sys_status = 3)
		and b.sys_status = 1
		and c.sys_status = 1
		and d.sys_status = 1
		and f.sys_status = 1 
		and a.is_verified = 1
)

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



