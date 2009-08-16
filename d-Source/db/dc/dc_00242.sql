:r ./../_define.sql

:setvar dc_number 00242
:setvar dc_description "work hours functions added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    13.05.2008 VLavrentiev  work hours functions added
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


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[usfREP_EMPLOYEE_Day_Count]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** ������� ������������ ������� ������� ���� � ���������� �������
** ������� �����
**
**  ������� ���������: 
**	@p_start_date - ���� ������ ������
**	@p_end_date   - ���� ��������� ������
**	@p_start_time_norm   - ������ �������� ��� �� �����
**	@p_end_time_norm	 - ��������� �������� ��� �� �����
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.05.2008 VLavrentiev	������� ����� ���������
*******************************************************************************/
( 
  @p_start_date		  datetime
, @p_end_date		  datetime
, @p_start_time_norm  char(8)
, @p_end_time_norm	  char(8)
)
RETURNS int
AS
BEGIN

declare
	 @v_initial_value      int
	,@v_value		       decimal
	,@v_start_date		   datetime
	,@v_end_date		   datetime
	,@v_temp_start_date    datetime
	,@v_temp_end_date	   datetime
	,@v_temp_value	       decimal		  
	,@i int
--���������� ���������� �������� ������� �����
set @v_initial_value = datediff("Day", @p_start_date, @p_end_date)

set @i = 0
set @v_value = 0

while (@i <= @v_initial_value)
begin
--���������� ���������� ������� ����� ����� 
 if (@i = 0)
  set @p_start_date = @p_start_date
 else
  begin
   set @p_start_date = @p_start_date + 1
   set @p_start_date = dbo.usfUtils_TimeToValue(@p_start_date, @p_start_time_norm)
  end
 set @p_end_date = @p_end_date
--����������������� ���������� ��� ������� �����
set @v_start_date = @p_start_date
set @v_end_date = @p_end_date
--
 set @v_temp_start_date = dbo.usfUtils_TimeToZero(@v_start_date)
--�������� ���� ��������� ������ �� ������������ ���� ������
--���� ���� ��������� (� ����) ������ ���� ������, ��� ������, ��� �������� �������� �������� 
--�� ��������� ����. �������� ���� ��������� � ���� ������ ���� ������
  set @v_temp_end_date = case when dbo.usfUtils_TimeToZero(@v_end_date) 
							= dbo.usfUtils_TimeToZero(@v_start_date)
						 then dbo.usfUtils_TimeToZero(@v_end_date) 
						 when dbo.usfUtils_TimeToZero(@v_end_date) 
							> dbo.usfUtils_TimeToZero(@v_start_date)
						 then dbo.usfUtils_TimeToZero(@v_start_date)
					 end
--���� ����� ������ ������ ������ ������ ������ �� ����� - �������� �����
if @v_start_date < convert(datetime, dbo.usfUtils_TimeToValue(@v_temp_start_date, @p_start_time_norm))
 set @v_start_date = dbo.usfUtils_TimeToValue(@v_temp_start_date, @p_start_time_norm)
--���� ����� ��������� ������ ������ ��������� ������ �� ����� - �������� �����
if @v_end_date > convert(datetime, dbo.usfUtils_TimeToValue(@v_temp_end_date , @p_end_time_norm))
 set @v_end_date = dbo.usfUtils_TimeToValue(@v_temp_end_date, @p_end_time_norm)

--������ ��������
set @v_temp_value = (convert(decimal, datediff("mi",@v_start_date, @v_end_date)) / convert(decimal, 60))
--���� ���������� �������� ������ ���� - ������ ���, ����� ����
if @v_temp_value < 0 
   set @v_temp_value = 0
--�������� ���������� �������� � ����� ����� � ������
 set @v_value = @v_value + @v_temp_value
 set @i = @i + 1
end

return @v_value

END
GO

GRANT VIEW DEFINITION ON [dbo].[usfREP_EMPLOYEE_Day_Count] TO [$(db_app_user)]
GO


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (69, 'EMP_WORK_HOUR_AMOUNT_TOTAL', '��������� ���������� ������� �����')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values (69, 'EMP_WORK_HOUR_AMOUNT_TOTAL', '��������� ���������� ������� �����')
go


set identity_insert dbo.CREP_VALUE on
insert into dbo.CREP_VALUE (id, short_name, full_name)
values (70, 'EMP_WORK_HOUR_AMOUNT_HR_TOTAL', '��������� ���������� ������� ����� ��� ������ ������')
set identity_insert dbo.CREP_VALUE off
go

insert into dbo.CSYS_CONST(id, name, description)
values (70, 'EMP_WORK_HOUR_AMOUNT_HR_TOTAL', '��������� ���������� ������� ����� ��� ������ ������')
go



create index ifk_employee_id_crep_employee_hour on [dbo].[CREP_EMPLOYEE_HOUR](employee_id)
on $(fg_idx_name)
go

create index ifk_date_created_cdrv_driver_list on [dbo].[CDRV_DRIVER_LIST](date_created)
on $(fg_idx_name)
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




