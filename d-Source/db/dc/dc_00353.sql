:r ./../_define.sql

:setvar dc_number 00353
:setvar dc_description "driver list number seqs added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    03.08.2008 VLavrentiev  driver list number seqs added
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




CREATE TABLE [dbo].[CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ](
	[number] [numeric](38, 0) NOT NULL,
	[sys_comment] [varchar](10) NULL,
 CONSTRAINT [csys_drv_list_number_org1_car_pk] PRIMARY KEY CLUSTERED 
(
	[number] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]
GO



CREATE TABLE [dbo].[CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ](
	[number] [numeric](38, 0) NOT NULL,
	[sys_comment] [varchar](10) NULL,
 CONSTRAINT [csys_drv_list_number_org1_freight_pk] PRIMARY KEY CLUSTERED 
(
	[number] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]
GO

CREATE TABLE [dbo].[CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ](
	[number] [numeric](38, 0) NOT NULL,
	[sys_comment] [varchar](10) NULL,
 CONSTRAINT [csys_drv_list_number_org2_car_pk] PRIMARY KEY CLUSTERED 
(
	[number] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]
GO



CREATE TABLE [dbo].[CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ](
	[number] [numeric](38, 0)  NOT NULL,
	[sys_comment] [varchar](10) NULL,
 CONSTRAINT [csys_drv_list_number_org2_freight_pk] PRIMARY KEY CLUSTERED 
(
	[number] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]
GO



insert into dbo.csys_const(id, name, description)
values(1001, 'ORG1', 'Организация №1')
go
insert into dbo.csys_const(id, name, description)
values(1004, 'ORG2', 'Организация №2')
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate]
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
   if @p_car_type_id = dbo.usfCONST('CAR') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin	
      if (not exists (select 1 
						from CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ
						where number = 1))	
		insert into CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_DRV_LIST_NUMBER_ORG1_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FREIGHT') and @p_organization_id = dbo.usfCONST('ORG1')	
    begin	
      if (not exists (select 1 
						from CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ
						where number = 1))	
		insert into CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_DRV_LIST_NUMBER_ORG1_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
   if @p_car_type_id = dbo.usfCONST('CAR') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
      if (not exists (select 1 
						from CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ
						where number = 1))	
		insert into CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_DRV_LIST_NUMBER_ORG2_CAR_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
---
 if @p_car_type_id = dbo.usfCONST('FREIGHT') and @p_organization_id = dbo.usfCONST('ORG2')	
    begin	
      if (not exists (select 1 
						from CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ
						where number = 1))	
		insert into CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		values(1, 'seq_gen')
      else
		insert into CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ(number, sys_comment)
		select max(number) + 1 , 'seq_gen'
		from CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	select  @v_number_tmp = max(number)
	from CSYS_DRV_LIST_NUMBER_ORG2_FREIGHT_SEQ

	set @p_number = convert(varchar(4), @v_number_tmp)

	end
   
    
  return  

end
go

GRANT EXECUTE ON [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVDRV_DRIVER_LIST_SEQ_Generate] TO [$(db_app_user)]
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


