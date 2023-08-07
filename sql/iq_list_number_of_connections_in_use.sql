SELECT @@max_connections AS 'max_connections'
	,count(*) AS 'active_connections'
	,(1 - (@@max_connections - count(*)) / convert(NUMERIC, @@max_connections)) * 100 AS 'percent_active'
FROM sp_iqconnection();
