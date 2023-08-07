CREATE TABLE #server ( 
server_name varchar(255) null);
insert into #server location 'server1.x' {select @@servername};
select * from #server;
