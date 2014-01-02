Select ae_p_phs_e.shop,
	ae_p_phs_e.part,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_p_phs_e
WHERE	(ae_p_phs_e.beg_dt BETWEEN '02/01/00' and '02/29/00')
GROUP BY ae_p_phs_e.shop,
	ae_p_phs_e.part,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	ae_p_phs_e.act_mat,
	ae_p_phs_e.act_lab,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.beg_dt
ORDER BY ae_p_phs_e.shop,
	ae_p_phs_e.beg_dt DESC