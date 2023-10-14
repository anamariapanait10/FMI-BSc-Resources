create table emp_pam as select * from employees;
comment on table emp_pam is 'Informatii despre angajati';
comment on column emp_pam.hire_date is 'Data_angajarii';

select * from user_tab_comments
where table_name = upper('emp_pam');

select * from user_col_comments
where table_name = upper('emp_pam');

comment on table emp_pam is 'Informatii despre angatati-NOU';
comment on column emp_pam.hire_date is 'Data angajarii-NOU';


-- 13
alter session set nls_date_format = 'DD.MM.YYYY HH24:MI:SS';

select sysdate from dual;

--14

select extract(YEAR from sysdate)
form dual;

--15

select extract(day from sysdate), extract(month from sysdate)
form dual;

--16

select table_name
from user_tables
where table_name like upper('%_pam');

-- 17

create table dept_pam as select * from departments;

select 'DROP TABLE' || table_name || ';'
from user_tables
where table_name like upper('%_pam');

spool C:\Users\Ana\Desktop\FMI\ceva.sql

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_pam');

spool off

--20 

set feedback off
spool C:\Users\Ana\Desktop\FMI\ceva.sql

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_pam');

spool off
set feedback on

-- 21 
set pagesize 0
set feedback off
spool C:\Users\Ana\Desktop\FMI\ceva.sql

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_pam');

spool off
set feedback on
set pagesize 10

--23
set pagesize 0
set feedback off
spool C:\Users\Ana\Desktop\FMI\ceva.sql

SELECT 'INSERT INTO departments VALUES(' || department_id ||', '''|| department_name ||''', '|| nvl(to_char(manager_id), 'Null') ||', '|| location_id || ');'
FROM departments;

spool off
set feedback on

select * from departments;

INSERT INTO departments VALUES(10, 'Administration', 200, 1700);
INSERT INTO departments VALUES(20, 'Marketing', 201, 1800);
INSERT INTO departments VALUES(30, 'Purchasing', 114, 1700);
INSERT INTO departments VALUES(40, 'Human Resources', 203, 2400);
INSERT INTO departments VALUES(50, 'Shipping', 121, 1500);
INSERT INTO departments VALUES(60, 'IT', 103, 1400);
INSERT INTO departments VALUES(70, 'Public Relations', 204, 2700);
INSERT INTO departments VALUES(80, 'Sales', 145, 2500);
INSERT INTO departments VALUES(90, 'Executive', 100, 1700);
INSERT INTO departments VALUES(100, 'Finance', 108, 1700);
INSERT INTO departments VALUES(110, 'Accounting', 205, 1700);
INSERT INTO departments VALUES(120, 'Treasury', Null, 1700);
INSERT INTO departments VALUES(130, 'Corporate Tax', Null, 1700);
INSERT INTO departments VALUES(140, 'Control And Credit', Null, 1700);
INSERT INTO departments VALUES(150, 'Shareholder Services', Null, 1700);
INSERT INTO departments VALUES(160, 'Benefits', Null, 1700);
INSERT INTO departments VALUES(170, 'Manufacturing', Null, 1700);
INSERT INTO departments VALUES(180, 'Construction', Null, 1700);
INSERT INTO departments VALUES(190, 'Contracting', Null, 1700);
INSERT INTO departments VALUES(200, 'Operations', Null, 1700);
INSERT INTO departments VALUES(210, 'IT Support', Null, 1700);
INSERT INTO departments VALUES(220, 'NOC', Null, 1700);
INSERT INTO departments VALUES(230, 'IT Helpdesk', Null, 1700);
INSERT INTO departments VALUES(240, 'Government Sales', Null, 1700);
INSERT INTO departments VALUES(2530, 'Retail Saless', Null, 1700);
INSERT INTO departments VALUES(2630, 'Recruitxing', Null, 1700);
INSERT INTO departments VALUES(2730, 'Payrozll', Null, 1700);
INSERT INTO departments VALUES(2830, 'Recreaction', 121, 1700);


select 'INSERT INTO TABLE ' || table_name ||
'VALUES ' (select * from departments) || ';'
from user_tables
where table_name like upper('%_pam');


select 'INSERT INTO TABLE' || table_name  ||
'VALUES' || (' || department_id ||','''|| department_name ||''','|| nvl(to_char(manager_id), 'null') ||','|| location_id || ')' FROM departments)
from user_tables
where table_name like upper('%_pam');