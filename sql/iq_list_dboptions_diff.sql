SELECT @@servername AS servername
	,user_name
	,option_type
	,option_name
	,current_value
	,default_value
FROM sp_iqcheckoptions()
WHERE current_value <> default_value
ORDER BY user_name ASC
	,option_name ASC
