--LAB 11 CONTINUARE

--21. Sã se afiºeze codul, numele departamentului ºi suma salariilor pe departamente. -(lab6.pdf)

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME, SUM(E.SALARY)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME;--11 rez

--care este cea mai mica suma a salariilor pe departamente?

SELECT min( SUM(E.SALARY))
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME; --4400

--Sã se afiºeze codul, numele departamentului pentru departamentul care are cea mai mica suma a salariilor pe departament.

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME, SUM(E.SALARY)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
having SUM(E.SALARY) = (SELECT min( SUM(E.SALARY))
                        FROM EMPLOYEES E,DEPARTMENTS D
                        WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                        GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME);
                        --10	Administration	4400

--lab7.pdf

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME, SUM(E.SALARY), count(*)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
order by 2;


60	IT	              28800	5
20	Marketing       	19000	2
70	Public Relations	10000	1
30	Purchasing	      24900	6

1. Sã se afiºeze codurile departamentelor, codurile job-urilor ?i o coloanã reprezentând 
suma salariilor pe departamente ºi, în cadrul acestora, pe job-uri.

SELECT D.DEPARTMENT_NAME, SUM(E.SALARY), count(*), job_id
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, job_id
order by 1;
IT	              28800	5 IT_PROG
Marketing	        13000	1 MK_MAN
Marketing	        6000	1 MK_REP
Public Relations	10000	1 PR_REP
Purchasing	      13900	5 PU_CLERK
Purchasing	      11000	1 PU_MAN

SELECT D.DEPARTMENT_NAME, SUM(E.SALARY), count(*), job_id
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY  job_id, D.DEPARTMENT_NAME -- nu exista angajati cu acelasi job, dar care sa lucreze in departamente diferite
order by 4;















---Saptamana 11 --L7.pdf
4. Sã se afi?eze codul, numele departamentului ?i numãrul de angaja?i 
care lucreazã în acel departament pentru:
a) departamentele în care lucreazã mai pu?in de 4 angaja?i;
b) departamentul care are numãrul maxim de angaja?i.




a)
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, count(*)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID =D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
HAVING COUNT(*) <4;
20	Marketing	2
110	Accounting	2
40	Human Resources	1
90	Executive	3
10	Administration	1
70	Public Relations	1

--afisam si departamentele cu 0 ang
SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, count(employee_id)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID(+) =D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
HAVING COUNT(*) <4; --22 rez

select D.DEPARTMENT_ID, D.DEPARTMENT_NAME,( Select count(employee_id)
                                            from employees e
                                            where e.department_id = d.department_id) as nr_ang
from departments d;
--where nr_ang <4; --nu

select aux.DEPARTMENT_ID, aux.DEPARTMENT_NAME, aux.nr_ang
from ( select D.DEPARTMENT_ID, D.DEPARTMENT_NAME,( Select count(employee_id)
                                            from employees e
                                            where e.department_id = d.department_id) as nr_ang
    from departments d) aux
where nr_ang<4; --22 rez


with 
aux as ( select D.DEPARTMENT_ID, D.DEPARTMENT_NAME,( Select count(employee_id)
                                            from employees e
                                            where e.department_id = d.department_id) as nr_ang
    from departments d)
select *
from aux
where aux.nr_ang<4;

b) departamentul care are numãrul maxim de angaja?i.

SELECT  D.DEPARTMENT_ID, D.DEPARTMENT_NAME, count(*)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
HAVING COUNT(*) = (SELECT MAX(count(*))  --subcererea returneaza nr maxim de angajati (per departamente)
                    FROM EMPLOYEES E,DEPARTMENTS D
                    WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                    GROUP BY  D.DEPARTMENT_ID); 
                    --50	Shipping	45
                    
--salariatii care lucreaza in departamentul care are numãrul maxim de angaja?i.

SELECT E.*
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID IN
                      (SELECT  D.DEPARTMENT_ID
                      FROM EMPLOYEES E,DEPARTMENTS D
                      WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                      GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
                      HAVING COUNT(*) = (SELECT max(count(*))
                                          FROM EMPLOYEES E,DEPARTMENTS D
                                          WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                                          GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID)); --45 ang

--salariatii care lucreaza in departamentul care are numãrul minim de angaja?i.
SELECT E.*
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID in --- daca avem = in loc de IN => ORA-01427: single-row subquery returns more than one row
                      (SELECT  D.DEPARTMENT_ID  -- departamentele cu nr minim de angajati
                      FROM EMPLOYEES E,DEPARTMENTS D
                      WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                      GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
                      HAVING COUNT(*) = (SELECT MIN(count(*))
                                          FROM EMPLOYEES E,DEPARTMENTS D
                                          WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                                          GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID));
200	Jennifer	Whalen	JWHALEN	515.123.4444	17-SEP-87	AD_ASST	4400		101	10
203	Susan	Mavris	SMAVRIS	515.123.7777	07-JUN-94	HR_REP	6500		101	40
204	Hermann	Baer	HBAER	515.123.8888	07-JUN-94	PR_REP	10000		101	70                                         
                                          
5. Sã se afi?eze salaria?ii care au fost angaja?i în aceeaºi zi
a lunii (ca numãr al zilei în lunã) în care cei mai mul?i dintre salaria?i au fost angaja?i. 

SELECT TO_CHAR(HIRE_DATE, 'DD'), count(*)  --nr de salariati angajati in fiecare zi
FROM EMPLOYEES 
GROUP BY TO_CHAR(HIRE_DATE, 'DD')
order by 1;

--nr maxim de salariati angajati in fiecare zi (luati maximul pt rezultatele de mai sus)

SELECT max(count(*))  
FROM EMPLOYEES 
GROUP BY TO_CHAR(HIRE_DATE, 'DD'); -- un rezultat: 12 ang

SELECT TO_CHAR(HIRE_DATE, 'DD') Ziua, count(*) nr_ang  --ZIUA CAND AU FOST ANGAJATI CEI MAI MULTI SALARIATI
FROM EMPLOYEES 
GROUP BY TO_CHAR(HIRE_DATE, 'DD')
HAVING COUNT(*) = ( SELECT MAX( COUNT(*))
                    FROM EMPLOYEES 
                    GROUP BY TO_CHAR(HIRE_DATE, 'DD'));
                    -- ziua 24	12 salariat
--atentie!!!   --nu                 
SELECT to_char(hire_date,'dd'), count(*), hire_date
FROM EMPLOYEES
GROUP BY hire_date
HAVING count(hire_date) = (SELECT max(count(hire_date))
                            FROM EMPLOYEES
                            GROUP BY hire_date); -- 07	4  07-06-1994
                            
SELECT to_char(hire_date,'dd'), count(*), hire_date
FROM EMPLOYEES
GROUP BY hire_date;                            


--rezolvare:
SELECT * 
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'DD') IN (SELECT TO_CHAR(HIRE_DATE, 'DD')  --ZIUA CAND AU FOST ANGAJATI CEI MAI MULTI SALARIATI 
                                  FROM EMPLOYEES                      -- ZIUA 24
                                  GROUP BY TO_CHAR(HIRE_DATE, 'DD')
                                  HAVING COUNT(*) = ( SELECT MAX( COUNT(*))
                                                      FROM EMPLOYEES 
                                                      GROUP BY TO_CHAR(HIRE_DATE, 'DD'))); --12 REZ                   

SELECT * 
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'DD') IN (SELECT TO_CHAR(HIRE_DATE, 'DD')  --ZIUA CAND AU FOST ANGAJATI CEI MAI PUTINI SALARIATI 
                                  FROM EMPLOYEES                      --08 ,25, 27
                                  GROUP BY TO_CHAR(HIRE_DATE, 'DD')
                                  HAVING COUNT(*) = ( SELECT MIN( COUNT(*))
                                                      FROM EMPLOYEES 
                                                      GROUP BY TO_CHAR(HIRE_DATE, 'DD')));
                                                      --3 rez
select min(salary)
from employees;

select min(salary)
from employees
group by job_id;

IV. [Exerciþii – subcereri nesincronizate în clauza FROM]
Subcererile pot apãrea în clauzele SELECT, WHERE, FROM, HAVING ale unei cereri.
O subcerere care apare în clauza FROM se mai numeºte view (vizualizare) in-line.
Ce obiecte au apãrut pânã acum în clauza FROM? 
– Tabelele = obiectele care stocheazã efectiv datele. 
Pe lângã acestea, putem specifica în FROM tabelele virtuale (vizualizãrile).

14. Sã se afiºeze codul, numele departamentului ºi suma salariilor pe departamente.

SELECT department_id ,SUM(salary) suma 
FROM employees
GROUP BY department_id;

SELECT d.department_id, d.department_name, a.suma  -- sau a.department_id in loc de d.department_id
FROM departments d, (SELECT department_id ,SUM(salary) suma 
                      FROM employees
                      GROUP BY department_id) a 
WHERE d.department_id = a.department_id; --11 rez

--afisati si dept fara angajati

SELECT d.department_id, d.department_name, nvl(a.suma, 0)
FROM departments d, (SELECT department_id ,SUM(salary) suma 
                      FROM employees
                      GROUP BY department_id) a 
WHERE d.department_id = a.department_id(+); --27 rez

15. Utilizând subcereri, sã se afiºeze titlul job-ului, salariul mediu corespunzãtor (media aritmentica dintre
min_salary si max_salary) si diferen?a dintre media limitelor (min_salary, max_salary) ?i media realã.
insert into jobs values( 'RLX', 'Relax', 15000, 30000);
commit;

--vrem informatii despre toate job-urile din tabela de jobs
select j.job_id, job_title, (min_salary+max_salary)/2, max_salary - min_salary, 
       nvl(to_char(aux.media_reala), 'nu lucreaza nimeni')
from jobs j, (select job_id, avg(salary) media_reala  -- aux are 19 rezultate
              from employees
              group by job_id) aux
where j.job_id = aux.job_id(+);     --afisam info si despre job-urile pe care nu lucreaza nimeni     
--20 rez

16. Modificaþi cererea anterioarã, pentru a determina ºi listarea 
numãrului de angajaþi corespunzãtori fiecãrui job.

select job_title, (min_salary+max_salary)/2, max_salary - min_salary, 
       nvl(to_char(aux.media_reala), 'nu lucreaza nimeni'), nvl(aux.nr_ang,0)
from jobs j, (select job_id, avg(salary) media_reala, count(*) nr_ang
              from employees
              group by job_id
              ) aux
where j.job_id = aux.job_id(+);     --afisam info si depre job-urile pe care nu lucreaza nimeni  

drop table employees;

17. Pentru fiecare departament, sã se afiºeze denumirea acestuia, 
precum ?i numele si salariul celor mai slab plãtiþi angajaþi din cadrul sãu.

select e.last_name, e.salary, d.department_name, sal_min
from (select department_id, min(salary) sal_min
      from employees
      group by department_id) aux, 
      employees e, departments d
where e.department_id = aux.department_id 
and d.department_id = aux.department_id 
and e.salary = aux.sal_min; --12 rez

select e.last_name, e.salary,e.department_id, department_name, aux.*
from employees e, departments d, (select department_id , min(salary) sal_min
                                  from employees
                                  group by department_id) aux
where e.department_id = d.department_id
and e.department_id = aux.department_id
and e.salary = aux.sal_min; --12 rez

select min_sal.department_id,min_sal.department_name, e.last_name, e.salary
from employees e, (select d.department_id, d.department_name, min(e.salary) minimul
                                  from employees e, departments d
                                  where d.department_id = e.department_id
                                  group by d.department_id, d.department_name) min_sal
where e.department_id = min_sal.department_id
and e.salary = min_sal.minimul;

select d.department_name, e.name, e.salary 
from departments d,(select first_name || ' ' || last_name name, salary, department_id
                    from employees e1
                    where e1.salary = (select min(salary)--subcerere corelata
                                    from employees e2
                                    where e2.department_id = e1.department_id)
                    ) e
where d.department_id = e.department_id;
--echivalent cu:
select first_name || ' ' || last_name name, salary, e1.department_id, d.department_name
from employees e1, departments d
where e1.department_id = d.department_id
and e1.salary = (select min(salary)--subcerere corelata
                from employees e2
                where e2.department_id = e1.department_id);


select e.last_name, e.salary, d.department_name
from employees e
inner join
        (select e.department_id, min(e.salary) "min_salary"
        from employees e
        group by e.department_id) aux
    on e.department_id = aux.department_id and
       e.salary = aux.min_salary
inner join departments d
    on e.department_id = d.department_id; --ORA-00904: "AUX"."MIN_SALARY": identificator nevalid
select e.last_name, e.salary, d.department_name
from employees e
inner join
        (select e.department_id, min(e.salary) min_salary
        from employees e
        group by e.department_id) aux
    on e.department_id = aux.department_id and
       e.salary = aux.min_salary
inner join departments d
    on e.department_id = d.department_id;
    
    
--sa includem si departamentele pe care nu lucreaza nimeni
select e.last_name, e.salary, d.department_name
from (select department_id, min(salary) sal_min
      from employees
      group by department_id) aux, 
      employees e, departments d
where e.department_id(+) = aux.department_id 
and d.department_id = aux.department_id (+) 
and e.salary(+) = aux.sal_min;
    
    
--Din lab 8.pdf

3.	Sã se afi?eze numele ?i salariul celor mai pu?in plãti?i angaja?i din fiecare departament 
(3 solu?ii: cu ?i fãrã sincronizare, subcerere în clauza FROM).

I - cu sincoronizare:

select e.last_name, e.salary, d.department_name
from employees e, departments d
where e.department_id = d.department_id 
and  e.salary  = (select min(salary) sal_min
                  from employees
                  where department_id = e.department_id ); --12 rez


                    

II - fara sincronizare

--care este cel mai mic salariu pt fiecare departament?
select department_id, min(salary) sal_min
from employees
group by department_id;

select e.last_name, e.salary, d.department_name
from employees e, departments d
where e.department_id = d.department_id 
and (e.department_id, e.salary ) in  (select department_id, min(salary) sal_min
                                      from employees
                                      group by department_id); --12 rez

--nuuuu                                       
 select e1.last_name, e1.first_name, e1.salary, e1.department_id, 
                  (select min(e2.salary)
                    from employees e2
                    where e1.department_id = e2.department_id) sal_minim_din_Dept
from employees e1
where ( e1.salary) IN (select  min(e2.salary)
                      from employees e2
                      group by e2.department_id);
Popp	6900	Finance
Colmenares	2500	Purchasing
De Haan	17000	Executive
Kochhar	17000	Executive                                      

III- Subcerere in clauza FROM
select e.last_name, e.salary
from employees e, (select min(salary) as sal, department_id
                  from employees
                  group by department_id )aux
where aux.sal = e.salary 
and e.department_id = aux.department_id;

--------------------

12.	 Scrie?i o cerere pentru a afi?a job-ul, salariul total pentru job-ul 
respectiv pe departamente si salariul total pentru job-ul respectiv pe 
departamentele 30, 50, 80. Se vor eticheta coloanele corespunz?tor. 
Rezultatul va ap?rea sub forma de mai jos:

Job       Dep30		 Dep50  	Dep80		 Total
------------------------------------------------------------------------------
……………………………………………………………………
……………………………………………………………………
select job_id, sum(salary)
FROM employees
GROUP BY job_id;

SELECT job_id, NVL(SUM(DECODE(department_id, 30, salary)),0) Dep30,
NVL(SUM(DECODE(department_id, 50, salary)),0) Dep50,
NVL(SUM(DECODE(department_id, 80, salary)),0) Dep80,
NVL(SUM(salary),0) Total
FROM employees
GROUP BY job_id
order by 1;
--SA_REP	0	0	243500	250500  --7000 sal angajatului cu dept_id = null
select department_id, sum(salary)
from employees e
where job_id ='SA_REP'
group by department_id;
null   7000
80	   243500

Select last_name, salary, department_id
from employees e
where job_id ='SA_REP'
order by department_id;

Metoda 2: (cu cereri corelate în clauza SELECT)
SELECT job_id, (SELECT NVL(SUM(salary),0)
                FROM employees
           		   WHERE department_id = 30
                AND job_id = e.job_id) Dep30,
(SELECT NVL(SUM(salary),0)
FROM employees
WHERE department_id = 50
AND job_id = e.job_id) Dep50,
(SELECT NVL(SUM(salary),0)
FROM employees
WHERE department_id = 80
AND job_id = e.job_id) Dep80,
NVL(SUM(salary),0) Total
FROM employees e
GROUP BY job_id;



--11.	 S? se creeze o cerere prin care s? se afi?eze num?rul total de angaja?i ?i,
--din acest total, num?rul celor care au fost angaja?i în 1997, 1998, 1999 
--si 2000. Denumiti capetele de tabel in mod corespunzator.
--(Ambele metode ca la exerci?iul anterior)
SELECT COUNT(*) TOTAL,
SUM(DECODE(TO_CHAR(hire_date,'yyyy'),1997,1,0)) "AN 1997",
SUM(DECODE(TO_CHAR(hire_date,'yyyy'),1998,1,0)) "AN 1998",
SUM(DECODE(TO_CHAR(hire_date,'yyyy'),1999,1,0)) "AN 1999",
SUM(DECODE(TO_CHAR(hire_date,'yyyy'),2000,1,0)) "AN 2000"
FROM employees;
--107	28	23	18	11
  
SELECT (Select count(*) from employees),
(SELECT count(*)
                  FROM employees
           		   WHERE TO_CHAR(hire_date,'yyyy')= 1997)  "AN 1997",
(SELECT count(*)
                  FROM employees
           		   WHERE TO_CHAR(hire_date,'yyyy')= 1998)  "AN 1998",
(SELECT count(*)
                  FROM employees
           		   WHERE TO_CHAR(hire_date,'yyyy')= 1999)  "AN 1999",
(SELECT count(*)
                  FROM employees
           		   WHERE TO_CHAR(hire_date,'yyyy')= 2000)  "AN 2000"
FROM dual;
