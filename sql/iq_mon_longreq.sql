SELECT number
	,name
	,ReqStatus
	,convert(DOUBLE, DATEDIFF(second, LastReqTime, CURRENT TIMESTAMP)) AS ReqTime
FROM dbo.sa_performance_diagnostics()
WHERE upper(ReqStatus) <> 'IDLE'
	AND ReqTime > 60.0
ORDER BY ReqTime DESC
