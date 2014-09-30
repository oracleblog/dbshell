#!/bin/bash
. ~/.bash_profile
V_TIMESTAMP=`date +%N`
while true
do
sqlplus test_rat/test_rat<<EOF>> ../log/workload_sql_1_`date +%Y%m%d`.log
set serverout on
set feedback on
exec DBMS_LOCK.SLEEP(round(DBMS_RANDOM.value(5,10),0));
drop table orasup_t1_$V_TIMESTAMP;
create table orasup_t1_$V_TIMESTAMP as select * from dba_objects;
insert into orasup_t1_$V_TIMESTAMP select * from orasup_t1_$V_TIMESTAMP;
insert into orasup_t1_$V_TIMESTAMP select * from orasup_t1_$V_TIMESTAMP;
insert into orasup_t1_$V_TIMESTAMP select * from orasup_t1_$V_TIMESTAMP;
insert into orasup_t1_$V_TIMESTAMP select * from orasup_t1_$V_TIMESTAMP;
delete from orasup_t1_$V_TIMESTAMP where rownum<=((select count(*) from orasup_t1_$V_TIMESTAMP)-500000);
commit;
insert into orasup_t1_$V_TIMESTAMP select * from orasup_t1_$V_TIMESTAMP where rownum<=round(DBMS_RANDOM.value(0,400000),0);
rollback;
delete from orasup_t1_$V_TIMESTAMP where rownum<=round(DBMS_RANDOM.value(0,400000),0);
rollback;
update orasup_t1_$V_TIMESTAMP set object_id=1 where rownum<=round(DBMS_RANDOM.value(0,400000),0);
rollback;
update orasup_t1_$V_TIMESTAMP set object_id=rownum;
commit;
create index idx_t1 on orasup_t1_$V_TIMESTAMP(object_id);
var v_obj_id number;
exec :v_obj_id:=round(DBMS_RANDOM.value(0,500000),0);
select object_id from orasup_t1_$V_TIMESTAMP where object_id=:v_obj_id;
exec :v_obj_id:=round(DBMS_RANDOM.value(0,500000),0);
select object_id from orasup_t1_$V_TIMESTAMP where object_id=:v_obj_id;
exec :v_obj_id:=round(DBMS_RANDOM.value(0,500000),0);
select object_id from orasup_t1_$V_TIMESTAMP where object_id=:v_obj_id;
exec :v_obj_id:=round(DBMS_RANDOM.value(0,500000),0);
select object_id from orasup_t1_$V_TIMESTAMP where object_id=:v_obj_id;
--##############
--Start plsql, loop 100 times
--
declare  
i number;
v_obj_id number;   
begin 
for i in 1..100 
loop  
select round(DBMS_RANDOM.value(0,500000),0) into v_obj_id from dual;
update orasup_t1_$V_TIMESTAMP set object_id=object_id+round(DBMS_RANDOM.value(0,100),0) where object_id=:v_obj_id;
commit;
dbms_output.put_line(i);
dbms_output.put_line(v_obj_id);
DBMS_LOCK.SLEEP(round(DBMS_RANDOM.value(1,5),0));
end loop;   
end; 
/
--
-- End plsql
--############################ 
exit
EOF
sleep 3
done
