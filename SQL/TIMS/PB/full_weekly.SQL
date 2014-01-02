SELECT prjd.project,   
         prje.prj_dsc,
	wkad.proposal,   
         wkad.shop_person,
	 wkad.shop,
	wkad.trans_no,
	wkad.item_no,   
         wkad.sched_date,   
         wkaa.work_desc  
    FROM ae_j_prj_d prjd,   
         ae_j_prj_e prje,   
         ae_p_wka_d wkad,   
         ae_p_wka_a wkaa  
   WHERE ( prjd.project = prje.project ) and  
         ( prjd.proposal = wkad.proposal ) and  
         ( wkad.trans_no = wkaa.trans_no ) and  
         ( wkad.item_no = wkaa.item_no ) and 
	 ( wkad.shop="SOFTWARE ENG" ) and 
         ( ( wkad.sched_date between "03/13/00" AND "03/17/00" ) )   
ORDER BY wkad.shop_person,
	  prjd.project ASC