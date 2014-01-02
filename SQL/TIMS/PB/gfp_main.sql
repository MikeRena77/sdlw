 SELECT ae_r_eqm_e.attr_val_8,   
         ae_r_eqm_e.attr_val_0,   
         ae_p_phs_e.proposal,   
         ae_p_phs_e.labor_indx,   
         ae_p_phs_e.craft_code,   
         ae_p_phs_e.beg_dt,   
         ae_p_wka_d.sched_date,   
         ae_p_phs_e.act_tot  
           


    FROM ae_r_eqm_e,   
         ae_p_phs_e,   
         ae_p_wka_d  


   WHERE ( ae_r_eqm_e.part = ae_p_phs_e.part ) and  
         ( ae_r_eqm_e.serial_no = ae_p_phs_e.serial_no ) and  
         ( ae_p_phs_e.proposal = ae_p_wka_d.proposal ) and  
         ( ae_p_phs_e.sort_code = ae_p_wka_d.sort_code ) and  
         ( ( datepart(month,ae_p_wka_d.sched_date) = 4 ) ) and
	 ( ae_p_wka_d.sched_date < ae_p_phs_e.beg_dt)  


ORDER BY ae_r_eqm_e.attr_val_8 ASC,   
         ae_r_eqm_e.attr_val_0 ASC,   
         ae_p_phs_e.proposal ASC   
