/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DB owner
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания функций в БД CSSAT
 ================================================================================== */ 

PRINT ' '
PRINT 'Creating  sfCONST...'
go


CREATE FUNCTION [dbo].[sfCONST]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция возвращает системные константы
**
**  Входные параметры:
**  @param @p_const_name
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.2     11.04.2007 VLavrentiev	Добавил обработку типов мест
** 1.1     10.04.2007 VLavrentiev	Добавил обработку типов справочников
** 1.0     06.04.2007 VLavrentiev	Добавил новую функцию
*******************************************************************************/
(
 @p_const_name nvarchar(40) 
)
RETURNS bigint
AS

BEGIN
 
	-- Declare the return variable here
	DECLARE @v_Rtrn_id bigint
            --
            -- Тип объекта
           ,@c_Mobile_Obj_Type bigint
            --
           ,@c_Stationary_Obj_Type bigint
            --
            -- Тип справочника
           ,@c_Mobile_Ref_Type bigint
            --
           ,@c_Stationary_Ref_Type bigint
            --
            -- Тип месторасположения
           ,@c_Fact_Location_Type bigint
            --
           ,@c_Jur_Location_Type bigint
            --
            -- Статус потока
           ,@c_Run_Closed bigint
            --
            -- Тип поиска - Simple_Term Search
           ,@c_ST_Search bigint
            -- Тип поиска - Prefix_Term Search
           ,@c_PT_Search bigint
            -- Тип поиска - Weight_Term - Simple_Term Search
           ,@c_WTST_Search bigint

    set @c_Mobile_Obj_Type = 1
    set @c_Stationary_Obj_Type = 2
   --
    set @c_Mobile_Ref_Type = 11
    set @c_Stationary_Ref_Type = 12
   --
    set @c_Fact_Location_Type = 21
    set @c_Jur_Location_Type = 22
   --
    set @c_Run_Closed = 4
   --
    set @c_ST_Search = 101
    set @c_PT_Search = 102
    set @c_WTST_Search = 103
    
    
      
   	set @v_Rtrn_id = 
                    case @p_const_name 
                      when 'MO_TYPE'
                      then @c_Mobile_Obj_Type
                      when 'SO_TYPE'
                      then @c_Stationary_Obj_Type
                      when 'MO_REF_TYPE'
                      then @c_Mobile_Ref_Type
                      when 'SO_REF_TYPE'
                      then @c_Stationary_Ref_Type
                      when 'FACT_LOC_TYPE'
                      then @c_Fact_Location_Type
                      when 'JUR_LOC_TYPE'
                      then @c_Jur_Location_Type
                      when 'RUN_CLOSED'
                      then @c_Run_Closed
                      when 'ST_SEARCH'
                      then @c_ST_Search 
                      when 'PT_SEARCH'
                      then @c_PT_Search 
                      when 'WTST_SEARCH'
                      then @c_WTST_Search
                      else null
                    end
	-- Return the result of the function
	RETURN @v_Rtrn_id

END
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
                    when (@p_Srch_Type = dbo.sfCONST('ST_SEARCH'))
                    then  '"'+ @p_Str + '"' 
                    when (@p_Srch_Type = dbo.sfCONST('PT_SEARCH'))
                    then  '"'+ @p_Str + '*"'   
                    when (@p_Srch_Type = dbo.sfCONST('WTST_SEARCH')) 
                    then 'ISABOUT(' + '"'+ @p_Str + '")'
                    end
       
	-- Return the result of the function
	RETURN @v_Rtrn_Stmt 

END
go

