SELECT SUBSTRING(value, CHARINDEX(',', value) + 2, 2)
FROM sp_iqstatus()
	,sysiqinfo
WHERE name IN (
		' Temporary IQ Blocks Used:'
		,' Local Temporary IQ Blocks Used:'
		)
