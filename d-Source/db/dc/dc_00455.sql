
:r ./../_define.sql

:setvar dc_number 00455
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create FUNCTION [dbo].[utfVWRH_WAREHOUSE_ITEM_By_date] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения содержимого склада
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
  @p_good_category_type_id numeric(38,0)
 ,@p_warehouse_type_id	   numeric(38,0)
 ,@p_organization_id	   numeric(38,0)	
 ,@p_date				   datetime
)
RETURNS TABLE 
AS
RETURN 
(
select 
		   b2.id
		  ,b2.sys_status
		  ,b2.sys_comment
		  ,b2.sys_date_modified
		  ,b2.sys_date_created
		  ,b2.sys_user_modified
		  ,b2.sys_user_created
		  ,b2.short_name as good_category_sname
		  ,b2.full_name as good_category_fname
		  ,b2.unit
		  ,b2.good_category_type_id
		  ,d2.short_name as good_category_type_sname
		  ,c2.short_name as warehouse_type_sname
		  ,b2.good_mark
		  ,a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.organization_id
		  ,e2.name as organization_sname
from 
(select sum(a.amount) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,a.organization_id  from 
(select sum(a.amount) as amount, b.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,b.organization_recieve_id  as organization_id 
			from dbo.cwrh_wrh_income_detail as a
					join dbo.cwrh_wrh_income_master as b on a.wrh_income_master_id = b.id
where b.sys_status = 1
  and b.date_created <= @p_date
group by b.organization_recieve_id,  b.warehouse_type_id, a.good_category_id,a.price
union all
select  -sum(a.amount) as amount, a.warehouse_type_id
		  ,a.good_category_id
		  ,a.price
		  ,b.organization_giver_id as organization_id from dbo.cwrh_wrh_demand_detail as a
					join dbo.cwrh_wrh_demand_master as b on a.wrh_demand_master_id = b.id
where b.sys_status = 1
  and b.date_created <= @p_date
group by b.organization_giver_id,  a.warehouse_type_id, a.good_category_id,a.price)
as a
group by a.organization_id,  a.warehouse_type_id, a.good_category_id,a.price) as a
	   join dbo.CWRH_GOOD_CATEGORY as b2
			on a.good_category_id = b2.id
	   join dbo.CWRH_WAREHOUSE_TYPE as c2
			on a.warehouse_type_id = c2.id
	   left outer join dbo.CWRH_GOOD_CATEGORY_TYPE as d2
			on b2.good_category_type_id = d2.id
	   left outer join dbo.CPRT_ORGANIZATION as e2
			on a.organization_id = e2.id
WHERE  (a.warehouse_type_id = @p_warehouse_type_id
		or @p_warehouse_type_id is null)
	   AND (b2.good_category_type_id = @p_good_category_type_id
			or @p_good_category_type_id is null)
	   AND (a.organization_id = @p_organization_id
			or @p_organization_id is null)	
)
go


GRANT VIEW DEFINITION ON [dbo].[utfVWRH_WAREHOUSE_ITEM_By_date] TO [$(db_app_user)]
GO






create FUNCTION [dbo].[usfWRH_ITEM_SelectBy_date_gd_id](@p_date datetime
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
select warehouse_type_sname + ' - ' + organization_sname + ': ' + convert(varchar(10), sum(amount))
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


GRANT VIEW DEFINITION ON [dbo].[usfWRH_ITEM_SelectBy_date_gd_id] TO [$(db_app_user)]
GO


create FUNCTION [dbo].[usfWRH_DEMAND_SelectBy_date_gd_id](@p_wrh_order_master_id numeric(38,0), @p_good_category_id numeric(38,0))
RETURNS varchar(2000)
AS
BEGIN

declare
    @v_stmt varchar(2000) 
   ,@v_tmp_stmt varchar(100)
   ,@i int

declare
shrt_name_cur cursor for
select c.short_name + ' - ' + b.name + ': ' + convert(varchar(10), sum(amount))
		from dbo.cwrh_wrh_demand_master as a
		join dbo.cprt_organization as b
		  on a.organization_giver_id = b.id
		join dbo.cwrh_wrh_demand_detail as d
		  on a.id = d.wrh_demand_master_id
		join dbo.cwrh_warehouse_type as c
		  on d.warehouse_type_id = c.id
where d.good_category_id = @p_good_category_id
  and a.wrh_order_master_id = @p_wrh_order_master_id
group by c.short_name, b.name
order by c.short_name, b.name


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


GRANT VIEW DEFINITION ON [dbo].[usfWRH_DEMAND_SelectBy_date_gd_id] TO [$(db_app_user)]
GO





set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[uspVWRH_WRH_ORDER_DETAIL_SelectByMaster_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях заказов-нарядов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_wrh_order_master_id numeric(38,0)
)
AS
SET NOCOUNT ON

declare @v_date datetime

select top(1) @v_date = date_created
  from dbo.cwrh_wrh_demand_master
where wrh_order_master_id = @p_wrh_order_master_id
  order by date_created desc
--Если дата нулл - попробуем найти
if (@v_date is null)
select @v_date = b.date_started
from dbo.cwrh_wrh_order_master as a
 join dbo.CRPR_REPAIR_ZONE_MASTER as b
   on a.repair_zone_master_id = b.id
where a.id = @p_wrh_order_master_id
--Если опять нулл
set @v_date = getdate()
	    
  
       SELECT  a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_order_master_id
		  ,a.good_category_id
		  ,a.amount
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.left_to_demand
		  ,dbo.usfWRH_ITEM_SelectBy_date_gd_id(@v_date, a.good_category_id)  
			as left_in_warehouse
		  ,dbo.usfWRH_DEMAND_SelectBy_date_gd_id(@p_wrh_order_master_id, a.good_category_id)  
			as demanded
	FROM dbo.utfVWRH_WRH_ORDER_DETAIL(@p_wrh_order_master_id) as a

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



