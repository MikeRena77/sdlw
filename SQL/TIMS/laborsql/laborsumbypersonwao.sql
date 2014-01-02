
select 
       "Person" = wka.shop_person,
       "WAO" = prj.project,
       "Hours" = sum(wka.act_hrs),
       "Cost" = convert(money,sum(wka.act_cost))
into #report
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       prj.project = "01060014"
group by wka.shop_person,prj.project
order by wka.shop_person,prj.project

select * from #report
compute sum(Cost)