SELECT
	-- 'net user /domain ' + upper(su.user_name) +  ' >> net_user_all_output.log' as command, 
	upper(su.user_name)
	,lp.login_policy_name
	,su.user_id
	,CASE left(lp.login_policy_name, 6)
		WHEN 'locked'
			THEN 'LOCKED'
		ELSE 'OPEN'
		END STATUS
FROM SYSUSER su
	,sysuserperm l
	,sysloginpolicy lp
WHERE su.login_policy_id = lp.login_policy_id
	AND l.user_id = su.user_id
	AND l.user_group = 'N'
	AND su.user_id < 2147483749
ORDER BY 4

SELECT *
FROM sa_get_user_status()
WHERE user_name LIKE '%dw%'
