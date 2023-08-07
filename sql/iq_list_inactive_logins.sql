SELECT U.user_name
	,S.last_login_time
	,R.remarks
	,
	--Ifnull(AD.auth, 'N', 'Y') AS dbaauth,
	--L.login_policy_name,
	--U.expire_password_on_login,
	U.password_creation_time
--Ifnull(AG.auth, 'N', 'Y') AS user_group
FROM sys.sysuser AS U
LEFT OUTER JOIN sys.sysuserauthority AS AD ON AD.user_id = U.user_id
	AND AD.auth = 'DBA'
LEFT OUTER JOIN dbo.Sa_get_user_status() AS S ON S.user_id = U.user_id
LEFT OUTER JOIN sys.sysremark AS R ON R.object_id = U.object_id
JOIN sys.sysloginpolicy AS L ON L.login_policy_id = U.login_policy_id
LEFT OUTER JOIN sys.sysuserauthority AS AG ON AG.user_id = U.user_id
	AND AG.auth = 'GROUP'
WHERE U.user_type = 12
	AND S.locked = 0
	AND dateadd(dd, 90, S.last_login_time) < getdate()
ORDER BY S.last_login_time;
