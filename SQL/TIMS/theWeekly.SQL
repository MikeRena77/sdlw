  SELECT PROJECT=ae_j_prj_d.project, 
	 --PROPOSAL=ae_j_prj_d.proposal,
	 --DATE=ae_p_wka_d.sched_date,
         DESCRIPTION=ae_j_prj_e.prj_dsc,   
         EMPLOYEE=ae_p_wka_d.shop_person,
    	 COMMENTS=ae_p_wka_a.work_desc
    FROM ae_j_prj_d,   
         ae_j_prj_e,   
         ae_p_wka_a,   
         ae_p_wka_d  
   WHERE ( ae_j_prj_d.project = ae_j_prj_e.project ) and 
 	 --( ae_j_prj_d.project = "11060054" ) and 
         ( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_wka_d.trans_no = ae_p_wka_a.trans_no ) and  
         ( ae_p_wka_d.item_no = ae_p_wka_a.item_no ) and
	 ( ae_p_wka_a.work_desc <> "Weekly work" ) and
	 ( ae_p_wka_a.work_desc <> "" ) and  
         ( ( ae_p_wka_d.shop = 'software eng' ) AND
	 ( ae_p_wka_d.shop_person <> "CHRIS HANSEN" ) AND  
         ( ae_j_prj_e.prj_type like 'base' OR ae_j_prj_e.prj_type like 'test') AND  
         ( ae_p_wka_d.sched_date between '06/21/01' AND dateadd(day, 1, '06/28/01') )  )
 
group by ae_j_prj_d.project, 
	 --ae_j_prj_d.proposal,  
	 --ae_p_wka_d.sched_date,
         ae_j_prj_e.prj_dsc,   
         ae_p_wka_d.shop_person,   
	 ae_p_wka_a.trans_no,
	 ae_p_wka_a.item_no,
	 ae_p_wka_a.seq,
    	 ae_p_wka_a.work_desc
order by
	 ae_j_prj_d.project
	 --ae_p_wka_d.sched_date desc