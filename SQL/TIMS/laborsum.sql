/*
select wka.shop_person,
       wka.sched_date,
       "hours" = sum(wka.act_hrs)
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       prj.project = "9005" and wka.sched_date < "02/01/99"
group by wka.shop_person,wka.sched_date
order by wka.shop_person,wka.sched_date
compute sum(sum(wka.act_hrs)) by wka.shop_person
*/
select shop_person,sched_date,proposal,act_hrs,time_type 
from ae_p_wka_d
where time_type in ("VT","HT","ST","JT","BT","PD") and
      proposal not in ("982987","982988","982989","982990","983033")
order by shop_person,sched_date