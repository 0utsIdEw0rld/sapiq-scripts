SELECT up.user_name + '.' + tab.table_name AS table_name
	,idx.index_type
	,count(*) AS number_of_indexes
FROM SYS.SYSTABLE AS tab
	,SYS.SYSINDEX AS idx
	,SYS.SYSUSERPERM AS up
	,SYS.SYSIXCOL AS ixc
	,SYS.SYSCOLUMN AS c
WHERE up.user_id = idx.creator
	AND up.user_name = 'dbo'
	AND tab.table_id = idx.table_id
	--    AND      idx.index_type  in ( 'HG')
	AND c.table_id = ixc.table_id
	AND c.column_id = ixc.column_id
	AND ixc.index_id = idx.index_id
	AND ixc.table_id = idx.table_id
GROUP BY up.user_name
	,tab.table_name
	,idx.index_type
--having count(*)>10
ORDER BY up.user_name
	,tab.table_name
