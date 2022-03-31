select * 
from employees;

describe employees;
describe jobs;

select * from jobs;

select job_id, min_salary, max_salary, max_salary-min_salary
from jobs;

/* alias pt coloana*/
select job_id, min_salary, max_salary, max_salary-min_salary calcul
from jobs;

select job_id, min_salary, max_salary, max_salary-min_salary as calcul
from jobs;

select job_id, min_salary, max_salary, max_salary-min_salary as "diferenta calcul"
from jobs; -- 19 rezultate

select job_id Jobul_ana, min_salary "Salariul minim", max_salary, max_salary-min_salary as "diferenta calcul"
from jobs; -- 19 rezultate

select employee_id, salary
from employees
where salary > 10000
order by salary desc; -- 15 rezultate

select employee_id, salary
from employees
where salary > 10000
order by 2 desc; -- 15 rezultate

select salary, employee_id
from employees
where salary > 10000
order by 2 desc; -- 15 rezultate


select job_id, min_salary, max_salary, max_salary-min_salary calcul
from jobs
where max_salary-min_salary > 6000 -- 6 rezultate
order by calcul desc;


describe employees;

select employee_id || ' ' || first_name || ' ' || last_name as "Angajat si titlul",  job_id, hire_date
from employees; --107 rezultate

select first_name || ' ' || last_name || ', ' || job_id as "Angajat si titlul"
from employees --107 rezultate
where salary > 10000
order by salary;


--laborator 4 continuare
select last_name, e.department_id, d.department_name
from employees e, departments d 
where e.department_id = d.department_id;

select distinct e.job_id, j.job_title
from employees e, jobs j
where j.job_id = e.job_id and e.department_id = 30;

select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where e.department_id = d.department_id and l.location_id = d.location_id and lower(l.city)='oxford';



