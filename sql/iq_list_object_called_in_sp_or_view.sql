set temporary option quoted_identifier = on;
--1.
SELECT view_name
	,view_owner
FROM sp_iqview()
WHERE view_def LIKE '%TABLE_NAME%'


--2.
SELECT proc_name
	,creator
FROM sysprocedure
WHERE proc_defn LIKE '%TABLE_NAME%'

