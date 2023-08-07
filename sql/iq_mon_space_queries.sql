
sp_iqstatus

-- /pkgs/iq/catalog/
SELECT DISTINCT cast(100 * (total_space - free_space) / total_space AS INTEGER) AS asa_usage
FROM sa_disk_free_space()

                                                        

SELECT usage
FROM sp_iqdbspace()
WHERE UPPER(DBSpaceName) = UPPER('IQ_MAIN')

sp_iqstatus


SELECT cast(round(sum(MainTableKBDr / 1024 / 1024.), 0) AS INTEGER) AS versioning_alert
FROM sp_iqtransaction()

select * from sp_iqdbspace()