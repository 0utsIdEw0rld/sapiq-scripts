SELECT props.number AS ConnId
	,props.PropName
	,props.value
FROM dbo.sa_conn_properties() props
WHERE lower(props.PropName) IN (
		'userid'
		,'appinfo'
		,'clientstmtcachemisses'
		,'connectedtime'
		,'clientnodeaddress'
		,'lastreqtime'
		,'laststatement'
		,'logintime'
		,'name'
		,'nodeaddress'
		,'osuser'
		,'servernodeaddress'
		)
	AND props.number IN (
		SELECT Number
		FROM sa_conn_info()
		WHERE reqtype = 'FETCH'
			AND userid != suser_name()
		)
ORDER BY ConnId
	,props.PropName
