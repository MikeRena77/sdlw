select 	ae_j_prj_d.project,
	ae_j_prj_e.prj_dsc,
	ae_p_wka_d.shop_person,
	ae_p_wka_d.labor_type,
	ae_p_wka_d.sched_date,
	ae_p_wka_d.act_hrs
from 	ae_j_prj_d, 
	ae_j_prj_e, 
	ae_p_wka_d 
where 	ae_j_prj_d.project = ae_j_prj_e.project and
      	ae_j_prj_d.proposal = ae_p_wka_d.proposal and
	ae_p_wka_d.time_type = "OT" and
      	ae_p_wka_d.sched_date between "10/01/2000" and dateadd(day,1,"12/13/2000") and
      	ae_p_wka_d.shop = "SOFTWARE ENG" and
	(ae_p_wka_d.shop_person = "STEVE BROWN" or      
	ae_p_wka_d.shop_person = "DUANE CLARK" or
	ae_p_wka_d.shop_person = "EARNEST SWINDEL" or
	ae_p_wka_d.shop_person = "CONRAD PALMER" or 
	ae_p_wka_d.shop_person = "BUNNELL" or 
	ae_p_wka_d.shop_person = "MICHAEL ANDREWS")
order by
	ae_p_wka_d.sched_date, 
	ae_j_prj_d.project,
	ae_j_prj_d.proposal