-- Lab 3-4 - Gr 2 - LABORATOR PL/SQL 1

-- 1. Evaluati urmatoarele declaratii de variabile:

DECLARE
--  v_nume, v_prenume VARCHAR2(35); -- incorect, fiecare variabila trebuie
                                    -- declarata pe un rand separat
    v_nume VARCHAR2(35); -- corect
    v_prenume VARCHAR2(35);
BEGIN
    null;
END;
/

DECLARE
    v_nr NUMBER(4); -- corect
BEGIN
    null;
END;
/

DECLARE
--  v_nr NUMBER(5, 2) = 10; -- incorect, pentru atribuire folosim
                            -- ':=' nu '=' 
    v_nr NUMBER(5, 2) := 10; -- corect
BEGIN
    null;
END;
/

DECLARE
--  v_test BOOLEAN := SYSDATE; -- incorect, nu se realizeaza conversia
    v_test BOOLEAN := TRUE; -- corect
BEGIN
    null;
END;
/

DECLARE
    v1 NUMBER(5) := 10;
    v2 NUMBER(5) := 15;
--  v3 NUMBER(5) := v1 < v2 -- incorect, nu se realizeaza conversia
    v3 BOOLEAN := v1 < v2; -- corect
BEGIN
    null;
END;
/


-- 2. Se da urmatorul bloc PL/SQL:

<<principal>>
DECLARE
    v_client_id NUMBER(4) := 1600;
    v_client_name VARCHAR2(50) := 'N1';
    v_nou_client_id NUMBER(4) := 500;
BEGIN
    <<secundar>>
    DECLARE
        v_client_id NUMBER(4) := 0;
        v_client_name VARCHAR2(50) := 'N2';
        v_nou_client_id NUMBER(4) := 300;
        v_nou_client_name VARCHAR2(50) := 'N3';
    BEGIN
        v_client_id := v_nou_client_id;
        principal.v_client_name := v_client_name || ' ' ||
                                   v_nou_client_name;
        --pozitia 1
        dbms_output.put_line(v_client_id);
        dbms_output.put_line(v_client_name);
        dbms_output.put_line(v_nou_client_id);
        dbms_output.put_line(v_nou_client_name);
    END;
    v_client_id := (v_client_id*12)/10;
    --pozitia 2
    dbms_output.put_line(v_client_id);
    dbms_output.put_line(v_client_name);
END;
/

/*
Determinati:
- valoarea variabilei v_client_id la pozitia 1; - 300
- valoarea variabilei v_client_nume la pozitia 1; - N2
- valoarea variabilei v_nou_client_id la pozitia 1; - 300
- valoarea variabilei v_nou_client_nume la pozitia 1; - N3
- valoarea variabilei v_client_id la pozitia 2; - 1920
- valoarea variabilei v_client_nume la pozitia 2; N2 N3
*/


-- 3. Creati un bloc anonim care sa afiseze propozitia 
--    "Invat PL/SQL" pe ecran.

-- Varianta 1 - Afisare folosind variabile de legatura

VAR g_mesaj VARCHAR2(50)

BEGIN
    :g_mesaj := 'Invat PL/SQL';
END;
/

PRINT g_mesaj

-- Varianta 2 - Afisare folosind procedurile din pachetul 
-- standard DBMS_OUTPUT

BEGIN
    dbms_output.put_line('Invat PL/SQL');
END;
/


/*
4. Definiti un bloc anonim in care sa se afle numele 
   departamentului cu cei mai multi angajati.
   Comentati cazul in care exista cel putin doua departamente 
   cu numar maxim de angajati.
*/

select department_name
from employees e, departments d
where e.department_id = d.department_id
group by department_name
having count(*) = (SELECT max(count(*))
                   from employees
                   group by department_id);
                   
DECLARE
    v_dep departments.department_name%TYPE;
BEGIN
    select department_name
    into v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (SELECT max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep);
END;
/

-- pentru a testa cazul in care select-ul ne intoarce mai multe
-- linii inlocuim semnul '=' din having cu '<>'

DECLARE
    v_dep departments.department_name%TYPE;
BEGIN
    SELECT department_name
    into v_dep
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) <> (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Mai multe linii');
END;
/

/*
5. Rezolvati problema anterioara utilizand variabile de leg?tur?. 
   Afisati rezultatul atat din bloc, cat si din exteriorul acestuia.
*/

VAR rezultat VARCHAR2(35)

BEGIN
    select department_name
    into :rezultat
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (SELECT max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || :rezultat);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Mai multe linii');
END;
/

PRINT rezultat;


/*
6. Modificati exercitiul anterior astfel incat sa obtineti si numarul 
   de angajati din departamentul respectiv.
*/

DECLARE
    v_dep_name departments.department_name%TYPE;
    v_nr_ang NUMBER(4);
BEGIN
    select department_name, count(*) as nr_ind
    into v_dep_name, v_nr_ang
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep_name || ' are ' || v_nr_ang || ' angajati');
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Mai multe linii');
END;
/

-- sau

VAR rezultat VARCHAR2(35)
VAR nr NUMBER

BEGIN
    SELECT department_name, count(*)
    into :rezultat, :nr
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees
                       group by department_id);
    dbms_output.put_line('Departamentul ' || :rezultat || ' cu ' || :nr || ' angajati');
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Mai multe linii');
END;
/

PRINT rezultat
PRINT nr


/*
7. Determinati salariul anual si bonusul pe care il primeste un salariat al 
   carui cod este dat de la tastatura. Bonusul este determinat astfel: daca 
   salariul anual este cel putin 200001, atunci bonusul este 20000; daca salariul
   anual este cel putin 100001 si cel mult 200000, atunci bonusul este 10000, iar 
   daca salariul anual este cel mult 100000, atunci bonusul este 5000. Afisati 
   bonusul obtinut. Comentati cazul in care nu exista niciun angajat cu codul introdus.
   Obs. Se foloseste instructiunea IF.
*/

SET VERIFY OFF
DECLARE
    v_cod employees.employee_id%TYPE := &p_cod;
    v_salariu_anual NUMBER;
    v_bonus NUMBER;
BEGIN
    SELECT salary*12 INTO v_salariu_anual
    FROM employees
    WHERE employee_id = v_cod;
    
    IF v_salariu_anual >= 200001 THEN
        v_bonus := 20000;
    ELSIF v_salariu_anual BETWEEN 100001 AND 200000 THEN
        v_bonus := 10000;
    ELSIF v_salariu_anual <= 100000 THEN
        v_bonus := 5000;
    END IF;
    
    dbms_output.put_line('Bonusul este ' || v_bonus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista niciun angajat cu codul ' || v_cod);
END;
/
SET VERIFY ON

select employee_id, salary*12
from employees;


-- 8. Rezolvati problema anterioara folosind instructiunea CASE.

DECLARE
    v_cod employees.employee_id%TYPE := &p_cod;
    v_salariu_anual NUMBER;
    v_bonus NUMBER;
BEGIN
    SELECT salary*12 INTO v_salariu_anual
    FROM employees
    WHERE employee_id = v_cod;
    
    CASE
    WHEN v_salariu_anual >= 200001 THEN
        v_bonus := 20000;
    WHEN v_salariu_anual >= 100001 THEN
        v_bonus := 10000;
    ELSE v_bonus := 5000;
    END CASE;
    
    dbms_output.put_line('Bonusul este ' || v_bonus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista niciun angajat cu codul ' || v_cod);
END;
/



/*
9. Scrieti un bloc PL/SQL in care stocati prin variabile de substitutie un cod de 
   angajat, un cod de departament si procentul cu care se mareste salariul acestuia. 
   Sa se mute salariatul in noul departament si sa i se creasca salariul in mod 
   corespunzator. Daca modificarea s-a putut realiza (exista in tabelul emp_*** un 
   salariat avand codul respectiv) sa se afiseze mesajul “Actualizare realizata”, 
   iar in caz contrar mesajul “Nu exista un angajat cu acest cod”. 
   Anulati modificarile realizate.
*/

DEFINE p_cod_sal = 200
DEFINE p_cod_dept = 80
DEFINE p_procent = 20
DECLARE
    v_cod_sal emp_gid.employee_id%TYPE := &p_cod_sal;
    v_cod_dept emp_gid.department_id%TYPE := &p_cod_dept;
    v_procent NUMBER := &p_procent;
BEGIN
    UPDATE emp_gid
    SET department_id = v_cod_dept,
        salary = salary + (salary*v_procent/100)
    WHERE employee_id = v_cod_sal;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    ELSE
        dbms_output.put_line('Actualizare realizata');
    END IF;
END;
/
ROLLBACK;


/*
10. Creati tabelul zile_***(id, data, nume_zi). Introduceti in tabelul zile_*** 
    informatiile corespunzatoare tuturor zilelor care au ramas din luna curenta.
    Obs. Folositi instructiunea LOOP.
*/

CREATE TABLE zile_gid(
    id NUMBER PRIMARY KEY,
    data DATE,
    nume_zi VARCHAR2(20)
);

DECLARE
    contor NUMBER := 1;
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_gid
        VALUES(contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
        EXIT WHEN contor > maxim;
    END LOOP;
END;
/
rollback;

select * from zile_gid;

alter session
set nls_language = 'ROMANIAN';
alter session
set nls_language = 'ENGLISH';


-- 11. Rezolvati cerinta anterioara folosind instructiunea WHILE.

DECLARE
    contor NUMBER := 1;
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    WHILE contor <= maxim LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_rs
        VALUES(contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
    END LOOP;
END;
/


-- 12. Rezolvati cerinta anterioara folosind instructiunea FOR.

DECLARE
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    FOR contor IN 1..maxim LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_td
        VALUES(contor, v_data, to_char(v_data, 'Day'));
    END LOOP;
END;
/

/*
13. Sa se declare si sa se initializeze cu 1 variabila i de tip POZITIVE
    si cu 10 constanta max_loop de tip POZITIVE. Sa se implementeze un ciclu 
    LOOP care incrementeaza pe i pana cand acesta ajunge la o valoare > max_loop, 
    moment in care ciclul LOOP este parasit si se sare la instructiunea i:=1.
    Obs. Se utilizeaza instructiunile GOTO/EXIT.
*/

-- Varianta 1 - GOTO

DECLARE
    i POSITIVE := 1;
    max_loop CONSTANT POSITIVE := 10;
BEGIN
    LOOP
        i := i + 1;
        IF i > max_loop THEN
            dbms_output.put_line('in loop i=' || i);
            GOTO urmator;
        END IF;
    END LOOP;
    <<urmator>>
    i := 1;
    dbms_output.put_line('dupa loop i=' || i);
END;
/

-- Varianta 2 - EXIT

DECLARE
    i POSITIVE := 1;
    max_loop CONSTANT POSITIVE := 10;
BEGIN
    LOOP
        i := i + 1;
        dbms_output.put_line('in loop i=' || i);
        EXIT WHEN i > max_loop;
    END LOOP;
    i := 1;
    dbms_output.put_line('dupa loop i=' || i);
END;
/


-- Tema - Exercitii 1-5 de la finalul fisierului
-- Deadline: miercuri 02.11.2022 ora 23:59 


