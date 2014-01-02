
select wka.shop_person,
       wka.labor_type,
       project,
       "hours" = sum(wka.act_hrs),
       "total cost" = sum(convert(money,wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       wka.shop = "SOFTWARE ENG" and 
       wka.sched_date between "10/01/98" and "04/01/99"
group by wka.shop_person,wka.labor_type,project
order by wka.shop_person,wka.labor_type,project
compute sum(sum(wka.act_hrs)), sum(sum(convert(money,wka.act_cost))) by wka.shop_person
compute sum(sum(wka.act_hrs)), sum(sum(convert(money,wka.act_cost)))
