SELECT @@servername AS servername
	,OWNER
	,object_name
	,convert(REAL, substr(columns, 1, char_length(columns) - 1)) * power(1024, charindex(substr(columns, char_length(columns), 1), 'BKMGTP') - 1) / 1024.0 / 1024.0 / 1024.0 AS columns_size_in_GB
	,convert(REAL, substr(indexes, 1, char_length(indexes) - 1)) * power(1024, charindex(substr(indexes, char_length(indexes), 1), 'BKMGTP') - 1) / 1024.0 / 1024.0 / 1024.0 AS indexes_size_in_GB
	,columns_size_in_GB + indexes_size_in_GB AS total_size_in_GB
FROM sp_iqdbspaceinfo()
WHERE total_size_in_GB > 1
ORDER BY total_size_in_GB DESC
