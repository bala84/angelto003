
:r ./../_define.sql

:setvar dc_number 00464
:setvar dc_description "wrh left fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   13.05.2009 VLavrentiev   wrh left fix
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


ALTER PROCEDURE [dbo].[uspVWRH_WAREHOUSE_ITEM_SelectByType_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о содержимом склада
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      10.04.2008 VLavrentiev	Добавил новую процедуру
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

 if (@p_Str is null)
    set @p_Str = ''
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
  -- Мы должны уметь группировать организации в товаре и выводить общую сумму
  -- поэтому выводим с функциями
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
		 --для режима редактирования выведем edit_state (нужно ли запоминать в бд?)
		  ,null as edit_state
		  ,max(organization_id) as organization_id
		  ,case when @p_organization_id is null  then 'Все организации'
				else max(organization_sname)
		    end as organization_sname
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id
									,@p_organization_id) as a
    WHERE 
--поиск
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
	having sum(amount) <> 0 


	RETURN
go

insert into dbo.csys_const (id, name, description)
values('411', 'Дополнительное ТО', 'Ид категории ремонта')
go

insert into dbo.csys_const (id, name, description)
values('412', 'Осн. рем. работы в ремзоне', 'Ид категории ремонта')
go

insert into dbo.csys_const (id, name, description)
values('413', 'Доп. рем. работы вне ремзоны', 'Ид категории ремонта')
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


create PROCEDURE [dbo].[uspVREP_Count_repairs_by_head_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет по количеству ремонтов, обработанных бригадирами
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_start_date			datetime
 ,@p_end_date			datetime
)
AS
BEGIN

if (@p_start_date is null)
 set @p_start_date = dbo.usfUtils_MonthTo01(getdate())

if (@p_end_date is null)
 set @p_end_date = dateadd("Month", 1, dbo.usfUtils_MonthTo01(getdate()))

 set @p_start_date = dbo.usfUtils_TimeToZero(@p_start_date)

 set @p_end_date = dbo.usfUtils_TimeToZero(@p_end_date)

select
	 fio
	,short_name
	,count(*)
from
(select a.employee_head_id
	  ,rtrim(rtrim(ltrim(c.lastname)) + ' ' + isnull(substring(rtrim(ltrim(c.name)),1,1),'') + '. ' + isnull(substring(rtrim(ltrim(c.surname)),1,1),'') + '.') as fio
	  ,case when (f.id = dbo.usfConst('Дополнительное ТО')) 
			  or (f.id = dbo.usfConst('Осн. рем. работы в ремзоне'))
			  or (f.id = dbo.usfConst('Доп. рем. работы вне ремзоны'))
			then e.short_name
			else f.short_name
		end as short_name
from dbo.cwrh_wrh_order_master as a
join dbo.cprt_employee as b
	on a.employee_head_id = b.id
join dbo.cprt_person as c
    on c.id = b.person_id
join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as d
	on a.id = d.wrh_order_master_id
join dbo.CRPR_REPAIR_TYPE_MASTER as e
	on d.repair_type_master_id = e.id
join dbo.CRPR_REPAIR_TYPE_MASTER_KIND as f
	on e.repair_type_master_kind_id = f.id
where a.order_state in (1,4)
 and a.date_created >= @p_start_date
 and a.date_created < @p_end_date) as a
group by 
     employee_head_id 
	,fio
	,short_name
order by fio
	,short_name

end

go


GRANT EXECUTE ON [dbo].[uspVREP_Count_repairs_by_head_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_Count_repairs_by_head_id] TO [$(db_app_user)]
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



