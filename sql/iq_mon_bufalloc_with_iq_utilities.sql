declare local temporary table dummy_monitor (dummy_column integer);
set option Monitor_Output_Directory = '/tmp/';
iq utilities private into dummy_monitor start monitor '-bufalloc -interval 2';
iq utilities private into dummy_monitor stop monitor;


