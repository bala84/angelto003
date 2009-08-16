
:r ./../_define.sql

:setvar dc_number 00454
:setvar dc_description "income by demand fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   17.04.2009 VLavrentiev   income by demand fix
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







ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_SelectByGood_category_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о деталях приходных документов по товару
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_good_category_id     numeric(38,0)
,@p_organization_id      numeric(38,0)
,@p_start_date		     datetime
,@p_end_date		     datetime
,@p_wrh_income_detail_id numeric(38,0) = null
,@p_Str varchar(100) = null
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
,@p_mode			 smallint = 1
,@p_amount_to_give   decimal(18,9) = null
,@p_warehouse_type_id numeric(38,0) = null
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
--Если тип вывода - по имеющимся прих. документам
if (@p_mode = 1)
  
       SELECT  top(1)
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_income_master_id
		  ,a.warehouse_type_id
		  ,a.warehouse_type_sname
		  ,a.date_created
		  ,a.number
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,convert(decimal(18,2), a.total) as total
		  ,convert(decimal(18,2), a.price) as price
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.full_string
		  ,a.organization_recieve_id	
		  ,a.organization_recieve_sname
		  ,convert(decimal(18,2), a.amount_gived) as amount_gived
		  ,case when a.is_verified = 0  then 'Не проверен'
		        else 'Проверен'
			end as is_verified
	FROM dbo.utfVWRH_WRH_INCOME_SelectByGood_category_id(@p_good_category_id) as a
	where a.amount > a.amount_gived
      and (a.amount - a.amount_gived) >= @p_amount_to_give
      and a.warehouse_type_id = @p_warehouse_type_id
/*exists 
		(select 1
			from dbo.CWRH_WAREHOUSE_ITEM as b
			where b.warehouse_type_id = a.warehouse_type_id
			  and b.good_category_id = a.good_category_id
			  and b.organization_id = a.organization_recieve_id
			  having sum(b.amount) > 0) 
	  and */
	and		a.organization_recieve_id = @p_organization_id
	and		a.income_detail_actual_version = 0
	 -- and a.date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		   and ((rtrim(ltrim(upper(a.number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
				or (rtrim(ltrim(upper(a.warehouse_type_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by date_created asc


-- Если тип вывода по текущему приходному документу
if (@p_mode = 2)
  
       SELECT  
		   a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.wrh_income_master_id
		  ,a.warehouse_type_id
		  ,a.warehouse_type_sname
		  ,a.date_created
		  ,a.number
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,convert(decimal(18,2), a.total) as total
		  ,convert(decimal(18,2), a.price) as price
		  ,a.good_mark
		  ,a.good_category_sname
		  ,a.unit
		  ,a.full_string
		  ,a.organization_recieve_id	
		  ,a.organization_recieve_sname
		  ,convert(decimal(18,2), a.amount_gived) as amount_gived
		  ,case when a.is_verified = 0  then 'Не проверен'
		        else 'Проверен'
			end as is_verified
	FROM dbo.utfVWRH_WRH_INCOME_SelectByGood_category_id(@p_good_category_id) as a
	where a.id = @p_wrh_income_detail_id


	RETURN
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go






ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_SelectByGood_category_id] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения деталей приходных документов по товару
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_good_category_id numeric(38,0)
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
		  ,a.wrh_income_master_id
		  ,c.organization_recieve_id
		  ,e.name as organization_recieve_sname
		  ,c.date_created
		  ,c.number
		  ,c.warehouse_type_id
		  ,d.short_name as warehouse_type_sname
		  ,a.good_category_id
		  ,a.good_category_price_id
		  ,convert(decimal(18,2), a.amount) as amount
		  ,a.total
		  ,convert(decimal(18,2),a.price) as price
		  ,b.good_mark
		  ,b.short_name as good_category_sname
		  ,b.unit
		  ,convert(varchar(60), convert(decimal(18,2), a.price)) + 'р.' + ' - ' + 'Дата создания: ' + convert(varchar(20), c.date_created, 103) + ' - Номер: ' + convert(varchar(60),c.number) as full_string
		  ,isnull(a2.amount_gived, 0) as amount_gived
		  ,c.is_verified
		  ,a.actual_version as income_detail_actual_version
		  ,c.account_type
      FROM dbo.CWRH_WRH_INCOME_DETAIL as a
		JOIN dbo.CWRH_GOOD_CATEGORY as b
			on a.good_category_id = b.id
		join dbo.CWRH_WRH_INCOME_MASTER as c
			on a.wrh_income_master_id = c.id
		join dbo.CWRH_WAREHOUSE_TYPE as d
			on c.warehouse_type_id = d.id
		join dbo.CPRT_ORGANIZATION as e
			on c.organization_recieve_id = e.id
		outer apply
			(select sum(a2.amount) as amount_gived
				from dbo.cwrh_wrh_demand_detail as a2
				join dbo.cwrh_wrh_demand_master as b2 on a2.wrh_demand_master_id = b2.id
			  where --a2.good_category_id = a.good_category_id
				--and b2.organization_giver_id = c.organization_recieve_id
				--and a2.warehouse_type_id = c.warehouse_type_id
			  --  and a2.price = a.price
			   -- and 
					a.id = a2.wrh_income_detail_id
			) as a2 
	  where b.id = @p_good_category_id
		and isnull(a2.amount_gived, 0) >= 0
        and c.is_verified != 2
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



