-- Lab 12 - Gr 1-2 - LABORATOR PL/SQL 7

-- 1. Remediati rand pe rand exceptiile din urmatorul exemplu.

DECLARE 
    v NUMBER;
    CURSOR c IS
        SELECT employee_id 
        FROM employees;
BEGIN
-- no data found
    SELECT employee_id 
    INTO v
    FROM employees
    WHERE employee_id = 100;
-- too many rows
    SELECT employee_id
    INTO v
    FROM employees
    WHERE employee_id = 101;
-- invalid number
    SELECT employee_id
    INTO v
    FROM employees
    --WHERE 2='s';
    WHERE last_name = 'Hunold';
-- when others
    --v := 's';
    v := 2;
-- cursor already open
    open c;
    -- open c;
EXCEPTION
 WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE (' no data found: ' ||SQLCODE || ' - ' || SQLERRM);
 WHEN TOO_MANY_ROWS THEN 
    DBMS_OUTPUT.PUT_LINE (' too many rows:  ' ||SQLCODE || ' - ' || SQLERRM);
 WHEN INVALID_NUMBER THEN 
    DBMS_OUTPUT.PUT_LINE (' invalid number: ' ||SQLCODE || ' - ' || SQLERRM);
 WHEN CURSOR_ALREADY_OPEN THEN
    DBMS_OUTPUT.PUT_LINE (' cursor already open: ' ||SQLCODE || ' - ' || SQLERRM);
 WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE (SQLCODE || ' - ' || SQLERRM);
 END;
/

select * from employees;

/*
2. Sa se creeze tabelul error_*** care va contine doua campuri: cod de tip NUMBER si mesaj de 
   tip VARCHAR2(100). Sa se creeze un bloc PL/SQL care sa permita gestiunea erorii „divide by 
   zero” in doua moduri: prin definirea unei exceptii de catre utilizator si prin captarea erorii 
   interne a sistemului. Codul si mesajul erorii vor fi introduse in tabelul error_***.
*/

CREATE TABLE error_gid
(cod    NUMBER,
 mesaj  VARCHAR2(100));

-- Varianta 1

DECLARE
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    x NUMBER;
    exceptie EXCEPTION;
BEGIN
    x := 1;
    IF x = 1 THEN 
        RAISE exceptie;
    ELSE
        x := x/(x-1);
    END IF;
EXCEPTION
    WHEN exceptie THEN
        v_cod := -20001;
        v_mesaj := 'x=1 determina o impartire la 0';
        INSERT INTO error_gid
        VALUES (v_cod, v_mesaj);
END;
/

select * from error_gid;

-- Varianta 2

DECLARE
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    x NUMBER;
BEGIN
    x := 1;
    x := x/(x-1);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        v_cod := SQLCODE;
        v_mesaj := SUBSTR(SQLERRM, 1, 100);
        INSERT INTO error_gid
        VALUES (v_cod, v_mesaj);
END;
/

/* 
3. Sa se creeze un bloc PL/SQL prin care sa se afiseze numele departamentului care functioneaza 
   intr-o anumita locatie. Daca interogarea nu întoarce nicio linie, atunci sa se trateze exceptia 
   si sa se insereze in tabelul error_*** codul erorii -20002 cu mesajul “nu exista departamente in 
   locatia data”. Daca interogarea intoarce o singura linie, atunci sa se afiseze numele departamentului. 
   Daca interogarea intoarce mai multe linii, atunci sa se introduca in tabelul error_*** codul erorii 
   -20003 cu mesajul “exista mai multe departamente in locatia data”. 
   Testati pentru urmatoarele locatii: 1400, 1700, 3000.
*/

ACCEPT p_loc PROMPT 'Dati locatia: '

DECLARE
  v_loc      dept_gid.location_id%TYPE:= &p_loc;
  v_nume     dept_gid.department_name%TYPE;
BEGIN
  SELECT   department_name
  INTO     v_nume
  FROM     dept_gid
  WHERE    location_id = v_loc;
  DBMS_OUTPUT.PUT_LINE('In locatia '|| v_loc ||
           ' functioneaza departamentul '||v_nume);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
     INSERT   INTO error_gid
     VALUES  ( -20002, 'nu exista departamente in locatia data');
     DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
  WHEN TOO_MANY_ROWS THEN
     INSERT   INTO error_gid
     VALUES   (-20003, 
                'exista mai multe departamente in locatia data');
     DBMS_OUTPUT.PUT_LINE('a aparut o exceptie ');
  WHEN OTHERS THEN
    INSERT   INTO error_gid(mesaj)
    VALUES   ('au aparut alte erori');
END;
/

select * from error_gid;

/*
4. Sa se adauge constrangerea de cheie primara pentru campul department_id din tabelul dept_*** 
   si constrangerea de cheie externa pentru campul department_id din tabelul emp_*** care refera 
   campul cu acelasi nume din tabelul dept_***. 
   Sa se creeze un bloc PL/SQL care trateaza exceptia aparuta in cazul in care se sterge un 
   departament in care lucreaza angajati (excep?ie intern? nepredefinit?)
*/

ALTER TABLE dept_gid
ADD CONSTRAINT c_pr_gid PRIMARY KEY(department_id);

ALTER TABLE emp_gid
ADD CONSTRAINT c_ex_gid FOREIGN KEY (department_id) REFERENCES dept_gid;

DELETE FROM dept_gid
WHERE department_id = 10;

ACCEPT p_cod PROMPT 'Dati un cod de departament '

DECLARE
    exceptie EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptie, -02292);
BEGIN
    DELETE FROM dept_gid
    WHERE department_id = &p_cod;
EXCEPTION
    WHEN exceptie THEN
        dbms_output.put_line('nu puteti sterge un departament in care lucreaza angajati');
END;
/


/*
5. Sa se creeze un bloc PL/SQL prin care se afiseaza numarul de salariati care au venitul anual mai 
   mare decat o valoare data. Sa se trateze cazul in care niciun salariat nu indeplineste aceasta 
   conditie (exceptii externe).
*/

ACCEPT p_val PROMPT 'Dati valoarea: '
DECLARE
  v_val          NUMBER := &p_val;
  v_numar     NUMBER(7);
  exceptie      EXCEPTION;
BEGIN
  SELECT  COUNT(*)
  INTO    v_numar
  FROM    emp_gid
  WHERE   (salary+salary*NVL(commission_pct,0))*12>v_val;
  IF v_numar = 0 THEN
     RAISE  exceptie;
  ELSE 
     DBMS_OUTPUT.PUT_LINE('NR de angajati este '||v_numar);
  END IF;

EXCEPTION
  WHEN exceptie THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista angajati pentru care sa se indeplineasca aceasta conditie');

  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Alta eroare');
END;
/


/*
6. Sa se mareasca cu 1000 salariul unui angajat al carui cod este dat de la tastatura. Sa se trateze 
   cazul in care nu exista angajatul al carui cod este specificat. Tratarea exceptiei se va face in 
   sectiunea executabila.
*/

ACCEPT p_cod PROMPT 'Dati codul '
DECLARE
    v_cod NUMBER := &p_cod;
BEGIN
    UPDATE emp_gid
    SET salary = salary + 1000
    WHERE employee_id = v_cod;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20999, 'salariatul nu exista');
    END IF;
END;
/

/*
7. Sa se afiseze numele si salariul unui angajat al carui cod este dat de la tastatura. Sa se trateze 
   cazul in care nu exista angajatul al carui cod este specificat. Tratarea exceptie se va face in 
   sectiunea de tratare a erorilor.
*/

ACCEPT p_cod PROMPT 'Dati codul: '
DECLARE
  v_cod    NUMBER := &p_cod;
  v_nume   emp_gid.last_name%TYPE;
  v_sal    emp_gid.salary%TYPE;
BEGIN  
  SELECT last_name,salary
  INTO   v_nume,v_sal
  FROM   emp_gid
  WHERE  employee_id=v_cod;
  DBMS_OUTPUT.PUT_LINE(v_nume||' '||v_sal);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20999, 'salariatul nu exista');
END;
/


/*
8. Sa se creeze un bloc PL/SQL care foloseste 3 comenzi SELECT. Una dintre aceste comenzi nu 
   va intoarce nicio linie. Sa se determine care dintre cele trei comenzi SELECT determina 
   aparitia exceptiei NO_DATA_FOUND.
*/

--Varianta 1 – fiecare comanda are un numar de ordine

DECLARE
    v_nume  emp_gid.last_name%TYPE;
    v_sal    emp_gid.salary%TYPE;
    v_job    emp_gid.job_id%TYPE;
    v_loc NUMBER := 1;
BEGIN  
    SELECT last_name
    INTO   v_nume
    FROM   emp_gid
    WHERE  employee_id=200;
    DBMS_OUTPUT.PUT_LINE(v_nume);

    v_loc := 2;
    SELECT salary
    INTO   v_sal
    FROM   emp_gid
    WHERE  employee_id=455;
    DBMS_OUTPUT.PUT_LINE(v_sal);

    v_loc := 3;
    SELECT job_id
    INTO   v_job
    FROM   emp_gid
    WHERE  employee_id=200;
    DBMS_OUTPUT.PUT_LINE(v_job);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('comanda SELECT ' || v_loc || ' nu returneaza nicio linie');
END;
/

--Varianta 2 – fiecare comanda este inclusa intr-un subbloc

DECLARE
    v_nume  emp_gid.last_name%TYPE;
    v_sal    emp_gid.salary%TYPE;
    v_job    emp_gid.job_id%TYPE;
BEGIN  
    BEGIN
        SELECT last_name
        INTO   v_nume
        FROM   emp_gid
        WHERE  employee_id=200;
        DBMS_OUTPUT.PUT_LINE(v_nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('comanda SELECT1 nu returneaza nicio linie');
    END;

    BEGIN
        SELECT salary
        INTO   v_sal
        FROM   emp_gid
        WHERE  employee_id=455;
        DBMS_OUTPUT.PUT_LINE(v_sal);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('comanda SELECT2 nu returneaza nicio linie');
    END;

    BEGIN
        SELECT job_id
        INTO   v_job
        FROM   emp_gid
        WHERE  employee_id=200;
        DBMS_OUTPUT.PUT_LINE(v_job);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('comanda SELECT3 nu returneaza nicio linie');
    END;
END;
/

/*
9. Dati un exemplu prin care sa se arate ca nu este permis saltul de la sectiunea de tratare a unei 
   exceptii, in blocul curent.
*/

DECLARE
  v_comm  NUMBER(4);
BEGIN
  SELECT ROUND(salary*NVL(commission_pct,0))
  INTO   v_comm
  FROM   emp_gid
  WHERE  employee_id=455;
<<eticheta>>
  UPDATE  emp_gid
  SET     salary=salary+v_comm
  WHERE employee_id=200;
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    v_comm:=5000;
    GOTO eticheta; 
END;
/


/*
10. Dati un exemplu prin care sa se arate ca nu este permis saltul la sectiunea de tratare a unei 
    exceptii.
*/

DECLARE
  v_comm_val  NUMBER(4);
  v_comm      emp_gid.commission_pct%TYPE;
BEGIN
  SELECT NVL(commission_pct,0),
         ROUND(salary*NVL(commission_pct,0))
  INTO   v_comm, v_comm_val
  FROM   emp_gid
  WHERE employee_id=200;
  IF v_comm=0 
   THEN 
     GOTO eticheta;
   ELSE 
     UPDATE emp_gid 
     SET salary=salary+ v_comm_val
     WHERE employee_id=200;
  END IF;
EXCEPTION
  WHEN OTHERS THEN 
  <<eticheta>>
     DBMS_OUTPUT.PUT_LINE('este o exceptie!'); 
END;
/

-- Tema - Exercitiile 1-6 de la finalul fisierului
-- Deadline: luni 16.01.2023 ora 23:59 
