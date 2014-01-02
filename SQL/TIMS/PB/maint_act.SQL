select 	ae_j_prj_d.project,
	ae_j_prj_e.prj_dsc,
	ae_p_wka_d.proposal, 
	ae_p_wka_d.shop_person, 
	ae_p_wka_d.labor_type, 
	TOTAL=SUM(ae_p_wka_d.act_hrs) 
from 	ae_p_wka_d,
	ae_j_prj_d,
	ae_j_prj_e
where 	( ae_j_prj_d.project = ae_j_prj_e.project ) and  
	( ae_j_prj_d.proposal = ae_p_wka_d.proposal ) and 
	ae_p_wka_d.shop ="SOFTWARE ENG"  and
	( ae_j_prj_e.prj_type like 'base' ) AND 
	( ae_p_wka_d.sched_date between '01/14/00' AND dateadd(day, 1, '07/21/00') ) 
group by
	ae_j_prj_d.project,
	ae_j_prj_e.prj_dsc,
	ae_p_wka_d.proposal, 
	ae_p_wka_d.labor_type,
	ae_p_wka_d.shop_person