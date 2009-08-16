
/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DB owner
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 04.04.2007    VLavrentiev    Скрипт для создания представлений в БД CSSAT
 ================================================================================== */ 

PRINT ' '
PRINT 'Creating  view VBCK_FIRMWARE...'
go


create VIEW [dbo].[VBCK_FIRMWARE]
AS
  SELECT ID, 
         CODE, 
         DESCRIPTION,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED, 
         SYS_COMMENT
  FROM   dbo.BBCK_FIRMWARE
  WHERE  (SYS_STATUS = 1)
go

PRINT ' '
PRINT 'Creating  view VOBJ_MOBILE_OBJECT...'
go



create view [dbo].[VOBJ_MOBILE_OBJECT]
 as
SELECT Id
     , PIN 
     , OLD_PIN 
     , STATE_NUMBER 
     , VIN 
     , COLOR_ID
     , MODEL_ID
     , MODEL_LINE_ID
     , MARK_ID
     , KIND_ID
     , REGION_NAME
     , YEAR_MARK
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED
	FROM dbo.COBJ_MOBILE_OBJECT
    where sys_status = 1
go



PRINT ' '
PRINT 'Creating view  VBCK_BLOCK...'
go

create view [dbo].[VBCK_BLOCK] 
as
SELECT 
  bck.Id
, bck.DECODED_CODE
, bck.BLOCK_NUMBER
, bck.CONFIGURATION_CODE
, bck.ENCODED_CODE
, bck.SIM_CARD_CODE
, bck.LOGICAL_NUMBER_SMS1
, bck.LOGICAL_NUMBER_SMS2
, bck.LOGICAL_NUMBER_DATA1
, bck.LOGICAL_NUMBER_DATA2
, bck.LOGICAL_IP_ADRESS1
, bck.LOGICAL_IP_ADRESS2
, bck.ALARM_NUMBER_SMS1
, bck.ALARM_NUMBER_SMS2
, bck.ALARM_NUMBER_DATA1
, bck.ALARM_NUMBER_DATA2
, bck.ALARM_IP_ADRESS1
, bck.ALARM_IP_ADRESS2
, bck.INSTALL_DATE
, bck.IS_MAIN
, bck.CFG_TEMPLATE_ID
, bck.CFG_TYPE_ID
, bck.GUARD_SYSTEM_ID
, bck.PLACEMENT_ID
, bck.SIM_CARD_ID 
, bck.SYS_STATUS
, bck.SYS_COMMENT
, bck.SYS_DATE_MODIFIED
, bck.SYS_DATE_CREATED
, bck.SYS_USER_MODIFIED
, bck.SYS_USER_CREATED
, bck.MOBILE_OBJECT_ID
, cmo.PIN
	FROM  dbo.BBCK_BLOCK bck
  left outer join dbo.COBJ_MOBILE_OBJECT cmo
    on bck.MOBILE_OBJECT_ID = cmo.id
    where bck.sys_status = 1
      and isnull(cmo.sys_status, 1) = 1
go

PRINT ' '
PRINT 'Creating view  VCFG_CFG_TYPE...'
go

create VIEW [dbo].[VCFG_CFG_TYPE]
AS
  SELECT ID, 
         FAMILY_ID, 
         FIRMWARE_ID, 
         MODIFICATION_ID, 
         TYPE_ID, 
         VERSION_ID,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED,
         SYS_COMMENT
  FROM   dbo.BCFG_CFG_TYPE
  WHERE  (SYS_STATUS = 1)
go

PRINT ' '
PRINT 'Creating view  VCON_CONTACT...'
go

create view [dbo].[VCON_CONTACT] as
SELECT cc.ID
     , cc.DESCRIPTION
     , cc.CONTACT_TYPE_ID
     , cc.SYS_STATUS
     , cc.SYS_COMMENT
     , cc.SYS_DATE_MODIFIED
     , cc.SYS_DATE_CREATED
     , cc.SYS_USER_MODIFIED
     , cc.SYS_USER_CREATED
	FROM dbo.CCON_CONTACT cc
    where cc.sys_status = 1
go

PRINT ' '
PRINT 'Creating view  VCON_CONTACT_LINK...'
go

create view [dbo].[VCON_CONTACT_LINK] as
SELECT ccl.CONTACT_ID
     , ccl.TABLE_NAME
     , ccl.RECORD_ID
     , ccl.SORT_FIELD
     , ccl.SYS_STATUS
     , ccl.SYS_COMMENT
     , ccl.SYS_DATE_MODIFIED
     , ccl.SYS_DATE_CREATED
     , ccl.SYS_USER_MODIFIED
     , ccl.SYS_USER_CREATED
	FROM dbo.CCON_CONTACT_LINK ccl
    where ccl.sys_status = 1
go

PRINT ' '
PRINT 'Creating view  VAGR_CONTRACT...'
go

create view [dbo].[VAGR_CONTRACT] as
SELECT cc.Id
     , cc.NUMBER 
     , cc.START_DATE 
     , cc.BALANCE 
     , cc.TARIFF_PLAN_ID 
     , cc.OBJECT_ID 
     , co.PIN
     , cc.SYS_STATUS
     , cc.SYS_COMMENT
     , cc.SYS_DATE_MODIFIED
     , cc.SYS_DATE_CREATED
     , cc.SYS_USER_MODIFIED
     , cc.SYS_USER_CREATED
	FROM dbo.CAGR_CONTRACT cc
  JOIN dbo.COBJ_OBJECT co
    on co.id = cc.id
    where cc.sys_status = 1
      and co.sys_status = 1
go


PRINT ' '
PRINT 'Creating view  VAGR_AGREEMENT_ROLE...'
go

create view [dbo].[VAGR_AGREEMENT_ROLE] as
SELECT car.Id
     , car.NAME 
     , car.SYS_STATUS
     , car.SYS_COMMENT
     , car.SYS_DATE_MODIFIED
     , car.SYS_DATE_CREATED
     , car.SYS_USER_MODIFIED
     , car.SYS_USER_CREATED
	FROM dbo.CAGR_AGREEMENT_ROLE car
    where car.sys_status = 1
go

PRINT ' '
PRINT 'Creating view  VAGR_TARIFF_PLAN...'
go


create view [dbo].[VAGR_TARIFF_PLAN] as
SELECT ctp.Id
     , ctp.NAME 
     , ctp.START_DATE
     , ctp.END_DATE
     , ctp.CHARGE
     , ctp.SYS_STATUS
     , ctp.SYS_COMMENT
     , ctp.SYS_DATE_MODIFIED
     , ctp.SYS_DATE_CREATED
     , ctp.SYS_USER_MODIFIED
     , ctp.SYS_USER_CREATED
	FROM dbo.CAGR_TARIFF_PLAN ctp
    where ctp.sys_status = 1
go

PRINT ' '
PRINT 'Creating view  VDEV_VERSION...'
go

create VIEW [dbo].[VDEV_VERSION]
AS 
  SELECT ID, 
         NAME, 
         DESCRIPTION, 
         REF_TYPE_ID,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED, 
         SYS_COMMENT
  FROM   dbo.CDEV_VERSION
  WHERE  (SYS_STATUS = 1)
go

PRINT ' '
PRINT 'Creating view  VLOC_LOCATION...'
go


create view [dbo].[VLOC_LOCATION]
as
select       cloc.id
            ,cloc.LOCATION_STRING
            ,cll.record_id
            ,cll.table_name
            ,cll.location_type_Id 
        from dbo.CLOC_LOCATION_LINK cll
        join dbo.CLOC_LOCATION cloc
         on cll.location_id = cloc.id
      where cll.sys_status = 1
        and cloc.sys_status = 1
go


PRINT ' '
PRINT 'Creating view  VOBJ_SET...'
go

create view [dbo].[VOBJ_SET] as
SELECT cs.Id
     , cs.NAME 
     , cs.REF_TYPE_ID
     , cs.SYS_STATUS
     , cs.SYS_COMMENT
     , cs.SYS_DATE_MODIFIED
     , cs.SYS_DATE_CREATED
     , cs.SYS_USER_MODIFIED
     , cs.SYS_USER_CREATED
	FROM dbo.COBJ_SET cs
    where cs.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VOBJ_KIND...'
go


create view [dbo].[VOBJ_KIND] as
SELECT ck.Id
     , ck.NAME
     , ck.REF_TYPE_ID
     , ck.SYS_STATUS
     , ck.SYS_COMMENT
     , ck.SYS_DATE_MODIFIED
     , ck.SYS_DATE_CREATED
     , ck.SYS_USER_MODIFIED
     , ck.SYS_USER_CREATED 
	FROM dbo.COBJ_KIND ck
    where ck.sys_status = 1
go


PRINT ' '
PRINT 'Creating view VOBJ_MARK...'
go

create view dbo.VOBJ_MARK as
SELECT cm.Id
     , cm.NAME 
     , cm.SYS_STATUS
     , cm.SYS_COMMENT
     , cm.SYS_DATE_MODIFIED
     , cm.SYS_DATE_CREATED
     , cm.SYS_USER_MODIFIED
     , cm.SYS_USER_CREATED 
	FROM dbo.COBJ_MARK cm
    where cm.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VOBJ_MODEL...'
go

create view [dbo].[VOBJ_MODEL] as
SELECT cm.Id
     , cm.NAME 
     , cm.MARK_ID
     , cm.MODEL_LINE_ID
     , cm.SYS_STATUS
     , cm.SYS_COMMENT
     , cm.SYS_DATE_MODIFIED
     , cm.SYS_DATE_CREATED
     , cm.SYS_USER_MODIFIED
     , cm.SYS_USER_CREATED  
	FROM dbo.COBJ_MODEL cm
    where cm.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VOBJ_MODEL_LINE...'
go



create view [dbo].[VOBJ_MODEL_LINE] as
SELECT cml.Id
     , cml.NAME 
     , cml.MARK_ID
     , cml.SYS_STATUS
     , cml.SYS_COMMENT
     , cml.SYS_DATE_MODIFIED
     , cml.SYS_DATE_CREATED
     , cml.SYS_USER_MODIFIED
     , cml.SYS_USER_CREATED 
	FROM dbo.COBJ_MODEL_LINE cml
    where cml.sys_status = 1
go



PRINT ' '
PRINT 'Creating view VOBJ_STATIONARY_OBJECT...'
go


create view [dbo].[VOBJ_STATIONARY_OBJECT]
 as
SELECT Id
     , PIN 
     , SQUARE
     , MOUNT_START_DATE 
     , MOUNT_END_DATE 
     , ACTIVATION_DATE
     , IS_PROBLEM
     , GUARANTEE_END_DATE
     , KIND_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED
	FROM dbo.COBJ_STATIONARY_OBJECT
    where sys_status = 1
go


PRINT ' '
PRINT 'Creating view VPAN_PANEL...'
go


create view [dbo].[VPAN_PANEL] 
as
SELECT 
  pan.Id
, pan.INSTALL_DATE
, pan.DESCRIPTION
, pan.LAST_TEST_DATE
, pan.ALARM_VOLUME
, pan.WITH_AUTOTEST
, pan.WITH_VIDEOCHECK
, pan.WITH_AUDIOCHECK
, pan.WITH_GUARD_SIGNALLING
, pan.WITH_FIRE_SIGNALLING
, pan.IS_KTC_CARRYABLE
, pan.IS_KTC_STATIONARY
, pan.CKD
, pan.ATS
, pan.DEVICE_TYPE_ID
, pan.SYS_STATUS
, pan.SYS_COMMENT
, pan.SYS_DATE_MODIFIED
, pan.SYS_DATE_CREATED
, pan.SYS_USER_MODIFIED
, pan.SYS_USER_CREATED
, cso.PIN
	FROM dbo.PPAN_PANEL pan
  left outer join dbo.COBJ_STATIONARY_OBJECT cso
    on pan.STATIONARY_OBJECT_ID = cso.id
    where pan.sys_status = 1
      and isnull(cso.sys_status, 1) = 1
go

PRINT ' '
PRINT 'Creating view VPRT_EMPLOYEE...'
go


create VIEW [dbo].[VPRT_EMPLOYEE] as
SELECT ID
     , PERSON_ID
     , JOB_TITLE_ID
     , ORGANIZATION_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CPRT_EMPLOYEE
    where sys_status = 1
go

PRINT ' '
PRINT 'Creating view VPRT_JOB_TITLE...'
go

create VIEW [dbo].[VPRT_JOB_TITLE]
AS
  SELECT ID, 
         NAME,
         SYS_STATUS, 
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED, 
         SYS_COMMENT 
  FROM   dbo.CPRT_JOB_TITLE
  WHERE  (SYS_STATUS = 1)
go


PRINT ' '
PRINT 'Creating view VPRT_ORGANIZATION...'
go

create view [dbo].[VPRT_ORGANIZATION] as
SELECT (select vloc.id 
        from VLOC_LOCATION vloc
      where  vloc.table_name in ('dbo.CPRT_ORGANIZATION')
        and  vloc.record_id = cpo.id 
        and  vloc.LOCATION_TYPE_ID = dbo.sfCONST('FACT_LOC_TYPE')) 
        as loc_fact_id
          ,(select vloc.id 
        from VLOC_LOCATION vloc
      where  vloc.table_name in ('dbo.CPRT_ORGANIZATION')
        and  vloc.record_id = cpo.id 
        and  vloc.LOCATION_TYPE_ID = dbo.sfCONST('JUR_LOC_TYPE')) 
        as loc_jur_id
      ,cpo.id as id
      ,cpo.name as name
      ,cpo.kpp as kpp
      ,cpo.inn as inn
     , cpo.SYS_STATUS
     , cpo.SYS_COMMENT
     , cpo.SYS_DATE_MODIFIED
     , cpo.SYS_DATE_CREATED
     , cpo.SYS_USER_MODIFIED
     , cpo.SYS_USER_CREATED
	FROM dbo.CPRT_ORGANIZATION cpo
    where cpo.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VPRT_PERSON...'
go

create view [dbo].[VPRT_PERSON] as
SELECT cpp.Id
     , cpp.NAME 
     , cpp.SECONDNAME
     , cpp.SURNAME 
     , cpp.SEX 
     , cpp.BIRTHDATE 
          ,(select vloc.id 
        from VLOC_LOCATION vloc
      where  vloc.table_name in ('dbo.CPRT_PERSON')
        and  vloc.record_id = cpp.id 
        and  vloc.LOCATION_TYPE_ID = dbo.sfCONST('FACT_LOC_TYPE')) 
        as loc_fact_id
     , cpp.SYS_STATUS
     , cpp.SYS_COMMENT
     , cpp.SYS_DATE_MODIFIED
     , cpp.SYS_DATE_CREATED
     , cpp.SYS_USER_MODIFIED
     , cpp.SYS_USER_CREATED
	FROM dbo.CPRT_PERSON cpp
    where cpp.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VUSR_PROFILE...'
go

create view [dbo].[VUSR_PROFILE] as
SELECT cp.Id
     , cp.USER_ID 
     , cp.CONFIGURATION 
     , cp.LANGUAGE 
     , cp.SYS_STATUS
     , cp.SYS_COMMENT
     , cp.SYS_DATE_MODIFIED
     , cp.SYS_DATE_CREATED
     , cp.SYS_USER_MODIFIED
     , cp.SYS_USER_CREATED
	FROM dbo.CUSR_PROFILE cp
    where cp.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VUSR_GROUP...'
go

create view [dbo].[VUSR_GROUP] as
SELECT cg.Id
     , cg.NAME
     , cg.REF_TYPE_ID
     , cg.SYS_STATUS
     , cg.SYS_COMMENT
     , cg.SYS_DATE_MODIFIED
     , cg.SYS_DATE_CREATED
     , cg.SYS_USER_MODIFIED
     , cg.SYS_USER_CREATED 
	FROM dbo.CUSR_GROUP cg
    where cg.sys_status = 1
go


PRINT ' '
PRINT 'Creating view VUSR_USER_GROUP...'
go

create view [dbo].[VUSR_USER_GROUP] as
SELECT USER_ID
     , GROUP_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CUSR_USER_GROUP cug
    where cug.sys_status = 1
go



PRINT ' '
PRINT 'Creating view VWFL_MESSAGE...'
go

create view [dbo].[VWFL_MESSAGE] as
SELECT id 
      ,MESSAGE_TYPE_ID
      ,OBJECT_ID
      ,PROCESSABLE
      ,PROCESSED
      ,DATA
      ,CREATED_TIME
      ,OBJECT_TYPE_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_MESSAGE_IMPORT 
    where sys_status = 1

go



PRINT ' '
PRINT 'Creating view VWFL_MESSAGE_TYPE...'
go

create view [dbo].[VWFL_MESSAGE_TYPE] as
SELECT Id
     , DESCRIPTION 
     , OBJECT_TYPE_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_MESSAGE_TYPE
    where sys_status = 1
go


PRINT ' '
PRINT 'Creating view VWFL_MESSAGE_TYPE_ROUTE_MASTER...'
go

create view [dbo].[VWFL_MESSAGE_TYPE_ROUTE_MASTER] as
SELECT ROUTE_MASTER_ID
      ,MESSAGE_TYPE_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_MESSAGE_TYPE_ROUTE_MASTER cmtrm
    where cmtrm.sys_status = 1
go

PRINT ' '
PRINT 'Creating view VWFL_ROUTE_DETAIL...'
go


create view [dbo].[VWFL_ROUTE_DETAIL] as
SELECT id 
      ,ROUTE_MASTER_ID
      ,SORT_FIELD
      ,PUBLIC_PROCESSING_TIME
      ,PRIVATE_PROCESSING_TIME
      ,INCIDENT_PROCESSING_TIME
      ,GROUP_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_ROUTE_DETAIL wrd
    where wrd.sys_status = 1
go


PRINT ' '
PRINT 'Creating view VWFL_ROUTE_FLOW_DETAIL...'
go

create view [dbo].[VWFL_ROUTE_FLOW_DETAIL] as
SELECT id 
      ,RUNTIME_STATUS
      ,ROUTE_FLOW_MASTER_ID
      ,MESSAGE_ID
      ,START_TIME
      ,END_TIME
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_ROUTE_FLOW_DETAIL 
    where sys_status = 1
go


PRINT ' '
PRINT 'Creating view VWFL_ROUTE_FLOW_MASTER...'
go

create view [dbo].[VWFL_ROUTE_FLOW_MASTER] as
SELECT id 
      ,RUNTIME_STATUS
      ,ROUTE_MASTER_ID
      ,ROUTE_DETAIL_ID
      ,START_TIME
      ,END_TIME
      ,GROUP_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_ROUTE_FLOW_MASTER wrfm
    where wrfm.sys_status = 1
      and wrfm.RUNTIME_STATUS <> dbo.sfCONST('RUN_CLOSED')
go

PRINT ' '
PRINT 'Creating view VWFL_ROUTE_MASTER...'
go


create view [dbo].[VWFL_ROUTE_MASTER] as
SELECT id 
      ,DESCRIPTION
      ,IS_DEFAULT
      ,FOR_VIP_CLIENT
      ,FOR_CLIENT_WEIGHT
      ,FOR_PROBLEM_CLIENT
      ,PROBLEM_TYPE_ID
      ,OBJECT_TYPE_ID
      ,BLOCK_ID
      ,STATE_ID
     , SYS_STATUS
     , SYS_COMMENT
     , SYS_DATE_MODIFIED
     , SYS_DATE_CREATED
     , SYS_USER_MODIFIED
     , SYS_USER_CREATED 
	FROM dbo.CWFL_ROUTE_MASTER wrm
    where wrm.sys_status = 1

go 

PRINT ' '
PRINT 'Creating view VWFL_ROUTE_FLOW...'
go


create view [dbo].[VWFL_ROUTE_FLOW] as
SELECT wrfm.id 
      ,wrfm.RUNTIME_STATUS
      ,wrfm.ROUTE_MASTER_ID
      ,wrfm.ROUTE_DETAIL_ID
      ,wrfm.START_TIME
      ,wrfm.END_TIME
      ,wrfm.GROUP_ID
      ,wrfd.MESSAGE_ID
      ,vm.OBJECT_ID
	FROM dbo.VWFL_ROUTE_FLOW_DETAIL wrfd
  JOIN dbo.VWFL_ROUTE_FLOW_MASTER wrfm
   on wrfd.ROUTE_FLOW_MASTER_ID = wrfm.id 
  JOIN dbo.VWFL_MESSAGE vm
   on wrfd.MESSAGE_ID = vm.id
go


PRINT ' '
PRINT 'Creating view VBCK_FAMILY...'
go


CREATE VIEW [dbo].[VBCK_FAMILY]
AS
  SELECT ID, 
         CODE, 
         DESCRIPTION,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED, 
         SYS_COMMENT
  FROM   dbo.BBCK_FAMILY
  WHERE  (SYS_STATUS = 1)
go



PRINT ' '
PRINT 'Creating view VBCK_MODIFICATION...'
go

create VIEW [dbo].[VBCK_MODIFICATION]
AS
  SELECT ID, 
         CODE, 
         DESCRIPTION,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED,
         SYS_COMMENT 
  FROM   dbo.BBCK_MODIFICATION
  WHERE  (SYS_STATUS = 1)
go


PRINT ' '
PRINT 'Creating view VBCK_TYPE...'
go


CREATE VIEW [dbo].[VBCK_TYPE]
AS
  SELECT ID, 
         CODE, 
         DESCRIPTION,
         SYS_DATE_MODIFIED, 
         SYS_DATE_CREATED, 
         SYS_USER_MODIFIED, 
         SYS_USER_CREATED, 
         SYS_COMMENT
  FROM   dbo.BBCK_TYPE
  WHERE  (SYS_STATUS = 1)
go


PRINT ' '
PRINT 'Creating view VCFG_SIM_CARD...'
go


CREATE VIEW [dbo].[VCFG_SIM_CARD]
AS
  SELECT sc.ID, 
         sc.DATA_NUMBER, 
         sc.SMS_CENTER_NUMBER, 
         sc.ISSA_PASSWORD, 
         sc.ORGANIZATION_ID as MOBILE_OPERATOR_ID,
         co.NAME AS MOBILE_OPERATOR_NAME,
         sc.VOICE_NUMBER,
         sc.SYS_STATUS, 
         sc.SYS_COMMENT, 
         sc.SYS_DATE_CREATED, 
         sc.SYS_DATE_MODIFIED, 
         sc.SYS_USER_MODIFIED, 
         sc.SYS_USER_CREATED 
  FROM   dbo.BCFG_SIM_CARD sc
    JOIN dbo.CPRT_ORGANIZATION co ON sc.ORGANIZATION_ID = co.ID
  WHERE  sc.SYS_STATUS = 1
    and  co.sys_status = 1
go



PRINT ' '
PRINT 'Creating view VOBJ_COLOUR...'
go


CREATE view [dbo].[VOBJ_COLOUR] as
SELECT cc.Id
     , cc.NAME 
     , cc.SYS_STATUS
     , cc.SYS_COMMENT
     , cc.SYS_DATE_MODIFIED
     , cc.SYS_DATE_CREATED
     , cc.SYS_USER_MODIFIED
     , cc.SYS_USER_CREATED
	FROM dbo.COBJ_COLOUR cc
    where cc.sys_status = 1
go


PRINT ' '
PRINT 'Creating view VUSR_USER...'
go



CREATE view [dbo].[VUSR_USER] as
SELECT cu.Id
     , cu.USERSID
     , cu.USERNAME
     , cu.PASSWORD 
     , cu.SYS_STATUS
     , cu.SYS_COMMENT
     , cu.SYS_DATE_MODIFIED
     , cu.SYS_DATE_CREATED
     , cu.SYS_USER_MODIFIED
     , cu.SYS_USER_CREATED 
	FROM dbo.CUSR_USER cu
    where cu.sys_status = 1
go


PRINT ' '
PRINT 'Creating view VOBJ_OBJECT_GROUP...'
go


CREATE view [dbo].[VOBJ_OBJECT_GROUP] as
SELECT cg.Object_Id
     , cg.Set_id 
     , cg.REF_TYPE_ID
     , cg.SYS_STATUS
     , cg.SYS_COMMENT
     , cg.SYS_DATE_MODIFIED
     , cg.SYS_DATE_CREATED
     , cg.SYS_USER_MODIFIED
     , cg.SYS_USER_CREATED
	FROM dbo.COBJ_OBJECT_GROUP cg
    where cg.sys_status = 1
go
