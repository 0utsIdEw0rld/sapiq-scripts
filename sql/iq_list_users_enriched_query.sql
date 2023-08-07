SELECT user_name
	,login_policy_name
	,sr.remarks
	,creation_time AS login_creation_time
	,password_creation_time
	,last_login_time
	,user_dn
	,remarks
FROM sys.sysloginpolicy p
	,sys.sysuser u
	,sysremark sr
	,sysobject so
WHERE p.login_policy_id = u.login_policy_id
	AND u.object_id = so.object_id
	AND user_name NOT IN (
		SELECT group_name
		FROM sysgroups
		)
	AND u.user_id > 100
	AND u.user_id < 2147484648 -- remove system logins
	AND u.object_id *= sr.object_id
	AND user_name NOT LIKE 'SYS_%'
ORDER BY user_name



SELECT U.user_id
	,U.object_id
	,U.user_name
	,IFNULL(AG.auth, 'N', 'Y') AS user_group
	,IFNULL(AP.auth, 'N', 'Y') AS publishauth
	,M.consolidate
	,IFNULL(AD.auth, 'N', 'Y') AS dbaauth
	,IFNULL(AR.auth, 'N', 'Y') AS resourceauth
	,IFNULL(AM.auth, 'N', 'Y') AS remotedbaauth
	,IFNULL(AB.auth, 'N', 'Y') AS backupauth
	,IFNULL(AV.auth, 'N', 'Y') AS validateauth
	,IFNULL(AF.auth, 'N', 'Y') AS profileauth
	,IFNULL(ARF.auth, 'N', 'Y') AS readfileauth
	,IFNULL(ARCF.auth, 'N', 'Y') AS readclientfileauth
	,IFNULL(AWCF.auth, 'N', 'Y') AS writeclientfileauth
	,U.login_policy_id
	,L.login_policy_name
	,U.password_creation_time
	,U.expire_password_on_login
	,S.last_login_time
	,S.failed_logins
	,S.locked
	,S.reason_locked
	,T.type_name
	,M.address
	,M.frequency
	,M.send_time
	,R.remarks
	,IFNULL(AUADM.auth, 'N', 'Y') AS useradminauth
	,IFNULL(ASADM.auth, 'N', 'Y') AS spaceadminauth
	,IFNULL(AMADM.auth, 'N', 'Y') AS mpxadminauth
	,IFNULL(APADM.auth, 'N', 'Y') AS permsadminauth
	,IFNULL(AOPER.auth, 'N', 'Y') AS operatorauth
FROM SYS.SYSUSER U
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AG ON AG.user_id = U.user_id
	AND AG.auth = 'GROUP'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AP ON AP.user_id = U.user_id
	AND AP.auth = 'PUBLISH'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AD ON AD.user_id = U.user_id
	AND AD.auth = 'DBA'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AR ON AR.user_id = U.user_id
	AND AR.auth = 'RESOURCE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AM ON AM.user_id = U.user_id
	AND AM.auth = 'REMOTE DBA'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AB ON AB.user_id = U.user_id
	AND AB.auth = 'BACKUP'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AV ON AV.user_id = U.user_id
	AND AV.auth = 'VALIDATE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AF ON AF.user_id = U.user_id
	AND AF.auth = 'PROFILE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY ARF ON ARF.user_id = U.user_id
	AND ARF.auth = 'READFILE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY ARCF ON ARCF.user_id = U.user_id
	AND ARCF.auth = 'READCLIENTFILE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AWCF ON AWCF.user_id = U.user_id
	AND AWCF.auth = 'WRITECLIENTFILE'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AUADM ON AUADM.user_id = U.user_id
	AND AUADM.auth = 'User Admin'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY ASADM ON ASADM.user_id = U.user_id
	AND ASADM.auth = 'Space Admin'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AMADM ON AMADM.user_id = U.user_id
	AND AMADM.auth = 'MULTIPLEX Admin'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY APADM ON APADM.user_id = U.user_id
	AND APADM.auth = 'Perms Admin'
LEFT OUTER JOIN SYS.SYSUSERAUTHORITY AOPER ON AOPER.user_id = U.user_id
	AND AOPER.auth = 'Operator'
JOIN SYS.SYSLOGINPOLICY L ON L.login_policy_id = U.login_policy_id
LEFT OUTER JOIN dbo.sa_get_user_status() S ON S.user_id = U.user_id
LEFT OUTER JOIN (
	SYS.SYSREMOTEUSER M JOIN SYS.SYSREMOTETYPE T ON T.type_id = M.type_id
	) ON M.user_id = U.user_id
LEFT OUTER JOIN SYS.SYSREMARK R ON R.object_id = U.object_id
	--WHERE U.user_name = 'XXXXXXXXX'


