:r ./../_define.sql

:setvar dc_number 00401
:setvar dc_description "rep serial log fix"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   26.11.2008 VLavrentiev  rep serial log fix
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
   ,@v_denied_msg		varchar(1024)

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
							   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE') then 'вышел(а) на линию'
							   when @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE') then 'вернулся(ась) с линии'
							   else ''
							   end
										  + ' ' +
						  '№ СТП: ' +  isnull(@v_state_number , '') + '.'

	set @v_last_message_code = isnull(@v_fio_employee, '') + ' ' +
							   case 
							   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE') then 'вернулся(ась) с линии'
							   when @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE') then 'вышел(а) на линию'
							   else ''
							   end
										  + ' ' +
						  '№ СТП: ' +  isnull(@v_state_number , '') + '.'

    set @v_denied_msg = 'У автомобиля ' +  isnull(@v_state_number , '') + ' уже зарегистрировано прибытие/убытие. Два раза одно событие не регистрируется.' 
 end
else
    set @v_message_code = @p_message_code

begin
 if ((not exists (select 
					1 from 
						(	select top(1) message_code from dbo.crep_serial_log
							where 
							--	message_code like isnull('%' + @v_fio_employee + '%', '%')
							--and 
								message_code like isnull('%' + @v_state_number + '%', '')
							and sys_status = 1
							order by date_created desc
						 ) as a
					where isnull(a.message_code, '1') like case 
													   when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE')
													   then '%вышел%'
													   when  @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE')
													   then '%вернулся%'
													   else '2'
													end
														))
	/*and (exists (select 
					1 from 
						(	select top(1) message_code from dbo.crep_serial_log
							where message_code like isnull(@v_fio_employee, '%')
							and message_code like isnull(@v_state_number , '')) as a
					where isnull(a.message_code, '1') like 
												    case when @v_device_id = dbo.usfConst('EXIT_DUTY_SERIAL_DEVICE')
													   then '%вернулся%'
													   when  @v_device_id = dbo.usfConst('ENTER_DUTY_SERIAL_DEVICE')
													   then '%вышел%'
													   else '1'
													end
														))*/
			)
   begin
	  if ((@p_id is null) and @v_state_number != '')
	   begin
		insert into dbo.CREP_SERIAL_LOG(date_created, message_code, state_number, fio, sys_comment, sys_user_modified, sys_user_created)
		values(@p_date_created, @v_message_code,@v_state_number , @v_fio_employee,  @p_sys_comment, @p_sys_user, @p_sys_user)
		
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
   end
  /*else
   	  if ((@p_id is null) and @v_state_number != '')
	   begin
		insert into dbo.CREP_SERIAL_LOG(date_created, message_code, sys_comment, sys_user_modified, sys_user_created)
		values(@p_date_created, @v_denied_msg , @p_sys_comment, @p_sys_user, @p_sys_user)
		
		set @p_id = scope_identity()
	   end*/
    
end
 
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

:r _add_chis_all_objects.sql


