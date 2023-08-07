SELECT getdate() AS snapshot_time
	,iqstatus_temp.tempUsagePct
	,iqstatus_main.mainUsagePct
	,iqstatus_temp.GlobalTempUsageGB
	,iqstatus_main.GlobalMainUsageGB
	,it.MainTableKbCr / 1024.0 AS MainTableMBCr
	,it.MainTableKbDr / 1024.0 AS MainTableMBDr
	,it.TempTableKbCr / 1024.0 AS TempTableMBCr
	,it.TempTableKbDr / 1024.0 AS TempTableMBDr
	,ico.TempWorkspaceKB / 1024.0 AS TempWorkspaceMB
	,ic.IQThreads
	,cast(CmdLine AS VARCHAR(32767)) AS cmdline
	,ic.UserId
	,STATE
	,ic.ConnHandle
	,ic.iqconnid
	,sco.nodeAddr
	,TxnCreateTime
	,sco.LastReqTime
	,sco.ReqType
	,cast(property('BytesReceived') AS VARCHAR(32767)) AS BytesReceived
	,cast(property('BytesSent') AS VARCHAR(32767)) AS BytesSent
	,cast(property('PacketsReceived') AS VARCHAR(32767)) AS PacketsReceived
	,cast(property('PacketsSent') AS VARCHAR(32767)) AS PacketsSent
	,cast(property('CacheHitsEng') AS VARCHAR(32767)) AS CacheHitsEng
	,cast(property('CurrentCacheSize') AS VARCHAR(32767)) AS CurrentCacheSizeKB
FROM sp_iqversionuse() AS ivu
	,sp_iqcontext() AS ic
	,sp_iqtransaction() AS it
	,sp_iqconnection() AS ico
	,sa_conn_info() AS sco
	,(
		SELECT cast(SUBSTRING(value, 1, CHARINDEX(' ', value) - 1) AS DOUBLE) * block_size / 1024.0 / 1024 / 1024.0 AS GlobalTempUsageGB
			,replace(SUBSTRING(value, CHARINDEX(',', value) + 2, 2), '%', '') AS tempUsagePct
		FROM sp_iqstatus()
			,sysiqinfo
		WHERE Name = ' Temporary IQ Blocks Used:'
		) AS iqstatus_temp
	,(
		SELECT cast(SUBSTRING(value, 1, CHARINDEX(' ', value) - 1) AS DOUBLE) * block_size / 1024.0 / 1024.0 / 1024.0 AS GlobalMainUsageGB
			,replace(SUBSTRING(value, CHARINDEX(',', value) + 2, 2), '%', '') AS mainUsagePct
		FROM sp_iqstatus()
			,sysiqinfo
		WHERE Name = ' Main IQ Blocks Used:'
		) AS iqstatus_main
WHERE ivu.iqconnid = * ic.iqconnid
	AND it.iqconnid = * ic.iqconnid
	AND ico.ConnHandle = ic.ConnHandle
	AND sco.number = ico.ConnHandle
	AND CmdLine NOT LIKE 'SELECT   getdate() as snapshot_time,%'
	AND it.STATE = 'ACTIVE'
	AND ico.LowestIQCursorState <> 'END_OF_DATA'
	AND ic.CmdLine <> 'NO COMMAND'
	AND lower(ic.CmdLine) NOT LIKE 'select getdate(*) as snapshot_time%'
