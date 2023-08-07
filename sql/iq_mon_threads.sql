SELECT @@servername AS servername
	,substring(stat_desc, 1, 50) AS stat_desc
	,substring(stat_value, 1, 20) AS stat_value
	,stat_name
FROM sp_iqstatistics()
WHERE stat_name IN (
		'ThreadsFree'
		,'ThreadsInUse'
		,'ConnectionsActive'
		,'OperationsActiveLoadTableStatements'
		)
