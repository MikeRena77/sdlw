select "Project" = convert(char(7),prj.project),
       "Desc" = ph.prj_dsc,
       "Labor Code" = wka.labor_type,
       "Labor Desc" = hr.job_code,
       "Hours" = sum(wka.act_hrs),
       "Cost" = sum(wka.act_cost)
from ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj, ae_j_prj_e ph, ae_h_emp_e hr
where prj.proposal = wka.proposal and
      pro.proposal = prj.proposal and
      prj.project = ph.project and
      wka.shop_person = hr.shop_person and
      prj.project like ("90%") and
      (hire_c = "CO" or wka.shop_person = "Tom Wise") and
      wka.sched_date < "05/10/99"
group by prj.project,ph.prj_dsc,wka.labor_type,hr.job_code
order by prj.project,wka.labor_type
