SELECT table_name
	,index_name
	,cardinality
FROM systable KEY
JOIN sysindex KEY
JOIN sysixcol KEY
JOIN syscolumn KEY
JOIN sysiqcolumn
WHERE index_type = 'LF'
	AND server_type = 'IQ'
	AND cardinality > 2000
ORDER BY cardinality DESC