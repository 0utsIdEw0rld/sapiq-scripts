SELECT i.ConnHandle
	,u.user_name
FROM sp_iqconnection() i
JOIN SYSUSERPERM u ON connection_property('Userid', i.ConnHandle) = u.user_name
WHERE i.IQCmdType = 'NONE' -- No current command.
	AND i.IQthreads < 1 -- No thread.
	AND i.LastIQCmdTime > '0001/01/01' -- Actual TIME recorded.
	AND minutes(i.LastIQCmdTime, CURRENT TIMESTAMP) >= 15 -- Hardcoded time limit.
	AND i.LowestIQCursorState IN (
		'NONE'
		,'END_OF_DATA'
		) -- Active fetching?
