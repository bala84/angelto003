:r ./../_define.sql

:setvar dc_number 00340
:setvar dc_description "rep emp hour mech added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    04.07.2008 VLavrentiev  rep emp hour mech added
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


drop table dbo.CREP_REPAIR_BY_CAR_DAY
go 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CREP_REPAIR_BY_CAR_DAY](
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[date_created] [datetime] NOT NULL,
	[car_id] [numeric](38, 0) NOT NULL,
	[state_number] [varchar](20) NOT NULL,
	[car_type_id] [numeric](38, 0) NOT NULL,
	[car_type_sname] [varchar](30) NOT NULL,
	[car_state_id] [numeric](38, 0) NULL,
	[car_state_sname] [varchar](30) NULL,
	[car_mark_id] [numeric](38, 0) NOT NULL,
	[car_mark_sname] [varchar](30) NOT NULL,
	[car_model_id] [numeric](38, 0) NOT NULL,
	[car_model_sname] [varchar](30) NOT NULL,
	[car_kind_id] [numeric](38, 0) NOT NULL,
	[car_kind_sname] [varchar](30) NOT NULL,
	[short_name] [varchar](30) NOT NULL,
	[repair_type_master_id] [numeric](38, 0) NOT NULL,
	[organization_id] [numeric](38, 0) NOT NULL,
	[organization_sname] [varchar](30) NOT NULL,
	[amt] [smallint] NOT NULL,
 CONSTRAINT [CREP_REPAIR_BY_CAR_DAY_pk] PRIMARY KEY CLUSTERED 
(
	[car_id] ASC,
	[repair_type_master_id] ASC,
	[date_created] ASC
) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Гос номер' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'state_number'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид типа автомобия' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_type_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название типа автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_type_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_state_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название состояния автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_state_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название марки автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_mark_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид модели автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_model_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Модель автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_model_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название вида автомобиля' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'car_kind_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'short_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида ремонта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'repair_type_master_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'organization_id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'organization_sname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество видов ремонтов по автомобилям' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY', @level2type=N'COLUMN',@level2name=N'amt'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица количества ремонтов по автомобилям' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_REPAIR_BY_CAR_DAY'
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить отчет о видах ремонтов по автомобилям
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      04.07.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_date_created		datetime	  
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0) 
	,@p_car_state_sname		varchar(30)	  
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_short_name			varchar(30)
	,@p_repair_type_master_id numeric(38,0)
	,@p_organization_id		numeric(38,0) 
	,@p_organization_sname  varchar(30)	  
	,@p_amt					smallint
    ,@p_sys_comment			varchar(2000) = '-'
    ,@p_sys_user			varchar(30) = null
)
as
begin

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
	

insert into dbo.CREP_REPAIR_BY_CAR_DAY
	  (date_created, state_number, car_id
			,car_type_id, car_type_sname, car_state_id	
			,car_state_sname, car_mark_id, car_mark_sname
			,car_model_id, car_model_sname
			,car_kind_id
			,car_kind_sname, short_name, repair_type_master_id, amt
			, organization_id, organization_sname
			, sys_comment, sys_user_created, sys_user_modified)
select @p_date_created, @p_state_number, @p_car_id
			,@p_car_type_id, @p_car_type_sname, @p_car_state_id	
			,@p_car_state_sname, @p_car_mark_id, @p_car_mark_sname
			,@p_car_model_id, @p_car_model_sname
			,@p_car_kind_id
			,@p_car_kind_sname, @p_short_name, @p_repair_type_master_id, @p_amt
			,@p_organization_id, @p_organization_sname
	        ,@p_sys_comment, @p_sys_user, @p_sys_user
 where not exists
(select 1 from dbo.CREP_REPAIR_BY_CAR_DAY as b
  where b.date_created = @p_date_created
	and b.repair_type_master_id = repair_type_master_id
	and b.car_id = @p_car_id)
       
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CREP_REPAIR_BY_CAR_DAY
		 set
		    state_number = @p_state_number
		   ,car_type_id = @p_car_type_id
		   ,car_type_sname = @p_car_type_sname
		   ,car_state_id = @p_car_state_id	
		   ,car_state_sname = @p_car_state_sname
		   ,car_mark_id = @p_car_mark_id
		   ,car_mark_sname = @p_car_mark_sname
		   ,car_model_id = @p_car_model_id
		   ,car_model_sname = @p_car_model_sname
		   ,car_kind_id = @p_car_kind_id
		   ,car_kind_sname = @p_car_kind_sname
		   ,short_name = @p_short_name
		   ,amt = @p_amt
		   ,organization_id = @p_organization_id
		   ,organization_sname = @p_organization_sname
	       ,sys_comment = @p_sys_comment
		   ,sys_user_modified = @p_sys_user
		where date_created = @p_date_created
		and repair_type_master_id = repair_type_master_id
		and car_id = @p_car_id
    
  return 

end
GO


GRANT EXECUTE ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_SaveById] TO [$(db_app_user)]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Calculate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна подсчитывать данные для отчетов о ремонтах по автомобилям
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      08.04.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	 @p_date_created		datetime		= null
	,@p_state_number		varchar(20)
	,@p_car_id				numeric(38,0)
	,@p_car_type_id			numeric(38,0)
	,@p_car_type_sname		varchar(30)
	,@p_car_state_id		numeric(38,0)	= null
	,@p_car_state_sname		varchar(30)		= null
	,@p_car_mark_id			numeric(38,0)
	,@p_car_mark_sname		varchar(30)
	,@p_car_model_id		numeric(38,0)
	,@p_car_model_sname		varchar(30)
	,@p_fuel_type_id		numeric(38,0)
	,@p_fuel_type_sname		varchar(30)
	,@p_car_kind_id			numeric(38,0)
	,@p_car_kind_sname		varchar(30)
	,@p_organization_id		numeric(38,0) = null
	,@p_organization_sname  varchar(30)	  = null
    ,@p_sys_comment			varchar(2000) 
    ,@p_sys_user			varchar(30)
)
AS
SET NOCOUNT ON
set xact_abort on
  
  declare

	 @v_Error			 int
    ,@v_TrancountOnEntry int
	,@v_month_created	 datetime
	,@v_state_number	 varchar(20)
	,@v_short_name		 varchar(30)
	,@v_amt				 smallint
	,@v_repair_type_master_id numeric(38,0)
 set @v_month_created = dbo.usfUtils_DayTo01(@p_date_created)
	
  
select  @v_state_number = d.state_number
	   ,@v_short_name = c.short_name
	   ,@v_amt = count(b.repair_type_master_id)
	   ,@v_repair_type_master_id = b.repair_type_master_id 
from dbo.CWRH_WRH_ORDER_MASTER as a
	join dbo.CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER as b
	on a.id = b.wrh_order_master_id
	join dbo.CRPR_REPAIR_TYPE_MASTER as c
	on b.repair_type_master_id = c.id
	join dbo.CCAR_CAR as d
	on a.car_id = d.id
where a.car_id = @p_car_id
   and a.date_created > = @v_month_created
   and a.date_created < dateadd("mm", 1, @v_month_created)
group by a.car_id, d.state_number,  c.short_name, b.repair_type_master_id

exec @v_Error = dbo.uspVREP_REPAIR_BY_CAR_DAY_SaveById
   @p_date_created = @p_date_created
  ,@p_state_number = @v_state_number
  ,@p_car_id = @p_car_id
  ,@p_car_type_id = @p_car_type_id
  ,@p_car_type_sname = @p_car_type_sname
  ,@p_car_state_id = @p_car_state_id
  ,@p_car_state_sname = @p_car_state_sname
  ,@p_car_mark_id = @p_car_mark_id
  ,@p_car_mark_sname = @p_car_mark_sname
  ,@p_car_model_id = @p_car_model_id
  ,@p_car_model_sname = @p_car_model_sname
  ,@p_car_kind_id = @p_car_kind_id
  ,@p_car_kind_sname = @p_car_kind_sname
  ,@p_short_name = @v_short_name
  ,@p_repair_type_master_id = @v_repair_type_master_id
  ,@p_organization_id = @p_organization_id
  ,@p_organization_sname = @p_organization_sname
  ,@p_amt = @v_amt
  ,@p_sys_comment = @p_sys_comment
  ,@p_sys_user = @p_sys_user


	RETURN
GO

GRANT EXECUTE ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Calculate] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_REPAIR_BY_CAR_DAY_Calculate] TO [$(db_app_user)]
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


