SELECT SUBSTRING(value, CHARINDEX(',', value) + 2, 2) AS percentage
FROM sp_iqstatus()
	,sysiqinfo
WHERE Name = ' Main IQ Blocks Used:';
