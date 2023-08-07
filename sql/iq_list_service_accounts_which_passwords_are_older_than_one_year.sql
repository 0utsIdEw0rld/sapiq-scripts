
--This query returns: 
-- [] non-locked users 
-- [] no groups
-- [] service accounts (login policy of root) 
-- [] which password has not changed in the last 365 days

SELECT trim(user_name) AS user_name
	,password_creation_time
	,datediff(dd, password_creation_time, getdate()) AS days_since_last_password_change
	,su.object_id
	,cast('' AS VARCHAR(255)) AS remarks
INTO #password_policy_report
FROM sysuser su
	,sysloginpolicy slp
WHERE su.login_policy_id = slp.login_policy_id
	AND login_policy_name = 'root' -- service accounts (login policy of root) 
	AND user_name NOT IN (
		SELECT group_name
		FROM sysgroups
		) --  no groups
	AND user_name NOT IN (
		SELECT user_name
		FROM sa_get_user_status()
		WHERE locked = 1
		) -- non-locked users 
	AND password_creation_time IS NOT NULL -- do not show system users without a password
	AND days_since_last_password_change >= 365 -- which password has not changed in the last 365 days

SELECT ppr.object_id
	,cast(sr.remarks AS VARCHAR(255)) AS remarks
INTO #remark
FROM sysremark sr
	,#password_policy_report ppr
WHERE ppr.object_id = sr.object_id

UPDATE #password_policy_report
SET remarks = r.remarks
FROM #remark r
WHERE #password_policy_report.object_id = r.object_id

SELECT user_name
	,password_creation_time
	,days_since_last_password_change
	,remarks
FROM #password_policy_report;
OUTPUT TO 'J:\SYBASEIQ\Sybase IQ reports\service_accounts_which_passwords_are_old_than_one_year.html'
format html



