-- list users with unchanged passwords in more than one year
SELECT DISTINCT trim(user_name) AS user_name
	,sr.remarks
	,password_creation_time
FROM sysuser su
	,sysremark sr
	,(
		SELECT lp.login_policy_id
			,lp.login_policy_name
		FROM sys.sysloginpolicy lp
			,sys.sysloginpolicyoption lpo
		WHERE lp.login_policy_id = lpo.login_policy_id
			AND lpo.login_option_name != 'locked'
			AND login_option_value = 'On'
		) locked
WHERE su.login_policy_id = locked.login_policy_id
	AND su.object_id *= sr.object_id
	AND password_creation_time IS NOT NULL
	AND dateadd(dd, 365, password_creation_time) < getdate()
	AND user_name NOT IN (
		SELECT user_name
		FROM sa_get_user_status()
		WHERE locked = 1
		)
ORDER BY password_creation_time
