--Lab 9 + Lab 10
--Subcerei necorelate + corelate

1. Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii care 
au fost angaja?i dup? Gates.
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date --11-07-1998
                    FROM employees
                    WHERE INITCAP(last_name)='Gates')
order by 2; --34 rez
--1". Folosind subcereri, s? se afi?eze numele ?i data angaj?rii pentru salaria?ii 
--care au fost angaja?i dup? Gates 
--si au salariul mai mare decat el.

SELECT last_name, hire_date, salary
FROM employees
WHERE hire_date > (SELECT hire_date
                    FROM employees
                    WHERE INITCAP(last_name)='Gates')
and salary > ( SELECT salary --2900
                    FROM employees
                    WHERE INITCAP(last_name)='Gates') 
order by 3,2;  --19 rez   

SELECT last_name, hire_date
FROM employees
WHERE (hire_date, salary) IN (SELECT hire_date, salary
                              FROM employees
                              WHERE INITCAP(last_name)='Gates');   
                              
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
                    FROM employees
                    WHERE INITCAP(last_name)='King');
                    --ORA-01427: o subinterogare de o singura linie returneaza mai mult decât o linie                         
                              
--avem 2 King
17-06-1987
30-01-1996
                              
SELECT last_name, hire_date
FROM employees
WHERE hire_date >any (SELECT hire_date  --mai mare ca minimul
                      FROM employees
                      WHERE INITCAP(last_name)='King')
order by hire_date;   
Whalen	17-09-1987
Kochhar	21-09-1989
Hunold	03-01-1990
Ernst	21-05-1991
De Haan	13-01-1993
Mavris	07-06-1994
Higgins	07-06-1994

SELECT last_name, hire_date
FROM employees
WHERE hire_date >all (SELECT hire_date  --mai mare ca maximul
                    FROM employees
                    WHERE INITCAP(last_name)='King')
order by hire_date; 

Bell	04-02-1996
Hartstein	17-02-1996
Sully	04-03-1996
Abel	11-05-1996
Mallin	14-06-1996
Weiss	18-07-1996
McEwen	01-08-1996
Russell	01-10-1996
Partners	05-01-1997
Davies	29-01-1997

Daca subcererea intoarce o multime de valori, se va folosi in cererea
parinte unul din operatorii IN, NOT IN, ANY, ALL.
WHERE col1 = ANY (SELECT …)  == WHERE col1 IN (SELECT …)
WHERE col1 > ANY (SELECT …) ==  mai mare ca minimul;
WHERE col1 < ANY (SELECT …) == mai mic ca maximul;
WHERE col1 > ALL (SELECT …) == mai mare ca maximul;
WHERE col1 < ALL (SELECT …) == mai mic ca minimul;
WHERE col 1 != ALL (SELECT …)  == WHERE col1 NOT IN (SELECT …)

2. Folosind subcereri, scrie?i o cerere pentru a afi?a numele 
?i salariul pentru to?i colegii (din acela?i departament)
lui Gates. Se va exclude Gates.

SELECT last_name, salary
FROM employees
WHERE department_id In (SELECT department_id -- = 
                        FROM employees
                        WHERE LOWER(last_name)='gates')
AND LOWER(last_name) <> 'gates';  --44 rez

SELECT last_name, salary
FROM employees
WHERE department_id = (SELECT department_id 
                        FROM employees
                        WHERE LOWER(last_name)='gates')
AND LOWER(last_name) <> 'gates';  --44 rez

--King

SELECT last_name, salary, department_id
FROM employees
WHERE department_id In (SELECT department_id  -- nu merege pt =
                        FROM employees
                        WHERE LOWER(last_name)='king')
AND LOWER(last_name) <> 'king';

--incorect
SELECT last_name, salary, department_id
FROM employees
WHERE department_id = (SELECT department_id  -- nu merege pt =
                        FROM employees
                        WHERE LOWER(last_name)='king')
AND LOWER(last_name) <> 'king';
--ORA-01427: o subinterogare de o singura linie returneaza mai mult decât o linie

3.. Folosind subcereri, s? se afi?eze numele ?i salariul angaja?ilor condu?i direct de pre?edintele 
companiei (acesta este considerat angajatul care nu are manager).

3" Afisati denumirile departamentor in care lucreaza angajati care contin litera 't' in nume.
(v1:join
v2:subcerere necorelate) --7 rez

--rezolvare pt 3
select last_name, salary
from employees
where manager_id = (select employee_id
                      from employees
                      where manager_id is null); --14 rez
                      
select last_name, salary
from employees
where manager_id in (select employee_id
                      from employees
                      where manager_id is null); --14 rez                      

--4. Scrie?i o cerere pentru a afi?a numele, codul departamentului ?i salariul angaja?ilor 
--al c?ror cod de departament ?i salariu coincid cu codul departamentului ?i salariul
--unui angajat care câ?tig? comision.

SELECT department_id, salary 
FROM employees 
WHERE commission_pct IS NOT NULL ; -- 35 rez

SELECT last_name, department_id, salary
FROM employees 
WHERE (department_id, salary) IN ( SELECT department_id, salary 
                                    FROM employees 
                                    WHERE commission_pct IS NOT NULL ); --34 REZ    
                                    
--atentie
SELECT last_name, department_id, salary
FROM employees 
WHERE department_id IN ( SELECT department_id
                        FROM employees 
                        WHERE commission_pct IS NOT NULL )
or salary in (SELECT salary
                FROM employees 
                WHERE commission_pct IS NOT NULL )
                order by salary; --42 REZ                                      
                                    
                                    
5. s? se afi?eze codul, numele ?i salariul tuturor angaja?ilor care ca?tig? mai mult 
decât salariul mediu pentru job-ul corespunz?tor ?i lucreaz? într-un departament cu cel pu?in unul 
dintre angaja?ii al c?ror nume con?ine litera “t”. Vom considera salariul mediu al unui job ca fiind egal 
cu media aritmetic? a limitelor sale admise 
(specificate în coloanele min_salary, max_salary din tabelul JOBS).

SELECT  e.employee_id,e.last_name,e.salary 
FROM employees e 
WHERE e.salary > ( SELECT (j.min_salary+j.max_salary)/2  --angaja?ilor care ca?tig? mai mult decât salariul mediu pentru job-ul corespunz?tor
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' ); --24 rez
                          
                          
--fara cerere corelata
SELECT (j.min_salary+j.max_salary)/2 , job_id
FROM jobs j
order by 2;  --pt fiacre job am calculat media salariilor
7000	IT_PROG
6600	FI_ACCOUNT
15000	SA_MAN
9000	SA_REP
4000	SH_CLERK
3500	ST_CLERK

SELECT  e.employee_id,e.last_name,e.salary, e.job_id
FROM employees e 
WHERE (e.salary ,e.job_id) in ( SELECT (j.min_salary+j.max_salary)/2, job_id
                                from jobs j )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' );

192	Bell	4000	SH_CLERK
141	Rajs	3500	ST_CLERK
158	McEwen	9000	SA_REP
152	Hall	9000	SA_REP


--atentie
SELECT  e.employee_id,e.last_name,e.salary, e.job_id
FROM employees e 
WHERE e.salary in ( SELECT (j.min_salary+j.max_salary)/2
                                from jobs j )
AND e.department_id IN ( SELECT distinct department_id
                          FROM employees 
                          WHERE  LOWER(last_name) LIKE '%t%' );
103	Hunold	9000	IT_PROG
109	Faviet	9000	FI_ACCOUNT  

SELECT e.employee_id,e.last_name,e.salary 
FROM employees e 
WHERE e.salary > ( SELECT (j.min_salary+j.max_salary)/2 
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
AND e.job_id IN ( SELECT job_id     
                  FROM employees m 
                  WHERE e.department_id=m.department_id 
                  AND LOWER(m.last_name) LIKE '%t%' ); --21 rez

 -- lucreaza pe acelasi job ca si colegii de departament care contin litera t                  
                  
6. Scrieti o cerere pentru a afi?a angaja?ii care câ?tig? mai mult decât oricare func?ionar 
(job-ul con?ine ?irul “CLERK”). Sorta?i rezultatele dupa salariu, în ordine descresc?toare.
Ce rezultat este returnat dac? se înlocuie?te “ALL” cu “ANY”?
SELECT * 
FROM employees e 
WHERE salary > ALL ( SELECT salary  ---mai mare ca maximul
                    FROM employees 
                    WHERE upper(job_id) LIKE '%CLERK%' )
order by salary;     ---4400 .... 24000               


sELECT salary 
FROM employees 
WHERE upper(job_id) LIKE '%CLERK%'
order by 1; --2100.....4200

SELECT * 
FROM employees e 
WHERE salary > any ( SELECT salary  ---mai mare ca minimul
                    FROM employees 
                    WHERE upper(job_id) LIKE '%CLERK%' )
order by salary; --2200 -24000
--106 rez

7. Scrie?i o cerere pentru a afi?a numele, numele departamentului ?i salariul angaja?ilor 
care nu câ?tig? comision, dar al c?ror ?ef direct câ?tig? comision

select last_name, first_name, department_name, commission_pct
from employees e, departments d
where e.department_id = d.department_id
--and e.commission_pct is null
and e.manager_id in (select employee_id
                     from employees
                     where commission_pct is not null);

7". Scrie?i o cerere pentru a afi?a numele, numele departamentului ?i salariul angaja?ilor 
care au salariu mai mare decât salariul mediu pentru job-ul corespunz?tor , 
dar al c?ror ?ef direct câ?tig? comision.   

select last_name, first_name, department_name, commission_pct
from employees e, departments d
where e.department_id = d.department_id
and e.salary > ( SELECT (j.min_salary+j.max_salary)/2 
                  FROM jobs j 
                  WHERE j.job_id=e.job_id )
and e.manager_id in (select employee_id
                     from employees
                     where commission_pct is not null);

---lab 9 finish


--Care este salariul minim din firma?
select min(salary) --2100
from employees;

--Care este salariatul cu salariul minim?
select *
from employees
where salary = (select min(salary) --2100
                from employees);
                --132	TJ	Olson	TJOLSON	650.124.8234	10-04-1999	ST_CLERK	2100		121	50
??? 
de ce nu merge:
select last_name,  min(salary)  ----Care este salariatul cu salariul minim?
from employees;
--ORA-00937: nu exista o functie de grupare de tip grup singular
--Aflam spre finalul lab acesta

7.. Scrie?i o cerere pentru a afi?a numele salariatului, numele departamentului ?i salariul angaja?ilor 
care câ?tig? comision,dar al c?ror ?ef direct nu câ?tig? comision.(modificata)

select e.last_name, d.department_name, e.salary
from employees e, departments d
where e.department_id = d.department_id(+) -- ca sa tinem cont si de cei care nu au setat departamentul
and e.commission_pct is not null 
and e.manager_id in (select a.employee_id  -- al c?ror ?ef direct nu câ?tig? comision
                      from employees a 
                      where a.commission_pct is null);

---GRUPARE --lab 10

--salariul maxim din toata firma
select max(salary)
from employees; --24000

select salary
from employees
order by 1 desc;

--salariul maxim din fiecare departament
select department_id, max(salary)
from employees
group by department_id; --12 rez

100	12000
30	11000
null 7000
90	24000
20	13000
70	10000
110	12000
50	8200
80	14000
40	6500
60	9000
10	4400

select salary
from employees
where department_id =60
order by 1; --5 rez
4200
4800
4800
6000
9000

--care este angajatul/angajatii cu acest salariu maxim din fiecare departament?
--atentie, nu aceasta este rezolvarea!!!!!!!!
select department_id, max(salary), employee_id
from employees
group by department_id;
--ORA-00979: nu este o expresie GROUP BY

--incorect
select department_id, max(salary), employee_id
from employees
group by department_id, employee_id ---se divide in 107 grupuri
order by 1,3; --107 rez

--R: v1 --subcerere necorelata
select employee_id, last_name , department_id, salary
from employees
where (department_id, salary) in (select department_id, max(salary)
                                    from employees
                                    group by department_id)
order by department_id; --11 rez

--R: v2 -- subcerere corelata
select e.employee_id, e.last_name , e.department_id, e.salary
from employees e  -- linie candidat e.....
where e.salary = (select max(salary)  -- calculam salariul maxim pentru linia candidat
                  from employees b
                  where b.department_id = e.department_id
                  --fara clauza de GROUP BY!!!!!!
                 )
order by department_id; --11 rez

--R: v3 -- SELECT folosit in clauza FROM
select employee_id, last_name , department_id, salary, sal_max
from employees e, (select department_id dept_id, max(salary) sal_max
                  from employees
                  group by department_id) dept_sal  --tabela
where e.department_id = dept_sal.dept_id
and e.salary = dept_sal.sal_max
order by department_id; --11 rez

--cati angajati se gasesc in firma
select count(*)
from employees; --107 rez

--cati salariati sunt angajati in fiecare departament
select count(*) nr_ang_dept, department_id
from employees
group by department_id;
6	100
6	30
1	null  !!!!!!
3	90
2	20
1	70
2	110
45	50
34	80
1	40
5	60
1	10

select count(department_id), department_id --nu ia in considereare valori null
from employees
group by department_id;
6	100
6	30
0	null !!!!!
3	90
2	20

select department_id, employee_id, last_name
from employees
where department_id  is null;
--null 	178	Grant

select count(employee_id), department_id
from employees
group by department_id;

6	100
6	30
1	null  !!!!!
3	90
2	20

select count(employee_id), count(commission_pct)
from employees;
--107	35
-- => 35 de angajati au comisioanele setate

-- Sa se afiseze valoarea medie a comisionului in firma
---pt valoarea media doar a comisioanelor setate
CORECT:
SELECT AVG(commission_pct) as MEDIE
FROM employees; --0,2228571428571428571428571428571428571429

SELECT SUM(commission_pct)/COUNT(commission_pct) as "MEDIE", COUNT(commission_pct)
FROM employees; --0,2228571428571428571428571428571428571429 , 35

INCORECT ( de ce? ) :
SELECT SUM(commission_pct)/COUNT(*) as "MEDIE GRESITA", count(*)
FROM employees; --0,072897196261682242990654205607476635514 , 107

--Sa scriem o cerere pentru a afisa pentru fiecare job titlul,
--codul si valorile comisioanelor nenule ale angajatilor ce-l
--practica. Se vor afisa si comisioanele angajatilor pentru care nu
--se cunoaste jobul, dar care au comision.
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, e.commission_pct
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--ORDER BY j.job_id,e.commission_pct; --35 rez
--
--Sa se afiseze valoarea medie a comisioanelor cunoscute la nivel de job
--= media comisioanelor pt fiecare job(la care lucreaza angajati ce au comisionul setat)
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id; --ORA-00979: nu este o expresie GROUP BY
--
--
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id, j.job_title;
----Sales Representative	SA_REP	0,21
----Sales Manager	SA_MAN	0,3
--!!!!!!
--Toate coloanele si expresiile de proiectie (din SELECT)
--care NU sunt functii de grup TREBUIE scrise in GROUP BY !!!
--
----job-urile care au media comisioanelor mai mare de 0.25
--!!!!!!!NUUUUUUUUUUUUUUUUUU
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--and avg( e.commission_pct)>0.25  --ORA-00934: functia de grupare nu este permisa aici
--group BY j.job_id, j.job_title;
--
----job-urile care au media comisioanelor mai mare de 0.25
--SELECT NVL(j.job_title,'Necunoscut') AS "JOBUL", j.job_id, avg( e.commission_pct)
--FROM employees e, jobs j
--WHERE e.job_id=j.job_id(+)
--AND e.commission_pct IS NOT NULL
--group BY j.job_id, j.job_title
--having avg( e.commission_pct)>0.25;
----Sales Manager	SA_MAN	0,3

11. S? se afi?eze cel mai mare salariu, cel mai mic salariu, suma ?i 
media salariilor tuturor angaja?ilor. 
Eticheta?i coloanele Maxim, Minim, Suma, respectiv Media. S? se rotunjeasc? rezultatele.

select max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA,
      floor(avg(salary)) med
from employees;
--24000	2100	691400	6462	6461

12. S? se afi?eze minimul, maximul, suma ?i media salariilor pentru fiecare job.

select job_id, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees
group by job_id; --19 rez

--atentie
--afisati si titlul job-ului
select e.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, 
        round(avg(salary)) MEDIA,  count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id; --ORA-00979: nu este o expresie GROUP BY


--corect
select e.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title;
--fiecarui job_id ii corespunde un job_title
--19 rez
IT_PROG	Programmer	            9000	4200	28800	5760	5
SA_REP	Sales Representative	11500	6100	250500	8350	30

--atentie
select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title; --j.job_id din select face probleme
--ORA-00979: nu este o expresie GROUP BY

--corect
select j.job_id, job_title, max(salary) Maxim, min(salary) MINIM, sum(salary) TOTAL, round(avg(salary)) MEDIA, 
        count(employee_id) NR_ang
from employees e, jobs j
where e.job_id = j.job_id
group by j.job_id, job_title; --j.job_id 


13. S? se afi?eze num?rul de angaja?i pentru fiecare job.

select job_id, count(*)
from employees
group by job_id
order by 2; --19 rez

ST_MAN	5
IT_PROG	5
ST_CLERK	20
SH_CLERK	20
SA_REP	30

select job_id, count(employee_id)
from employees
group by job_id
order by 2;

select e.job_id, job_title, count(employee_id)
from employees e, jobs j
where e.job_id = j.job_id
group by e.job_id, job_title
order by 3;

--atentie
select * from employees where department_id is null;
--178	Kimberely	Grant	KGRANT	011.44.1644.429263	24-05-1999	SA_REP
--nu
select job_id, count(department_id)
from employees
group by job_id
order by 2;
ST_MAN	5
IT_PROG	5
ST_CLERK	20
SH_CLERK	20
SA_REP	29  --- deoarece dept_id lui Kimberely	Grant este null

14. S? se determine num?rul de angaja?i care sunt ?efi. Eticheta?i coloana “Nr. manageri”.
Observa?ie: Este necesar cuvântul cheie DISTINCT. Ce ob?inem dac? îl omitem?

select employee_id, manager_id
from employees;

--lista a managerilor din firma
select distinct manager_id
from employees
where manager_id is not null
order by 1; --18 rez

--lista sefilor angajatilor (inclusiv manager_id null)
select distinct manager_id
from employees; --19 (deoarece nu l am exclus pe cel cu null(manager_id pt Steven King = null))

--R:
select count(distinct manager_id)  --nu ia in considerrare valorile de null
from employees; --18 sefi

--R:
select count(distinct manager_id)
from employees
where manager_id is not null; --nu este obligatoriu nevoie de cluaza de where

15. S? se afi?eze diferen?a dintre cel mai mare ?i cel mai mic salariu  pe
departamente. Eticheta?i coloana “Diferenta”.

select max(salary) - min(salary) Diferenta, department_id, count(*) nr_ang_din_dept
from employees
group by department_id;

16. Scrie?i o cerere pentru a se afi?a numele departamentului, loca?ia, 
num?rul de angaja?i ?i salariul mediu pentru angaja?ii din acel departament. 
Coloanele vor fi etichetate corespunz?tor.
Observa?ie: În clauza GROUP BY se trec obligatoriu toate coloanele prezente 
în clauza SELECT,care nu sunt argument al func?iilor grup 
(a se vedea ultima observa?ie de la punctul I).


select department_name, city, count(employee_id), round(avg(salary))
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id= l.location_id
group by d.department_id; 
--ORA-00979: nu este o expresie GROUP BY

--R:
select department_name, city, count(employee_id), round(avg(salary))
from employees e, departments d, locations l
where d.department_id = e.department_id
and d.location_id= l.location_id
group by e.department_id,  department_name, city;
--fiecare departament are un singur nume si o singura locatie in care se gaseste

--atenite
--nr de ang si sal mediu pt fiecare departament
select department_id dept_id, count(*) nr_ang, round(avg(salary)) sal_mediu
from employees
group by department_id;

--Rez V2 SELECT folosit in clauza de FROM
select department_name, city, nr_ang, sal_mediu, aux.dept_id
from locations l, departments d, 
    (select department_id dept_id, count(*) nr_ang, round(avg(salary)) sal_mediu
    from employees
    group by department_id) aux
where l.location_id = d.location_id
and aux.dept_id = d.department_id;
--11 rez



17. S? se afi?eze codul ?i numele angaja?ilor care câstig? mai mult decât 
salariul mediu din firm?. Se va sorta rezultatul în ordine descresc?toare a salariilor.

--care este salariul mediu din firma?
select avg(salary)
from employees;
--6461,682242990654205607476635514018691589

select employee_id, last_name, salary
from employees
where salary> (select avg(salary)
                from employees)
order by salary desc;        --51 rez    
--123	Vollman	6500

select employee_id, first_name || ' ' || last_name, salary,aux.sal
from employees,(select avg(salary) sal
                from employees) aux
where salary>aux.sal
order by 3 desc; --51 rez

17". S? se afi?eze codul ?i numele angaja?ilor care câstig? mai mult decât 
salariul mediu din departamentul in care lucreaza.
Se va sorta rezultatul în ordine descresc?toare a salariilor.

select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary> (select avg(a.salary) --salariul mediu din departamentul in care lucreaza.
                from employees a
                where a.department_id = e.department_id) --fara group by!!!
order by  e.salary desc;  --38 rez

--rezolvare identica cu cea de sus
select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary> (select avg(salary) --salariul mediu din departamentul in care lucreaza.
                from employees 
                where department_id = e.department_id)
order by  e.salary desc;  --38 rez

select employee_id, first_name || ' ' || last_name, salary,aux.sal
from employees e,(select department_id, avg(salary) sal
                  from employees
                  group by department_id) aux
where e.department_id=aux.department_id 
and salary > aux.sal
order by 3 desc;--38 rez

--nu
select distinct employee_id, first_name || ' ' || last_name, salary
from employees, (select avg(salary) salariu
                  from employees
                  group by department_id) sal
where salary > sal.salariu  ---salariu mai mare ca un salariu mediu din orice departament
order by salary desc; --70 rez

--nu
select e.employee_id, e.last_name, e.salary, department_id
from employees e
where e.salary >any (select avg(salary)  --subcererea returneaza mai multe rezultate
                      from employees 
                      group by department_id)
order by  e.salary desc;  --70 rez


--141	Rajs	3500 50
select avg(a.salary)
from employees a
where a.department_id = 50; --3475,555555555555555555555555555555555556


select employee_id, salary
from employees a
where a.department_id = 50
order by 2;

--atentie
--nu
select employee_id, last_name
from employees e1
where salary>(select avg(salary) 
              from employees e2 
              where e1.department_id=e2.department_id );
              group by e2.department_id);---in plus

--nu
select last_name, employee_id
from employees
where salary > ( select avg(e.salary)  --6456,603773584905660377358490566037735849
                from employees e, departments d  --media salariilor pt angajatii care lucreaza in departamente
                where e.department_id = d.department_id)
order by salary desc;              

18. Pentru fiecare ?ef, s? se afi?eze codul sau  si salariul celui mai pu?in platit 
subordonat al s?u. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 4000$. 
Sorta?i rezultatul în ordine descresc?toare a salariilor.

select e.manager_id, min(e.salary)
from employees e
where e.manager_id is not null --Se vor exclude cei pentru care codul managerului nu este cunoscut
group by e.manager_id     -- Pentru fiecare sef
having min(salary) >4000 --se vor exclude grupurile în care salariul minim este mai mic de 4000$.
order by 2; --12 rez

--nuuuu
select e.manager_id, min(e.salary)
from employees e
where e.manager_id is not null 
and min(salary) >4000   --ORA-00934: functia de grupare nu este permisa aici
group by e.manager_id     
order by 2; 

18. Pentru fiecare ?ef, s? se afi?eze codul s?u ?i salariul celui mai pu?in platit 
subordonat al s?u. Se vor exclude cei pentru care codul managerului nu este cunoscut. 
De asemenea, se vor exclude grupurile în care salariul minim este mai mic de 4000$. 
Sorta?i rezultatul în ordine descresc?toare a salariilor.
--18" la rezovarea de mai sus, afisati si care este salariatul care are acel 
--salariu minim

--v1 cerere necorelata
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului
from employees a
where (a.manager_id, a.salary) in (select e.manager_id, min(e.salary)
                                  from employees e
                                  where e.manager_id is not null 
                                  group by e.manager_id     
                                  having min(salary) >4000 ); -- 12 rez
--v2  -- select in from
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului, sal_min
from employees a, (select e.manager_id, min(e.salary) sal_min
                  from employees e
                  where e.manager_id is not null 
                  group by e.manager_id     
                  having min(salary) >4000 ) aux
where a.manager_id = aux.manager_id
and a.salary = aux.sal_min; --12 rez

 --v3 cerere corelata                                 
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului
from employees a
where  a.salary = (select  min(e.salary)
                  from employees e
                  --where e.manager_id is not null  --este in plus(datorita join-ului)
                  where  e.manager_id  = a.manager_id 
                  --nu este nevoie de group by!!!!
                  having min(salary) >4000 ); --12 rez  
                  
select  min(e.salary)
from employees e
--where e.manager_id is not null  --este in plus(datorita join-ului)
where  e.manager_id  = 121  --min(e.salary) = 2100
--nu este nevoie de group by!!!!
having min(salary) >4000 ; --null
                  
 --nu
 select e.manager_id, min(e.salary),e.employee_id
from employees e
where e.manager_id is not null --Se vor exclude cei pentru care codul managerului nu este cunoscut
group by e.manager_id, e.employee_id 
having min(salary) >4000;

--nu
select a.manager_id Managerul, a.employee_id Angajatul, a.salary Salariul_angajatului
from employees a
where a.salary in (select  min(e.salary)
                                  from employees e
                                  where e.manager_id is not null 
                                  group by e.manager_id     
                                  having min(salary) >4000 ); -- 18 rez
                  
                  
--Ex:  Sa se afiseze codul si numele angajatilor care câstiga  
--cel mai mult pe job-ul pe care lucreaza.
--Se va sorta rezultatul în ordine descrescatoare a salariilor.                 

--R:V1 - subcerere corelata

SELECT e.employee_id cod,
  e.first_name
  || ' '
  || e.last_name nume
FROM employees e
WHERE salary =
  ( SELECT MAX(salary) FROM employees WHERE job_id = e.job_id
  ); --20 rez

--R:V2 - Select in FROM
SELECT
   e.employee_id,e.last_name  
FROM employees e,
   (   SELECT  e.job_id cod ,   MAX(e.salary) sala
        FROM  employees e
        GROUP BY e.job_id
    ) a
WHERE a.sala=e.salary and a.cod=e.job_id 
order by 1;  --20 rez

--R: V3 - subcerere necorelata
SELECT
   e.employee_id,e.last_name  
FROM employees e
where (e.job_id, e.salary) in
                             (   SELECT  e.job_id cod ,   MAX(e.salary) sala
                                  FROM  employees e
                                  GROUP BY e.job_id
                              ) 
order by 1;  --20 rez


--Ex: Sa se afiseze angajatii care au salariul minim din fiecare departament.    

--salariul maxim din fiecare departament
select department_id, min(salary)
from employees
group by department_id; --12 rez


--R:V1
select employee_id, department_id
from employees e
where e.salary = (select min(e1.salary)
                  from employees e1
                  where e1.department_id = e.department_id)
order by 2; --12 rez

select * from employees where department_id = 90;

--R: V2
select e.employee_id, e.salary
from employees e, (select department_id, min(salary) sal 
                    from employees 
                    group by department_id) maxime
where e.department_id=maxime.department_id 
and e.salary=maxime.sal; --12 rez


--R:V3
select employee_id, salary
from employees
where (department_id, salary) in( select department_id, min(salary)
                                  from employees
                                  group by department_id); --12 rez


--nu 
select employee_id, salary
from employees
where salary in( select  min(salary)
                from employees
                group by department_id); --26 rez


--afisati angajatii care au salariul egal cu un salariu maxim din orice departament


--Cati angajati lucreaza in fiecare locatie? Afisati orasul si numarul de angajati din fiecare oras.
--Pentru fiecare locatie, care este salariul maxim al angajatilor care lucreaza in acele locatii.
--Pentru fiecare locatie, care este numele angajatilor care au salariul maxim si lucreaza in acele locatii.



                                  

19. Pentru departamentele in care salariul maxim dep??e?te 7000$, s? se ob?in? codul, numele acestor 
departamente ?i salariul maxim pe departament.

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,MAX(E.SALARY)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
HAVING MAX(E.SALARY)>7000; --9 rez

--s? se ob?in? codul, numele acestor departamente ?i salariul mediu pe departament.(pt fiecare departament)

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,round(avg(E.SALARY))  --, max(salary)
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME; --11 rez


22. S? se afi?eze maximul salariilor medii pe departamente.
Vrem SUPER-AGREGAREA: Maximul salariului mediu per departament.
---NUUUUUU!!!!
SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,max(round(avg(E.SALARY)))
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME; --ORA-00937: nu exista o functie de grupare de tip grup singular

SELECT MAX(round(AVG(SALARY)))
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID; --19333

--pt a afisa si id-ul si denumirea departamentului care are cel mai mare salariu mediu

SELECT D.DEPARTMENT_ID,D.DEPARTMENT_NAME,round(avg(E.SALARY))
FROM EMPLOYEES E,DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID,D.DEPARTMENT_NAME
having round(avg(E.SALARY)) = (SELECT MAX(round(AVG(SALARY)))
                                FROM EMPLOYEES E,DEPARTMENTS D
                                WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
                                GROUP BY E.DEPARTMENT_ID );
 





