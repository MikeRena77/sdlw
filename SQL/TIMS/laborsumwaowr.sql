
select 
       prj.project,
       wka.proposal,
       pro.title,
       "hours" = sum(wka.act_hrs),
       "total cost" = convert(money,sum(wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and 
       project = "9101"
group by prj.project,wka.proposal,pro.title
order by prj.project,wka.proposal,pro.title
