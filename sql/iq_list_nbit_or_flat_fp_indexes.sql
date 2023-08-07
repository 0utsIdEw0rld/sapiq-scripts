SELECT   idx.index_name, idx.index_type, c.column_name, tab.table_name, idx.[unique], rd.indexType
FROM     SYS.SYSTABLE as tab,
             SYS.SYSINDEX as idx,
             SYS.SYSUSERPERM as up,
             SYS.SYSIXCOL as ixc,
             SYS.SYSCOLUMN as c,
             (select * from sp_iqrowdensity('table dbo.deal_base')) as rd
    WHERE    up.user_id = idx.creator
    AND      up.user_name = 'dbo'
    AND      tab.table_id = idx.table_id
    AND      idx.index_type  in ( 'FP')
    AND      c.table_id = ixc.table_id
    AND      c.column_id = ixc.column_id
    AND      ixc.index_id = idx.index_id
    AND      ixc.table_id = idx.table_id
    and      up.user_name+'.'+tab.table_name = rd.tablename
    and      c.column_name = rd.[column name]
