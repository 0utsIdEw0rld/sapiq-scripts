SELECT 'IQ_SYSTEM_TEMP'
	,usage
FROM sp_iqdbspace()
WHERE UPPER(DBSpaceName) = UPPER('IQ_SYSTEM_TEMP')

UNION ALL

SELECT 'iq_main'
	,usage
FROM sp_iqdbspace()
WHERE upper(DBSpaceName) = trim(UPPER('iq_main'))
