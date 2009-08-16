:r ./../_define.sql

:setvar dc_number 00392
:setvar dc_description "rep_serial_log columns added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.11.2008 VLavrentiev   rep_serial_log columns added
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

alter table dbo.CREP_SERIAL_LOG
add state_number varchar(20)
go

alter table dbo.CREP_SERIAL_LOG
add fio varchar(60)
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Номер автомобиля',
   'user', @CurrentUser, 'table', 'CREP_SERIAL_LOG', 'column', 'state_number'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'ФИО водителя',
   'user', @CurrentUser, 'table', 'CREP_SERIAL_LOG', 'column', 'fio'
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_SaveById]
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
 ,@p_device_name	varchar(256)	  = null
 ,@p_message_code   varchar(256)	  = null
 ,@p_card_number	varchar(128)	  = null 
 ,@p_sys_comment	varchar(2000)	  = '-'
 ,@p_sys_user		varchar(30)		  = null
)
AS
BEGIN

declare 
	@v_message_code		 varchar(1024)
   ,@v_last_message_code varchar(1024)
   ,@v_fio_employee_id	numeric(38,0)
   ,@v_fio_employee		varchar(256)
   ,@v_car_id			numeric(38,0)
   ,@v_state_number		varchar(20)
   ,@v_device_id		numeric(38,0)

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
		and speedometer_end_indctn is null
		order by date_created desc, fact_end_duty desc 

	select 
	  @v_fio_employee = rtrim(b.lastname + ' ' + isnull(substring(b.name,1,1),'') + '. ' + isnull(substring(b.surname,1,1),'') + '.')
      from dbo.CPRT_EMPLOYEE as a
		join dbo.CPRT_PERSON as b
		on a.person_id = b.id
	  where a.id = @v_fio_employee_id

	select @v_device_id = id from dbo.CDEV_DEVICE
	where short_name = @p_device_name 

	set @v_message_code = isnull(@v_fio_employee, '') + ' ' +
							   case 
							   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE') then 'вышел на линию'
							   when @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE') then 'вернулся с линии'
							   else ''
							   end
										  + ' ' +
						  '№ СТП: ' +  isnull(@v_state_number , '') + '.'

	set @v_last_message_code = isnull(@v_fio_employee, '') + ' ' +
							   case 
							   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE') then 'вернулся с линии'
							   when @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE') then 'вышел на линию'
							   else ''
							   end
										  + ' ' +
						  '№ СТП: ' +  isnull(@v_state_number , '') + '.'
 end
else
    set @v_message_code = @p_message_code

/*if ( (not exists (select TOP(1) 1 from dbo.CREP_SERIAL_LOG where @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE')
													and message_code = @v_message_code
													and date_created >= 
																(select TOP(1) date_created
																	from dbo.CREP_SERIAL_LOG 
																	where @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE')
																	  and message_code = @v_last_message_code
																	order by date_created desc)
				  order by date_created desc))
	or
	( not exists (select TOP(1) 1 from dbo.CREP_SERIAL_LOG where @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE')
													and message_code = @v_message_code
													and date_created >= 
																(select TOP(1) date_created
																	from dbo.CREP_SERIAL_LOG 
																	where @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE')
																	  and message_code = @v_last_message_code
																	order by date_created desc)
				 order by date_created desc)))*/
begin
 if ((@p_id is null) and @v_state_number != '')
  begin
	insert into dbo.CREP_SERIAL_LOG(date_created, message_code, state_number, fio, sys_comment, sys_user_modified, sys_user_created)
	values(@p_date_created, @v_message_code, @v_state_number, @v_fio_employee, @p_sys_comment, @p_sys_user, @p_sys_user)
	
	set @p_id = scope_identity()
  end
 else
    update dbo.CREP_SERIAL_LOG
	 set
	    message_code		= @v_message_code
	   ,date_created		= @p_date_created
	   ,state_number		= @v_state_number
	   ,fio					= @v_fio_employee
	   ,sys_comment			= @p_sys_comment
	   ,sys_user_modified	= @p_sys_user	
	where id = @p_id
end
 
END
go


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




ALTER function [dbo].[utfVREP_SERIAL_LOG]
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
	,state_number
	,fio
	from dbo.CREP_SERIAL_LOG
)

go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

ALTER PROCEDURE [dbo].[uspVREP_SERIAL_LOG_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна выводить отчет о выходе на линию автомобилей
**
**  Входные параметры:
**	@p_start_date		- Дата, с которой выводить события выхода(возвращения)
**	@p_end_date			- Дата, по которую выводить события выхода(возвращения)
**  @p_Str				- Строка поиска (по сообщению)
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      20.11.2008 VLavrentiev	Добавил вывод номера автомобиля и ФИО водителя
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
	,state_number
	,fio
	from dbo.utfVREP_SERIAL_LOG()
	where dbo.usfUtils_TimeToZero(date_created) between @p_start_date and @p_end_date
	  and (upper(rtrim(ltrim(message_code))) like upper(rtrim(ltrim('%' + @p_Str + '%'))) or @p_Str is null)
	  order by date_created desc
 
END

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
