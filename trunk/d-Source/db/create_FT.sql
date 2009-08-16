/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DB owner
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания Full-Text Search в БД CSSAT
 ================================================================================== */ 


PRINT ' '
PRINT 'creating PartyFTCat...'
go

CREATE FULLTEXT CATALOG PartyFTCat
ON FILEGROUP [$(db_name)_FT00]
go

PRINT ' '
PRINT 'creating FT index on  dbo.CPRT_PERSON...'
go

CREATE FULLTEXT INDEX ON dbo.CPRT_PERSON
     (NAME, SECONDNAME, SURNAME)
     KEY INDEX PK_CPRT_PERSON_ID
          ON PartyFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go

PRINT ' '
PRINT 'creating FT index on dbo.CPRT_ORGANIZATION....'
go

CREATE FULLTEXT INDEX ON dbo.CPRT_ORGANIZATION
     (name, kpp, inn)
     KEY INDEX PK_CPRT_ORGANIZATION_ID
          ON PartyFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go

PRINT ' '
PRINT 'creating FT Catalog on Mobile Objects....'
go

CREATE FULLTEXT CATALOG MobObjFTCat
ON FILEGROUP [$(db_name)_FT00]


PRINT ' '
PRINT 'creating FT index on dbo.COBJ_MOBILE_OBJECT....'
go

CREATE FULLTEXT INDEX ON dbo.COBJ_MOBILE_OBJECT
     (PIN, STATE_NUMBER )
     KEY INDEX PK_COBJ_MOBILE_OBJECT_ID
          ON MobObjFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go



PRINT ' '
PRINT 'creating FT Catalog on Stationary Objects....'
go

CREATE FULLTEXT CATALOG StnryObjFTCat
ON FILEGROUP [$(db_name)_FT00]

go

PRINT ' '
PRINT 'creating FT index on dbo.COBJ_STATIONARY_OBJECT ....'
go

CREATE FULLTEXT INDEX ON dbo.COBJ_STATIONARY_OBJECT
     (PIN)
     KEY INDEX PK_COBJ_STATIONARY_OBJECT_ID
          ON StnryObjFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go

PRINT ' '
PRINT 'creating BlockFTCat...'
go

CREATE FULLTEXT CATALOG BlockFTCat
ON FILEGROUP [$(db_name)_FT00]
go

PRINT ' '
PRINT 'creating FT index on  BBCK_BLOCK...'
go

CREATE FULLTEXT INDEX ON dbo.BBCK_BLOCK
     (BLOCK_NUMBER, DECODED_CODE)
     KEY INDEX PK_BBCK_BLOCK_ID
          ON BlockFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go

PRINT ' '
PRINT 'creating PanelFTCat ....'
go

CREATE FULLTEXT CATALOG PanelFTCat
ON FILEGROUP [$(db_name)_FT00]
go

PRINT ' '
PRINT 'creating FT index on  VPAN_PANEL...'
go

CREATE FULLTEXT INDEX ON dbo.PPAN_PANEL
     (DESCRIPTION)
     KEY INDEX PK_PPAN_PANEL_ID
          ON PanelFTCat
     WITH 
          CHANGE_TRACKING  AUTO 
go

