
select "Person" = t.shop_person,"Date" = CONVERT(varchar(8),t.sched_date,1),
       "Project" = convert(char(8),project),
       "Work Request" = convert(char(8),w.proposal),
       "Desc" = title,"Total Hours" = t.act_hrs
from ae_j_prj_d p, ae_p_wka_d t, ae_p_pro_e w
where p.proposal = t.proposal and
      p.proposal = w.proposal and
      t.shop = "SOFTWARE ENG" and
      t.sched_date between "10/01/00" and "05/31/01"
order by t.shop_person,convert(varchar(8),t.sched_date,1),project,w.proposal
compute sum(t.act_hrs) by t.shop_person
