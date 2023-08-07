SELECT name
	,CASE 
		WHEN type = 'V'
			THEN 'View'
		WHEN type = 'U'
			THEN 'User Table'
		WHEN type = 'S'
			THEN 'System Table'
		WHEN type = 'P'
			THEN 'Procedure'
		ELSE type
		END AS object_type
	,suser_name(uid) AS OWNER
FROM SYSOBJECTS
WHERE name LIKE 'XXXXXXXXXX%'
