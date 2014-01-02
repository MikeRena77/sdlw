  SELECT ae_p_phs_e.shop,   
         ae_j_prj_d.project,   
         ae_j_prj_d.proposal,   
         ae_p_phs_e.sort_code,   
         ae_p_phs_e.phsdsc,   
         ae_p_pro_e.shop_person,   
         ae_p_phs_e.beg_dt,   
         ae_p_phs_e.end_dt,   
         ae_p_phs_e.act_hrs,   
         ae_p_phs_e.act_lab,   
         ae_p_phs_e.act_mat,   
         ae_p_phs_e.status_code  
    FROM ae_j_prj_d,   
         ae_p_phs_e,   
         ae_p_pro_e  
   WHERE ( ae_j_prj_d.proposal = ae_p_phs_e.proposal ) and  
         ( ae_p_phs_e.proposal = ae_p_pro_e.proposal ) and  
         ( ae_j_prj_d.proposal = ae_p_pro_e.proposal ) and  
         ( ae_p_pro_e.shop = ae_p_phs_e.shop ) and  
         ( ( ae_p_phs_e.shop in ( "AUTOMOTIVE","RTCA","CABLE","CARPENTRY","DIGITAL","ENGINEER SUPP","ELECTRIC","HEAT/AC","VIDEO", "MACHINE","COMMO/RADIO" ) ) AND  
         ( ae_p_phs_e.end_dt between '04/01/00' AND '04/30/00' )) and  
         --( ae_p_phs_e.end_dt = null )) AND  
         ( ae_j_prj_d.project not like "9%" ) AND  
         ( ae_j_prj_d.project not like "8%" )  
ORDER BY ae_p_phs_e.shop ASC,   
         ae_j_prj_d.proposal ASC,   
         ae_p_phs_e.status_code ASC   
