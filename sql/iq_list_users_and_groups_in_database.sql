SELECT name
	,user_group
FROM SYS.SYSUSERLIST
ORDER BY 1

SELECT member_name
	,list(group_name) AS group_list
FROM sysgroups
GROUP BY member_name
ORDER BY group_list;
OUTPUT TO 'j:\sybaseiq\sybase iq reports\group_members.html'

format html
