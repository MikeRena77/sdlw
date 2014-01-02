
select 
       wka.proposal,
       wka.shop_person,
       "hours" = sum(wka.act_hrs),
       "cost" = sum(wka.act_cost)
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       prj.project = "9101"
group by wka.proposal,wka.shop_person
order by wka.proposal,wka.shop_person
compute sum(sum(wka.act_hrs)), sum(sum(wka.act_cost))

/*
select shop_person,sched_date,proposal,act_hrs,time_type 
from ae_p_wka_d
where time_type in ("VT","HT","ST","JT","BT","PD") and
      proposal not in ("982987","982988","982989","982990","983033")
order by shop_person,sched_date
*/
