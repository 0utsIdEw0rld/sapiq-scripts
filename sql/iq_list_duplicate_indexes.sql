create table #dupes ( creator bigint, table_id bigint, table_name varchar(250), column_name varchar(250)) ;

insert into #dupes
SELECT creator
	,table_id
	,convert(CHAR(250), table_name)
	,convert(CHAR(250), cname)
FROM (
	SELECT DISTINCT SYS.SYSTABLE.creator
		,SYS.SYSTABLE.table_id
		,SYS.SYSTABLE.table_name
		,(
			SELECT column_name
			FROM SYS.SYSIXCOL
			JOIN SYS.SYSCOLUMN
			WHERE index_id = SYSINDEX.index_id
				AND SYSIXCOL.table_id = SYSINDEX.table_id
			) cname
		,index_type
	FROM SYS.SYSTABLE
	JOIN SYS.SYSINDEX
	WHERE index_type IN (
			'LF'
			,'HG'
			)
		AND (
			SELECT count(*)
			FROM SYS.SYSIXCOL
			JOIN SYS.SYSCOLUMN
			WHERE index_id = SYSINDEX.index_id
				AND SYSIXCOL.table_id = SYSINDEX.table_id
			GROUP BY index_id
			) = 1
	) x
GROUP BY creator
	,table_id
	,table_name
	,cname
HAVING count(*) > 1
ORDER BY creator
	,table_id
	,table_name
	,cname;


SELECT convert(VARCHAR(20), suser_name(d.creator)) OWNER
	,convert(CHAR(30), table_name)
	,index_type
	,index_name
FROM
	--#dupes join SYS.SYSINDEX
	#dupes d
	,SYS.SYSINDEX si
WHERE d.table_id = si.table_id
	AND d.creator = si.creator
	AND index_type IN (
		'LF'
		,'HG'
		)
	AND (
		SELECT count(*)
		FROM SYS.SYSIXCOL
		JOIN SYS.SYSCOLUMN
		WHERE index_id = si.index_id
			AND SYSIXCOL.table_id = si.table_id
		GROUP BY index_id
		) = 1
	AND d.column_name = (
		SELECT column_name
		FROM SYS.SYSIXCOL
		JOIN SYS.SYSCOLUMN
		WHERE index_id = si.index_id
			AND SYSIXCOL.table_id = si.table_id
		)
ORDER BY 1
	,2
	,3;

