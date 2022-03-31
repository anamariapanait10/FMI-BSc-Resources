
select e.last_name, j.max_salary, j.min_salary, d.department_name
from employees e, jobs j, departments d
where e.department_id = d.department_id and j.job_id = e.job_id;


select e.last_name, e.salary, j.job_title, l.city, c.country_name
from employees e, jobs j, departments d, locations l, countries c
where e.department_id= d.department_id and j.job_id = e.job_id and l.location_id=d.location_id 
and c.country_id=l.country_id and e.manager_id = 100;


select e.last_name, e.hire_date
from employees e
where e.hire_date > (select e2.hire_date from employees e2 where e2.last_name='Gates');


select e.last_name, to_char(e.hire_date, 'MONTH') as "luna", to_char(e.hire_date, 'YYYY') as "anul"
from employees e, employees e2
where e2.last_name='Gates' and e.department_id=e2.department_id and lower(e.last_name) like '%a%';



select e.last_name, to_char(e.hire_date, 'MONTH') as "luna", to_char(e.hire_date, 'YYYY') as "anul"
from employees e, employees e2
where e2.last_name='Gates' and e.department_id=e2.department_id and lower(e.last_name) like '%a%';

select e.last_name from employees e where e.department_id = (select e2.department_id 
from employees e2 
where initcp);


select e.employee_id, e.last_name
from employees e
where e.department_id in (select distinct e2.department_id
                        from departments d, employees e2
                        where lower(e2.last_name) like '%t%' and e.department_id = d.department_id);
                        





