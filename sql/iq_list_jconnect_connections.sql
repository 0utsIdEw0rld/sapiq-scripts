SELECT connectionId
	,userId
	,application
FROM sp_iqshowpsexe()
WHERE connectionId IN (
		SELECT number
		FROM sa_conn_properties()
		WHERE propname = 'ClientLibrary'
			AND value = 'jConnect'
		)
