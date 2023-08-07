SELECT @@servername
	,userId
	,propname
	,value
FROM sa_conn_properties() cp
	,sp_iqwho() w
WHERE propName = 'Encryption'
	AND w.connhandle = cp.number


/*
SELECT @@servername
	,userId
	,w.connhandle
	,propname
	,value
FROM sa_conn_properties() cp
	,sp_iqwho() w
WHERE propName IN (
		'ClientLibrary'
		,'CommProtocol'
		,'database_authentication'
		,'java_location'
		,'LastStatement'
		)
	AND w.connhandle = cp.number
	AND userId = 'XXXXXXXXXX'

*/