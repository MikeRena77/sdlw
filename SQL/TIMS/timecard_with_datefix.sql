   SELECT "Project" =  time_card_map.project_name,   
         convert(char(8),ae_p_wka_d.sched_date,1),   
         ae_p_wka_d.act_hrs,   
         time_card_map.contract_no,
         time_card_map.contract_type,   
         ae_j_prj_d.project,
         "Task " = '  ',   
         time_card_map.dept_pool,
         "O/T" = '  '  
    FROM ae_p_wka_d,   
         ae_p_pro_e,   
         ae_j_prj_d,   
         time_card_map  
   WHERE ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_pro_e.proposal = ae_j_prj_d.proposal ) and
         ( ae_j_prj_d.project = time_card_map.project) and  
         ( time_card_map.order_type = ae_p_pro_e.order_type ) and  
         ( time_card_map.time_type = ae_p_wka_d.time_type ) and  
         ( ( ae_p_wka_d.shop_person = "BOB RASMUSSEN"  ) AND  
         ( ae_p_wka_d.sched_date between "11/23/98" and "01/03/99"  ) )
   order by ae_p_wka_d.sched_date,contract_type desc, contract_no, project    
