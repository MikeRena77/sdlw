/*
select * from syscolumns where name = "contractor"
*/
/*
select obj.id, obj.name, col.name
from sysobjects obj, syscolumns col
where obj.id = col.id and
      col.name = "shop_person" and
      obj.name like "ae_%"
order by obj.name
*/
/*
select distinct shop_person from 
*/

/*
delete from 
*/
/*
ae_l_man_d
ae_l_man_e *
ae_l_shp_d
ae_l_shp_h
ae_h_emp_e
*/
select * from ae_h_emp_e
where shop_person in (
"Bert Rodriguez"
)

/*
order by shop_person
*/
