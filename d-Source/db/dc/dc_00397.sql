:r ./../_define.sql

:setvar dc_number 00397
:setvar dc_description "logon log added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   22.11.2008 VLavrentiev  logon log added
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
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CSYS_LOGON_LOG](
	[id] [numeric](38, 0) IDENTITY(1000,1) NOT NULL,
	[sys_status] [tinyint] NOT NULL DEFAULT ((1)),
	[sys_comment] [varchar](2000) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT ('-'),
	[sys_date_modified] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_date_created] [datetime] NOT NULL DEFAULT (getdate()),
	[sys_user_modified] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[sys_user_created] [varchar](30) COLLATE Cyrillic_General_CI_AS NOT NULL DEFAULT (user_name()),
	[party_id] [numeric](38, 0) NOT NULL,
	[session_id] [numeric](38, 0) NOT NULL,
 CONSTRAINT [CSYS_LOGON_LOG_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (IGNORE_DUP_KEY = OFF) ON [$(fg_idx_name)]
) ON [$(fg_idx_name)]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Системный статус записи' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_status'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Комментарий' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_comment'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата модификации' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_date_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата создания' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_date_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, модифицировавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_user_modified'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Пользователь, создавший запись' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'sys_user_created'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид пользователя' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'party_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид сессии' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG', @level2type=N'COLUMN', @level2name=N'session_id'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица пользователей' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CSYS_LOGON_LOG'

GO

ALTER TABLE [dbo].[CSYS_LOGON_LOG]  WITH CHECK ADD  CONSTRAINT [CSYS_LOGON_LOG_PARTY_ID_FK] FOREIGN KEY([party_id])
REFERENCES [dbo].[CPRT_PARTY] ([id])

create index ifk_csys_logon_log_party_id on dbo.CSYS_LOGON_LOG(party_id)
on $(fg_idx_name)
go

create index i_csys_logon_log_session_id on dbo.CSYS_LOGON_LOG(session_id)
on $(fg_idx_name)
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[uspCSYS_LOGON_LOG_SaveById]
/******************************************************************************
**
** Author : VLavrentiev
**
**-----------------------------------------------------------------------------
** Description:
** Процедура должна сохранить информацию о подключении пользователя
**
**  Входные параметры: 
**------------------------------------------------------------------------------
** Version: Date:      Author:		Comments:
** 1.0      22.11.2008 VLavrentiev	Добавил новую процедуру
*******************************************************************************/
(
     @p_username          numeric(38,0)
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


	   insert into
			     dbo.CSYS_LOGON_LOG 
            (party_id, session_id, sys_comment, sys_user_created, sys_user_modified)
	   select id, @@SPID, @p_sys_comment, @p_sys_user, @p_sys_user 
		 from dbo.CPRT_USER
		where  username = @p_username
       
	
    
  return  

end
go


GRANT EXECUTE ON [dbo].[uspCSYS_LOGON_LOG_SaveById] TO [$(db_app_user)]
GO

GRANT VIEW DEFINITION ON [dbo].[uspCSYS_LOGON_LOG_SaveById] TO [$(db_app_user)]
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

:r _add_chis_all_objects.sql


