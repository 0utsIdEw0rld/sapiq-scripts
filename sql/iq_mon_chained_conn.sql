WITH connhandle
AS (
	SELECT connhandle
		,userid
	FROM sp_iqwho()
	)
	,scp
AS (
	SELECT number
		,propname
		,value
	FROM sa_conn_properties()
	)
SELECT connHandle
	,userid
	,propname
	,value
FROM scp
	,connhandle
WHERE scp.number = connhandle.connhandle
	AND PropName = 'UncommitOp'
	AND value > 0

UNION ALL

SELECT connHandle
	,userid
	,propname
	,value
FROM scp
	,connhandle
WHERE scp.number = connhandle.connhandle
	AND PropName = 'chained'
	AND lower(value) = 'on'

UNION ALL

SELECT connHandle
	,userid
	,propname
	,value
FROM scp
	,connhandle
WHERE scp.number = connhandle.connhandle
	AND PropName = 'close_on_endtrans'
	AND lower(value) = 'off'

UNION ALL

SELECT connHandle
	,userid
	,propname
	,value
FROM scp
	,connhandle
WHERE scp.number = connhandle.connhandle
	AND PropName = 'TransactionStartTime'
	AND lower(value) <> ''
