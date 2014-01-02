  SELECT ae_j_prj_d.project,   
         ae_j_prj_e.prj_dsc,   
         ae_p_wka_d.shop_person,   
	 ae_p_wka_a.trans_no,
	 ae_p_wka_a.item_no,  
	 "t_work_desc" = (str(ae_p_wka_a.seq,2,0) + '~' + ae_p_wka_a.work_desc)
    FROM ae_j_prj_d,   
         ae_j_prj_e,   
         ae_p_wka_a,   
         ae_p_wka_d  
   WHERE ( ae_j_prj_d.project = ae_j_prj_e.project ) and  
         ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_wka_d.trans_no = ae_p_wka_a.trans_no ) and  
         ( ae_p_wka_d.item_no = ae_p_wka_a.item_no ) and  
         ( ( ae_p_wka_d.shop = 'software eng' ) AND  
         ( ae_j_prj_e.prj_type like 'base' ) AND  
         ( ae_p_wka_d.sched_date between '03/20/00' AND dateadd(day, 1, '03/23/00') ) )   
/*group by ae_j_prj_d.project,   
         ae_j_prj_e.prj_dsc,   
         ae_p_wka_d.shop_person,   
	 ae_p_wka_a.trans_no,
	 ae_p_wka_a.item_no */
order by ae_p_wka_a.trans_no,
	 ae_p_wka_a.item_no,  
	 t_work_desc