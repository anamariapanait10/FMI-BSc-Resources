select t.category
from title t, rental r 
where t.title_id = r.title_id;

select category from title;
select max(rating)
from title
group by category;

select count(t.title_id)
from title t, rental ren
where t.title_id = ren.title_id
group by t.category;

-- 7 filme
select *
from rental r
where r.act_ret_date is not NULL;

-- 97 1
-- 92 2
-- 93 3
-- 95 1
-- 98 1

select count(r.act_ret_date)
from rental r
where r.act_ret_date is not NULL
group by title_id;

with titluri as (select r.title_id, count(distinct r.copy_id) as copii
from 
select count(r.act_ret_date)
from rental r
where r.act_ret_date is not NULL
group by title_id;

select * from title;
select * from title_copy;
select * from rental;

select t.title, 
from title t, rental r
where t.title_id = r.title_id;

select t.title, count(*)
from title_copy c, title t
where c.title_id = t.title_id
group by c.title_id;

with disp as
(select count(*)
from title_copy c
group by c.title_id)
select t.title
