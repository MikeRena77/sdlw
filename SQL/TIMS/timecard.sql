
select t.shop_person,"date" = CONVERT(varchar(8),t.sched_date,1), "total_hours" = t.act_hrs,
       project
from ae_j_prj_d p, ae_p_wka_d t, ae_p_pro_e w
where p.proposal = t.proposal and
      p.proposal = w.proposal and
      t.shop = "SOFTWARE ENG" and
      t.sched_date between "8/24/98" and "09/24/98"
order by t.shop_person,convert(varchar(8),t.sched_date,1)
compute sum(t.act_hrs) by t.shop_person
