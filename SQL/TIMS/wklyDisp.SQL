select ae_j_prj_d.project,ae_j_prj_e.prj_dsc,ae_p_wka_d.shop_person,ae_p_wka_a.work_desc
from ae_j_prj_d, ae_j_prj_e , ae_p_wka_d , ae_p_wka_a 
where ae_j_prj_d.project = ae_j_prj_e.project and
      ae_j_prj_d.proposal = ae_p_wka_d.proposal and
      ae_p_wka_d.trans_no = ae_p_wka_a.trans_no and
      ae_p_wka_d.item_no = ae_p_wka_a.item_no and
      ae_p_wka_d.sched_date between :begindate and dateadd(day,1,:enddate) and
      ae_j_prj_e.prj_type like :waotype and
      ae_p_wka_d.shop = :shop       
order by ae_j_prj_d.project,ae_j_prj_d.proposal,ae_p_wka_a.trans_no,ae_p_wka_a.item_no,ae_p_wka_a.seq