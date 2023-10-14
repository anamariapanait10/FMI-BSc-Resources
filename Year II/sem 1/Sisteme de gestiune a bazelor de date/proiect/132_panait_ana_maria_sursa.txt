-- 4
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
    id_reprez number(5) constraint pk_reprez_auto primary key,
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
    id_reprez number(5),
    id_model number(5),
    cantitate number(38) not null,
    constraint pk_id_modele_disp primary key(id_reprez, id_model),
    constraint fk_id_modele_disp_reprez foreign key(id_reprez) references reprez_auto(id_reprez) on delete cascade,
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
    id_motorizare number(5) not null,
    id_janta number(5) not null,
    id_tapiterie number(5) not null,
    id_vopsea number(5) not null,
    id_nivel number(5) not null,
    id_reprez number(5) not null,
    id_model number(5) not null,
    pret_total number(9, 2),
    constraint fk_configuratie_id_motorizari foreign key(id_motorizare) references motorizare(id_motorizare) on delete cascade,
    constraint fk_configuratie_id_janta foreign key(id_janta) references janta(id_janta) on delete cascade,
    constraint fk_configuratie_id_tapiterie foreign key(id_tapiterie) references tapiterie(id_tapiterie) on delete cascade,
    constraint fk_configuratie_id_vopsele foreign key(id_vopsea) references vopsea(id_vopsea) on delete cascade,
    constraint fk_configuratie_id_nivel foreign key(id_nivel) references nivel_echipare(id_nivel) on delete cascade,
    constraint fk_configuratie_id_reprez foreign key(id_reprez) references reprez_auto(id_reprez) on delete cascade,
    constraint fk_configuratie_id_model foreign key(id_model) references model_masina(id_model) on delete cascade
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
    data_angajare date default sysdate,
    id_reprez number(5),
    constraint fk_dealer_id_reprez foreign key(id_reprez) references reprez_auto(id_reprez) on delete cascade
);

create table oferta(
    id_configuratie number(5),
    id_client number(5),
    id_dealer number(5),
    pret_oferta number(9, 2),
    data_inceput date,
    data_expirare date,
    constraint pk_id_oferta primary key(id_configuratie, id_client, id_dealer),
    constraint fk_id_oferta_configuratie foreign key(id_configuratie) references configuratie(id_configuratie) on delete cascade,
    constraint fk_id_oferta_client foreign key(id_client) references client(id_client)on delete cascade,
    constraint fk_id_oferta_dealer foreign key(id_dealer) references dealer(id_dealer)on delete cascade
);

--5
insert into firma_auto values (secventa_inc_id.nextval, 'Skoda'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Renault');  
insert into firma_auto values (secventa_inc_id.nextval, 'Dacia'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Toyota'); 
insert into firma_auto values (secventa_inc_id.nextval, 'Suzuki'); 

insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Bucuresti', 'Crinul de Padure', 2);
insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Bucuresti', 'Ion Mincu', 3);
insert into locatie values (secventa_inc_id.nextval, 'Romania', 'Iasi', 'Vasile Alecsandri', 1);
insert into locatie values (secventa_inc_id.nextval, 'Italia', 'Roma', 'Bocca di Leone', 5);
insert into locatie values (secventa_inc_id.nextval, 'Franta', 'Paris', 'Theatre des Champs Elysees', 6);

insert into reprez_auto values (secventa_inc_id.nextval, 'Porsche Bucuresti Vest', 1, 6);
insert into reprez_auto values (secventa_inc_id.nextval, 'Porsche Iasi', 2, 7);
insert into reprez_auto values (secventa_inc_id.nextval, 'Brady Auto', 3, 8);
insert into reprez_auto values (secventa_inc_id.nextval, 'AutoItalia', 4, 9);
insert into reprez_auto values (secventa_inc_id.nextval, 'Roland Auto', 5, 10);

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

insert into nivel_echipare (id_nivel, nume, descriere, pret) values (secventa_inc_id.nextval, 'Basic', 'Nivel standard care contine dotari de baza', 2000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Spirit', 3000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Pasion', 5000);
insert into nivel_echipare (id_nivel, nume, pret) values (secventa_inc_id.nextval, 'Style', 6500);
insert into nivel_echipare (id_nivel, nume, descriere, pret) values (secventa_inc_id.nextval, 'RS', 'Varianta sportiva pentru pasionati auto', 10000);

insert into niv_ech_disp values(27, 17);
insert into niv_ech_disp values(27, 18);
insert into niv_ech_disp values(27, 21);
insert into niv_ech_disp values(27, 22);
insert into niv_ech_disp values(27, 23);
insert into niv_ech_disp values(27, 24);
insert into niv_ech_disp values(27, 25);
insert into niv_ech_disp values(28, 18);
insert into niv_ech_disp values(28, 19);
insert into niv_ech_disp values(28, 20);
insert into niv_ech_disp values(28, 23);
insert into niv_ech_disp values(28, 24);
insert into niv_ech_disp values(28, 25);
insert into niv_ech_disp values(28, 26);
insert into niv_ech_disp values(29, 18);
insert into niv_ech_disp values(29, 19);
insert into niv_ech_disp values(29, 20);
insert into niv_ech_disp values(29, 23);
insert into niv_ech_disp values(29, 24);
insert into niv_ech_disp values(29, 25);
insert into niv_ech_disp values(30, 16);
insert into niv_ech_disp values(30, 17);
insert into niv_ech_disp values(30, 21);
insert into niv_ech_disp values(30, 22);
insert into niv_ech_disp values(30, 26);
insert into niv_ech_disp values(31, 16);
insert into niv_ech_disp values(31, 24);
insert into niv_ech_disp values(31, 26);

insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'diesel', 170, 2000, 'Automata', 7, 130, 2500);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'diesel', 150, 2200, 'Manuala', 8, 135, 2000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'benzina', 90, 1200, 'Automata', 7, 110, 1800);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'benzina', 80, 1000, 'Manuala', 6, 130, 1600);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'hybrid', 220, 2000, 'Automata', 5, 90, 6000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'hybrid', 180, 1800, 'Manuala', 5, 80, 5000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'plug-in hybrid', 250, 2000, 'Automata', 4, 130, 8000);
insert into motorizare(id_motorizare, combustibil, putere, capacitate, transmisie, consum, emisii, pret) values (secventa_inc_id.nextval, 'electric', 180, 0, 'Automata', 0, 0, 15000);

insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Basic small', 'tabla', '#000000', 14, 200);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Basic large', 'tabla', '#000000', 15, 400);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Aero', 'aliaj', '#AAAAAA', 16, 800);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Aero PRO', 'magneziu', '#111111', 18, 2000);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Perseus', 'aliaj', '#A1A1A1', 19, 3000);
insert into janta(id_janta, nume, material, culoare, diametru, pret) values (secventa_inc_id.nextval, 'Z-performance', 'magneziu', '#FFCC00', 21, 4000);

insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Stofa','#000000',100);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Stofa','#CC6600',200);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#000000',800);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#804000',1000);
insert into tapiterie (id_tapiterie, material, culoare, pret) VALUES (secventa_inc_id.nextval,'Piele','#FFFFFF',1200);

insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Energy Blue', '#3366FF', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Magic Black', '#404040', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Candy White', '#EEEEEE', 100);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Race Blue', '#0052CC', 500);
insert into vopsea (id_vopsea, nume, cod_culoare, pret) values (secventa_inc_id.nextval, 'Velvet Red', '#CC0000', 750);

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

insert into motorizare_niv values(27, 35);
insert into motorizare_niv values(27, 33);
insert into motorizare_niv values(27, 37);
insert into motorizare_niv values(28, 32);
insert into motorizare_niv values(28, 33);
insert into motorizare_niv values(28, 34);
insert into motorizare_niv values(28, 35);
insert into motorizare_niv values(28, 36);
insert into motorizare_niv values(28, 37);
insert into motorizare_niv values(29, 33);
insert into motorizare_niv values(29, 34);
insert into motorizare_niv values(29, 35);
insert into motorizare_niv values(30, 32);
insert into motorizare_niv values(30, 33);
insert into motorizare_niv values(30, 34);
insert into motorizare_niv values(30, 35);
insert into motorizare_niv values(30, 37);
insert into motorizare_niv values(31, 36);
insert into motorizare_niv values(31, 38);
insert into motorizare_niv values(31, 39);

insert into janta_niv values(27, 40);
insert into janta_niv values(27, 41);
insert into janta_niv values(28, 41);
insert into janta_niv values(28, 42);
insert into janta_niv values(29, 41);
insert into janta_niv values(29, 42);
insert into janta_niv values(29, 44);
insert into janta_niv values(30, 42);
insert into janta_niv values(30, 44);
insert into janta_niv values(31, 43);
insert into janta_niv values(31, 44);
insert into janta_niv values(31, 45);

insert into tapit_niv values(27, 46);
insert into tapit_niv values(27, 47);
insert into tapit_niv values(28, 46);
insert into tapit_niv values(28, 47);
insert into tapit_niv values(29, 46);
insert into tapit_niv values(29, 47);
insert into tapit_niv values(29, 48);
insert into tapit_niv values(30, 47);
insert into tapit_niv values(30, 48);
insert into tapit_niv values(30, 49);
insert into tapit_niv values(31, 48);
insert into tapit_niv values(31, 49);
insert into tapit_niv values(31, 50);

insert into vopsea_niv values(27, 51);
insert into vopsea_niv values(27, 52);
insert into vopsea_niv values(27, 53);
insert into vopsea_niv values(28, 52);
insert into vopsea_niv values(28, 53);
insert into vopsea_niv values(29, 51);
insert into vopsea_niv values(29, 52);
insert into vopsea_niv values(30, 51);
insert into vopsea_niv values(30, 54);
insert into vopsea_niv values(30, 53);
insert into vopsea_niv values(31, 51);
insert into vopsea_niv values(31, 52);
insert into vopsea_niv values(31, 53);
insert into vopsea_niv values(31, 54);
insert into vopsea_niv values(31, 55);

insert into extraop_niv values(27, 56);
insert into extraop_niv values(27, 57);
insert into extraop_niv values(27, 64);
insert into extraop_niv values(28, 56);
insert into extraop_niv values(28, 57);
insert into extraop_niv values(28, 64);
insert into extraop_niv values(28, 65);
insert into extraop_niv values(29, 56);
insert into extraop_niv values(29, 57);
insert into extraop_niv values(29, 63);
insert into extraop_niv values(29, 65);
insert into extraop_niv values(27, 65);
insert into extraop_niv values(30, 56);
insert into extraop_niv values(30, 57);
insert into extraop_niv values(30, 59);
insert into extraop_niv values(30, 60);
insert into extraop_niv values(30, 62);
insert into extraop_niv values(30, 63);
insert into extraop_niv values(30, 65);
insert into extraop_niv values(31, 56);
insert into extraop_niv values(31, 57);
insert into extraop_niv values(31, 58);
insert into extraop_niv values(31, 59);
insert into extraop_niv values(31, 60);
insert into extraop_niv values(31, 61);
insert into extraop_niv values(31, 62);
insert into extraop_niv values(31, 63);
insert into extraop_niv values(31, 64);
insert into extraop_niv values(31, 65);

insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 32, 42, 47, 51, 30, 11, 16);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 32, 44, 49, 53, 31, 11, 16);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 33, 40, 46, 52, 27, 11, 17);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 41, 47, 51, 27, 11, 17);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 44, 48, 54, 30, 11, 17);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 40, 46, 51, 27, 12, 18);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 41, 47, 52, 28, 12, 18);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 32, 42, 46, 53, 28, 12, 19);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 34, 44, 48, 52, 29, 12, 19);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 33, 41, 46, 53, 28, 13, 20);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 42, 47, 52, 29, 13, 20);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 40, 46, 51, 27, 13, 21);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 32, 44, 49, 54, 30, 13, 21);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 34, 42, 48, 51, 30, 13, 22);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 40, 46, 53, 27, 14, 23);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 41, 47, 52, 28, 14, 23);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 33, 42, 48, 51, 29, 14, 24);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 41, 46, 52, 28, 14, 24);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 43, 50, 55, 31, 14, 24);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 33, 40, 46, 53, 27, 15, 25);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 35, 41, 47, 52, 28, 15, 25);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 34, 42, 48, 51, 29, 15, 25);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 37, 44, 49, 54, 30, 15, 26);
insert into configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
values (secventa_inc_id.nextval, 38, 45, 50, 55, 31, 15, 26);

insert into conf_extraop(id_configuratie, id_extraoptiune) values (66, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (66, 65);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (67, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (67, 58);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (68, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (68, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (68, 64);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (69, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (70, 62);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (70, 60);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (71, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (71, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (71, 64);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (72, 65);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (73, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (74, 63);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (75, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (76, 63);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (77, 64);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (78, 59);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (79, 62);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (79, 60);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (81, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (81, 64);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (83, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (83, 65);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (84, 64);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (85, 57);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (86, 56);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (87, 63);
insert into conf_extraop(id_configuratie, id_extraoptiune) values (88, 60);

insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ion', 'Ionut', '28-FEB-1975');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Popescu', 'Mihai', '12-DEC-1995');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ionescu', 'George', '14-MAR-2000');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ilie', 'Claudia', '22-JUN-1955');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Oprea', 'Alexandru', '21-FEB-1970');
insert into client (id_client, nume, prenume, data_nastere) values (secventa_inc_id.nextval, 'Ursu', 'Laurentiu', '8-SEP-1982');

insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Moraru', 'Stefan', '6-SEP-2021', 11);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Varzan', 'Gheorghe', '12-DEC-2021', 12);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Surdu', 'Mihai', '2-NOV-2019', 13);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Georgescu', 'Adrian', '26-FEB-2021', 14);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Goga', 'Albert', '11-MAY-2021', 15);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Vasilescu', 'Octavian', '15-AUG-2021', 11);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Ursu', 'Bogdan', '10-OCT-2012', 12);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Manole', 'Gheorghe', '22-JAN-2018', 13);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Panait', 'Alexandru', '3-JUN-2016', 14);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Bob', 'George', '21-FEB-2019', 15);
insert into dealer (id_dealer, nume, prenume, data_angajare, id_reprez) values (secventa_inc_id.nextval, 'Boboc', 'Ionut', '16-MAY-2020', 11);

insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (66, 90, 96, 29002, '15-AUG-2020', '15-AUG-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (66, 91, 101, 12320, '23-JUL-2021', '23-SEP-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (66, 92, 101, 29002, '8-OCT-2019', '8-NOV-2020');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (66, 93, 96, 12320, '22-JUL-2018', '22-AUG-2019');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (66, 94, 96, 29002, '9-MAR-2023', '9-APR-2024');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (67, 95, 106, 12071, '14-JAN-2021', '14-JAN-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (67, 90, 101, 23683, '1-NOV-2021', '1-NOV-2022');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (68, 91, 96, 18657, '4-FEB-2019', '4-MAR-2019');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (68, 92, 101, 26654, '10-APR-2022', '10-APR-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (69, 93, 106, 17463, '11-DEC-2024', '11-DEC-2026');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (69, 94, 96, 8919, '8-APR-2020', '20-APR-2020');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (70, 95, 96, 28684, '20-JUN-2022', '20-JUL-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (71, 90, 102, 16856, '1-JUL-2020', '30-JUL-2020');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (72, 91, 97, 28684, '18-JAN-2021', '21-FEB-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (72, 92, 97, 16856, '2-APR-2022', '9-APR-2022');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (73, 93, 102, 28684, '13-SEP-2022', '13-OCT-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (74, 94, 97, 16856, '22-MAY-2022', '22-MAY-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (75, 95, 103, 28684, '17-OCT-2020', '17-OCT-2024');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (76, 90, 98, 16856, '14-NOV-2022', '14-NOV-2024');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (77, 91, 103, 28684, '24-SEP-2021', '24-DEC-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (77, 92, 103, 16856, '4-JAN-2020', '4-JAN-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (78, 93, 103, 28684, '24-SEP-2021', '24-DEC-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (78, 94, 98, 16856, '4-FEB-2020', '4-FEB-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (78, 95, 98, 16856, '13-JAN-2022', '13-JAN-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (79, 90, 98, 16856, '25-APR-2016', '25-MAY-2017');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (80, 91, 104, 16856, '21-DEC-2018', '21-JAN-2020');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (81, 92, 104, 16856, '13-JAN-2023', '13-JAN-2024');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (81, 93, 99, 16856, '4-JAN-2020', '4-JAN-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (82, 94, 99, 16856, '24-SEP-2021', '24-DEC-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (83, 95, 104, 16856, '13-JAN-2022', '13-JAN-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (84, 90, 99, 16856, '10-APR-2022', '10-APR-2023');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (85, 91, 100, 16856, '22-JUL-2018', '22-AUG-2019');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (86, 92, 105, 16856, '4-JAN-2020', '4-JAN-2021');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (87, 93, 100, 16856, '8-OCT-2019', '8-NOV-2020');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (88, 94, 105, 16856, '9-MAR-2024', '9-APR-2024');
insert into oferta(id_configuratie, id_client, id_dealer, pret_oferta, data_inceput, data_expirare) values (89, 95, 105, 16856, '9-MAR-2023', '9-APR-2024');

-- 6
CREATE OR REPLACE PROCEDURE actualiz_oferte_exp IS
    TYPE oferta_record IS RECORD
    (cod_config oferta.id_configuratie%TYPE,
    pret oferta.pret_oferta%TYPE,
    cod_client oferta.id_client%TYPE,
    cod_dealer oferta.id_dealer%TYPE);

    TYPE t_tbl_imbricat IS TABLE OF oferta_record;
    t_oferta t_tbl_imbricat;

    TYPE dealer_record IS RECORD
    (cod_dealer dealer.id_dealer%TYPE,
    nume dealer.nume%TYPE,
    prenume dealer.prenume%TYPE);

    TYPE t_tbl_indx_dealer IS TABLE OF dealer_record INDEX BY PLS_INTEGER;
    t_dealer t_tbl_indx_dealer := t_tbl_indx_dealer();

    TYPE client_record IS RECORD
    (cod_client client.id_client%TYPE,
    nume client.nume%TYPE,
    prenume client.prenume%TYPE);

    TYPE t_tbl_indx_client IS TABLE OF client_record  INDEX BY PLS_INTEGER;
    t_client t_tbl_indx_client := t_tbl_indx_client();

    are_oferte_expirate BOOLEAN;
BEGIN
    SELECT id_dealer, nume, prenume BULK COLLECT INTO t_dealer
    FROM dealer
    ORDER BY nume;

    SELECT id_client, nume, prenume BULK COLLECT INTO t_client
    FROM client;

    SELECT id_configuratie, pret_oferta, id_client, id_dealer BULK COLLECT INTO t_oferta
    FROM oferta
    WHERE data_expirare < sysdate;

    IF t_oferta.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista oferte expirate');
        RETURN;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Ofertele expirate sunt:');

    FOR i IN t_dealer.FIRST..t_dealer.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('- Dealerul ' || t_dealer(i).nume ||' '||t_dealer(i).prenume||': ');
        are_oferte_expirate := false;
        FOR j IN t_oferta.FIRST..t_oferta.LAST LOOP
            IF t_oferta(j).cod_dealer = t_dealer(i).cod_dealer THEN
                are_oferte_expirate := true;
                DBMS_OUTPUT.PUT(' -> oferta pentru configuratia ' || t_oferta(j).cod_config || ' facuta pentru clientul ');
                FOR k IN t_client.FIRST..t_client.LAST LOOP
                    IF t_oferta(j).cod_client = t_client(k).cod_client THEN
                        DBMS_OUTPUT.PUT(t_client(k).nume || ' ' || t_client(k).prenume);
                    END IF;
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(' cu pretul de ' || t_oferta(j).pret);
            END IF;
        END LOOP;

        IF are_oferte_expirate = false THEN
            DBMS_OUTPUT.PUT_LINE(' Nu are nicio oferta expirata');
        END IF;
    END LOOP;
    FOR o IN t_oferta.FIRST..t_oferta.LAST LOOP
        UPDATE OFERTA SET data_inceput = sysdate WHERE id_configuratie=t_oferta(o).cod_config and id_dealer=t_oferta(o).cod_dealer and id_client=t_oferta(o).cod_client;
        UPDATE OFERTA SET data_expirare = add_months(sysdate, 24) WHERE id_configuratie=t_oferta(o).cod_config and id_dealer=t_oferta(o).cod_dealer and id_client=t_oferta(o).cod_client;
    END LOOP;
END actualiz_oferte_exp;
/

BEGIN
 actualiz_oferte_exp();
END;
/

--7
CREATE OR REPLACE PROCEDURE actualiz_pret_mot(d dealer.nume%TYPE) IS
    -- cursor cu toate configuratiile care apar in ofertele 
    -- dealerului cu numele dat ca parametru
    CURSOR c7 (d1 dealer.nume%TYPE) IS 
        SELECT c.id_configuratie, c.id_motorizare
        FROM oferta o, configuratie c, dealer de
        WHERE o.id_configuratie = c.id_configuratie and o.id_dealer = de.id_dealer 
                and lower(de.nume) = lower(d1);
    
    v_pret_vechi NUMBER;
    v_pret_nou NUMBER;
    v_macar_o_actualizare BOOLEAN := FALSE;
    v_contor NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_contor
    FROM dealer de
    WHERE lower(de.nume)=lower(d);
    
    IF v_contor = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun dealer cu acest nume');
    ELSE
        FOR i in c7(d) LOOP
            FOR j IN (SELECT *
                        FROM motorizare
                        WHERE emisii > 120 and capacitate > (SELECT AVG(capacitate)
                                                            FROM motorizare)) LOOP
                IF i.id_motorizare = j.id_motorizare THEN
                    SELECT pret INTO v_pret_vechi
                    FROM motorizare 
                    WHERE id_motorizare=i.id_motorizare;
                    
                    UPDATE motorizare
                    SET pret = pret + 500
                    WHERE id_motorizare=i.id_motorizare;
                    
                    SELECT pret INTO v_pret_nou
                    FROM motorizare 
                    WHERE id_motorizare=i.id_motorizare;
                    
                    DBMS_OUTPUT.PUT_LINE('Pretul motorizarii cu id-ul ' || i.id_motorizare || ' era ' || v_pret_vechi || ' si acum e ' || v_pret_nou);
                    v_macar_o_actualizare := TRUE;
                END IF;
            END LOOP;
        END LOOP;
        
        IF v_macar_o_actualizare = FALSE THEN
            DBMS_OUTPUT.PUT_LINE('Conditiile nu sunt indeplinite de nicio motorizare.');
        END IF;
    END IF;
END actualiz_pret_mot;
/


BEGIN
    DBMS_OUTPUT.PUT_LINE('Pentru dealerul ''Moraru'':');
    actualiz_pret_mot('Moraru');
    
    DBMS_OUTPUT.PUT_LINE('Pentru dealerul ''Varzan'':');
    actualiz_pret_mot('Varzan');
    
    DBMS_OUTPUT.PUT_LINE('Pentru dealerul ''Inexistent'':');
    actualiz_pret_mot('Inexistent');
END;
/

--8
CREATE OR REPLACE FUNCTION cel_mai_popular_model_din_reprez(v_nume_reprez_auto REPREZ_AUTO.nume%TYPE)
RETURN VARCHAR2 IS
    v_id_reprez REPREZ_AUTO.id_reprez%TYPE;
    
    TYPE vect IS VARRAY(1000) OF MODEL_MASINA.nume%TYPE;
    modele vect := vect();
    
    v_contor NUMBER;
    
    FARA_REPREZ EXCEPTION;
    FARA_CONFIG EXCEPTION;
    PREA_MULTE_MODELE EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO v_contor
    FROM REPREZ_AUTO
    WHERE lower(nume) = lower(v_nume_reprez_auto);
    
    IF v_contor = 0 THEN
        RAISE FARA_REPREZ;
    END IF; -- nu avem cum sa avem contorul > 1 pt ca numele din tabelul reprez_auto este unique
    
    SELECT id_reprez INTO v_id_reprez
    FROM REPREZ_AUTO
    WHERE lower(nume) = lower(v_nume_reprez_auto);
    -- datorita verificarii de mai sus stim ca exista o reprezentanta si numai una cu acest nume deci nu se vor genera erori
    
    -- luam toate modelele care au numarul de aparitii din configuratiile reprezentantei maxim
    SELECT mm.nume BULK COLLECT INTO modele
    FROM REPREZ_AUTO r JOIN MODELE_DISP md ON r.id_reprez=md.id_reprez 
        JOIN MODEL_MASINA mm ON md.id_model=mm.id_model
        JOIN CONFIGURATIE c ON mm.id_model=c.id_model
    WHERE r.id_reprez = v_id_reprez
    GROUP BY c.id_model, mm.nume
    HAVING COUNT(*) = (
                        SELECT MAX(COUNT(cc.id_model))
                        FROM CONFIGURATIE cc
                        WHERE cc.id_reprez = v_id_reprez
                        GROUP BY cc.id_model
                        );
                
    IF modele.count = 0 THEN
        RAISE FARA_CONFIG;
    ELSIF modele.count > 1 THEN
        RAISE PREA_MULTE_MODELE;
    END IF;
    
    RETURN 'Modelul care apare cel mai des in configuratii in reprezentanta ' || v_nume_reprez_auto || ' este ' || modele(1) ||'.';
EXCEPTION
    WHEN FARA_REPREZ THEN
        RETURN 'Nu exista nicio reprezentanta auto cu acest nume.';
    WHEN FARA_CONFIG THEN
        RETURN 'Nu exista configuratii incercate pentru acesta reprezentanta.';
    WHEN PREA_MULTE_MODELE THEN
        RETURN 'Exista mai multe modele cu numarul de aparitii maxim in configuratii pentru acesta reprezentanta.';
END cel_mai_popular_model_din_reprez;
/

BEGIN 
    DBMS_OUTPUT.PUT_LINE('Reprezentanta Porsche Bucuresti Vest:');
    DBMS_OUTPUT.PUT_LINE('-> ' || cel_mai_popular_model_din_reprez('Porsche Bucuresti Vest'));
    
    -- stergem temporar configuratiile din reprezentanta AutoItalia
    -- pentru a testa generarea de eroare corespunzatoare
    DELETE
    FROM CONFIGURATIE c
    WHERE c.id_reprez = (SELECT id_reprez 
                        FROM REPREZ_AUTO r 
                        WHERE lower(r.nume)=lower('AutoItalia'));
    DBMS_OUTPUT.PUT_LINE('Reprezentanta AutoItalia:');
    DBMS_OUTPUT.PUT_LINE('-> ' || cel_mai_popular_model_din_reprez('AutoItalia'));
    ROLLBACK;
    
    -- genereaza PREA_MULTE_MODELE
    DBMS_OUTPUT.PUT_LINE('Reprezentanta Porsche Iasi:'); 
    DBMS_OUTPUT.PUT_LINE('-> ' || cel_mai_popular_model_din_reprez('Porsche Iasi'));
END; 
/

-- 9
CREATE OR REPLACE PROCEDURE mareste_pret_oferta(v_nume_model MODEL_MASINA.nume%TYPE, v_nume_dealer DEALER.nume%TYPE) IS
   v_id_model MODEL_MASINA.id_model%TYPE;
   v_contor NUMBER;
   v_nr_select NUMBER := 0;
   v_id_dealer DEALER.id_dealer%TYPE;
   v_oferta_id_conf OFERTA.id_configuratie%TYPE;
   v_oferta_id_dealer OFERTA.id_dealer%TYPE;
   v_oferta_id_client OFERTA.id_client%TYPE;
BEGIN
    SELECT id_model INTO v_id_model
    FROM MODEL_MASINA
    WHERE lower(nume) = lower(v_nume_model);
    
    v_nr_select := 1;
    SELECT id_dealer INTO v_id_dealer
    FROM DEALER
    WHERE lower(nume) = lower(v_nume_dealer);
    
    v_nr_select := 2;
    SELECT o.id_configuratie, o.id_dealer, o.id_client INTO v_oferta_id_conf, v_oferta_id_dealer, v_oferta_id_client
    FROM MODEL_MASINA mm JOIN CONFIGURATIE c ON mm.id_model=c.id_model
        JOIN OFERTA o ON c.id_configuratie=o.id_configuratie 
        JOIN DEALER d ON d.id_dealer=o.id_dealer
        JOIN CLIENT cl ON cl.id_client=o.id_client
    WHERE mm.id_model= v_id_model and d.id_dealer=v_id_dealer and trunc(months_between(sysdate, cl.data_nastere) / 12) < 45;
    
    UPDATE OFERTA o
    SET pret_oferta = pret_oferta + pret_oferta * 0.05
    WHERE o.id_configuratie=v_oferta_id_conf and o.id_dealer=v_oferta_id_dealer and o.id_client=v_oferta_id_client;
    
    DBMS_OUTPUT.PUT_LINE('Update pret oferta realizat cu succes');
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe oferte cu modelul dat, dealerul dat si facute pentru un client mai tanar de 45 de ani.');
    WHEN NO_DATA_FOUND THEN
        IF v_nr_select = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun model de masina cu numele dat.');
        ELSIF v_nr_select = 1 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun dealer cu numele dat.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nu exista nicio oferta cu modelul dat, dealerul dat si facuta pentru un client mai tanar de 45 de ani.');
        END IF;
END mareste_pret_oferta;
/

BEGIN 
    -- Exista o singura oferta care indeplineste conditiile deci nu se va generea nicio eroare, iar pretul va fi acualizat       
    DBMS_OUTPUT.PUT_LINE('Modelul ''Octavia'', dealerul ''Boboc'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('Octavia', 'Boboc');
    DBMS_OUTPUT.PUT_LINE('');
    
    
    -- Nu exista acest model de masina => se va genera NO_DATA_FOUND cu mesajul corespunzator
    DBMS_OUTPUT.PUT_LINE('Modelul ''ModelInexistent'', dealerul ''Vasilescu'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('ModelInexistent', 'Vasilescu');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Nu exista acest dealer => se va genera NO_DATA_FOUND cu mesajul corespunzator
    DBMS_OUTPUT.PUT_LINE('Modelul ''Octavia'', dealerul ''DealerInexistent'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('Octavia', 'DealerInexistent');
    DBMS_OUTPUT.PUT_LINE('');
   
    -- Exista oferte facute de acest dealer pentru acest model dar clientii carora le-a fost facuta oferta au mai mult de 45 de ani 
    -- => se va genera NO_DATA_FOUND si se va afisa mesajul corespunzator
    DBMS_OUTPUT.PUT_LINE('Modelul ''Octavia'', dealerul ''Moraru'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('Octavia', 'Moraru');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Exista acest model si acest dealer dar nu exista o oferta facuta de dealer pentru acest model
    -- => se va genereza NO_DATA_FOUND si se va afisa mesajul corespunzator
    DBMS_OUTPUT.PUT_LINE('Modelul ''Octavia'', dealerul ''Bob'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('Octavia', 'Bob');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Exista doua oferte care indeplinesc conditiile din cerinta
    -- => se va genera eroarea TOO_MANY_ROWS si se va afisa mesajul corespunzator
    DBMS_OUTPUT.PUT_LINE('Modelul ''Octavia'', dealerul ''Vasilescu'': ');
    DBMS_OUTPUT.PUT('-> ');
    mareste_pret_oferta('Octavia', 'Vasilescu');
    DBMS_OUTPUT.PUT_LINE('');
END; 
/

-- 10
CREATE OR REPLACE TRIGGER stergere_motoriz
    BEFORE DELETE ON motorizare
DECLARE
    v_nr_motoriz NUMBER;
BEGIN
    IF (TO_CHAR(sysdate, 'D') = 1 OR TO_CHAR(sysdate, 'D') = 2 OR TO_CHAR(sysdate, 'HH24') NOT BETWEEN 8 AND 20) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nu se poate sterge o motorizare inafara programului!');
    ELSE
        SELECT count(*) INTO v_nr_motoriz
        FROM motorizare m;
        
        IF v_nr_motoriz = 1 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Nu se poate sterge ultima motorizare disponibila!');
        END IF;  
    END IF;
END;
/

-- Declansare trigger
BEGIN
    -- Stergem toate motorizarile mai putin una
    DELETE 
    FROM motorizare
    WHERE id_motorizare!=32;
    DBMS_OUTPUT.PUT_LINE('A mai ramas o singura motorizare');
    -- Incercam stergerea ultimei => genereaza eroare
    DELETE 
    FROM motorizare
    WHERE id_motorizare=32;
    rollback;
END;
/

-- 11
CREATE OR REPLACE TRIGGER validare_config
    BEFORE INSERT OR UPDATE ON configuratie
    FOR EACH ROW
DECLARE
    v_pret_model NUMBER;
    v_pret_niv_ech NUMBER;
    v_pret_mot NUMBER;
    v_pret_jante NUMBER;
    v_pret_tapit NUMBER;
    v_pret_vopsea NUMBER; 
    v_contor NUMBER;
BEGIN
    -- Verificam compatibilitatea id-urilor date
    SELECT count(*) INTO v_contor
    FROM reprez_auto r, modele_disp md, model_masina mm, niv_ech_disp ned, nivel_echipare ne,
         motorizare_niv mn, motorizare mot, janta_niv jn, janta j, tapit_niv tn,
         tapiterie t, vopsea_niv vn, vopsea v
    WHERE r.id_reprez=md.id_reprez and md.id_model=mm.id_model and mm.id_model=ned.id_model and ned.id_nivel=ne.id_nivel
    and ne.id_nivel=mn.id_nivel and ne.id_nivel=jn.id_nivel and ne.id_nivel=tn.id_nivel
    and ne.id_nivel=vn.id_nivel and mn.id_motorizare=mot.id_motorizare and jn.id_janta=j.id_janta
    and tn.id_tapiterie=t.id_tapiterie and vn.id_vopsea=v.id_vopsea and r.id_reprez=:NEW.id_reprez
    and mm.id_model=:NEW.id_model and ne.id_nivel=:NEW.id_nivel and v.id_vopsea=:NEW.id_vopsea
    and t.id_tapiterie=:NEW.id_tapiterie and j.id_janta=:NEW.id_janta and mot.id_motorizare=:NEW.id_motorizare;

    IF v_contor > 0 THEN
        -- Daca am ajuns pana aici inseamna ca datele sunt valide si putem sa ne
        -- calculam pretul ca suma de componente din configuratie
        SELECT pret_pornire INTO v_pret_model
        FROM MODEL_MASINA mm
        WHERE mm.id_model=:NEW.id_model;

        SELECT pret INTO v_pret_niv_ech
        FROM NIVEL_ECHIPARE ne
        WHERE ne.id_nivel=:NEW.id_nivel;

        SELECT pret INTO v_pret_mot
        FROM MOTORIZARE mot
        WHERE mot.id_motorizare=:NEW.id_motorizare;

        SELECT pret INTO v_pret_jante
        FROM JANTA j
        WHERE j.id_janta=:NEW.id_janta;

        SELECT pret INTO v_pret_tapit
        FROM TAPITERIE t
        WHERE t.id_tapiterie=:NEW.id_tapiterie;

        SELECT pret INTO v_pret_vopsea
        FROM VOPSEA v
        WHERE v.id_vopsea=:NEW.id_vopsea;

        :NEW.pret_total := v_pret_model + v_pret_niv_ech + v_pret_mot + v_pret_jante + v_pret_tapit + v_pret_vopsea;
    ELSE
        RAISE_APPLICATION_ERROR ( -20001, 'Incompatibilitate intre componentele configuratiei!');
    END IF;
END;

select * from configuratie;
-- Declansare trigger
DECLARE
    v_pret NUMBER;
BEGIN
    -- Stergem temporar o configuratie valida
    DELETE 
    FROM configuratie
    WHERE id_configuratie=66;
    IF SQL%ROWCOUNT > 0 THEN
        -- Inseram configuratia stearsa dar fara pret care va fi actualizat de trigger
        -- Este o configuratie valida deci nu se va genera nicio eroare
        INSERT INTO configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
        VALUES (66, 32, 42, 47, 51, 30, 11, 16);
        
        SELECT pret_total INTO v_pret
        FROM configuratie
        WHERE id_configuratie=66;
        DBMS_OUTPUT.PUT_LINE('Pretul actualizat al configuratiei este ' || v_pret);
        
        -- Incercam sa inseram o configuratie cu componente incompatibile => triggerul va genera o eroare
        -- (nivelul de echipare nu e compatibil cu restul componentelor)
        INSERT INTO configuratie(id_configuratie, id_motorizare, id_janta, id_tapiterie, id_vopsea, id_nivel, id_reprez, id_model)
        VALUES (66, 32, 42, 47, 51, 31, 11, 16);
    
        rollback;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Id inexistent pentru configuratie');
    END IF;
END;
/


-- 12
CREATE TABLE istoric_comenzi(
    utilizator VARCHAR2(30),
    comanda VARCHAR(100),
    nume_bd VARCHAR(20),
    data date
);

CREATE OR REPLACE DIRECTORY CTEST AS 'C:\test';
GRANT READ ON DIRECTORY CTEST TO PUBLIC;

CREATE OR REPLACE TRIGGER t12
    AFTER CREATE OR DROP OR ALTER OR SERVERERROR ON DATABASE
DECLARE
    out_File  UTL_FILE.FILE_TYPE;
    v_count NUMBER;
BEGIN
    IF DBMS_UTILITY.FORMAT_ERROR_STACK IS NULL THEN
        INSERT INTO istoric_comenzi VALUES
            (SYS.LOGIN_USER, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
    ELSE
        out_File := UTL_FILE.FOPEN('CTEST', 'trigger_test.txt' , 'W');

        UTL_FILE.PUT_LINE(out_file , DBMS_UTILITY.FORMAT_ERROR_STACK);
        UTL_FILE.FCLOSE(out_file);
    END IF;
END;
/

CREATE TABLE test(id NUMBER);
ALTER TABLE test ADD col NUMBER;

-- 13
CREATE OR REPLACE PACKAGE pachet13 AS
    -- 6
    PROCEDURE actualiz_oferte_exp;
    -- 7
    PROCEDURE actualiz_pret_mot(d dealer.nume%TYPE);
    -- 8
    FUNCTION cel_mai_popular_model_din_reprez(v_nume_reprez_auto REPREZ_AUTO.nume%TYPE)
        RETURN VARCHAR2;
    -- 9
    PROCEDURE mareste_pret_oferta(v_nume_model MODEL_MASINA.nume%TYPE, v_nume_dealer DEALER.nume%TYPE);
END pachet13;
/

CREATE OR REPLACE PACKAGE BODY pachet13 AS
    --6. Afisare si actualizare de oferte expirate
    PROCEDURE actualiz_oferte_exp IS
        TYPE oferta_record IS RECORD
        (cod_config oferta.id_configuratie%TYPE,
        pret oferta.pret_oferta%TYPE,
        cod_client oferta.id_client%TYPE,
        cod_dealer oferta.id_dealer%TYPE);

        TYPE t_tbl_imbricat IS TABLE OF oferta_record;
        t_oferta t_tbl_imbricat;
    
        TYPE dealer_record IS RECORD
        (cod_dealer dealer.id_dealer%TYPE,
        nume dealer.nume%TYPE,
        prenume dealer.prenume%TYPE);
    
        TYPE t_tbl_indx_dealer IS TABLE OF dealer_record INDEX BY PLS_INTEGER;
        t_dealer t_tbl_indx_dealer := t_tbl_indx_dealer();
    
        TYPE client_record IS RECORD
        (cod_client client.id_client%TYPE,
        nume client.nume%TYPE,
        prenume client.prenume%TYPE);
    
        TYPE t_tbl_indx_client IS TABLE OF client_record  INDEX BY PLS_INTEGER;
        t_client t_tbl_indx_client := t_tbl_indx_client();
    
        are_oferte_expirate BOOLEAN;
    BEGIN
        SELECT id_dealer, nume, prenume BULK COLLECT INTO t_dealer
        FROM dealer
        ORDER BY nume;
    
        SELECT id_client, nume, prenume BULK COLLECT INTO t_client
        FROM client;
    
        SELECT id_configuratie, pret_oferta, id_client, id_dealer BULK COLLECT INTO t_oferta
        FROM oferta
        WHERE data_expirare < sysdate;
    
        IF t_oferta.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista oferte expirate');
            RETURN;
        END IF;
    
        DBMS_OUTPUT.PUT_LINE('Ofertele expirate sunt:');
    
        FOR i IN t_dealer.FIRST..t_dealer.LAST LOOP
            DBMS_OUTPUT.PUT_LINE('- Dealerul ' || t_dealer(i).nume ||' '||t_dealer(i).prenume||': ');
            are_oferte_expirate := false;
            FOR j IN t_oferta.FIRST..t_oferta.LAST LOOP
                IF t_oferta(j).cod_dealer = t_dealer(i).cod_dealer THEN
                    are_oferte_expirate := true;
                    DBMS_OUTPUT.PUT(' -> oferta pentru configuratia ' || t_oferta(j).cod_config || ' facuta pentru clientul ');
                    FOR k IN t_client.FIRST..t_client.LAST LOOP
                        IF t_oferta(j).cod_client = t_client(k).cod_client THEN
                            DBMS_OUTPUT.PUT(t_client(k).nume || ' ' || t_client(k).prenume);
                        END IF;
                    END LOOP;
                    DBMS_OUTPUT.PUT_LINE(' cu pretul de ' || t_oferta(j).pret);
                END IF;
            END LOOP;
    
            IF are_oferte_expirate = false THEN
                DBMS_OUTPUT.PUT_LINE(' Nu are nicio oferta expirata');
            END IF;
        END LOOP;
        FOR o IN t_oferta.FIRST..t_oferta.LAST LOOP
            UPDATE OFERTA SET data_inceput = sysdate WHERE id_configuratie=t_oferta(o).cod_config and id_dealer=t_oferta(o).cod_dealer and id_client=t_oferta(o).cod_client;
            UPDATE OFERTA SET data_expirare = add_months(sysdate, 24) WHERE id_configuratie=t_oferta(o).cod_config and id_dealer=t_oferta(o).cod_dealer and id_client=t_oferta(o).cod_client;
        END LOOP;
    END actualiz_oferte_exp;
    
    --7. Scumpire motorizari care au emisii si capaciatea cilindirca mare, proportional cu nr de oferte in care apar
    PROCEDURE actualiz_pret_mot(d dealer.nume%TYPE) IS
        -- cursor cu toate configuratiile care apar in ofertele 
        -- dealerului cu numele dat ca parametru
        CURSOR c7 (d1 dealer.nume%TYPE) IS 
            SELECT c.id_configuratie, c.id_motorizare
            FROM oferta o, configuratie c, dealer de
            WHERE o.id_configuratie = c.id_configuratie and o.id_dealer = de.id_dealer 
                    and lower(de.nume) = lower(d1);
        
        v_pret_vechi NUMBER;
        v_pret_nou NUMBER;
        v_macar_o_actualizare BOOLEAN := FALSE;
        v_contor NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_contor
        FROM dealer de
        WHERE lower(de.nume)=lower(d);
        
        IF v_contor = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Nu exista niciun dealer cu acest nume');
        ELSE
            FOR i in c7(d) LOOP
                FOR j IN (SELECT *
                            FROM motorizare
                            WHERE emisii > 120 and capacitate > (SELECT AVG(capacitate)
                                                                FROM motorizare)) LOOP
                    IF i.id_motorizare = j.id_motorizare THEN
                        SELECT pret INTO v_pret_vechi
                        FROM motorizare 
                        WHERE id_motorizare=i.id_motorizare;
                        
                        UPDATE motorizare
                        SET pret = pret + 500
                        WHERE id_motorizare=i.id_motorizare;
                        
                        SELECT pret INTO v_pret_nou
                        FROM motorizare 
                        WHERE id_motorizare=i.id_motorizare;
                        
                        DBMS_OUTPUT.PUT_LINE('Pretul motorizarii cu id-ul ' || i.id_motorizare || ' era ' || v_pret_vechi || ' si acum e ' || v_pret_nou);
                        v_macar_o_actualizare := TRUE;
                    END IF;
                END LOOP;
            END LOOP;
            
            IF v_macar_o_actualizare = FALSE THEN
                DBMS_OUTPUT.PUT_LINE('Conditiile nu sunt indeplinite de nicio motorizare.');
            END IF;
        END IF;
    END actualiz_pret_mot;

    --8. Cel mai popular model din configuratii dintr-o anumita reprezentanta
    FUNCTION cel_mai_popular_model_din_reprez(v_nume_reprez_auto REPREZ_AUTO.nume%TYPE)
    RETURN VARCHAR2 IS
        v_id_reprez REPREZ_AUTO.id_reprez%TYPE;
        
        TYPE vect IS VARRAY(1000) OF MODEL_MASINA.nume%TYPE;
        modele vect := vect();
        
        v_contor NUMBER;
        
        FARA_REPREZ EXCEPTION;
        FARA_CONFIG EXCEPTION;
        PREA_MULTE_MODELE EXCEPTION;
    BEGIN
        SELECT COUNT(*) INTO v_contor
        FROM REPREZ_AUTO
        WHERE lower(nume) = lower(v_nume_reprez_auto);
        
        IF v_contor = 0 THEN
            RAISE FARA_REPREZ;
        END IF; -- nu avem cum sa avem contorul > 1 pt ca numele din tabelul reprez_auto este unique
        
        SELECT id_reprez INTO v_id_reprez
        FROM REPREZ_AUTO
        WHERE lower(nume) = lower(v_nume_reprez_auto);
        -- datorita verificarii de mai sus stim ca exista o reprezentanta si numai una cu acest nume deci nu se vor genera erori
        
        -- luam toate modelele care au numarul de aparitii din configuratiile reprezentantei maxim
        SELECT mm.nume BULK COLLECT INTO modele
        FROM REPREZ_AUTO r JOIN MODELE_DISP md ON r.id_reprez=md.id_reprez 
            JOIN MODEL_MASINA mm ON md.id_model=mm.id_model
            JOIN CONFIGURATIE c ON mm.id_model=c.id_model
        WHERE r.id_reprez = v_id_reprez
        GROUP BY c.id_model, mm.nume
        HAVING COUNT(*) = (
                            SELECT MAX(COUNT(cc.id_model))
                            FROM CONFIGURATIE cc
                            WHERE cc.id_reprez = v_id_reprez
                            GROUP BY cc.id_model
                            );
                    
        IF modele.count = 0 THEN
            RAISE FARA_CONFIG;
        ELSIF modele.count > 1 THEN
            RAISE PREA_MULTE_MODELE;
        END IF;
        
        RETURN 'Modelul care apare cel mai des in configuratii in reprezentanta ' || v_nume_reprez_auto || ' este ' || modele(1) ||'.';
    EXCEPTION
        WHEN FARA_REPREZ THEN
            RETURN 'Nu exista nicio reprezentanta auto cu acest nume.';
        WHEN FARA_CONFIG THEN
            RETURN 'Nu exista configuratii incercate pentru acesta reprezentanta.';
        WHEN PREA_MULTE_MODELE THEN
            RETURN 'Exista mai multe modele cu numarul de aparitii maxim in configuratii pentru acesta reprezentanta.';
    END cel_mai_popular_model_din_reprez;
    
    --9. Scumpire oferta pentru un model de masina si un dealer dat
    PROCEDURE mareste_pret_oferta(v_nume_model MODEL_MASINA.nume%TYPE, v_nume_dealer DEALER.nume%TYPE) IS
       v_id_model MODEL_MASINA.id_model%TYPE;
       v_contor NUMBER;
       v_nr_select NUMBER := 0;
       v_id_dealer DEALER.id_dealer%TYPE;
       v_oferta_id_conf OFERTA.id_configuratie%TYPE;
       v_oferta_id_dealer OFERTA.id_dealer%TYPE;
       v_oferta_id_client OFERTA.id_client%TYPE;
    BEGIN
        SELECT id_model INTO v_id_model
        FROM MODEL_MASINA
        WHERE lower(nume) = lower(v_nume_model);
        
        v_nr_select := 1;
        SELECT id_dealer INTO v_id_dealer
        FROM DEALER
        WHERE lower(nume) = lower(v_nume_dealer);
        
        v_nr_select := 2;
        SELECT o.id_configuratie, o.id_dealer, o.id_client INTO v_oferta_id_conf, v_oferta_id_dealer, v_oferta_id_client
        FROM MODEL_MASINA mm JOIN CONFIGURATIE c ON mm.id_model=c.id_model
            JOIN OFERTA o ON c.id_configuratie=o.id_configuratie 
            JOIN DEALER d ON d.id_dealer=o.id_dealer
            JOIN CLIENT cl ON cl.id_client=o.id_client
        WHERE mm.id_model= v_id_model and d.id_dealer=v_id_dealer and trunc(months_between(sysdate, cl.data_nastere) / 12) < 45;
        
        UPDATE OFERTA o
        SET pret_oferta = pret_oferta + pret_oferta * 0.05
        WHERE o.id_configuratie=v_oferta_id_conf and o.id_dealer=v_oferta_id_dealer and o.id_client=v_oferta_id_client;
        
        DBMS_OUTPUT.PUT_LINE('Update pret oferta realizat cu succes');
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('Exista mai multe oferte cu modelul dat, dealerul dat si facute pentru un client mai tanar de 45 de ani.');
        WHEN NO_DATA_FOUND THEN
            IF v_nr_select = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista niciun model de masina cu numele dat.');
            ELSIF v_nr_select = 1 THEN
                DBMS_OUTPUT.PUT_LINE('Nu exista niciun dealer cu numele dat.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Nu exista nicio oferta cu modelul dat, dealerul dat si facuta pentru un client mai tanar de 45 de ani.');
            END IF;
    END mareste_pret_oferta;

END pachet13;
/

BEGIN
    pachet13.actualiz_oferte_exp();
    pachet13.actualiz_pret_mot('Moraru');
    DBMS_OUTPUT.PUT_LINE(pachet13.cel_mai_popular_model_din_reprez('Porsche Bucuresti Vest'));
    pachet13.mareste_pret_oferta('Octavia', 'Boboc');
    rollback;
END;
/
-- 14
CREATE OR REPLACE PACKAGE pachet14 AS
    TYPE oferta_record IS RECORD
    (cod_config oferta.id_configuratie%TYPE,
    pret oferta.pret_oferta%TYPE,
    cod_client oferta.id_client%TYPE,
    cod_dealer oferta.id_dealer%TYPE);

    TYPE t_tbl_imbricat IS TABLE OF oferta_record;
    t_oferta t_tbl_imbricat := t_tbl_imbricat();

    TYPE extraoptiune_record IS RECORD
    (cod_config configuratie.id_configuratie%TYPE,
    cod_extraop extraoptiune.id_extraoptiune%TYPE,
    nume extraoptiune.nume%TYPE);

    TYPE vector IS VARRAY (100) OF extraoptiune_record;
    TYPE matrice IS VARRAY (100) OF vector;
    --matrice in care retin extraoptiunile tuturor configuratilor
    mat matrice := matrice();

    PROCEDURE populeaza_cu_extraoptiuni;
    PROCEDURE afisare_extraoptiuni;
    PROCEDURE sterge_extraoptiuni;
    PROCEDURE populeaza_cu_oferte;
    PROCEDURE afisare_oferte;
    PROCEDURE sterge_oferte;
    FUNCTION nr_clienti_oferta_reducere (procent IN NUMBER)
    RETURN NUMBER;
    FUNCTION config_cu_cele_mai_multe_extraop
    RETURN configuratie.id_configuratie%TYPE;

END pachet14;
/

CREATE OR REPLACE PACKAGE BODY pachet14 AS
    PROCEDURE populeaza_cu_extraoptiuni IS
        r extraoptiune_record;
        CURSOR c IS
        SELECT c.id_configuratie
        FROM configuratie c;

        CURSOR c2(conf configuratie.id_configuratie%TYPE) IS
        SELECT c.id_configuratie, e.id_extraoptiune, e.nume
        FROM configuratie c, conf_extraop ce, extraoptiune e
        WHERE e.id_extraoptiune=ce.id_extraoptiune and ce.id_configuratie=c.id_configuratie
            and conf=c.id_configuratie;
    BEGIN
        FOR i IN c LOOP
            mat.EXTEND();
            mat(mat.LAST) := vector();
            FOR j in c2(i.id_configuratie) LOOP
                r.cod_config := j.id_configuratie;
                r.cod_extraop := j.id_extraoptiune;
                r.nume := j.nume;
                mat(mat.LAST).EXTEND();
                mat(mat.LAST)(mat(mat.LAST).LAST) := r;
            END LOOP;
        END LOOP;
    END populeaza_cu_extraoptiuni;

    PROCEDURE afisare_extraoptiuni IS
    BEGIN
        FOR i IN 1..mat.COUNT LOOP
            IF mat(i).COUNT > 0 THEN
                DBMS_OUTPUT.PUT('Configuratia cu id-ul ' || mat(i)(1).cod_config || ' are urmatoarele extraoptiuni: ');
                FOR j IN 1..mat(i).COUNT LOOP
                    DBMS_OUTPUT.PUT(mat(i)(j).nume || ', ');
                END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
            END IF;
        END LOOP;
    END afisare_extraoptiuni;

    PROCEDURE sterge_extraoptiuni IS
    BEGIN
        FOR i IN 1..mat.COUNT LOOP
            mat(i) := vector();
        END LOOP;
        mat := matrice();
    END sterge_extraoptiuni;

    PROCEDURE populeaza_cu_oferte IS
        r oferta_record;
        CURSOR c IS
        SELECT id_configuratie, pret_oferta, id_client, id_dealer
        FROM oferta;
    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO r;
            EXIT WHEN c%NOTFOUND;
            t_oferta.EXTEND;
            t_oferta(t_oferta.LAST) := r;
        END LOOP;
        CLOSE c;
    END populeaza_cu_oferte;

    PROCEDURE afisare_oferte IS
    BEGIN
        FOR i IN 1..t_oferta.COUNT LOOP
            DBMS_OUTPUT.PUT(i || '. Oferta in valoare de ' || t_oferta(i).pret || ' facuta pentru configuratie cu id-ul ');
            DBMS_OUTPUT.PUT_LINE(t_oferta(i).cod_config || ', id-ul dealer-ului ' || t_oferta(i).cod_dealer || ' si id-ul clientului ' || t_oferta(i).cod_client);
        END LOOP;
    END afisare_oferte;

    PROCEDURE sterge_oferte IS
    BEGIN
        t_oferta := t_tbl_imbricat();
    END sterge_oferte;

    -- numarul de clienti care au primit reducere la oferta mai mare decat un procent dat ca parametru
    FUNCTION nr_clienti_oferta_reducere (procent IN NUMBER)
    RETURN NUMBER
    IS
        v_pret_conf configuratie.pret_total%TYPE;
        v_cnt NUMBER := 0;
    BEGIN
        FOR i IN t_oferta.FIRST..t_oferta.LAST LOOP
            SELECT pret_total INTO v_pret_conf
            FROM configuratie
            WHERE t_oferta(i).cod_config=id_configuratie;
            IF v_pret_conf - t_oferta(i).pret > procent * v_pret_conf / 100 THEN
                v_cnt := v_cnt + 1;
            END IF;
        END LOOP;

        return v_cnt;
    END nr_clienti_oferta_reducere;

     -- returneaza id-ul configuratiei cu cele mai multe extraoptiuni
    FUNCTION config_cu_cele_mai_multe_extraop
    RETURN configuratie.id_configuratie%TYPE
    IS
        v_id_conf configuratie.id_configuratie%TYPE;
        v_max NUMBER := 0;
    BEGIN
        FOR i IN 1..mat.COUNT LOOP
           IF mat(i).COUNT > v_max THEN
                v_id_conf := mat(i)(1).cod_config;
                v_max := mat(i).COUNT;
            END IF;
        END LOOP;

        return v_id_conf;
    END config_cu_cele_mai_multe_extraop;
END pachet14;
/

BEGIN
    pachet14.sterge_extraoptiuni();
    pachet14.populeaza_cu_extraoptiuni();
    pachet14.afisare_extraoptiuni();
    pachet14.sterge_oferte();
    pachet14.populeaza_cu_oferte();
    pachet14.afisare_oferte();
    DBMS_OUTPUT.PUT_LINE('Numarul clientilor care au primit o reducere mai mare de 15% este: ' || pachet14.nr_clienti_oferta_reducere(15));
    DBMS_OUTPUT.PUT_LINE('Id-ul configuratiei cu celel mai multe extraoptiuni este ' || pachet14.config_cu_cele_mai_multe_extraop());
END;
/


                                            
                                    




