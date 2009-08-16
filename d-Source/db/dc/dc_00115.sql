:r ./../_define.sql

:setvar dc_number 00115                  
:setvar dc_description "full text on cars and persons added#2"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    17.03.2008 VLavrentiev  full text on cars and persons added#2
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
PRINT ' '
go


insert into dbo.CSYS_CONST(id, name, description)
values(200,'ST_SEARCH','Значение для поиска по Single_Search')
go

insert into dbo.CSYS_CONST(id, name, description)
values(201,'PT_SEARCH','Значение для поиска по Prefix_Search')
go


insert into dbo.CSYS_CONST(id, name, description)
values(202,'WTST_SEARCH','Значение для поиска по WTST_Search')
go



PRINT ' '
PRINT 'Creating  sfSrchCndtn_Translate...'
go

CREATE FUNCTION [dbo].[sfSrchCndtn_Translate]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция преобразует поданные строки в Search_Condition Strings для
** Full_Text_Search
**
**  Входные параметры:
**  @param @p_const_name
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0     27.04.2007 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_Str nvarchar(1000) 
,@p_Srch_Type tinyint 
)
RETURNS nvarchar(2000)
AS

BEGIN
 
	-- Declare the return variable here
	DECLARE @v_Rtrn_Stmt nvarchar(2000)
 
 set @v_Rtrn_Stmt = case 
                    when (@p_Srch_Type = dbo.usfCONST('ST_SEARCH'))
                    then  '"'+ @p_Str + '"' 
                    when (@p_Srch_Type = dbo.usfCONST('PT_SEARCH'))
                    then  '"'+ @p_Str + '*"'   
                    when (@p_Srch_Type = dbo.usfCONST('WTST_SEARCH')) 
                    then 'ISABOUT(' + '"'+ @p_Str + '")'
                    end
       
	-- Return the result of the function
	RETURN @v_Rtrn_Stmt 

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
