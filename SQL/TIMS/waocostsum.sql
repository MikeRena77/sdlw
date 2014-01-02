
select prj.project,
       wka.shop,
       "Hours" = sum(wka.act_hrs),
       "Cost" = sum(wka.act_cost)
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       prj.project like "91%"
group by prj.project,wka.shop
order by prj.project,wka.shop
compute sum(sum(wka.act_hrs)),sum(sum(wka.act_cost)) by prj.project

/*
select shop_person,sched_date,proposal,act_hrs,time_type 
from ae_p_wka_d
where time_type in ("VT","HT","ST","JT","BT","PD") and
      proposal not in ("982987","982988","982989","982990","983033")
order by shop_person,sched_date
*/