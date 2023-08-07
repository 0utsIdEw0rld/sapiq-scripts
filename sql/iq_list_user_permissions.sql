SELECT @@servername
	,PERM.user_id
	,PERM.object_id
	,user_name
	,PERM.resourceauth
	,PERM.dbaauth
	,PERM.scheduleauth
	,PERM.publishauth
	,PERM.remotedbaauth
	,PERM.user_group
	,PERM.remarks
	,role_name
FROM SYSUSERPERM AS PERM
	,dbo.sp_displayroles() AS roles
WHERE user_name *= role_name
