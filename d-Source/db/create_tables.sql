/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DB owner 
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 10.02.2008    VLavrentiev    ������ ��� �������� ������ �� ANGEL_TO_001
 ================================================================================== */ 

/*==============================================================*/
/* Table: CLOC_ABBREVIATION                                     */
/*==============================================================*/
create table CLOC_ABBREVIATION (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(10)          null,
   full_name            varchar(250)         not null,
   external_code        varchar(30)          null,
   parent_id            numeric(38,0)        null,
   constraint cloc_abbreviation_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �����������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������ ��������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'full_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'external_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ��������',
   'user', @CurrentUser, 'table', 'CLOC_ABBREVIATION', 'column', 'parent_id'
go

/*==============================================================*/
/* Table: CLOC_COUNTRY                                          */
/*==============================================================*/
create table CLOC_COUNTRY (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   country_char2        char(2)              null,
   country_char3        char(3)              null,
   short_name           varchar(50)          null,
   full_name            varchar(250)         not null,
   constraint cloc_country_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �����',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������ ������������ ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'country_char2'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������ ������������ ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'country_char3'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������� �������� ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������ �������� ������',
   'user', @CurrentUser, 'table', 'CLOC_COUNTRY', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CLOC_DISTRICT                                         */
/*==============================================================*/
create table CLOC_DISTRICT (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(250)         not null,
   settlement_id        numeric(38,0)        not null,
   abbreviation_id      numeric(38,0)        null,
   external_code        varchar(30)          null,
   constraint cloc_district_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'settlement_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'abbreviation_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_DISTRICT', 'column', 'external_code'
go

/*==============================================================*/
/* Table: CLOC_LOCATION                                         */
/*==============================================================*/
create table CLOC_LOCATION (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   country_id           numeric(38,0)        not null,
   state_id             numeric(38,0)        null,
   region_id            numeric(38,0)        not null,
   settlement_id        numeric(38,0)        not null,
   district_id          numeric(38,0)        null,
   street_id            numeric(38,0)        not null,
   location_string      varchar(2000)        null,
   house                varchar(10)          null,
   building             varchar(30)          null,
   structure            varchar(30)          null,
   doorway              varchar(10)          null,
   doorway_code         varchar(10)          null,
   flat                 varchar(10)          null,
   room                 varchar(10)          null,
   description          varchar(250)         null,
   zip_code             varchar(30)          null,
   external_code        varchar(30)          null,
   constraint cloc_location_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����������������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'country_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���. �������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'region_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'settlement_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'district_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �����',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'street_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'location_string'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'house'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'building'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'structure'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'doorway'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��� ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'doorway_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'flat'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'room'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'description'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'zip_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION', 'column', 'external_code'
go

/*==============================================================*/
/* Table: CLOC_LOCATION_LINK                                    */
/*==============================================================*/
create table CLOC_LOCATION_LINK (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   location_id          numeric(38,0)        not null,
   location_type_id     numeric(38,0)        not null,
   table_name           int                  not null,
   record_id            numeric(38,0)        not null,
   is_default           bit                  not null default 1,
   constraint cloc_loc_lnk_pk primary key (location_id, location_type_id, table_name, record_id, is_default)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ������ ������� � �������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'location_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'location_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������� �������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'table_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'record_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������ �� ��������� ��� ���',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_LINK', 'column', 'is_default'
go

/*==============================================================*/
/* Table: CLOC_LOCATION_TYPE                                    */
/*==============================================================*/
create table CLOC_LOCATION_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cloc_location_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����� �������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������ ��������',
   'user', @CurrentUser, 'table', 'CLOC_LOCATION_TYPE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CLOC_REGION                                           */
/*==============================================================*/
create table CLOC_REGION (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(250)         not null,
   external_code        varchar(30)          null,
   zip_code             varchar(30)          null,
   state_id             numeric(38,0)        not null,
   abbreviation_id      numeric(38,0)        null,
   constraint cloc_region_pk primary key nonclustered (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��������',
   'user', @CurrentUser, 'table', 'CLOC_REGION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'external_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'zip_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �����. �������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CLOC_REGION', 'column', 'abbreviation_id'
go

/*==============================================================*/
/* Table: CLOC_SETTLEMENT                                       */
/*==============================================================*/
create table CLOC_SETTLEMENT (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(250)         null,
   state_id             numeric(38,0)        null,
   region_id            numeric(38,0)        not null,
   abbreviation_id      numeric(38,0)        null,
   is_capital           tinyint              not null default 0,
   external_code        varchar(30)          null,
   zip_code             varchar(30)          null,
   constraint cloc_settlement_pk primary key nonclustered (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ���������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���. �������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'state_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'region_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'abbreviation_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������� �������� ��� ���',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'is_capital'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'external_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CLOC_SETTLEMENT', 'column', 'zip_code'
go

/*==============================================================*/
/* Table: CLOC_STATE                                            */
/*==============================================================*/
create table CLOC_STATE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(250)         not null,
   external_code        varchar(30)          null,
   zip_code             varchar(30)          null,
   country_id           numeric(38,0)        not null,
   abbreviation_id      numeric(38,0)        null,
   constraint cloc_state_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_STATE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'external_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'zip_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'country_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CLOC_STATE', 'column', 'abbreviation_id'
go

/*==============================================================*/
/* Table: CLOC_STREET                                           */
/*==============================================================*/
create table CLOC_STREET (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(250)         not null,
   settlement_id        numeric(38,0)        not null,
   abbreviation_id      numeric(38,0)        null,
   external_code        varchar(30)          null,
   zip_code             varchar(30)          null,
   constraint cloc_street_pk primary key nonclustered (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����',
   'user', @CurrentUser, 'table', 'CLOC_STREET'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���. �������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'settlement_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'abbreviation_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'external_code'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CLOC_STREET', 'column', 'zip_code'
go

/*==============================================================*/
/* Table: CNOT_NOTE                                             */
/*==============================================================*/
create table CNOT_NOTE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   body                 varchar(4000)        not null,
   constraint cnot_note_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '����� �������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE', 'column', 'body'
go

/*==============================================================*/
/* Table: CNOT_NOTE_LINK                                        */
/*==============================================================*/
create table CNOT_NOTE_LINK (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   note_type_id         numeric(38,0)        not null,
   note_id              numeric(38,0)        not null,
   table_name           int                  not null,
   record_id            numeric(38,0)        not null,
   is_default           bit                  not null,
   constraint cnot_note_link_pk primary key (note_type_id, note_id, table_name, record_id, is_default)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ������ ������� � ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���� �������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'note_type_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'note_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��� �����',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'table_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'record_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �� ��������� ��� ���',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_LINK', 'column', 'is_default'
go

/*==============================================================*/
/* Table: CNOT_NOTE_TYPE                                        */
/*==============================================================*/
create table CNOT_NOTE_TYPE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   short_name           varchar(30)          not null,
   full_name            varchar(60)          not null,
   constraint cnot_note_type_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����� �������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'short_name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������ ��������',
   'user', @CurrentUser, 'table', 'CNOT_NOTE_TYPE', 'column', 'full_name'
go

/*==============================================================*/
/* Table: CPRT_EMPLOYEE                                         */
/*==============================================================*/
create table CPRT_EMPLOYEE (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   organization_id      numeric(38,0)        not null,
   person_id            numeric(38,0)        null,
   constraint cprt_employee_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� �����������',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'organization_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ���. ����',
   'user', @CurrentUser, 'table', 'CPRT_EMPLOYEE', 'column', 'person_id'
go

/*==============================================================*/
/* Table: CPRT_GROUP                                            */
/*==============================================================*/
create table CPRT_GROUP (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(100)         not null,
   constraint cprt_group_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����� �������������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������',
   'user', @CurrentUser, 'table', 'CPRT_GROUP', 'column', 'name'
go

/*==============================================================*/
/* Table: CPRT_ORGANIZATION                                     */
/*==============================================================*/
create table CPRT_ORGANIZATION (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(100)         not null,
   constraint cprt_organization_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �����������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CPRT_ORGANIZATION', 'column', 'name'
go

/*==============================================================*/
/* Table: CPRT_PARTY                                            */
/*==============================================================*/
create table CPRT_PARTY (
   id                   numeric(38,0)        identity(1000,1),
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   constraint cprt_party_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ��� ����� ������������� � �������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_PARTY', 'column', 'sys_user_created'
go

/*==============================================================*/
/* Table: CPRT_PERSON                                           */
/*==============================================================*/
create table CPRT_PERSON (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   name                 varchar(60)          null,
   lastname             varchar(100)         not null,
   surname              varchar(60)          null,
   sex                  bit                  null default 1,
   birthdate            datetime             null,
   constraint cprt_person_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ���������� ���',
   'user', @CurrentUser, 'table', 'CPRT_PERSON'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'name'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'lastname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'surname'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'sex'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_PERSON', 'column', 'birthdate'
go

/*==============================================================*/
/* Table: CPRT_USER                                             */
/*==============================================================*/
create table CPRT_USER (
   id                   numeric(38,0)        not null,
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   username             varchar(60)          not null,
   password             varchar(60)          not null,
   constraint cprt_user_pk primary key (id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� �������������',
   'user', @CurrentUser, 'table', 'CPRT_USER'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'username'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������',
   'user', @CurrentUser, 'table', 'CPRT_USER', 'column', 'password'
go

/*==============================================================*/
/* Table: CPRT_USER_GROUP                                       */
/*==============================================================*/
create table CPRT_USER_GROUP (
   sys_status           tinyint              not null default 1,
   sys_comment          varchar(2000)        not null default '-',
   sys_date_modified    datetime             not null default getdate(),
   sys_date_created     datetime             not null default getdate(),
   sys_user_modified    varchar(30)          not null default user_name(),
   sys_user_created     varchar(30)          not null default user_name(),
   user_id              numeric(38,0)        not null,
   group_id             numeric(38,0)        not null,
   constraint cprt_user_group_pk primary key (user_id, group_id)
         on $(db_name)_IDX
)
on "$(db_name)_DAT"
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������� ����� ������������� � �����',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '��������� ������ ������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_status'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�����������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_comment'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� �����������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_date_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '���� ��������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_date_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ���������������� ������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_user_modified'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '������������, ��������� ������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'sys_user_created'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'user_id'
go

declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   '�� ������',
   'user', @CurrentUser, 'table', 'CPRT_USER_GROUP', 'column', 'group_id'
go

alter table CLOC_ABBREVIATION
   add constraint CLOC_ABBREVIATION_PARENT_ID_FK foreign key (parent_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_DISTRICT
   add constraint CLOC_DISTRICT_ABBR_ID_FK foreign key (abbreviation_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_DISTRICT
   add constraint CLOC_DISTRICT_STLTMT_ID_FK foreign key (settlement_id)
      references CLOC_SETTLEMENT (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_COUNTRY_ID_FK foreign key (country_id)
      references CLOC_COUNTRY (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_DISTRICT_ID_FK foreign key (district_id)
      references CLOC_DISTRICT (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_REGION_ID_FK foreign key (region_id)
      references CLOC_REGION (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_STATE_ID_FK foreign key (state_id)
      references CLOC_STATE (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_STLMT_ID_FK foreign key (settlement_id)
      references CLOC_SETTLEMENT (id)
go

alter table CLOC_LOCATION
   add constraint CLOC_LOCATION_STREET_ID_FK foreign key (street_id)
      references CLOC_STREET (id)
go

alter table CLOC_LOCATION_LINK
   add constraint CLOC_LOC_LINK_LOC_TYPE_ID_FK foreign key (location_type_id)
      references CLOC_LOCATION_TYPE (id)
go

alter table CLOC_LOCATION_LINK
   add constraint CLOC_LOC_LNK_LOC_ID_FK foreign key (location_id)
      references CLOC_LOCATION (id)
go

alter table CLOC_REGION
   add constraint CLOC_REGION_ABBR_ID_FK foreign key (abbreviation_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_REGION
   add constraint CLOC_REGION_STATE_ID_FK foreign key (state_id)
      references CLOC_STATE (id)
go

alter table CLOC_SETTLEMENT
   add constraint CLOC_SETTLEMENT_ABBR_ID_FK foreign key (abbreviation_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_SETTLEMENT
   add constraint CLOC_SETTLEMENT_REGION_ID_FK foreign key (region_id)
      references CLOC_REGION (id)
go

alter table CLOC_SETTLEMENT
   add constraint CLOC_SETTLEMENT_STATE_ID_FK foreign key (state_id)
      references CLOC_STATE (id)
go

alter table CLOC_STATE
   add constraint CLOC_STATE_ABBR_ID_FK foreign key (abbreviation_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_STATE
   add constraint CLOC_STATE_COUNTRY_ID_FK foreign key (country_id)
      references CLOC_COUNTRY (id)
go

alter table CLOC_STREET
   add constraint CLOC_STREET_ABBR_ID_FK foreign key (abbreviation_id)
      references CLOC_ABBREVIATION (id)
go

alter table CLOC_STREET
   add constraint CLOC_STREET_STLMT_ID_FK foreign key (settlement_id)
      references CLOC_SETTLEMENT (id)
go

alter table CNOT_NOTE_LINK
   add constraint CNOT_NOTE_LINK_NOTE_ID_FK foreign key (note_id)
      references CNOT_NOTE (id)
go

alter table CNOT_NOTE_LINK
   add constraint CNOT_NOTE_LINK_NOTE_TYPE_ID_FK foreign key (note_type_id)
      references CNOT_NOTE_TYPE (id)
go

alter table CPRT_EMPLOYEE
   add constraint CPRT_EMP_ORGANIZATION_ID_FK foreign key (organization_id)
      references CPRT_ORGANIZATION (id)
go

alter table CPRT_EMPLOYEE
   add constraint CPRT_EMP_PERSON_ID_FK foreign key (person_id)
      references CPRT_PERSON (id)
go

alter table CPRT_GROUP
   add constraint CPRT_GROUP_PARTY_ID_FK foreign key (id)
      references CPRT_PARTY (id)
go

alter table CPRT_ORGANIZATION
   add constraint CPRT_ORGANIZATION_PARTY_ID_FK foreign key (id)
      references CPRT_PARTY (id)
go

alter table CPRT_PERSON
   add constraint CPRT_PERSON_PARTY_FK foreign key (id)
      references CPRT_PARTY (id)
go

alter table CPRT_USER
   add constraint CPRT_USER_PARTY_ID_FK foreign key (id)
      references CPRT_PARTY (id)
go

alter table CPRT_USER_GROUP
   add constraint CPRT_USER_GROUP_GROUP_ID_FK foreign key (group_id)
      references CPRT_GROUP (id)
go

alter table CPRT_USER_GROUP
   add constraint CPRT_USER_GROUP_USER_ID_FK foreign key (user_id)
      references CPRT_USER (id)
go



