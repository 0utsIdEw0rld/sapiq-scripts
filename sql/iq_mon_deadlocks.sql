-- deadlocks
SELECT a.*
	,b.table_name
	,u.user_name
FROM dbo.sa_report_deadlocks() a
LEFT OUTER JOIN (
	SYS.SYSTAB b JOIN SYS.SYSUSER u ON b.creator = u.user_id
	) ON a.object_id = b.object_id
ORDER BY a.snapshotId
	
-- SELECT CONNECTION_PROPERTY( 'log_deadlocks' )
