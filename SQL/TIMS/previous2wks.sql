/*
select ae_h_emp_e.shop_person, shop, u_num
from ae_h_emp_e, ae_l_shp_d
where ae_h_emp_e.shop_person = ae_l_shp_d.shop_person and
      u_num = "9740"
*/
/*
update ae_h_emp_e
set u_num = "9740"
where shop_person = "BOB RASMUSSEN"
*/
/*
select shop_name
from emplist
where shop_name not in (select shop_person from ae_h_emp_e) 
*/
/*
update ae_h_emp_e
set e.u_num = l.u_num
from ae_h_emp_e e, emplist l
where e.shop_person = l.shop_name
*/
declare @@begindate datetime
declare @@enddate datetime
select @@begindate = 
convert(char(8),dateadd(day,-(datepart(weekday,getdate()) - datepart(weekday,getdate()) + 2 + 14),getdate()),1)
select @@enddate = 
convert(char(8),dateadd(day,-(datepart(weekday,getdate()) - datepart(weekday,getdate()) + 2 + 1),getdate()),1)
select @@begindate,@@enddate