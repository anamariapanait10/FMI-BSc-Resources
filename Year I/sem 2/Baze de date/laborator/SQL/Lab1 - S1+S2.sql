select *
from employees;

select * from Employees;

describe employees;
describe jobs;
select * from jobs;

select *
from employees;

describe employees;
describe jobs;

select employee_id
from employees; --107 rezultate


select employee_id, salary
from employees
where salary > 10000; --15 rezutate


select employee_id, salary
where salary > 10000 --nu aici --ORA-00923: FROM keyword not found where expected
from employees;

select employee_id, salary
from employees
where salary > 10000
and employee_id <150
order by salary desc; --10 rezutate

select employee_id, salary
from employees
where salary > 10000
order by salary desc; -- 15 rez

select employee_id, salary --ordoneaza dupa cea de-a doua coloana
from employees
where salary > 10000
order by 2 desc; --15 rezutate

select salary, employee_id --ordoneaza dupa cea de-a doua coloana
from employees
where salary > 10000
order by 2 desc; --15 rezutate

select employee_id, salary sal 
from employees
where salary > 10000
order by sal desc; --15 rezutate


select employee_id, salary sal 
from employees
where sal > 10000  -- ORA-00904: "SAL": invalid identifier
order by sal desc; 



--alias coloane
select job_id, min_salary, max_salary, max_salary - min_salary
from jobs; --19 rezultate

Select job_id JOBUL, min_salary, max_salary, max_salary - min_salary "calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary   calcul
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary  as calcul
from jobs; --19 rezultate

select job_id, min_salary, max_salary, 
       max_salary - min_salary  as "Diferenta calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary,
      max_salary - min_salary  "Diferenta calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary, 
      max_salary - min_salary  as diferenta calcul
from jobs; --nu  --ORA-00923: FROM keyword not found where expected

select job_id, min_salary, max_salary, 
      max_salary - min_salary  as diferenta_calcul
from jobs; --19 

select job_id Jobul_ong, min_salary "Salariul minim", max_salary, max_salary - min_salary  as diferenta_calcul
from jobs; --19 

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
where calcul > 6000;  --ORA-00904: "CALCUL": invalid identifier

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
where max_salary - min_salary > 6000
order by calcul desc; -- 6 rezultate

--S? se afi?eze codul angajatului, numele, codul job-ului, data  angajarii pentru toti angajatii din firma


describe employees;

select employee_id, first_name || " " || Last_name NUMEle_complet, job_id, hire_date --ORA-00904: " ": invalid identifier
from employees;

select employee_id, first_name || ' ' || Last_name NUMEle_complet, job_id, hire_date
from employees;



/*S? se afi?eze pentru fiecare angajat numele concatenat cu job_id-ul, 
separate prin virgula si spatiu, si etichetati coloana “Angajat si titlu”
*/

select  first_name || ' ' || Last_name || ', ' ||job_id "Angajat si titlu"
from employees; --107 rezultate

select  first_name || ' ' || Last_name || ', ' ||job_id "Angajat si titlu"
from employees
where salary >10000
order by salary; --15 rezultate

---S2
10. S? se listeze numele complet si salariul angaja?ilor care câ?tig? mai mult de 2850. 

select first_name || ' ' ||last_name, salary
from employees
where salary > 2850;



select 1+2
from dual; --afis val 3

select 1+2
from employees; --107 rasp

select sysdate
from dual; --23-FEB-22 //  23-02-2022

select to_char(sysdate, 'DAY /MM/ YEAR')
from dual; --WEDNESDAY /02/ TWENTY TWENTY-TWO //MIERCURI /02/ TWENTY TWENTY-TWO


alter session set nls_language=American;

alter session set nls_language=Romanian;

select to_char(sysdate, 'DD /MM/ YYYY')
from dual; --23 /02/ 2022

select to_char(sysdate, 'D /MM/ YYYY')
from dual; --4 /02/ 2022 --mirecuri este a 4-a zi din sapt 
--(duminica este prima zi din sapt)


ex - numele lunii in care s-a angajat fiecare salariat

select to_char(hire_date, 'Month'),to_char(Hire_date, 'MONTH')
from employees;
--June     	JUNE     
--September	SEPTEMBER
--January  	JANUARY  

--ordonare
select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY')
from employees
order by 1;

select to_char(hire_date, 'Month') luna,to_char(hire_date, 'DAY')
from employees
order by luna;

select to_char(hire_date, 'Month') ,to_char(hire_date, 'DAY')
from employees
order by to_char(hire_date, 'Month');

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY'), employee_id
from employees
order by 1 asc, 2 desc;

April    	THURSDAY 
April    	THURSDAY 
April    	SATURDAY 
April    	MONDAY   
April    	FRIDAY   
April    	FRIDAY   
April    	FRIDAY   
select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY')  ,
        to_char(hire_date, 'D'), employee_id
from employees
order by 1 asc, to_number(to_char(hire_date, 'D')) desc;

April    	SATURDAY 
April    	FRIDAY   
April    	FRIDAY   
April    	FRIDAY   
April    	THURSDAY 
April    	THURSDAY 
April    	MONDAY   


SELECT FIRST_NAME, SALARY, commission_pct
FROM employees
ORDER BY COMMISSION_PCT desc;  --atentie la liniile cu null


SELECT FIRST_NAME, SALARY, commission_pct
FROM employees
ORDER BY COMMISSION_PCT asc;  --atentie la liniile cu null


h) S? se afi?eze data ?i ora curent?, pana la precizie de minut.
--de rez
select to_char(sysdate, '  dd/mm/yyyy hh24:mi') 
from dual;
i) Ce efect are comanda:  

SELECT SYSDATE  FROM EMPLOYEES;

Pentru fiecare angajat sa se scrie codul, numele si ziua din  saptamana in litere in care a fost angajat

Ordonati angajatii din firma crescator dupa anul angajarii in  firma, 
iar la egalitate de an descrescator dupa ziua din an in care au fost angajati.
--de rez



select sysdate +1, sysdate+3
from dual;

select employee_id, round(sysdate-hire_date,2) dif,
        to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') ang_hire_date
from employees
order by dif;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') ang_hire_date
from employees
where dif >10000 --ORA-00904: "DIF": invalid identifier
order by dif;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') ang_hire_date
from employees
where round(sysdate-hire_date,2) >10000 
order by dif; -- 12 rez


Sa se listeze numele si salariul angajatilor care câ?tig? mai mult de  2850 $.
--de rez


S? se afi?eze numele, job-ul ?i data la care au început lucrul 
salariatii angajati între 20 Februarie 1987 ?i 1 Mai 1989.  
Rezultatul va fi ordonat cresc?tor dup? data de început.

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-Mai-1989';

King	Steven	AD_PRES	17-JUN-87
Whalen	Jennifer	AD_ASST	17-SEP-87
alter session set nls_language=Romanian;

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-May-1989';
ORA-01843: luna nu este valida

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-Mai-1989';

alter session set nls_language=American;


S? se afi?eze numele salariatilor ?i codul departamentelor pentru
toti angajatii din departamentele 10, 30 ?i 50 în ordine alfabetic? a  numelor

select last_name, first_name,department_id
from employees
where department_id in (10,30,50)
order by 1; --52 

select last_name, first_name,department_id
from employees
where department_id =10
      or department_id =30
      or department_id =50
order by 1; --52 rez

S? se afiseze numele, job-ul si salariul pentru toti salariatii al 
caror job contine ?irul “clerk” sau “rep” si salariul nu este egal cu  
3200, 2700, 2500, 3100, 6200.


--corect
select last_name, first_name, job_id, salary
from employees
where (lower(job_id) like lower('%clerK%')
or lower(job_id) like ('%rep%'))
and salary not in (3200, 2700, 2500, 3100, 6200) ; --60 rez

select last_name, first_name, job_id, salary
from employees
where lower(job_id) like lower('%clerK%')

or 

lower(job_id) like lower('%rep%')
and salary not in (3200, 2700, 2500, 3100, 6200) ; --76 rez
-- deoarece:

select last_name, first_name, job_id, salary
from employees
where lower(job_id) like lower('%clerK%'); --45 rez
select last_name, first_name, job_id, salary
from employees
where lower(job_id) like ('%rep%')
and salary not in (3200, 2700, 2500, 3100, 6200); --31 rez


S? se afi?eze numele ?i job-ul pentru toti angajatii care nu au  manager
select last_name, first_name, job_id
from employees
where manager_id = null; --0 rez ---incorecta

select last_name, first_name, job_id
from employees
where manager_id is null; --1 rez ---corecta
King	Steven	AD_PRES


select last_name, first_name, job_id
from employees
where manager_id is not null; --106 rez ---corecta

Afisati numele, salariul si comisionul pentru toti angajatii al caror  salariu este mai mare decat comisionul (salary*commission_pct)  marit de 5 ori.






select *
from employees;

select * from Employees;

describe employees;
describe jobs;
select * from jobs;

select *
from employees;

describe employees;
describe jobs;

select employee_id
from employees; --107 rezultate


select employee_id, salary
from employees
where salary > 10000; --15 rezutate


select employee_id, salary
where salary > 10000 --nu aici --ORA-00923: FROM keyword not found where expected
from employees;

select employee_id, salary
from employees
where salary > 10000
and employee_id <150
order by salary desc; --10 rezutate

select employee_id, salary
from employees
where salary > 10000
order by salary desc; -- 15 rez

select employee_id, salary --ordoneaza dupa cea de-a doua coloana
from employees
where salary > 10000
order by 2 desc; --15 rezutate

select salary, employee_id --ordoneaza dupa cea de-a doua coloana
from employees
where salary > 10000
order by 2 desc; --15 rezutate

select employee_id, salary sal 
from employees
where salary > 10000
order by sal desc; --15 rezutate


select employee_id, salary sal 
from employees
where sal > 10000  -- ORA-00904: "SAL": invalid identifier
order by sal desc; 


--alias coloane

select job_id, min_salary, max_salary, max_salary - min_salary
from jobs; --19 rezultate

Select job_id JOBUL, min_salary, max_salary, max_salary - min_salary "calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary  calcul
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary as calcul
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary  as "Diferenta calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary  "Diferenta calcul"
from jobs; --19 rezultate

select job_id, min_salary, max_salary, max_salary - min_salary  as diferenta calcul
from jobs; --nu  --ORA-00923: FROM keyword not found where expected

select job_id, min_salary, max_salary, max_salary - min_salary  as diferenta_calcul
from jobs; --19 

select job_id Jobul_ong, min_salary "Salariul minim", max_salary, max_salary - min_salary  as diferenta_calcul
from jobs; --19 

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
order by calcul; --19 rez

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
order by 4 desc; --19 rez

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
where calcul > 6000;  --ORA-00904: "CALCUL": invalid identifier

select job_id JOBUL, min_salary, max_salary, max_salary - min_salary calcul
from jobs
where max_salary - min_salary > 6000
order by calcul desc; -- 6 rezultate

--S? se afi?eze codul angajatului, numele, codul job-ului, data  angajarii pentru toti angajatii din firma


describe employees;

select employee_id, first_name || " " || Last_name NUMEle_complet, job_id, hire_date --ORA-00904: " ": invalid identifier
from employees;

select employee_id, first_name || ' ' || Last_name NUMEle_complet, job_id, hire_date
from employees;



/*S? se afi?eze pentru fiecare angajat numele concatenat cu job_id-ul, 
separate prin virgula si spatiu, si etichetati coloana “Angajat si titlu”
*/

select  first_name || ' ' || Last_name || ', ' ||job_id "Angajat si titlu"
from employees; --107 rezultate

select  first_name || ' ' || Last_name || ', ' ||job_id "Angajat si titlu"
from employees
where salary >10000
order by salary; --15 rezultate

---S2
10. S? se listeze numele complet si salariul angaja?ilor care câ?tig? mai mult de 2850. 

select first_name || ' ' ||last_name, salary
from employees
where salary > 2850;



select 1+2
from dual; --afis val 3


select 1+2
from employees; --107 rasp

select 1+2
from jobs;  --19 rez

select sysdate
from dual; --23-FEB-22

select sysdate 
from employees;

select to_char(sysdate, 'DAY /MONTH/ YEAR')
from dual; --WEDNESDAY /02/ TWENTY TWENTY-TWO

alter session set nls_language=Romanian;

alter session set nls_language=American;

select to_char(sysdate, 'DD /MM/ YYYY')
from dual; --23 /02/ 2022

select to_char(sysdate, 'D /MM/ YYYY')
from dual; --4 /02/ 2022 --miercuri


ex - numele lunii in care a fost angajat fiecare salariat

select to_char(hire_date, 'Month'),to_char(hire_date, 'MONTH'), EMPLOYEE_ID
from employees;
--June     	JUNE     
--September	SEPTEMBER
--January  	JANUARY  

--ordonare
select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY'), employee_id
from employees
order by 1;
April    	FRIDAY   	196
April    	FRIDAY   	173
April    	THURSDAY 	177
April    	SATURDAY 	132
April    	MONDAY   	140
April    	FRIDAY   	167
April    	THURSDAY 	121

select to_char(hire_date, 'Month') luna,to_char(hire_date, 'DAY')
from employees
order by luna;

select to_char(hire_date, 'Month') ,to_char(hire_date, 'DAY')
from employees
order by to_char(hire_date, 'Month');

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY'),employee_id
from employees
order by 1 asc, 2 desc;
April    	THURSDAY 	121
April    	THURSDAY 	177
April    	SATURDAY 	132
April    	MONDAY   	140
April    	FRIDAY   	173
April    	FRIDAY   	196
April    	FRIDAY   	167

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY'),employee_id
from employees
order by 1 asc, 3 desc;

April    	FRIDAY   	196
April    	THURSDAY 	177
April    	FRIDAY   	173
April    	FRIDAY   	167
April    	MONDAY   	140
April    	SATURDAY 	132
April    	THURSDAY 	121

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY') , employee_id
           -- ,  to_char(hire_date, 'D')
from employees
order by 1 asc, to_char(hire_date, 'D') desc;

April    	SATURDAY 
April    	FRIDAY   
April    	FRIDAY   
April    	FRIDAY   
April    	THURSDAY 
April    	THURSDAY 
April    	MONDAY   


SELECT FIRST_NAME, SALARY, commission_pct
FROM employees
ORDER BY COMMISSION_PCT desc;  --atentie la liniile cu null


SELECT FIRST_NAME, SALARY, commission_pct
FROM employees
ORDER BY COMMISSION_PCT asc;  --atentie la liniile cu null


h) S? se afi?eze data ?i ora curent?, pana la precizie de minut.
--de rez

select to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS')
from dual;

i) Ce efect are comanda:  
SELECT SYSDATE 
FROM EMPLOYEES;

Pentru fiecare angajat sa se scrie codul, numele si ziua din  saptamana in litere in care a fost angajat

Ordonati angajatii din firma crescator dupa anul angajarii in  firma, 
iar la egalitate de an descrescator dupa ziua din an in care au  fost angati.
--de rez


Sa se listeze numele si salariul angajatilor care câ?tig? mai mult de  2850 $.
select first_name, last_name, salary
from employees
where salary >2850;

select sysdate +1, sysdate-1, sysdate
from dual;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') 
from employees
order by dif;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') ang_hire_date
from employees
where dif >10000 --ORA-00904: "DIF": invalid identifier
order by dif;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, '  dd/mm/yyyy hh24:mi') azi,
        to_char(hire_date, '  dd/mm/yyyy hh24:mi') ang_hire_date
from employees
where round(sysdate-hire_date,2) >10000 
order by dif; --12 rez

S? se afi?eze numele, job-ul ?i data la care au început lucrul 
salariatii angajati între  1987 ?i 1989.  
Rezultatul va fi ordonat cresc?tor dup? data de început.

select last_name, first_name, job_id, hire_date
from employees
where to_char(hire_date, 'YYYY') between 1987 and 1989;

Whalen	Jennifer	AD_ASST	17-SEP-87
King	Steven	AD_PRES	17-JUN-87
Kochhar	Neena	AD_VP	21-SEP-89

select last_name, first_name, job_id, hire_date
from employees
where extract( year from hire_date) between 1987 and 1989;

S? se afi?eze numele, job-ul ?i data la care au început lucrul 
salariatii angajati între 20 Februarie 1987 ?i 1 Mai 1989.  
Rezultatul va fi ordonat cresc?tor dup? data de început.

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-May-1989';

King	Steven	AD_PRES	17-JUN-87
Whalen	Jennifer	AD_ASST	17-SEP-87

alter session set nls_language=Romanian;

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY')
from employees
order by 1 asc, 2 desc;
Aprilie   	VINERI  
Aprilie   	VINERI  
Aprilie   	VINERI  
Aprilie   	SÂMBATA 
Aprilie   	LUNI    
Aprilie   	JOI     
Aprilie   	JOI     
August    	MIERCURI

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-May-1989';
ORA-01843: luna nu este valida

select last_name, first_name, job_id, hire_date
from employees
where hire_date between '20-Feb-1987' and '1-Mai-1989';

alter session set nls_language=American;




S? se afi?eze numele salariatilor ?i codul departamentelor pentru
toti angajatii din departamentele 10, 30 ?i 50 în ordine alfabetic? a  numelor

select last_name|| ' '|| first_name,department_id
from employees
where department_id in (10,30,50)
order by last_name; --52 ang

select last_name, first_name,department_id
from employees
where department_id =10 
        or department_id =30 
        or department_id=50
order by 1; --52 ang

S? se afiseze numele, job-ul si salariul pentru toti salariatii al 
caror job contine ?irul “clerk” sau “rep” si salariul nu este egal cu  
3200, 2700, 2500, 3100, 6200.
describe employees;
select * from employees;

select last_name, first_name, job_id, salary
from employees
where (lower(job_id) like lower('%clerK%')
or lower(job_id) like ('%rep%'))
and salary not in (3200, 2700, 2500, 3100, 6200) ; --60 rez



---NUUUUU
select last_name, first_name, job_id, salary
from employees
where lower(job_id) like lower('%clerK%')

or

lower(job_id) like ('%rep%')
and salary not in (3200, 2700, 2500, 3100, 6200) ; --76 rez
-- deoarece:

select last_name, first_name, job_id, salary
from employees
where lower(job_id) like lower('%clerK%'); --45 rez

select last_name, first_name, job_id, salary
from employees
where lower(job_id) like ('%rep%')
and salary not in (3200, 2700, 2500, 3100, 6200); --31 rez


S? se afi?eze numele ?i job-ul pentru toti angajatii care nu au  manager
describe employees;
--nu
select last_name, first_name, job_id
from employees
where manager_id = null;


select last_name, first_name, job_id
from employees
where manager_id is null;
--King	Steven	AD_PRES

--angajatii care au manageri
select last_name, first_name, job_id
from employees
where manager_id is not null; --106  ang

Afisati numele, salariul si comisionul pentru toti angajatii al caror  
salariu este mai mare decat comisionul (salary*commission_pct)  marit de 5 ori.

select last_name, salary, commission_pct
from employees
where salary > commission_pct*salary *5; --11 rez




select last_name, salary, commission_pct
from employees
where salary < commission_pct*salary *5000;


select last_name, salary, commission_pct, commission_pct*salary
from employees;

select last_name, salary, commission_pct, nvl(commission_pct,0)*salary
from employees;



Afisati numele, salariul si comisionul pentru toti angajatii al caror  
salariu este MAI MIC  decat comisionul (salary*commission_pct)   
adunat la salariul marit de 10 ori.
--Atentie!!!!
select last_name, salary, commission_pct
from employees
where salary < commission_pct*salary +salary*10;--35 rez

select last_name, salary, commission_pct
from employees
where  commission_pct is not null; --35 rez


--corect
select last_name, salary, nvl(commission_pct, 0)
from employees
where salary < nvl(commission_pct,0)*salary +salary*10; --107 rez






















