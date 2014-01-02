select distinct lname,fname,shop,labor_class,hire_name
from ae_l_shp_d shp, ae_l_man_d man, ae_h_emp_e emp
where shp.shop_person = man.shop_person and
      shp.shop_person = emp.shop_person and
      lname <> NULL
order by lname,fname