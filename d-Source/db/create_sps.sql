/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DB owner
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания процедур в БД CSSAT
 ================================================================================== */ 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


PRINT ' '
PRINT 'Creating  spCLOC_LOCATION_LINK_SaveById...'
go

create procedure [dbo].[spCLOC_LOCATION_LINK_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить сведения в таблицу связи мест и объектов в системе
**
**  Входные параметры:
    @param p_id       
    @param p_LOCATION_ID  
    @param p_LOCATION_TYPE_ID 
    @param p_TABLE_NAME
    @param p_RECORD_ID 
    @param p_IS_DEFAULT
    @param p_sys_comment 
    @param p_sys_user 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      11.04.2007 VLavrentiev	Изменил обработку update
** 1.0      11.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_LOCATION_ID         bigint,
    @p_LOCATION_TYPE_ID    bigint,
    @p_TABLE_NAME         nvarchar(30),
    @p_RECORD_ID          bigint,
    @p_IS_DEFAULT         bit = 0,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin

   set nocount on
  
  if (@p_sys_user is null)
   set @p_sys_user = user_name()

      	insert into
	  dbo.CLOC_LOCATION_LINK 
              (LOCATION_ID, LOCATION_TYPE_ID , IS_DEFAULT
               ,TABLE_NAME, RECORD_ID,sys_comment, sys_user_created)
         values( @p_LOCATION_ID, @p_LOCATION_TYPE_ID , @p_IS_DEFAULT
               ,@p_TABLE_NAME, @p_RECORD_ID,@p_sys_comment, @p_sys_user)  
		
/*
   if (@@rowcount = 0)

	  update dbo.CLOC_LOCATION_LINK set
	      CLOC_LOCATION_ID = @p_CLOC_LOCATION_ID
         ,IS_DEFAULT = @p_IS_DEFAULT
         ,sys_comment = @p_sys_comment 
         ,sys_user_modified = @p_sys_user 
		where RECORD_ID = @p_RECORD_ID
          and TABLE_NAME = @p_TABLE_NAME
          and CLOC_LOCATION_TYPE_ID = @p_CLOC_LOCATION_TYPE_ID  
          and sys_status = 1*/

end
go

GRANT EXECUTE ON [dbo].[spCLOC_LOCATION_LINK_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCLOC_LOCATION_LINK_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spCOBJ_OBJECT_SaveById...'
go

create procedure [dbo].[spCOBJ_OBJECT_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить запись в связочной таблице 
** объектов и групп для объектов
**
**  Входные параметры:
**  @param p_id, 
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      03.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id       bigint = null out,
    @p_PIN      nvarchar(10),
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on
    if (@p_sys_user is null)
    set @p_sys_user = user_name()
    -- надо добавлять
	    insert into
			dbo.COBJ_OBJECT 
            (PIN, sys_comment, sys_user_created)
	    values
	    (@p_PIN, @p_sys_comment, @p_sys_user)

         set @p_id = SCOPE_IDENTITY();
  return
   
end
go


GRANT EXECUTE ON [dbo].[spCOBJ_OBJECT_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCOBJ_OBJECT_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spCPRT_JOB_TITLE_SaveById...'
go

create PROCEDURE [dbo].[spCPRT_JOB_TITLE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ID bigint  = null out
,@p_NAME nvarchar(60)
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
 AS
  set nocount on

  if (@p_sys_user is null)
    set @p_sys_user = user_name()


 if (@p_id is null)
   begin

     INSERT INTO dbo.CPRT_JOB_TITLE
     (NAME, SYS_COMMENT, SYS_USER_CREATED)
     VALUES 
     (@p_NAME, @p_sys_comment, @p_sys_user)
   
     SET @p_id = scope_identity()

    end
else
 
 UPDATE dbo.CPRT_JOB_TITLE
 SET 
  NAME = @p_NAME
 ,SYS_COMMENT = @p_sys_comment
 ,SYS_USER_MODIFIED = @p_sys_user
 WHERE ID = @p_id
 and sys_status = 1

RETURN 
go

GRANT EXECUTE ON [dbo].[spCPRT_JOB_TITLE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCPRT_JOB_TITLE_SaveById] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating  spCPRT_JOB_TITLE_SelectAll...'
go

create PROCEDURE [dbo].[spCPRT_JOB_TITLE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
 AS
  set nocount on

 SELECT ID,NAME
 FROM dbo.CPRT_JOB_TITLE
 where sys_status = 1
 order by NAME asc

RETURN 
go


GRANT EXECUTE ON [dbo].[spCPRT_JOB_TITLE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCPRT_JOB_TITLE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVCFG_CFG_TYPE_SelectAll...'
go

create PROCEDURE [dbo].[spVCFG_CFG_TYPE_SelectAll]
/******************************************************************************
** Description
** Получение всех типов конфигураций блоков
**-----------------------------------------------------------------------------
** Version  Date         Author 		Comments
**-----------------------------------------------------------------------------
** 1.0      27.04.2007   OLobanov	    Создание процедуры
*******************************************************************************/
AS
BEGIN

  SET NOCOUNT ON

  SELECT 
    vct.ID,
    vct.FAMILY_ID,
    vf.code AS FAMILY_CODE,
    vf.description AS FAMILY_DESCRIPTION,
    vct.FIRMWARE_ID,
    vi.code AS FIRMWARE_CODE,
    vi.description AS FIRMWARE_DESCRIPTION,
    vct.MODIFICATION_ID,
    vm.code as MODIFICATION_CODE,
    vm.description AS MODIFICATION_DESCRIPTION,
    vct.TYPE_ID,
    vt.code AS TYPE_CODE,
    vt.description AS TYPE_DESCRIPTION,
    vct.VERSION_ID,
    vv.name AS VERSION_NAME,
    vv.description AS VERSION_DESCRIPTION,
    vct.SYS_DATE_MODIFIED, 
    vct.SYS_DATE_CREATED, 
    vct.SYS_USER_MODIFIED, 
    vct.SYS_USER_CREATED,
    vct.SYS_COMMENT
  FROM 
    dbo.VCFG_CFG_TYPE vct
    LEFT JOIN dbo.VBCK_FAMILY vf ON vct.FAMILY_ID = vf.ID
    LEFT JOIN dbo.VBCK_FIRMWARE vi ON vct.FIRMWARE_ID = vi.ID
    LEFT JOIN dbo.VBCK_MODIFICATION vm ON vct.MODIFICATION_ID = vm.id
    LEFT JOIN dbo.VBCK_TYPE vt ON vct.TYPE_ID = vt.ID
    LEFT JOIN dbo.VDEV_VERSION vv ON vct.VERSION_ID = vv.ID

END
go

GRANT EXECUTE ON [dbo].[spVCFG_CFG_TYPE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCFG_CFG_TYPE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVCON_CONTACT_LINK_SaveByParty_Id...'
go


create procedure [dbo].[spVCON_CONTACT_LINK_SaveByParty_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура вставляет контакт для физ. и юр. лиц
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      18.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_CONTACT_ID      bigint
,@p_CONTACT_TYPE_ID bigint
,@p_PARTY_ID        bigint
,@p_SORT_FIELD      bigint 
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
as
begin
  
  set nocount on
  
     if (@p_sys_user is null)
       set @p_sys_user = user_name()

     declare @v_table_name nvarchar(30)
       set  @v_table_name = 'dbo.CPRT_PARTY'

 insert into dbo.CCON_CONTACT_LINK 
           (CONTACT_ID, TABLE_NAME, RECORD_ID, CONTACT_TYPE_ID ,
            SORT_FIELD, SYS_COMMENT, SYS_USER_CREATED)
  select @p_CONTACT_ID, @v_table_name, @p_PARTY_ID, @p_CONTACT_TYPE_ID,
         @p_SORT_FIELD, @p_sys_comment, @p_sys_user
   where not exists
         (select TOP(1) 1 from dbo.CCON_CONTACT_LINK
           where CONTACT_ID = @p_CONTACT_ID
                  and TABLE_NAME = @v_table_name
                  and RECORD_ID = @p_PARTY_ID
                  and CONTACT_TYPE_ID = @p_CONTACT_TYPE_ID)

 if (@@rowcount = 0)
 
   

  update dbo.CCON_CONTACT_LINK
     set SORT_FIELD = @p_SORT_FIELD
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where CONTACT_ID = @p_CONTACT_ID
     and TABLE_NAME = @v_table_name
     and RECORD_ID = @p_PARTY_ID
     and CONTACT_TYPE_ID = @p_CONTACT_TYPE_ID

       
  
  return
   
end
go

GRANT EXECUTE ON [dbo].[spVCON_CONTACT_LINK_SaveByParty_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCON_CONTACT_LINK_SaveByParty_Id] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVCON_CONTACT_SaveById...'
go


create procedure [dbo].[spVCON_CONTACT_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура вставляет контакт
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      18.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id      bigint = null out
,@p_DESCRIPTION nvarchar(4000)
,@p_CONTACT_TYPE_ID bigint = null
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
as
begin
  
  set nocount on
  
     if (@p_sys_user is null)
       set @p_sys_user = user_name()

  if (@p_id is null)
    begin

      insert into dbo.CCON_CONTACT 
           (DESCRIPTION, CONTACT_TYPE_ID, SYS_COMMENT, SYS_USER_CREATED)
      values (@P_DESCRIPTION, @p_CONTACT_TYPE_ID, @p_sys_comment, @p_sys_user)
  
      set @p_id = scope_identity()
   end
  else             


  update dbo.CCON_CONTACT
     set DESCRIPTION = @P_DESCRIPTION
        ,CONTACT_TYPE_ID = @p_CONTACT_TYPE_ID
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id

  return
   
end

go

GRANT EXECUTE ON [dbo].[spVCON_CONTACT_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCON_CONTACT_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVCON_CONTACT_SelectByParty_Id...'
go

create procedure [dbo].[spVCON_CONTACT_SelectByParty_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура возвращает контакты для для физ. и юр. лиц
**
**  Входные параметры:
**  @param @p_CPRT_PARTY_ID 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      18.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
  @p_PARTY_ID       bigint
)
as
begin

  set nocount on

  declare @v_table_name nvarchar(30)
     set  @v_table_name = 'dbo.CPRT_PARTY'
  
    select vcl.CONTACT_ID
          ,vcl.RECORD_ID as PARTY_ID
          ,vcl.SORT_FIELD
          ,vc.CONTACT_TYPE_ID
      from dbo.VCON_CONTACT_LINK vcl
       join dbo.VCON_CONTACT vc
         on vcl.CONTACT_ID = vc.id
      where RECORD_ID = @p_PARTY_ID 
        and TABLE_NAME = @v_table_name
      order by SORT_FIELD asc

  return
   
end

go

GRANT EXECUTE ON [dbo].[spVCON_CONTACT_SelectByParty_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCON_CONTACT_SelectByParty_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVCON_CONTACT_TYPE_SaveById...'
go


create procedure [dbo].[spVCON_CONTACT_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип контакта
**---------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      18.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint out,
    @p_NAME        nvarchar(100),
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  
  if (@p_sys_user is null)
   set @p_sys_user = user_name()

   if (@p_id is null)
     -- надо добавлять
    begin
	   insert into
		dbo.CCON_CONTACT_TYPE 
            (NAME, sys_comment, sys_user_created)
	   values
	    (@p_NAME, @p_sys_comment, @p_sys_user)

      set @p_id = scope_identity()
    end
  else

  -- надо править существующий
		update dbo.CCON_CONTACT_TYPE set
		NAME =  @p_NAME,
                sys_comment = @p_sys_comment,
              sys_user_modified = @p_sys_user
		where ID = @p_id



end
go

GRANT EXECUTE ON [dbo].[spVCON_CONTACT_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCON_CONTACT_TYPE_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVAGR_AGREEMENT_ROLE_SelectById...'
go


create PROCEDURE [dbo].[spVAGR_AGREEMENT_ROLE_SelectById]
/******************************************************************************
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      26.04.2007   OLobanov	    Создание процедуры
*******************************************************************************/
@p_id bigint
AS
BEGIN
  SELECT id,
         name,
         sys_status,
         sys_date_created,
         sys_user_created,
         sys_date_modified,
         sys_user_modified,
         sys_comment
  FROM dbo.VAGR_Agreement_Role
  WHERE id = @p_id
END
go

GRANT EXECUTE ON [dbo].[spVAGR_AGREEMENT_ROLE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVAGR_AGREEMENT_ROLE_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVAGR_TARIFF_PLAN_SelectAll...'
go


create PROCEDURE [dbo].[spVAGR_TARIFF_PLAN_SelectAll]
/******************************************************************************
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      26.04.2007   OLobanov	    Создание процедуры
*******************************************************************************/
AS
BEGIN
  SELECT [ID]
        ,[SYS_STATUS]
        ,[SYS_COMMENT]
        ,[SYS_DATE_MODIFIED]
        ,[SYS_DATE_CREATED]
        ,[SYS_USER_MODIFIED]
        ,[SYS_USER_CREATED]
        ,[NAME]
        ,[START_DATE]
        ,[END_DATE]
        ,[CHARGE]
  FROM [dbo].[VAGR_TARIFF_PLAN]
END
go


GRANT EXECUTE ON [dbo].[spVAGR_TARIFF_PLAN_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVAGR_TARIFF_PLAN_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVAGR_TARIFF_PLAN_SelectById...'
go

create PROCEDURE [dbo].[spVAGR_TARIFF_PLAN_SelectById]
/******************************************************************************
** Description:
** Процедура возвращает описание заданного тарифа
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
@p_id bigint
AS
BEGIN
  SELECT [ID]
        ,[SYS_STATUS]
        ,[SYS_COMMENT]
        ,[SYS_DATE_MODIFIED]
        ,[SYS_DATE_CREATED]
        ,[SYS_USER_MODIFIED]
        ,[SYS_USER_CREATED]
        ,[NAME]
        ,[START_DATE]
        ,[END_DATE]
        ,[CHARGE]
  FROM [dbo].[VAGR_TARIFF_PLAN]
  WHERE id = @p_id
END
go

GRANT EXECUTE ON [dbo].[spVAGR_TARIFF_PLAN_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVAGR_TARIFF_PLAN_SelectById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVLOC_LOCATION_SaveById...'
go

create procedure [dbo].[spVLOC_LOCATION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить местоположение
**
**  Входные параметры:
    @param p_id       
    @param p_COUNTRY_ID  
    @param p_STATE_ID 
    @param p_SETTLEMENT_ID
    @param p_DISTRICT_ID 
    @param p_LOCATION_STRING 
    @param p_ZIP_CODE 
    @param p_HOUSE  
    @param p_BUILDING 
    @param p_STRUCTURE 
    @param p_DOORWAY 
    @param p_DOORWAY_CODE 
    @param p_FLAT 
    @param p_ROOM 
    @param p_NOTES 
    @param p_EXTERNAL_CODE
    @param p_sys_comment 
    @param p_sys_user 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_id               bigint = null out,
	   @p_COUNTRY_ID  bigint = null,
	   @p_STATE_ID    bigint = null,
    @p_SETTLEMENT_ID bigint = null,
    @p_DISTRICT_ID   bigint = null,
    @p_LOCATION_STRING    nvarchar(256) = null,
    @p_ZIP_CODE           nvarchar(30) = null,
    @p_HOUSE              nvarchar(10) = null,
    @p_BUILDING           nvarchar(30) = null,
    @p_STRUCTURE          nvarchar(30) = null,
    @p_DOORWAY            nvarchar(10) = null,
    @p_DOORWAY_CODE       nvarchar(10) = null, 
    @p_FLAT               nvarchar(10) = null, 
    @p_ROOM               nvarchar(10) = null, 
    @p_NOTES              nvarchar(256) = null,     
    @p_EXTERNAL_CODE      nvarchar(30) = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  
  if (@p_sys_user is null)
   set @p_sys_user = user_name()


  if (@p_id is null)
    begin 
      insert into
			   dbo.CLOC_LOCATION 
            (COUNTRY_ID ,STATE_ID ,SETTLEMENT_ID
            ,DISTRICT_ID,LOCATION_STRING
            ,ZIP_CODE ,HOUSE ,BUILDING ,STRUCTURE ,DOORWAY 
            ,DOORWAY_CODE ,FLAT ,ROOM ,NOTES ,EXTERNAL_CODE
            ,sys_comment, sys_user_created)
		    values
			  (@p_COUNTRY_ID ,@p_STATE_ID ,@p_SETTLEMENT_ID
            ,@p_DISTRICT_ID ,@p_LOCATION_STRING
            ,@p_ZIP_CODE ,@p_HOUSE ,@p_BUILDING ,@p_STRUCTURE ,@p_DOORWAY 
            ,@p_DOORWAY_CODE ,@p_FLAT ,@p_ROOM ,@p_NOTES ,@p_EXTERNAL_CODE
            ,@p_sys_comment, @p_sys_user)
    
      set @p_id = scope_identity()
   end
  else 

  -- надо править существующий
		update dbo.CLOC_LOCATION set
	    COUNTRY_ID = @p_COUNTRY_ID  
	   ,STATE_ID = @p_STATE_ID 
    ,SETTLEMENT_ID = @p_SETTLEMENT_ID
    ,DISTRICT_ID = @p_DISTRICT_ID 
    ,LOCATION_STRING = @p_LOCATION_STRING 
    ,ZIP_CODE = @p_ZIP_CODE 
    ,HOUSE = @p_HOUSE  
    ,BUILDING = @p_BUILDING 
    ,STRUCTURE = @p_STRUCTURE 
    ,DOORWAY = @p_DOORWAY 
    ,DOORWAY_CODE = @p_DOORWAY_CODE 
    ,FLAT = @p_FLAT 
    ,ROOM = @p_ROOM 
    ,NOTES = @p_NOTES 
    ,EXTERNAL_CODE = @p_EXTERNAL_CODE
    ,sys_comment = @p_sys_comment 
    ,sys_user_modified = @p_sys_user 
		where ID = @p_id


end
go

GRANT EXECUTE ON [dbo].[spVLOC_LOCATION_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVLOC_LOCATION_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spCLOC_LOCATION_STRING_SaveById...'
go


create procedure [dbo].[spCLOC_LOCATION_STRING_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить привязанное местположение к записи в БД
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_LOCATION_ID           bigint out,
    @p_LOCATION_TYPE_ID      bigint = null, 
    @p_TABLE_NAME                 nvarchar(30), 
    @p_RECORD_ID                  bigint, 
	   @p_COUNTRY_ID  bigint = null,
	   @p_STATE_ID    bigint = null,
    @p_SETTLEMENT_ID bigint = null,
    @p_DISTRICT_ID   bigint = null,
    @p_LOCATION_STRING    nvarchar(256) = null,
    @p_ZIP_CODE           nvarchar(30) = null,
    @p_HOUSE              nvarchar(10) = null,
    @p_BUILDING           nvarchar(30) = null,
    @p_STRUCTURE          nvarchar(30) = null,
    @p_DOORWAY            nvarchar(10) = null,
    @p_DOORWAY_CODE       nvarchar(10) = null, 
    @p_FLAT               nvarchar(10) = null, 
    @p_ROOM               nvarchar(10) = null, 
    @p_NOTES              nvarchar(256) = null,     
    @p_EXTERNAL_CODE      nvarchar(30) = null,
    @p_IS_DEFAULT         bit = 0,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

  
  if (@p_sys_user is null)
   set @p_sys_user = user_name()
  if (@p_LOCATION_TYPE_ID is null)
   exec @p_LOCATION_TYPE_ID = dbo.sfCONST 
                                              @p_const_name = 'FACT_LOC_TYPE'
  -- надо править существующий
    if (@@tranCount = 0)
      begin transaction 		
      
      
      exec @v_Error =  dbo.spVLOC_LOCATION_SaveById
       @p_id = @p_LOCATION_ID out
  	   ,@p_COUNTRY_ID = @p_COUNTRY_ID  
	     ,@p_STATE_ID = @p_STATE_ID 
      ,@p_SETTLEMENT_ID = @p_SETTLEMENT_ID
      ,@p_DISTRICT_ID = @p_DISTRICT_ID 
      ,@p_LOCATION_STRING = @p_LOCATION_STRING 
      ,@p_ZIP_CODE = @p_ZIP_CODE 
      ,@p_HOUSE  = @p_HOUSE  
      ,@p_BUILDING = @p_BUILDING 
      ,@p_STRUCTURE = @p_STRUCTURE 
      ,@p_DOORWAY = @p_DOORWAY 
      ,@p_DOORWAY_CODE = @p_DOORWAY_CODE 
      ,@p_FLAT  = @p_FLAT 
      ,@p_ROOM = @p_ROOM      
      ,@p_NOTES = @p_NOTES 
      ,@p_EXTERNAL_CODE = @p_EXTERNAL_CODE
      ,@p_sys_comment= @p_sys_comment 
      ,@p_sys_user = @p_sys_user 

     if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
           rollback
         return @v_Error
       end

      
       exec @v_Error =  dbo.spCLOC_LOCATION_LINK_SaveById
        @p_LOCATION_ID = @p_LOCATION_ID
	      ,@p_LOCATION_TYPE_ID = @p_LOCATION_TYPE_ID
       ,@p_TABLE_NAME = @p_TABLE_NAME
       ,@p_RECORD_ID = @p_RECORD_ID
       ,@p_IS_DEFAULT  = @p_IS_DEFAULT
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

      if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
           rollback
         return @v_Error
       end 
    if (@@tranCount > @v_TrancountOnEntry)
     commit
 
   return    

end
go

GRANT EXECUTE ON [dbo].[spCLOC_LOCATION_STRING_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCLOC_LOCATION_STRING_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVLOC_LOCATION_TYPE_SaveById...'
go


create procedure [dbo].[spVLOC_LOCATION_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить тип местоположения
**
**  Входные параметры:
	@param p_id       
	@param p_FULL_NAME  
	@param p_SHORT_NAME 
    @param p_CODE 
    @param p_sys_comment 
    @param p_sys_user 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      11.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_id          bigint = null out,
	   @p_FULL_NAME   nvarchar(256),
	   @p_SHORT_NAME  nvarchar(30)=  null,
    @p_CODE        nvarchar(30) = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  
  if (@p_sys_user is null)
   set @p_sys_user = user_name()

if (@p_id is null)
   begin
     		  insert into
			 dbo.CLOC_LOCATION_TYPE 
   (FULL_NAME, SHORT_NAME, CODE ,sys_comment, sys_user_created)
		  values
			(@p_FULL_NAME, @p_SHORT_NAME, @p_CODE ,@p_sys_comment, @p_sys_user)

   set @p_id = scope_identity()

   end
else
  -- надо править существующий
		update dbo.CLOC_LOCATION_TYPE set
		FULL_NAME =  @p_FULL_NAME,
		SHORT_NAME = @p_SHORT_NAME,
        CODE = @p_CODE,
        sys_comment = @p_sys_comment,
        sys_user_modified = @p_sys_user
		where ID = @p_id


end
go

GRANT EXECUTE ON [dbo].[spVLOC_LOCATION_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVLOC_LOCATION_TYPE_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVLOC_STATE_SaveById...'
go

create procedure [dbo].[spVLOC_STATE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить адм. округ страны
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0     20.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	@p_id                   bigint = null out,
 @p_COUNTRY_ID      bigint,
 @p_ABBREVIATION_ID bigint,
	@p_Name                 nvarchar(256),
 @p_EXTERNAL_CODE        nvarchar(30) = null,
 @p_ZIP_CODE             nvarchar(30) = null,
 @p_sys_comment          nvarchar(2000) = null,
 @p_sys_user             nvarchar(30) = null
)
as
begin

  set nocount on

    if (@p_sys_user is null)
    set @p_sys_user = user_name()


 if (@p_id is null)
  begin	
   	insert into
			  dbo.CLOC_STATE 
            ( COUNTRY_ID, ABBREVIATION_ID
             ,Name, EXTERNAL_CODE, ZIP_CODE
             ,sys_comment, sys_user_created)
	  	values
			( @p_COUNTRY_ID, @p_ABBREVIATION_ID
    ,@p_Name, @p_EXTERNAL_CODE, @p_ZIP_CODE
    ,@p_sys_comment, @p_sys_user)

       set @p_id = scope_identity()
  end

   -- надо править существующий
		update dbo.CLOC_STATE set
   COUNTRY_ID = @p_COUNTRY_ID
  ,ABBREVIATION_ID = @p_ABBREVIATION_ID 
		,Name =  @p_Name
  ,EXTERNAL_CODE = @p_EXTERNAL_CODE
  ,ZIP_CODE = @p_ZIP_CODE
  ,sys_comment = @p_sys_comment
  ,sys_user_modified = @p_sys_user
		where ID = @p_id
  

  return

end
go

GRANT EXECUTE ON [dbo].[spVLOC_STATE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVLOC_STATE_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spCPRT_JOB_TITLE_SelectById...'
go

create PROCEDURE [dbo].[spCPRT_JOB_TITLE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
 AS
  set nocount on
 SELECT ID,NAME
 FROM dbo.CPRT_JOB_TITLE
 WHERE ID = @p_id
 and sys_status = 1
RETURN 
go

GRANT EXECUTE ON [dbo].[spCPRT_JOB_TITLE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCPRT_JOB_TITLE_SelectById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spCPRT_PARTY_SaveById...'
go

CREATE procedure [dbo].[spCPRT_PARTY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**  Входные параметры:
**  @param p_id, 
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      27.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	@p_id       bigint out,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on
  if (@p_sys_user is null)
    set @p_sys_user = user_name()
    -- надо добавлять
		insert into
			dbo.CPRT_PARTY 
            (sys_comment, sys_user_created)
		values
			(@p_sys_comment, @p_sys_user)

         set @p_id = SCOPE_IDENTITY();

  return
   
end
go

GRANT EXECUTE ON [dbo].[spCPRT_PARTY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spCPRT_PARTY_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVBCK_BLOCK_SaveById...'
go


create PROCEDURE [dbo].[spVBCK_BLOCK_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      03.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ID bigint = null out 
,@p_DECODED_CODE nvarchar(100) = null 
,@p_BLOCK_NUMBER nvarchar(30)
,@p_CONFIGURATION_CODE nvarchar(250)  = null
,@p_ENCODED_CODE nvarchar(250)  = null
,@p_SIM_CARD_CODE nvarchar(50) = null
,@p_LOGICAL_NUMBER_SMS1 nvarchar(20) = null
,@p_LOGICAL_NUMBER_SMS2 nvarchar(20) = null
,@p_LOGICAL_NUMBER_DATA1 nvarchar(20) = null
,@p_LOGICAL_NUMBER_DATA2 nvarchar(20) = null
,@p_LOGICAL_IP_ADRESS1 nvarchar(20) = null
,@p_LOGICAL_IP_ADRESS2 nvarchar(20) = null
,@p_ALARM_NUMBER_SMS1 nvarchar(20) = null
,@p_ALARM_NUMBER_SMS2 nvarchar(20) = null
,@p_ALARM_NUMBER_DATA1 nvarchar(20) = null
,@p_ALARM_NUMBER_DATA2 nvarchar(20) = null
,@p_ALARM_IP_ADRESS1 nvarchar(20) = null
,@p_ALARM_IP_ADRESS2 nvarchar(20) = null
,@p_INSTALL_DATE datetime = null
,@p_IS_MAIN bit = 0
,@p_CFG_TEMPLATE_ID bigint = null
,@p_GUARD_SYSTEM_ID bigint = null
,@p_PLACEMENT_ID bigint = null
,@p_CFG_TYPE_ID bigint = null
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
,@p_MOBILE_OBJECT_ID bigint = null
)
 AS
  SET NOCOUNT ON
  
  if (@p_sys_user is null)
    set @p_sys_user = user_name()


if (@p_id is null)
 begin
    INSERT INTO dbo.BBCK_BLOCK
( DECODED_CODE ,BLOCK_NUMBER ,CONFIGURATION_CODE ,ENCODED_CODE 
 ,SIM_CARD_CODE ,LOGICAL_NUMBER_SMS1 ,LOGICAL_NUMBER_SMS2
,LOGICAL_NUMBER_DATA1 ,LOGICAL_NUMBER_DATA2 ,LOGICAL_IP_ADRESS1
,LOGICAL_IP_ADRESS2 ,ALARM_NUMBER_SMS1 ,ALARM_NUMBER_SMS2
,ALARM_NUMBER_DATA1 ,ALARM_NUMBER_DATA2 ,ALARM_IP_ADRESS1 
,ALARM_IP_ADRESS2 ,INSTALL_DATE ,IS_MAIN ,CFG_TEMPLATE_ID 
,GUARD_SYSTEM_ID  ,PLACEMENT_ID ,CFG_TYPE_ID 
,SYS_COMMENT ,SYS_USER_CREATED, MOBILE_OBJECT_ID
)
 VALUES 
( @p_DECODED_CODE ,@p_BLOCK_NUMBER ,@p_CONFIGURATION_CODE ,@p_ENCODED_CODE
,@p_SIM_CARD_CODE ,@p_LOGICAL_NUMBER_SMS1 ,@p_LOGICAL_NUMBER_SMS2
,@p_LOGICAL_NUMBER_DATA1 ,@p_LOGICAL_NUMBER_DATA2 ,@p_LOGICAL_IP_ADRESS1
,@p_LOGICAL_IP_ADRESS2 ,@p_ALARM_NUMBER_SMS1 ,@p_ALARM_NUMBER_SMS2
,@p_ALARM_NUMBER_DATA1 ,@p_ALARM_NUMBER_DATA2 ,@p_ALARM_IP_ADRESS1 
,@p_ALARM_IP_ADRESS2  ,@p_INSTALL_DATE ,@p_IS_MAIN ,@p_CFG_TEMPLATE_ID 
,@p_GUARD_SYSTEM_ID  ,@p_PLACEMENT_ID ,@p_CFG_TYPE_ID 
,@p_sys_comment ,@p_sys_user, @p_MOBILE_OBJECT_ID
)
  SET @p_id = scope_identity()
 end

else
 
 UPDATE dbo.BBCK_BLOCK
 SET 
 DECODED_CODE = @p_DECODED_CODE
,BLOCK_NUMBER = @p_BLOCK_NUMBER
,CONFIGURATION_CODE = @p_CONFIGURATION_CODE
,ENCODED_CODE = @p_ENCODED_CODE
,SIM_CARD_CODE = @p_SIM_CARD_CODE
,LOGICAL_NUMBER_SMS1 = @p_LOGICAL_NUMBER_SMS1
,LOGICAL_NUMBER_SMS2 = @p_LOGICAL_NUMBER_SMS2
,LOGICAL_NUMBER_DATA1 = @p_LOGICAL_NUMBER_DATA1
,LOGICAL_NUMBER_DATA2 = @p_LOGICAL_NUMBER_DATA2
,LOGICAL_IP_ADRESS1 = @p_LOGICAL_IP_ADRESS1
,LOGICAL_IP_ADRESS2 = @p_LOGICAL_IP_ADRESS2
,ALARM_NUMBER_SMS1 = @p_ALARM_NUMBER_SMS1
,ALARM_NUMBER_SMS2 = @p_ALARM_NUMBER_SMS2
,ALARM_NUMBER_DATA1 = @p_ALARM_NUMBER_DATA1
,ALARM_NUMBER_DATA2 = @p_ALARM_NUMBER_DATA2
,ALARM_IP_ADRESS1 = @p_ALARM_IP_ADRESS1 
,ALARM_IP_ADRESS2 = @p_ALARM_IP_ADRESS2 
,INSTALL_DATE = @p_INSTALL_DATE
,IS_MAIN = @p_IS_MAIN
,CFG_TEMPLATE_ID = @p_CFG_TEMPLATE_ID 
,GUARD_SYSTEM_ID = @p_GUARD_SYSTEM_ID 
,PLACEMENT_ID = @p_PLACEMENT_ID 
,CFG_TYPE_ID = @p_CFG_TYPE_ID 
,SYS_COMMENT = @p_sys_comment
,SYS_USER_MODIFIED = @p_sys_user
,MOBILE_OBJECT_ID = @p_MOBILE_OBJECT_ID
 WHERE ID = @p_id


RETURN 
go

GRANT EXECUTE ON [dbo].[spVBCK_BLOCK_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVBCK_BLOCK_SaveById] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating  spVCFG_SIM_CARD_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVCFG_SIM_CARD_SelectAll]
/******************************************************************************
** Description:
** Процедура возвращает справочник сим-карт на блоке
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
AS
BEGIN
  SELECT ID, 
         DATA_NUMBER, 
         SMS_CENTER_NUMBER, 
         ISSA_PASSWORD, 
         MOBILE_OPERATOR_ID,
         MOBILE_OPERATOR_NAME,
         VOICE_NUMBER,
         SYS_STATUS, 
         SYS_COMMENT, 
         SYS_DATE_CREATED, 
         SYS_DATE_MODIFIED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED 
  FROM   dbo.VCFG_SIM_CARD 
END
go

GRANT EXECUTE ON [dbo].[spVCFG_SIM_CARD_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCFG_SIM_CARD_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVCFG_SIM_CARD_SelectByID...'
go

CREATE PROCEDURE [dbo].[spVCFG_SIM_CARD_SelectByID]
/******************************************************************************
** Description:
** Процедура возвращает заданную сим-карту
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
@p_id bigint
AS
BEGIN
  SELECT ID, 
         DATA_NUMBER, 
         SMS_CENTER_NUMBER, 
         ISSA_PASSWORD, 
         MOBILE_OPERATOR_ID,
         MOBILE_OPERATOR_NAME,
         VOICE_NUMBER,
         SYS_STATUS, 
         SYS_COMMENT, 
         SYS_DATE_CREATED, 
         SYS_DATE_MODIFIED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED 
  FROM   dbo.VCFG_SIM_CARD 
  WHERE id = @p_id
END
go

GRANT EXECUTE ON [dbo].[spVCFG_SIM_CARD_SelectByID] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVCFG_SIM_CARD_SelectByID] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVAGR_AGREEMENT_ROLE_SelectAll...'
go


CREATE PROCEDURE [dbo].[spVAGR_AGREEMENT_ROLE_SelectAll]
/******************************************************************************
** Description:
** Процедура возвращает список ролей представителей
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
AS
BEGIN
  SELECT id,
         name,
         sys_status,
         sys_date_created,
         sys_user_created,
         sys_date_modified,
         sys_user_modified,
         sys_comment
  FROM dbo.VAGR_AGREEMENT_ROLE
  order by name asc
END
go

GRANT EXECUTE ON [dbo].[spVAGR_AGREEMENT_ROLE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVAGR_AGREEMENT_ROLE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVLOC_COUNTRY_SaveById...'
go


CREATE procedure [dbo].[spVLOC_COUNTRY_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить страны
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0     20.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	@p_id                   bigint out,
 @p_COUNTRY_CHAR2      char(2),
 @p_COUNTRY_CHAR3      char(3),
 @p_SHORT_NAME         nvarchar(50),
 @p_FULL_NAME             nvarchar(256),
 @p_EXTERNAL_CODE         nvarchar(30) = null,
 @p_sys_comment          nvarchar(2000) = null,
 @p_sys_user             nvarchar(30) = null
)
as
begin

  set nocount on

    if (@p_sys_user is null)
    set @p_sys_user = user_name()

 if (@p_id is null)

  begin
    
		insert into
			dbo.CLOC_COUNTRY 
            ( COUNTRY_CHAR2,COUNTRY_CHAR3
             ,SHORT_NAME, FULL_NAME, EXTERNAL_CODE
             ,sys_comment, sys_user_created)
		values
			(@p_COUNTRY_CHAR2,@p_COUNTRY_CHAR3
   ,@p_SHORT_NAME, @p_FULL_NAME, @p_EXTERNAL_CODE
    ,@p_sys_comment, @p_sys_user)

       set @p_id = scope_identity()

  end
else
   -- надо править существующий
		update dbo.CLOC_COUNTRY set
   COUNTRY_CHAR2 = @p_COUNTRY_CHAR2
  ,COUNTRY_CHAR3 = @p_COUNTRY_CHAR3 
		,SHORT_NAME = @p_SHORT_NAME
  ,FULL_NAME = @p_FULL_NAME
  ,EXTERNAL_CODE = @p_EXTERNAL_CODE
  ,sys_comment = @p_sys_comment
  ,sys_user_modified = @p_sys_user
		where ID = @p_id

  return

end
go


GRANT EXECUTE ON [dbo].[spVLOC_COUNTRY_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVLOC_COUNTRY_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVOBJ_COLOUR_SelectAll...'
go

create PROCEDURE [dbo].[spVOBJ_COLOUR_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение цветов мобильного объекта
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 begin
  set nocount on
  

	 SELECT ID, NAME
	 FROM dbo.VOBJ_COLOUR
   order by 2 asc

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_COLOUR_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_COLOUR_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_COLOUR_SelectById...'
go


CREATE PROCEDURE [dbo].[spVOBJ_COLOUR_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение цвета мобильного объекта по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
) 
AS
 begin
  set nocount on
  

	 SELECT ID, NAME
	 FROM dbo.VOBJ_COLOUR
   where Id = @p_id

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_COLOUR_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_COLOUR_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_SET_SaveById...'
go

CREATE procedure [dbo].[spVOBJ_SET_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить группу для объектов
**
**  Входные параметры:
**  @param p_id, 
**  @param p_Name,
**  @param p_REF_TYPE_ID,
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.3     03.05.2007 OLobanov      @p_CREF_REF_TYPE_ID -> @p_REF_TYPE_ID (CREF_REF_TYPE_ID -> REF_TYPE_ID)
** 1.2     10.04.2007 VLavrentiev	Добавил обработку ref_type
** 1.1     09.04.2007 VLavrentiev	Поправил вывод id
** 1.0     03.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id           bigint out,
@p_Name         nvarchar(100),
@p_REF_TYPE_ID  bigint = null,
@p_sys_comment  nvarchar(2000) = null,
@p_sys_user     nvarchar(30) = null
)
as
begin

  set nocount on

  if (@p_sys_user is null)
    set @p_sys_user = user_name()

   -- Если тип пришел нулл проставим по умолчанию справочник для
   -- мобильного объекта
  if (@p_REF_TYPE_ID is null)
    exec @p_REF_TYPE_ID = dbo.sfCONST @p_const_name = 'MO_REF_TYPE'
 
 if (@p_id is null)
     begin
  -- надо добавлять
  -- добавим запись в связочную таблицу
	      insert into dbo.COBJ_SET (Name, REF_TYPE_ID, sys_comment, sys_user_created)
      	values (@p_Name, @p_REF_TYPE_ID,  @p_sys_comment, @p_sys_user)

       set @p_id = scope_identity()
    end
  else

   -- надо править существующий
  update dbo.COBJ_SET 
  set    Name =  @p_Name,
         sys_comment = @p_sys_comment,
         sys_user_modified = @p_sys_user
  where  ID = @p_id
  

  return

end
go

GRANT EXECUTE ON [dbo].[spVOBJ_SET_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_SET_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVOBJ_SET_SelectById...'
go


CREATE PROCEDURE [dbo].[spVOBJ_SET_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение группы по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      03.02.2005 OLobanov     Добавил вывод всех полей из view VOBJ_GROUP
** 1.0      09.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
@p_id bigint
AS
BEGIN
  set nocount on

  select ID, 
         NAME, 
         REF_TYPE_ID, 
         SYS_STATUS, 
         SYS_COMMENT, 
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED
  from  dbo.VOBJ_SET
  where id = @p_id
  order by name asc
  RETURN
END
go

GRANT EXECUTE ON [dbo].[spVOBJ_SET_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_SET_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_KIND_SelectAll...'
go

               
CREATE PROCEDURE [dbo].[spVOBJ_KIND_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение видов мобильных объектов
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
 begin
  set nocount on
  

	 SELECT 
          ID
         ,NAME
         ,REF_TYPE_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_KIND
    order by 2 asc

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_KIND_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_KIND_SelectAll] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating  spVOBJ_KIND_SelectById...'
go


CREATE PROCEDURE [dbo].[spVOBJ_KIND_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение вида мобильного объекта по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
) 
AS
 begin
  set nocount on
  

	 SELECT ID
         ,NAME
         ,REF_TYPE_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_KIND
   where Id = @p_id

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_KIND_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_KIND_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_MARK_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVOBJ_MARK_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение марок мобильных объектов
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/

AS
 begin
  set nocount on
  

	 SELECT 
          ID
         ,NAME
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MARK
    order by 2 asc

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MARK_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MARK_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_MOBILE_OBJECT_SaveById...'
go

create procedure [dbo].[spVOBJ_MOBILE_OBJECT_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить мобильный	 объект
**
**  Входные параметры:
**  @param p_id, 
**  @param p_PIN, 
**  @param p_OLD_PIN,
**  @param p_State_number,
**	@param p_VIN,
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.3     17.04.2007 VLavrentiev	Добавил REGION_NAME и YEAR_MARK
** 1.2     17.04.2007 VLavrentiev	Поправил обработку вставки
** 1.1     03.04.2007 VLavrentiev	Добавил модели и цвета
** 1.0     03.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_id                 bigint out,
	   @p_PIN                nvarchar(10),
	   @p_OLD_PIN            nvarchar(10) = null,
    @p_State_number       nvarchar(30) = null,
	   @p_VIN                nvarchar(25) = null,
    @p_COLOR_ID      bigint = null,
    @p_MODEL_ID      bigint = null,
    @p_MODEL_LINE_ID bigint = null,
    @p_MARK_ID       bigint = null,
    @p_KIND_ID       bigint = null,
    @p_REGION_NAME   nvarchar(50) = null,
    @p_YEAR_MARK     datetime = null,
    @p_sys_comment   nvarchar(2000) = null,
    @p_sys_user      nvarchar(30) = null
)
as
begin
   set nocount on
   set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

     if (@p_sys_user is null)
    set @p_sys_user = user_name()

   if (@p_id is null)
       begin
    -- надо добавлять
    -- добавим запись в связочную таблицу
      if (@@tranCount = 0)
       begin transaction 		

       exec  @v_Error = 
           dbo.spCOBJ_OBJECT_SaveById
           --выходной параметр id
            @p_id = @p_id out
           ,@p_PIN = @p_PIN
           ,@p_sys_comment = @p_sys_comment
           ,@p_sys_user = @p_sys_user
      
       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
           rollback
         return @v_Error
       end

		    insert into
		    	dbo.COBJ_MOBILE_OBJECT 
            ( id, PIN, OLD_PIN, State_number, 
              VIN, COLOR_ID, MODEL_ID
            , MODEL_LINE_ID, MARK_ID, KIND_ID
            , REGION_NAME, YEAR_MARK, sys_comment, sys_user_created )
		     values
			         (@p_id, @p_PIN, @p_OLD_PIN, @p_State_number
           , @p_VIN, @p_COLOR_ID, @p_MODEL_ID
           , @p_MODEL_LINE_ID, @p_MARK_ID, @p_KIND_ID
           , @p_REGION_NAME, @p_YEAR_MARK,  @p_sys_comment, @p_sys_user)

       
      if (@@error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
           rollback
         return @@error
       end

      if (@@tranCount > @v_TrancountOnEntry)
       commit
     end
 else
   -- надо править существующий
		update dbo.COBJ_MOBILE_OBJECT set
		PIN =  @p_PIN,
		OLD_PIN = @p_OLD_PIN,
        State_number = @p_State_number,
        VIN = @p_VIN,
        COLOR_ID = @p_COLOR_ID,
        MODEL_ID = @p_MODEL_ID,
        MODEL_LINE_ID = @p_MODEL_LINE_ID,
        MARK_ID = @p_MARK_ID,
        KIND_ID = @p_KIND_ID,
        REGION_NAME = @p_REGION_NAME,
        YEAR_MARK = @p_YEAR_MARK, 
        sys_comment = @p_sys_comment,
        sys_user_modified = @p_sys_user
		where ID = @p_id


end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MOBILE_OBJECT_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MOBILE_OBJECT_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating  spVOBJ_MODEL_LINE_SelectByAll...'
go


create PROCEDURE [dbo].[spVOBJ_MODEL_LINE_SelectByAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение модельного ряда мобильного объекта
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 begin
  set nocount on
  

	 SELECT 
          ID
         ,NAME
         ,MARK_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL_LINE
         order by 2 asc
	 
  RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_LINE_SelectByAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_LINE_SelectByAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_MODEL_LINE_SelectById...'
go


create PROCEDURE [dbo].[spVOBJ_MODEL_LINE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение модельного ряда мобильного объекта по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_ID bigint
)
AS
 begin
  set nocount on
  

	 SELECT
          ID
         ,NAME
         ,MARK_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL_LINE
  where ID = @p_ID 
	 
  RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_LINE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_LINE_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_MODEL_LINE_SelectByMark_Id...'
go


create PROCEDURE [dbo].[spVOBJ_MODEL_LINE_SelectByMark_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение модельного ряда мобильного объекта по марке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_MARK_ID bigint
)
AS
 begin
  set nocount on
  

	 SELECT ID
         ,NAME
         ,MARK_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL_LINE
  where MARK_ID = @p_MARK_ID 
    order by 2 asc  
	 
  RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_LINE_SelectByMark_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_LINE_SelectByMark_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_MODEL_SelectAll...'
go



create PROCEDURE [dbo].[spVOBJ_MODEL_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение моделей мобильного объекта
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 begin
  set nocount on
  

	 SELECT 
           ID
          ,NAME
          ,MARK_ID
          ,MODEL_LINE_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL
   order by 2 asc

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_SelectAll] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVOBJ_MODEL_SelectById...'
go

create PROCEDURE [dbo].[spVOBJ_MODEL_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение моделей мобильного объекта
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id bigint
)
AS
 begin
  set nocount on
  

	 SELECT  
           ID
          ,NAME
          ,MARK_ID
          ,MODEL_LINE_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL
         where id = @p_id

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_MODEL_SelectByMark_Id...'
go


create PROCEDURE [dbo].[spVOBJ_MODEL_SelectByMark_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение моделей мобильного объекта по марке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_MARK_ID bigint
)
AS
 begin
  set nocount on
  

	 SELECT            
           ID
          ,NAME
          ,MARK_ID
          ,MODEL_LINE_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL
  where MARK_ID = @p_MARK_ID

	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_SelectByMark_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_SelectByMark_Id] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVOBJ_MODEL_SelectByModel_Line_Id...'
go

create PROCEDURE [dbo].[spVOBJ_MODEL_SelectByModel_Line_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение моделей мобильного объекта по модельному ряду
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      17.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_MODEL_LINE_ID bigint
)
AS
 begin
  set nocount on
  

	 SELECT
           ID
          ,NAME
          ,MARK_ID
          ,MODEL_LINE_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	 FROM dbo.VOBJ_MODEL
         where MODEL_LINE_ID = @p_MODEL_LINE_ID

	 RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVOBJ_MODEL_SelectByModel_Line_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MODEL_SelectByModel_Line_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_OBJECT_GROUP_SaveById...'
go

create procedure [dbo].[spVOBJ_OBJECT_GROUP_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить объект в группе
**
**  Входные параметры:
**  @param p_PARTY_ID,
**  @param p_GROUP_ID,
**  @param p_REF_TYPE_ID,
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1     16.04.2007 VLavrentiev	Обработка ПИН добавлена
** 1.0     06.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_OBJECT_ID       bigint,
    @p_SET_ID          bigint,
    @p_REF_TYPE_ID     bigint = null,
    @p_sys_comment         nvarchar(2000) = null,
    @p_sys_user            nvarchar(30) = null
)
as
begin
  set nocount on
    if (@p_sys_user is null)
    set @p_sys_user = user_name()
   -- Если тип пришел нулл проставим по умолчанию справочник для
   -- мобильного объекта
  if (@p_REF_TYPE_ID is null)
    exec @p_REF_TYPE_ID = dbo.sfCONST
                           @p_const_name = 'MO_REF_TYPE'

  
    		insert into
			    dbo.COBJ_OBJECT_GROUP 
            (OBJECT_ID, SET_ID, REF_TYPE_ID
           , sys_comment, sys_user_created)
      select @p_OBJECT_ID, @p_SET_ID,  @p_REF_TYPE_ID, 
             @p_sys_comment, @p_sys_user
      where not exists (select top(1) 1
                          from dbo.VOBJ_OBJECT_GROUP
                         where OBJECT_ID = @p_OBJECT_ID
                           and REF_TYPE_ID = @p_REF_TYPE_ID)

  if (@@rowcount = 0)

      update dbo.COBJ_OBJECT_GROUP
      set SET_ID = @p_SET_ID
         ,sys_user_modified = @p_sys_user
         ,sys_comment = @p_sys_comment
      where OBJECT_ID = @p_OBJECT_ID
      and REF_TYPE_ID = @p_REF_TYPE_ID

  return
end
go

GRANT EXECUTE ON [dbo].[spVOBJ_OBJECT_GROUP_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_OBJECT_GROUP_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_Delete...'
go

CREATE PROCEDURE [dbo].[spVPRT_EMPLOYEE_Delete]
/******************************************************************************
** Description:
** Процедура удаляет работника организации
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
@p_id             bigint,
@p_sys_comment    nvarchar(2000) = null,
@p_sys_user       nvarchar(30) = null
AS
BEGIN
  if (@p_sys_user is null)
    set @p_sys_user = user_name()

  update dbo.CPRT_EMPLOYEE
     set SYS_STATUS = 2
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id
  
END
go

GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_Delete] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_SaveById...'
go



create PROCEDURE [dbo].[spVPRT_EMPLOYEE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ID           bigint out 
,@p_PERSON_ID    bigint
,@p_JOB_TITLE_ID bigint
,@p_ORGANIZATION_ID bigint
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
 AS
  set nocount on

  if (@p_sys_user is null)
    set @p_sys_user = user_name()

 if (@p_id is null)
  begin
     INSERT INTO dbo.CPRT_EMPLOYEE
     (PERSON_ID ,JOB_TITLE_ID ,ORGANIZATION_ID
     ,SYS_COMMENT ,SYS_USER_CREATED)
     VALUES 
     (@p_PERSON_ID ,@p_JOB_TITLE_ID ,@p_ORGANIZATION_ID
     ,@p_sys_comment ,@p_sys_user)

     SET @p_id = scope_identity()

  end
 else
   UPDATE dbo.CPRT_EMPLOYEE
   SET 
     PERSON_ID = @p_PERSON_ID
    ,JOB_TITLE_ID = @p_JOB_TITLE_ID
    ,ORGANIZATION_ID = @p_ORGANIZATION_ID
    ,SYS_COMMENT = @p_sys_comment
    ,SYS_USER_MODIFIED = @p_sys_user
   WHERE ID = @p_id

RETURN 
go

GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVPRT_EMPLOYEE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
 AS
  set nocount on

  SELECT ID
        ,PERSON_ID
        ,JOB_TITLE_ID
        ,ORGANIZATION_ID
        ,SYS_STATUS 
        ,SYS_COMMENT 
        ,SYS_DATE_MODIFIED 
        ,SYS_DATE_CREATED
        ,SYS_USER_MODIFIED 
        ,SYS_USER_CREATED
  FROM dbo.VPRT_EMPLOYEE

RETURN 
go

GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_SelectByParty_Id...'
go



create PROCEDURE [dbo].[spVPRT_EMPLOYEE_SelectByParty_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_PARTY_ID bigint
)
 AS
  set nocount on
 SELECT ID
        ,PERSON_ID
        ,JOB_TITLE_ID
        ,ORGANIZATION_ID
        ,SYS_STATUS 
        ,SYS_COMMENT 
        ,SYS_DATE_MODIFIED 
        ,SYS_DATE_CREATED
        ,SYS_USER_MODIFIED 
        ,SYS_USER_CREATED
 FROM dbo.VPRT_EMPLOYEE
 WHERE ORGANIZATION_ID = @p_PARTY_ID
    OR PERSON_ID = @p_PARTY_ID
RETURN 
go


GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_SelectByParty_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_SelectByParty_Id] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_SelectById...'
go

CREATE PROCEDURE [dbo].[spVPRT_EMPLOYEE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
 AS
  set nocount on
 SELECT  ID
        ,PERSON_ID
        ,JOB_TITLE_ID
        ,ORGANIZATION_ID
        ,SYS_STATUS 
        ,SYS_COMMENT 
        ,SYS_DATE_MODIFIED 
        ,SYS_DATE_CREATED
        ,SYS_USER_MODIFIED 
        ,SYS_USER_CREATED
 FROM dbo.VPRT_EMPLOYEE
 WHERE ID = @p_id
RETURN 
go

GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_SelectById] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating spVPRT_EMPLOYEE_SelectByOrganization_ID...'
go

CREATE PROCEDURE [dbo].[spVPRT_EMPLOYEE_SelectByOrganization_ID]
/******************************************************************************
** Description:
** Процедура возвращает список представителей заданного юр. лица
**
** Version  Date         Author 		Comments
**------------------------------------------------------------------------------
** 1.0      02.05.2007   OLobanov	    Создание процедуры
*******************************************************************************/
@p_organization_id bigint
AS
BEGIN
  SELECT
     e.Id
    ,e.PERSON_ID
    ,p.NAME
    ,p.SECONDNAME
    ,p.SURNAME
    ,p.SEX
    ,p.BIRTHDATE
    ,j.NAME AS JOB_TITLE_NAME
    ,e.SYS_STATUS 
    ,e.SYS_COMMENT 
    ,e.SYS_DATE_MODIFIED 
    ,e.SYS_DATE_CREATED
    ,e.SYS_USER_MODIFIED 
    ,e.SYS_USER_CREATED
  FROM   dbo.VPRT_EMPLOYEE e
    JOIN dbo.VPRT_PERSON p ON p.ID = e.PERSON_ID
    JOIN dbo.VPRT_JOB_TITLE j ON j.ID = e.JOB_TITLE_ID
  WHERE
    e.ORGANIZATION_ID = @p_organization_id
  ORDER BY 
    p.SURNAME,
    p.NAME
END
go

GRANT EXECUTE ON [dbo].[spVPRT_EMPLOYEE_SelectByOrganization_ID] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_EMPLOYEE_SelectByOrganization_ID] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_ORGANIZATION_SaveById...'
go


CREATE PROCEDURE [dbo].[spVPRT_ORGANIZATION_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ID bigint out 
,@p_NAME nvarchar(60)
,@p_KPP  nvarchar(60) = null
,@p_INN  nvarchar(60) = null
,@p_Loc_Fact_id    bigint = null
,@p_Loc_Jur_id     bigint = null 
,@p_is_default_loc bit = 1 
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
 AS
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

 if (@p_sys_user is null)
    set @p_sys_user = user_name()

  
    --Тип - Факт адрес
  declare @v_loc_fact_type_id bigint
         ,@v_loc_jur_type_id  bigint
   
   set @v_loc_fact_type_id = dbo.sfCONST('FACT_LOC_TYPE')
   set @v_loc_jur_type_id = dbo.sfCONST('JUR_LOC_TYPE')
   
 if (@p_id is null)
   begin

     if (@@tranCount = 0)
       begin transaction 

 -- добавим запись в связочную таблицу 
     exec @v_Error = 
        dbo.spCPRT_Party_SaveById
        @p_id = @p_id out
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

     if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

      INSERT INTO dbo.CPRT_ORGANIZATION
      (ID, NAME, KPP, INN, SYS_COMMENT, SYS_USER_CREATED)
      VALUES (@p_Id ,@p_NAME ,@p_KPP ,@p_INN ,@p_sys_comment ,@p_sys_user)

     if (@@Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @@Error
       end 
   end
 else
      UPDATE dbo.CPRT_ORGANIZATION
         SET 
          NAME = @p_NAME
         ,KPP = @p_KPP
         ,INN = @p_INN
         ,SYS_COMMENT = @p_sys_comment
         ,SYS_USER_MODIFIED = @p_sys_user
          WHERE ID = @p_id
        --  and sys_status = 1
   
  -- добавим связку в таблице мест для записи
   if  (@p_Loc_Fact_id is not null)
      exec @v_Error = 
       dbo.spCLOC_LOCATION_LINK_SaveById
        @p_LOCATION_ID = @p_Loc_Fact_id
	      ,@p_LOCATION_TYPE_ID = @v_loc_fact_type_id
       ,@p_TABLE_NAME = 'dbo.CPRT_ORGANIZATION'
       ,@p_RECORD_ID = @p_id
       ,@p_IS_DEFAULT  = @p_is_default_loc
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end   

   if  (@p_Loc_Jur_id is not null)
      exec @v_Error = 
        dbo.spCLOC_LOCATION_LINK_SaveById
        @p_LOCATION_ID = @p_Loc_Jur_id
	      ,@p_LOCATION_TYPE_ID = @v_loc_jur_type_id
       ,@p_TABLE_NAME = 'dbo.CPRT_ORGANIZATION'
       ,@p_RECORD_ID = @p_id
       ,@p_IS_DEFAULT  = @p_is_default_loc
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user
  if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

  if (@@tranCount > @v_TrancountOnEntry)
       commit
    
  return    
go


GRANT EXECUTE ON [dbo].[spVPRT_ORGANIZATION_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_ORGANIZATION_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_ORGANIZATION_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVPRT_ORGANIZATION_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 set nocount on 

	SELECT 
           LOC_FACT_ID
          ,LOC_JUR_ID
          ,ID
          ,NAME
          ,KPP
          ,INN       
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	FROM dbo.VPRT_ORGANIZATION
      order by 4 asc

	RETURN
go

GRANT EXECUTE ON [dbo].[spVPRT_ORGANIZATION_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_ORGANIZATION_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_ORGANIZATION_SelectById...'
go

CREATE PROCEDURE [dbo].[spVPRT_ORGANIZATION_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      28.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
AS

 set nocount on

	SELECT           
           LOC_FACT_ID
          ,LOC_JUR_ID
          ,ID
          ,NAME
          ,KPP
          ,INN       
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	FROM dbo.VPRT_ORGANIZATION
      where ID = @p_id 

	RETURN
go


GRANT EXECUTE ON [dbo].[spVPRT_ORGANIZATION_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_ORGANIZATION_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_PERSON_SaveById...'
go

CREATE procedure [dbo].[spVPRT_PERSON_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить физ. лицо
**
**  Входные параметры:
    @param p_id       
    @param p_Name   
    @param p_SecondName 
    @param p_SurName 
    @param p_Sex   
    @param p_Birthdate 
    @param p_sys_comment 
    @param p_sys_user 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint out,
    @p_Name        nvarchar(30),
    @p_SecondName  nvarchar(30),
    @p_SurName     nvarchar(30) = null,
    @p_Sex         char(1) = 'M',
    @p_Birthdate      datetime = null,
    @p_Loc_Fact_id    bigint = null,
    @p_is_default_loc bit = 1,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
   --Тип - Факт адрес
  declare @v_cloc_location_type_id bigint
   
   set @v_cloc_location_type_id = dbo.sfCONST('FACT_LOC_TYPE')
       -- надо добавлять
  if (@p_id is null)

   begin
      if (@@tranCount = 0)
        begin transaction  
     -- добавим запись в связочную таблицу 

        exec @v_Error = 
        dbo.spCPRT_Party_SaveById
        @p_id = @p_id out
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user

       if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 

		     insert into
			     dbo.CPRT_PERSON 
            (id, Name, SecondName, SurName, Sex, Birthdate ,sys_comment, sys_user_created)
	      	values
			         (@p_id, @p_Name, @p_SecondName, @p_SurName, @p_Sex, @p_Birthdate ,@p_sys_comment, @p_sys_user)

       if (@@error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @@Error
       end 
      end 
 else
  -- надо править существующий
		update dbo.CPRT_PERSON set
		Name =  @p_Name,
		SecondName = @p_SecondName,
        SurName = @p_SurName,
        Sex  = @p_Sex,
        Birthdate  = @p_Birthdate,
        sys_comment = @p_sys_comment,
        sys_user_modified = @p_sys_user
		where ID = @p_id
        --  and sys_status = 1

   if (@p_Loc_Fact_id is not null)
      exec @v_Error = 
        dbo.spCLOC_LOCATION_LINK_SaveById
        @p_LOCATION_ID = @p_Loc_Fact_id
       ,@p_LOCATION_TYPE_ID = @v_cloc_location_type_id
       ,@p_TABLE_NAME = 'dbo.CPRT_PERSON'
       ,@p_RECORD_ID = @p_id
       ,@p_IS_DEFAULT  = @p_is_default_loc
       ,@p_sys_comment = @p_sys_comment
       ,@p_sys_user = @p_sys_user
     
      if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
      if (@@tranCount > @v_TrancountOnEntry)
       commit
    
  return 

end
go

GRANT EXECUTE ON [dbo].[spVPRT_PERSON_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_PERSON_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_PERSON_SelectAll...'
go


CREATE PROCEDURE [dbo].[spVPRT_PERSON_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      23.03.2007 VLavrentiev	Сделал вывод на основе представления
** 1.0      23.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 set nocount on
  	SELECT ID 
          ,NAME 
          ,SECONDNAME
          ,SURNAME
          ,SEX 
          ,BIRTHDATE 
          ,LOC_FACT_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	FROM dbo.VPRT_PERSON
     order by 2 asc,  3 asc , 4 asc

	RETURN

go


GRANT EXECUTE ON [dbo].[spVPRT_PERSON_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_PERSON_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_PERSON_SelectById...'
go

CREATE PROCEDURE [dbo].[spVPRT_PERSON_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Вывод информации о пользователе по его Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
AS
 set nocount on
  	SELECT ID 
          ,NAME 
          ,SECONDNAME
          ,SURNAME
          ,SEX 
          ,BIRTHDATE 
          ,LOC_FACT_ID
          ,SYS_STATUS 
          ,SYS_COMMENT 
          ,SYS_DATE_MODIFIED 
          ,SYS_DATE_CREATED
          ,SYS_USER_MODIFIED 
          ,SYS_USER_CREATED
	FROM dbo.VPRT_PERSON
    where ID = @p_id

	RETURN
go

GRANT EXECUTE ON [dbo].[spVPRT_PERSON_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_PERSON_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_PROFILE_SaveById...'
go

CREATE PROCEDURE [dbo].[spVUSR_PROFILE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
 @p_ID bigint out 
,@p_USER_ID bigint
,@p_Configuration XML = '<root />'
,@p_Language CHAR(5) = 'en-EN'
,@p_sys_comment nvarchar(2000) = null
,@p_sys_user    nvarchar(30) = null
)
 AS
  set nocount on

    if (@p_sys_user is null)
    set @p_sys_user = user_name()

if (@p_id is null)
 begin
    INSERT INTO dbo.CUSR_PROFILE
     (USER_ID ,CONFIGURATION ,LANGUAGE
     ,SYS_COMMENT ,SYS_USER_CREATED)
    VALUES 
     (@p_USER_ID ,@p_CONFIGURATION ,@p_LANGUAGE
     ,@p_sys_comment ,@p_sys_user)
    SET @p_id = scope_identity()
 end
else
 UPDATE dbo.CUSR_PROFILE
 SET 
 USER_ID = @p_USER_ID
,CONFIGURATION = @p_CONFIGURATION
,LANGUAGE = @p_LANGUAGE
,SYS_COMMENT = @p_sys_comment
,SYS_USER_MODIFIED = @p_sys_user
 WHERE ID = @p_id
 and sys_status = 1

RETURN 
go

GRANT EXECUTE ON [dbo].[spVUSR_PROFILE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_PROFILE_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_PROFILE_SaveByUser_id...'
go

CREATE procedure [dbo].[spVUSR_PROFILE_SaveByUser_id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить конфигурацию пользователя
**
**  Входные параметры:
**  @param p_User_id, 
**  @param p_Configuration, 
**  @param p_Language
**  @param p_sys_comment
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:			
** 1.3      10.04.2007 VLavrentiev	Поправил вывод CUSR_USER_ID 
** 1.2      23.03.2007 VLavrentiev	Дбавил схему и статус записи 
** 1.1      21.03.2007 VLavrentiev	Немного изменил обработку 
** 1.0      20.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_User_id  bigint,
	   @p_Configuration XML = '<root />',
	   @p_Language CHAR(5) = 'en-EN',
           @p_sys_comment nvarchar(2000) = null,
           @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on
  
  if (@p_sys_user is null)
       set @p_sys_user = user_name()
   -- надо править существующий
  if (@p_User_id is null)
          -- надо добавлять
	  	insert into
			 dbo.CUSR_PROFILE 
            (User_id, Configuration, Language, sys_comment, sys_user_created)
	  	values
	    (@p_User_id, @p_Configuration, @p_Language, @p_sys_comment, @p_sys_user)
  else

  		update dbo.CUSR_PROFILE set
		      Configuration = @p_Configuration,
		      Language = @p_Language,
                      sys_comment = @p_sys_comment,
                      sys_user_modified = @p_sys_user
		  where User_ID = @p_User_id
      and sys_status = 1

  return
end
go

GRANT EXECUTE ON [dbo].[spVUSR_PROFILE_SaveByUser_id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_PROFILE_SaveByUser_id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_PROFILE_SelectAll...'
go

create PROCEDURE [dbo].[spVUSR_PROFILE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
 AS
 set nocount on
 
 SELECT ID
       ,USER_ID
       ,CONFIGURATION
       ,LANGUAGE
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
 FROM dbo.VUSR_PROFILE
RETURN 
go


GRANT EXECUTE ON [dbo].[spVUSR_PROFILE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_PROFILE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_PROFILE_SelectById...'
go

CREATE PROCEDURE [dbo].[spVUSR_PROFILE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**------------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      29.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
 AS
 set nocount on

 SELECT ID
       ,USER_ID
       ,CONFIGURATION
       ,LANGUAGE
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
 FROM dbo.VUSR_PROFILE
 WHERE ID = @p_id
RETURN 
go

GRANT EXECUTE ON [dbo].[spVUSR_PROFILE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_PROFILE_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_PROFILE_SelectByUser_Id...'
go


CREATE PROCEDURE [dbo].[spVUSR_PROFILE_SelectByUser_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**  Процедура возвращает конфигурации пользователя по его User_Id
**  Входные параметры:
**  @param p_User_id 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      23.03.2007 VLavrentiev	Добавил статус записи
** 1.0      21.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
	(
        @p_User_id bigint
	)
AS

 set nocount on

	SELECT 
        ID
       ,USER_ID
       ,CONFIGURATION
       ,LANGUAGE
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VUSR_PROFILE
	WHERE User_id = @p_User_id;

	RETURN
go

GRANT EXECUTE ON [dbo].[spVUSR_PROFILE_SelectByUser_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_PROFILE_SelectByUser_Id] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVUSR_GROUP_SaveById...'
go

CREATE procedure [dbo].[spVUSR_GROUP_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить группу для пользователей
**
**  Входные параметры:
**  @param p_id, 
**  @param p_name
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
	   @p_id       bigint = null out,
    @p_name     nvarchar(30),
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
   set nocount on

      if (@p_sys_user is null)
       set @p_sys_user = user_name()

 if (@p_id is null)
  begin

     insert into
     dbo.CUSR_GROUP 
       (name,  sys_comment, sys_user_created)
     values
       (@p_name, @p_sys_comment, @p_sys_user)
     
     set @p_id = scope_identity()

  end
 else 
   -- надо править существующий
		update dbo.CUSR_GROUP set
		      name =  @p_name,
                      sys_comment = @p_sys_comment,
                      sys_user_modified = @p_sys_user
		where ID = @p_id


  return     
      
end
go


GRANT EXECUTE ON [dbo].[spVUSR_GROUP_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_GROUP_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_GROUP_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVUSR_GROUP_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение полного списка групп
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 set nocount on

	SELECT Id
             ,Name
             ,SYS_STATUS 
             ,SYS_COMMENT 
             ,SYS_DATE_MODIFIED 
             ,SYS_DATE_CREATED
             ,SYS_USER_MODIFIED 
             ,SYS_USER_CREATED
	FROM dbo.VUSR_GROUP
        order by Name asc

	RETURN

GRANT EXECUTE ON [dbo].[spVUSR_GROUP_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_GROUP_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_GROUP_SelectById...'
go

CREATE PROCEDURE [dbo].[spVUSR_GROUP_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение группы по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
AS
  set nocount on
  

	SELECT Id
             ,Name
             ,SYS_STATUS 
             ,SYS_COMMENT 
             ,SYS_DATE_MODIFIED 
             ,SYS_DATE_CREATED
             ,SYS_USER_MODIFIED 
             ,SYS_USER_CREATED
	FROM dbo.VUSR_GROUP
        where  id = @p_id

	RETURN

go

GRANT EXECUTE ON [dbo].[spVUSR_GROUP_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_GROUP_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_USER_Authentication...'
go

CREATE PROCEDURE [dbo].[spVUSR_USER_Authentication]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна проверить существует ли пользователь с
** указанным SID или парой логин/пароль) в базе пользователей
** и возвратить данные пользователя (SID и логин) в случае его 
** существования.
**
**  Входные параметры:
**  @param p_Sid, 
**  @param p_Login, 
**  @param p_Password
**
**  В случае (1. ) просто возвращается пользователь по его SID
**  В случае (2.) проверяется существование пары логин/пароль. 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.4      23.03.2007 VLavrentiev	Добавил статус сообщения
** 1.3      20.03.2007 VLavrentiev	Изменил тип @p_Sid 
** 1.2      20.03.2007 VLavrentiev	Добавил вывод Id
** 1.1      19.03.2007 VLavrentiev	Изменил типы параметров вызова
** 1.0      15.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
	(
        @p_Sid   nvarchar(50),
	@p_Login nvarchar(30) = null,
        @p_Password nvarchar(30) = null
	)
AS
  IF @p_Login is null 

	SELECT Id
              ,UserSid
              ,UserName
              ,SYS_STATUS 
              ,SYS_COMMENT 
              ,SYS_DATE_MODIFIED 
              ,SYS_DATE_CREATED
              ,SYS_USER_MODIFIED 
              ,SYS_USER_CREATED
	FROM dbo.VUSR_USER
	WHERE UserSid = @p_Sid;

  else

    SELECT     Id
              ,UserSid
              ,UserName
              ,SYS_STATUS 
              ,SYS_COMMENT 
              ,SYS_DATE_MODIFIED 
              ,SYS_DATE_CREATED
              ,SYS_USER_MODIFIED 
              ,SYS_USER_CREATED
	FROM dbo.VUSR_USER
	WHERE UserName = @p_Login 
      and Password = @p_Password;

	RETURN
go


GRANT EXECUTE ON [dbo].[spVUSR_USER_Authentication] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_USER_Authentication] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_USER_GROUP_SaveById...'
go

CREATE procedure [dbo].[spVUSR_USER_GROUP_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить запись в связочной таблице групп
** и пользователей
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments: 
** 1.0      27.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_USER_ID       bigint,
    @p_GROUP_ID       bigint,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on
  if (@p_sys_user is null)
    set @p_sys_user = user_name()
    -- надо добавлять
		insert into
			dbo.CUSR_USER_GROUP 
            (USER_ID, GROUP_ID, sys_comment, sys_user_created)
		values
	    (@p_USER_ID, @p_GROUP_ID, @p_sys_comment, @p_sys_user)

   
end
go

GRANT EXECUTE ON [dbo].[spVUSR_USER_GROUP_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_USER_GROUP_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVUSR_USER_SaveById...'
go
create procedure [dbo].[spVUSR_USER_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить конфигурацию пользователя
**
**  Входные параметры:
**  @param p_id, 
**  @param p_UserSid, 
**  @param p_UserName,
**  @param p_Password,
**	@param p_Configuration,
**	@param p_Language,
**  @param p_sys_comment,
**  @param p_sys_user
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.4      11.04.2007 VLavrentiev	Работа с парти изменена 
** 1.3      26.03.2007 VLavrentiev	Изменил обращение к конфигурации пользователя 
** 1.2      22.03.2007 VLavrentiev	Добавил запись конфигурации пользователя 
** 1.1      21.03.2007 VLavrentiev	Немного изменил обработку 
** 1.0      21.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id       bigint = null out,
    @p_UserSid  nvarchar(50),
    @p_UserName nvarchar(30),
    @p_Password nvarchar(30),
    @p_Configuration XML = '<root />',
    @p_Language CHAR(5) = 'en-EN',
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

 if (@p_sys_user is null)
    set @p_sys_user = user_name()

 if (@p_id is null)
  begin
    -- надо добавлять
    -- добавим запись в связочную таблицу
      if (@@tranCount = 0)
       begin transaction 

       insert into
	dbo.CUSR_USER 
       ( UserSid, UserName, Password, sys_comment, sys_user_created)
       values
       ( @p_UserSid, @p_UserName, @p_Password, @p_sys_comment, @p_sys_user)
        
       if (@@Error > 0)
          begin 
           if (@@tranCount > @v_TrancountOnEntry)
            rollback
           return @@Error
          end

    --  должна быть создана конфигурация 
       exec @v_Error = 
        dbo.spVUSR_PROFILE_SaveByUser_id
        @p_user_id = @p_id
      , @p_Configuration = @p_Configuration
      , @p_Language = @p_Language
      , @p_sys_comment = @p_sys_comment
      , @p_sys_user = @p_sys_user

       if (@v_Error > 0)
          begin 
            if (@@tranCount > @v_TrancountOnEntry)
              rollback
          return @v_Error
         end

       if (@@tranCount > @v_TrancountOnEntry)
         commit
   
 set @p_Id = scope_identity()
    
  end
 else
   -- надо править существующий
	 update dbo.CUSR_USER 
         set
		UserSid =  @p_UserSid,
		UserName = @p_UserName,
                Password = @p_Password,
                sys_comment = @p_sys_comment,
                sys_user_modified = @p_sys_user
	 where ID = @p_id
        --  and sys_status = 1	

    
  return     
      
end
go

GRANT EXECUTE ON [dbo].[spVUSR_USER_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_USER_SaveById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_USER_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVUSR_USER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      20.03.2007 VLavrentiev	Добавил вывод Id
** 1.0      16.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
 set nocount on
	SELECT Id
              ,UserSid
              ,UserName
              ,Password
              ,SYS_STATUS 
              ,SYS_COMMENT 
              ,SYS_DATE_MODIFIED 
              ,SYS_DATE_CREATED
              ,SYS_USER_MODIFIED 
              ,SYS_USER_CREATED
	FROM dbo.VUSR_USER
    order by UserName asc

	RETURN

go

GRANT EXECUTE ON [dbo].[spVUSR_USER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_USER_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVUSR_USER_SelectById...'
go

CREATE PROCEDURE [dbo].[spVUSR_USER_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура возвращает пользователя по его Id
**  Входные параметры:
**  @param p_id 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      23.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
	(
        @p_id bigint
	)
AS
 set nocount on

	SELECT Id
              ,UserSid
              ,UserName
              ,Password
              ,SYS_STATUS 
              ,SYS_COMMENT 
              ,SYS_DATE_MODIFIED 
              ,SYS_DATE_CREATED
              ,SYS_USER_MODIFIED 
              ,SYS_USER_CREATED
	FROM dbo.VUSR_USER
	WHERE id = @p_id;

	RETURN
go

GRANT EXECUTE ON [dbo].[spVUSR_USER_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVUSR_USER_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_SelectById...'
go


CREATE PROCEDURE [dbo].[spVWFL_MESSAGE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение типа сообщения по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_id bigint
)
AS
  set nocount on
  

	SELECT   
          MESSAGE_TYPE_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
	FROM dbo.VWFL_MESSAGE
        where id = @p_id

	RETURN
go

GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_SelectById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_TYPE_SaveById...'
go

create procedure [dbo].[spVWFL_MESSAGE_TYPE_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить конфигурацию пользователя
**
**  Входные параметры:
**  @param p_id, 
**  @param p_Description
**  @param @p_sys_comment 
**  @param @p_sys_user
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.3	    21.03.2007 VLavrentiev	Убрал проверку на null, сделал проверку на @@ROWCOUNT
** 1.2	    21.03.2007 RLyalchenko	Убрал подсчёт записей по ИД и добавил проверку на null
** 1.1      21.03.2007 VLavrentiev	Добавил @p_id out
** 1.0      20.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(   @p_id  bigint out,
    @p_Description nvarchar(512),
    @p_OBJECT_TYPE_ID bigint = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on


 if (@p_sys_user is null)
    set @p_sys_user = user_name()

 if (@p_OBJECT_TYPE_ID is null)
    set @p_OBJECT_TYPE_ID = dbo.sfCONST('MO_TYPE')

 if (@p_id is null)
  begin
    insert into
      dbo.CWFL_MESSAGE_TYPE 
      (OBJECT_TYPE_ID, Description, sys_comment, sys_user_created)
    values
      (@p_OBJECT_TYPE_ID, @p_Description, @p_sys_comment, @p_sys_user)
        
        set @p_id = SCOPE_IDENTITY();
  end
 else
-- надо править существующий
	update dbo.CWFL_MESSAGE_TYPE 
        set 
	  Description = @p_Description,
          OBJECT_TYPE_ID = @p_OBJECT_TYPE_ID,
          sys_comment = @p_sys_comment,
          sys_user_modified = @p_sys_user
        where ID = @p_id

return
end
go


GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_TYPE_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_TYPE_SaveById] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_TYPE_SelectAll...'
go

CREATE procedure [dbo].[spVWFL_MESSAGE_TYPE_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура возвращает список всех сообщений
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      20.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
as

  set nocount on

  select id
         ,description
         ,OBJECT_TYPE_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED
  from dbo.VWFL_MESSAGE_TYPE
   order by description asc

return	
go

GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_TYPE_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_TYPE_SelectAll] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_TYPE_SelectById...'
go

CREATE PROCEDURE [dbo].[spVWFL_MESSAGE_TYPE_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура возвращает тип сообщения по его ИД
**  Входные параметры:
**  @param p_id 
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      21.03.2007 VLavrentiev	Добавил вывод id
** 1.0      20.03.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
	(
        @p_id bigint
	)
AS
 set nocount on
	SELECT  Id
         ,Description
         ,OBJECT_TYPE_ID
         ,SYS_STATUS 
         ,SYS_COMMENT 
         ,SYS_DATE_MODIFIED 
         ,SYS_DATE_CREATED
         ,SYS_USER_MODIFIED 
         ,SYS_USER_CREATED 
	FROM dbo.VWFL_MESSAGE_TYPE
	WHERE id = @p_id;

	RETURN
go


GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_TYPE_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_TYPE_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_TYPE_SelectByRTM_Id...'
go


CREATE PROCEDURE [dbo].[spVWFL_MESSAGE_TYPE_SelectByRTM_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение типов сообщений по Id маршрута
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_ROUTE_MASTER_ID bigint
)
AS
begin
  set nocount on


 select vmt.Id
       ,vmt.DESCRIPTION
       ,vmt.OBJECT_TYPE_ID
       ,vmt.SYS_STATUS
       ,vmt.SYS_COMMENT
       ,vmt.SYS_DATE_MODIFIED
       ,vmt.SYS_DATE_CREATED
       ,vmt.SYS_USER_MODIFIED
       ,vmt.SYS_USER_CREATED
    from dbo.VWFL_ROUTE_MASTER vrm
     join dbo.VWFL_MESSAGE_TYPE_ROUTE_MASTER vmtrm
       on vrm.id = vmtrm.ROUTE_MASTER_ID
     join dbo.VWFL_MESSAGE_TYPE vmt
       on vmtrm.MESSAGE_TYPE_ID = vmt.id
    where vrm.id = @p_ROUTE_MASTER_ID

end
go

GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_TYPE_SelectByRTM_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_TYPE_SelectByRTM_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_DETAIL_Delete...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_DETAIL_Delete]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура удаляет дет информацию о маршруте
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 

  if (@p_sys_user is null)
   set @p_sys_user = user_name()

  update dbo.CWFL_ROUTE_DETAIL
     set SYS_STATUS = 2
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id


end

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_DETAIL_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_DETAIL_Delete] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_DETAIL_Insert...'
go


create procedure [dbo].[spVWFL_ROUTE_DETAIL_Insert]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна вставить детальную информацию о маршруте
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id                   bigint out,
    @p_ROUTE_MASTER_ID      bigint,
    @p_SORT_FIELD           tinyint,
    @p_PUBLIC_PROCESSING_TIME         bigint = null,
    @p_PRIVATE_PROCESSING_TIME        bigint = null,
    @p_INCIDENT_PROCESSING_TIME       bigint = null,
    @p_GROUP_ID       bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 

 
		     insert into
			     dbo.CWFL_ROUTE_DETAIL
            (ROUTE_MASTER_ID, SORT_FIELD, PUBLIC_PROCESSING_TIME
           , PRIVATE_PROCESSING_TIME, INCIDENT_PROCESSING_TIME, GROUP_ID
           , sys_comment, sys_user_created)
	      	values
			         (@p_ROUTE_MASTER_ID, @p_SORT_FIELD, @p_PUBLIC_PROCESSING_TIME
           , @p_PRIVATE_PROCESSING_TIME, @p_INCIDENT_PROCESSING_TIME, @p_GROUP_ID
           , @p_sys_comment, @p_sys_user)

       set @p_id = scope_identity()
end
go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_DETAIL_Insert] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_DETAIL_Insert] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_DETAIL_SelectById...'
go


CREATE PROCEDURE [dbo].[spVWFL_ROUTE_DETAIL_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение детали маршрута по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id bigint
)
AS
  set nocount on
  

	SELECT ID
       ,ROUTE_MASTER_ID
       ,SORT_FIELD
       ,PUBLIC_PROCESSING_TIME
       ,PRIVATE_PROCESSING_TIME
       ,INCIDENT_PROCESSING_TIME
       ,GROUP_ID
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VWFL_ROUTE_DETAIL
    where ID = @p_Id

	RETURN
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_DETAIL_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_DETAIL_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_DETAIL_SelectbyRTM_Id...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_DETAIL_SelectbyRTM_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id потока по его Message_Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.2      27.04.2007 VLavrentiev	Вывод названия группы добавил
** 1.1      16.04.2007 VLavrentiev	Вывод ID добавил
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_ROUTE_MASTER_ID bigint
)
AS
begin
  set nocount on
  

	SELECT vrd.ID
       ,vrd.ROUTE_MASTER_ID
       ,vrd.SORT_FIELD
       ,vrd.PUBLIC_PROCESSING_TIME
       ,vrd.PRIVATE_PROCESSING_TIME
       ,vrd.INCIDENT_PROCESSING_TIME
       ,vrd.GROUP_ID
       ,vrd.SYS_STATUS 
       ,vrd.SYS_COMMENT 
       ,vrd.SYS_DATE_MODIFIED 
       ,vrd.SYS_DATE_CREATED
       ,vrd.SYS_USER_MODIFIED 
       ,vrd.SYS_USER_CREATED
       ,vg.NAME
	FROM dbo.VWFL_ROUTE_DETAIL vrd
  join dbo.VUSR_GROUP vg
   on  vrd.GROUP_ID = vg.ID 
    where ROUTE_MASTER_ID = @p_ROUTE_MASTER_ID
 order by vrd.SORT_FIELD asc, vg.NAME asc

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_DETAIL_SelectbyRTM_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_DETAIL_SelectbyRTM_Id] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating spVWFL_ROUTE_DETAIL_Update...'
go

create procedure [dbo].[spVWFL_ROUTE_DETAIL_Update]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна изменить детальную информацию о маршруте
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id                   bigint,
    @p_ROUTE_MASTER_ID      bigint,
    @p_SORT_FIELD           tinyint,
    @p_PUBLIC_PROCESSING_TIME         bigint = null,
    @p_PRIVATE_PROCESSING_TIME        bigint = null,
    @p_INCIDENT_PROCESSING_TIME       bigint = null,
    @p_GROUP_ID       bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 

 
		     update 
			     dbo.CWFL_ROUTE_DETAIL
        set ROUTE_MASTER_ID = @p_ROUTE_MASTER_ID
          , SORT_FIELD = @p_SORT_FIELD
          , PUBLIC_PROCESSING_TIME =   @p_PUBLIC_PROCESSING_TIME
          , PRIVATE_PROCESSING_TIME =  @p_PRIVATE_PROCESSING_TIME
          , INCIDENT_PROCESSING_TIME = @p_INCIDENT_PROCESSING_TIME
          , GROUP_ID = @p_GROUP_ID
          , sys_comment = @p_sys_comment
          , sys_user_modified = @p_sys_user
	      where id = @p_id
end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_DETAIL_Update] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_DETAIL_Update] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_Close...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_Close]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура закрывает поток и проставляет сообщения в статус "обработано"
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      24.04.2007 VLavrentiev	Убрал обработку детали
** 1.0      18.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,   
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 
  set xact_abort on
  

   declare  @v_TrancountOnEntry int,
            @v_RUNTIME_STATUS tinyint 

     set @v_TrancountOnEntry = @@tranCount
     set @v_RUNTIME_STATUS = dbo.sfCONST('RUN_CLOSED') 

   if (@p_sys_user is null)
   set @p_sys_user = user_name()

   if (@@tranCount = 0)
        begin transaction  

       update dbo.CWFL_ROUTE_FLOW_MASTER
       set RUNTIME_STATUS = @v_RUNTIME_STATUS
          ,SYS_COMMENT = @p_sys_comment
          ,SYS_USER_MODIFIED = @p_sys_user
       where  ID = @p_id 
 
   if (@@Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @@Error
       end 

    update dbo.WIMP_MESSAGE
     set PROCESSED = 1
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
     where id in (select MESSAGE_ID 
                  from dbo.CWFL_ROUTE_FLOW_DETAIL
                 where ROUTE_FLOW_MASTER_ID = @p_id)

    if (@@Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @@Error
       end 

   if (@@tranCount > @v_TrancountOnEntry)
       commit
    
  return 
end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_Close] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_Close] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_DETAIL_Delete...'
go


CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Delete]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура удаляет дет информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 
   if (@p_sys_user is null)
   set @p_sys_user = user_name()

  update dbo.CWFL_ROUTE_FLOW_DETAIL
     set SYS_STATUS = 2
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id
  

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Delete] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_DETAIL_Insert...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Insert]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна вставить информацию о детали потока
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint out,
    @p_RUNTIME_STATUS tinyint,
    @p_ROUTE_FLOW_MASTER_ID  bigint,
    @p_MESSAGE_ID            bigint,
    @p_START_TIME     datetime = null,
    @p_END_TIME       datetime = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
		 insert into dbo.CWFL_ROUTE_FLOW_DETAIL
  (RUNTIME_STATUS, ROUTE_FLOW_MASTER_ID, MESSAGE_ID
  ,START_TIME, END_TIME, SYS_COMMENT, SYS_USER_CREATED)
   values
  (@p_RUNTIME_STATUS, @p_ROUTE_FLOW_MASTER_ID, @p_MESSAGE_ID
  ,@p_START_TIME, @p_END_TIME, @p_SYS_COMMENT, @p_SYS_USER)

   set @p_id = scope_identity()

end
go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Insert] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Insert] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_DETAIL_SelectById...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_DETAIL_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение детали потока по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id bigint
)
AS
  set nocount on
  

	SELECT ID
       ,RUNTIME_STATUS
       ,ROUTE_FLOW_MASTER_ID
       ,MESSAGE_ID
       ,START_TIME
       ,END_TIME
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VWFL_ROUTE_FLOW_DETAIL
    where ID = @p_Id

	RETURN

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_DETAIL_Update...'
go

create procedure [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Update]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна изменить информацию о детали потока
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_RUNTIME_STATUS tinyint,
    @p_ROUTE_FLOW_MASTER_ID  bigint,
    @p_MESSAGE_ID       bigint,
    @p_START_TIME     datetime = null,
    @p_END_TIME       datetime = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
		 update dbo.CWFL_ROUTE_FLOW_DETAIL
   set 
   RUNTIME_STATUS = @p_RUNTIME_STATUS
 , ROUTE_FLOW_MASTER_ID = @p_ROUTE_FLOW_MASTER_ID
 , MESSAGE_ID = @p_MESSAGE_ID
 , START_TIME = @p_START_TIME
 , END_TIME = @p_END_TIME
 , SYS_COMMENT = @p_SYS_COMMENT
 , SYS_USER_MODIFIED = @p_SYS_USER
  where ID = @p_id

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Update] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_DETAIL_Update] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_FindFlowByMessage_Id...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_FindFlowByMessage_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id потока по его Message_Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      24.04.2007 VLavrentiev	Изменил название ид
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Message_Id bigint
)
AS
  set nocount on
  

	SELECT ID
	FROM dbo.VWFL_ROUTE_FLOW
    where MESSAGE_ID = @p_Message_Id
    group by ID

	RETURN
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowByMessage_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowByMessage_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_FindFlowbyObject_Id...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_FindFlowbyObject_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Ид потока по Id Party объекта
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Object_Id bigint
)
AS
  set nocount on
  

	SELECT ID
	FROM VWFL_ROUTE_FLOW
    where OBJECT_ID = @p_OBJECT_Id
    group by ID

	RETURN
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowbyObject_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowbyObject_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_FindFlowByUser_Id...'
go

create PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_FindFlowByUser_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id пользователей по его ид потока
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_USER_ID bigint
)
AS
begin
  set nocount on
  
select vrfm.id from 
        dbo.VUSR_USER_GROUP vug
  join  dbo.VWFL_ROUTE_DETAIL vrd
    on  vug.GROUP_ID = vrd.GROUP_ID
  join  VWFL_ROUTE_FLOW_MASTER  vrfm
    on  vrd.id = vrfm.ROUTE_DETAIL_ID
where vug.USER_ID = @p_USER_ID

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowByUser_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_FindFlowByUser_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_FindRouteByMessage_Id...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_FindRouteByMessage_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id маршрута по Id сообщения
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Message_Id bigint
)
AS
  set nocount on
  

	SELECT ROUTE_MASTER_ID
	FROM dbo.VWFL_ROUTE_FLOW
        where MESSAGE_ID = @p_Message_Id
        group by ROUTE_MASTER_ID

	RETURN
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_FindRouteByMessage_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_FindRouteByMessage_Id] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_FindUserByRTFM_Id...'
go


CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_FindUserByRTFM_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id пользователей по его ид потока
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.1      17.04.2007 VLavrentiev	Добавил группировку
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_ROUTE_FLOW_MASTER_ID bigint
)
AS
begin
  set nocount on
 
select  a.USER_ID from
(select TOP(100) PERCENT 
  vug.USER_ID from 
  dbo.VWFL_ROUTE_FLOW_MASTER  vrfm
join dbo.VWFL_ROUTE_MASTER vrm
  on vrfm.ROUTE_MASTER_ID = vrm.id
join dbo.VWFL_ROUTE_DETAIL vrd
  on vrm.id = vrd.ROUTE_MASTER_ID
join dbo.VUSR_USER_GROUP vug
  on vrd.GROUP_ID = vug.GROUP_ID
where vrfm.id  = @p_ROUTE_FLOW_MASTER_ID
 order by vrd.SORT_FIELD asc) a
group by a.USER_ID

end

go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_FindUserByRTFM_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_FindUserByRTFM_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_MASTER_Delete...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_MASTER_Delete]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура удаляет дет информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 

 if (@p_sys_user is null)
   set @p_sys_user = user_name()

  update dbo.CWFL_ROUTE_FLOW_MASTER
     set SYS_STATUS = 2
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Delete] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_MASTER_Insert...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_MASTER_Insert]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна вставить информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id               bigint = null out,
    @p_RUNTIME_STATUS   tinyint,
    @p_ROUTE_MASTER_ID  bigint = null,
    @p_ROUTE_DETAIL_ID  bigint,
    @p_START_TIME     datetime = null,
    @p_END_TIME       datetime = null,
    @p_GROUP_ID    bigint = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
		     insert into
			     dbo.CWFL_ROUTE_FLOW_MASTER 
            (RUNTIME_STATUS, ROUTE_MASTER_ID, ROUTE_DETAIL_ID
           , START_TIME, END_TIME, GROUP_ID ,sys_comment, sys_user_created)
	      	values
			         (@p_RUNTIME_STATUS, @p_ROUTE_MASTER_ID, @p_ROUTE_DETAIL_ID
           , @p_START_TIME, @p_END_TIME, @p_GROUP_ID ,@p_sys_comment, @p_sys_user)

       set @p_id = scope_identity()
end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Insert] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Insert] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_MASTER_SelectById...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_FLOW_MASTER_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение потока по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id bigint
)
AS
  set nocount on
  

	SELECT ID
       ,RUNTIME_STATUS
       ,ROUTE_MASTER_ID
       ,ROUTE_DETAIL_ID
       ,START_TIME
       ,END_TIME
       ,GROUP_ID
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VWFL_ROUTE_FLOW_MASTER
    where ID = @p_Id

	RETURN
go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_MASTER_Update...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_MASTER_Update]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна изменить информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint,
    @p_RUNTIME_STATUS tinyint,
    @p_ROUTE_MASTER_ID  bigint = null,
    @p_ROUTE_DETAIL_ID  bigint,
    @p_START_TIME     datetime = null,
    @p_END_TIME       datetime = null,
    @p_GROUP_ID  bigint = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
		     
  -- надо править существующий
		update dbo.CWFL_ROUTE_FLOW_MASTER set
		      RUNTIME_STATUS =  @p_RUNTIME_STATUS,
		      ROUTE_MASTER_ID = @p_ROUTE_MASTER_ID,
        ROUTE_DETAIL_ID = @p_ROUTE_DETAIL_ID,
        START_TIME  = @p_START_TIME,
        END_TIME  = @p_END_TIME,
        GROUP_ID = @p_GROUP_ID,
        sys_comment = @p_sys_comment,
        sys_user_modified = @p_sys_user
		where ID = @p_id
          and sys_status = 1

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Update] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_Update] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_MASTER_UpdateStatus...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_MASTER_UpdateStatus]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна установить статус потока
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил обработку ид группы-пользователя
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint,
    @p_RUNTIME_STATUS tinyint,
    @p_GROUP_ID bigint,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 
 
		     
  -- надо править существующий
		update dbo.CWFL_ROUTE_FLOW_MASTER set
		      RUNTIME_STATUS =  @p_RUNTIME_STATUS,
        GROUP_ID = @p_GROUP_ID,
        sys_comment = @p_sys_comment,
        sys_user_modified = @p_sys_user
		where ID = @p_id

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_UpdateStatus] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_MASTER_UpdateStatus] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_Delete...'
go


CREATE procedure [dbo].[spVWFL_ROUTE_MASTER_Delete]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура удаляет информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 

if (@p_sys_user is null)
   set @p_sys_user = user_name()

  update dbo.CWFL_ROUTE_MASTER
     set SYS_STATUS = 2
        ,SYS_COMMENT = @p_sys_comment
        ,SYS_USER_MODIFIED = @p_sys_user
   where id = @p_id
 

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_Delete] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_Insert...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_MASTER_Insert]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна вставить информацию о маршруте
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint = null out,
    @p_DESCRIPTION nvarchar(256),
    @p_IS_DEFAULT  bit = 0,
    @p_FOR_VIP_CLIENT        bit = 0,
    @p_FOR_CLIENT_WEIGHT     int = null,
    @p_FOR_PROBLEM_CLIENT    bit = 0,
    @p_PROBLEM_TYPE_ID  bigint = null,
    @p_OBJECT_TYPE_ID   bigint = null,
    @p_BLOCK_ID         bigint = null,
    @p_STATE_ID              bigint = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 

   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 

    if (@p_OBJECT_TYPE_ID is null)
    set @p_OBJECT_TYPE_ID = dbo.sfCONST('MO_TYPE')


		     insert into
			     dbo.CWFL_ROUTE_MASTER 
            (DESCRIPTION, IS_DEFAULT, FOR_VIP_CLIENT
           , FOR_CLIENT_WEIGHT, FOR_PROBLEM_CLIENT, PROBLEM_TYPE_ID
           , OBJECT_TYPE_ID, BLOCK_ID, STATE_ID
           ,sys_comment, sys_user_created)
	      	values
			         (@p_DESCRIPTION, @p_IS_DEFAULT,@p_FOR_VIP_CLIENT
           , @p_FOR_CLIENT_WEIGHT, @p_FOR_PROBLEM_CLIENT, @p_PROBLEM_TYPE_ID
           , @p_OBJECT_TYPE_ID, @p_BLOCK_ID , @p_STATE_ID 
           , @p_sys_comment, @p_sys_user)

        set @p_id = scope_identity()
    
  return    

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_Insert] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_Insert] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_SelectAll...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_MASTER_SelectAll]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение маршрутов
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      25.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
AS
  set nocount on
  

	SELECT ID
       ,DESCRIPTION
       ,IS_DEFAULT
       ,FOR_VIP_CLIENT
       ,FOR_CLIENT_WEIGHT
       ,FOR_PROBLEM_CLIENT
       ,PROBLEM_TYPE_ID
       ,OBJECT_TYPE_ID
       ,BLOCK_ID
       ,STATE_ID
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VWFL_ROUTE_MASTER

	RETURN
go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_SelectAll] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_SelectAll] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_SelectById...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_MASTER_SelectById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение маршрута по Id
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Id bigint
)
AS
  set nocount on
  

	SELECT ID
       ,DESCRIPTION
       ,IS_DEFAULT
       ,FOR_VIP_CLIENT
       ,FOR_CLIENT_WEIGHT
       ,FOR_PROBLEM_CLIENT
       ,PROBLEM_TYPE_ID
       ,OBJECT_TYPE_ID
       ,BLOCK_ID
       ,STATE_ID
       ,SYS_STATUS 
       ,SYS_COMMENT 
       ,SYS_DATE_MODIFIED 
       ,SYS_DATE_CREATED
       ,SYS_USER_MODIFIED 
       ,SYS_USER_CREATED
	FROM dbo.VWFL_ROUTE_MASTER
    where ID = @p_Id

	RETURN

go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_SelectById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_SelectById] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_SelectByMessage_Id...'
go

CREATE PROCEDURE [dbo].[spVWFL_ROUTE_MASTER_SelectByMessage_Id]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Получение Id маршрута по Id сообщения
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
@p_Message_Id bigint
)
AS
  set nocount on
  
SELECT vrm.ID
        ,vrm.DESCRIPTION
        ,vrm.IS_DEFAULT
        ,vrm.FOR_VIP_CLIENT
        ,vrm.FOR_CLIENT_WEIGHT
        ,vrm.FOR_PROBLEM_CLIENT
        ,vrm.PROBLEM_TYPE_ID
        ,vrm.OBJECT_TYPE_ID
        ,vrm.BLOCK_ID
        ,vrm.STATE_ID
        ,vrm.SYS_STATUS 
        ,vrm.SYS_COMMENT 
        ,vrm.SYS_DATE_MODIFIED 
        ,vrm.SYS_DATE_CREATED
        ,vrm.SYS_USER_MODIFIED 
        ,vrm.SYS_USER_CREATED
	FROM  dbo.VWFL_MESSAGE vm
  join dbo.VWFL_MESSAGE_TYPE_ROUTE_MASTER vmtrm
      on vm.MESSAGE_TYPE_ID = vmtrm.MESSAGE_TYPE_ID
  join dbo.VWFL_ROUTE_MASTER vrm
      on vmtrm.ROUTE_MASTER_ID = vrm.id
 where vm.id = @p_Message_Id

	RETURN
go


GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_SelectByMessage_Id] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_SelectByMessage_Id] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_MASTER_Update...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_MASTER_Update]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна изменить информацию о маршруте
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      12.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id          bigint,
    @p_DESCRIPTION nvarchar(256),
    @p_IS_DEFAULT  bit = 0,
    @p_FOR_VIP_CLIENT        bit = 0,
    @p_FOR_CLIENT_WEIGHT     int = null,
    @p_FOR_PROBLEM_CLIENT    bit = 0,
    @p_PROBLEM_TYPE_ID  bigint = null,
    @p_OBJECT_TYPE_ID   bigint = null,
    @p_BLOCK_ID         bigint = null,
    @p_STATE_ID              bigint = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user    nvarchar(30) = null
)
as
begin
  set nocount on 
  
   
    if (@p_sys_user is null)
    set @p_sys_user = user_name() 

    if (@p_OBJECT_TYPE_ID is null)
    set @p_OBJECT_TYPE_ID = dbo.sfCONST('MO_TYPE')

 
		     update 
			     dbo.CWFL_ROUTE_MASTER 
          set DESCRIPTION = @p_DESCRIPTION
             ,IS_DEFAULT = @p_IS_DEFAULT
             ,FOR_VIP_CLIENT = @p_FOR_VIP_CLIENT
             ,FOR_CLIENT_WEIGHT = @p_FOR_CLIENT_WEIGHT
             ,FOR_PROBLEM_CLIENT = @p_FOR_PROBLEM_CLIENT
             ,PROBLEM_TYPE_ID = @p_PROBLEM_TYPE_ID
             ,OBJECT_TYPE_ID = @p_OBJECT_TYPE_ID
             ,BLOCK_ID = @p_BLOCK_ID
             ,STATE_ID = @p_STATE_ID
             ,sys_comment = @p_sys_comment
             ,sys_user_modified = @p_sys_user
       where id = @p_id
    
  return    

end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_MASTER_Update] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_MASTER_Update] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVWFL_ROUTE_FLOW_Delete...'
go

CREATE procedure [dbo].[spVWFL_ROUTE_FLOW_Delete]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура удаляет информацию о потоке
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      16.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id             bigint,
    @p_sys_comment    nvarchar(2000) = null,
    @p_sys_user       nvarchar(30) = null
)
as
begin
  set nocount on 
  set xact_abort on
  

   declare @v_Error int
         , @v_TrancountOnEntry int

     set @v_Error = 0
     set @v_TrancountOnEntry = @@tranCount

   if (@p_sys_user is null)
   set @p_sys_user = user_name()

   if (@@tranCount = 0)
        begin transaction  

   exec 
    @v_Error = dbo.spVWFL_ROUTE_FLOW_MASTER_Delete
              @p_id = @p_id
             ,@p_sys_comment =  @p_sys_comment
             ,@p_sys_user = @p_sys_user
 
   if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   
    exec 
     @v_Error = dbo.spVWFL_ROUTE_FLOW_DETAIL_Delete
              @p_id = @p_id
             ,@p_sys_comment =  @p_sys_comment
             ,@p_sys_user = @p_sys_user


      if (@v_Error > 0)
       begin 
         if (@@tranCount > @v_TrancountOnEntry)
              rollback
         return @v_Error
       end 
   

   if (@@tranCount > @v_TrancountOnEntry)
       commit
    
  return 
end
go

GRANT EXECUTE ON [dbo].[spVWFL_ROUTE_FLOW_Delete] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_ROUTE_FLOW_Delete] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVWFL_MESSAGE_Insert...'
go

CREATE procedure [dbo].[spVWFL_MESSAGE_Insert]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура cохранения сообщения в системе
**
**
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.2      10.04.2007 VLavrentiev	Добавил обработку PIN
** 1.1      10.04.2007 VLavrentiev	Добавил обработку id
** 1.0      10.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
    @p_id bigint out,
    @p_MESSAGE_TYPE_ID bigint = null,
    @p_OBJECT_ID bigint = null,
    @p_PROCESSABLE bit = 0,
    @p_PROCESSED bit = 0,
    @p_DATA XML,
    @p_CREATED_TIME datetime = null,
    @p_sys_comment nvarchar(2000) = null,
    @p_sys_user nvarchar(30) = null
)
as
begin
  set nocount on 
  
  if (@p_CREATED_TIME is null)  
   set @p_CREATED_TIME = getdate()
  if (@p_sys_user is null)
   set @p_sys_user = user_name()

insert into dbo.CWFL_MESSAGE_IMPORT
( SYS_COMMENT, SYS_USER_CREATED, MESSAGE_TYPE_ID
, OBJECT_ID, PROCESSABLE, PROCESSED, DATA
, CREATED_TIME,  OBJECT_TYPE_ID )
values
 ( @p_sys_comment, @p_sys_user, @p_MESSAGE_TYPE_ID
, @p_OBJECT_ID,  @p_PROCESSABLE, @p_PROCESSED, @p_DATA
, @p_CREATED_TIME,  null)
         
set @p_id = scope_identity()

end
go

GRANT EXECUTE ON [dbo].[spVWFL_MESSAGE_Insert] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVWFL_MESSAGE_Insert] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVBCK_BLOCK_SmplSearch...'
go

CREATE PROCEDURE [dbo].[spVBCK_BLOCK_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по блокам
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
    FT_TBL.Id
  , FT_TBL.DECODED_CODE
  , FT_TBL.BLOCK_NUMBER
  , FT_TBL.CONFIGURATION_CODE
  , FT_TBL.ENCODED_CODE
  , FT_TBL.SIM_CARD_CODE
  , FT_TBL.LOGICAL_NUMBER_SMS1
  , FT_TBL.LOGICAL_NUMBER_SMS2
  , FT_TBL.LOGICAL_NUMBER_DATA1
  , FT_TBL.LOGICAL_NUMBER_DATA2
  , FT_TBL.LOGICAL_IP_ADRESS1
  , FT_TBL.LOGICAL_IP_ADRESS2
  , FT_TBL.ALARM_NUMBER_SMS1
  , FT_TBL.ALARM_NUMBER_SMS2
  , FT_TBL.ALARM_NUMBER_DATA1
  , FT_TBL.ALARM_NUMBER_DATA2
  , FT_TBL.ALARM_IP_ADRESS1
  , FT_TBL.ALARM_IP_ADRESS2
  , FT_TBL.INSTALL_DATE
  , FT_TBL.IS_MAIN
  , FT_TBL.CFG_TEMPLATE_ID
  , FT_TBL.CFG_TYPE_ID
  , FT_TBL.GUARD_SYSTEM_ID
  , FT_TBL.PLACEMENT_ID
  , FT_TBL.SIM_CARD_ID 
  , FT_TBL.MOBILE_OBJECT_ID 
  , FT_TBL.SYS_STATUS
  , FT_TBL.SYS_COMMENT
  , FT_TBL.SYS_DATE_MODIFIED
  , FT_TBL.SYS_DATE_CREATED
  , FT_TBL.SYS_USER_MODIFIED
  , FT_TBL.SYS_USER_CREATED
  , FT_TBL.PIN
     , KEY_TBL.RANK
  FROM dbo.VBCK_BLOCK AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.BBCK_BLOCK, (BLOCK_NUMBER, DECODED_CODE), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVBCK_BLOCK_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVBCK_BLOCK_SmplSearch] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_MOBILE_OBJECT_SmplSearch...'
go

CREATE PROCEDURE [dbo].[spVOBJ_MOBILE_OBJECT_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по мобильным объектам
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      27.04.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
       FT_TBL.Id
     , FT_TBL.PIN 
     , FT_TBL.OLD_PIN 
     , FT_TBL.STATE_NUMBER 
     , FT_TBL.VIN 
     , FT_TBL.COLOR_ID
     , FT_TBL.MODEL_ID
     , FT_TBL.MODEL_LINE_ID
     , FT_TBL.MARK_ID
     , FT_TBL.KIND_ID
     , FT_TBL.REGION_NAME
     , FT_TBL.YEAR_MARK
     , FT_TBL.SYS_STATUS
     , FT_TBL.SYS_COMMENT
     , FT_TBL.SYS_DATE_MODIFIED
     , FT_TBL.SYS_DATE_CREATED
     , FT_TBL.SYS_USER_MODIFIED
     , FT_TBL.SYS_USER_CREATED
     , KEY_TBL.RANK
  FROM dbo.VOBJ_MOBILE_OBJECT AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.COBJ_MOBILE_OBJECT, (PIN, STATE_NUMBER), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVOBJ_MOBILE_OBJECT_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_MOBILE_OBJECT_SmplSearch] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVOBJ_STATIONARY_OBJECT_SmplSearch...'
go

CREATE PROCEDURE [dbo].[spVOBJ_STATIONARY_OBJECT_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по стационарным объектам
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
       FT_TBL.Id
     , FT_TBL.PIN 
     , FT_TBL.SQUARE
     , FT_TBL.MOUNT_START_DATE 
     , FT_TBL.MOUNT_END_DATE 
     , FT_TBL.ACTIVATION_DATE
     , FT_TBL.IS_PROBLEM
     , FT_TBL.GUARANTEE_END_DATE
     , FT_TBL.KIND_ID
     , FT_TBL.SYS_STATUS
     , FT_TBL.SYS_COMMENT
     , FT_TBL.SYS_DATE_MODIFIED
     , FT_TBL.SYS_DATE_CREATED
     , FT_TBL.SYS_USER_MODIFIED
     , FT_TBL.SYS_USER_CREATED
     , KEY_TBL.RANK
  FROM dbo.VOBJ_STATIONARY_OBJECT AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.COBJ_STATIONARY_OBJECT, (PIN), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVOBJ_STATIONARY_OBJECT_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVOBJ_STATIONARY_OBJECT_SmplSearch] TO [$(db_app_user)]
GO


PRINT ' '
PRINT 'Creating spVPAN_PANEL_SmplSearch...'
go


CREATE PROCEDURE [dbo].[spVPAN_PANEL_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по панелям
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
  FT_TBL.Id
, FT_TBL.INSTALL_DATE
, FT_TBL.DESCRIPTION
, FT_TBL.LAST_TEST_DATE
, FT_TBL.ALARM_VOLUME
, FT_TBL.WITH_AUTOTEST
, FT_TBL.WITH_VIDEOCHECK
, FT_TBL.WITH_AUDIOCHECK
, FT_TBL.WITH_GUARD_SIGNALLING
, FT_TBL.WITH_FIRE_SIGNALLING
, FT_TBL.IS_KTC_CARRYABLE
, FT_TBL.IS_KTC_STATIONARY
, FT_TBL.CKD
, FT_TBL.ATS
, FT_TBL.DEVICE_TYPE_ID
, FT_TBL.SYS_STATUS
, FT_TBL.SYS_COMMENT
, FT_TBL.SYS_DATE_MODIFIED
, FT_TBL.SYS_DATE_CREATED
, FT_TBL.SYS_USER_MODIFIED
, FT_TBL.SYS_USER_CREATED
, FT_TBL.PIN
     , KEY_TBL.RANK
  FROM dbo.VPAN_PANEL AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.PPAN_PANEL, (DESCRIPTION), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go

GRANT EXECUTE ON [dbo].[spVPAN_PANEL_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPAN_PANEL_SmplSearch] TO [$(db_app_user)]
GO



PRINT ' '
PRINT 'Creating spVPRT_ORGANIZATION_SmplSearch...'
go



CREATE PROCEDURE [dbo].[spVPRT_ORGANIZATION_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по юр. лицам
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
       FT_TBL.loc_fact_id
     , FT_TBL.loc_jur_id
     , FT_TBL.id
     , FT_TBL.name
     , FT_TBL.kpp
     , FT_TBL.inn 
     , FT_TBL.SYS_STATUS
     , FT_TBL.SYS_COMMENT
     , FT_TBL.SYS_DATE_MODIFIED
     , FT_TBL.SYS_DATE_CREATED
     , FT_TBL.SYS_USER_MODIFIED
     , FT_TBL.SYS_USER_CREATED
     , KEY_TBL.RANK
  FROM dbo.VPRT_ORGANIZATION AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.CPRT_ORGANIZATION, (name, kpp, inn), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVPRT_ORGANIZATION_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_ORGANIZATION_SmplSearch] TO [$(db_app_user)]
GO

PRINT ' '
PRINT 'Creating spVPRT_PERSON_SmplSearch...'
go


CREATE PROCEDURE [dbo].[spVPRT_PERSON_SmplSearch]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура для простого поиска по физ. лицам
**
**
** @param @p_Str           - Cтрока поиска
** @param @p_Srch_Type     - Тип поиска ( Simple_Term, Prefix_Term ....)
** @param @p_Top_n_by_rank - Выводить TOP N количество попаданий поиска 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      02.05.2007 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(@p_Str nvarchar(100)
,@p_Srch_Type tinyint = null 
,@p_Top_n_by_rank smallint = null
 )
AS
 begin
  set nocount on
  declare
      @v_Srch_Str      nvarchar(1000)
     ,@v_Top_n_by_rank smallint
     ,@v_Param_Definition nvarchar(1000)
 
  set @v_Param_Definition = N'@v_Srch_Str nvarchar(1000), @v_Top_n_by_rank smallint';
    
  
 if (@p_Srch_Type is null)
   set @p_Srch_Type = dbo.sfCONST('ST_SEARCH')

 if (@p_Top_n_by_rank is null)
    set @v_Top_n_by_rank = 1
  
  -- Преобразуем строку поиска
  exec @v_Srch_Str = dbo.sfSrchCndtn_Translate
                                 @p_Str = @p_Str
                                ,@p_Srch_Type = @p_Srch_Type

exec 
sp_executesql N'SELECT 
       FT_TBL.Id
     , FT_TBL.NAME 
     , FT_TBL.SECONDNAME
     , FT_TBL.SURNAME 
     , FT_TBL.SEX 
     , FT_TBL.BIRTHDATE 
     , FT_TBL.loc_fact_id
     , FT_TBL.SYS_STATUS
     , FT_TBL.SYS_COMMENT
     , FT_TBL.SYS_DATE_MODIFIED
     , FT_TBL.SYS_DATE_CREATED
     , FT_TBL.SYS_USER_MODIFIED
     , FT_TBL.SYS_USER_CREATED
     , KEY_TBL.RANK
  FROM dbo.VPRT_PERSON AS FT_TBL INNER JOIN
   CONTAINSTABLE (dbo.CPRT_PERSON, (NAME, SECONDNAME, SURNAME), 
           @v_Srch_Str
         , @v_Top_n_by_rank
   ) AS KEY_TBL
   ON FT_TBL.Id = KEY_TBL.[KEY]', @v_Param_Definition
                                , @v_Srch_Str = @v_Srch_Str
                                , @v_Top_n_by_rank = @v_Top_n_by_rank

  
	 RETURN
 end
go


GRANT EXECUTE ON [dbo].[spVPRT_PERSON_SmplSearch] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[spVPRT_PERSON_SmplSearch] TO [$(db_app_user)]
GO