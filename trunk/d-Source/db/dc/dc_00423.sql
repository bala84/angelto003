:r ./../_define.sql

:setvar dc_number 00423
:setvar dc_description "driver plan detail triggers added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   16.03.2009 VLavrentiev   driver plan detail triggers added
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
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CREP_DRIVER_PLAN_DETAIL](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000)  NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) NOT NULL DEFAULT (user_name()),
	[car_id] [numeric](38, 0) NOT NULL,
	[date] [datetime] NOT NULL,
	[time] [datetime] NULL,
	[employee_id] [numeric](38, 0) NULL,
	[shift_number] [tinyint] NULL,
	[comments] [varchar](1000) NULL,
	[mech_employee_id] [numeric](38, 0) NULL,
	[is_completed] [bit] NULL DEFAULT ((0)),
 CONSTRAINT [CREP_DRIVER_PLAN_DETAIL_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'car_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'date'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Время выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'time'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сотрудника' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'employee_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер смены' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'shift_number'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'comments'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид механика' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'mech_employee_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Утвержденный план или нет' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'is_completed'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица детального плана выхода на линию' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CREP_DRIVER_PLAN_DETAIL'

GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go





create trigger [TAIUD_CDRV_DRIVER_PLAN_DETAIL]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Триггер для регистрации созданного плана выхода на линию
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.02.2009 VLavrentiev	Добавил новый триггер
*******************************************************************************/
on [dbo].[CDRV_DRIVER_PLAN_DETAIL]
after insert, update, delete
as
begin
  
  
  -- Если время позже шести - проставим статус плана - завершен
  if (datepart("Hh", getdate()) > 6) 
  begin
    update dbo.cdrv_driver_plan_detail
	   set is_completed = 1
	  where is_completed = 0
		and date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))
  end
  -- Если плана нет в отчетных планах добавим отчет
  if (not exists (select 1 from dbo.crep_driver_plan_detail where date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))))
  begin
	insert into dbo.crep_driver_plan_detail(car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed)
	select car_id, date, time, employee_id, shift_number, comments, mech_employee_id, is_completed
	  from dbo.cdrv_driver_plan_detail
	  where date = dbo.usfUtils_TimeToZero(dateadd("Day", -1, getdate()))
  end	 


end
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







ALTER procedure [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить детальный план выхода на линию по машинам
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
	,@p_car_id			 numeric(38,0)
	,@p_date			 datetime
    ,@p_time			 varchar(5)	   = null
	,@p_employee_id		 numeric(38,0) = null
	,@p_shift_number	 tinyint	   = null
	,@p_comments		 varchar(1000) = null
	,@p_mech_employee_id numeric(38,0) = null
	,@p_is_completed	 bit		   = 0
    ,@p_sys_comment		varchar(2000)  = '-'
    ,@p_sys_user		varchar(30)	   = null
)
as
begin
  set nocount on
	declare @v_time datetime


     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

    set @p_date = dbo.usfUtils_TimeToZero(@p_date)

    select @v_time = convert(datetime, substring(convert(varchar(30), @p_date), 1, 11) + ' ' + @p_time + ':00')
															

   if (@p_is_completed is null)
    set @p_is_completed = 0

       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CDRV_DRIVER_PLAN_DETAIL
            (car_id, date, "time", employee_id, shift_number, comments ,mech_employee_id, is_completed
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_employee_id, @p_shift_number, @p_comments ,@p_mech_employee_id, @p_is_completed
		    ,@p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CDRV_DRIVER_PLAN_DETAIL set
		  car_id = @p_car_id
	    , date   = @p_date
		, "time" = @v_time
		, employee_id = @p_employee_id
		, shift_number = @p_shift_number
		, comments	   = @p_comments
		, mech_employee_id = @p_mech_employee_id
		, is_completed     = @p_is_completed
		, sys_comment = @p_sys_comment
        , sys_user_modified = @p_sys_user
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




