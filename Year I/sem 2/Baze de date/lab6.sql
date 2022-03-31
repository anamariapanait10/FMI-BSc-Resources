-- lab 6

select department_id 
from departments
minus
select department_id
from employees;

select department_id 
from departments
where department_id not in (select department_id from employees where department_id is not null);

create table EMP_PAM as select * from employees;
create table DEPT_PAM as select * from departments;

describe employees;
describe EMP_PAM;
select * from EMP_nem;

alter table EMP_PAM
ADD CONSTRAINT pk_emp_pam PRIMARY KEY(employee_id);

alter table DEPT_PAM
ADD CONSTRAINT pk_dept_pam PRIMARY KEY(department_id);

alter table EMP_PAM
ADD CONSTRAINT fk_emp_dept_pam FOREIGN KEY(department_id)
REFERENCES DEPT_PAM(department_id);

select *
from user_constraints
where lower(table_name) = 'emp_pam';

select *
from user_constraints
where lower(table_name) = 'dept_pam';

select * from dept_ong2 where department_id=300;

