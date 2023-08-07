SELECT @@servername AS servername
	,*
FROM sa_db_properties()
