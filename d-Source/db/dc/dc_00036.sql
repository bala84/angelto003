:r ./../_define.sql
:setvar dc_number 00036
:setvar dc_description "CCAR_CAR_MODEL fixed"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    24.02.2008 VLavrentiev  CCAR_CAR_MODEL fixed   
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

DECLARE ref_cursor CURSOR
   FOR
select o.name from sys.sysobjects o 
			join sys.tables r on r.object_id = o.parent_obj
			join sys.columns f on r.object_id = f.object_id 
			join sys.sysconstraints g on f.column_id = g.colid
								and o.id = g.constid
where r.name = 'CCAR_CAR_MODEL'
  and f.name = 'fuel_norm';
OPEN  ref_cursor;
DECLARE @v_object_name varchar(100)

        
FETCH NEXT FROM ref_cursor INTO @v_object_name;
WHILE (@@FETCH_STATUS <> -1)
BEGIN
 exec ('alter table dbo.CCAR_CAR_MODEL drop ' + @v_object_name)

   FETCH NEXT FROM ref_cursor INTO @v_object_name;
END;
PRINT 'The ref have been dropped';
CLOSE ref_cursor;
DEALLOCATE ref_cursor;
GO



alter table dbo.ccar_car_model
drop column fuel_norm
go


/*==============================================================*/
/* Table: CCAR_FUEL_MODEL                                       */
/*==============================================================*/
create table CCAR_FUEL_MODEL (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   fuel_type_id         numeric(38,0)        not null,
   full_norm            varchar(60)          not null default 0.0,
   car_model_id         numeric(38,0)        not null,
   constraint ccar_fuel_model_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Таблица отношений типов топлива и моделей автомобиля',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Системный статус записи',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Комментарий',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата модификации',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Дата создания',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, модифицировавший запись',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Пользователь, создавший запись',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид типа топлива',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'fuel_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Норма расхода топлива на 100 км',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'full_norm'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ид модели',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'car_model_id'
go

alter table CCAR_FUEL_MODEL
   add constraint CCAR_FUEL_MODEL_MODEL_ID_FK foreign key (car_model_id)
      references CCAR_CAR_MODEL (id)
go

alter table CCAR_FUEL_MODEL
   add constraint CCAR_FUEL_MODEL_TYPE_ID_FK foreign key (fuel_type_id)
      references CCAR_FUEL_TYPE (id)
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_CAR_MODEL] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения моделей автомобилей
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую функцию
*******************************************************************************/
()
RETURNS TABLE 
AS
RETURN 
(
	SELECT a.id
		  ,a.sys_status
		  ,a.sys_comment
		  ,a.sys_date_modified
		  ,a.sys_date_created
		  ,a.sys_user_modified
		  ,a.sys_user_created
		  ,a.short_name
		  ,a.full_name
		  ,a.mark_id
		  ,b.short_name as car_mark_name
      FROM dbo.CCAR_CAR_MODEL as a
		JOIN dbo.CCAR_CAR_MARK as b on a.mark_id = b.id	
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_CAR_MODEL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить модель автомобиля
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0) = null out
    ,@p_short_name  varchar(30)
    ,@p_full_name   varchar(60)
    ,@p_mark_id		numeric(38,0)   
    ,@p_sys_comment varchar(2000) = '-'
    ,@p_sys_user    varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'
       -- надо добавлять
  if (@p_id is null)
    begin
	   insert into
			     dbo.CCAR_CAR_MODEL 
            (short_name, full_name, mark_id, sys_comment, sys_user_created, sys_user_modified)
	   values
			(@p_short_name , @p_full_name, @p_mark_id,  @p_sys_comment, @p_sys_user, @p_sys_user)
       
	  set @p_id = scope_identity();
    end   
       
	    
 else
  -- надо править существующий
		update dbo.CCAR_CAR_MODEL set
		 short_name =  @p_short_name
        	,full_name =  @p_full_name
		,mark_id = @p_mark_id
	    	,sys_comment = @p_sys_comment
        	,sys_user_modified = @p_sys_user
		where ID = @p_id
    
  return 

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_CAR_MODEL_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о моделях автомобиля
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      22.02.2008 VLavrentiev	Добавил fuel_norm
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
SET NOCOUNT ON
  
       SELECT  id
		  ,sys_status
		  ,sys_comment
		  ,sys_date_modified
		  ,sys_date_created
		  ,sys_user_modified
		  ,sys_user_created
		  ,short_name
		  ,full_name
		  ,mark_id
		  ,car_mark_name
	FROM dbo.utfVCAR_CAR_MODEL()

	RETURN
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
