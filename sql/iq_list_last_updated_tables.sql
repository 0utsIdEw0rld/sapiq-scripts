SELECT t.table_name
	,it.create_time
	,it.update_time
FROM sysiqtable it
	,systable t
WHERE it.table_id = t.table_id
	AND (it.table_id > 100)
	AND creator = suser_id('dbo')
	AND table_type = 'BASE'
ORDER BY it.update_time DESC -- t.table_name -- it.update_time desc; 
