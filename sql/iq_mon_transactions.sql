-- IQ sets an implicit savepoint before and after every DML command
SELECT tx.ConnHandle
	,tx.Name
	,tx.UserId
	,tx.STATE
	,tx.TxnID
	,datediff(ss, tx.TxnCreateTime, now()) AS secondsOfExec
	,round(tx.SpCount / 2, 0) AS RowsLoaded
	,round(tx.SpNumber / datediff(ss, tx.TxnCreateTime, now()), 0) AS avgRowsPerSecond
	,cx.CmdLine
	,cx.IQthreads
	,tx.maintableKbCr / 1024. AS maintableMbCr
	,tx.maintableKbdr / 1024. AS maintableMbdr
	,tx.temptableKbCr / 1024. AS temptableMbCr
	,tx.temptableKbDr / 1024. AS temptableMbDr
FROM sp_iqtransaction() tx
	,sp_iqcontext() cx
WHERE datediff(ss, TxnCreateTime, now()) != 0
	AND tx.connhandle = cx.connhandle
	AND cx.connOrCursor = 'CONNECTION'
