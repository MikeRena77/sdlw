-- UNION
Select 	NOMENCLATURE=ae_i_inv_e.inv_dsc,
	PROJECT=ae_j_prj_d.project,
	SHOP=ae_p_phs_e.shop,
	ENDDT=ae_p_phs_e.end_dt,
	REASON=ae_p_phs_e.problem_code,
	STATCD=ae_p_phs_e.status_code,
	ACTCOST=sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_p_phs_e,
	ae_p_wka_d,
	ae_j_prj_d,
	ae_j_prj_e,
	ae_i_inv_e
WHERE	( ae_j_prj_d.project = ae_j_prj_e.project ) and  
	(( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and 
	(ae_p_phs_e.proposal = ae_p_wka_d.proposal )) and
	( ae_i_inv_e.part = ae_p_phs_e.part ) and
	( ae_p_phs_e.end_dt between '07/01/00' AND dateadd(day, 1, '08/01/00') )
GROUP BY 
	ae_j_prj_d.project,
	ae_i_inv_e.inv_dsc,
	ae_p_phs_e.shop,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code
UNION ALL
SELECT DISTINCT
	NOMENCLATURE=ae_p_pro_e.title,
	PROJECT=ae_p_pro_e.ref,
	--QUANTITY=
	--DTINIT=
	--REASON=
	SHOP=ae_p_pro_e.shop,
	ENDDT=ae_p_pro_e.desired_date,
	REASON=ae_p_phs_e.problem_code,
	STATCD=ae_p_pro_e.status_code,
	--STATUSDATE=ae_p_sta_e.status_date,
	--ESTCOST=
	ACTCOST=(SUM(ae_p_pro_e.act_tot))
FROM	ae_p_pro_e,
	ae_p_sta_e,
	ae_p_phs_e
WHERE	ae_p_pro_e.proposal =  ae_p_sta_e.proposal and
	(ae_p_phs_e.proposal = ae_p_pro_e.proposal ) and 
	ae_p_pro_e.ent_date >= '2000-07-01 00:00:00' and 
	ae_p_pro_e.ent_date <= '2000-08-01 00:00:00'
GROUP BY
	ae_p_pro_e.ref,
	ae_p_pro_e.title,
	ae_p_pro_e.shop,
	ae_p_pro_e.desired_date,
	ae_p_phs_e.problem_code,
	ae_p_pro_e.status_code
ORDER BY
	SHOP,
	ENDDT DESC