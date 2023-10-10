-- Lab 1 - Gr 2 - LABORATOR SQL RECAPITULARE – 1

-- 1
-- a - F
-- b - A
-- c - F

-- 2
-- a - F
-- b - A
-- c - F
-- d - F

-- 3
-- a - A
-- b - A
-- c - F
-- d - A

-- 4 - d

-- 5 - c

-- 6 - a

-- 7 - a

-- 8 - c

-- 9 - c

-- 10 - d

-- 11-12
create table emp_gid as select * from employees;

comment on table emp_gid is 'Informatii despre angajati';
comment on column emp_gid.hire_date is 'Data angajarii';

select * from user_tab_comments 
where table_name = upper('emp_gid');

select * from user_col_comments
where table_name = upper('emp_gid');

-- actualizare comentarii
comment on table emp_gid is 'Informatii despre angajati-NOU';
comment on column emp_gid.hire_date is 'Data angajarii-NOU';

-- stergere comentarii
comment on table emp_gid is '';
comment on column emp_gid.hire_date is '';

-- 13

select sysdate from dual;
alter session set nls_date_format = 'DD.MM.YYYY HH24:MI:SS';

-- 14

SELECT EXTRACT(YEAR FROM SYSDATE)
FROM dual;

-- 15

select extract(day from sysdate), extract(month from sysdate)
from dual;

-- 16

select table_name
from user_tables
where table_name like upper('%_gid');

-- 17-18

create table dept_gid as select * from departments;

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_gid');

-- comenzile de mai jos (pana la ex 19) trebuie selectate si rulate ca script
spool C:\Users\Ioana\Desktop\Lab1\sterg_tabele.sql --calea si numele fisierului

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_gid');

spool off

-- 19

--se multiplica antetul tabelului
--apare mesajul de final (de exemplu 2 rows selected)

-- 20

-- comenzile de mai jos (pana la ex 21) trebuie selectate si rulate ca script
set feedback off
spool C:\Users\Ioana\Desktop\Lab1\sterg_tabele.sql  --calea si numele fisierului

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_gid');

spool off
set feedback on

-- 21

-- comenzile de mai jos (pana la tema) trebuie selectate si rulate ca script
set pagesize 0
set feedback off
spool C:\Users\Ioana\Desktop\Lab1\sterg_tabele.sql  --calea si numele fisierului

select 'DROP TABLE ' || table_name || ';'
from user_tables
where table_name like upper('%_gid');

spool off
set feedback on
set pagesize 10

-- tema: ex 23, deadline: miercuri 12.10.2022 23:59 








