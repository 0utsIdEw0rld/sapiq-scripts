SELECT ConnHandle
	,Userid
	,ConnOrCurCreateTime
FROM sp_iqcontext()
WHERE ConnOrCurCreateTime < (getdate() - 5 / 24.0);
