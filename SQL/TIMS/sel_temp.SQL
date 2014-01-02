select t_project, 
       t_prj_dsc, 
       t_shop_person, 
       t_trans_no,
       t_item_no,
       t_work_desc
from tempweekly
where 
group by t_project, 
         t_prj_dsc, 
         t_shop_person, 
         t_trans_no,
         t_item_no,
         t_work_desc
