SELECT @@servername AS servername
	,CURRENT TIMESTAMP AS TIMESTAMP
	,'MainIQ_IO_Statistics' AS stat_name
	,Value AS MainIQ_IO_Statistics
FROM sp_iqstatus()
WHERE Name = ' Main IQ I/O:'

UNION

SELECT @@servername AS servername
	,CURRENT TIMESTAMP AS TIMESTAMP
	,'TempIQ_IO_Statistics' AS stat_name
	,Value AS TempIQ_IO_Statistics
FROM sp_iqstatus()
WHERE Name = ' Temporary IQ I/O:'
