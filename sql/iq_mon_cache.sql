SELECT @@servername AS servername
	,substring(stat_desc, 1, 50) AS Parameter
	,substring(stat_value, 1, 20) AS Value
FROM sp_iqstatistics()
WHERE stat_name IN (
		'TempCacheHits'
		,'MainCacheHits'
		,'TempCacheFinds'
		,'MainCacheFinds'
		)
