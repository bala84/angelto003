
declare
	 @p_name varchar(2000)
	,@i	int

declare
trg_cur cursor for
	select a.name
	from  sys.triggers as a
	 join sys.tables as b on a.parent_id = b.object_id
	where upper(b.name) not like 'CSYS%'
	 and upper(b.name) not like 'SYS%'
	 and upper(b.name) not like 'CHIS%'
	 and upper(b.name) not like 'CREP%'
	 and upper(a.name) like '%_HIS_ALL'
	union all
	select a.name
	from  sys.triggers as a
	 join sys.tables as b on a.parent_id = b.object_id
	where upper(b.name) = 'CSYS_CONST'

begin
open trg_cur

fetch next from trg_cur
into @p_name

set @i = 1

while @@fetch_status = 0
begin

  print 'Dropping trigger "' + @p_name + '"...'
  execute ('drop trigger dbo.' + @p_name)
  print '...trigger "' + @p_name + '" dropped.'

fetch next from trg_cur
into @p_name
set @i = @i + 1
end

CLOSE trg_cur
DEALLOCATE trg_cur
end
go
