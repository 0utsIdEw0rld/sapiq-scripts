SELECT @@servername AS servername
	,CURRENT TIMESTAMP AS TIMESTAMP
	,'Catalog Cache MB' AS stat_name
	,cast(cast(round(PROPERTY('CurrentCacheSize') / 1024, 0) AS INTEGER) AS VARCHAR(255)) AS stat_value

UNION

SELECT @@servername AS servername
	,CURRENT TIMESTAMP AS TIMESTAMP
	,name
	,value
FROM sp_iqstatus()
WHERE Name LIKE '%IQ large%'

UNION

SELECT @@servername AS servername
	,CURRENT TIMESTAMP AS TIMESTAMP
	,substring(stat_name, 1, 50) AS stat_name
	,substring(stat_value, 1, 20) AS stat_value
FROM sp_iqstatistics()
WHERE stat_name IN (
		'MainCachePagesInUsePercentage'
		,'TempCachePagesInUsePercentage'
		,'MainCacheCurrentSize'
		,'TempCacheCurrentSize'
		)
