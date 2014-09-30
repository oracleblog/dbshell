#!/bin/bash
. ~/.bash_profile

sqlplus "/ as sysdba"<<EOF>> ../log/initial_`date +%Y%m%d`.log
drop user test_rat cascade;
create user test_rat identified by test_rat default tablespace users;
grant connect,resource to test_rat;
grant select any table,select any dictionary to test_rat;
grant execute on DBMS_LOCK to test_rat; 
exit;
EOF

nohup ./workload_sql_1.sh &
nohup ./workload_sql_2.sh &
nohup ./workload_sql_3.sh &

echo "Initial and start!"
