SELECT U.user_name + '.' + T.table_name
FROM sysobject O
	,systab T
	,sysuser U
WHERE T.object_id = O.object_id
	AND U.user_id = T.creator
	AND O.STATUS = 2 /* Invalid */
	AND O.object_type = 2 /* views */


alter view dbo.cr_mis_collateral_view recompile

alter view dbo.cr_mis_collateral_view enable 



/*
It can be the case that you need to recreate a table because it is corrupted. Well, the dependent views can become invalid after you dropped and recreated the table. 
The below query shows wich views are invalid (status = 2). Once you spot them, you need to run these two commands to fix them:
 
alter view dbo.md_price_info_latest recompile 
alter view dbo.md_price_info_latest enable 
*/

SELECT T.table_id
	,T.creator
	,T.object_id
	,T.table_name
	,U.user_name
	,T.table_type
	,J.[status]
	,F.file_id
	,F.dbspace_name
	,V.mv_use_in_optimization
	,V.mv_refresh_type
	,
IF T.table_type = 2 THEN COALESCE(IF V.mv_refresh_type = 1 THEN '0' ENDIF
		,
		IF J.[status] = 4 THEN '2' ENDIF
			,
			IF V.mv_last_refreshed_at IS NOT NULL THEN '3' END
				IF 
					,(
						SELECT FIRST SQLStateVal
						FROM dbo.sa_materialized_view_can_be_immediate(T.table_name, U.user_name)
						ORDER BY 1
						) ) END
					IF 
						,V.mv_last_refreshed_at
						,V.mv_known_stale_at
						,T.[encrypted]
						,T.pct_free
						,T.count
						,R.remarks FROM SYS.SYSTAB T JOIN SYS.SYSUSER U ON U.user_id = T.creator JOIN SYS.SYSOBJECT J ON J.object_id = T.object_id JOIN SYS.SYSVIEW V ON V.view_object_id = T.object_id LEFT OUTER JOIN SYS.SYSFILE F ON F.file_id = T.file_id
						AND T.table_type = 2 LEFT OUTER JOIN SYS.SYSREMARK R ON R.object_id = T.object_id WHERE J.[status] = 2 ORDER BY T.table_name
						,U.user_name
	
  
