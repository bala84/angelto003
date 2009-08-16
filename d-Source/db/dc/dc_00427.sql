:r ./../_define.sql

:setvar dc_number 00427
:setvar dc_description "car no exit type added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   27.03.2009 VLavrentiev   car no exit type added
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
CREATE TABLE [dbo].[CCAR_CAR_NOEXIT_REASON_TYPE](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[short_name] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL,
	[full_name] [varchar](60) COLLATE Cyrillic_General_CI_AS NOT NULL,
 CONSTRAINT [CCAR_CAR_NOEXIT_REASON_TYPE_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_dat_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Краткое название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'short_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Полное название' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE', @level2type=N'COLUMN', @level2name=N'full_name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица типов невыходов автомобилей с линии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CCAR_CAR_NOEXIT_REASON_TYPE'
GO



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


	if (@p_account_type = 'Цена без НДС')
	 set @v_account_type = 0
	if (@p_account_type = 'Сумма с НДС')
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

alter table dbo.cdrv_driver_plan_detail
alter column car_id numeric(38,0) null
go



alter table dbo.cdrv_driver_plan_detail
add rownum int null
go

alter table dbo.cdrv_driver_plan_detail
add organization_id numeric(38,0)
go

alter table dbo.cdrv_driver_plan_detail
add car_kind_id numeric(38,0)
go


alter table dbo.cdrv_driver_plan_detail
add organization_sname varchar(100)
go

alter table dbo.cdrv_driver_plan_detail
add car_kind_sname varchar(30)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Порядковый номер выхода' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cdrv_driver_plan_detail', @level2type=N'COLUMN', @level2name=N'rownum'

GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cdrv_driver_plan_detail', @level2type=N'COLUMN', @level2name=N'organization_id'

GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название организации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cdrv_driver_plan_detail', @level2type=N'COLUMN', @level2name=N'organization_sname'

GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид вида автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cdrv_driver_plan_detail', @level2type=N'COLUMN', @level2name=N'car_kind_id'

GO


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название автомобиля' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'cdrv_driver_plan_detail', @level2type=N'COLUMN', @level2name=N'car_kind_sname'

GO


create unique index u_drv_driver_plan_detail_rownum_date_org_id_car_kind_id on dbo.cdrv_driver_plan_detail(rownum, date, organization_id, car_kind_id)
on $(fg_idx_name)
go

create index ifk_drv_driver_plan_detail_org_id on dbo.cdrv_driver_plan_detail(organization_id)
on $(fg_idx_name)
go

create index ifk_drv_driver_plan_detail_car_kind_id on dbo.cdrv_driver_plan_detail(car_kind_id)
on $(fg_idx_name)
go



alter table dbo.cdrv_driver_plan_detail
   add constraint cdrv_driver_plan_detail_organization_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

alter table dbo.cdrv_driver_plan_detail
   add constraint cdrv_driver_plan_detail_car_kind_ID_FK foreign key (car_kind_id)
      references CCAR_CAR_KIND (id)
go





set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go









ALTER PROCEDURE [dbo].[uspVDRV_DRIVER_PLAN_DETAIL_SelectByDate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о детальном плане выхода на линию по машинам
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.05.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_date		datetime
,@p_car_kind_id numeric(38,0)
,@p_organization_id numeric(38,0)
)
AS
SET NOCOUNT ON

select  @p_date = dbo.usfUtils_TimeToZero(@p_date)


/*if (not exists (select 1 from dbo.cdrv_driver_plan_detail as a
				 where date = @p_date 
				   and exists
						(select 1 from dbo.ccar_car as b
							where a.car_id = b.id
							  and b.car_kind_id = @p_car_kind_id
							  and b.organization_id = @p_organization_id)))
select null as id
	 , null as sys_status
	 , null as sys_comment
	 , null as sys_date_modified
	 , null as sys_date_created
	 , null as sys_user_modified
	 , null as sys_user_created
	 , b.car_id
	 , c.state_number
	 , @p_date as date
	 , null as time
	 , b.employee_id 
	 , e.lastname + ' ' + substring(e.name,1,1) + '.' + isnull(substring(e.surname,1,1) + '.','') as fio_driver
	 , d.driver_license
	 , null as shift_number
	 , null as comments
	 , null as mech_employee_id
	 , 0 as is_completed
	  ,f.id as organization_id
	  ,f.name as organization_sname
	  ,g.id as car_kind_id
	  ,g.short_name as car_kind_sname
	  ,null as dt_time
	  ,null as is_night_work
 from
(select car_id, case when schema_schedule = 1 then employee1_id
					when schema_schedule = 2 then employee2_id
					when schema_schedule = 3 then employee3_id
					when schema_schedule = 4 then employee4_id
				end as employee_id
from
(select b.car_id, employee1_id, employee2_id, employee3_id, employee4_id
				 ,case  when Day(@p_date) = 1
		         then a.day_1
				 when Day(@p_date) = 2
		         then a.day_2
				 when Day(@p_date) = 3
		         then a.day_3
				 when Day(@p_date) = 4
		         then a.day_4
				 when Day(@p_date) = 5
		         then a.day_5
				 when Day(@p_date) = 6
		         then a.day_6
				 when Day(@p_date) = 7
		         then a.day_7
				 when Day(@p_date) = 8
		         then a.day_9
				 when Day(@p_date) = 10
		         then a.day_10
				 when Day(@p_date) = 11
		         then a.day_11
				 when Day(@p_date) = 12
		         then a.day_12
				 when Day(@p_date) = 13
		         then a.day_13
				 when Day(@p_date) = 14
		         then a.day_14
				 when Day(@p_date) = 15
		         then a.day_15
				 when Day(@p_date) = 16
		         then a.day_16
				 when Day(@p_date) = 17
		         then a.day_17
			     when Day(@p_date) = 18
		         then a.day_18
				 when Day(@p_date) = 19
		         then a.day_19
				 when Day(@p_date) = 20
		         then a.day_20
				 when Day(@p_date) = 21
		         then a.day_21
				 when Day(@p_date) = 22
		         then a.day_22
				 when Day(@p_date) = 23
		         then a.day_23
				 when Day(@p_date) = 24
		         then a.day_24
				 when Day(@p_date) = 25
		         then a.day_25
				 when Day(@p_date) = 26
		         then a.day_26
				 when Day(@p_date) = 27
		         then a.day_27
				 when Day(@p_date) = 28
		         then a.day_28
				 when Day(@p_date) = 29
		         then a.day_29
				 when Day(@p_date) = 30
		         then a.day_30
				 when Day(@p_date) = 31
		         then a.day_31
			 end as schema_schedule
from dbo.cdrv_month_plan as a
		join dbo.cdrv_driver_plan as b
		  on  a.month = dbo.usfUtils_TimeToZero(b.time)
where a.month = dbo.usfUtils_DayTo01(@p_date)) as a) as b
join dbo.ccar_car as c
  on b.car_id = c.id
join dbo.cprt_employee as d
  on b.employee_id = d.id
join dbo.cprt_person as e
  on d.person_id = e.id
join dbo.cprt_organization as f
  on f.id = c.organization_id
	join dbo.ccar_car_kind as g
	  on c.car_kind_id = g.id
where c.sys_status = 1
  and d.sys_status = 1
  and e.sys_status = 1
  and f.sys_status = 1
  and g.sys_status = 1
  and c.car_kind_id = @p_car_kind_id
  and c.organization_id = @p_organization_id

else*/

select a.id
	  ,a.sys_status
	  ,a.sys_comment
	  ,a.sys_date_modified
	  ,a.sys_date_created
	  ,a.sys_user_modified
	  ,a.sys_user_created
	  ,a.car_id
	  ,b.state_number
	  ,a.date
	  ,case when datepart("Hh", a.time) < 10
			then '0' + convert(varchar(1), datepart("Hh", a.time))
			else convert(varchar(2), datepart("Hh", a.time))
		end + ':' +
			case when datepart("Minute", a.time) < 10
			then '0' + convert(varchar(1), datepart("Minute", a.time))
			else convert(varchar(2), datepart("Minute", a.time))
			end as time
	  ,a.employee_id
	  ,d.lastname + ' ' + substring(d.name,1,1) + '.' + isnull(substring(d.surname,1,1) + '.','') as fio_driver
	  ,c.driver_license
	  ,a.shift_number
	  ,a.comments
	  ,a.mech_employee_id
	  ,a.is_completed
	  ,a.id as organization_id
	  ,a.organization_sname
	  ,a.id as car_kind_id
	  ,a.car_kind_sname
	  ,a.time as dt_time
	  ,case when datepart("Hh", a.time )< dbo.usfConst('Начало ночной смены')
		then 0
	    else 1
	    end as is_night_work
	  ,a.rownum
  from dbo.CDRV_DRIVER_PLAN_DETAIL as a
	left outer join dbo.ccar_car as b
	  on a.car_id = b.id
	left outer join dbo.cprt_employee as c
	  on a.employee_id = c.id
	left outer join dbo.cprt_person as d
	  on c.person_id = d.id
  where isnull(b.sys_status, 1) = 1
	and isnull(c.sys_status, 1) = 1
    and isnull(d.sys_status, 1) = 1
    and a.date = @p_date
	and a.car_kind_id = @p_car_kind_id
	and a.organization_id = @p_organization_id
   order by a.rownum, a.time	



	RETURN

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
	,@p_car_id			 numeric(38,0) = null
	,@p_date			 datetime
    ,@p_time			 varchar(5)	   = null
	,@p_employee_id		 numeric(38,0) = null
	,@p_shift_number	 tinyint	   = null
	,@p_comments		 varchar(1000) = null
	,@p_mech_employee_id numeric(38,0) = null
	,@p_is_completed	 bit		   = 0
	,@p_rownum			 int		
	,@p_organization_id	 numeric(38,0) 
	,@p_organization_sname	varchar(100)
	,@p_car_kind_id		numeric(38,0)
	,@p_car_kind_sname	varchar(30)
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
		    ,rownum, organization_id, organization_sname, car_kind_id, car_kind_sname	
			,sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_car_id, @p_date, @v_time, @p_employee_id, @p_shift_number, @p_comments ,@p_mech_employee_id, @p_is_completed
		    ,@p_rownum, @p_organization_id, @p_organization_sname, @p_car_kind_id, @p_car_kind_sname 	
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
		, rownum = @p_rownum
		, organization_id = @p_organization_id
		, organization_sname = @p_organization_sname
		, car_kind_id = @p_car_kind_id
		, car_kind_sname = @p_car_kind_sname
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




