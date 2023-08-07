SELECT *
FROM sa_get_user_status()
WHERE locked = 1
	AND reason_locked <> 'locked by login policy'
