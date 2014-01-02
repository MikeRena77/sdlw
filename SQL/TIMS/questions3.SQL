  SELECT *
    FROM ae_j_prj_e
   WHERE project = '01060018' or
	project = '01060022' or
	project = '01060039' or 
	project = '01060047'
/* ae_p_wka_d.shop = 'cable' AND
	         ( ae_p_wka_d.sched_date between '05/23/00' AND dateadd(day, 1, '05/30/00') )
       ae_j_prj_d,
         ae_j_prj_e   
         ae_p_wka_a,   
         ae_p_wka_d  
   WHERE ( ae_j_prj_d.project = ae_j_prj_e.project ) and  
         ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ( ae_p_wka_d.shop = 'cable' ) AND  
         ( ae_j_prj_e.prj_type like 'test') AND  
         ( ae_p_wka_d.sched_date between '05/23/00' AND dateadd(day, 1, '05/30/00') ) )   


01060018
01060022
01060039
01060047   */
