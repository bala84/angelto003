
:r ./../_define.sql

:setvar dc_number 00457
:setvar dc_description "warehouse order detail fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.04.2009 VLavrentiev   warehouse order detail fix
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




ALTER FUNCTION [dbo].[usfWRH_DEMAND_SelectBy_date_gd_id](@p_wrh_order_master_id numeric(38,0), @p_good_category_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select isnull(c.short_name, 'не указан склад') + ' - ' + b.name + ' - ' + convert(varchar(100), a.number) + ': ' + convert(varchar(10), convert(decimal(18,2), sum(amount)))
		from dbo.cwrh_wrh_demand_master as a
		join dbo.cprt_organization as b
		  on a.organization_giver_id = b.id
		join dbo.cwrh_wrh_demand_detail as d
		  on a.id = d.wrh_demand_master_id
		join dbo.cwrh_warehouse_type as c
		  on d.warehouse_type_id = c.id
where d.good_category_id = @p_good_category_id
  and a.wrh_order_master_id = @p_wrh_order_master_id
group by c.short_name, b.name, a.number
order by c.short_name, b.name, a.number


begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt


set @i = 1
set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
      set @v_stmt = @v_tmp_stmt
	else
	  set @v_stmt = @v_stmt + CHAR(13) + @v_tmp_stmt


fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END

go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/****** Object:  UserDefinedFunction [dbo].[utfVWRH_WAREHOUSE_ITEM]    Script Date: 04/17/2009 13:56:26 ******/

ALTER FUNCTION [dbo].[usfWRH_ITEM_SelectBy_date_gd_id](@p_date datetime
																			,@p_good_category_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select warehouse_type_sname + ' - ' + organization_sname + ': ' + convert(varchar(10), convert(decimal(18,2), sum(amount)))
		from dbo.utfVWRH_WAREHOUSE_ITEM_By_date (null
									,null
									,null
									,@p_date)
where good_category_id = @p_good_category_id
group by warehouse_type_sname, organization_sname
order by organization_sname, warehouse_type_sname


begin
open shrt_name_cur

fetch next from shrt_name_cur
into @v_tmp_stmt


set @i = 1
set @v_stmt = ''

while @@fetch_status = 0
begin

    if (@v_stmt = '')
      set @v_stmt = @v_tmp_stmt
	else
	  set @v_stmt = @v_stmt + CHAR(13) + @v_tmp_stmt


fetch next from shrt_name_cur
into @v_tmp_stmt
set @i = @i + 1
end

CLOSE shrt_name_cur
DEALLOCATE shrt_name_cur

end

 return @v_stmt

END

go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVWRH_WRH_DEMAND_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую функцию
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
		  ,d.organization_id as car_organization_id
		  ,h2.name as car_organization_name
		  ,f.short_name as car_mark_sname
		  ,g.short_name as car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. '+ substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
		  ,a.date_created
		  ,a.wrh_demand_master_type_id
		  ,e.short_name as wrh_demand_master_type_sname	
		  ,a.organization_giver_id
		  ,h.name as organization_giver_sname
		  ,a.wrh_order_master_id
		  ,j.number as wrh_order_master_number	
		  ,a.is_verified	
      FROM dbo.CWRH_WRH_DEMAND_MASTER as a
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
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CWRH_WRH_DEMAND_MASTER_TYPE as e
			on a.wrh_demand_master_type_id = e.id
		left outer join dbo.CPRT_ORGANIZATION as h
			on a.organization_giver_id = h.id
		left outer join dbo.CWRH_WRH_ORDER_MASTER as j
		   on a.wrh_order_master_id = j.id
		left outer join dbo.CPRT_ORGANIZATION as h2
			on d.organization_id = h2.id
	--  WHERE a.date_created between @p_start_date
	--						   and @p_end_date
		
		
)
go



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[utfVWRH_WRH_DEMAND_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения требований
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2008 VLavrentiev	Добавил новую функцию
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
		  ,d.organization_id as car_organization_id
		  ,h2.name as car_organization_name
		  ,f.short_name as car_mark_sname
		  ,g.short_name as car_model_sname
		  ,a.number
		  ,a.employee_recieve_id
		  ,c.lastname + ' ' + substring(c.name, 1, 1) + '. '+ substring(c.surname, 1, 1) + '.' as FIO_employee_recieve
		  ,a.employee_head_id
		  ,c2.lastname + ' ' + substring(c2.name, 1, 1) + '. ' + substring(c2.surname, 1, 1) + '.' as FIO_employee_head 
		  ,a.employee_worker_id
		  ,c3.lastname + ' ' + substring(c3.name, 1, 1) + '. ' + substring(c3.surname, 1, 1) + '.' as FIO_employee_worker
		  ,a.date_created
		  ,a.wrh_demand_master_type_id
		  ,e.short_name as wrh_demand_master_type_sname	
		  ,a.organization_giver_id
		  ,h.name as organization_giver_sname
		  ,a.wrh_order_master_id
		  ,j.number as wrh_order_master_number	
		  ,a.is_verified	
      FROM dbo.CWRH_WRH_DEMAND_MASTER as a
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
		left outer join dbo.CCAR_CAR_MARK as f
			on d.car_mark_id = f.id
		left outer join dbo.CCAR_CAR_MODEL as g
			on d.car_model_id = g.id
		left outer join dbo.CWRH_WRH_DEMAND_MASTER_TYPE as e
			on a.wrh_demand_master_type_id = e.id
		left outer join dbo.CPRT_ORGANIZATION as h
			on a.organization_giver_id = h.id
		left outer join dbo.CWRH_WRH_ORDER_MASTER as j
		   on a.wrh_order_master_id = j.id
		left outer join dbo.CPRT_ORGANIZATION as h2
			on d.organization_id = h2.id
	--  WHERE a.date_created between @p_start_date
	--						   and @p_end_date
		
		
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



