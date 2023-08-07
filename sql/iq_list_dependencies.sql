SELECT soRef.name
	,soRef.type
	,soRef.id
	,suRef.user_name
	,soDep.name
	,soDep.type
	,suDep.user_name
	,soDep.id
FROM SYSDEPENDENCY sd
JOIN sysobjects soREf ON soRef.id = sd.ref_object_id
JOIN sysobjects soDep ON soDep.id = sd.dep_object_id
JOIN sysuser suRef ON suRef.user_id = soREF.uid
JOIN sysuser suDep ON suDep.user_id = soDep.uid
WHERE suRef.user_name = 'dbo'
