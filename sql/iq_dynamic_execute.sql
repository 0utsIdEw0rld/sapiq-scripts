/* Example proc that create a temp table with a dynamic value */
create or replace proc dbo.sp_dba_dynamic_execute (
    @num_value int
)
as
begin
    -- Dynamically create the temp table with the requested column value
    execute('select ' || @num_value || ' as column_1 into #temp')
    -- Return the result
    select column_1 from #temp
end;
exec dbo.sp_dba_dynamic_execute 123
