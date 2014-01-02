-- query GFP Maint with parts for BASE
Select 	PROJECT=ae_j_prj_d.project,
	DESCRIPTION=ae_j_prj_e.prj_dsc,
	WORKRQST=ae_p_wka_d.proposal, 
	EMPLOYEE=ae_p_wka_d.shop_person, 
	LABORTYPE=ae_p_wka_d.labor_type, 
	SHOP=ae_p_phs_e.shop,
	PART=ae_p_phs_e.part,
	PARTDESCR=ae_i_inv_e.inv_dsc,
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
	( ae_p_phs_e.part = ae_i_inv_e.part ) and
	( ae_j_prj_e.prj_type like 'base' ) AND 
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
ORDER BY ae_p_phs_e.proposal,
	ae_p_phs_e.shop,
	ae_p_phs_e.beg_dt DESC,
	ae_p_phs_e.part