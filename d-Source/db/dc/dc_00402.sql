:r ./../_define.sql

:setvar dc_number 00402
:setvar dc_description "car exit func added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   01.12.2008 VLavrentiev  car exit func added
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

CREATE FUNCTION [dbo].[utfVCAR_CAR_EXITByDate] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения выхода автомобилей
**
** Входные параметры:
** @p_date	Дата, за которую необходимо выполнить поиск выходов автомобилей
**
**
** Выходные данные:
** state_number	Номер СТП
** fio			Фамилия водителя, вышедшего на линию
** date_planned Время и дата запланнированного выхода
** date_exit	Время и дата выхода по факту
** date_return  Время и дата возвращения автомобиля
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      01.12.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
@p_date datetime
)
RETURNS TABLE 
AS
RETURN 
(
	
with exit_stmt (date_exit, id, message_code, state_number) as
(select c.date_created as date_exit, id, message_code, state_number
		   from dbo.crep_serial_log as c
		where c.message_code like ('%вышел%')
		  and c.date_created  <= dateadd("Day", 1, @p_date)
		  and c.date_created > @p_date)
    ,exit_next_stmt(date_exit, id, message_code, state_number) as
(select date_created as date_exit, id, message_code, state_number
	from dbo.crep_serial_log as c
	where c.message_code like ('%вышел%')
	  and c.date_created > dateadd("Day", 1, @p_date))
select
TOP(100) PERCENT 
 a.state_number
,a.fio
,a.date_planned 
,a.date_exit
,j3.date_return
 from
(select 
	 b.date_created 
	,b.state_number
	,b.fio
	--,j.time
	,dateadd("Hh", 6, dbo.usfUtils_TimeToZero(b.date_created)) as date_planned
	,j2.date_exit
	from dbo.crep_serial_log as b
	outer apply
		(select top(1) date_exit
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc) as j2
	where b.id = (select top(1) id 
					from exit_stmt
					where state_number = b.state_number
					order by date_exit desc)) as a
outer apply
	(select top(1) c.date_created as date_return
	   from dbo.crep_serial_log as c
	where c.state_number = a.state_number
	  and c.message_code like ('%вернулся%')
	  and c.date_created  > a.date_exit
	  and c.date_created < (select top(1) date_exit 
							from exit_next_stmt
							where state_number = a.state_number
							order by date_exit asc)
	order by c.date_created desc) as j3
order by a.date_created desc 
,a.state_number asc



)
go



GRANT VIEW DEFINITION ON [dbo].[utfVCAR_CAR_EXITByDate] TO [$(db_app_user)]
GO


GRANT VIEW DEFINITION ON [dbo].[utfVCAR_CAR_EXITByDate] TO [$(db_dc_user)]
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




PRINT ' '
PRINT '==============================================================================='
PRINT '=          Starting script _add_chis_all_objects.sql                          ='
PRINT '==============================================================================='
PRINT ' '
go

--:r _add_chis_all_objects.sql


