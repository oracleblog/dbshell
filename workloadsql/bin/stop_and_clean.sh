#!/bin/bash
. ~/.bash_profile
echo "killing OS process ... PLEASE WAIT UNTIL FINISH"
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 5
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 5
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 10
echo "killing session in database ... PLEASE WAIT UNTIL FINISH"
sqlplus  -s "/ as sysdba"<<EOF> ../log/stop_and_clean_`date +%Y%m%d_%H%M%S_%N`.log
set line 1000
set pages 1000
set head off
set feedback off
set echo off
spool clean.sql
SELECT 'alter system kill session '||''''||SID||','||serial#||''''||' IMMEDIATE;'||CHR(10)||'exec DBMS_LOCK.SLEEP(5);'||CHR(10)
 FROM v\$session WHERE username='TEST_RAT';
spool off
@clean.sql
exit;
EOF
rm clean.sql
echo "killing another round... PLEASE WAIT UNTIL FINISH"
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 3 
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 3
kill -9 `ps -ef |grep workload_sql|grep -v grep|awk '{print $2}'`
sleep 3
sqlplus  -s "/ as sysdba"<<EOF> ../log/stop_and_clean_`date +%Y%m%d_%H%M%S_%N`.log
set line 1000
set pages 1000
set head off
set feedback off
set echo off
spool clean.sql
SELECT 'alter system kill session '||''''||SID||','||serial#||''''||' IMMEDIATE;'||CHR(10)||'exec DBMS_LOCK.SLEEP(5);'||CHR(10)
 FROM v\$session WHERE username='TEST_RAT';
spool off
@clean.sql
exit;
EOF
rm clean.sql
echo "Stop and clean FINISH!"
