
select "Project" = prj.project,
       "Person" = wka.shop_person,
       "Hours" = sum(wka.act_hrs),
       "Cost" = convert(money,sum(wka.act_cost))
into #tempcostsum
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "09/01/98" and "06/27/99" and 
       project in ("9110")
group by prj.project,wka.shop_person

insert into #tempcostsum
select "Project" = prj.project,
       "Person" = wka.shop_person,
       "Hours" = sum(wka.act_hrs),
       "Cost" = convert(money,sum(wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "09/01/98" and "06/27/99" and 
       wka.proposal in (select proposal from ae_p_phs_e where contract_no in ("9110"))
group by prj.project,wka.shop_person

select Project,Person,"Hours" = sum(Hours),"Cost" = sum(Cost) 
from #tempcostsum
group by Project,Person
order by Project,Person
compute sum(sum(Hours)), sum(sum(Cost)) by Project
compute sum(sum(Cost))
