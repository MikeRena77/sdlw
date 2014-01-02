
select prj.project,
       wka.shop_person,
       wka.sched_date,
       wka.act_hrs
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       prj.project in ("9108")
/*
group by prj.project,wka.shop_person,wka.sched_date,wka.act_hrs
*/
order by prj.project,wka.shop_person,wka.sched_date
compute sum(wka.act_hrs) by prj.project,wka.shop_person
compute sum(wka.act_hrs) by prj.project

/*
select shop_person,sched_date,proposal,act_hrs,time_type 
from ae_p_wka_d
where time_type in ("VT","HT","ST","JT","BT","PD") and
      proposal not in ("982987","982988","982989","982990","983033")
order by shop_person,sched_date
*/