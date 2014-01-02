
select wka.shop_person,
       prj.project,
       st_hours = wka.act_hrs,
       ot_hours = 0.0,
       wka.labor_type
into #templabor
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "10/01/98" and dateadd(hour,23,"4/11/99") and
       wka.time_type not in ("OT","PT") and
       wka.shop_person in ("CATHY QUICK","KAREN EMBREE","MELISSA HOLIDAY","WANDA GLOVER")

insert into #templabor
select wka.shop_person,
       prj.project,
       st_hours = 0.0,
       ot_hours = wka.act_hrs,
       wka.labor_type
into #templabor
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "10/01/98" and dateadd(hour,23,"4/11/99") and
       wka.time_type = "OT" and
       wka.shop_person in ("CATHY QUICK","KAREN EMBREE","MELISSA HOLIDAY","WANDA GLOVER")


select "Name" = shop_person,
       "Project" = convert(char(7),project),
       "STHours" = sum(st_hours),
       "OTHours" = sum(ot_hours),
       "LaborCode" = convert(char(2),labor_type)
into #tempreportedlabor
from #templabor
group by shop_person, project,labor_type

select Name,Project,STHours,OTHours,LaborCode 
from #tempreportedlabor
order by Name,Project




