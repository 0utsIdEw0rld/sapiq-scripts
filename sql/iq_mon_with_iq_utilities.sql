--sp_iqsysmon '00:00:05', 'lma'

set temporary option Monitor_Output_Directory = '/tmp/'
go
declare local temporary table dummy_monitor (dummy_column integer)
go
-- main cache=main
iq utilities main into dummy_monitor start monitor '-summary -interval 5'
go
-- temp cache=private
iq utilities private into dummy_monitor start monitor  '-cache -interval 3'
iq utilities private into dummy_monitor start monitor '-bufalloc -interval 2'

iq utilities main into dummy_monitor start monitor  '-cache -interval 3'
commit
go

/* Do not disconnect from IQ and wait until the monitoring should stop. Then type this: */
iq utilities main into dummy_monitor stop monitor
go