
drop sequence secventa_inc_id;

create sequence secventa_inc_id
start with 1
increment by 1
nocycle
nocache;

commit;
drop table oferta;
drop table dealer;
drop table client;
drop table conf_extraop;
drop table configuratie;
drop table extraop_niv;
drop table vopsea_niv;
drop table tapis_niv;
drop table janta_niv;
drop table motorizare_niv;
drop table extraoptiune;
drop table vopsea;
drop table tapiterie;
drop table janta;
drop table motorizare;
drop table niv_ech_disp;
drop table nivel_echipare;
drop table modele_disp;
drop table model_masina;
drop table reprez_auto;
drop table locatie;
drop table firma_auto;
drop sequence secventa_inc_id;

delete from oferta;
delete from dealer;
delete from client;
delete from conf_extraop;
delete from configuratie;
delete from extraop_niv;
delete from vopsea_niv;
delete from tapis_niv;
delete from janta_niv;
delete from motorizare_niv;
delete from extraoptiune;
delete from vopsea;
delete from tapiterie;
delete from janta;
delete from motorizare;
delete from niv_ech_disp;
delete from nivel_echipare;
delete from modele_disp;
delete from model_masina;
delete from reprez_auto;
delete from locatie;
delete from firma_auto;


create table firma_auto(
id_firma number(5) constraint pk_fima_auto primary key,
marca varchar2(30) not null constraint uniq_marca unique
);

create table locatie(
id_locatie number(5) constraint pk_locatie primary key,
tara varchar2(30) not null,
oras varchar2(30) not null,
strada varchar2(50) not null, 
numar number(5) not null
);

create table reprez_auto(
id_reprezentanta number(5) constraint pk_reprez_auto primary key,
nume varchar2(30) not null constraint uniq_nume_reprez unique,
id_firma number(5), 
id_locatie number(5),
constraint fk_id_reprez_firma foreign key(id_firma) references firma_auto(id_firma) on delete cascade,
constraint fk_id_reprez_locatie foreign key(id_locatie) references locatie(id_locatie) on delete cascade
);


create table model_masina(
id_model number(5) constraint pk_model_masina primary key,
nume varchar2(30) not null constraint uniq_nume_model unique,
pret_pornire number(8, 2) not null
);


create table modele_disp(
id_reprezentanta number(5),
id_model number(5),
cantitate number(38) not null,
constraint pk_id_modele_disp primary key(id_reprezentanta, id_model),
constraint fk_id_modele_disp_reprez foreign key(id_reprezentanta) references reprez_auto(id_reprezentanta) on delete cascade,
constraint fk_id_modele_disp_model foreign key(id_model) references model_masina(id_model)on delete cascade
);


create table nivel_echipare(
id_nivel number(5) constraint pk_nivel primary key,
nume varchar2(30) not null constraint uniq_nume_nivel unique,
descriere varchar2(2000) default null,
pret number(8, 2) not null
);


create table niv_ech_disp(
id_nivel number(5),
id_model number(5),
constraint pk_id_niv_ech_disp primary key(id_nivel, id_model),
constraint fk_id_niv_ech_disp_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_niv_ech_disp_model foreign key(id_model) references model_masina(id_model)on delete cascade
);


create table motorizare(
id_motorizare number(5) constraint pk_motorizare primary key,
combustibil varchar2(20) not null check(lower(combustibil) in ('diesel', 'benzina', 'electric', 'hybrid', 'plug-in hybrid')), 
putere number(3) not null,
transmisie varchar2(20) not null check(lower(transmisie) in ('automata', 'manuala')),
emisii number(4) not null,
consum number(4, 1) not null,
capacitate number(4) not null,
pret number(7, 2) not null
);


create table janta(
id_janta number(5) constraint pk_janta primary key,
nume varchar2(30) not null constraint uniq_nume_janta unique,
material varchar2(20) not null,
culoare varchar(20) default '#000000' not null check(culoare like '#______'),
diametru number(3) not null,
pret number(7, 2) not null
);


create table tapiterie(
id_tapiterie number(5) constraint pk_tapiterie primary key,
material varchar2(30) not null,
culoare varchar2(30) default '#000000' not null check(culoare like '#______'),
pret number(7, 2) not null
);


 
create table vopsea(
id_vopsea number(5) constraint pk_vopsea primary key,
nume varchar2(30) not null,
cod_culoare varchar2(15) default '#FF0000' not null check(cod_culoare like '#______'),
pret number(7, 2) not null
);


create table extraoptiune(
id_extraoptiune number(5) constraint pk_extraoptiune primary key,
nume varchar2(30) not null constraint uniq_nume_extraop unique,
descriere varchar2(2000) default null,
pret number(7, 2) not null
);


create table  motorizare_niv(
id_nivel number(5),
id_motorizare number(5),
constraint pk_id_motorizare_niv primary key(id_nivel, id_motorizare),
constraint fk_id_motorizare_niv_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_motorizare_niv_motorizare foreign key(id_motorizare) references motorizare(id_motorizare)on delete cascade
);

create table  janta_niv(
id_nivel number(5),
id_janta number(5),
constraint pk_id_janta_niv primary key(id_nivel, id_janta),
constraint fk_id_janta_niv_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_janta_niv_janta foreign key(id_janta) references janta(id_janta)on delete cascade
);


create table  tapit_niv(
id_nivel number(5),
id_tapiterie number(5),
constraint pk_id_tapit_niv primary key(id_nivel, id_tapiterie),
constraint fk_id_tapit_niv_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_tapit_niv_tapiterie foreign key(id_tapiterie) references tapiterie(id_tapiterie)on delete cascade
);

create table  vopsea_niv(
id_nivel number(5),
id_vopsea number(5),
constraint pk_id_vopsea_niv primary key(id_nivel, id_vopsea),
constraint fk_id_vopsea_niv_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_vopsea_niv_vopsea foreign key(id_vopsea) references vopsea(id_vopsea)on delete cascade
);

create table extraop_niv(
id_nivel number(5),
id_extraoptiune number(5),
constraint pk_id_extraoptiune_niv primary key(id_nivel, id_extraoptiune),
constraint fk_id_extraoptiune_niv_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_id_extraoptiune_niv_extraoptiune foreign key(id_extraoptiune) references extraoptiune(id_extraoptiune)on delete cascade
);


create table configuratie(
id_configuratie number(5) constraint pk_configuratie primary key,
id_motorizare number(5),
id_janta number(5),
id_tapiterie number(5),
id_vopsea number(5),
id_nivel number(5),
id_reprezentanta number(5),
constraint fk_configuratie_id_motorizari foreign key(id_motorizare) references motorizare(id_motorizare) on delete cascade,
constraint fk_configuratie_id_janta foreign key(id_janta) references janta(id_janta) on delete cascade,
constraint fk_configuratie_id_tapiterie foreign key(id_tapiterie) references tapiterie(id_tapiterie) on delete cascade,
constraint fk_configuratie_id_vopsele foreign key(id_vopsea) references vopsea(id_vopsea) on delete cascade,
constraint fk_configuratie_id_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
constraint fk_configuratie_id_reprezentanta foreign key(id_reprezentanta) references reprez_auto(id_reprezentanta) on delete cascade
);


create table conf_extraop(
id_configuratie number(5),
id_extraoptiune number(5),
constraint pk_id_conf_extraop primary key(id_configuratie, id_extraoptiune),
constraint fk_id_conf_extraop_configuratie foreign key(id_configuratie) references configuratie(id_configuratie) on delete cascade,
constraint fk_id_conf_extraop_extraoptiune foreign key(id_extraoptiune) references extraoptiune(id_extraoptiune)on delete cascade
);


create table client(
id_client number(5) constraint pk_client primary key,
nume varchar2(30) not null,
prenume varchar2(30) not null,
data_nastere date
);

create table dealer(
id_dealer number(5) constraint pk_dealer primary key,
nume varchar2(30) not null,
prenume varchar2(30) not null,
data_angajare date default sysdate
);

create table oferta(
id_configuratie number(5),
id_client number(5),
id_dealer number(5),
pret_oferta number(20, 2),
constraint pk_id_oferta primary key(id_configuratie, id_client, id_dealer),
constraint fk_id_oferta_configuratie foreign key(id_configuratie) references configuratie(id_configuratie) on delete cascade,
constraint fk_id_oferta_client foreign key(id_client) references client(id_client)on delete cascade,
constraint fk_id_oferta_dealer foreign key(id_dealer) references dealer(id_dealer)on delete cascade
);



-- Inserari

drop sequence secventa_inc_id;
create sequence secventa_inc_id
start with 1
increment by 1
nocycle
nocache;

-- 1) firma_auto
insert into firma_auto values (secventa_inc_id.nextval, 'Skoda'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Renault');  
insert into firma_auto values (secventa_inc_id.nextval, 'Dacia'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Toyota'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Suzuki'); 

select * from firma_auto;

delete from firma_auto;

-- 2) locatie
insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Bucuresti', 'Crinul de Padure', 2);
insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Bucuresti', 'Ion Mincu', 3);
insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Iasi', 'Vasile Alecsandri', 1);
insert into locatie values (secventa_inc_id.nextval, 'Italia', 'Roma', 'Bocca di Leone', 5);
insert into locatie values (secventa_inc_id.nextval, 'Franta', 'Paris', 'Theatre des Champs Elysees', 6);

select * from locatie;


delete from locatie;

-- 3) reprez_auto // id_firma, id_locatie
insert into reprez_auto values (secventa_inc_id.nextval, 'Porsche Bucuresti Vest', 1, 6);
insert into reprez_auto values (secventa_inc_id.nextval, 'Porsche Iasi', 2, 7);
insert into reprez_auto values (secventa_inc_id.nextval, 'Brady Auto', 3, 8);
insert into reprez_auto values (secventa_inc_id.nextval, 'AutoItalia', 4, 9);
insert into reprez_auto values (secventa_inc_id.nextval, 'Roland Auto', 5, 10);


select * from reprez_auto;


delete from reprez_auto;

-- 4) model_masina
insert into model_masina values (secventa_inc_id.nextval, 'Octavia', 23000); -- skoda
insert into model_masina values (secventa_inc_id.nextval, 'Fabia', 13000);
insert into model_masina values (secventa_inc_id.nextval, 'Swift', 12000); --suzuki
insert into model_masina values (secventa_inc_id.nextval, 'Vitara', 18000);
insert into model_masina values (secventa_inc_id.nextval, 'Ignis', 14000);
insert into model_masina values (secventa_inc_id.nextval, 'Logan', 9000); -- dacia
insert into model_masina values (secventa_inc_id.nextval, 'Spring', 8000);
insert into model_masina values (secventa_inc_id.nextval, 'Clio', 15000); -- renault
insert into model_masina values (secventa_inc_id.nextval, 'Megane', 18000);
insert into model_masina values (secventa_inc_id.nextval, 'Kadjar', 20000);
insert into model_masina values (secventa_inc_id.nextval, 'Camry', 40000); -- toyota

select * from model_masina;
delete from model_masina;

-- 5) modele_disp // (id_repre, id_model, cant)
insert into modele_disp values(11, 16, 10);
insert into modele_disp values(11, 17, 20);
insert into modele_disp values(12, 18, 60);
insert into modele_disp values(12, 19, 100);
insert into modele_disp values(13, 20, 500);
insert into modele_disp values(13, 21, 30);
insert into modele_disp values(13, 22, 30);
insert into modele_disp values(14, 23, 35);
insert into modele_disp values(14, 24, 90);
insert into modele_disp values(15, 25, 60);
insert into modele_disp values(15, 26, 110);

select * from modele_disp;


delete from modele_disp;

-- 6) nivel_echipare
insert into nivel_echipare (id_nivel, nume, descriere, pret) values (secventa_inc_id.nextval, 'Basic', 'Nivel standard care contine dotari de baza', 2000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Spirit', 3000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Pasion', 5000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Style', 6500);
insert into nivel_echipare (id_nivel, nume, descriere, pret) values (secventa_inc_id.nextval, 'RS', 'Varianta sportiva pentru pasionati auto', 10000);

select * from nivel_echipare;
delete from nivel_echipare;

-- 7) niv_ech_disp // (id_nivel, id_model)
insert into niv_ech_disp values(27, 16);
insert into niv_ech_disp values(28, 16);
insert into niv_ech_disp values(27, 17);
insert into niv_ech_disp values(28, 17);
insert into niv_ech_disp values(29, 25);
insert into niv_ech_disp values(30, 18);
insert into niv_ech_disp values(27, 19);
insert into niv_ech_disp values(29, 19);
insert into niv_ech_disp values(30, 20);
insert into niv_ech_disp values(29, 16);
insert into niv_ech_disp values(30, 21);
insert into niv_ech_disp values(27, 21);
insert into niv_ech_disp values(27, 22);
insert into niv_ech_disp values(29, 26);
insert into niv_ech_disp values(27, 23);
insert into niv_ech_disp values(31, 23);
insert into niv_ech_disp values(28, 26);
insert into niv_ech_disp values(28, 24);

select * from niv_ech_disp;


-- 13) motorizare
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'diesel', 150, 2000, 'Automata', 7, 130, 2500);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'benzina', 80, 1000, 'Manuala', 6, 130, 2000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'hybrid', 220, 2000, 'Automata', 5, 130, 6000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'plug-in hybrid', 250, 2000, 'Automata', 4, 130, 8000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'electric', 180, 0, 'Automata', 0, 0, 15000);

select * from motorizare;

-- 14) janta

insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Basic small', 'tabla', '#000000', 14, 200);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Basic large', 'tabla', '#000000', 15, 400);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Aero', 'aliaj', '#AAAAAA', 16, 800);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Aero PRO', 'magneziu', '#111111', 18, 2000);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Perseus', 'aliaj', '#A1A1A1', 19, 3000);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Z-performance', 'magneziu', '#FFCC00', 21, 4000);

select * from janta;
delete from janta;

-- 15) tapiterie

insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Stofa','#000000',100);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Stofa','#CC6600',200);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#000000',800);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#804000',1000);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#FFFFFF',1200);

select * from tapiterie;

-- 16) vopsea
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Energy Blue', '#3366FF', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Magic Black', '#404040', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Candy White', '#EEEEEE', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Race Blue', '#0052CC', 500);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Velvet Red', '#CC0000', 750);

select * from vopsea;

-- 17) extraoptiune

insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Oglinzi incalzite', 'Incalzire', 200);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Scaune incalzite', '', 200);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Scaune ventilate', 'Scaune care impiedica transpiratia', 500);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Parbriz cu degivrare rapida', 'Incalzire in parbriz', 300);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Sistem Keyless Go', '', 200);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Volan incalzit', 'Volan imbracat in piele si incalzit', 200);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Trapa panoramica', 'Geam in tavanul masinii', 900);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Clima bi-zona', 'Sistem de climatizare cu doua zone', 500);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Ecran touchscreen 5 inch', 'Sistem navigatie cu ecran mic', 200);
insert into extraoptiune(id_extraoptiune, nume, descriere, pret) values(secventa_inc_id.nextval, 'Ecran touchscreen 7 inch', 'Sistem de navigatie cu android auto', 400);

select * from extraoptiune;

-- 8) motorizare_niv
insert into motorizare_niv values(27, 33);
insert into motorizare_niv values(28, 33);
insert into motorizare_niv values(29, 32);
insert into motorizare_niv values(30, 32);
insert into motorizare_niv values(31, 35);
insert into motorizare_niv values(27, 32);
insert into motorizare_niv values(28, 32);
insert into motorizare_niv values(29, 34);
insert into motorizare_niv values(30, 34);
insert into motorizare_niv values(31, 36);

select * from motorizare_niv;

-- 9) janta_niv
insert into janta_niv values(27, 37);
insert into janta_niv values(28, 37);
insert into janta_niv values(29, 38);
insert into janta_niv values(30, 38);
insert into janta_niv values(31, 39);
insert into janta_niv values(27, 39);
insert into janta_niv values(28, 40);
insert into janta_niv values(29, 40);
insert into janta_niv values(30, 41);
insert into janta_niv values(31, 42);

select * from janta_niv;

-- 10) tapit_niv
insert into tapit_niv values(27, 43);
insert into tapit_niv values(28, 43);
insert into tapit_niv values(29, 44);
insert into tapit_niv values(30, 44);
insert into tapit_niv values(31, 45);
insert into tapit_niv values(27, 45);
insert into tapit_niv values(28, 46);
insert into tapit_niv values(29, 46);
insert into tapit_niv values(30, 47);
insert into tapit_niv values(31, 47);

select * from tapit_niv;

-- 12) vopsea_niv
insert into vopsea_niv values(27, 48);
insert into vopsea_niv values(28, 48);
insert into vopsea_niv values(29, 49);
insert into vopsea_niv values(30, 49);
insert into vopsea_niv values(31, 50);
insert into vopsea_niv values(27, 50);
insert into vopsea_niv values(28, 51);
insert into vopsea_niv values(29, 51);
insert into vopsea_niv values(30, 52);
insert into vopsea_niv values(31, 52);

select * from vopsea_niv;

-- 11) extraop_niv
insert into extraop_niv values(27, 53);
insert into extraop_niv values(28, 53);
insert into extraop_niv values(29, 54);
insert into extraop_niv values(30, 54);
insert into extraop_niv values(31, 55);
insert into extraop_niv values(27, 55);
insert into extraop_niv values(28, 56);
insert into extraop_niv values(29, 56);
insert into extraop_niv values(30, 57);
insert into extraop_niv values(31, 57);
insert into extraop_niv values(31, 58);
insert into extraop_niv values(27, 58);
insert into extraop_niv values(28, 59);
insert into extraop_niv values(29, 59);
insert into extraop_niv values(30, 60);
insert into extraop_niv values(31, 60);
insert into extraop_niv values(31, 61);
insert into extraop_niv values(27, 61);
insert into extraop_niv values(28, 62);
insert into extraop_niv values(29, 62);

select * from extraop_niv;

-- 18) configuratie

insert into configuratie(id_configuratie, id_nivel, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_reprezentanta)
values (secventa_inc_id.nextval, 27, 33, 37, 43, 50, 11);
insert into configuratie(id_configuratie, id_nivel, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_reprezentanta)
values (secventa_inc_id.nextval, 28, 32, 40, 43, 51, 15);
insert into configuratie(id_configuratie, id_nivel, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_reprezentanta)
values (secventa_inc_id.nextval, 29, 32, 38, 46, 49, 12);
insert into configuratie(id_configuratie, id_nivel, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_reprezentanta)
values (secventa_inc_id.nextval, 30, 34, 41, 47, 52, 13);
insert into configuratie(id_configuratie, id_nivel, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_reprezentanta)
values (secventa_inc_id.nextval, 31, 35, 42, 47, 50, 14);

select * from configuratie;

-- 19) conf_extraop
insert into conf_extraop(id_configuratie, id_extraoptiune) values (63, 53);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (63, 61);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (64, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (64, 59);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (65, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (65, 62);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (66, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (66, 60);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (67, 55);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (67, 60);

select * from conf_extraop;

-- 20) client

insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ion', 'Ion', '28-FEB-1975');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Popescu', 'Mihai', '12-DEC-1995');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ionescu', 'George', '14-MAR-2000');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ilie', 'Claudia', '22-JUN-1955');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Oprea', 'Alexandru', '21-FEB-1970');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ursu', 'Laurentiu', '8-SEP-1982');

select * from client;


-- 21) dealer

insert into dealer (id_dealer, nume, prenume, data_angajare) values (secventa_inc_id.nextval, 'Moraru', 'Stefan', '6-SEP-2021');
insert into dealer (id_dealer, nume, prenume, data_angajare) values (secventa_inc_id.nextval, 'Alexandru', 'Gheorghe', '12-DEC-2021');
insert into dealer (id_dealer, nume, prenume) values (secventa_inc_id.nextval, 'Moraru', 'Stefan');
insert into dealer (id_dealer, nume, prenume, data_angajare) values (secventa_inc_id.nextval, 'Bilet', 'Adrian', '26-FEB-2021');
insert into dealer (id_dealer, nume, prenume, data_angajare) values (secventa_inc_id.nextval, 'Goga', 'Albert', '11-MAY-2021');
insert into dealer (id_dealer, nume, prenume, data_angajare) values (secventa_inc_id.nextval, 'Mihai', 'Octavian', '15-AUG-2021');

select * from dealer;

-- 22) oferta (id_configuratie, id_client, id_dealer, pret_oferta)
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (63, 68, 74, 29002);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (63, 69, 75, 12320);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (64, 70, 76, 12071);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (64, 71, 77, 23683);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (65, 72, 78, 18657);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (65, 73, 79, 26654);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (66, 68, 74, 17463);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (66, 69, 75, 8919);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (67, 70, 76, 28684);
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta) values (67, 71, 77, 16856);

select * from oferta;

commit;


/*
 Ex 12.1 Sa se afiseze id-ul, numele reprezentantelor care vand masini 
 care pot avea un nivel de echipare care incepe cu litera 's', cat 
 si pretul acestor nivele. Sa se ordoneze descrescator dupa pret. 
 Am folosit operatie join intre 4 tabele, filtrara la nivel de linii, functii pe 
 siruri de caractere (lower), ordonarea datelor.
*/
    
select distinct r.id_reprezentanta, r.nume, ne.pret
from reprez_auto r
    join modele_disp m on r.id_reprezentanta = m.id_reprezentanta
    join model_masina mm on mm.id_model = m.id_model
    join niv_ech_disp ned on mm.id_model = ned.id_model
    join nivel_echipare ne on ne.id_nivel = ned.id_nivel 
where lower(ne.nume) like 's%' 
order by ne.pret desc;

/*
Ex 12.2 Sa se afiseze numele si descrierea extraoptiunilor, ordonate alfabetic dupa nume,
 (in cazul in care descrierea este NULL se va inlocui cu 'Fara descriere') care 
 sunt mai ieftine decat media extraoptiunilor si care se afla in configuratii care 
 au fost oferite de dealeri angajati in anul 2021.
 Am folosit join pe 4 tabele, filtrare la nivel de linii, subcerere necorelata, 
 functii grup (avg), ordonare, nvl, functii pe siruri de caractere(to_char).
*/
select e.nume, nvl(e.descriere, 'Fara descriere')
from extraoptiune e
where e.pret < (select avg(pret) from extraoptiune) and id_extraoptiune in (
    select ce.id_extraoptiune from conf_extraop ce, configuratie c, oferta o, dealer d where
    ce.id_configuratie = c.id_configuratie and
    c.id_configuratie = o.id_configuratie and
    o.id_dealer = d.id_dealer
    and to_char(d.data_angajare, 'YYYY') = '2021'
) 
order by e.nume;


/*
Ex 12.3 Sa se afiseze pentru fiecare model cate nivele de echipare fara descriere si mai 
scumpe decat maximul pretului motoarelor disponibile pentru acel model se pot alege. 
Am folosit operatie join pe 4 tabele, filtrare la nivel de linii, functii grup, 
grupari de date, bloc de cerere with.
*/
with mot_pret_max as (
    select ned.id_model as id_model, max(mo.pret) as pret_max_motor
    from motorizare mo, motorizare_niv mn, niv_ech_disp ned
    where mo.id_motorizare = mn.id_motorizare and mn.id_nivel = ned.id_nivel
    group by ned.id_model
)
select m.id_model, count(decode(ne.descriere, null, 1, null))
from nivel_echipare ne, niv_ech_disp ned, model_masina m, mot_pret_max mpx
where ne.id_nivel = ned.id_nivel and ned.id_model = m.id_model and ne.pret > mpx.pret_max_motor and m.id_model = mpx.id_model
group by m.id_model;


select max(pret_max_motor)
from (
select ned.id_model as id_model, max(mo.pret) as pret_max_motor
from motorizare mo, motorizare_niv mn, niv_ech_disp ned
where mo.id_motorizare = mn.id_motorizare and mn.id_nivel = ned.id_nivel
group by ned.id_model);

/*
 Ex 12.4 Sa se afiseze pentru clientii care au varsta peste 25 de ani, prenumele, iar pentru cei 
 sub 25 sau care nu au data nasterii introdusa, pretul maxim al unei oferte care le-a fost prezentata 
 de un dealer care este angajat de mai putin de 6 luni.
 Am folosit filtrare la nivel de linii, subcereri, functii grup, functii pe 
 date calendaristice, nvl, expresie case.
*/
select 
case
    when trunc(months_between(sysdate,nvl(c.data_nastere, sysdate)) / 12) > 25 then
        c.prenume
    else
        (select max(to_char(o.pret_oferta)) from oferta o where o.id_dealer in
                                                  (select d.id_dealer 
                                                    from dealer d
                                                    where months_between(d.data_angajare, sysdate) < 6))
end 
from client c;


/*
Ex 12.5 Sa se afiseze toti clientii care au primit minim o oferta de la un angajat al carui nume 
incepe cu 'm'. 
Am folosit subcerere corelata, filtrare la nivel de linii, functii grup
*/
select * 
from client c where 
                (select count(*) from oferta o 
                where c.id_client = o.id_client 
                  and o.id_dealer in (
                      select id_dealer from dealer where lower(nume) like 'm%')
                ) >= 1;

/*
13.1 Sa se actualizeze pretul la valoarea de 20000 pentru toate ofertele facute 
de un dealer care a fost angajat inainte ca toti clientii pentru care au fost facute 
oferte sa se nasca.
*/
update oferta
set pret_oferta = 20000
where id_dealer in (select id_dealer
                    from dealer 
                    where to_char(data_angajare, 'dd-MM-YYYY') <= any( select to_char(data_nastere, 'dd-MM-YYYY')
                                            from oferta o, dealer d, client c
                                            where o.id_dealer = d.id_dealer and o.id_client = c.id_client));


/*
13.2 S? se stearg? toate configuratiile care nu au cel putin o extraoptiune.
*/
delete from configuratie c
where c.id_configuratie in (select distinct id_configuratie 
                            from conf_extraop c 
                            where (select count(*) 
                                    from conf_extraop conf 
                                    where conf.id_configuratie = c.id_configuratie) = 0);




/*
13.3 Sa se seteze pentru extraoptiune atributul descriere cu 'Fara descriere' 
daca campul este null si au fost folosite macar intr-o configuratie.
*/

select * from extraoptiune;
update extraoptiune e
set e.descriere = 'Fara descriere'
where e.descriere is null and e.id_extraoptiune in (select distinct id_extraoptiune 
                                                from conf_extraop conf 
                                                where (select count(*) 
                                                        from conf_extraop ce 
                                                        where conf.id_extraoptiune = ce.id_extraoptiune) != 0);






--incercari
select * from nivel_echipare ne 
where lower(ne.nume) like 's%' and ne.id_nivel in (
     select id_extraoptiune 
     from extraop_niv en 
     where ne.id_extraoptiune = en.id_extraoptiune
     );
     
     
/*
 Sa se afiseze nivelele de echipare al caror nume incepe cu 'S' si pot avea extraoptiuni care au pretul mai mic decat media preturilor motorizarilor
 */

 select from nivel_echipare ne where lower(ne.nume) like 's%' and ne.id_nivel in (
     select id_nivel 
     from extraop_niv en, extraop eo
     where en.id_extraoptiune = eo.id_extraoptiune and 
           eo.pret < (select avg(pret) from motorizare)

 );
 
 
/*
 Sa se afiseze configuratiile care au pretul mai mare decat media preturilor configuratiilor oferite de un dealer al carui nume incepe cu 'Ion'
 */
 select * 
 from configuratie c 
 where c.pret > (select avg(o.pret) 
                 from oferta o, dealer d 
                 where o.id_configuratie = c.id_configuratie and d.nume like 'Ion%');
 
 
update extraoptiune
set descriere = null
where id_extraoptiune=57;
                                            
                                    




