/*
select man.shop_person,labor_class,time_type,labor_rate
into #temptimetype
from ae_h_emp_e hr, ae_l_man_d man
where hr.shop_person = man.shop_person and
      hire_c <> "CO" and
      time_type in ("RE")
*/
/*
update #temptimetype
set time_type = "LT",labor_rate = 0
*/
/*
delete ae_l_man_d
from ae_l_man_d man, ae_h_emp_e hr
where hr.shop_person = man.shop_person and
      hire_c <> "CO" and
      time_type <> "RE"
*/

insert into ae_l_man_d
select * from #temptimetype

