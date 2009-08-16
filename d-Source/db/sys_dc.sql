
Print 'Creating table SYS_DC'
CREATE TABLE dbo.SYS_DC
(
  M_NUMBER       NUMERIC(10,2) NOT NULL,
  M_SUB_SYSTEM   NVARCHAR(255)  NOT NULL default 'CSSAT',
  M_DATE         datetime      NOT NULL default getdate(),
  M_DESCRIPTION  NVARCHAR(2000)
)
on [$(db_name)_DAT]
go


execute sp_addextendedproperty 'MS_Description', 'Devchange number', 'user', 'dbo', 'table', 'SYS_DC', 'column', 'M_NUMBER'
go

execute sp_addextendedproperty 'MS_Description', 'Branch', 'user', 'dbo', 'table', 'SYS_DC', 'column', 'M_SUB_SYSTEM'
go

execute sp_addextendedproperty 'MS_Description', 'Apply date', 'user', 'dbo', 'table', 'SYS_DC', 'column', 'M_DATE'
go

execute sp_addextendedproperty 'MS_Description', 'Description of devchange', 'user', 'dbo', 'table', 'SYS_DC', 'column', 'M_DESCRIPTION'
go

Print 'Creating primary key for table SYS_DC'
alter table dbo.SYS_DC
   add constraint SYS_DC_PK primary key (M_NUMBER, M_SUB_SYSTEM)
      on [$(db_name)_IDX]
go
