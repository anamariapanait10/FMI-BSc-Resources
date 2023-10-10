S5+S6 - Laborator3.pdf  - Join(+subcereri necorelate) + Union(all)+Operatii multimi(16-17+23-24/02.2022)

Pt toti salariatii din firma afisati numele angajatului, limitele salariale ale job-ului 
pe care lucreaza(max_salary, min_salary)  si denumirea departamentului in care
lucreaza fiecare salariat.

--v1
select e.last_name || ' '||e.first_name, j.max_salary, j.min_salary,d.department_name
from jobs j, employees e, departments d
where j.job_id = e.job_id
and e.department_id = d.department_id; --106 rez
--v2
select e.last_name || ' '||e.first_name, j.max_salary, j.min_salary,d.department_name
from  jobs j join  employees e on  j.job_id = e.job_id  
        join departments d on e.department_id = d.department_id; --106 rez

-------------------------------------------------------------------------
select e.last_name || ' '||e.first_name, d.department_name
from   employees e join departments d on e.department_id = d.department_id; --106 rez

--natural join
--angajatii care au ca manager direct managerul departamentului in care lucreaza ei
select e.last_name || ' '||e.first_name, d.department_name
from   employees e natural join departments d ; --32 rez  --department_id, manager_id

---departametul (numele) in care lucreaza fiecare angajat
select e.last_name || ' '||e.first_name, d.department_name, department_id  --atentie dept_id
from   employees e  join departments d using(department_id); --106 rez 


--incorect
select e.last_name || ' '||e.first_name, d.department_name, d.department_id  --atentie dept_id
from   employees e  join departments d using(department_id); --106 rez 
--ORA-25154: column part of USING clause cannot have qualifier


Sa se afiseze numele, salariul, titlul job-ului, 
ora?ul ?i ?ara în care  lucreaz? angajatii 
condusi direct de managerul cu cod 100.
--v1
select e.last_name || ' '||e.first_name, j.job_title, l.city, c.country_name
from jobs j, employees e, departments d, locations l, countries c
where j.job_id = e.job_id
and e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and e.manager_id =100;--14 rez

--v2
select e.last_name || ' '||e.first_name, j.job_title, l.city, c.country_name
from jobs j join  employees e on  j.job_id = e.job_id
        join departments d on e.department_id = d.department_id
        join locations l on d.location_id = l.location_id
        join countries c on l.country_id = c.country_id
where e.manager_id =100;--14 rez

--v3
--incorect
select e.last_name || ' '||e.first_name, j.job_title, l.city, c.country_name, 
        manager_id, department_id
from jobs j  natural join  employees e 
       natural join departments d   --department_id, manager_id
         natural join locations l
       natural join countries c 
where manager_id =100;--2 rez

select manager_id  ---manageru-ul 100 pt dept 90
from departments
where department_id =90;

--corect
select e.last_name || ' '||e.first_name, j.job_title, l.city, c.country_name
from jobs j  join  employees e using (job_id)
        join departments d using (department_id)
         join locations l  using (location_id)
         join countries c using (country_id)
where e.manager_id =100;--14 rez


Sa se gaseasca toate titlurile de job-uri
care au maximul  salariului mai mic decat 
salariul angajatului cu cod 100.

SELECT j.job_title
FROM JOBS j, EMPLOYEES e
WHERE j.max_salary<e.salary  
AND e.employee_id=100; --17 rez

SELECT j.job_title , e.salary, j.max_salary
FROM JOBS j JOIN EMPLOYEES e ON (j.max_salary<e.salary) 
WHERE e.employee_id=100;

--Salariul ang cu codul 100
select salary   --240000
from employees
where employee_id =100;

SELECT j.job_title
FROM JOBS j
WHERE j.max_salary<(select salary   --240000
                    from employees
                    where employee_id =100); --subcerere necorelata
--17 rez

--atentie!!
SELECT j.job_title , e.salary, j.max_salary, e.employee_id
FROM JOBS j JOIN EMPLOYEES e ON (j.max_salary<e.salary) ;

SELECT j.job_title , e.salary, j.max_salary
FROM JOBS j natural JOIN EMPLOYEES e 
where (j.max_salary<=e.salary) ; --1 rez pt ca fiecare sal are 
--salariul intre limitele salariale coresp jobului pe care lucreaza

SELECT j.job_title
FROM JOBS j
WHERE j.max_salary<(select salary   --240000
                    from employees
                    where employee_id =100); --subcerere necorelata
                    
-- Self join de tip nonequijoin
S? se afi?eze numele ?i data angaj?rii pentru salaria?ii
care au fost  angaja?i dup? Gates.

--data angajarii lui 'Gates'
SELECT E2.hire_date
FROM  EMPLOYEES E2
WHERE initcap(e2.last_name)='Gates' ;  --11-JUL-98

--rezolvare:
SELECT E.last_name, E.hire_date
FROM EMPLOYEES E, EMPLOYEES E2
WHERE initcap(e2.last_name)='Gates'  AND E.hire_date>E2.hire_date;
--34 rez
-- E2.hire_date = 11-JUL-98
--in E2 avem informatii despre Gates

SELECT E.last_name, E.hire_date
FROM EMPLOYEES E JOIN EMPLOYEES E2
            ON (E.hire_date>E2.hire_date)  
WHERE initcap(e2.last_name)='Gates';

--subcerere necorelata
SELECT E.last_name, E.hire_date
FROM EMPLOYEES E
WHERE E.hire_date > ( SELECT E2.hire_date   --subcererea necorelata returneaza o singura 
                    FROM  EMPLOYEES E2      -- linie si o singura coloana
                    WHERE initcap(e2.last_name)='Gates' );
 --34 rez                   



--Self join de tip equijoin

Scrieti o cerere pentru a se afisa numele, luna (în litere) ?i
anul  angaj?rii pentru toti salariatii din acelasi departament cu Gates,
al  c?ror nume con?ine litera “a”.


--in ce dept lucreaza Gates
SELECT e2.department_id
FROM employees e2  
WHERE initcap(e2.last_name)='Gates';
--dept 50

SELECT e.last_name, to_char(e.hire_date,'MONTH') as "luna", 
    to_char(e.hire_date,'YYYY') as "anul"
FROM employees e, employees e2  
WHERE initcap(e2.last_name)='Gates'
AND e.department_id=e2.department_id   --conditie de join
AND lower(e.last_name) LIKE '%a%'; --24 rez
--e2.department_id =50

alter session set nls_language=American;

SELECT e.last_name, to_char(e.hire_date,'MONTH') as "luna", 
        to_char(e.hire_date,'YYYY') as "anul"
FROM employees e
WHERE lower(e.last_name) LIKE '%a%'
and e.department_id = (SELECT e2.department_id  --subcerere necorelata
                        FROM employees e2  
                        WHERE e2.last_name='Gates');--24 rez
                        --nu este nevoie de alias-uri

Sa se afiseze codul ?i numele angaja?ilor care lucreaz? în 
acelasi departament cu cel pu?in un angajat al c?rui nume  con?ine litera “t”.

In ce departamente(id+nume) lucreaza angajatii  al c?ror nume con?in litera “t”.

SELECT DISTINCT d.department_id, d.department_name
FROM EMPLOYEES E, departments d
WHERE E.department_id= d.department_id
AND lower(E.last_name) LIKE '%t%'; --7 rez


In ce departamente(id) lucreaza angajatii  al c?rui nume con?ine litera “t”.

SELECT DISTINCT e.department_id
FROM EMPLOYEES E
WHERE lower(E.last_name) LIKE '%t%'; --8 rez


Sa se afiseze codul ?i numele angaja?ilor care lucreaz? în 
acelasi departament cu cel pu?in un angajat al c?rui nume 
con?ine litera “t”.

SELECT DISTINCT E.employee_id, E.last_name 
FROM EMPLOYEES E, EMPLOYEES E2
WHERE E.department_id= E2.department_id
AND lower(E2.last_name) LIKE '%t%'; --100 rez
---e2 angajatii care contin in nume litera t

SELECT  E.employee_id, E.last_name 
FROM EMPLOYEES E
WHERE E.department_id in ( SELECT DISTINCT e.department_id
                        FROM EMPLOYEES E
                        WHERE lower(E.last_name) LIKE '%t%'); --100 rez
  --incorect                      
SELECT  E.employee_id, E.last_name 
FROM EMPLOYEES E
WHERE E.department_id in (SELECT DISTINCT d.department_id, d.DEPARTMENT_NAME --ORA-00913: too many values
                            FROM EMPLOYEES E, departments d
                            WHERE E.department_id= d.department_id
                            AND lower(E.last_name) LIKE '%t%'); --100 rez

SELECT  E.employee_id, E.last_name 
FROM EMPLOYEES E
WHERE E.department_id in (SELECT DISTINCT d.department_id
                            FROM EMPLOYEES E, departments d
                            WHERE E.department_id= d.department_id
                            AND lower(E.last_name) LIKE '%t%'); --100 rez
                            
SELECT  E.employee_id, E.last_name 
FROM EMPLOYEES E
WHERE E.department_id in (SELECT  d.department_id   
                            FROM EMPLOYEES E, departments d
                            WHERE E.department_id= d.department_id
                            AND lower(E.last_name) LIKE '%t%'); --100 rez
--subcererea necorelata returneaza o coloana, dar mai multe linii

---outer join

S? se afi?eze numele salaria?ilor ?i numele departamentelor în 
care lucreaz?. Se vor afi?a ?i salaria?ii care nu au asociat un  departament.

SELECT	e.*, d.* 
FROM departments d, employees e
WHERE d.department_id(+) = e.department_id
order by d.department_id desc;
--107 rez

SELECT	last_name, department_name
FROM	departments d RIGHT OUTER JOIN employees e 
ON d.department_id = e.department_id; --107 rez

---exista angajatul si vrem sa completeze cu null la info-le legate de departament


q)S? se afi?eze numele departamentelor ?i numele salaria?ilor care  
lucreaz? în ele. Se vor afi?a ?i departamentele care nu au salaria?i.

SELECT	e.*, d.* 
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
order by d.department_id desc;

--16 dep in care nu lucreaza niciun angajat +106 ang care lucreaza in departamente
--122 rez

SELECT	last_name, department_name
FROM	departments d Left OUTER JOIN employees e 
ON d.department_id = e.department_id; --122 rez

SELECT	last_name, department_name
FROM	employees e right OUTER JOIN departments d
ON d.department_id = e.department_id; --122 rez


Scrieti o cerere care afiseaza departamentele, chiar ?i cele f?r? 
func?ionari, ?i func?ionarii, chiar ?i cei care nu sunt asigna?i 
nici  unui departament

---NUUUUUU
SELECT	e.*, d.* 
FROM departments d, employees e
WHERE d.department_id(+) = e.department_id(+)
order by d.department_id desc;
--ORA-01468: a predicate may reference only one outer-joined table

--v1 corecta
SELECT employee_id,last_name, department_name  FROM employees e, departments d
WHERE e.department_id = d.department_id(+)   --inclusiv ang care nu au dept
UNION
SELECT employee_id,last_name, department_name  FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;  --inclusiv departamentele care nu au ang


106 ang cu dept
16 dept pe care nu lucreaza ang
1 ang fara dept
123

{1,2,3} union {2,3,4} ={1,2,3,4}

{1,2,3,1,3} union {2,3,4} ={1,2,3,4}

--atentie la angajatii cu acelasi nume
;
SELECT last_name, department_name  
FROM employees e, departments d
WHERE e.department_id = d.department_id(+)   --inclusiv ang care nu au dept
UNION
SELECT last_name, department_name  
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;  --inclusiv departamentele care nu au ang
--121 rez --incorect

--v2 corecta
SELECT last_name, department_name  
FROM employees e FULL OUTER JOIN departments d
ON e.department_id = d.department_id;

Sa se afiseze codurile de tara,locatie,departament,angajat
inclusiv pt tarile fara locatii


--nuu
SELECT E.EMPLOYEE_ID,D.DEPARTMENT_ID,L.LOCATION_ID,C.COUNTRY_ID  
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C  
WHERE L.COUNTRY_ID(+)=C.COUNTRY_ID
AND D.LOCATION_ID=L.LOCATION_ID
AND E.DEPARTMENT_ID=D.DEPARTMENT_ID;

---corect
/
SELECT E.EMPLOYEE_ID,D.DEPARTMENT_ID,L.LOCATION_ID,C.COUNTRY_ID  
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C  
WHERE L.COUNTRY_ID(+)=C.COUNTRY_ID
AND D.LOCATION_ID(+)=L.LOCATION_ID
AND E.DEPARTMENT_ID(+)=D.DEPARTMENT_ID; ---149 rez
/

Se cer codurile departamentelor al c?ror nume con?ine sirul “re”
sau în care lucreaz? angaja?i având codul job-ului “SA_REP”.

-- codurile departamentelorîn care lucreaz? angaja?i având codul job-ului “SA_REP”.
SELECT department_id "Cod departament" 
FROM employees
WHERE upper(job_id)='SA_REP'   --80, null  ---30 rez
UNION
--codurile departamentelor al c?ror nume con?ine ?irul “re”
SELECT department_id  
FROM departments
WHERE lower(department_name) LIKE '%re%';   ---7 rez 
--40,70,120,140,150,250,260
--in total 9 rez
;

SELECT department_id "Cod departament" 
FROM employees
WHERE upper(job_id)='SA_REP'   --80, null  ---30 rez
UNION all
SELECT department_id  
FROM departments
WHERE lower(department_name) LIKE '%re%';   ---7 rez 
--40,70,120,140,150,250,260
--in total 37 rez

/*
--discutii:
Se cer codurile departamentelor al c?ror nume con?ine sirul “re”
sau în care lucreaz? angaja?i având codul job-ului “SA_REP”.
--folosind outer join

SELECT  distinct d.department_id "Cod departament" 
FROM employees e full outer join departments d on (e.department_id =d.department_id)
WHERE  (upper(job_id)='SA_REP'  or lower(department_name) LIKE '%re%'); 
-- 9 rez

Se cer codurile departamentelor  pe care lucreaza angajati si 
(al c?ror nume de departament con?ine sirul “re” 
sau în care lucreaz? angaja?i având codul job-ului “SA_REP”).

SELECT distinct d.department_id "Cod departament" 
FROM employees e, departments d
WHERE e.department_id = d.department_id
and (upper(job_id)='SA_REP'  or lower(department_name) LIKE '%re%');
--70, 80, 40


---nu
SELECT distinct d.department_id "Cod departament" 
FROM employees e, departments d
WHERE  (upper(job_id)='SA_REP'  or lower(department_name) LIKE '%re%');

select * from employees where department_id =260;
*/



--select job_id 
--from jobs
--where job_id not in (select job_id
--                     from employees);




----------------------------------------------------------------------------
-- lucram pe 193.226.51.37

desc departments;

Name            Null?    Type         
--------------- -------- ------------ 
DEPARTMENT_ID   NOT NULL NUMBER(4)    
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
MANAGER_ID               NUMBER(6)    
LOCATION_ID              NUMBER(4)

insert into departments values (111, 'Test dept1', null, null);
insert into departments values (112, 'Test dept2', null, null);

commit;

Saptamana 6

Afisati informatii despre orasele(city) si departamentele(department_name)
care se gasesc in acele locatii (orase).Se vor afisa informatii chiar
si despre locatiile(orasele) in care nu se gasesc departamente.

select l.city, d.department_name dep
from locations l, departments d
where l.location_id = d.location_id(+)
order by dep desc;  --43 rez (16 locatii fara dept)

select l.city, d.department_name dep
from locations l left outer join departments d
on l.location_id = d.location_id
order by dep desc; --43 rez

--atentie
Select l.city, d.department_name dep
from locations l full outer join departments d 
on ( l.location_id = d.location_id);
--43 vad studentii inainte de a da eu commit dupa cele 2 insert-uri de la inceput
--commit;
--corect:
--45 rez (16 locatii fara dept, 2 dept fara locatii)

10.	Se cer codurile departamentelor al cãror nume conþine ºirul “re” sau în care 
lucreazã angajaþi având codul job-ului “SA_REP”.

-- codurile departamentelor în care lucreaz? angaja?i având codul job-ului “SA_REP”.
SELECT department_id "Cod departament" 
FROM employees
WHERE upper(job_id)='SA_REP'   --80, null  ---30 rez
UNION
--codurile departamentelor al c?ror nume con?ine ?irul “re”
SELECT department_id  "codul"
FROM departments
WHERE lower(department_name) LIKE '%re%';   ---7 rez 
--40,70,120,140,150,250,260

--in total 9 rez
;

--atentie apare aliasul "Cod departament" 

SELECT department_id "Cod departament" 
FROM employees
WHERE upper(job_id)='SA_REP'   --80, null  ---30 rez
UNION all
SELECT department_id  
FROM departments
WHERE lower(department_name) LIKE '%re%';   ---7 rez 
--40,70,120,140,150,250,260
--in total 37 rez


10.1.	Se cer codurile si numele departamentelor al cãror nume 
conþine ºirul “re” sau în care 
lucreazã angajaþi având codul job-ului “SA_REP”.
--corect
--numele departamentelor al cãror nume conþine ºirul “re”
select department_name "Nume departamente", department_id
from departments
where lower(department_name) like '%re%'
Union
-- numele departamentelor în care lucreazã angajaþi având codul job-ului “SA_REP”.
select department_name "Nume2", e.department_id --29 rez
from employees e, departments d
where lower(job_id) like 'sa_rep'
and e.department_id = d.department_id; 
--Final : 8 rez


--numele departamentelor al cãror nume conþine ºirul “re”
select department_name "Nume departamente", department_id
from departments
where lower(department_name) like '%re%'
Union
-- numele departamentelor în care lucreazã angajaþi având codul job-ului “SA_REP”.
select department_name "Nume2", e.department_id --29 rez
from employees e, departments d
where lower(job_id) like 'sa_rep'
and e.department_id = d.department_id(+); 



--ATENTIE!!!!
--ORA-01790: expresia trebuie sa aiba acelasi tip de data ca si expresia corespondenta
--din cealata cerere!
--numele departamentelor al cãror nume conþine ºirul “re”
select department_name "Nume departamente"
from departments
where lower(department_name) like '%re%'
Union
-- codurile departamentelor în care lucreazã angajaþi având codul job-ului “SA_REP”.
select d.department_id "Nume2"
from employees e, departments d
where lower(job_id) like 'sa_rep'
and e.department_id = d.department_id; 

--ruleaza corect
--numele departamentelor al cãror nume conþine ºirul “re”
select department_name "Nume departamente"
from departments
where lower(department_name) like '%re%'
Union
-- codurile departamentelor în care lucreazã angajaþi având codul job-ului “SA_REP”.
select to_char(d.department_id) "Idul2"
from employees e, departments d
where lower(job_id) like 'sa_rep'
and e.department_id = d.department_id; 

--ATENTIE!!!!
--functioneaza
--numele si id-ul departamentelor al cãror nume conþine ºirul “re”
select department_name "Nume departamente", To_char(department_id)
from departments
where lower(department_name) like '%re%'
Union
--numele angajaþilor si id-ul jobului pt salariatii având codul job-ului “SA_REP”.
select last_name "Nume angajat", job_id
from employees e, departments d
where lower(job_id) like 'sa_rep'
and e.department_id = d.department_id; --35 rez


11.	Sã se ob?inã codurile departamentelor în care nu lucreazã nimeni 
(nu este introdus nici un salariat în tabelul employees).
Se cer douã soluþii (MINUS, NOT IN).
Observa?ie: Operatorii pe mulþimi pot fi utilizaþi în subcereri. 
Coloanele care apar în clauza WHERE a interogãrii trebuie sã corespundã, 
ca numãr ºi tip de date, celor din clauza SELECT a subcererii. 
Comenta?i necesitatea tratãrii valorilor null în varianta utilizãrii 
operatorului NOT IN. 

Solu?ie:;

SELECT d.department_id
FROM departments d ---lista tututor departamentelor din firma
MINUS
SELECT UNIQUE department_id
FROM employees; --lista departamentelor in care lucreaza angajatii
--18 rez

SELECT d.department_id
FROM departments d ---lista tututor departamentelor din firma
MINUS
SELECT distinct department_id
FROM employees; --lista departamentelor in care lucreaza angajatii

SELECT d.department_id
FROM departments d ---lista tututor departamentelor din firma
MINUS
SELECT department_id
FROM employees; -- departamentele in care lucreaza angajatii

SELECT d.department_id
FROM departments d ---lista tututor departamentelor din firma
MINUS
SELECT e.department_id
FROM employees e, departments d
where e.department_id = d.department_id; -- departamentele in care lucreaza angajatii


111
112
120
130
140
150
160
170
180
190
200
210
220
230
240
250
260
270
select distinct department_id
from employees; --12 (+null)

-subcerere

--incorect
select d.department_id
from departments d
where d.department_id not in ( SELECT UNIQUE department_id
                                 FROM employees e); --contine null
                                 --0 rez

--corect
select d.department_id
from departments d
where d.department_id not in ( SELECT UNIQUE dd.department_id
                                 FROM employees e, departments dd
                                 where e.department_id = dd.department_id);        

SELECT department_id
FROM departments
WHERE department_id NOT IN (
                              SELECT d.department_id
                              FROM departments d
                              JOIN employees e ON(d.department_id=e.department_id)
                              );
                              
select d.department_id
from departments d
where d.department_id not in ( SELECT UNIQUE e.department_id
                                 FROM employees e
                                 where e.department_id is not null);  
                                 --18 dept (2 departamente adaugate de noi astazi) 


12.	Se cer codurile departamentelor al cãror nume conþine ºirul “re” si în care 
lucreazã angajaþi având codul job-ului “HR_REP”. 

--codurile departamentelor al cãror nume conþine ºirul “re”
select department_id "Id de departamente"
from departments
where lower(department_name) like '%re%'
Intersect
-- codurile departamentelor în care lucreazã angajaþi având codul job-ului “HR_REP”.
select d.department_id "Id2"
from employees e, departments d
where lower(job_id) like 'hr_rep'
and e.department_id = d.department_id; -- 1 rez : Dep 40


select d.department_id "Id2"
from employees e, departments d
where lower(job_id) = 'hr_rep'
and e.department_id = d.department_id
and  lower(department_name) like '%re%'; -- 1 rez : Dep 40




