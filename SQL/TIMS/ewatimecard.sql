
 SELECT  ewa_time_map.charge_number,
         ewa_time_map.WAO,
         ae_p_wka_d.time_type,   
         "Date" = convert(char(8),ae_p_wka_d.sched_date,1),   
         "Hours" = ae_p_wka_d.act_hrs     
    FROM ae_p_wka_d,   
         ae_p_pro_e,   
         ae_j_prj_d,   
         ewa_time_map  
   WHERE ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_pro_e.proposal = ae_j_prj_d.proposal ) and  
         ( ewa_time_map.order_type = ae_p_pro_e.order_type ) and  
         ( ewa_time_map.time_type = ae_p_wka_d.time_type ) and
         ( ewa_time_map.WAO = ae_j_prj_d.project) and 
         ( ae_p_wka_d.shop_person = 'Bob Rasmussen' ) AND  
         ( convert(char(8),ae_p_wka_d.sched_date,1) between '05/31/99' and '06/06/99' )
compute sum(ae_p_wka_d.act_hrs)

/*
select distinct d.shop_person,j.project 
from ae_p_wka_d d, ae_j_prj_d j, ae_h_emp_e e 
where d.proposal = j.proposal and
      d.shop_person = e.shop_person and 
      sched_date between "05/03/99" and "05/10/99" and
      hire_c = "DY"
order by d.shop_person,j.project
*/

