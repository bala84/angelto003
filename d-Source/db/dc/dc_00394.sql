:r ./../_define.sql

:setvar dc_number 00394
:setvar dc_description "driver plan mech id added"

/*******************************************************************************
                                                                                 
 Syntax: logon to sqlcmd as db schema owner
 Requirements: 

********************************************************************************
VER    DATE       AUTHOR       TEXT   
********************************************************************************
1.0   21.11.2008 VLavrentiev  driver plan mech id added
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


alter table dbo.CDRV_DRIVER_PLAN_DETAIL
add mech_employee_id numeric(38,0)
go

create index ifk_cdrv_driver_plan_detail_mech_employee_id on dbo.CDRV_DRIVER_PLAN_DETAIL(mech_employee_id)
on $(fg_idx_name)
go

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ид механика' ,@level0type=N'SCHEMA', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'CDRV_DRIVER_PLAN_DETAIL', @level2type=N'COLUMN', @level2name=N'mech_employee_id'

GO

ALTER TABLE [dbo].[CDRV_DRIVER_PLAN_DETAIL]  WITH CHECK ADD  CONSTRAINT [CDRV_DRIVER_PLAN_DETAIL_MECH_EMP_ID_FK] FOREIGN KEY([mech_employee_id])
REFERENCES [dbo].[CPRT_EMPLOYEE] ([id])
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

--:r _add_chis_all_objects.sql
