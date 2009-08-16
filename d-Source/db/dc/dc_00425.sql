:r ./../_define.sql

:setvar dc_number 00425
:setvar dc_description "income master new fields added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   26.03.2009 VLavrentiev   income master new fields added
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


alter table dbo.cwrh_wrh_income_detail
add actual_version int default 0
go

alter table dbo.cwrh_wrh_income_master
add account_type smallint default 0
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Архив версии или нет' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cwrh_wrh_income_detail', @level2type=N'COLUMN', @level2name=N'actual_version'

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип подсчета прих. документа' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cwrh_wrh_income_master', @level2type=N'COLUMN', @level2name=N'account_type'

GO


create index i_cwrh_wrh_incomer_detail_actual_version on dbo.cwrh_wrh_income_detail(actual_version)
on $(fg_idx_name)
go


create index i_cwrh_wrh_incomer_master_account_type on dbo.cwrh_wrh_income_master(account_type)
on $(fg_idx_name)
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
)
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



ALTER FUNCTION [dbo].[utfVWRH_WRH_INCOME_MASTER] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения приходных документов
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
		  ,a.total
		  ,a.summa
		  ,a.is_verified
		  ,a.account_type
      FROM dbo.CWRH_WRH_INCOME_MASTER as a
		join dbo.CPRT_ORGANIZATION as b on a.organization_id = b.id
		join dbo.CWRH_WAREHOUSE_TYPE as c on a.warehouse_type_id = c.id
		join dbo.CPRT_ORGANIZATION as d on a.organization_recieve_id = d.id 
)
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
				else 'Проверен'
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
    @v_is_verified bit
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
	else
	 set @v_is_verified = 1


	if (@p_is_verified = 'Цена без НДС')
	 set @v_account_type = 0
	if (@p_is_verified = 'Сумма с НДС')
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql




