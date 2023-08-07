@@servername AS servername
	,Number
	,Name
	,ReqTimeActive
	,convert(DOUBLE, DATEDIFF(second, LoginTime, CURRENT TIMESTAMP)) AS T
	,ReqTimeActive / T AS PercentActive
FROM dbo.sa_performance_diagnostics()
WHERE PercentActive > 10.0
	AND T > 0
ORDER BY PercentActive DESC
