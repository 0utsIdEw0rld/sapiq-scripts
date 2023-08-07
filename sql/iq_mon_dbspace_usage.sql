SELECT getdate() AS snapshot_time
	,DBSpaceName
	,cast(usage AS INTEGER) AS usage
	,TotalSize
	,cast(Reserve AS VARCHAR(10)) AS reserve
	,cast(NumFiles AS VARCHAR(10)) AS NumFiles
	,cast(StripingOn AS VARCHAR(10)) AS StripingOn
	,cast(StripeSize AS VARCHAR(10)) AS StripeSize
	,cast(BlkTypes AS VARCHAR(10)) AS BlkTypes
	,cast(OkToDrop AS VARCHAR(10)) AS OkToDrop
FROM sp_iqdbspace()
WHERE DBSpaceName IN (
		'iq_main'
		,'IQ_SYSTEM_MAIN'
		,'IQ_SYSTEM_TEMP'
		)

UNION ALL

SELECT DISTINCT getdate() AS snapshot_time
	,'ASA disk' AS DBSpaceName
	,cast(100 * (total_space - free_space) / total_space AS INTEGER) AS usage
	,cast(total_space / 1024. / 1024. / 1024. AS VARCHAR(10)) + 'G' 'N/A'
	,'N/A'
	,'N/A'
	,'N/A'
	,'N/A'
	,'N/A'
	,'N/A'
FROM sa_disk_free_space();



SELECT getdate() AS snapshot_time
	,DBSpaceName
	,cast(usage AS INTEGER) AS usage_pct
FROM sp_iqdbspace()
WHERE DBSpaceName IN (
		'iq_main'
		,'IQ_SYSTEM_MAIN'
		,'IQ_SYSTEM_TEMP'
		)

UNION ALL

SELECT DISTINCT getdate() AS snapshot_time
	,'ASA disk' AS DBSpaceName
	,cast(100 * (total_space - free_space) / total_space AS INTEGER) AS usage
FROM sa_disk_free_space();





SELECT *
FROM sp_iqstatus()
WHERE name = ' Version:'

SELECT R.dbspace_name
	,Q.dbfile_name
	,P.file_name
	,P.read_write
	,P.block_count
	,P.reserve_size
	,(
		SELECT block_size
		FROM SYSIQINFO
		)
FROM SYS.SYSIQDBFILE P
	,SYS.SYSDBFILE Q
	,SYS.SYSDBSPACE R
WHERE P.dbfile_id = Q.dbfile_id
	AND Q.dbspace_id = R.dbspace_id


