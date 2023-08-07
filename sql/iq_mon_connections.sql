SELECT iqstatus.GlobalTempUsage
	,ico.TempWorkspaceKB / 1024.0 AS TempWorkspaceMB
	,CmdLine
	,ic.UserId
	,STATE
	,ic.ConnHandle
	,ic.iqconnid
	,TxnCreateTime
FROM sp_iqversionuse() AS ivu
	,sp_iqcontext() AS ic
	,sp_iqtransaction() AS it
	,sp_iqconnection() AS ico
	,(
		SELECT value AS GlobalTempUsage
		FROM sp_iqstatus()
		WHERE Name IN (
				' Temporary IQ Blocks Used:'
				,' Local Temporary IQ Blocks Used:'
				)
		) AS iqstatus
WHERE ivu.iqconnid = * ic.iqconnid
	AND it.iqconnid = * ic.iqconnid
	AND ico.ConnHandle = ic.ConnHandle
	AND lower(CmdLine) NOT LIKE 'select iqstatus.globaltempusage%'


  
sp_iqwho -- drop connection 30505
sp_iqcontext -- 30505
    
SELECT spit.connhandle
	,spco.Userid
	,spit.STATE
	,spco.ConnCreateTime
	,ConnOrCurCreateTime
	,LastReqTime
	,spit.name
	,connection_property('LastStatement', spit.connhandle) AS lastExecutedCommand
	,connection_property('AppInfo', spit.connhandle) AS AppInfo
	,spic.CmdLine
	,spvu.WasReported
	,spco.IQThreads
	,spco.TempTableSpaceKb / 1024. AS TempTableSpaceMB
	,spco.TempWorkSpaceKB / 1024. AS TempWorkSpaceMB
FROM sp_iqtransaction() spit
	,sp_iqcontext() spic
	,sp_iqversionuse() spvu
	,sp_iqconnection() spco
WHERE spic.Connhandle = spit.ConnHandle
	AND spit.IQConnID = spvu.IQConnid
	AND spco.Connhandle = spit.ConnHandle
	AND spic.ConnHandle != @@spid
	AND spic.ConnHandle < 1000000000
	AND spco.ConnHandle < 10000000
	AND LastReqTime < dateadd(hh, - 1, getdate())
	AND AppInfo NOT LIKE '%dbisql.exe%'

  
SELECT *
FROM sp_iqtransaction()
WHERE txncreatetime <= dateadd(hh, - 1, getdate())


SELECT connection.ConnHandle
	,connection.UserId
	,connection.NodeAddr
	,TRANSACTION.MainTableKBCr / 1024. / 1024 AS MainTableGBCr
	,TRANSACTION.MainTableKBDr / 1024. / 1024 AS MainTableGBDr
	,TRANSACTION.TempTableKBCr / 1024. / 1024 AS TempTableGBCr
	,TRANSACTION.TempTableKBDr / 1024. / 1024 AS TempTableGBDr
	,connection.TempWorkSpaceKB
	,connection.IQCmdType
	,connection.LowestIQCursorState
	,connection.LastReqTime
	,connection.IQthreads
	,context.CmdLine
FROM sp_iqconnection() connection
	,sp_iqcontext() context
	,sp_iqtransaction() TRANSACTION
WHERE connection.ConnHandle *= context.ConnHandle
	AND connection.ConnHandle *= TRANSACTION.ConnHandle
	--and upper(context.CmdLine) != 'NO COMMAND'
	--and upper(connection.LowestIQCursorState) != 'END_OF_DATA'
	--and transaction.state = 'ACTIVE'
	AND connection.ConnHandle != @@spid


SELECT datediff(ss, getdate(), connection.LastReqTime) AS active_connection_time_in_seconds
	,connection.ConnHandle
	,connection.UserId
	,connection.TempWorkSpaceKB / 1024. AS TempWorkSpaceMB
	,TRANSACTION.MainTableKBCr / 1024. AS MainTableMBCr
	,TRANSACTION.MainTableKBDr / 1024. AS MainTableMBDr
	,TRANSACTION.TempTableKBCr / 1024. AS TempTableMBCr
	,TRANSACTION.TempTableKBDr / 1024. AS TempTableMBDr
	,connection.IQthreads
	,context.CmdLine
	,connection.NodeAddr
	,connection.IQCmdType
	,connection.LowestIQCursorState
	,connection.LastReqTime
FROM sp_iqconnection() connection
	,sp_iqcontext() context
	,sp_iqtransaction() TRANSACTION
WHERE connection.ConnHandle = context.ConnHandle
	AND connection.ConnHandle = TRANSACTION.ConnHandle
	AND upper(context.CmdLine) != 'NO COMMAND'
	AND upper(connection.LowestIQCursorState) != 'END_OF_DATA'
	AND TRANSACTION.STATE = 'ACTIVE'
	AND (
		TempWorkSpaceMB != 0
		OR MainTableMBCr != 0
		OR MainTableMBDr != 0
		OR TempTableMBCr != 0
		OR TempTableMBDr != 0
		)
	AND connection.ConnHandle != @@spid



SELECT spit.connhandle
	,spic.Userid
	,spit.STATE
	,spco.ConnCreateTime
	,ConnOrCurCreateTime
	,LastReqTime
	,spit.name
	,spic.CmdLine
	,spvu.WasReported
	,spco.IQThreads
	,spco.TempTableSpaceKb / 1024. AS TempTableSpaceMB
	,spco.TempWorkSpaceKB / 1024. AS TempWorkSpaceMB
FROM sp_iqtransaction() spit
	,sp_iqcontext() spic
	,sp_iqversionuse() spvu
	,sp_iqconnection() spco
WHERE spic.Connhandle = spit.ConnHandle
	AND spit.IQConnID = spvu.IQConnid
	AND spco.Connhandle = spit.ConnHandle
	AND spic.ConnHandle != @@spid



SELECT
	--it.*, ic.* 
	it.name
	,it.userid
	,it.txnid
	,it.STATE
	,ct.CmdLine
	,ct.iqthreads
	,it.connhandle
	,it.MainTableKBCr
	,it.mainTableKBDr
	,ic.lastreqtime
	,ic.conncreatetime
FROM sp_iqtransaction() it
	,sp_iqconnection() ic
	,sp_iqcontext() ct
WHERE it.txnid = ic.txnid
	AND ct.connhandle = it.connhandle
	AND ct.CmdLine != 'NO COMMAND'
	AND it.userid != suser_name()

SELECT @@servername AS servername
	,a.ConnHandle
	,a.IQconnID
	,a.Userid
	,a.Name
	,a.ConnCreateTime
	,a.LastReqTime
	,a.ReqType
	,a.LastIQCmdTime
	,a.IQCmdType
	,a.TempTableSpaceKB
	,a.TempWorkSpaceKB
	,a.IQCursors
	,a.IQthreads
	,CONNECTION_PROPERTY('NodeAddress', a.ConnHandle) AS NodeAddress
	,b.CmdLine
	,b.ConnOrCursor
FROM dbo.sp_iqconnection() AS a
	,dbo.sp_iqcontext() AS b
WHERE a.ConnHandle = b.ConnHandle
ORDER BY ConnCreateTime ASC

SELECT *
FROM sa_conn_info()


SELECT *
FROM sa_conn_properties()
WHERE lower(propname) LIKE '%_timeout%'
	AND number = 12919

SELECT connection_property('PrepStmt')

set temporary option request_timeout = 86400 