-- Lab 9-10 - Gr 1-2 - LABORATOR PL/SQL 5

-- Pachete definite de utilizator

/*
1. Definiti un pachet care permite prin intermediul a doua functii calculul numarului 
   de angajati si suma ce trebuie alocata pentru plata salariilor si a comisioanelor 
   pentru un departament al carui cod este dat ca parametru. 
   
*/

CREATE OR REPLACE PACKAGE pachet1_gid AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
    FUNCTION f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
END pachet1_gid;
/

CREATE OR REPLACE PACKAGE BODY pachet1_gid AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER
    IS
        numar NUMBER;
    BEGIN
        SELECT COUNT(*) INTO numar
        FROM employees
        WHERE department_id = v_dept;
        
        RETURN numar;
    END f_numar;
    
    FUNCTION f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER
    IS
        suma NUMBER;
    BEGIN
        SELECT SUM(salary + salary * NVL(commission_pct, 0)) INTO suma
        FROM employees
        WHERE department_id = v_dept;
        
        RETURN suma;
    END f_suma;
END pachet1_gid;
/

SELECT pachet1_gid.f_numar(80)
FROM dual;

SELECT pachet1_gid.f_suma(80)
FROM dual;

BEGIN
    dbms_output.put_line('numarul de salariati este ' || pachet1_gid.f_numar(80));
    dbms_output.put_line('suma alocata este ' || pachet1_gid.f_suma(80));
END;
/


/*
2. Creati un pachet ce include actiuni pentru adaugarea unui nou departament in tabelul 
   dept_*** si a unui nou angajat (ce va lucra in acest departament) in tabelul emp_***. 
   Procedurile pachetului vor fi apelate din SQL, respectiv din PL/SQL. Se va verifica 
   daca managerul departamentului exista inregistrat ca salariat. De asemenea, se va 
   verifica daca locatia departamentului exista. Pentru inserarea codului salariatului
   se va utiliza o secventa.
*/


CREATE SEQUENCE sec_gid START WITH 400;

DESC departments;
DESC employees;

CREATE OR REPLACE PACKAGE pachet2_gid IS
    PROCEDURE p_dept (v_cod dept_gid.department_id%TYPE,
                      v_nume dept_gid.department_name%TYPE,
                      v_mgr dept_gid.manager_id%TYPE,
                      v_loc dept_gid.location_id%TYPE);
    
    PROCEDURE p_emp (v_prenume emp_gid.first_name%TYPE,
                     v_nume emp_gid.last_name%TYPE,
                     v_email emp_gid.email%TYPE,
                     v_telefon emp_gid.phone_number%TYPE := NULL,
                     v_data_ang emp_gid.hire_date%TYPE := SYSDATE,
                     v_job_id emp_gid.job_id%TYPE,
                     v_salariu emp_gid.salary%TYPE := 0,
                     v_comision emp_gid.commission_pct%TYPE := 0,
                     v_mgr emp_gid.manager_id%TYPE,
                     v_dept emp_gid.department_id%TYPE);
    
    FUNCTION exista (v_mgr_id dept_gid.manager_id%TYPE,
                     v_loc dept_gid.location_id%TYPE)
        RETURN BOOLEAN;
END pachet2_gid;
/


CREATE OR REPLACE PACKAGE BODY pachet2_gid IS

    FUNCTION exista (v_mgr_id dept_gid.manager_id%TYPE,
                     v_loc dept_gid.location_id%TYPE)
    RETURN BOOLEAN
    IS
        nr_mgr NUMBER;
        nr_loc NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nr_mgr
        FROM employees
        WHERE employee_id = v_mgr_id;
        
        SELECT COUNT(*) INTO nr_loc
        FROM locations
        WHERE location_id = v_loc;
        
        IF nr_mgr = 0 OR nr_loc = 0 THEN
            RETURN false;
        ELSE
            RETURN true;
        END IF;
    END exista;
    
    PROCEDURE p_dept (v_cod dept_gid.department_id%TYPE,
                      v_nume dept_gid.department_name%TYPE,
                      v_mgr dept_gid.manager_id%TYPE,
                      v_loc dept_gid.location_id%TYPE)
    IS
    BEGIN
        IF exista(v_mgr, v_loc) THEN
            INSERT INTO dept_gid VALUES (v_cod, v_nume, v_mgr, v_loc);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nu s-au introdus date coerente pentru tabelul dept_gid');
        END IF;
    END p_dept;

    PROCEDURE p_emp (v_prenume emp_gid.first_name%TYPE,
                     v_nume emp_gid.last_name%TYPE,
                     v_email emp_gid.email%TYPE,
                     v_telefon emp_gid.phone_number%TYPE := NULL,
                     v_data_ang emp_gid.hire_date%TYPE := SYSDATE,
                     v_job_id emp_gid.job_id%TYPE,
                     v_salariu emp_gid.salary%TYPE := 0,
                     v_comision emp_gid.commission_pct%TYPE := 0,
                     v_mgr emp_gid.manager_id%TYPE,
                     v_dept emp_gid.department_id%TYPE)
    IS
    BEGIN
        INSERT INTO emp_gid VALUES(sec_gid.NEXTVAL, v_prenume, v_nume, v_email, v_telefon,
                                   v_data_ang, v_job_id, v_salariu, v_comision, v_mgr, v_dept);
    END p_emp;
END pachet2_gid;
/


EXECUTE pachet2_gid.p_dept(50,'Economic',500,2000); 
SELECT * FROM dept_gid WHERE department_id=50; 

EXECUTE pachet2_gid.p_emp('f','l','e',v_job_id=>'j', v_mgr=>200,v_dept=>50); 
SELECT * FROM emp_gid WHERE job_id='j'; 

ROLLBACK;


/*
3. Definiti un pachet cu ajutorul caruia sa se obtina salariul maxim inregistrat pentru 
   salariatii care lucreaza intr-un anumit oras si lista salariatilor care au salariul 
   mai mare sau egal decat acel maxim. Pachetul va contine un cursor si o functie.
*/

CREATE OR REPLACE PACKAGE p3_pam AS
    CURSOR emps(nr NUMBER) RETURN employees%ROWTYPE;
    FUNCTION max_sal (oras locations.city%TYPE) RETURN NUMBER;
END p3_pam;
/

CREATE OR REPLACE PACKAGE BODY p3_pam AS
CURSOR emps(nr NUMBER) RETURN employees%ROWTYPE
    IS
    SELECT *
    FROM employees
    WHERE salary >= nr;

 

FUNCTION max_sal (oras locations.city%TYPE) RETURN NUMBER IS
    sal_maxim NUMBER;
BEGIN
    SELECT max(salary) INTO sal_maxim
    FROM employees e, departments d, locations l
    WHERE e.department_id=d.department_id AND d.location_id=l.location_id AND LOWER(city)=LOWER(oras);

    RETURN sal_maxim;
END max_sal;

END p3_pam;
/

DECLARE
    oras locations.city%TYPE:= 'London';
    sal_max NUMBER;
    lista employees%ROWTYPE;
BEGIN
    sal_max:= p3_pam.max_sal(oras);
    FOR c IN p3_pam.emps(sal_max) LOOP
        DBMS_OUTPUT.PUT_LINE(c.last_name||' '||c.first_name || ' '|| c.salary);
    END LOOP;
END;
/


/*
4. Definiti un pachet care sa contina o procedura prin care se verifica daca o combinatie 
   specificata dintre campurile employee_id si job_id este o combinatie care exista in 
   tabelul employees. 
*/

CREATE OR REPLACE PACKAGE pachet4_gid IS
    PROCEDURE p_verific (v_cod employees.employee_id%TYPE,
                         v_job employees.job_id%TYPE);
    CURSOR c_emp RETURN employees%ROWTYPE;
END pachet4_gid;
/

CREATE OR REPLACE PACKAGE BODY pachet4_gid IS
    CURSOR c_emp RETURN employees%ROWTYPE IS
        SELECT * FROM employees;
    PROCEDURE p_verific (v_cod employees.employee_id%TYPE,
                         v_job employees.job_id%TYPE)
    IS
        gasit BOOLEAN := FALSE;
        emp employees%ROWTYPE;
    BEGIN
        OPEN c_emp;
        LOOP
            FETCH c_emp INTO emp;
            EXIT WHEN c_emp%NOTFOUND;
            IF emp.employee_id = v_cod AND emp.job_id = v_job THEN
                gasit := TRUE;
            END IF;
        END LOOP;
        CLOSE c_emp;
        IF gasit = TRUE THEN
            dbms_output.put_line('combinatie existenta');
        ELSE
            dbms_output.put_line('combinatie inexistenta');
        END IF;
    END p_verific;
END pachet4_gid;
/
         
EXECUTE pachet4_gid.p_verific(2000, 'AD_ASST');                


-- Pachete predefinite

-- 1. Pachetul DBMS_OUTPUT

-- Exemplul 1

DECLARE
-- paramentrii de tip OUT pt procedura GET_LINE
    linie1 VARCHAR2(255);
    stare1 INTEGER;
    linie2 VARCHAR2(255);
    stare2 INTEGER;
    linie3 VARCHAR2(255);
    stare3 INTEGER;

    v_emp  employees.employee_id%TYPE;
    v_job  employees.job_id%TYPE;
    v_dept employees.department_id%TYPE;

BEGIN
    SELECT employee_id, job_id, department_id
    INTO   v_emp, v_job, v_dept
    FROM   employees
    WHERE  last_name = 'Lorentz';

-- se introduce o linie in buffer fara caracter 
-- de terminare linie
    DBMS_OUTPUT.PUT(' 1 ' || v_emp || ' ');

-- se incearca extragerea liniei introdusa 
-- in buffer si starea acesteia
    DBMS_OUTPUT.GET_LINE(linie1, stare1); 

-- se depunde informatie pe aceeasi linie in buffer
    DBMS_OUTPUT.PUT(' 2 ' || v_job || ' ');

-- se inchide linia depusa in buffer si se extrage 
-- linia din buffer
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.GET_LINE(linie2, stare2); 

-- se introduc informatii pe aceeasi linie 
-- si se afiseaza informatia
    DBMS_OUTPUT.PUT_LINE(' 3 ' || v_emp || ' ' || v_job);
    DBMS_OUTPUT.GET_LINE(linie3, stare3); 

-- se afiseaza ceea ce s-a extras
    DBMS_OUTPUT.PUT_LINE('linie1 = ' || linie1||
                         '; stare1 = ' || stare1);
    DBMS_OUTPUT.PUT_LINE('linie2 = ' || linie2||
                         '; stare2 = ' || stare2);
    DBMS_OUTPUT.PUT_LINE('linie3 = ' || linie3||
                         '; stare3 = ' || stare3);
END;
/ 

-- Exemplul 2

DECLARE
-- parametru de tip OUT pentru NEW_LINES  
-- tablou de siruri de caractere
    linii DBMS_OUTPUT.CHARARR;
-- paramentru de tip IN OUT pentru NEW_LINES
    nr_linii INTEGER;

    v_emp  employees.employee_id%TYPE;
    v_job  employees.job_id%TYPE;
    v_dept employees.department_id%TYPE;

BEGIN
    SELECT employee_id, job_id, department_id
    INTO   v_emp,v_job,v_dept
    FROM   employees
    WHERE  last_name='Lorentz';

-- se mareste dimensiunea bufferului 
    DBMS_OUTPUT.ENABLE(1000000);
    DBMS_OUTPUT.PUT(' 1 '||v_emp|| ' ');
    DBMS_OUTPUT.PUT(' 2 '||v_job|| ' ');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE(' 3 ' ||v_emp|| ' '|| v_job);
    DBMS_OUTPUT.PUT_LINE(' 4 ' ||v_emp|| ' '|| v_job||' ' ||v_dept);
-- se afiseaza ceea ce s-a extras
    nr_linii := 4;
    DBMS_OUTPUT.GET_LINES(linii,nr_linii); 
    DBMS_OUTPUT.put_line('In buffer sunt '|| nr_linii ||' linii');
    FOR i IN 1..nr_linii LOOP
        DBMS_OUTPUT.put_line(linii(i));
    END LOOP;
END;
/


-- 2. Pachetul DBMS_JOB

CREATE OR REPLACE PROCEDURE marire_salariu_gid
     (id_angajat emp_gid.employee_id%type,
      valoare    number)
IS
BEGIN
  UPDATE emp_gid
  SET    salary = salary + valoare
  WHERE  employee_id = id_angajat; 
END;
/

--Varianta 1

VARIABLE nr_job NUMBER

BEGIN
 DBMS_JOB.SUBMIT(
    -- intoarce numarul jobului, printr-o variabila de legatura
    JOB => :nr_job,   
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_gid(100, 1000);', 
    
    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

SELECT salary FROM emp_gid WHERE employee_id = 100;
-- asteptati 10 de secunde
SELECT salary FROM emp_gid WHERE employee_id = 100;

rollback;

-- numarul jobului
PRINT nr_job;

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_gid WHERE employee_id = 100;
BEGIN
   -- presupunand ca jobul are codul 1 atunci:
   DBMS_JOB.RUN(job => 801);
END;
/
SELECT salary FROM emp_gid WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(job=>801);
END;
/

SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS;

UPDATE emp_gid
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;

--Varianta 2

CREATE OR REPLACE PACKAGE pachet_job_gid
IS
  nr_job NUMBER;
  FUNCTION obtine_job RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE body pachet_job_gid
IS
  FUNCTION obtine_job RETURN NUMBER IS
  BEGIN
    RETURN nr_job;
  END;
END;
/

BEGIN
 DBMS_JOB.SUBMIT(
    --intoarve numarul jobului, printr-o variabila de legatura
    JOB => pachet_job_gid.nr_job,    
    
    -- codul PL/SQL care trebuie executat 
    WHAT => 'marire_salariu_gid(100, 1000);', 

    -- data de start a executiei (dupa 10 secunde)
    NEXT_DATE => SYSDATE+10/86400,  
    
    -- intervalul de timp la care se repeta executia
    INTERVAL => 'SYSDATE+1');  
   
    COMMIT;
END;
/

-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_gid.obtine_job;

-- lansarea jobului la momentul dorit
SELECT salary FROM emp_gid WHERE employee_id = 100;
BEGIN
   DBMS_JOB.RUN(JOB => pachet_job_gid.obtine_job);
END;
/
SELECT salary FROM emp_gid WHERE employee_id = 100;

-- stergerea unui job
BEGIN
   DBMS_JOB.REMOVE(JOB=>pachet_job_gid.obtine_job);
END;
/
SELECT JOB, NEXT_DATE, WHAT
FROM   USER_JOBS
WHERE  JOB = pachet_job_gid.obtine_job;

UPDATE emp_gid
SET    salary = 24000
WHERE  employee_id = 100;

COMMIT;


-- 3. Pachetul UTL_FILE

--Exemplu: Mentinem rezultatele unei comenzi SELECT intr-un fisier.

CREATE OR REPLACE PROCEDURE scriu_fisier_gid
 (director VARCHAR2,
  fisier VARCHAR2)
IS
  v_file UTL_FILE.FILE_TYPE;
  CURSOR cursor_rez IS
     SELECT department_id departament, SUM(salary) suma
     FROM employees
     GROUP BY department_id
     ORDER BY SUM(salary);
  v_rez cursor_rez%ROWTYPE;
BEGIN
 v_file:=UTL_FILE.FOPEN(director, fisier, 'w');
 UTL_FILE.PUTF(v_file, 'Suma salariilor pe departamente \n Raport generat pe data  ');
 UTL_FILE.PUT(v_file, SYSDATE);
 UTL_FILE.NEW_LINE(v_file);
 OPEN cursor_rez;
 LOOP
     FETCH cursor_rez INTO v_rez;
     EXIT WHEN cursor_rez%NOTFOUND;
     UTL_FILE.NEW_LINE(v_file);
     UTL_FILE.PUT(v_file, v_rez.departament);
     UTL_FILE.PUT(v_file, '         ');
     UTL_FILE.PUT(v_file, v_rez.suma);
 END LOOP;
 CLOSE cursor_rez;
 UTL_FILE.FCLOSE(v_file);
END;
/

SQL> EXECUTE scriu_fisier('F:\','test.txt');


-- Tema - Exercitiul 1 de la finalul fisierului
-- Deadline: miercuri 21.12.2022 ora 23:59 
