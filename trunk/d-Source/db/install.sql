/* 
 =====================================================================================
 | 
 | Syntax: This script must be run by a DBA user 
 | 
 | -----------------------------------------------------------------------------------
 |  VER    DATE       AUTHOR       TEXT   
 | -----------------------------------------------------------------------------------
 |  1.0 09.02.2007    VLavrentiev    Установочный скрипт для создания БД ANGEL_TO_001
 ================================================================================== */ 



:r $(file_script_dir)_define.sql

print ' '
print 'Creating db...'
print ' '
go

:r $(file_script_dir)create_database.sql

print ' '
print 'Creating Users...'
print ' '
go
 
:r $(file_script_dir)create_users.sql

print ' '
print 'Creating Tables...'
print ' '
go

:r $(file_script_dir)create_tables.sql


print ' '
print 'Creating SYS_DC...'
print ' '
go


:r $(file_script_dir)sys_dc.sql

--print ' '
--print 'Creating FULL-TEXT...'
--print ' '
--go
--
--:r $(file_script_dir)create_FT.sql
--
--print ' '
--print 'Creating Functions...'
--print ' '
--go
--
--:r $(file_script_dir)create_sfs.sql
--
--print ' '
--print 'Creating Views...'
--print ' '
--go
--
--:r $(file_script_dir)create_views.sql
--
--
--print ' '
--print 'Creating Stored Procedures...'
--print ' '
--go
--
--:r $(file_script_dir)create_sps.sql
--
--
--print ' '
--print 'Insert data ...'
--print ' '
--go
--
--:r $(file_script_dir)insert_data.sql
--
--
exit