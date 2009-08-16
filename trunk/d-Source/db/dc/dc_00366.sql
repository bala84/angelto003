:r ./../_define.sql

:setvar dc_number 00366
:setvar dc_description "driver list seq gen fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    21.08.2008 VLavrentiev  driver list seq gen fixed
*******************************************************************************/ 
use [$(db_name)]
GO

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

ALTER procedure [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить устройство
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_car_type_id      numeric(38,0)
    ,@p_organization_id	 numeric(38,0)
	,@p_number			 varchar(20)   = null out
    ,@p_sys_comment		 varchar(2000) = '-'
)
as
begin
  set nocount on
  declare
     @v_number_tmp numeric(38,0)

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'


---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ	

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ	


      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
   if @p_car_type_id = dbo.usfCONST('FORM_3') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FORM_4P') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin
	  if (day(getdate()) = 1) and not exists(select 1 from dbo.CDRV_DRIVER_LIST
													 where date_created >= dbo.usfUtils_DayTo01(getdate()))
	  delete from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ	
	
      if (not exists (select 1 
						from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ
						where number = 1))	
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from dbo.CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end

 if (@p_number is null)
  begin
	insert into dbo.CSYS_DRIVER_LIST_NUMBER_SEQ (sys_comment)
	values ('-')
    set @p_number = scope_identity()
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


