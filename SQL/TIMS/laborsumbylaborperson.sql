
select 
       wka.labor_type,
       wka.shop_person,
       "hours" = sum(wka.act_hrs),
       "total cost" = convert(money,sum(wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       wka.labor_type = "11" and
       sched_date between "10/01/98" and "06/27/99"
group by wka.labor_type,wka.shop_person
order by wka.labor_type,wka.shop_person