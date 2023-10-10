-- Lab 6-7 - Gr 2 - LABORATOR PL/SQL 3

/*
1. Obtineti pentru fiecare departament numele acestuia si numarul de angajati, 
   intr-una din urmatoarele forme:
   “ In departamentul <nume departament> nu lucreaza angajati”.
   “ In departamentul <nume departament> lucreaza un angajat”.
   “ In departamentul <nume departament> lucreaza <numar> angajati”.
   Rezolvati problema folosind un cursor explicit.
*/

SELECT department_name, count(employee_id)
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
GROUP BY department_name;

DECLARE
    CURSOR c IS
        SELECT department_name, count(employee_id)
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+) -- AND 1 = 0
        GROUP BY department_name;
    v_nume departments.department_name%TYPE;
    v_nr NUMBER;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%NOTFOUND;
        IF v_nr = 0 THEN
            dbms_output.put_line('In departamentul ' || v_nume || ' nu lucreaza angajati');
        ELSIF v_nr = 1 THEN
            dbms_output.put_line('In departamentul ' || v_nume || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul ' || v_nume || ' lucreaza ' || v_nr || ' angajati');
        END IF;
    END LOOP;
    
    IF v_nume IS NULL THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

-- Rezolvati problema in SQL.

WITH aux as (
SELECT department_name as nume, count(employee_id) as nr
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
GROUP BY department_name)
SELECT CASE WHEN aux.nr = 0 THEN 'Departamentul ' || aux.nume || ' are 0 angajati'
            WHEN aux.nr = 1 THEN 'Departamentul ' || aux.nume || ' are 1 angajat'
            ELSE 'Departamentul ' || aux.nume || ' are ' || aux.nr || ' angajat' END
FROM aux;

select case when v_nr=0 then 'In departamentul '|| v_nume || ' nu lucreaza angajati'
            when v_nr=1 then 'In departamentul '|| v_nume || ' lucreaza un angajat'
            else 'In departamentul '|| v_nume || ' lucreaza '|| v_nr ||' angajati'
       end
from (select department_name v_nume, count(employee_id) v_nr
      from departments d, employees e
      where d.department_id=e.department_id (+)
      group by department_name);

/*
2. Rezolvati exercitiul 1 mentinand informatiile din cursor in colectii. Comentati. 
   Procesati toate liniile din cursor, incarcand la fiecare pas cate 5 linii.
*/

DECLARE
    CURSOR c IS
        SELECT department_name, count(employee_id)
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+) -- AND 1 = 0
        GROUP BY department_name;
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER;
    t_nume tab_nume;
    t_nr tab_nr;
BEGIN
    OPEN c;
    LOOP
        FETCH c BULK COLLECT INTO t_nume, t_nr LIMIT 5;
        EXIT WHEN c%NOTFOUND;
        FOR i IN t_nr.first..t_nr.last LOOP
            IF t_nr(i) = 0 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati');
            ELSIF t_nr(i) = 1 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza un angajat');
            ELSE
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati');
            END IF;
        END LOOP;
    END LOOP;
    
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

-- Rezolvati problema folosind cursorul si o singura colectie.

DECLARE
    TYPE rec IS RECORD (nume departments.department_name%TYPE, nr NUMBER(4));
    TYPE tab_nume_nr IS TABLE OF rec INDEX BY PLS_INTEGER;
    t_nume_nr tab_nume_nr;
    CURSOR c IS
        SELECT department_name nume, COUNT(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id=e.department_id(+)
        GROUP BY department_name;
BEGIN
    OPEN c;
    FETCH c BULK COLLECT INTO t_nume_nr;
    CLOSE c;
    FOR i IN t_nume_nr.FIRST..t_nume_nr.LAST LOOP
    IF t_nume_nr(i).nr=0 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume_nr(i).nume||' nu lucreaza angajati');
    ELSIF t_nume_nr(i).nr=1 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume_nr(i).nume|| ' lucreaza un angajat');
    ELSE
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume_nr(i).nume|| ' lucreaza '|| t_nume_nr(i).nr||' angajati');
END IF;
END LOOP;
END;
/

DECLARE
    CURSOR c IS
        SELECT department_name, count(employee_id) as nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+)
        GROUP BY department_name;
    TYPE tab_nume IS TABLE OF c%ROWTYPE;
    t_nume tab_nume;
BEGIN
    OPEN c;
    LOOP
        FETCH c BULK COLLECT INTO t_nume LIMIT 5;
        EXIT WHEN c%NOTFOUND;
        FOR i IN t_nume.FIRST..t_nume.LAST LOOP
            IF t_nume(i).nr = 0 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' nu lucreaza angajati');
            ELSIF t_nume(i).nr = 1 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' lucreaza 1 angajat');
            ELSE
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' lucreaza ' || t_nume(i).nr || ' angajati');
            END IF;
        END LOOP;
    END LOOP;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

-- Rezolvati problema folosind doar colectii. 

DECLARE
    TYPE rec IS RECORD (nume departments.department_name%TYPE, nr NUMBER(4));
    TYPE tab_nume_nr IS TABLE OF rec INDEX BY PLS_INTEGER;
    t_nume_nr tab_nume_nr;
BEGIN
    SELECT department_name nume, COUNT(employee_id) nr BULK COLLECT INTO t_nume_nr
    FROM departments d, employees e
    WHERE d.department_id=e.department_id(+)
    GROUP BY department_name;
    
    FOR i IN t_nume_nr.FIRST..t_nume_nr.LAST LOOP
    IF t_nume_nr(i).nr=0 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume_nr(i).nume||' nu lucreaza angajati');
    ELSIF t_nume_nr(i).nr=1 THEN
        DBMS_OUTPUT.PUT_LINE('In departamentul '||t_nume_nr(i).nume|| ' lucreaza un angajat');
    ELSE
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| t_nume_nr(i).nume|| ' lucreaza '|| t_nume_nr(i).nr||' angajati');
END IF;
END LOOP;
END;
/

DECLARE
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER;
    t_nume tab_nume;
    t_nr tab_nr;
BEGIN
    SELECT department_name, count(employee_id) BULK COLLECT INTO t_nume, t_nr
    FROM departments d, employees e
    WHERE d.department_id = e.department_id(+)
    GROUP BY department_name;
     
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati');
        ELSIF t_nr(i) = 1 THEN                
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza 1 angajat');
        ELSE
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati');
        END IF;
    END LOOP;
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/


-- 3. Rezolvati exercitiul 1 folosind un ciclu cursor.


DECLARE
    CURSOR c IS
        SELECT department_name nume, count(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+) --AND 1 = 0
        GROUP BY department_name;
    nr NUMBER := 0;
BEGIN
    FOR i IN C LOOP
        nr := nr + 1;
        dbms_output.put_line(c%ROWCOUNT);
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;

    
    IF nr = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/

-- 4. Rezolvati exercitiul 1 folosind un ciclu cursor cu subcereri. 


DECLARE
    nr NUMBER := 0;
BEGIN
    FOR i IN ( SELECT department_name nume, count(employee_id) nr
                FROM departments d, employees e
                WHERE d.department_id = e.department_id(+) --AND 1 = 0
                GROUP BY department_name) LOOP
        nr := nr + 1;
        dbms_output.put_line(nr);
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza un angajat');
        ELSE
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;

    
    IF nr = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/

/*
5. Obtineti primii 3 manageri care au cei mai multi subordonati. 
   Afisati numele managerului, respectiv numarul de angajati.
   a. Rezolvati problema folosind un cursor explicit.
*/

SELECT sef.last_name, count(ang.employee_id) nr
FROM employees sef, employees ang
WHERE ang.manager_id = sef.employee_id
GROUP BY sef.last_name
ORDER BY nr DESC;

DECLARE
    CURSOR c IS SELECT sef.last_name, count(ang.employee_id) nr
                FROM employees sef, employees ang
                WHERE ang.manager_id = sef.employee_id
                GROUP BY sef.last_name
                ORDER BY nr DESC;
    v_nume employees.last_name%TYPE;
    v_nr NUMBER;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%NOTFOUND OR c%ROWCOUNT > 3;
        dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_nr || ' angajati');
    END LOOP;
    CLOSE c;
END;
/

/*
   b. Modificati rezolvarea anterioara astfel incat sa obtineti primii 4 manageri
      care indeplinesc conditia. Observati rezultatul obtinut si specificati daca 
      la punctul a s-a obtinut top 3 manageri? 
*/

DECLARE
    CURSOR c IS SELECT sef.last_name, count(ang.employee_id) nr
                 FROM employees sef, employees ang
                 WHERE ang.manager_id = sef.employee_id
                 GROUP BY sef.last_name
                 ORDER BY nr DESC;
    v_nume employees.last_name%TYPE;
    v_nr NUMBER;
    v_prec NUMBER;
    v_top NUMBER := 1;
BEGIN
    OPEN c;
    FETCH c INTO v_nume, v_prec;
    dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_prec || ' angajati');
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%NOTFOUND;
        IF v_nr <> v_prec THEN
            v_top := v_top + 1;
        END IF;
        EXIT WHEN v_top = 4;
        dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_nr || ' angajati');
        v_prec := v_nr;
    END LOOP;
    CLOSE c;
END;
/

-- Rezolvati problema in SQL.

WITH aux AS
(SELECT sef.last_name nume, count(ang.employee_id) nr
FROM employees sef, employees ang
WHERE ang.manager_id = sef.employee_id
GROUP BY sef.last_name)
SELECT 'Manager ' || nume || ' conduce ' || nr || ' angajati'
FROM aux a
WHERE 2 >= (SELECT COUNT(DISTINCT nr)
            FROM aux
            WHERE nr > a.nr)
ORDER BY nr DESC;

-- 6. Rezolvati exercitiul 5 folosind un ciclu cursor.

DECLARE
    CURSOR c IS SELECT sef.last_name nume, count(ang.employee_id) nr
                FROM employees sef, employees ang
                WHERE ang.manager_id = sef.employee_id
                GROUP BY sef.last_name
                ORDER BY nr DESC;
BEGIN
    FOR i IN c LOOP
        EXIT WHEN c%ROWCOUNT > 3;
        dbms_output.put_line('Managerul ' || i.nume || ' conduce ' || i.nr || ' angajati');
    END LOOP;
END;
/

-- 7. Rezolvati exercitiul 5 folosind un ciclu cursor cu subcereri.

DECLARE
    counter NUMBER := 0;
BEGIN
    FOR i IN (SELECT sef.last_name nume, count(ang.employee_id) nr
              FROM employees sef, employees ang
              WHERE ang.manager_id = sef.employee_id
              GROUP BY sef.last_name
              ORDER BY nr DESC) LOOP
        dbms_output.put_line('Managerul ' || i.nume || ' conduce ' || i.nr || ' angajati');
        counter := counter + 1;
        EXIT WHEN counter = 3;
    END LOOP;
END;
/

/*
8. Modificati exercitiul 1 astfel incat sa obtineti doar departamentele in care 
   lucreaza cel putin x angajati, unde x reprezinta un numar introdus de la tastatura. 
   Rezolvati problema folosind toate cele trei tipuri de cursoare studiate.
*/

-- cursor explicit
DECLARE
    x NUMBER(4) := &p_x;
    v_nr NUMBER(4);
    v_nume departments.department_name%TYPE;
    CURSOR c (minim NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> minim;
BEGIN
    OPEN c(x);
    LOOP
        FETCH c INTO v_nume,v_nr;
        EXIT WHEN c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||' lucreaza '|| v_nr||' angajati');
    END LOOP;
    CLOSE c;
END;
/

--ciclu cursor
DECLARE
    x NUMBER(4) := &p_x;
    CURSOR c (minim NUMBER) IS
        SELECT department_name nume, COUNT(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id=e.department_id
        GROUP BY department_name
        HAVING COUNT(employee_id)> minim;
BEGIN
    FOR i in c(x) LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' lucreaza '|| i.nr||' angajati');
    END LOOP;
END;
/

--ciclu cursor cu subcereri
DECLARE
    x NUMBER(4) := &p_x;
BEGIN
    FOR i in (SELECT department_name nume, COUNT(employee_id) nr
                FROM departments d, employees e
                WHERE d.department_id=e.department_id
                GROUP BY department_name
                HAVING COUNT(employee_id)> x) LOOP
        DBMS_OUTPUT.PUT_LINE('In departamentul '|| i.nume||' lucreaza '|| i.nr||' angajati');
    END LOOP;
END;
/


/*
9. Mariti cu 1000 salariile celor care au fost angajati în 2000 (din tabelul emp_***) 
   blocand liniile inainte de actualizare (cursor SELECT FOR UPDATE).
*/

DECLARE
    CURSOR c IS SELECT *
                FROM emp_gid
                WHERE to_char(hire_date, 'YYYY') = 2000
                FOR UPDATE WAIT 5;
BEGIN
    FOR i IN c LOOP
        UPDATE emp_gid
        SET salary = salary + 1000
        WHERE CURRENT OF c;
    END LOOP;
END;
/
rollback;

/*
10. Pentru fiecare dintre departamentele 10, 20, 30 si 40, obtineti numele precum si 
    lista numelor angajatilor care isi desfasoara activitatea in cadrul acestora. 
    Rezolvati problema folosind:
    a. ciclu cursor cu subcereri;
*/

BEGIN
    FOR dept IN (SELECT department_id, department_name
                    FROM departments
                    WHERE department_id IN (10,20,30,40))LOOP
    DBMS_OUTPUT.PUT_LINE (dept.department_name|| ': ');
        FOR emp IN (SELECT last_name, first_name
                    FROM employees
                    WHERE department_id = dept.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE (emp.last_name || ' ' || emp.first_name);
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
/

--  b. expresii cursor. 

DECLARE
    CURSOR c_dept IS SELECT department_name, 
                            CURSOR (SELECT first_name || ' ' || last_name
                                    FROM employees e
                                    WHERE e.department_id = d.department_id)
                     FROM departments d
                     WHERE department_id IN (10, 20, 30, 40);
    v_nume_dept departments.department_name%TYPE;
    v_nume_ang VARCHAR2(50);
    TYPE refcursor IS REF CURSOR;
    v_cursor refcursor;
BEGIN
    OPEN c_dept;
    LOOP
        FETCH c_dept INTO v_nume_dept, v_cursor;
        EXIT WHEN c_dept%NOTFOUND;
        dbms_output.put_line('Departament ' || v_nume_dept);
        LOOP 
            FETCH v_cursor INTO v_nume_ang;
            EXIT WHEN v_cursor%NOTFOUND;
            dbms_output.put_line(v_nume_ang);
        END LOOP;
        dbms_output.new_line;
    END LOOP;
    CLOSE c_dept;
END;
/


/*
11. Declarati un cursor dinamic care intoarce linii de tipul celor din tabelul emp_***. 
    In functie de o optiune introdusa de la tastatura (una dintre valorile 1, 2 sau 3) 
    deschideti cursorul astfel incat sa regaseasca:
    - toate informatiile din tabelul emp_*** (pentru optiunea 1);
    - doar angajatii avand salariul cuprins intre 10000 si 20000 (pentru optiunea 2);
    - doar salariatii angajati in anul 2000 (pentru optiunea 3).
    Verificati ce se intampla in cazul in care introduceti o valoare diferita de 1, 2 sau 3. 
    Modificati corespunzator
*/

DECLARE 
    TYPE emp_tip IS REF CURSOR RETURN employees%ROWTYPE;
    v_emp emp_tip;
    optiune NUMBER := &optiune;
    v_ang employees%ROWTYPE;
BEGIN
    IF optiune = 1 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees;
    ELSIF optiune = 2 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees
                       WHERE salary BETWEEN 10000 AND 20000;
    ELSIF optiune = 3 THEN
        OPEN v_emp FOR SELECT *
                       FROM employees
                       WHERE to_char(hire_date, 'YYYY') = 2000;
    ELSE
        dbms_output.put_line('Optiune incorecta');
    END IF;
    
    IF v_emp%ISOPEN THEN
        LOOP
            FETCH v_emp INTO v_ang;
            EXIT WHEN v_emp%NOTFOUND;
            dbms_output.put_line(v_emp%ROWCOUNT || '. ' || v_ang.last_name);
        END LOOP;
        CLOSE v_emp;
    END IF;
END;
/

/*
12. Cititi de la tastatura o valoare n. Prin intermediul unui cursor deschis cu ajutorul 
    unui sir dinamic obtineti angajatii avand salariul mai mare decat n. Pentru fiecare 
    linie regasita de cursor afisati urmatoarele informatii: 
    - numele si salariul daca angajatul nu are comision;
    - numele, salariul si comisionul daca angajatul are comision.
*/

DECLARE
    TYPE empref IS REF CURSOR;
    v_emp empref;
    v_nr INTEGER := &n;
    nume employees.last_name%TYPE;
    sal employees.salary%TYPE;
    cms employees.commission_pct%TYPE;
BEGIN
    OPEN v_emp FOR
        'SELECT last_name, salary, commission_pct ' ||
        'FROM employees WHERE salary > :bind_var'
        USING v_nr;
    
    LOOP
        FETCH v_emp INTO nume, sal, cms;
        EXIT WHEN v_emp%NOTFOUND;
        IF cms IS NULL THEN
            dbms_output.put_line(nume || ' ' || sal);
        ELSE
            dbms_output.put_line(nume || ' ' || sal || ' ' || cms || '%');
        END IF;
    END LOOP;
    
    CLOSE v_emp;
END;
/

-- Tema - Exercitiile 1-5 de la finalul fisierului
-- Obs. Pentru ex 1 si 2 rezolvati folosind toate cele 4 tipuri de cursoare,
--      iar pentru 3, 4 si 5 rezolvati alegand doar unul dintre cele 4 tipuri.
-- Deadline: miercuri 23.11.2022 ora 23:59 
