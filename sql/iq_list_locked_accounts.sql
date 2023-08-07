SELECT @@servername
	,upper(u.user_name) AS login_name
	,cast(@@servername AS VARCHAR(50)) AS server_name
	,'locked by login policy' AS reason_locked
	,cast(SUSER_NAME() AS VARCHAR(250)) AS updated_by
	,cast(getdate() AS DATETIME) AS updated_dttm
FROM sysuser AS u
	,(
		SELECT lp.login_policy_id
			,lp.login_policy_name
		FROM sys.sysloginpolicy AS lp
			,sys.sysloginpolicyoption AS lpo
		WHERE lp.login_policy_id = lpo.login_policy_id
			AND lpo.login_option_name = 'locked'
			AND login_option_value = 'On'
		) AS locked
WHERE u.login_policy_id = locked.login_policy_id

UNION ALL

SELECT @@servername
	,upper(u.user_name) AS login_name
	,cast(@@servername AS VARCHAR(50)) AS server_name
	,'password expired' AS reason_locked
	,cast(SUSER_NAME() AS VARCHAR(250)) AS updated_by
	,cast(getdate() AS DATETIME) AS updated_dttm
FROM sysuser AS u
	,(
		SELECT lp.login_policy_id
			,lpo.login_option_name
			,cast(lpo.login_option_value AS INTEGER) AS password_life_time
		FROM sys.sysloginpolicy AS lp
			,sys.sysloginpolicyoption AS lpo
		WHERE lp.login_policy_id = lpo.login_policy_id
			AND lpo.login_option_name = 'password_life_time'
			AND lpo.login_option_value <> 'unlimited'
		) AS password_life_time
WHERE u.login_policy_id = password_life_time.login_policy_id
	AND u.password_creation_time + password_life_time < cast(getdate() AS DATE)

UNION ALL

SELECT @@servername
	,upper(u.user_name) AS login_name
	,cast(@@servername AS VARCHAR(50)) AS server_name
	,'maximum failed logins exceeded' AS reason_locked
	,cast(SUSER_NAME() AS VARCHAR(250)) AS updated_by
	,cast(getdate() AS DATETIME) AS updated_dttm
FROM sysuser AS u
	,(
		SELECT lp.login_policy_id
			,lpo.login_option_name
			,cast(lpo.login_option_value AS INTEGER) AS max_failed_login_attempts
		FROM sys.sysloginpolicy AS lp
			,sys.sysloginpolicyoption AS lpo
		WHERE lp.login_policy_id = lpo.login_policy_id
			AND lpo.login_option_name = 'max_failed_login_attempts'
			AND lpo.login_option_value <> 'unlimited'
		) AS max_failed_login_attempts
WHERE u.login_policy_id = max_failed_login_attempts.login_policy_id
	AND u.failed_login_attempts > max_failed_login_attempts
