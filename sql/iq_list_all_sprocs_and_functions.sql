SELECT '--' = b.user_name + '.' + a.proc_name
FROM sys.sysprocedure a
JOIN sys.sysuserperm b ON a.creator = b.user_id
-- where  b.user_name = 'dbo'
ORDER BY a.proc_name;
GO