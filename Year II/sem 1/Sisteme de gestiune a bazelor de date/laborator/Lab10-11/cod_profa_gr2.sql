-- Lab 10-11 - Gr 1-2 - LABORATOR PL/SQL 6

/*
1. Definiti un declansator care sa nu permita lucrul asupra tabelului emp_*** (INSERT, UPDATE, 
   DELETE) decat in intervalul de ore 8:00 - 20:00, de luni pana sambata (declansator la nivel 
   de instructiune).
*/

select TO_CHAR(SYSDATE, 'D') from dual;

CREATE OR REPLACE TRIGGER trig1_gid
    BEFORE INSERT OR UPDATE OR DELETE ON emp_gid
BEGIN
    IF TO_CHAR(SYSDATE, 'D') = 1 OR TO_CHAR(SYSDATE, 'HH24') BETWEEN 8 AND 20 THEN
        RAISE_APPLICATION_ERROR(-20001, 'tabelul nu poate fi actualizat');
    END IF;
END;
/

delete from emp_gid;

drop trigger trig1_gid;
    

/*
2. Definiti un declansator prin care sa nu se permita micsorarea salariilor angajatilor din 
   tabelul emp_*** (declansator la nivel de linie).
*/

-- Varianta 1

CREATE OR REPLACE TRIGGER trig21_gid
    BEFORE UPDATE OF salary ON emp_gid
    FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20002, 'salariul nu poate fi micsorat');
    END IF;
END;
/

UPDATE emp_gid
SET salary = salary - 100;

DROP TRIGGER trig21_gid;

-- Varianta 2

CREATE OR REPLACE TRIGGER trig22_gid
    BEFORE UPDATE OF salary ON emp_gid
    FOR EACH ROW
    WHEN (NEW.salary < OLD.salary)
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'salariul nu poate fi micsorat');
END;
/

UPDATE emp_gid
SET salary = salary - 100;

DROP TRIGGER trig22_gid;


/*
3. Creati un declansator care sa nu permita marirea limitei inferioare a grilei de salarizare 1, 
   respectiv micsorarea limitei superioare a grilei de salarizare 7 decat daca toate salariile se 
   gasesc in intervalul dat de aceste doua valori modificate. Se va utiliza tabelul job_grades_***.
*/

select * from job_grades;

CREATE TABLE job_grades_gid AS SELECT * FROM job_grades;

CREATE OR REPLACE TRIGGER trig3_gid
    BEFORE UPDATE OF lowest_sal, highest_sal ON job_grades_gid
    FOR EACH ROW 
DECLARE
    min_sal emp_gid.salary%TYPE;
    max_sal emp_gid.salary%TYPE;
    exceptie EXCEPTION;
BEGIN
    SELECT min(salary), max(salary)
    INTO min_sal, max_sal
    FROM emp_gid;
    
    IF (:OLD.grade_level = 1) AND (min_sal < :NEW.lowest_sal) THEN
        RAISE exceptie;
    END IF;
    
    IF (:OLD.grade_level = 7) AND (max_sal > :NEW.highest_sal) THEN
        RAISE exceptie;
    END IF;
EXCEPTION
    WHEN exceptie THEN
        RAISE_APPLICATION_ERROR(-20003, 'Exista salarii care se gasesc in afara intervalului');
END;
/

select min(salary), max(salary)
FROM employees;

UPDATE job_grades_gid
SET lowest_sal = 3000
WHERE grade_level = 1;

UPDATE job_grades_gid
SET highest_sal = 25000
WHERE grade_level = 7;

rollback;

drop trigger trig3_gid;

/*
4. a. Creati tabelul info_dept_*** cu urmatoarele coloane:
      - id (codul departamentului) – cheie primara;
      - nume_dept (numele departamentului);
      - plati (suma alocata pentru plata salariilor angajatilor care lucreaza in 
        departamentul respectiv).
   b. Introduceti date in tabelul creat anterior corespunzatoare informatiilor existente in schema.
   c. Definiti un declansator care va actualiza automat campul plati atunci cand se introduce un 
      nou salariat, respectiv se sterge un salariat sau se modifica salariul unui angajat.
*/

desc departments;

CREATE TABLE info_dept_gid(
    id NUMBER(4) PRIMARY KEY,
    nume_dept VARCHAR2(30),
    plati NUMBER
);

INSERT INTO info_dept_gid
SELECT d.department_id, department_name, sum(salary)
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
GROUP BY d.department_id, department_name;

commit;

SELECT * FROM info_dept_gid;

CREATE OR REPLACE PROCEDURE modific_plati_gid
    ( v_cod info_dept_gid.id%TYPE,
      v_plati info_dept_gid.plati%TYPE)
IS
BEGIN
    UPDATE info_dept_gid
    SET plati = NVL(plati, 0) + v_plati
    WHERE id = v_cod;
END;
/

CREATE OR REPLACE TRIGGER trig4_gid
    AFTER DELETE OR UPDATE OR INSERT OF salary ON emp_gid
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        modific_plati_gid(:OLD.department_id, -1 * :OLD.salary);
    ELSIF UPDATING THEN
        modific_plati_gid(:OLD.department_id, :NEW.salary - :OLD.salary);
    ELSE
        modific_plati_gid(:NEW.department_id, :NEW.salary);
    END IF;
END;
/

SELECT * FROM info_dept_gid WHERE id=90;

INSERT INTO emp_gid(employee_id, last_name, first_name, email, hire_date, job_id, salary, department_id)
VALUES (300, 'N1', 'P1', 'n1@g.com', sysdate, 'SA_REP', 2000, 90);

UPDATE emp_gid
SET salary = salary + 1000
WHERE employee_id = 300;

DELETE FROM emp_gid
WHERE employee_id = 300;

DROP TRIGGER trig4_gid;


/*
5. a. Creati tabelul info_emp_*** cu urmatoarele coloane:
      - id (codul angajatului) – cheie primara;
      - nume (numele angajatului);
      - prenume (prenumele angajatului);
      - salariu (salariul angajatului);
      - id_dept (codul departamentului) – cheie externa care refera tabelul info_dept_***.
   b. Introduceti date in tabelul creat anterior corespunzatoare informatiilor existente.
   c. Creati vizualizarea v_info_*** care va contine informatii complete despre angajati si 
      departamentele acestora. Folositi cele doua tabele create anterior, info_emp_***, 
      respectiv info_dept_***.
   d. Se pot realiza actualizari asupra acestei vizualizari? Care este tabelul protejat prin cheie? 
      Consultati vizualizarea user_updatable_columns.
   e. Definiti un declansator prin care actualizarile ce au loc asupra vizualizarii se propaga 
      automat in tabelele de baza (declansator INSTEAD OF). Se considera ca au loc urmatoarele 
      actualizari asupra vizualizarii:
      - se adauga un angajat intr-un departament deja existent;
      - se elimina un angajat;
      - se modifica valoarea salariului unui angajat;
      - se modifica departamentul unui angajat (codul departamentului).
   f. Verificati daca declansatorul definit functioneaza corect.
*/

DESC employees;

CREATE TABLE info_emp_gid(
    id NUMBER(6) PRIMARY KEY,
    nume VARCHAR2(25),
    prenume VARCHAR2(20),
    salariu NUMBER,
    id_dept NUMBER(4) REFERENCES info_dept_gid(id)
);

INSERT INTO info_emp_gid
SELECT employee_id, last_name, first_name, salary, department_id
FROM emp_gid;

COMMIT;

CREATE OR REPLACE VIEW v_info_gid AS
    SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, d.nume_dept, d.plati
    FROM info_emp_gid e, info_dept_gid d
    WHERE e.id_dept = d.id;
    
SELECT * FROM v_info_gid;

SELECT *
FROM user_updatable_columns
WHERE table_name = UPPER('v_info_gid');

CREATE OR REPLACE TRIGGER trig5_gid
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_gid
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO info_emp_gid
        VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
        
        UPDATE info_dept_gid
        SET plati = NVL(plati, 0) + :NEW.salariu
        WHERE id = :NEW.id_dept;
    ELSIF DELETING THEN
        DELETE FROM info_emp_gid
        WHERE id = :OLD.id;
        
        UPDATE info_dept_gid
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('salariu') THEN
        UPDATE info_emp_gid
        SET salariu = :NEW.salariu
        WHERE id = :OLD.id;
        
        UPDATE info_dept_gid
        SET plati = plati - :OLD.salariu + :NEW.salariu
        WHERE id = :OLD.id_dept;
    END IF;
    
    IF UPDATING('id_dept') THEN
        UPDATE info_emp_gid
        SET id_dept = :NEW.id_dept
        WHERE id = :OLD.id;
        
        UPDATE info_dept_gid
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
        
        UPDATE info_dept_gid
        SET plati = plati + :NEW.salariu
        WHERE id = :NEW.id_dept;
    END IF;
END;
/

SELECT * FROM info_dept_gid where id = 10;

INSERT INTO v_info_gid
VALUES (400, 'N1', 'P1', 3000, 10, 'Nume dept', 0);

SELECT * FROM info_emp_gid WHERE id = 400;
SELECT * FROM info_dept_gid where id = 10;

UPDATE v_info_gid
SET salariu = salariu + 2000,
    id_dept = 90
WHERE id = 400;

SELECT * FROM info_emp_gid WHERE id = 400;
SELECT * FROM info_dept_gid where id = 10;

SELECT * FROM info_dept_gid WHERE id = 90;

UPDATE v_info_gid
SET id_dept = 90
WHERE id = 400;

SELECT * FROM info_emp_gid WHERE id = 400;
SELECT * FROM info_dept_gid where id = 10;
SELECT * FROM info_dept_gid WHERE id = 90;

DELETE FROM v_info_gid WHERE id=400;

SELECT * FROM info_emp_gid WHERE id = 400;
SELECT * FROM info_dept_gid WHERE id = 90;

DROP TRIGGER trig5_gid;
        

/*
6. Definiti un declansator care sa nu permita stergerea informatiilor din tabelul emp_*** de 
   catre utilizatorul grupa***.
*/

CREATE OR REPLACE TRIGGER trig6_gid
    BEFORE DELETE ON emp_gid
BEGIN
    IF USER = UPPER('grupa232') THEN
        RAISE_APPLICATION_ERROR(-20900, 'Nu este permisa stergerea');
    END IF;
END;
/

DELETE FROM emp_gid;

DROP TRIGGER trig6_gid;

/*
7. a. Creati tabelul audit_*** cu urmatoarele campuri:
      - utilizator (numele utilizatorului);
      - nume_bd (numele bazei de date);
      - eveniment (evenimentul sistem);
      - nume_obiect (numele obiectului);
      - data (data producerii evenimentului).
   b. Definiti un declansator care sa introduca date in acest tabel dupa ce utilizatorul a folosit o 
      comanda LDD (declansator sistem - la nivel de schema).
*/

DROP TABLE audit_gid;

CREATE TABLE audit_gid
    (utilizator VARCHAR2(30),
     nume_bd VARCHAR2(50),
     eveniment VARCHAR2(20),
     nume_obiect VARCHAR2(30),
     data DATE);

CREATE OR REPLACE TRIGGER trig7_gid
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO audit_gid
    VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_gid ON info_emp_gid(nume);
DROP INDEX ind_gid;

SELECT * FROM audit_gid;

DROP TRIGGER trig7_gid;

/*
8. Definiti un declansator care sa nu permita modificarea:
   - valorii salariului maxim astfel incat acesta sa devina mai mic decat media tuturor salariilor;
   - valorii salariului minim astfel incat acesta sa devina mai mare decat media tuturor salariilor.
   Observatie:
   In acest caz este necesara mentinerea unor variabile in care sa se retina salariul minim, 
   salariul maxim, respectiv media salariilor. Variabilele se definesc intr-un pachet, iar apoi 
   pot fi referite in declansator prin nume_pachet.nume_variabila. 
   Este necesar sa se defineasca doi declansatori:
   - un declansator la nivel de comanda care sa actualizeze variabilele din pachet.
   - un declansator la nivel de linie care sa realizeze verificarea conditiilor.
*/

CREATE OR REPLACE PACKAGE pachet_gid
AS
    min_sal NUMBER;
    max_sal NUMBER;
    med_sal NUMBER;
END pachet_gid;
/

CREATE OR REPLACE TRIGGER trig81_gid
BEFORE UPDATE OF salary ON emp_gid
BEGIN
    SELECT min(salary), max(salary), avg(salary)
    INTO pachet_gid.min_sal, pachet_gid.max_sal, pachet_gid.med_sal
    FROM emp_gid;
END;
/
    

CREATE OR REPLACE TRIGGER trig82_gid
BEFORE UPDATE OF salary ON emp_gid
FOR EACH ROW
BEGIN    
    IF :OLD.salary = pachet_gid.max_sal AND :NEW.salary < pachet_gid.med_sal THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu este sub valoarea medie');
    ELSIF :OLD.salary = pachet_gid.min_sal AND :NEW.salary > pachet_gid.med_sal THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu depaseste valoarea medie');
    END IF;
END;
/

SELECT min(salary), max(salary), avg(salary)
FROM emp_gid;

UPDATE emp_gid
SET salary = 10000
WHERE salary = (SELECT MIN(salary) FROM emp_gid);

UPDATE emp_gid
SET salary = 1000
WHERE salary = (SELECT MAX(salary) FROM emp_gid);

UPDATE emp_gid
SET salary = 1000
WHERE salary = (SELECT MIN(salary) FROM emp_gid);

DROP TRIGGER trig81_gid;
DROP TRIGGER trig82_gid;

-- Tema - Exercitiile 1-6 de la finalul fisierului
-- Deadline: miercuri 11.01.2023 ora 23:59 

