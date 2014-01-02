
select wka.shop_person,
       wka.shop,
       wka.labor_type,
       "hours" = sum(wka.act_hrs),
       "total cost" = sum(convert(money,wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       project = "9002" and 
       wka.sched_date between "10/01/98" and "04/01/99"
group by wka.shop_person,wka.shop,wka.labor_type
order by wka.shop_person,wka.shop,wka.labor_type
compute sum(sum(wka.act_hrs)), sum(sum(convert(money,wka.act_cost)))
