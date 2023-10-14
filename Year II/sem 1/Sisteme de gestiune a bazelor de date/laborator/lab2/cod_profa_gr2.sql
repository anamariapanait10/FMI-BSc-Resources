-- Lab 2 - Gr 2 - LABORATOR SQL RECAPITULARE – 2

/*
MEMBER(member_id, last_name, first_name, address, city, phone, join_date)
TITLE(title_id, title, description, rating, category, release_date)
TITLE_COPY(copy_id, title_id, status)
RENTAL(book_date, copy_id, member_id, title_id, act_ret_date, exp_ret_date)
RESERVATION(res_date, member_id, title_id)
*/

/*
1. Identificati coloanele care compun cheia primara a fiecarei tabele stiind ca:
   a. exemplarele fiecarui titlu sunt numerotate începând cu valoarea 1;
   b. un membru poate împrumuta acelasi exemplar al unui film de mai multe ori,
      dar nu în aceeasi zi.
   c. un membru poate rezerva acelasi film de mai multe ori, dar nu în aceeasi zi.
*/

-- MEMBER - (member_id)
-- TITLE - (title_id)
-- TITLE_COPY - (copy_id, title_id)
-- RENTAL - (book_date, copy_id, member_id, title_id)
-- RESERVATION - (res_date, member_id, title_id)

select * from member;
select * from title;
select * from title_copy;
select * from rental;
select * from reservation;

/*
4. Câte filme (titluri, respectiv exemplare) au fost împrumutate din cea mai 
   ceruta categorie?
*/


select * from rental;

-- in subcerere obtinem numarul de exemplare imprumutate din
-- cea mai ceruta categorie, iar apoi selectam numarul de titluri
-- distincte si de exemplare din categoriile care au numarul
-- de imprumuturi egal cu maximul
select category, count(distinct r.title_id), count(r.copy_id)
from title t, rental r
where t.title_id = r.title_id
group by category
having count(r.copy_id) = ( select max(count(category))
                            from title t, rental r
                            where t.title_id = r.title_id
                            group by category);


-- daca vrem sa afisam si categoriile din care nu a fost imprumutat
-- niciun film, facem un outer join
select category, count(r.copy_id)
from title t, rental r
where t.title_id = r.title_id(+)
group by category;

-- verificam faptul ca din categoria SCIFI (cea mai ceruta) au fost
-- imprumutate 2 titluri si 8 exemplare
select title, category
from title t, rental r
where t.title_id = r.title_id
order by 1, 2;


/*
5. Câte exemplare din fiecare film sunt disponibile în prezent (considerati 
   ca statusul unui exemplar nu este setat, deci nu poate fi utilizat)?
*/

select * from title_copy;

-- aceasta rezolvare nu este corecta, deoarece coloana status din title_copy
-- contine valori puse la intamplare, necorelate cu tabela rental
select title, count(*)
from title t, title_copy tc
where t.title_id = tc.title_id
and status = 'AVAILABLE'
group by title;


-- cu ajutorul acestei cereri obtinem exemplarele ce in prezent 
-- sunt imprumutate
select title_id, copy_id
from rental
where act_ret_date is null;


-- pentru a obtine si filmele ce au toate exemplarele imprumutate
-- ne creem tabela 'a' pentru a putea face outer join
select title, count(copy_id)
from title b,
( select title_id, copy_id
  from title_copy
  where (title_id, copy_id) not in (select title_id, copy_id
                                    from rental
                                    where act_ret_date is null)) a
where b.title_id = a.title_id(+)
group by title;

select * from title;

/*
6. Afisati urmatoarele informatii: titlul filmului, numarul exemplarului, 
   statusul setat si statusul corect.
*/

select * from title_copy;

-- cu ajutorul unui case si a subcererii din exercitiul
-- anterior, obtinem statusul corect
select title, copy_id, status,
       case when (a.title_id, copy_id) not in (select title_id, copy_id
                                                from rental
                                                where ACT_RET_DATE is null) then 'AVAILABLE'
            when (a.title_id, copy_id) IN (select title_id, copy_id
                                            from rental
                                            where ACT_RET_DATE is null) then 'RENTED'
            else 'DESTROYED or RESERVED'
       end status_corect
from title_copy a, title b
where a.title_id = b.title_id;


/*
7. a. Câte exemplare au statusul eronat? 
   b. Setati statusul corect pentru toate exemplarele care au statusul 
      eronat. Salvati actualizarile realizate.
   Obs. Pentru rezolvare creati tabela title_copy_***, preluând structura 
   si datele din tabela title_copy.
*/

-- a
with aux as
(select title, copy_id, status,
        case when (a.title_id, copy_id) not in (select title_id, copy_id
                                                from rental
                                                where ACT_RET_DATE is null) then 'AVAILABLE'
             else 'RENTED'
        end status_corect
from title_copy a, title b
where a.title_id = b.title_id)
select count(*) as "NrStatusuriGresite"
from  aux
where aux.status_corect != aux.status;


--b
create table title_copy_gid as select * from title_copy;

update title_copy_gid
set status = case when (title_id, copy_id) not in (select title_id, copy_id
                                                   from rental
                                                   where ACT_RET_DATE is null) then 'AVAILABLE'
                  else 'RENTED'
             end
where status <> case when (title_id, copy_id) not in (select title_id, copy_id
                                                      from rental
                                                      where ACT_RET_DATE is null) then 'AVAILABLE'
                     else 'RENTED'
                end;
                
commit;

-- tema: ex 2-3, 8-12 deadline: miercuri 19.10.2022 23:59


