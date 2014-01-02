
select 
       wka.shop,
       prj.project,
       "hours" = sum(wka.act_hrs),
       "total cost" = convert(money,sum(wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       wka.shop = "SOFTWARE ENG" and
       sched_date between "10/01/00" and "06/27/01"
group by wka.shop,prj.project
order by wka.shop,prj.project
