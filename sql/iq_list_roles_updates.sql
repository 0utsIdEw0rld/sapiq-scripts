SELECT @@servername
	,user_name
	,insertauth
	,deleteauth
	,updateauth
	,stname
	,grantor
FROM SYSUSERPERM
	,SYSTABAUTH
WHERE (
		insertauth <> 'N'
		OR deleteauth <> 'N'
		OR updateauth <> 'N'
		)
	AND user_name = grantee
	AND user_group = 'Y'
	AND tcreator = 'dbo'
	AND grantor != 'SYS'
ORDER BY stname;
