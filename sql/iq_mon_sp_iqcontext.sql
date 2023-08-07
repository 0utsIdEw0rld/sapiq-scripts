SELECT *
FROM sp_iqcontext()
WHERE connhandle != @@spid
	AND cmdline != 'NO COMMAND'
	AND connhandle < 1000000000
