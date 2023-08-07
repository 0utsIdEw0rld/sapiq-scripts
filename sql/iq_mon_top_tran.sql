SELECT @@servername AS servername
	,CONNECTION_PROPERTY('NodeAddress', a.ConnHandle) AS NodeAddress
	,a.ConnHandle
	,a.IQconnID
	,substring(a.Userid, 1, 10) AS UserID
	,a.ReqType
	,substring(a.Name, 1, 30) AS Name
	,substring(a.ConnCreateTime, 1, 30) AS ConnCreateTime
	,substring(a.LastReqTime, 1, 30) AS LastReqTime
	,a.LastIdle
	,datediff(ss, a.LastReqTime, now()) AS Last_CALL_ET_sec
	,a.TempTableSpaceKB
	,a.TempWorkSpaceKB
	,b.CmdLine
FROM dbo.sp_iqconnection() AS a
	,dbo.sp_iqcontext() AS b
WHERE a.ConnHandle = b.ConnHandle
	AND b.CmdLine <> 'NO COMMAND'
	AND a.ConnHandle <> @@spid
	AND b.CmdLine <> ''
