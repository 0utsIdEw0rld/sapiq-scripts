SELECT trim(user_name) AS user_name
	,sr.remarks
	,password_creation_time
FROM sysuser su
	,sysremark sr
WHERE su.object_id *= sr.object_id
	--and password_creation_time is not null
	AND dateadd(dd, 365, password_creation_time) < getdate()
	AND user_name IN (
		SELECT user_name
		FROM sa_get_user_status()
		WHERE locked = 1
		)
ORDER BY password_creation_time



SELECT *
FROM sa_get_user_status()
WHERE locked = 1
	AND user_name = 'XXXXXXXX'
