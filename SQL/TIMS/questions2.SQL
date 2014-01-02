 SELECT distinct ae_j_prj_d.project,   
         ae_j_prj_e.prj_dsc,   
         ae_p_wka_d.shop_person,
         ae_p_wka_d.sched_date
    FROM ae_j_prj_d,   
         ae_j_prj_e,   
         ae_p_wka_a,   
         ae_p_wka_d  
   WHERE ( ae_j_prj_d.project = ae_j_prj_e.project ) and  
         ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_j_prj_d.project = '01060018' or
	ae_j_prj_d.project = '01060022' or
	ae_j_prj_d.project = '01060039' or 
	ae_j_prj_d.project = '01060047')