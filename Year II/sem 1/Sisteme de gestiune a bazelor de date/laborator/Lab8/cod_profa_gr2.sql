-- Lab 8 - Gr 2 - LABORATOR PL/SQL 4

/*
1. Definiti un subprogram prin care sa obtineti salariul unui angajat 
   al carui nume este specificat. 
   Tratati toate exceptiile ce pot fi generate. 
   Apelati subprogramul pentru urmatorii angajati: Bell, King, Kimball. 
   Rezolvati problema folosind o functie locala.
*/

DECLARE
    nume_ang employees.last_name%TYPE := Initcap('&p_nume');
    
    FUNCTION f1 RETURN employees.salary%TYPE IS
        salariu employees.salary%TYPE;
    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE last_name = nume_ang;
        
        RETURN salariu;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Nu exista niciun angajat cu numele ' || nume_ang);
            return -1;
        WHEN TOO_MANY_ROWS THEN 
            dbms_output.put_line('Mai multi angajati cu numele ' || nume_ang);
            return -2;
        WHEN OTHERS THEN
            dbms_output.put_line('Alta eroare');
            return -3;
    END f1;
BEGIN
    IF f1 > 0 THEN
        dbms_output.put_line('Salariul este ' || f1);
    END IF;
--EXCEPTION
--    WHEN OTHERS THEN
--        dbms_output.put_line('Codul erorii este: ' || SQLCODE || ' si mesajul este ' || SQLERRM);
END;
/

-- 2. Rezolvati exercitiul 1 folosind o functie stocata.

CREATE OR REPLACE FUNCTION f2_gid(nume_ang employees.last_name%TYPE)
RETURN employees.salary%TYPE IS
    salariu employees.salary%TYPE;
BEGIN
    SELECT salary INTO salariu
    FROM employees
    WHERE last_name = nume_ang;
        
    RETURN salariu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun angajat cu numele ' || nume_ang);
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Mai multi angajati cu numele ' || nume_ang);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END f2_gid;
/


BEGIN
    dbms_output.put_line('Salariul este ' || f2_gid('King'));
END;
/

SELECT f2_gid('K') FROM dual;

VAR sal NUMBER
EXECUTE :sal := f2_gid('Bell');
PRINT sal


-- 3. Rezolvati exercitiul 1 folosind o procedura locala.

-- varianta 1 (fara parametrii)

DECLARE
    nume_ang employees.last_name%TYPE := Initcap('&p_nume');
    
    PROCEDURE p3 IS
        salariu employees.salary%TYPE;
    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE last_name = nume_ang;
        
        dbms_output.put_line('Salariul este ' || salariu);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Nu exista niciun angajat cu numele ' || nume_ang);
        WHEN TOO_MANY_ROWS THEN 
            dbms_output.put_line('Mai multi angajati cu numele ' || nume_ang);
        WHEN OTHERS THEN
            dbms_output.put_line('Alta eroare');
    END p3;
BEGIN
    p3;
END;
/


-- varianta 2 (cu parametru OUT)

DECLARE
    nume_ang employees.last_name%TYPE := Initcap('&p_nume');
    sal employees.salary%TYPE;
    
    PROCEDURE p3(salariu OUT employees.salary%TYPE) IS
    BEGIN
        SELECT salary INTO salariu
        FROM employees
        WHERE last_name = nume_ang;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun angajat cu numele ' || nume_ang);
        WHEN TOO_MANY_ROWS THEN 
            RAISE_APPLICATION_ERROR(-20001, 'Mai multi angajati cu numele ' || nume_ang);
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
    END p3;
BEGIN
    p3(sal);
    dbms_output.put_line('Salariul este ' || sal);
END;
/


-- 4. Rezolvati exercitiul 1 folosind o procedura stocata.

-- varianta 1 (fara parametru OUT)

CREATE OR REPLACE PROCEDURE p4_gid(nume_ang employees.last_name%TYPE)
IS
    salariu employees.salary%TYPE;
BEGIN
    SELECT salary INTO salariu
    FROM employees
    WHERE last_name = nume_ang;
        
    dbms_output.put_line('Salariul este ' || salariu);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun angajat cu numele ' || nume_ang);
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Mai multi angajati cu numele ' || nume_ang);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END p4_gid;
/

BEGIN
    p4_gid('Bell');
END;
/

-- varianta 2 (cu parametru OUT)

CREATE OR REPLACE PROCEDURE p4_gid(nume_ang employees.last_name%TYPE,
                                   salariu OUT employees.salary%TYPE)
IS
BEGIN
    SELECT salary INTO salariu
    FROM employees
    WHERE last_name = nume_ang;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun angajat cu numele ' || nume_ang);
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Mai multi angajati cu numele ' || nume_ang);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END p4_gid;
/

DECLARE
    sal employees.salary%TYPE;
BEGIN
    p4_gid('Bell', sal);
    dbms_output.put_line('Salariul este ' || sal);
END;
/

/*
5. Creati o procedura stocata care primeste printr-un parametru codul 
   unui angajat si returneaza prin intermediul aceluiasi parametru codul 
   managerului corespunzator acelui angajat (parametru de tip IN OUT).
*/

CREATE OR REPLACE PROCEDURE p5_gid(nr IN OUT employees.employee_id%TYPE)
IS
BEGIN
    SELECT manager_id INTO nr
    FROM employees
    WHERE employee_id = nr;
END p5_gid;
/

DECLARE
    ang employees.employee_id%TYPE := 200;
BEGIN
    p5_gid(ang);
    dbms_output.put_line('Manager ' || ang);
END;
/

/*
6. Declarati o procedura locala care are parametrii: 
   - rezultat (parametru de tip OUT) de tip last_name din employees;
   - comision (parametru de tip IN) de tip commission_pct din employees, 
     initializat cu NULL;
   - cod (parametru de tip IN) de tip employee_id din employees, initializat cu NULL.
   Daca comisionul nu este NULL atunci in rezultat se va memora numele salariatului 
   care are comisionul respectiv. In caz contrar, in rezultat se va memora numele 
   salariatului al carui cod are valoarea data in apelarea procedurii.
*/

DECLARE
    nume employees.last_name%TYPE;
    
    PROCEDURE p6 (rezultat OUT employees.last_name%TYPE,
                  comision IN employees.commission_pct%TYPE := NULL,
                  cod IN employees.employee_id%TYPE := NULL)
    IS
    BEGIN
        IF comision IS NULL THEN
            SELECT last_name INTO rezultat
            FROM employees
            WHERE employee_id = cod;
        ELSE
            SELECT last_name INTO rezultat
            FROM employees
            WHERE commission_pct = comision;
        END IF;
    END p6;
BEGIN
    p6(nume, 0.4);
    dbms_output.put_line(nume);
    p6(nume, cod => 200);
    dbms_output.put_line(nume);
END;
/


/*
7. Definiti doua functii locale cu acelasi nume (overload) care sa calculeze media 
   salariilor astfel:
   - prima functie va avea ca argument codul departamentului, adica functia calculeaza
     media salariilor din departamentul specificat;
   - a doua functie va avea doua argumente, unul reprezentand codul departamentului, 
     iar celalalt reprezentand job-ul, adica functia va calcula media salariilor 
     dintr-un anumit departament si care apartin unui job specificat.
*/

DECLARE
    medie1 NUMBER;
    medie2 NUMBER;
    
    FUNCTION medie (v_dept employees.department_id%TYPE)
    RETURN NUMBER
    IS
        rezultat NUMBER;
    BEGIN
        SELECT avg(salary) INTO rezultat
        FROM employees
        WHERE department_id = v_dept;
        
        RETURN rezultat;
    END;
    
    FUNCTION medie (v_dept employees.department_id%TYPE,
                    v_job employees.job_id%TYPE)
    RETURN NUMBER
    IS
        rezultat NUMBER;
    BEGIN
        SELECT avg(salary) INTO rezultat
        FROM employees
        WHERE department_id = v_dept
        AND job_id = v_job;
        
        RETURN rezultat;
    END;
BEGIN
    medie1 := medie(80);
    dbms_output.put_line('Media departamentului este ' || medie1);
    medie2 := medie(80, 'SA_MAN');
    dbms_output.put_line('Media departametului si jobului este ' || medie2);
END;
/

-- 8. Calculati recursiv factorialul unui numar dat (recursivitate).

CREATE OR REPLACE FUNCTION factorial_gid(n NUMBER)
RETURN NUMBER
IS
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE 
        RETURN n * factorial_gid(n - 1);
    END IF;
END;
/

BEGIN
    dbms_output.put_line(factorial_gid(5));
END;
/

/*
9. Afisati numele si salariul angajatilor al caror salariu este mai mare decat media 
   tuturor salariilor. Media salariilor va fi obtinuta prin apelarea unei functii stocate.
*/

CREATE OR REPLACE FUNCTION medie_gid
RETURN NUMBER
IS  
    rezultat NUMBER;
BEGIN
    SELECT avg(salary)
    into rezultat
    FROM employees;
    RETURN rezultat;
END;
/

SELECT last_name,salary
FROM employees
WHERE salary >= medie_gid;


-- Tema - Exercitiile 1-6 de la finalul fisierului
-- Deadline: miercuri 7.12.2022 ora 23:59 

