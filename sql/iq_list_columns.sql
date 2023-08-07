SELECT @@servername AS servername
	,t.table_name
	,c.column_name
	,d.domain_name
	,c.width
	,c.scale
FROM SYS.SYSTAB AS t
JOIN SYS.SYSCOLUMN AS c ON t.table_id = c.table_id
JOIN SYS.SYSDOMAIN AS d ON d.domain_id = c.domain_id
WHERE t.creator <> 0
	AND NOT EXISTS (
		SELECT *
		FROM sys.systab AS tv
		WHERE tv.creator IN (
				2
				,22
				)
			AND tv.table_id = t.table_id
		)
ORDER BY 1 ASC
	,2 ASC
