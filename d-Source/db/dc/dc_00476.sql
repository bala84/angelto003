
:r ./../_define.sql

:setvar dc_number 00476
:setvar dc_description "income-outcome outdate fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   06.07.2009 VLavrentiev   income-outcome outdate fix
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






ALTER procedure [dbo].[uspVWRH_WRH_INCOME_MASTER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ��������� �������� �� ������
**
**  ������� ���������: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2008 VLavrentiev	������� ����� ���������
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
	,@p_is_verified			varchar(30) = '�� ��������'
	,@p_account_type		varchar(50) = '���� ��� ���'
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

  declare
    @v_is_verified smallint
   ,@v_account_type smallint

  -- ���� ������ �������� ���� �� � ����� ����������, ������ ������ � ������������� ���������
  if (exists
	(select top(1) 1 from dbo.cwrh_wrh_demand_detail as a
		  where exists
			(select 1 from 
						dbo.cwrh_wrh_income_detail as b
				where a.wrh_income_detail_id = b.id
				  and b.wrh_income_master_id = @p_id)
	 order by a.id asc))
	begin
         RAISERROR ('������ �������� ��������� ��������, ���� �� ������������ ���� �� � ����� ����������.', 16, 1)
	end



     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_is_verified is null)
	set @p_is_verified = '�� ��������'

	 if (@p_account_type is null)
	set @p_account_type = '���� ��� ���'


	if (@p_is_verified = '�� ��������')
	 set @v_is_verified = 0
	if (@p_is_verified = '��������')
	 set @v_is_verified = 1
	if (@p_is_verified = '�������������')
	 set @v_is_verified = 2



	if (@p_account_type = '���� ��� ���')
	 set @v_account_type = 0
	if (@p_account_type = '����� � ���')
	 set @v_account_type = 1

   

       -- ���� ���������
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
  -- ���� ������� ������������
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








ALTER PROCEDURE [dbo].[uspVWRH_WRH_INCOME_SelectByGood_category_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ��������� ������ ��������� ������ � ������� ��������� ���������� �� ������
**
**  ������� ���������:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.10.2008 VLavrentiev	������� ����� ���������
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
  
  -- ����������� ������ ������
  exec @v_Srch_Str = dbo.usfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type
--���� ��� ������ - �� ��������� ����. ����������
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
		  ,case when a.is_verified = 0  then '�� ��������'
		        else '��������'
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
	and		a.is_verified = 1
	 -- and a.date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		   and ((rtrim(ltrim(upper(a.number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
				or (rtrim(ltrim(upper(a.warehouse_type_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by date_created asc


-- ���� ��� ������ �� �������� ���������� ���������
if (@p_mode = 2)
  
       SELECT  top(20)
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
		  ,case when a.is_verified = 0  then '�� ��������'
		        else '��������'
			end as is_verified
	FROM dbo.utfVWRH_WRH_INCOME_SelectByGood_category_id(@p_good_category_id) as a
	where  a.warehouse_type_id = @p_warehouse_type_id
	and		a.organization_recieve_id = @p_organization_id
	and		a.income_detail_actual_version = 0
	and		a.is_verified = 1
	 -- and a.date_created between @p_start_date and @p_end_date
	  and (((@p_Str != '')
		   and ((rtrim(ltrim(upper(a.number))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
				or (rtrim(ltrim(upper(a.warehouse_type_sname))) like rtrim(ltrim(upper('%' + @p_Str + '%')))))
		or (@p_Str = ''))
	order by a.date_created asc


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




