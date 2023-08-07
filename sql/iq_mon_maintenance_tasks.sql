SELECT UserId
	,CmdLine
	,*
FROM sp_iqcontext()
WHERE (
		CmdLine LIKE '%backup database%'
		OR CmdLine LIKE '%sp_iqcheckdb%'
		)
	AND NOT ConnHandle = ANY (
		SELECT connection_property('Number')
		)
