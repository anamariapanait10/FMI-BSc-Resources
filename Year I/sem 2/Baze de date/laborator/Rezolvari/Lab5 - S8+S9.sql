S8+S9 - L5.pdf

IV. [Exerci?ii – definire tabele]
1. Sã se creeze tabelul ANGAJATI_*** (pnu se alcatuieºte din prima literã din prenume 
ºi primele douã din numele studentului) corespunzãtor schemei relaþionale:
ANGAJATI_***(cod_ang number(4), nume varchar2(20), prenume varchar2(20), 
email char(15), data_ang date, job varchar2(10), cod_sef number(4), 
salariu number(8, 2), cod_dep number(2))
în urmãtoarele moduri:
Se presupune cã valoarea implicitã a coloanei data_ang este SYSDATE.
Observa?ie: Nu pot exista douã tabele cu acelaºi nume în cadrul unei scheme,
deci recrearea unui tabel va fi precedatã de suprimarea sa prin comanda:
DROP TABLE ANGAJATI_***;

a) fãrã precizarea vreunei chei sau constrângeri;

create table ANGAJATI_***(
  cod_ang number(4), 
  nume varchar2(20), 
  prenume varchar2(20), 
  email char(15), 
  data_ang date, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2), 
  cod_dep number(2)); --table ANGAJATI_*** created.
  
  select * from angajati_***; --0 rez
  drop table angajati_***; --table ANGAJATI_*** dropped.
  
b) cu precizarea cheilor primare la nivel de coloanã ?i a 
constrângerilor NOT NULL pentru coloanele nume ºi salariu;
Se presupune cã valoarea implicitã a coloanei data_ang este SYSDATE.

create table ANGAJATI_***(
  cod_ang number(4) primary key, 
  nume varchar2(20) not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2));
    
SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati_***', 'angajati_tnt');
--SYS_C00527493	C	ANGAJATI_***
--SYS_C00527492	C	ANGAJATI_***
--SYS_C00527494	P	ANGAJATI_***  
 drop table angajati_***;
--v2
create table ANGAJATI_***(
  cod_ang number(4) constraint pk_ang_*** primary key, 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) not null, 
  cod_dep number(2));
  
--SYS_C00527502	C	ANGAJATI_*** --salariu
--NULL_NUME_***	C	ANGAJATI_*** --nume
--PK_ANG_***	P	ANGAJATI_***  ---cod_ang



c) cu precizarea cheii primare la nivel de tabel ?i 
a constrângerilor NOT NULL pentru coloanele nume ºi salariu.
Se presupune cã valoarea implicitã a coloanei data_ang este SYSDATE.
;
  drop table angajati_***;

create table ANGAJATI_***(
  cod_ang number(4), 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15), 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4), 
  salariu number(8, 2) constraint null_salariu_*** not null, 
  cod_dep number(2),
  constraint pk_ang_*** primary key(cod_ang)
  );
  
  select * from angajati_***;
  SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) ='angajati_***';
  Observa?ie: Tipul constrângerilor este marcat prin:
• P – pentru cheie primarã
• R – pentru constrângerea de integritate referenþialã (cheie externã);
• U – pentru constrângerea de unicitate (UNIQUE);
• C – pentru constrângerile de tip CHECK.

--NULL_SALARIU_***	C	ANGAJATI_***
--NULL_NUME_***	C	ANGAJATI_***
--PK_ANG_***	P	ANGAJATI_***

2.	Ad?uga?i urm?toarele înregistr?ri în tabelul ANGAJATI_***:

Cod_ang	Nume	Prenume	   Email	Data_ang	Job	Cod_sef	Salariu	Cod_dep
    100	Nume1	Prenume1	Null	Null	    Director	null	20000	10
    101	Nume2	Prenume2	Nume2	02-02-2004	Inginer	100	10000	10
    102	Nume3	Prenume3	Nume3	05-06-2004	Analist	101	5000	20
    103	Nume4	Prenume4	Null	Null	    Inginer	100	9000	20
    104	Nume5	Prenume5	Nume5	Null	    Analist	101	3000	30
    
    
Prima si a patra înregistrare vor fi introduse specificând coloanele pentru care 
introduce?i date efectiv, iar celelalte vor fi inserate f?r? precizarea 
coloanelor în comanda INSERT.
Salva?i comenzile de inserare.

insert into angajati_***(Cod_ang,Nume,Prenume,Email,Data_ang,Job,Cod_sef,Salariu,Cod_dep)
values( 100	,'Nume1',	'Prenume1',	Null	,Null,	'Director',	null,	20000	,10);
select * from angajati_***;

insert into angajati_***
values (101, 'Nume2','Prenume2','Nume2@gmail.com',
        to_date('02-02-2004', 'dd-mm-yyyy'), 'Inginer',	100,10000,10);
        
insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', 
        to_date('05-06-2004', 'dd-mm-yyyy'), 'Programator', 101, 5000, 20);
--ORA-12899: value too large for column "GRUPA33"."ANGAJATI_***"."JOB" (actual: 11, maximum: 10)
-- job varchar2(10)

insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', 
        to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103 

insert into angajati_***
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30);

select * from angajati_***;
commit;

100	Nume1	Prenume1			                    Director    20000	10
101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10
102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20
103	Nume4	Prenume4		            06-APR-22	Inginer	100	9000	20
104	Nume5	Prenume5	Nume5@gmail.com		        Analist	101	3000	30

truncate table angajati_***;
rollback;
select * from angajati_***;

3. Creaþi tabelul ANGAJATI10_***, prin copierea angajaþilor din departamentul 10 
din tabelul ANGAJATI_***. Listaþi structura noului tabel. Ce se observã?

create table angajati10_*** as
  Select * from angajati_*** where cod_dep =10;
  
  select * from angajati10_***; --2 rez
  
  
SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati10_***');
--SYS_C00527544	C	ANGAJATI10_***
--SYS_C00527543	C	ANGAJATI10_***
--doar contrangerile de not null peste coloanele nume si salriu au fost copiate
desc angajati10_***;
Name     Null     Type         
-------- -------- ------------ 
COD_ANG           NUMBER(4)    --lipseste pk
NUME     NOT NULL VARCHAR2(20) 
PRENUME           VARCHAR2(20) 
EMAIL             CHAR(15)     
DATA_ANG          DATE         
JOB               VARCHAR2(10) 
COD_SEF           NUMBER(4)    
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2)    

desc angajati_***;

Name     Null     Type         
-------- -------- ------------ 
COD_ANG  NOT NULL NUMBER(4)    --este setata PK
NUME     NOT NULL VARCHAR2(20) 
PRENUME           VARCHAR2(20) 
EMAIL             CHAR(15)     
DATA_ANG          DATE         
JOB               VARCHAR2(10) 
COD_SEF           NUMBER(4)    
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2) 



4. Introduceti coloana comision in tabelul ANGAJATI_***. 
Coloana va avea tipul de date NUMBER(4,2).

alter table angajati_***
add (comision number(4,2));

select * from angajati_***;

5. Este posibilã modificarea tipului coloanei comision în NUMBER(6,2)?
alter table angajati_***
modify (comision number(6,2));

--apoi pot sa micsorez?
alter table angajati_***
modify (comision number(4,2));
--table ANGAJATI_*** altered. (toate infomatiiile din coloana comision sunt nule)

select * from angajati_***;
5" .	Este posibil? modificarea tipului coloanei salariu în NUMBER(6,2)?
-- SALARIU  NOT NULL NUMBER(8,2) 
alter table angajati_***
modify (salariu number(6,2));
-- SQL Error: ORA-01440: coloana de modificat trebuie sa fie goala pentru a micsora precizia sau scala

-- 6. Setaþi o valoare DEFAULT pentru coloana salariu.

alter table angajati_***
modify(salariu default 1111);

-- lipseste salariul 

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Cod_dep) 
values (105, 'Nume6', 'Prenume6', 'Inginer', 100, 20);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Cod_dep, salariu)
values (106, 'Num76', 'Prenume76', 'Inginer', 100, 20, 2222);

select * from angajati_***;

-- 105	Nume6	Prenume6		06-APR-22	Inginer	100	1111	20	
-- 106	Num76	Prenume76		06-APR-22	Inginer	100	2222	20	

7. Modificaþi tipul coloanei comision în NUMBER(2, 2) si 
al coloanei salariu în NUMBER(10,2), 
în cadrul aceleiaºi instrucþiuni.
desc angajati_***;

-- inainte
SALARIU  NOT NULL NUMBER(8,2)  
COD_DEP           NUMBER(2)    
COMISION          NUMBER(4,2)  

alter table angajati_***
modify ( salariu number(10,2),
          comision number(2,2)
          );

-- dupa: 
SALARIU  NOT NULL NUMBER(10,2) 
COD_DEP           NUMBER(2)    
COMISION          NUMBER(2,2)           

--8. Actualiza?i valoarea coloanei comision, setând-o la valoarea 0.1 pentru 
--salariaþii al cãror job începe cu litera I. (UPDATE)
--select * from angajati_***;

update angajati_***
set comision=0.1
where lower(job)  like 'i%';

select * from angajati_***;

-- atentie

update angajati_***
set comision=1.1 
where lower(job)  like 'i%';
-- ORA-01438: value larger than specified precision allowed for this column

update angajati_***
set comision=0.129345 
where lower(job)  like 'i%';

-- 100	Nume1	Prenume1			                    Director	20000	10	
-- 101	Nume2	Prenume2	Nume2@gmail.com	02-FEB-04	Inginer	100	10000	10	0.13
-- 102	Nume3	Prenume3	Nume3@gmail.com	05-JUN-04	Analist	101	5000	20	
-- 103	Nume4	Prenume4		            06-APR-22	Inginer	100	9000	20	0.13
-- 104	Nume5	Prenume5	Nume5@gmail.com             Analist	101	3000	30	
-- 105	Nume6	Prenume6		            06-APR-22	Inginer	100	1111	20	0.13
-- 106	Num76	Prenume76		            06-APR-22	Inginer	100	2222	20	0.13

12. Redenumiþi tabelul ANGAJATI_*** în ANGAJATI3_***.
rename angajati_*** to angajati3_***; 
-- angajati_*** TO succeeded.
select * from angajati_***; -- ORA-00942: tabelul sau vizualizarea nu exista
select * from angajati3_***; 
desc angajati3_***;

13. Consultaþi vizualizarea TAB din dicþionarul datelor. Redenumiþi angajati3_*** în angajati_***.
select * from tab;
rename angajati3_*** to angajati_***;
--Table renamed.
select * from angajati_***;
select * from angajati3_***;  --ORA-00942: tabelul sau vizualizarea nu exista

14. Suprimaþi conþinutul tabelului angajati10_***, fãrã a suprima structura acestuia.

create table angajati10_*** as
  Select * from angajati_*** where cod_dep =10;
  
  select * from angajati10_***;
  
  delete from angajati10_***; --tabela goala
  rollback; -- avem cele 2 inregistrari
  
  truncate table angajati10_***; --se pastreaza structura tabelei (DELETE+COMMIT)
  rollback; -- in continuare tabela este goala
  
  drop table angajati10_***;
  select * from angajati10_***; -- ORA-00942: tabelul sau vizualizarea nu exista
  
-- 15. Creaþi tabelul DEPARTAMENTE_***, corespunzãtor schemei relaþionale:
-- DEPARTAMENTE_*** (cod_dep# number(2), nume varchar2(15), cod_director number(4))
-- specificând doar constrângerea NOT NULL pentru nume
-- (nu precizaþi deocamdatã constrângerea de cheie primarã). 

CREATE TABLE departamente_*** 
(cod_dep number(2), 
nume varchar2(15) constraint NL_nume_*** NOT NULL, 
cod_director number(4)); 

DESC departamente_***;

/*
Name         Null     Type         
------------ -------- ------------ 
COD_DEP               NUMBER(2)    
NUME         NOT NULL VARCHAR2(15) 
COD_DIRECTOR          NUMBER(4)   

16. Introduceþi urmãtoarele înregistrãri în tabelul DEPARTAMENTE_pnu:
Cod_dep	Nume	Cod_director
10	Administrativ	100
20	Proiectare	101
30	Programare	Null
*/

insert into departamente_***
values(10,	'Administrativ',	100);
insert into departamente_***
values(20, 'Proiectare',	101);
insert into departamente_***
values(30,	'Programare',	Null);
-- atentie
insert into departamente_***
values(30,	'DE_STERS',	Null);

select * from departamente_***;
/*
10	Administrativ	100
20	Proiectare	101
30	Programare	
30	DE_STERS	
*/

alter table departamente_***
add constraint pk_depart_*** primary key (cod_dep); 

-- SQL Error: ORA-02437: (GRUPA32.PK_DEPART_***) nu a putut fi validata - cheia primara a fost violata
--*Cause:    attempted to validate a primary key with duplicate values or null
--           values.
--*Action:   remove the duplicates and null values before enabling a primary
--           key.
;
delete from departamente_***
where nume = 'DE_STERS'; -- 1 rows deleted.

select * from departamente_***;
commit;

17. Introduce?i constângerea de cheie primarã asupra coloanei cod_dep,
fãrã suprimarea ºi recrearea tabelului 
(comanda ALTER).
Observa?ie:
o Introducerea unei constrângeri dupã crearea tabelului presupune cã toate liniile existente în tabel la 
momentul respectiv satisfac noua constrângere.
o Specificarea constrângerilor permite numirea acestora.
o In situaþia in care constrângerile sunt precizate la nivel de coloanã sau tabel 
(în CREATE TABLE) ele vor primi implicit nume atribuite de sistem, dacã nu se specificã vreun alt nume 
într-o clauzã CONSTRAINT.
Exemplu : CREATE TABLE alfa (
X NUMBER CONSTRAINT nn_x NOT NULL,
Y VARCHAR2 (10) NOT NULL
);

-- atentie
alter table departamente_***  --PK = Unique + NOT NULL
add constraint pk_depart_*** primary key (cod_director);
--SQL Error: ORA-01449: coloana contine valori NULL; nu se poate modifica în NOT NULL


alter table departamente_***
add constraint pk_depart_*** primary key (cod_dep); 

--table DEPARTAMENTE_*** altered.

--alter table departamente_***
--drop constraint pk_depart_***;

-- lab8 finish

desc departamente_***;
18. Sã se precizeze constrângerea de cheie externã pentru coloana cod_dep din ANGAJATI_pnu:
a) fãrã suprimarea tabelului (ALTER TABLE);

desc angajati_***;

select * from angajati_***;
delete from angajati_***
where cod_ang in (105,114);

alter  table angajati_***
add  constraint fk_ang_depart_*** foreign key(cod_dep) references departamente_***(cod_dep);

--Posibile erori:
-- ORA-02270: no matching unique or primary key for this column-list (pt ca nu este setata cheia primara pe tabela de departamente

--ORA-02298: cannot validate (GRUPA34.FK_ANG_DEPART_***) - parent keys not found
--02298. 00000 - "cannot validate (%s.%s) - parent keys not found"
-- angajatii lucreaza pe departamente care nu se gasesc in tabela departamente_***
--insert  into angajati_***
--values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', Null, 'Analist', 101, 3000, 50, 0.2);
delete from angajati_***
where cod_ang =105;

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) = 'angajati_***';

NULL_SALARIU_***	C	ANGAJATI_***
NULL_NUME_***	C	ANGAJATI_***
FK_ANG_DEPART_***	R	ANGAJATI_*** --FK
PK_ANG_***	P	ANGAJATI_***  --PK

b) prin suprimarea ºi recrearea tabelului, cu precizarea noii constrângeri la nivel de coloanã 
({DROP, CREATE} TABLE). De asemenea, se vor mai preciza constrângerile (la nivel de coloanã, 
în mãsura în care este posibil):
- PRIMARY KEY pentru cod_ang;
- FOREIGN KEY pentru cod_sef;
- UNIQUE pentru combinaþia nume + prenume;
- UNIQUE pentru email;
- NOT NULL pentru nume;
- verificarea cod_dep > 0;
- verificarea ca salariul sã fie mai mare decât comisionul*100.

--drop table departamente_***; --SQL Error: ORA-02449: cheile unice/primare din tabela sunt referite de cheile externe

drop table angajati_***; --table ANGAJATI_*** dropped.

create table ANGAJATI_***(
  cod_ang number(4) constraint pk_ang_*** primary key, 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15) constraint unq_email_*** unique, 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4) constraint fk_ang_ang_*** references angajati_***(cod_ang), 
  salariu number(8, 2),
  cod_dep number(2) constraint ck_cod_dep_*** check(cod_dep>0), 
  comision number(4,2),
  constraint unq_nume_pren_*** unique(nume, prenume),
  constraint ck_sal_com_*** check( salariu>comision *100),
  constraint fk_ang_depart_*** foreign key(cod_dep) references departamente_***(cod_dep)--se poate punse si la nivel de coloana
    );


SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('angajati_***');

CK_SAL_COM_***	C	ANGAJATI_***
CK_COD_DEP_***	C	ANGAJATI_***
NULL_NUME_***	C	ANGAJATI_***
FK_ANG_DEPART_***	R	ANGAJATI_***
FK_ANG_ANG_***	R	ANGAJATI_***
UNQ_NUME_PREN_***	U	ANGAJATI_***
UNQ_EMAIL_***	U	ANGAJATI_***
PK_ANG_***	P	ANGAJATI_***

19. Suprimaþi ºi recreaþi tabelul, specificând toate constrângerile la nivel de tabel 
(în mãsura în care este posibil).
/
--
drop table angajati_***;

create  table ANGAJATI_***(
  cod_ang number(4) , 
  nume varchar2(20) constraint null_nume_*** not null, 
  prenume varchar2(20), 
  email char(15) , 
  data_ang date default sysdate, 
  job varchar2(10), 
  cod_sef number(4) , 
  salariu number(8, 2),
  cod_dep number(2) ,
  comision number(4,2),
  constraint unq_nume_pren_*** unique(nume, prenume),
  constraint ck_sal_com_*** check(salariu>comision *100),
  constraint pk_ang_*** primary key(cod_ang),
  constraint unq_email_*** unique(email),
  constraint fk_ang_ang_*** foreign key(cod_sef) references angajati_***(cod_ang),
  constraint ck_cod_dep_*** check(cod_dep>0),
  constraint fk_depart_*** foreign key(cod_dep) references departamente_***(cod_dep)  
    );
    
    drop table ANGAJATI_***;

  SELECT * FROM USER_CONSTRAINTS WHERE lower(TABLE_NAME) = 'angajati_***';

CK_COD_DEP_***	C
CK_SAL_COM_***	C
NULL_NUME_***	C
FK_DEPART_***	R
FK_ANG_ANG_***	R
UNQ_EMAIL_***	U
UNQ_NUME_PREN_***	U
PK_ANG_***	P

insert into angajati_***(Cod_ang,	Nume	,Prenume,	Email,	Data_ang	,Job,	Cod_sef,	Salariu,	Cod_dep)
values( 100	,'Nume1',	'Prenume1',	Null	,Null,	'Director',	null,	20000	,10);
select * from angajati_***;

insert into angajati_***
values (101, 	'Nume2',	'Prenume2',	'Nume2@gmail.com', to_date(	'02-02-2004', 'dd-mm-yyyy'), 	'Inginer',	100,	10000	,10, 0.1);

insert into angajati_***
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20, null);

insert into angajati_*** (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103 

insert into angajati_***
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);

select * from angajati_***;
commit;

delete from angajati_***;
rollback;

insert into angajati_***  --inserare prin copiere din tabela mea
select * from angajati_***;
-----
insert into angajati_(Cod_ang, Nume ,Prenume, Email, Data_ang ,Job, Cod_sef, Salariu, Cod_dep)
values( 100 ,'Nume1', 'Prenume1', Null ,Null, 'Director', null, 20000 ,10);
select * from angajati_***;
insert into angajati_
values (101, 'Nume2', 'Prenume2', 'Nume2@gmail.com', to_date( '02-02-2004', 'dd-mm-yyyy'), 'Inginer', 100, 10000 ,10, 0.1);
insert into angajati_
values (102, 'Nume3', 'Prenume3', 'Nume3@gmail.com', to_date('05-06-2004', 'dd-mm-yyyy'), 'Analist', 101, 5000, 20, null);
insert into angajati_ (Cod_ang, Nume, Prenume, Job, Cod_sef, Salariu, Cod_dep)
values (103, 'Nume4', 'Prenume4', 'Inginer', 100, 9000, 20);
--atentie la data de angajare a lui 103
insert into angajati_
values (104, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
-----------
commit;

25. (Încercaþi sã) adãugaþi o nouã înregistrare în tabelul ANGAJATI_pnu, care sã corespundã codului
de departament 50. Se poate?

--atentie
insert into angajati_***
values (105, 'Nume5', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
--SQL Error: ORA-00001: restrictia unica (GRUPA34.UNQ_NUME_PREN_***) nu este respectata

insert  into angajati_***
values (105, 'Nume6', 'Prenume5', 'Nume5@gmail.com', Null, 'Analist', 101, 3000, 30, 0.2);
--SQL Error: ORA-00001: restrictia unica (GRUPA34.UNQ_EMAIL_***) nu este respectata

insert  into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', Null, 'Analist', 101, 3000, 50, 0.2);
SQL Error: ORA-02291: constrângere de integritate (GRUPA33.FK_DEPART_***) violata - cheia parinte negasita
--dept 50 nu exista in lista de departamente

29. (Încercaþi sã) introduceþi un nou angajat, specificând valoarea 114 pentru cod_sef. Ce se obþine?

insert into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', null, 'Analist', 114, 3000, 20, 0.2);

SQL Error: ORA-02291: constrângere de integritate (GRUPA33.FK_ANG_ANG_***) violata - cheia parinte negasita

--angajatul 114 nu exista in baza de date
30. Adãugaþi un nou angajat, având codul 114. Încercaþi din nou introducerea înregistrãrii de la exerciþiul 29.

insert into angajati_***
values (114, 'Nume7', 'Prenume7', 'Nume7@gmail.com', null, 'Analist', 100, 3000, 20, 0.2); --1 rows inserted.

insert into angajati_***
values (105, 'Nume6', 'Prenume6', 'Nume6@gmail.com', null, 'Analist', 114, 3000, 20, 0.2); --1 rows inserted.

select * from angajati_***;

21. Ce se întâmplã dacã se încearcã suprimarea tabelului departamente_pnu?

drop table departamente_***; 
--SQL Error: ORA-02449: cheile unice/primare din tabela sunt referite de cheile externe
truncate table departamente_***; 
--SQL Error: ORA-02266: cheile unice/primare din tabela sunt referite de cheile externe activate
delete from departamente_***; 
--SQL Error: ORA-02292: constrângerea de integritate (GRUPA33.FK_DEPART_***) violata - gasita înregistrarea copil

26. Adãugaþi un nou departament, cu numele Testare, codul 60 ºi directorul null în DEPARTAMENTE_pnu. COMMIT.
insert into departamente_***
values(60,	'Testare',	null); --1 rows inserted.
commit;

27. (Încercaþi sã) ºtergeþi departamentul 20 din tabelul DEPARTAMENTE_pnu. Comentaþi.
delete from departamente_***
where cod_dep =20;
--SQL Error: ORA-02292: constrângerea de integritate (GRUPA34.FK_DEPART_***) violata - gasita înregistrarea copil
--lucreaza angajati in dept 20
select * from angajati_***
where cod_dep =20;
--4 rez

28. ªtergeþi departamentul 60 din DEPARTAMENTE_pnu. ROLLBACK.

select * from departamente_***;
delete from departamente_***
where cod_dep =60; --1 rows deleted.
commit;
31. Se doreºte ºtergerea automatã a angajaþilor dintr-un departament, odatã cu suprimarea departamentului.
Pentru aceasta, este necesarã introducerea clauzei ON DELETE CASCADE în definirea constrângerii de cheie externã.
Suprimaþi constrângerea de cheie externã asupra tabelului ANGAJATI_pnu ºi reintroduceþi aceastã constrângere, 
specificând clauza ON DELETE CASCADE.

SELECT constraint_name, constraint_type, table_name
FROM     user_constraints
WHERE  lower(table_name) IN ('departamente_***', 'angajati_***');

alter table angajati_***
drop constraint FK_ANG_DEPART_***;
--table ANGAJATI_*** altered.

alter table angajati_***
add constraint FK_ANG_DEPART2_*** foreign key(cod_dep) 
            references departamente_***(cod_dep) on delete cascade;

32. ªtergeþi departamentul 20 din DEPARTAMENTE_pnu. Ce se întâmplã? Rollback.

select * from angajati_***;
-- 7 rez, dintre care 4 lucreaza in dept 20
-- exista angajati care lucreaza in dept 20


delete from departamente_*** 
where cod_dep =20;
--1 rows deleted.

select * from angajati_***;
--3 rez

rollback;
select * from angajati_***; --7 rez
select * from departamente_***; --3 rez

-- ON DELETE SET NULL

alter table angajati_***
drop constraint fk_depart_***2;
--table ANGAJATI_*** altered.

alter table angajati_***
add constraint fk_depart_***3 foreign key(cod_dep) 
        references departamente_***(cod_dep) on delete set null;


select * from angajati_***;
-- 7 rez, dintre care 4 lucreaza in dept 20

delete from departamente_*** 
where cod_dep =20;
--1 rows deleted.

select * from angajati_***;
--7 rez, cei care lucrau in dept 20, acum au dept setata null

---------------------------------
CREATE SEQUENCE nume_secv
[INCREMENT BY n]
[START WITH n]
[{MAXVALUE n | NOMAXVALUE}]
[{MINVALUE n | NOMINVALUE}]
[{CYCLE | NOCYCLE}]
[{CACHE n | NOCACHE}]

38. Creaþi o secvenþã pentru generarea codurilor de departamente, SEQ_DEPT_PNU. 
Secvenþa va începe de la 400, va creºte cu 10 de fiecare datã ºi va avea valoarea maximã 
10000, nu va cicla ºi nu va încãrca nici un numãr înainte de cerere.

create  sequence seq_dept_***
start with 400
increment by 10
maxvalue 10000
nocycle
nocache;
--Sequence SEQ_DEPT_*** created.

select seq_dept_***.nextval
from dual;

--I -> 400
--II ->410

select seq_dept_***.currval
from dual;

insert into departamente_***
values(seq_dept_***.nextval, 'Dept_sec', null);  --420
--SQL Error: ORA-01438: valoare mai mare decât precizia specificata permisa pentru aceasta coloana

desc departamente_***;
Name         Null     Type         
------------ -------- ------------ 
COD_DEP      NOT NULL NUMBER(2)    
NUME         NOT NULL VARCHAR2(15) 
COD_DIRECTOR          NUMBER(4)    


insert into dept_***
values(seq_dept_***.nextval, 'Dept_sec', null, null); 
--1 rows inserted.
select * from dept_***;
--430	Dept_sec		null null
--440	Dept_sec		null null 

40. Creaþi o secvenþã pentru generarea codurilor de angajaþi, SEQ_EMP_PNU.

create sequence seq_ang_***
start with 100
maxvalue 10000
nocycle
nocache;

41. Sã se modifice toate liniile din angajati_*** (dacã nu mai existã, îl recreaþi),
regenerând codul angajaþilor astfel încât sã utilizeze secvenþa SEQ_EMP_PNU ºi 
sã avem continuitate în codurile angajaþilor.

update angajati_***  --7 ang
set cod_ang = seq_ang_***.nextval; --(100..106)
--SQL Error: ORA-02292: constrângerea de integritate (GRUPA34.FK_ANG_ANG_***) violata - gasita înregistrarea copil

select * from angajati_***;

delete from angajati_***
where cod_ang =105; --nu rezolva problema
commit;

update angajati_*** --6 ang
set cod_ang = seq_ang_***.nextval; --(107---112)
--SQL Error: ORA-02292: constrângerea de integritate (GRUPA34.FK_ANG_ANG_***) violata - gasita înregistrarea copil


update angajati_***
set cod_sef = null;
6 rows updated.

--dupa 2 update-uri esuate am ajuns la val 113

update angajati_***
set cod_ang = seq_ang_***.nextval;
6 rows updated.

--113	Nume1	Prenume1			Director		20000	10	
--114	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer		10000	10	0,1
--115	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist		5000		
--116	Nume4	Prenume4		15-04-2021	Inginer		9000		
--117	Nume5	Prenume5	Nume5@gmail.com		Analist		3000	30	0,2
--118	Nume7	Prenume7	Nume7@gmail.com		Analist		3000		0,2

rollback;
--
--100	Nume1	Prenume1			Director		20000	10	
--101	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer	100	10000	10	0,1
--102	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist	101	5000		
--103	Nume4	Prenume4		14-04-2021	Inginer	100	9000		
--104	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30	0,2
--114	Nume7	Prenume7	Nume7@gmail.com		Analist	100	3000		0,2


--modific codul unui angajat care nu este sef -> se poate
update angajati_*** 
set cod_ang = seq_ang_***.nextval
where cod_ang =104;

--100	Nume1	Prenume1			Director		20000	10	
--101	Nume2	Prenume2	Nume2@gmail.com	02-02-2004	Inginer	100	10000	10	0,1
--102	Nume3	Prenume3	Nume3@gmail.com	05-06-2004	Analist	101	5000		
--103	Nume4	Prenume4		15-04-2021	Inginer	100	9000		
--119	Nume5	Prenume5	Nume5@gmail.com		Analist	101	3000	30	0,2
--114	Nume7	Prenume7	Nume7@gmail.com		Analist	100	3000		0,2

