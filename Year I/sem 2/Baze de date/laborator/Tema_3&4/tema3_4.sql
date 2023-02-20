
/* 
Cati angajati lucreaza in fiecare locatie? Afisati orasul si numarul de angajati din fiecare oras.
*/

select l.city as "Oras_PAM", count(e.employee_id) as "Nr_Angajati_PAM"
from employees e, departments d, locations l 
where e.department_id (+) = d.department_id and d.location_id (+) = l.location_id
group by l.city; -- 23 rezultate




/*
Pentru fiecare locatie, care este salariul maxim al 
angajatilor care lucreaza in acele locatii.
*/

select l.location_id "Locatii_PAM", nvl(max(e.salary), 0) "Salariu_maxim_PAM"
from employees e, departments d, locations l 
where e.department_id (+) = d.department_id and d.location_id (+) = l.location_id
group by l.location_id; -- 23 rezultate

-- Pentru a afla salariul maxim din fiecare locatie trebuie mai intai sa
-- grupam dupa locatie toti angajatii (folosind group by) si apoi
-- pentru fiecare grup sa selectam salariul maxim (functia max pe campul salary). 
-- Cum aceste informatii se afla in tabelele locations si employees, 
-- iar legatura dintre ele se face prin tabela departments e necesar 
-- un join intre cele 3 tabele folosind id-urile de departament si locatie.
-- Ca sa afisam si salariul pentru locatiile in care nu lucreaza nimei (=0)
-- folosim left join si functia nvl la salariul maxim.


/*
Pentru fiecare locatie, care este numele angajatilor care au salariul 
maxim si lucreaza in acele locatii.
*/

with salariu_maxim_locatie as
(select l.location_id as location, nvl(max(e.salary), 0) as max_salary
                    from employees e, departments d, locations l 
                    where e.department_id (+) = d.department_id and d.location_id (+) = l.location_id
                    group by l.location_id
)
select l.location_id "Locatii_PAM", e.last_name "Nume_Angajat_Sal_Max_PAM"
from employees e , departments d, locations l, salariu_maxim_locatie s
where e.department_id = d.department_id and d.location_id = l.location_id 
and l.location_id = s.location and e.salary = s.max_salary; -- 7 rezultate


-- Pentru a rezolva cerinta am folosit cererea de la ex anterior pe care
-- am pus-o intr-un tabel temporar folosit clauze with. Apoi am corelat
-- cele trei tabele pentru a afla salariul maxim din fiecare locatie 
-- (am grupat pe locatii folosind group by) si am adaugat verificarile
-- legate de salariu maxim si locatie pentru a face legatura cu tabelul
-- temporar.


/*
Sa se obtina numele salariatilor, numele departamentului si orasul 
pentru angajatii care lucreaza într-un departament în care exista cel
putin un angajat cu salariul egal cu salariul maxim din unul dintre 
departamentele in care lucreaza un salariat care continul sirul "er" 
in prenume.
*/

/*
Ex4.a) In ce departamente lucreaza salaritii care contin
sirul "er" in prenume.
*/
select distinct d.department_id "Departamente_PAM"
from employees e, departments d
where e.department_id = d.department_id and lower(e.first_name) like '%er%';
-- 6 rezultate

-- Facem join intre tabelele employees si departments prin department_id
-- si folosim functia like ca sa selectam angajatii al caror nume contine 
-- sirul er. Ca sa nu afisam acelasi departamdent de mai multe ori am
-- folosit distinct in cerere.


/*
Ex4.b) Care sunt salariile maxime din aceste departamente 
obtinute la subpunctul a)?
*/

select d.department_id "Departamente_PAM", max(e.salary) as "Salariu_Maxim_PAM"
from employees e, departments d
where e.department_id = d.department_id and e.department_id in 
(
select distinct d.department_id "Departamente_PAM"
from employees e, departments d
where e.department_id = d.department_id and lower(e.first_name) like '%er%' 
)
group by d.department_id; -- 6 rezultate

-- Facem join intre employees si departments cu conditia ca departamentul 
-- sa respecte conditiile de la subpunctul anterior si grupam dupa 
-- department_id. Apoi selectam departamentul si
-- si salariile maxime corespunzatoare

/*
Ex4.c) In ce departamente lucreaza angajatii care au salariul 
egal cu unul dintre salariile maxime obtinute la subpunctul b)?
*/


select distinct d.department_id "Departamente_PAM"
from employees e, departments d
where e.department_id = d.department_id and e.salary in 
( 
    select max(e.salary) as "Salariu_Maxim_PAM"
    from employees e, departments d
    where e.department_id = d.department_id and e.department_id in (select distinct d.department_id "Departamente_PAM"
                                                                    from departments d, employees e
                                                                    where e.department_id = d.department_id 
                                                                    and lower(e.first_name) like '%er%')
    group by d.department_id
); 
--7 rez

-- Am facut join intre employees su departments si am 
-- folosit cererea de la subpunctul anterior ca sa 
-- selectam angajatii care au salariul egal cu
-- cel maxim din departamenul corespunzator





