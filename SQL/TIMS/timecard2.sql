 SELECT time_card_map.project_name,   
         "Date" = convert(char(8),ae_p_wka_d.sched_date,1),   
         "Hours" = ae_p_wka_d.act_hrs,   
         time_card_map.contract_no,   
         ae_j_prj_d.project,   
         time_card_map.dept_pool  
    FROM ae_p_wka_d,   
         ae_p_pro_e,   
         ae_j_prj_d,   
         time_card_map  
   WHERE ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_pro_e.proposal = ae_j_prj_d.proposal ) and  
         ( time_card_map.order_type = ae_p_pro_e.order_type ) and  
         ( time_card_map.time_type = ae_p_wka_d.time_type ) and 
         ( ae_p_wka_d.shop = 'SOFTWARE ENG') and 
         ( ae_p_wka_d.shop_person = 'BOB RASMUSSEN' ) AND  
         ( convert(char(8),ae_p_wka_d.sched_date,1) between '09/07/98' and '09/11/98' )
compute sum(ae_p_wka_d.act_hrs)
    
