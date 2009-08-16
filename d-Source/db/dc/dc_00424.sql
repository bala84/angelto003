:r ./../_define.sql

:setvar dc_number 00424
:setvar dc_description "order detail save fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   23.03.2009 VLavrentiev   order detail save fix
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
-- Если товар без - по количеству, которое надо выдать - запишем его - иначе - это просто товар, который списали по ошибке 
  if ((@p_left_to_demand >= 0) or (@p_left_to_demand is null))
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




