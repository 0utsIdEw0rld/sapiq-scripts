SELECT su.name + '.' + sio.name AS table_name
	,sio.crdate
FROM dbo.sysiqobjects AS sio
	,dbo.sysusers AS su
WHERE sio.type = 'U'
	AND sio.uid = su.uid
	AND su.name = 'dbo'
	AND sio.crdate IS NOT NULL
ORDER BY crdate DESC
