:r ./../_define.sql

:setvar dc_number 00325
:setvar dc_description "serial port tables added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    29.06.2008 VLavrentiev  serial port tables added
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


create table dbo.CSYS_SERIAL_LOG
(
 id numeric(38,0) identity (1000,1)
,sys_status smallint default 1
,sys_date_created datetime default getdate()
,sys_date_modified datetime default getdate()
,sys_user_modified varchar(30) default user_name()
,sys_user_created varchar(30) default user_name()
,sys_comment varchar(2000) default '-'
,date_created datetime	default getdate()
,device_name  varchar(256) not null
,message_code varchar(256) not null
,constraint CSYS_SERIAL_LOG_PK primary key (id) on $(fg_idx_name)
)  on $(fg_dat_name)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Название устройства' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'device_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Сообщение' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'message_code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица для логирования сообщений от com порта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CSYS_SERIAL_LOG'
GO

create index i_date_created_sys_serial_log on dbo.CSYS_SERIAL_LOG(date_created)
on $(fg_idx_name)
go

create index i_device_name_sys_serial_log on dbo.CSYS_SERIAL_LOG(device_name)
on $(fg_idx_name)
go


create function utfVSYS_SERIAL_LOG
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция должна выводить данные о логе ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
()
RETURNS TABLE 
AS
return
(
select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,device_name
	,message_code
	from dbo.CSYS_SERIAL_LOG
)
go

     
GRANT VIEW DEFINITION ON [dbo].[utfVSYS_SERIAL_LOG] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.uspVSYS_SERIAL_LOG_SelectAll
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить данные о логе ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

(
  @p_start_date datetime
 ,@p_end_date datetime
)
AS
BEGIN

	SET NOCOUNT ON

select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,device_name
	,message_code
	from dbo.utfVSYS_SERIAL_LOG()
	where date_created between @p_start_date and @p_end_date
 
END
GO


GRANT EXECUTE ON [dbo].[uspVSYS_SERIAL_LOG_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVSYS_SERIAL_LOG_SelectAll] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE dbo.uspVSYS_SERIAL_LOG_SaveById
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить данные в лог ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)	  = null out
 ,@p_date_created	datetime		  = null
 ,@p_device_name	varchar(256)
 ,@p_message_code   varchar(256)
 ,@p_sys_comment	varchar(2000)	  = '-'
 ,@p_sys_user		varchar(30)		  = null
)
AS
BEGIN


if (@p_sys_user is null)
	set @p_sys_user = user_name()

if (@p_sys_comment is null)
	set @p_sys_comment = '-'

if (@p_date_created is null)
	set @p_date_created = getdate()

if (@p_id is null)
 begin
	insert into dbo.CSYS_SERIAL_LOG(date_created, device_name, message_code, sys_comment, sys_user_modified, sys_user_created)
	values(@p_date_created, @p_device_name, @p_message_code, @p_sys_comment, @p_sys_user, @p_sys_user)
	
	set @p_id = scope_identity()
 end
else
    update dbo.CSYS_SERIAL_LOG
	 set
		device_name			= @p_device_name
	   ,date_created		= @p_date_created
	   ,message_code		= @p_message_code
	   ,sys_comment			= @p_sys_comment
	   ,sys_user_modified	= @p_sys_user	
	where id = @p_id
 
END
GO


GRANT EXECUTE ON [dbo].[uspVSYS_SERIAL_LOG_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVSYS_SERIAL_LOG_SaveById] TO [$(db_app_user)]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.uspVSYS_SERIAL_LOG_DeleteById
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить данные из лога ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)
)
AS
BEGIN

delete from dbo.CSYS_SERIAL_LOG
where id = @p_id
END
GO


GRANT EXECUTE ON [dbo].[uspVSYS_SERIAL_LOG_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVSYS_SERIAL_LOG_DeleteById] TO [$(db_app_user)]
GO


create table dbo.CREP_SERIAL_LOG
(
 id numeric(38,0) identity (1000,1)
,sys_status smallint default 1
,sys_date_created datetime default getdate()
,sys_date_modified datetime default getdate()
,sys_user_modified varchar(30) default user_name()
,sys_user_created varchar(30) default user_name()
,sys_comment varchar(2000) default '-'
,date_created datetime	default getdate()
,message_code varchar(512) not null
,constraint CREP_SERIAL_LOG_PK primary key (id)
)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_comment'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_date_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_user_modified'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'sys_user_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'id'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'date_created'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Сообщение' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG', @level2type=N'COLUMN',@level2name=N'message_code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица отчета сообщений от com порта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CREP_SERIAL_LOG'
GO


create index i_date_created_rep_serial_log on dbo.CREP_SERIAL_LOG(date_created)
on $(fg_idx_name)
go



create index i_message_code_rep_serial_log on dbo.CREP_SERIAL_LOG(message_code)
on $(fg_idx_name)
go



create function dbo.utfVREP_SERIAL_LOG
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**  Функция должна выводить данные об отчете ком портов
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      26.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
()
RETURNS TABLE 
AS
return
(
select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,message_code
	from dbo.CREP_SERIAL_LOG
)
go

GRANT VIEW DEFINITION ON [dbo].[utfVREP_SERIAL_LOG] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.uspVREP_SERIAL_LOG_SelectAll
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

(
  @p_start_date datetime
 ,@p_end_date   datetime
 ,@p_Str	varchar(100) = null
)
AS
BEGIN

	SET NOCOUNT ON

select 
	 id
	,sys_status
	,sys_date_created
	,sys_date_modified
	,sys_user_modified
	,sys_user_created
	,sys_comment
	,date_created
	,message_code
	from dbo.utfVREP_SERIAL_LOG()
	where date_created between @p_start_date and @p_end_date
	  and (upper(rtrim(ltrim(message_code))) like upper(rtrim(ltrim(@p_Str + '%'))) or @p_Str is null)
 
END
GO


GRANT EXECUTE ON [dbo].[uspVREP_SERIAL_LOG_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_SERIAL_LOG_SelectAll] TO [$(db_app_user)]
GO



alter table dbo.CCAR_CAR add card_number varchar(128)
go


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Номер прокси карточки' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CCAR_CAR', @level2type=N'COLUMN',@level2name=N'card_number'
GO

create index i_card_number_car on dbo.CCAR_CAR(card_number)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.uspVREP_SERIAL_LOG_SaveById
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранять отчет о ком портах
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.06.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_id				numeric(38,0)	  = null out
 ,@p_date_created	datetime		  = null
 ,@p_device_name	varchar(256)	  
 ,@p_message_code   varchar(256)	  = null
 ,@p_card_number	varchar(128)	  
 ,@p_sys_comment	varchar(2000)	  = '-'
 ,@p_sys_user		varchar(30)		  = null
)
AS
BEGIN

declare 
	@v_message_code		varchar(1024)
   ,@v_fio_employee_id	numeric(38,0)
   ,@v_fio_employee		varchar(256)
   ,@v_car_id			numeric(38,0)
   ,@v_state_number		varchar(20)

if (@p_sys_user is null)
	set @p_sys_user = user_name()

if (@p_sys_comment is null)
	set @p_sys_comment = '-'

if (@p_date_created is null)
	set @p_date_created = getdate()

if (@p_message_code is null)
 begin
	select @v_car_id = id
		  ,@v_state_number = state_number
	  from dbo.CCAR_CAR
	  where card_number = @p_card_number
  
	select TOP(1) 
	  @v_fio_employee_id = employee1_id
      from dbo.CDRV_DRIVER_LIST
	  where car_id = @v_car_id
		order by date_created desc, fact_end_duty desc 

	select 
	  @v_fio_employee = 'Иванов И.И.'
      from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b
		on a.person_id = b.id
	  where a.id = @v_fio_employee_id

	set @v_message_code = @v_fio_employee + ' ' +
							   case when @p_device_name = 'dev1' then 'вышел на линию'
							   when @p_device_name = 'dev2' then 'вернулся с линии'
							   end
										  + ' ' +
						  '№ СТП: ' +  @v_state_number + '.'
 end
else
    set @v_message_code = @p_message_code

if (@p_id is null)
 begin
	insert into dbo.CREP_SERIAL_LOG(date_created, message_code, sys_comment, sys_user_modified, sys_user_created)
	values(@p_date_created, @v_message_code, @p_sys_comment, @p_sys_user, @p_sys_user)
	
	set @p_id = scope_identity()
 end
else
    update dbo.CREP_SERIAL_LOG
	 set
	    message_code		= @v_message_code
	   ,date_created		= @p_date_created
	   ,sys_comment			= @p_sys_comment
	   ,sys_user_modified	= @p_sys_user	
	where id = @p_id
 
END
GO


GRANT EXECUTE ON [dbo].[uspVREP_SERIAL_LOG_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVREP_SERIAL_LOG_SaveById] TO [$(db_app_user)]
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



