:r ./../_define.sql

:setvar dc_number 00283
:setvar dc_description "new demand types added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    03.06.2008 VLavrentiev  new demand types added
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


set identity_insert dbo.CWRH_WRH_DEMAND_MASTER_TYPE on
insert into dbo.CWRH_WRH_DEMAND_MASTER_TYPE (id ,short_name, full_name)
values (403, 'Расход','Расход')
insert into dbo.CWRH_WRH_DEMAND_MASTER_TYPE (id ,short_name, full_name)
values (404, 'Моторный цех','Моторный цех') 
set identity_insert dbo.CWRH_WRH_DEMAND_MASTER_TYPE off
go


insert into dbo.CSYS_CONST (id, name, description)
values (401, 'DEMAND_TYPE_CAR', 'Тип требования по машине')
insert into dbo.CSYS_CONST (id, name, description)
values (402, 'DEMAND_TYPE_WORKER', 'Тип требования по механикам')
insert into dbo.CSYS_CONST (id, name, description)
values (403, 'DEMAND_TYPE_EXPENSE', 'Тип требования расход')
insert into dbo.CSYS_CONST (id, name, description)
values (404, 'DEMAND_TYPE_MOTOR', 'Тип требования по моторному цеху')
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
		  ,warehouse_type_id
		  ,amount
		  ,good_category_id
		  ,good_mark
		  ,good_category_sname
		  ,good_category_fname
		  ,unit
		  ,good_category_type_id
		  ,good_category_type_sname
		  ,warehouse_type_sname
		  ,price
		  ,null as edit_state
	FROM dbo.utfVWRH_WAREHOUSE_ITEM( @p_good_category_type_id
									,@p_warehouse_type_id) as a
    WHERE (((@p_Str != '') 
			AND EXISTS
		 (select 1 FROM CONTAINSTABLE (dbo.CWRH_GOOD_CATEGORY, (short_name), 
							 @v_Srch_Str
							,@p_Top_n_by_rank
					    ) AS KEY_TBL 
			WHERE a.good_category_id = KEY_TBL.[KEY]))
		or (@p_Str = ''))

	RETURN
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


