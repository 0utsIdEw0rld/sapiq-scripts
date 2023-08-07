SELECT version
	,platform
	,first_time
	,last_time
FROM SYS.SYSHISTORY
WHERE operation = 'UPGRADE'
