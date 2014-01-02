  SELECT shop_person,
     sched_date,
                  sort_code,
       proposal,
        act_hrs,
                  act_cost,
                 item_no,
                  time_type,
        craft_code,
      labor_type,
 work_desc,
                                status_code,
 current_rate,
             pay_type,
 trans_no,
                 shop
 
    FROM ae_p_wka_d
   WHERE ae_p_wka_d.shop = 'cable' AND
	         ( ae_p_wka_d.sched_date between '05/23/00' AND dateadd(day, 1, '05/30/00') )
/*       ae_j_prj_d,
         ae_j_prj_e   
         ae_p_wka_a,   
         ae_p_wka_d  
   WHERE ( ae_j_prj_d.project = ae_j_prj_e.project ) and  
         ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ( ae_p_wka_d.shop = 'cable' ) AND  
         ( ae_j_prj_e.prj_type like 'test') AND  
         ( ae_p_wka_d.sched_date between '05/23/00' AND dateadd(day, 1, '05/30/00') ) )   */
