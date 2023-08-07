-- if user_dn_cached_at is older than two months, either the cache is obsolete or the account is not used
SELECT *
FROM sa_get_user_status()
WHERE user_dn_cached_at < dateadd(dd, - 60, getdate())
--and last_login_time > dateadd (dd, -60, getdate())
ORDER BY user_dn_cached_at

SELECT *
FROM sysuser
WHERE user_type = 12
	AND user_id < 2147483749
	
SELECT *
FROM sysloginpolicyoption

	-- SELECT * FROM SYSLDAPSERVER ORDER BY ldsrv_name ASC
	-- sa_get_ldapserver_status
	- /*
select * from sysloginpolicyoption where login_option_name in ('ldap_primary_server', 'ldap_secondary_server') and login_option_value != '' 
and login_policy_id not in (select login_policy_id from SYSIQLSLOGINPOLICIES)
*/

DROP TABLE #user_dn_cached
SELECT login_option_value AS ldap_server
	,lower(su.user_name)
	,su.user_dn
	,length(ldap_server)
	,length(su.user_name)
	,length(su.user_dn)
INTO #user_dn_cached
FROM SYSUSER su
	,sysuserperm l
	,sysloginpolicy lp
	,sysloginpolicyoption lpo
WHERE su.login_policy_id = lp.login_policy_id
	AND lpo.login_policy_id = lp.login_policy_id
	AND login_option_name IN (
		'ldap_primary_server'
		,'ldap_secondary_server'
		)
	AND login_option_value != ''
	AND lpo.login_policy_id NOT IN (
		SELECT login_policy_id
		FROM SYSIQLSLOGINPOLICIES
		)
	AND l.user_id = su.user_id
	AND su.user_dn IS NOT NULL
ORDER BY 2


SELECT *
FROM sp_iqtransaction()
WHERE STATE = 'ACTIVE'
	AND connhandle != @@spid
	AND TxnCreateTime < dateadd(hh, (- 1) * 0, getdate())
	AND connhandle < 1000000000
	AND userId != 'iqtech' 
	

CREATE
	OR replace PROCEDURE dbo.sp_dba_monitor_and_alert_open_request (@number_of_hours INT DEFAULT 3) AS

BEGIN
	DECLARE @error INT
	DECLARE @connhandle INT
	DECLARE @fix_command VARCHAR(512)
	DECLARE @num_rows INT
	DECLARE @user_name VARCHAR(30)

	SELECT connhandle
		,userid AS user_name
	INTO #open_requests
	FROM sp_iqtransaction()
	WHERE STATE = 'ACTIVE'
		AND connhandle != @@spid
		AND TxnCreateTime < dateadd(hh, (- 1) * @number_of_hours, getdate())
		AND connhandle < 1000000000
		AND userId != 'iqtech'
	ORDER BY 1

	SELECT @num_rows = count(*)
	FROM #open_requests

	WHILE (@num_rows > 0)
	BEGIN
		SELECT @user_name = user_name
			,@connhandle = connhandle
		FROM #open_requests
		WHERE connhandle = (
				SELECT min(connhandle)
				FROM #open_requests
				)

		EXECUTE sp_iqlogtoiqmsg 'XXX MONITORING: ERROR. ' + @user_name + ' has ACTIVE transaction for more than ' + cast(@number_of_hours AS VARCHAR(2)) + '. ConnHandle: ' + cast(@connhandle AS VARCHAR(20))

		SELECT @fix_command = ' drop connection ' + cast(@connhandle AS VARCHAR(20))

		EXECUTE (@fix_command)

		EXECUTE sp_iqlogtoiqmsg 'XXX MONITORING: ERROR fixed with command ' + @fix_command

		DELETE
		FROM #open_requests
		WHERE connhandle = @connhandle

		SELECT @num_rows = count(*)
		FROM #open_requests
	END
END 



-- fixer: alter user XXXXXXXX refresh dn
-- these are accounts not logged in in the last two months
SELECT *
FROM sa_get_user_status()
WHERE last_login_time < dateadd(dd, - 60, getdate())
ORDER BY user_dn_cached_at


-- if the below query returns something, the account is locked for some strange reason. Should be notified
SELECT user_name
FROM sa_get_user_status()
WHERE locked = 1
	AND reason_locked != 'locked by login policy'


ALTER USER XXXXXXXX RESET LOGIN POLICY

SELECT 'drop connection ' + cast(connhandle AS VARCHAR(15)) + ';' AS killme
FROM sp_iqwho()
WHERE lower(userid) = 'XXXXXXXX'

