-- GFP Maint with parts detail
Select 	
	SHOP=ae_p_phs_e.shop,
	PARTDESCR=ae_i_inv_e.inv_dsc,
	PROJECT=ae_j_prj_d.project,
	DESCRIPTION=ae_j_prj_e.prj_dsc,
	WORKRQST=ae_p_wka_d.proposal, 
	EMPLOYEE=ae_p_wka_d.shop_person, 
	LABORTYPE=ae_p_wka_d.labor_type, 
	PART=ae_p_phs_e.part,
	LASTUSAGE=ae_i_inv_e.last_usage_date,
	BEGNDT=ae_p_phs_e.beg_dt,
	ENDDT=ae_p_phs_e.end_dt,
	PROBCD=ae_p_phs_e.problem_code,
	--STATCD=ae_p_phs_e.status_code,
	HOURS=SUM(ae_p_wka_d.act_hrs), 
	TOTALCOST=sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_p_phs_e,
	ae_p_wka_d,
	ae_j_prj_d,
	ae_j_prj_e,
	ae_i_inv_e
WHERE	( ae_j_prj_d.project = ae_j_prj_e.project ) and  
	(( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and 
	(ae_p_phs_e.proposal = ae_p_wka_d.proposal )) and
	( ae_i_inv_e.part = ae_p_phs_e.part ) and
	( ae_j_prj_e.prj_type like 'test' ) AND 
	( ae_p_phs_e.part <> '') and
	( ae_p_wka_d.sched_date between '07/01/00' AND dateadd(day, 1, '07/31/00') ) --and 
	--ae_p_phs_e.act_hrs > 0
GROUP BY ae_j_prj_d.project,
	ae_j_prj_e.prj_dsc,
	ae_p_wka_d.proposal, 
	ae_p_wka_d.shop_person, 
	ae_p_wka_d.labor_type, 
	ae_p_phs_e.proposal, 
	ae_p_phs_e.shop,
	ae_p_phs_e.part,
	ae_i_inv_e.inv_dsc,
	ae_i_inv_e.last_usage_date,
	ae_p_phs_e.problem_code,
	--ae_p_phs_e.status_code,
	ae_p_phs_e.act_mat,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.beg_dt
ORDER BY 
	ae_p_phs_e.shop,
	ae_p_phs_e.proposal,
	ae_p_phs_e.beg_dt DESC,
	ae_p_phs_e.part



/* select 			part,
            		last_usage_date,
		        inv_dsc,
                      	class,
                        inv_uom,
			inv_cost,
                 	inv_soh,
                  	inv_sot,
                  	inv_order,
                	inv_commit,
               		inv_minlev,
               		inv_maxlev,
               		inv_status,
           		tot_amt,
                  	comm_code,
       			pref_way,
        		warehouse,
 			serial_yn,
 			bpo_num,
                  	item_type,
 			inv_category,
       			cycle_code,
 			freeze_yn,
 			times_used,
               		abs_usage,
                	weighted_usage,
           		times_used_c,
             		abs_usage_c,
              		weighted_usage_c,
         		count_all,
                	trans_per_min,
             		last_usage_percent,
       			fifo_count,
               		msds_flag,
 			spec_cd_flag,
 			shelf_time,
               		attr_desc_0,
                    	attr_desc_1,
                    	attr_desc_2,
                    	attr_desc_3,
                    	attr_desc_4,
                    	attr_desc_5,
                    	attr_desc_6,
                    	attr_desc_7,
                    	attr_desc_8,
                    	attr_desc_9,
                    	part_image
from			ae_i_inv_e
order by		part,
			class,
            		last_usage_date,
		        inv_dsc */