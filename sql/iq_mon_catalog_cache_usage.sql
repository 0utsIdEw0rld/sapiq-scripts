-- To see global server usage:
SELECT now() AS MonDateTime
	,cast(property('MaxCacheSize') / 1024. AS DOUBLE) AS MaxCache
	,cast(property('CurrentCacheSize') / 1024. AS DOUBLE) AS CurrentCacheUsage
	,cast(property('CurrentCacheSize') AS DOUBLE) / cast(property('MaxCacheSize') AS DOUBLE) * 100 AS CacheInUsePercent;

--When high usage is observed in srvlog (cahce size adjusted to <number> K), connect as DBA and execute:
SELECT TOP 5 now() AS MonDateTime
	,number Conn_id
	,connection_property('name', number) AS AppName
	,connection_property('userid', number) AS UserName
	,Propname
	,value
FROM sa_conn_properties()
WHERE propname = 'CacheRead'
ORDER BY Value DESC;

--Average Cache usage 
begin 
	declare c1 int; 
	declare local temporary table #tmp1(ar bigint, lp bigint) in SYSTEM; 
	set c1 = 0; 
	lp: loop 
		set c1 = c1 + 1; 
		if c1 > 10 then 
		leave lp 
		end if; 
		insert #tmp1 select property('ActiveReq'), property('LockedHeapPages'); 
		waitfor delay '00:00:05'; 
	end loop; 
	select max(lp) as MaxLockedHeapPages, 
	max(ar) as MaxActiveReq , 
	max(lp)/max(ar) as AvgPagesPerRequest 
	from #tmp1; 
end;
