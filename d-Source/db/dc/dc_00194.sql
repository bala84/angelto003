:r ./../_define.sql

:setvar dc_number 00194
:setvar dc_description "orders fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    14.04.2008 VLavrentiev  orders fixed
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

alter table dbo.CWRH_WRH_ORDER_MASTER
alter column car_id numeric(38,0)
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVWRH_WRH_ORDER_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения заказов-нарядов
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_start_date datetime
,@p_end_date   datetime
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
		  ,a.car_id
		  ,d.state_number
		  ,f.short_name as car_mark_sname
		  ,g.short_name as car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. ' + substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
		  ,a.date_created
		  ,a.repair_type_id
		  ,h.short_name as repair_type_sname
		  ,a.malfunction_desc
		  ,e.run
		  ,case order_state when 0 
							then 'Открыт'
							when 1
							then 'Закрыт'
		   end as order_state 			
      FROM dbo.CWRH_WRH_ORDER_MASTER as a
		join dbo.CPRT_EMPLOYEE as b
			on a.employee_recieve_id = b.id
		join dbo.CPRT_PERSON as c
			on b.person_id = c.id
		join dbo.CPRT_EMPLOYEE as b2
			on a.employee_head_id = b2.id
		join dbo.CPRT_PERSON as c2
			on b2.person_id = c2.id
		join dbo.CPRT_EMPLOYEE as b3
			on a.employee_worker_id = b3.id
		join dbo.CPRT_PERSON as c3
			on b3.person_id = c3.id
		left outer join dbo.CCAR_CAR as d
			on a.car_id = d.id
		left outer join dbo.CCAR_CONDITION as e
			on a.car_id = e.car_id
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CRPR_REPAIR_TYPE_MASTER as h
			on a.repair_type_id = h.id
	  WHERE a.date_created between @p_start_date
							   and @p_end_date
		
		
)
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_SaveById]
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
    ,@p_number				varchar(20)
	,@p_car_id				numeric(38,0) = null
	,@p_employee_recieve_id numeric(38,0)
	,@p_employee_head_id	numeric(38,0)
	,@p_employee_worker_id  numeric(38,0)
	,@p_date_created		datetime
	,@p_order_state			varchar(20)
	,@p_repair_type_id		numeric(38,0) = null
	,@p_malfunction_desc	varchar(4000)
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin
  set nocount on
	declare
		@v_order_state smallint

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @v_order_state = case @p_order_state when 'Открыт'
											 then 0
											 when 'Закрыт'
											 then 1
						 end

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CWRH_WRH_ORDER_MASTER
            ( car_id, number, date_created
			, employee_recieve_id, employee_head_id
			, employee_worker_id, order_state, repair_type_id, malfunction_desc
			, sys_comment, sys_user_created, sys_user_modified)
	   values
			( @p_car_id, @p_number, @p_date_created
			, @p_employee_recieve_id, @p_employee_head_id
			, @p_employee_worker_id, @v_order_state, @p_repair_type_id, @p_malfunction_desc
			, @p_sys_comment, @p_sys_user, @p_sys_user)
       
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
		,order_state = @v_order_state
		,repair_type_id = @p_repair_type_id
		,malfunction_desc = @p_malfunction_desc
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

ALTER procedure [dbo].[uspVWRH_WRH_ORDER_MASTER_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из заказов-нарядов
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) 
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

   delete
	from dbo.CWRH_WRH_ORDER_DETAIL
	where wrh_order_master_id = @p_id 

	delete
	from dbo.cwrh_wrh_order_master
	where id = @p_id

	if (@@tranCount > @v_TrancountOnEntry)
        commit
    
  return 

end
GO


alter table dbo.CWRH_WRH_ORDER_MASTER
drop constraint CWRH_WRH_ORDER_M_CAR_ID_FK
go

ALTER TABLE dbo.CWRH_WRH_ORDER_MASTER 
ADD  CONSTRAINT CWRH_WRH_ORDER_M_CAR_ID_FK FOREIGN KEY(car_id)
REFERENCES dbo.CCAR_CAR (id)
go



alter table dbo.CWRH_WRH_ORDER_MASTER
drop constraint CWRH_WRH_ORDER_M_REP_TYPE_ID_FK
go

ALTER TABLE dbo.CWRH_WRH_ORDER_MASTER 
ADD  CONSTRAINT CWRH_WRH_ORDER_M_REP_TYPE_ID_FK FOREIGN KEY(repair_type_id)
REFERENCES dbo.CRPR_REPAIR_TYPE_MASTER (id)
go



create unique index u_number_wrh_order_m
on dbo.CWRH_WRH_ORDER_MASTER(number)
on $(fg_idx_name)
go


create unique index u_wrh_order_master_gd_ctgry_id_wrh_inc_d
on dbo.CWRH_WRH_ORDER_DETAIL(wrh_order_master_id, good_category_id)
on $(fg_idx_name)
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

