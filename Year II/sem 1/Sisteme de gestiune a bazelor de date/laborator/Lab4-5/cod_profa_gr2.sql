-- Lab 4-5 - Gr 2 - LABORATOR PL/SQL 2

-- 1. Care este rezultatul urmatorului bloc PL/SQL?

DECLARE
    x NUMBER := 5;
    y x%TYPE := NULL;
BEGIN
    IF x <> y THEN
        dbms_output.put_line('valoare <> null este = true');
    ELSE
        dbms_output.put_line('valoare <> null este != true');
    END IF;
    
    x := NULL;
    
    IF x = y THEN
        dbms_output.put_line('null = null este = true');
    ELSE
        dbms_output.put_line('null = null este != true');
    END IF;
END;
/

-- Raspuns:
-- valoare <> null este != true
-- null = null este != true
-- deoarece orice comparatie ce implica null va fi evaluata la null si astfel
-- se va intra pe ramurile else ale if-urilor


/*
2. Definiti tipul inregistrare emp_record care contine campurile 
   employee_id, salary si job_id. Apoi, definiti o variabila de acest tip.
*/

-- a. Initializati variabila definita. Afisati variabila.

DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
--    v_ang.cod := 700;
--    v_ang.salariu := 9000;
--    v_ang.job := 'SA_MAN';
    SELECT 700, 9000, 'SA_MAN'
    INTO v_ang
    FROM dual;
    
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod ||
        ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

-- b. Initializati variabila cu valorile corespunzatoare angajatului avand codul 101. 
--    Afisati variabila.

DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    /******** In loc de ...
    * SELECT employee_id, salary, job_id
    * INTO v_ang.cod, v_ang.salariu, v_ang.job
    * FROM employees
    * WHERE employee_id = 101;
    *******************************/
    
    SELECT employee_id, salary, job_id
    INTO v_ang
    FROM employees
    WHERE employee_id = 101;
    
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod ||
        ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

-- c. Stergeti angajatul avand codul 100 din tabelul emp_*** si retineti in variabila 
--    definita anterior informatii corespunzatoare acestui angajat. 
--    Anulati modificarile realizate.

DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    
    DELETE FROM emp_gid
    WHERE employee_id = 100
    RETURNING employee_id, salary, job_id INTO v_ang;
    
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod ||
        ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/
rollback;


/*
3. Declarati doua variabile cu aceeasi structura ca si tabelul emp_***. Stergeti din 
   tabelul emp_*** angajatii 100 si 101, mentinand valorile sterse in cele doua 
   variabile definite. Folosind cele doua variabile, introduceti informatiile 
   sterse in tabelul emp_***. 
*/

select * from employees;

DECLARE
    v_ang1 employees%ROWTYPE;
    v_ang2 employees%ROWTYPE;
BEGIN
-- sterg angajat 100 si mentin in variabila linia stearsa
    DELETE FROM emp_gid
    WHERE employee_id = 100
    RETURNING employee_id, first_name, last_name, email, phone_number,
              hire_date, job_id, salary, commission_pct, manager_id,
              department_id
    INTO v_ang1;
 
-- inserez inapoi in tabel linia stearsa   
    INSERT INTO emp_gid
    VALUES v_ang1;
    
-- sterg angajatul 101 
    DELETE FROM emp_gid
    WHERE employee_id = 101;
    
-- obtin datele despre angajatul 101 din tabelul employees
    SELECT *
    INTO v_ang2
    FROM employees
    WHERE employee_id = 101;
    
-- inserez o linie oarecare in emp_***
    INSERT INTO emp_gid
    VALUES (1000, 'FN', 'LN', 'E', null, sysdate, 'AD_VP', 1000, null, 100, 90);
    
-- modific linia adaugata anterior cu valorile variabilei v_ang2
    UPDATE emp_gid
    SET ROW = v_ang2
    WHERE employee_id = 1000;
END;
/



/*
4. Definiti un tablou indexat de numere. Introduceti in el primele 10 numere naturale. 
   a. Afisati numarul de elemente al tabloului si elementele acestuia.
   b. Setati la valoarea null elementele de pe pozitiile impare. Afisati numarul de 
      elemente al tabloului si elementele acestuia.
   c. Stergeti primul element, elementele de pe pozitiile 5, 6 si 7, respectiv ultimul 
      element. Afisati valoarea si indicele primului, respectiv ultimului element. 
      Afisati elementele tabloului si numarul acestora.
   d. Stergeti toate elementele tabloului.
*/

DECLARE
    TYPE tab_idx IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t tab_idx;
BEGIN
    FOR i IN 1..10 LOOP
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line;
    
    FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN
            t(i) := null;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line;
    
    t.delete(t.first);
    t.delete(5, 7);
    t.delete(t.last);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.first || '-' || nvl(t(t.first), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.last || '-' || nvl(t(t.last), 0));
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.exists(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line;
    
    t.delete;
    dbms_output.put_line(t.COUNT || ' elemenete');
END;
/

/*
5. Definiti un tablou indexat de inregistrari avand tipul celor din tabelul emp_***. 
   Stergeti primele doua linii din tabelul emp_***. Afisati elementele tabloului. 
   Folosind tabelul indexat adaugati inapoi cele doua linii sterse.
*/

--BULK COLLECT INTO

/*
TYPE t_tablou_indexat IS TABLE OF { 
 { tip_de_date | variabila%TYPE 
 | tabel.coloana%TYPE }[NOT NULL]}
 | tabel%ROWTYPE }
INDEX BY PLS_INTEGER | BINARY_INTEGER | VARCHAR2(n);
v_tablou t_tablou_indexat;
*/

DECLARE
    TYPE tabl_indx IS TABLE OF emp_pam%ROWTYPE INDEX BY BINARY_INTEGER;
    t tabl_indx;
BEGIN
    DELETE FROM emp_pam
    WHERE ROWNUM <= 2
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id
    BULK COLLECT INTO t;

    DBMS_OUTPUT.PUT_LINE (t(1).first_name ||' ' || t(1).last_name);
    DBMS_OUTPUT.PUT_LINE (t(2).first_name ||' ' || t(2).last_name);

    INSERT INTO emp_pam VALUES t(1);
    INSERT INTO emp_pam VALUES t(2);
END;
/


-- 6. Rezolvati exercitiul 4 folosind tablouri imbricate.

DECLARE
    TYPE tab_imb IS TABLE OF NUMBER;
    t tab_imb := tab_imb();
BEGIN
    FOR i IN 1..10 LOOP
        t.extend;
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line;
    
    FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN
            t(i) := null;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line;
    
    t.delete(t.first);
    t.delete(5, 7);
    t.delete(t.last);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.first || '-' || nvl(t(t.first), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.last || '-' || nvl(t(t.last), 0));
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.exists(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line;
    
    t.delete;
    dbms_output.put_line(t.COUNT || ' elemenete');
END;
/

/*
7. Declarati un tip tablou imbricat de caractere si o variabila de acest tip. 
   Initializati variabila cu urmatoarele valori: m, i, n, i, m. Afisati 
   continutul tabloului, de la primul la ultimul element si invers. 
   Stergeti elementele 2 si 4 si apoi afisati continutul tabloului.
*/

DECLARE
    TYPE tab_imb IS TABLE OF CHAR(1);
    t tab_imb := tab_imb('m', 'i', 'n', 'i', 'm');
    j INTEGER;
BEGIN
    FOR i IN t.first..t.last LOOP
        dbms_output.put(t(i));
    END LOOP;
    dbms_output.new_line;
    
    j := t.last;
    WHILE j >= t.first LOOP
        dbms_output.put(t(j));
        j := t.prior(j);
    END LOOP;
    dbms_output.new_line;
    
    t.delete(2);
    t.delete(4);
    
    j := t.first;
    WHILE j <= t.last LOOP
        dbms_output.put(t(j));
        j := t.next(j);
    END LOOP;
    dbms_output.new_line;
END;
/


-- 8. Rezolvati exercitiul 4 folosind vectori.

DECLARE
    TYPE vector IS VARRAY(20) OF NUMBER;
    t vector := vector();
BEGIN
    FOR i IN 1..10 LOOP
        t.extend;
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line;
    
    FOR i IN 1..10 LOOP
        IF i mod 2 = 1 THEN
            t(i) := null;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line;
    
-- metodele DELETE(n), DELETE(m,n) nu sunt valabile pentru vectori!!!
    t.trim(3);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.first || '-' || nvl(t(t.first), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.last || '-' || nvl(t(t.last), 0));
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.exists(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line;
    
    t.delete;
    dbms_output.put_line(t.COUNT || ' elemenete');
END;
/

/*
9. Definiti tipul subordonati_*** (vector, dimensiune maxima 10, mentine numere). 
   Creati tabelul manageri_*** cu urmatoarele campuri: cod_mgr NUMBER(10), 
   nume VARCHAR2(20), lista subordonati_***. Introduceti 3 linii in tabel. 
   Afisati informatiile din tabel. Stergeti tabelul creat, apoi tipul.
*/

CREATE OR REPLACE TYPE subordonati_gid IS VARRAY(10) OF NUMBER;
/

CREATE TABLE manageri_gid (cod_mgr NUMBER(10),
                           nume VARCHAR2(20),
                           lista subordonati_gid);

INSERT INTO manageri_gid
VALUES (1, 'Mgr 1', subordonati_gid(100, 200, 300));

INSERT INTO manageri_gid
VALUES (2, 'Mgr 2', null);

INSERT INTO manageri_gid
VALUES (3, 'Mgr 3', subordonati_gid(400, 500));

select * from manageri_gid;

drop table manageri_gid;
drop type subordonati_gid;

/*
10. Creati tabelul emp_test_*** cu coloanele employee_id si last_name din tabelul employees. 
    Adaugati in acest tabel un nou camp numit telefon de tip tablou imbricat. Acest tablou 
    va mentine pentru fiecare salariat toate numerele de telefon la care poate fi contactat. 
    Inserati o linie noua in tabel. Actualizati o linie din tabel. Afisati informatiile din tabel. 
    Stergeti tabelul si tipul.
*/

CREATE TABLE emp_test_gid AS SELECT employee_id, last_name from employees;
CREATE OR REPLACE TYPE tip_tel_gid IS TABLE OF VARCHAR2(12);
/

ALTER TABLE emp_test_gid ADD
telefon tip_tel_gid
NESTED TABLE telefon STORE AS tabel_telefon_gid;

select * from emp_test_gid;

INSERT INTO emp_test_gid
VALUES (500, 'XYZ', tip_tel_gid('073XXX', '0213XXX', '037XXX'));

select * from emp_test_gid where employee_id = 500;

UPDATE emp_test_gid
SET telefon = tip_tel_gid('073XXX', '0214XXX')
WHERE employee_id = 500;

select a.employee_id, a.last_name, b.* 
FROM emp_test_gid a, TABLE (a.telefon) b;

drop table emp_test_gid;
drop type tip_tel_gid;

/*
11. Stergeti din tabelul emp_*** salariatii avand codurile mentinute intr-un vector.
    Obs. Comanda FORALL permite ca toate liniile unei colectii sa fie transferate simultan 
    printr-o singura operatie. Procedeul este numit bulk bind.
*/

-- Varianta 1

DECLARE
    TYPE vect IS VARRAY(10) OF NUMBER;
    t vect := vect(100, 101, 102);
BEGIN
    FOR i IN t.FIRST..t.LAST LOOP
        DELETE FROM emp_rs
        WHERE employee_id = t(i);
    END LOOP;
END;
/

-- Varianta 2

DECLARE
    TYPE tip_cod IS VARRAY(10) OF NUMBER;
    coduri tip_cod := tip_cod(205, 206);
BEGIN
    FORALL i IN coduri.first..coduri.last
        DELETE FROM emp_gid
        WHERE employee_id = coduri(i);
        
END;
/
rollback;


-- Tema - Exercitii 1-3 de la finalul fisierului
-- Deadline: miercuri 09.11.2022 ora 23:59 



