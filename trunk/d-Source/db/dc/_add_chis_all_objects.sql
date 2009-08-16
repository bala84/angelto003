set nocount on
go

create procedure dbo.uspUtils_pivot_pk_columns
(@p_object_id   int
,@p_pivot_type  tinyint 
,@p_result_stmt1 varchar(max) out
,@p_result_stmt2 varchar(max) out
,@p_result_stmt3 varchar(max) out
,@p_result_stmt4 varchar(max) out
,@p_result_stmt5 varchar(max) out
,@p_result_stmt6 varchar(max) out
,@p_result_stmt7 varchar(max) out
,@p_result_stmt8 varchar(max) out
,@p_result_stmt9 varchar(max) out
)
as
begin
	
  declare @v_result_stmt1 varchar(max)
		 ,@v_result_stmt2 varchar(max)
		 ,@v_result_stmt3 varchar(max)
		 ,@v_result_stmt4 varchar(max)
		 ,@v_result_stmt5 varchar(max)
		 ,@v_result_stmt6 varchar(max)
		 ,@v_result_stmt7 varchar(max)
		 ,@v_result_stmt8 varchar(max)
		 ,@v_result_stmt9 varchar(max)
		 ,@i			 int
		 ,@v_name1		 varchar(2000)
		 ,@v_name2		 varchar(2000)
		 ,@v_name3		 varchar(2000)
		 ,@v_name4		 varchar(2000)
		 ,@v_name5		 varchar(2000)
		 ,@v_name6		 varchar(2000)
		 ,@v_name7		 varchar(2000)
		 ,@v_name8		 varchar(2000)
		 ,@v_name9		 varchar(2000)

  declare pk_cur  cursor for
		with name_forming (name1, name2, name3, name4, name5, name6, name7, name8, name9) as
			(
					select  TOP(100) PERCENT '@v_id_' + d.name + ' ' + case 
																	when e.name = 'varchar' or e.name = 'char'
																	then e.name + ' (' + convert(varchar(100), d.max_length) + ')'
																	when e.name = 'numeric' or e.name = 'decimal'
																	then e.name + ' (' + convert(varchar(10),e.precision) + ',' + convert(varchar(10),e.scale) + ')'
																	else e.name
																	end  as name1
				    ,'select @v_id_' + d.name + ' = isnull(@new_' + d.name + ' ,' + '@old_' + d.name + ')' as name2
					,'@p_row_id' + convert(varchar(2), c.index_column_id) + ' = @v_id_' + d.name as name3
					,'(@v_id_' + d.name + ' is not null)' as name4
					,'isnull(@new_' + d.name +' ,' + '@old_' + d.name + ')' as name5
					,'new_' + d.name + ' = ' + '@new_' + d.name as name6
					,'@new_' + d.name + ' is null' as name7
					,'old_' + d.name + ' = ' + '@old_' + d.name as name8
					,'@old_' + d.name + ' is null' as name9
					from  sys.key_constraints as a
					join sys.indexes as b on a.name = b.name
					join sys.index_columns as c on c.index_id = b.index_id and c.object_id = b.object_id
					join sys.columns as d on c.object_id = d.object_id and c.column_id = d.column_id
					join sys.types as e on d.user_type_id = e.user_type_id
					where a.type = 'PK'
					  and a.parent_object_id = @p_object_id
					order by c.index_column_id asc
		)
		select
			   case when @p_pivot_type = 4 then name1 else '' end
			  ,case when @p_pivot_type = 4 then name2 else '' end
			  ,case when @p_pivot_type = 4 then name3 else '' end
			  ,case when @p_pivot_type = 4 then name4 else '' end
			  ,case when @p_pivot_type = 4 then name5 else '' end
			  ,case when @p_pivot_type = 4 then name6 else '' end
			  ,case when @p_pivot_type = 4 then name7 else '' end
			  ,case when @p_pivot_type = 4 then name8 else '' end
			  ,case when @p_pivot_type = 4 then name9 else '' end
			  from name_forming

  set @v_result_stmt1 = ''
  set @v_result_stmt2 = ''
  set @v_result_stmt3 = ''
  set @v_result_stmt4 = ''
  set @v_result_stmt5 = ''
  set @v_result_stmt6 = ''
  set @v_result_stmt7 = ''
  set @v_result_stmt8 = ''
  set @v_result_stmt9 = ''

 open pk_cur

  fetch next from pk_cur
  into @v_name1, @v_name2, @v_name3, @v_name4, @v_name5, @v_name6, @v_name7, @v_name8, @v_name9

  set @i = 1

  while @@fetch_status = 0
	begin
	  if (@v_result_stmt1 != '')
		set @v_result_stmt1 = @v_result_stmt1 + ', ' + @v_name1 + char(13)
      else
	    set @v_result_stmt1 = '  ' + @v_name1 + char(13)

	  if (@v_result_stmt2 != '')
		set @v_result_stmt2 = @v_result_stmt2 + '' + @v_name2 + char(13)
      else
	    set @v_result_stmt2 = '  ' + @v_name2 + char(13)

	  if (@v_result_stmt3 != '')
		set @v_result_stmt3 = @v_result_stmt3 + ', ' + @v_name3 + char(13)
      else
	    set @v_result_stmt3 = '  ' + @v_name3 + char(13)

	  if (@v_result_stmt4 != '')
		set @v_result_stmt4 = @v_result_stmt4 + ' and ' + @v_name4 + char(13)
      else
	    set @v_result_stmt4 = ' and ' + @v_name4 + char(13)


	  if (@v_result_stmt5 != '')
		set @v_result_stmt5 = @v_result_stmt5 + ', ' + @v_name5 + char(13)
      else
	    set @v_result_stmt5 = '  ' + @v_name5 + char(13)

	  if (@v_result_stmt6 != '')
		set @v_result_stmt6 = @v_result_stmt6 + ' and ' + @v_name6 + char(13)
      else
	    set @v_result_stmt6 = '  ' + @v_name6 + char(13)

	  if (@v_result_stmt7 != '')
		set @v_result_stmt7 = @v_result_stmt7 + ' and ' + @v_name7 + char(13)
      else
	    set @v_result_stmt7 = '  ' + @v_name7 + char(13)

	  if (@v_result_stmt8 != '')
		set @v_result_stmt8 = @v_result_stmt8 + ' and ' + @v_name8 + char(13)
      else
	    set @v_result_stmt8 = '  ' + @v_name8 + char(13)

	  if (@v_result_stmt9 != '')
		set @v_result_stmt9 = @v_result_stmt9 + ' and ' + @v_name9 + char(13)
      else
	    set @v_result_stmt9 = '  ' + @v_name9 + char(13)

  fetch next from pk_cur
	  into @v_name1, @v_name2, @v_name3, @v_name4, @v_name5, @v_name6, @v_name7, @v_name8, @v_name9
		
	  set @i = @i + 1
		
	end

  CLOSE pk_cur
  DEALLOCATE pk_cur
  
	set @p_result_stmt1 = @v_result_stmt1
	set @p_result_stmt2 = @v_result_stmt2
	set @p_result_stmt3 = @v_result_stmt3
	set @p_result_stmt4 = @v_result_stmt4
	set @p_result_stmt5 = @v_result_stmt5
	set @p_result_stmt6 = @v_result_stmt6
	set @p_result_stmt7 = @v_result_stmt7
	set @p_result_stmt8 = @v_result_stmt8
	set @p_result_stmt9 = @v_result_stmt9

END
go

create procedure dbo.uspUtils_pivot_table_columns 
(   @p_object_id   int 
  , @p_pivot_type  tinyint 
  , @p_result_stmt  varchar(max) out
  , @p_result_stmt1 varchar(max) out
  , @p_result_stmt2 varchar(max) out
  , @p_result_stmt3 varchar(max) out
  , @p_result_stmt4 varchar(max) out
  , @p_result_stmt5 varchar(max) out
  , @p_result_stmt6 varchar(max) out
  , @p_result_stmt7 varchar(max) out
  , @p_result_stmt8 varchar(max) out
  , @p_result_stmt9 varchar(max) out
  , @p_result_stmt10 varchar(max) out
  , @p_result_stmt11 varchar(max) out
  , @p_result_stmt12 varchar(max) out
  , @p_result_stmt13 varchar(max) out
  , @p_result_stmt14 varchar(max) out
)
as
BEGIN
  declare @v_result_stmt varchar(max)
		 ,@i			 int
		 ,@v_name		 varchar(2000)
		 ,@v_name1		 varchar(2000)
		 ,@v_name2		 varchar(2000)
		 ,@v_name3		 varchar(2000)
		 ,@v_name4		 varchar(2000)
		 ,@v_name5		 varchar(2000)
		 ,@v_name6		 varchar(2000)
		 ,@v_name7		 varchar(2000)
		 ,@v_name8		 varchar(2000)
		 ,@v_name9		 varchar(2000)
		 ,@v_name10		 varchar(2000)
		 ,@v_name11		 varchar(2000)
		 ,@v_name12		 varchar(2000)
		 ,@v_name13		 varchar(2000)
		 ,@v_name14		 varchar(2000)
		 ,@v_result_stmt1 varchar(max)
		 ,@v_result_stmt2 varchar(max)
		 ,@v_result_stmt3 varchar(max)
		 ,@v_result_stmt4 varchar(max)
		 ,@v_result_stmt5 varchar(max)
		 ,@v_result_stmt6 varchar(max)
		 ,@v_result_stmt7 varchar(max)
		 ,@v_result_stmt8 varchar(max)
		 ,@v_result_stmt9 varchar(max)
		 ,@v_result_stmt10 varchar(max)
		 ,@v_result_stmt11 varchar(max)
		 ,@v_result_stmt12 varchar(max)
		 ,@v_result_stmt13 varchar(max)
		 ,@v_result_stmt14 varchar(max)



  declare col_cur cursor for
		 with name_forming (name1, name2, name3, name4, name5, name6, name7, name8, name9, name10, name11, name12, name13, name14)
		  as
			(select
				 a.name as name1
				,'@new_' + a.name + ' = new_' + a.name as name2
				,'@old_' + a.name + ' = old_' + a.name as name3
			    ,'<' + a.name + '>'' + ' + 'isnull(convert(varchar(4000), @new_' + a.name + '),'''')' + ' + ''</' + a.name + '>' as name4
				,'<' + a.name + '>'' + ' + 'isnull(convert(varchar(4000), @old_' + a.name + '),'''')' + ' + ''</' + + a.name + '>' as name5
				,'@new_' + a.name + ' ' + 			
																	case 
																	when b.name = 'varchar' or b.name = 'char'
																	then b.name + '(' + convert(varchar(100), a.max_length) + ')'
																	when b.name = 'numeric' or b.name = 'decimal'
																	then b.name + '(' + convert(varchar(10),a.precision) + ',' + convert(varchar(10),a.scale) + ')'
																	else b.name
																	end  as name6
			   ,'@old_' + a.name + ' ' + 			
																	case 
																	when b.name = 'varchar' or b.name = 'char'
																	then b.name + '(' + convert(varchar(100), a.max_length) + ')'
																	when b.name = 'numeric' or b.name = 'decimal'
																	then b.name + '(' + convert(varchar(10),a.precision) + ',' + convert(varchar(10),a.scale) + ')'
																	else b.name
																	end  as name7
			   ,'<' + a.name + '>' + convert(varchar(4000), c.value) + '</' + a.name + '>'  as name8
			   ,case when b.name = 'xml' 
					 then 'convert(varchar(max), @old_' + a.name + ') = ' + 'convert(varchar(max), @new_' + a.name + ')'
					 else 
						 case when   upper(a.name) like upper('%sys_user%')
								  or upper(a.name) like upper('%sys_date%')
								  or upper(a.name) like upper('%sys_comment%')
							  -- —равним одинаковые элементы дл€ системных записей
							  then '@old_' + a.name + ' = ' + '@old_' + a.name 	
							  -- Ќормальной сравнение
							  else '@old_' + a.name + ' = ' + '@new_' + a.name 
						 end
			     end as name9
				,'new_' + a.name as name10
				,'old_' + a.name as name11
				,'null' as name12
				,'new_' + a.name + ' ' + 			
																	case 
																	when b.name = 'varchar' or b.name = 'char'
																	then b.name + '(' + convert(varchar(100), a.max_length) + ')'
																	when b.name = 'numeric' or b.name = 'decimal'
																	then b.name + '(' + convert(varchar(10),a.precision) + ',' + convert(varchar(10),a.scale) + ')'
																	else b.name
																	end  as name13
			   ,'old_' + a.name + ' ' + 			
																	case 
																	when b.name = 'varchar' or b.name = 'char'
																	then b.name + '(' + convert(varchar(100), a.max_length) + ')'
																	when b.name = 'numeric' or b.name = 'decimal'
																	then b.name + '(' + convert(varchar(10),a.precision) + ',' + convert(varchar(10),a.scale) + ')'
																	else b.name
																	end  as name14
			 from sys.columns as a
			 join sys.types as b on a.user_type_id = b.user_type_id
			 join sys.extended_properties as c on c.major_id = a.object_id and c.minor_id = a.column_id
			where a.object_id = @p_object_id
			  and c.name = 'MS_Description'
			--  and b.name != 'xml'
							)
			select 
			  case when @p_pivot_type = 1 then name1
				   when @p_pivot_type = 2 then name2
				   when @p_pivot_type = 3 then name3
				   when @p_pivot_type = 4 then name4
				   when @p_pivot_type = 5 then name5
				   when @p_pivot_type = 6 then name6
				   when @p_pivot_type = 7 then name7
				   when @p_pivot_type = 8 then name8
				   when @p_pivot_type = 9 then name9
				   when @p_pivot_type = 10 then name10
				   when @p_pivot_type = 11 then name11
				   when @p_pivot_type = 12 then name12
				   when @p_pivot_type = 13 then name13
				   when @p_pivot_type = 14 then name14
			  end as "name"
			  ,case when @p_pivot_type = 10 then name1 else '' end
			  ,case when @p_pivot_type = 10 then name2 else '' end
			  ,case when @p_pivot_type = 10 then name3 else '' end
			  ,case when @p_pivot_type = 10 then name4 else '' end
			  ,case when @p_pivot_type = 10 then name5 else '' end
			  ,case when @p_pivot_type = 10 then name6 else '' end
			  ,case when @p_pivot_type = 10 then name7 else '' end
			  ,case when @p_pivot_type = 10 then name8 else '' end
			  ,case when @p_pivot_type = 10 then name9 else '' end
			  ,case when @p_pivot_type = 10 then name10 else '' end
			  ,case when @p_pivot_type = 10 then name11 else '' end
			  ,case when @p_pivot_type = 10 then name12 else '' end
			  ,case when @p_pivot_type = 10 then name13 else '' end
			  ,case when @p_pivot_type = 10 then name14 else '' end
			  from name_forming
			 
    set @v_result_stmt = ''
	set @v_result_stmt1 = ''
	set @v_result_stmt2 = ''
	set @v_result_stmt3 = ''
	set @v_result_stmt4 = ''
	set @v_result_stmt5 = ''
	set @v_result_stmt6 = ''
	set @v_result_stmt7 = ''
	set @v_result_stmt8 = ''
	set @v_result_stmt9 = ''
	set @v_result_stmt10 = ''
	set @v_result_stmt11 = ''
	set @v_result_stmt12 = ''
	set @v_result_stmt13 = ''
	set @v_result_stmt14 = ''

		
  open col_cur

  fetch next from col_cur
  into @v_name, @v_name1, @v_name2, @v_name3, @v_name4, @v_name5, @v_name6, @v_name7, @v_name8, @v_name9, @v_name10, @v_name11, @v_name12, @v_name13, @v_name14

  set @i = 1

  while @@fetch_status = 0
	begin
      if (@v_result_stmt != '')
		set @v_result_stmt = @v_result_stmt + case when @p_pivot_type not in (4,5,8,9) then ', '
												   when @p_pivot_type = 9 then 'and ' 
												   else ' ' 
											  end + @v_name + char(13)
      else
	    set @v_result_stmt = '  ' + @v_name + char(13)

      if (@v_result_stmt1 != '')
		set @v_result_stmt1 = @v_result_stmt1 + ', ' + @v_name1 + char(13)
      else
	    set @v_result_stmt1 = '  ' + @v_name1 + char(13)

      if (@v_result_stmt2 != '')
		set @v_result_stmt2 = @v_result_stmt2 + ', ' + @v_name2 + char(13)
      else
	    set @v_result_stmt2 = '  ' + @v_name2 + char(13)

      if (@v_result_stmt3 != '')
		set @v_result_stmt3 = @v_result_stmt3 + ', ' + @v_name3 + char(13)
      else
	    set @v_result_stmt3 = '  ' + @v_name3 + char(13)

      if (@v_result_stmt4 != '')
		set @v_result_stmt4 = @v_result_stmt4 + ' ' + @v_name4 + char(13)
      else
	    set @v_result_stmt4 = '  ' + @v_name4 + char(13)

      if (@v_result_stmt5 != '')
		set @v_result_stmt5 = @v_result_stmt5 + ' ' + @v_name5 + char(13)
      else
	    set @v_result_stmt5 = '  ' + @v_name5 + char(13)

      if (@v_result_stmt6 != '')
		set @v_result_stmt6 = @v_result_stmt6 + ', ' + @v_name6 + char(13)
      else
	    set @v_result_stmt6 = '  ' + @v_name6 + char(13)

      if (@v_result_stmt7 != '')
		set @v_result_stmt7 = @v_result_stmt7 + ', ' + @v_name7 + char(13)
      else
	    set @v_result_stmt7 = '  ' + @v_name7 + char(13)

      if (@v_result_stmt8 != '')
		set @v_result_stmt8 = @v_result_stmt8 + ' ' + @v_name8 + char(13)
      else
	    set @v_result_stmt8 = '  ' + @v_name8 + char(13)

	  if (@v_result_stmt9 != '')
		set @v_result_stmt9 = @v_result_stmt9 + 'and ' + @v_name9 + char(13)
      else
	    set @v_result_stmt9 = '  ' + @v_name9 + char(13)


      if (@v_result_stmt10 != '')
		set @v_result_stmt10 = @v_result_stmt10 + ', ' + @v_name10 + char(13)
      else
	    set @v_result_stmt10 = '  ' + @v_name10 + char(13)


      if (@v_result_stmt11 != '')
		set @v_result_stmt11 = @v_result_stmt11 + ', ' + @v_name11 + char(13)
      else
	    set @v_result_stmt11 = '  ' + @v_name11 + char(13)

      if (@v_result_stmt12 != '')
		set @v_result_stmt12 = @v_result_stmt12 + ', ' + @v_name12 + char(13)
      else
	    set @v_result_stmt12 = '  ' + @v_name12 + char(13)

      if (@v_result_stmt13 != '')
		set @v_result_stmt13 = @v_result_stmt13 + ', ' + @v_name13 + char(13)
      else
	    set @v_result_stmt13 = '  ' + @v_name13 + char(13)

      if (@v_result_stmt14 != '')
		set @v_result_stmt14 = @v_result_stmt14 + ', ' + @v_name14 + char(13)
      else
	    set @v_result_stmt14 = '  ' + @v_name14 + char(13)

 
	  fetch next from col_cur
	  into @v_name, @v_name1, @v_name2, @v_name3, @v_name4, @v_name5, @v_name6, @v_name7, @v_name8, @v_name9, @v_name10, @v_name11, @v_name12, @v_name13, @v_name14
		
	  set @i = @i + 1
		
	end

  CLOSE col_cur
  DEALLOCATE col_cur
  
	set @p_result_stmt = @v_result_stmt
	set @p_result_stmt1 = @v_result_stmt1
	set @p_result_stmt2 = @v_result_stmt2
	set @p_result_stmt3 = @v_result_stmt3
	set @p_result_stmt4 = @v_result_stmt4
	set @p_result_stmt5 = @v_result_stmt5
	set @p_result_stmt6 = @v_result_stmt6
	set @p_result_stmt7 = @v_result_stmt7
	set @p_result_stmt8 = @v_result_stmt8
	set @p_result_stmt9 = @v_result_stmt9
	set @p_result_stmt10 = @v_result_stmt10
	set @p_result_stmt11 = @v_result_stmt11
	set @p_result_stmt12 = @v_result_stmt12
	set @p_result_stmt13 = @v_result_stmt13
	set @p_result_stmt14 = @v_result_stmt14

END
GO


declare
	 @p_name		 varchar(2000)
	,@i				 int
	,@p_trigger_body varchar(max)
	,@p_object_id	 int
	,@v_select_stmt varchar(max)
	,@v_new_declare_stmt varchar(max)
	,@v_old_declare_stmt varchar(max)
	,@v_new_select_stmt varchar(max)
	,@v_old_select_stmt varchar(max)
	,@v_new_select_wp_stmt varchar(max)
	,@v_old_select_wp_stmt varchar(max)
	,@v_new_select_wi_stmt varchar(max)
	,@v_old_select_wi_stmt varchar(max)
	,@v_new_xml_stmt varchar(max)
	,@v_old_xml_stmt varchar(max)
	,@v_comments_stmt varchar(max)
	,@v_where_stmt varchar(max)
	,@v_id_declare_stmt varchar(max)
	,@v_id_select_stmt varchar(max)
	,@v_id_exec_stmt varchar(max)
	,@v_id_not_null_stmt varchar(max)
	,@v_null_stmt varchar(max)
	,@v_order_id_stmt varchar(max)
	,@v_delete_by_new_id_stmt varchar(max)
	,@v_delete_by_old_id_stmt varchar(max)
	,@v_delete_by_new_null_id_stmt varchar(max)
	,@v_delete_by_old_null_id_stmt varchar(max)

declare
tbl_cur cursor for
	select b.name, b.object_id
	from  sys.tables as b
	where upper(b.name) not like 'CSYS%'
	 and upper(b.name) not like 'SYS%'
	 and upper(b.name) not like 'CHIS%'
	 and upper(b.name) not like 'CREP%'
	 --and upper(b.name) = 'CWRH_ORDER_MASTER_REPAIR_TYPE_MASTER'
	union all
	select b.name, b.object_id
	from  sys.tables as b
	where upper(b.name) = 'CSYS_CONST'


begin
open tbl_cur

fetch next from tbl_cur
into @p_name, @p_object_id

set @i = 1

while @@fetch_status = 0
begin
   exec dbo.uspUtils_pivot_table_columns 
				@p_object_id = @p_object_id
			  , @p_pivot_type =  10
			  , @p_result_stmt = null 
			  , @p_result_stmt1 = @v_select_stmt out
			  , @p_result_stmt2 = @v_new_select_stmt out
			  , @p_result_stmt3 = @v_old_select_stmt out
			  , @p_result_stmt4 = @v_new_xml_stmt out
			  , @p_result_stmt5 = @v_old_xml_stmt out
			  , @p_result_stmt6 = @v_new_declare_stmt out
			  , @p_result_stmt7 = @v_old_declare_stmt out
			  , @p_result_stmt8 = @v_comments_stmt out
			  , @p_result_stmt9 = @v_where_stmt out
			  , @p_result_stmt10 = @v_new_select_wi_stmt out
			  , @p_result_stmt11 = @v_old_select_wi_stmt out
			  , @p_result_stmt12 = @v_null_stmt out
			  , @p_result_stmt13 = @v_new_select_wp_stmt out
			  , @p_result_stmt14 = @v_old_select_wp_stmt out

   exec dbo.uspUtils_pivot_pk_columns 
				@p_object_id = @p_object_id
			  , @p_pivot_type =  4 
			  , @p_result_stmt1 = @v_id_declare_stmt out
			  , @p_result_stmt2 = @v_id_select_stmt out
			  , @p_result_stmt3 = @v_id_exec_stmt out
			  , @p_result_stmt4 = @v_id_not_null_stmt out
			  , @p_result_stmt5 = @v_order_id_stmt out
			  , @p_result_stmt6 = @v_delete_by_new_id_stmt out
			  , @p_result_stmt7 = @v_delete_by_new_null_id_stmt out
			  , @p_result_stmt8 = @v_delete_by_old_id_stmt out
			  , @p_result_stmt9 = @v_delete_by_old_null_id_stmt out

   set @p_trigger_body =   'CREATE TRIGGER dbo.TIUD_' + @p_name + '_HIS_ALL' + CHAR(13)
						 + 'ON dbo.' + @p_name + CHAR(13)
						 + 'AFTER INSERT,DELETE,UPDATE' + CHAR(13)
						 + 'AS' + CHAR(13) 
						 + 'BEGIN' + CHAR(13)
						 + '	SET NOCOUNT ON' + CHAR(13)
						 + '	declare'		+ CHAR(13)
						 + '		 @v_Error int' + CHAR(13)
						 + '		,' + @v_new_declare_stmt
						 + '		,' + @v_old_declare_stmt
						 + CHAR(13)
						 + '	declare'		+ CHAR(13)
						 + '		 @t table(' + CHAR(13)
						 + '		 ' + @v_new_select_wp_stmt
						 + '		,' + @v_old_select_wp_stmt + ')'
						 + CHAR(13)
						 + '	declare' + CHAR(13) 
						 + '		 @v_data				xml' + CHAR(13)
						 + '	    ,@v_tablename_id		numeric(38,0)' + CHAR(13)
						 + '	    ,@v_action		    tinyint' + CHAR(13)
						 + '	    ,@v_message_level_id numeric(38,0)' + CHAR(13)
						 + '	    ,@v_subsystem_id		numeric(38,0)' + CHAR(13)		
						 + '	    ,@v_system_date_created	datetime' + CHAR(13) 
						 + '	    ,@v_system_user_id		numeric(38,0)' + CHAR(13)
						 + '    declare' + CHAR(13)
						 + '		' + @v_id_declare_stmt
						 + CHAR(13)
						 + 'insert into @t('		+ CHAR(13)
						 + '		 ' + @v_new_select_wi_stmt
						 + '		,' + @v_old_select_wi_stmt + ')' + CHAR(13)
						 + 'select ' + CHAR(13)
						 + '		 ' + @v_select_stmt
						 + '		,' + @v_null_stmt + CHAR(13)
						 + 'from inserted' + CHAR(13)
						 + 'union all' + CHAR(13)
						 + 'select ' + CHAR(13)
						 + '		 ' + @v_null_stmt
						 + '		,' + @v_select_stmt + CHAR(13)
						 + 'from deleted' + CHAR(13)
						 + CHAR(13)
						 + 'while (exists' + CHAR(13)						 + '(select top(1) 1 ' + CHAR(13)						 + 'from @t' + CHAR(13)						 + 'order by ' + @v_order_id_stmt + '))' + CHAR(13)
						 + 'begin' + CHAR(13)
						 + CHAR(13)
						 + 'select TOP(1)' + CHAR(13)						 + '	' +   @v_new_select_stmt 						 + '   ,' +   @v_old_select_stmt 						 + 'from @t' + char(13)						 + 'order by ' + @v_order_id_stmt + CHAR(13)
						 + CHAR(13)
						 + '	set @v_system_date_created  = getdate()' + CHAR(13)
						 + '	set @v_tablename_id = dbo.usfConst(''dbo.' + @p_name + ''')' + CHAR(13)
						 + '	set @v_message_level_id = dbo.usfValue(''LOG_MESSAGE_LEVEL'')' + CHAR(13)
						 + '	set @v_subsystem_id = dbo.usfConst(''DEMAND_SUBSYSTEM'')' + CHAR(13)
						 + CHAR(13)
						 + '	if ((@old_sys_status is null) and (@new_sys_status is not null))' + CHAR(13)
						 + '		set @v_action = dbo.usfConst(''ACTION_INSERT'')' + CHAR(13)
						 + '	else' + CHAR(13)
						 + '		 if ((@old_sys_status is not null) and (@new_sys_status is not null))' + CHAR(13)
						 + '			set @v_action = dbo.usfConst(''ACTION_UPDATE'')' + CHAR(13)
						 + '		 else' + CHAR(13)
						 + '			set @v_action = dbo.usfConst(''ACTION_DELETE'')' + CHAR(13)
						 + '		--end' + CHAR(13)
						 + '		--¬ыбираем из двух id по скольку id не обновл€етс€. ¬ыбираем сначала по новому или старому - в общем без разницы' + CHAR(13)
						 + '		' + @v_id_select_stmt
						 + '		--¬ыбираем пользовател€ по новому сначала - потому что пользователь нужен самый последний' + CHAR(13)
						 + '		select @v_system_user_id = id from dbo.CPRT_USER where username = isnull(@new_sys_user_modified, @old_sys_user_modified)' + CHAR(13)
						 + '		if (@v_system_user_id is null)' + CHAR(13)
						 + '		  select  @v_system_user_id = id from dbo.CPRT_GROUP where name = isnull(@new_sys_user_modified, @old_sys_user_modified)' + CHAR(13)						
						 + '		select @v_data = cast(''<root> <new_value> ' + @v_new_xml_stmt + '</new_value>' + CHAR(13) 
						 + '									   <old_value> ' + @v_old_xml_stmt +  '</old_value>' + CHAR(13)
						 + '									   <comments> '  + @v_comments_stmt + '</comments>' + CHAR(13)
						 + '							   </root>'' as xml)' + CHAR(13)
						 + '		where  not exists' + CHAR(13)
						 + '		(select 1' + CHAR(13)
						 + '			where' + CHAR(13)
						 + '			  ' + @v_where_stmt +')' + CHAR(13)
						 + CHAR(13)
						 + '	if ((@v_data is not null)' + @v_id_not_null_stmt + ')' + CHAR(13)
						 + '	exec @v_Error = ' + CHAR(13)
						 + '				dbo.uspCHIS_ALL_SaveById' + CHAR(13)
						 + '									' + @v_id_exec_stmt
						 + '									,@p_id = null'
						 + '									,@p_tablename_id		= @v_tablename_id' + CHAR(13)
						 + '									,@p_action				= @v_action' + CHAR(13)
						 + '									,@p_data				= @v_data' + CHAR(13)
						 + '									,@p_party_id			= @v_system_user_id' + CHAR(13)
						 + '									,@p_message_level_id	= @v_message_level_id' + CHAR(13)
						 + '									,@p_subsystem_id		= @v_subsystem_id' + CHAR(13)
						 + '									,@p_date_created		= @v_system_date_created' + CHAR(13)
						 + '									,@p_sys_comment		= ''-''' + CHAR(13)
						 + '									,@p_sys_user			= ''-''' + CHAR(13)
						 + CHAR(13)
						 + 'delete from @t' + CHAR(13)						 + 'where ((' + @v_delete_by_new_id_stmt + ')' + CHAR(13)						 + 'or     (' + @v_delete_by_new_null_id_stmt + '))' + CHAR(13)						 + 'or ((' + @v_delete_by_old_id_stmt + ')'  + CHAR(13)						 + 'or     (' + @v_delete_by_new_null_id_stmt + '))' + CHAR(13)						 + CHAR(13)
						 + 'end' + CHAR(13)
						 + CHAR(13)
						 + 'END' + CHAR(13)


   print 'Adding trigger dbo.TIUD_' + @p_name + '_HIS_ALL ...'
  -- select (@p_trigger_body)
   exec  (@p_trigger_body)
   print '...trigger dbo.TIUD_' + @p_name + '_HIS_ALL added.'
   
  

fetch next from tbl_cur
into @p_name, @p_object_id
set @i = @i + 1
select @i - 1
end

CLOSE tbl_cur
DEALLOCATE tbl_cur
end
go


drop procedure dbo.uspUtils_pivot_table_columns 
go

drop procedure dbo.uspUtils_pivot_pk_columns
go
