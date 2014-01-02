Select ae_p_phs_e.shop,
	ae_i_inv_e.part,
	ae_i_inv_e.inv_dsc,
	ae_i_inv_e.inv_sot,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_i_inv_e,
	ae_p_phs_e
WHERE	(ae_i_inv_e.part=ae_p_phs_e.part) and
	((ae_i_inv_e.serial_yn='Y') and
	(ae_i_inv_e.class='PROP') and
	(ae_p_phs_e.beg_dt BETWEEN '02/01/00' and '02/29/00'))
GROUP BY ae_p_phs_e.shop,
	ae_i_inv_e.part,
	ae_i_inv_e.inv_dsc,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	ae_p_phs_e.act_mat,
	ae_p_phs_e.act_lab,
	ae_i_inv_e.inv_sot,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.beg_dt
ORDER BY ae_p_phs_e.shop,
	ae_p_phs_e.beg_dt DESC