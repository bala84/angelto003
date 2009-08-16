:r ./../_define.sql
:setvar dc_number 00042
:setvar dc_description "FUEL_MODEL added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0    25.02.2008 VLavrentiev  FUEL_MODEL added   
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



alter table dbo.CCAR_FUEL_TYPE
add season smallint not null
go


declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Сезон',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_TYPE', 'column', 'season'
go



insert into dbo.CSYS_CONST(id,name,description)
values(40,'WINTER_SEASON','Сезон зима')
go

insert into dbo.CSYS_CONST(id,name,description)
values(41,'SPRING_SEASON','Сезон весна')
go

insert into dbo.CSYS_CONST(id,name,description)
values(42,'SUMMER_SEASON','Сезон лето')
go

insert into dbo.CSYS_CONST(id,name,description)
values(43,'AUTUMN_SEASON','Сезон осень')
go

DECLARE ref_cursor CURSOR
   FOR
select o.name from sys.sysobjects o 
			join sys.tables r on r.object_id = o.parent_obj
			join sys.columns f on r.object_id = f.object_id 
			join sys.sysconstraints g on f.column_id = g.colid
								and o.id = g.constid
where r.name = 'CCAR_FUEL_MODEL'
  and f.name = 'full_norm';
OPEN  ref_cursor;
DECLARE @v_object_name varchar(100)

        
FETCH NEXT FROM ref_cursor INTO @v_object_name;
WHILE (@@FETCH_STATUS <> -1)
BEGIN
 exec ('alter table dbo.CCAR_FUEL_MODEL drop ' + @v_object_name)

   FETCH NEXT FROM ref_cursor INTO @v_object_name;
END;
PRINT 'The ref have been dropped';
CLOSE ref_cursor;
DEALLOCATE ref_cursor;
GO


alter table dbo.CCAR_FUEL_MODEL
drop column full_norm
go

alter table dbo.CCAR_FUEL_MODEL
add fuel_norm decimal not null default 0.0
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Норма расхода топлива',
   'user', @CurrentUser, 'table', 'CCAR_FUEL_MODEL', 'column', 'fuel_norm'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[utfVCAR_FUEL_TYPE] 
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Функция отображения типов топлива
**
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
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
		  ,b.fuel_norm
		  ,b.car_model_id
		  ,c.mark_id
		  ,d.short_name + ' - ' + c.short_name as car_mark_model_sname
		  ,a.season
      FROM dbo.CCAR_FUEL_MODEL as b
		JOIN dbo.CCAR_FUEL_TYPE as a on a.id = b.fuel_type_id
		JOIN dbo.CCAR_CAR_MODEL as c on  c.id = b.car_model_id
		JOIN dbo.CCAR_CAR_MARK as d on c.mark_id = d.id
	
)
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspVCAR_FUEL_TYPE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна извлекать данные о типах топлива
**
**  Входные параметры:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
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
		  ,fuel_norm
		  ,car_model_id
		  ,mark_id
		  ,car_mark_model_sname
		  ,case season when dbo.usfConst('WINTER_SEASON')
					   then 'Зима'
					   when dbo.usfConst('SPRING_SEASON')
					   then 'Весна'
					   when dbo.usfConst('SUMMER_SEASON')
					   then 'Лето'
					   when dbo.usfConst('AUTUMN_SEASON')
					   then 'Осень'
		  end as season
	FROM dbo.utfVCAR_FUEL_TYPE()

	RETURN
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[uspVCAR_FUEL_MODEL_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить о связь топлива с моделью
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_fuel_type_id  numeric(38,0)
    ,@p_fuel_norm     decimal = 0.0
	,@p_car_model_id  numeric(38,0)
    ,@p_sys_comment	  varchar(2000) = '-'
    ,@p_sys_user	  varchar(30) = null
)
as
begin
  set nocount on

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	 if (@p_fuel_norm is null)
	set @p_fuel_norm = 0.0

       -- надо добавлять
  
	   insert into
			     dbo.CCAR_FUEL_MODEL 
            (fuel_type_id, fuel_norm, car_model_id, sys_comment, sys_user_created, sys_user_modified)
	   select @p_fuel_type_id, @p_fuel_norm, @p_car_model_id, @p_sys_comment, @p_sys_user, @p_sys_user
		where not exists
			(
			select 1 from dbo.CCAR_FUEL_MODEL as a
			 where a.fuel_type_id = @p_fuel_type_id
			   and a.car_model_id = @p_car_model_id
			)
     
       
	    
  if (@@rowcount = 0)
  -- надо править существующий
		update dbo.CCAR_FUEL_MODEL set
		 fuel_type_id = @p_fuel_type_id
		,fuel_norm = @p_fuel_norm
		,car_model_id = @p_car_model_id
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where fuel_type_id = @p_fuel_type_id
		  and car_model_id = @p_car_model_id
    
  return  

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_FUEL_MODEL_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_FUEL_MODEL_SaveById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_FUEL_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить о тип топлива
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id				 numeric(38,0) = null out
    ,@p_short_name       varchar(30)
    ,@p_full_name        varchar(60)
    ,@p_fuel_norm		 decimal = 0.0
	,@p_car_model_id	 numeric(38,0)
    ,@p_sys_comment		 varchar(2000) = '-'
    ,@p_sys_user		 varchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     if (@p_sys_user is null)
    set @p_sys_user = user_name()
	 if (@p_sys_comment is null)
	set @p_sys_comment = '-'

	set @v_Error = 0
    set @v_TrancountOnEntry = @@tranCount
  if (@@tranCount = 0)
    begin transaction 
       -- надо добавлять
  if (@p_id is null)
    begin
			insert into
			     dbo.CCAR_FUEL_TYPE 
					(short_name, full_name, sys_comment, sys_user_created, sys_user_modified)
			values
					(@p_short_name , @p_full_name, @p_sys_comment, @p_sys_user, @p_sys_user)
       
			set @p_id = scope_identity();
			
			exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_SaveById
				 @p_fuel_type_id = @p_id
				,@p_fuel_norm = @p_fuel_norm
				,@p_car_model_id = @p_car_model_id
				,@p_sys_comment = @p_sys_comment
				,@p_sys_user = @p_sys_user

			if (@v_Error > 0)
				begin 
					if (@@tranCount > @v_TrancountOnEntry)
						rollback
					return @v_Error
				end 


    end   
       
	    
 else
	begin
  -- надо править существующий
		update dbo.CCAR_FUEL_TYPE set
		 short_name =  @p_short_name
        ,full_name =  @p_full_name
		,sys_comment = @p_sys_comment
        ,sys_user_modified = @p_sys_user
		where ID = @p_id

		exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_SaveById
				 @p_fuel_type_id = @p_id
				,@p_fuel_norm = @p_fuel_norm
				,@p_car_model_id = @p_car_model_id
				,@p_sys_comment = @p_sys_comment
				,@p_sys_user = @p_sys_user

		if (@v_Error > 0)
			begin 
				if (@@tranCount > @v_TrancountOnEntry)
					rollback
				return @v_Error
			end 
    end

   
  if (@@tranCount > @v_TrancountOnEntry)
    commit


  return  

end
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspVCAR_FUEL_MODEL_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из связочной таблицы типов топлива и модели
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_fuel_type_id          numeric(38,0)
    ,@p_car_model_id		  numeric(38,0) 
)
as
begin
  set nocount on

	delete
	from dbo.CCAR_FUEL_MODEL
	where fuel_type_id = @p_fuel_type_id
	  and car_model_id = @p_car_model_id
    
  return 

end
GO

GRANT EXECUTE ON [dbo].[uspVCAR_FUEL_MODEL_DeleteById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspVCAR_FUEL_MODEL_DeleteById] TO [$(db_app_user)]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[uspVCAR_FUEL_TYPE_DeleteById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна удалить строку из типов топлива
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.02.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_id          numeric(38,0)
    ,@p_car_model_id		  numeric(38,0) 
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

   set @v_Error = 0
   set @v_TrancountOnEntry = @@tranCount
   
   if (@@tranCount = 0)
    begin transaction 


   exec @v_Error = 
				 dbo.uspVCAR_FUEL_MODEL_DeleteById
				 @p_fuel_type_id = @p_id
				,@p_car_model_id = @p_car_model_id

   if (@v_Error > 0)
	begin 
		if (@@tranCount > @v_TrancountOnEntry)
			rollback
		return @v_Error
	end 

	delete
	from dbo.CCAR_FUEL_TYPE
	where id = @p_id
   
    if (@@tranCount > @v_TrancountOnEntry)
    commit

  
 
  return 

end
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
