
/*
select wka.sched_date,
       prj.project,
       st_hours = wka.act_hrs,
       ot_hours = 0.0,
       wka.shop_person,
       wka.labor_type
into #templabor
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "10/1/98" and dateadd(hour,23,"2/7/99") and
       wka.time_type = "RE" and
       wka.labor_type in ("07","15","24","42","49","54","62","64","90","98")

insert into #templabor
select wka.sched_date,
       prj.project,
       st_hours = 0.0,
       ot_hours = wka.act_hrs,
       wka.shop_person,
       wka.labor_type
into #templabor
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between "10/1/98" and dateadd(hour,23,"2/7/99") and
       wka.time_type = "OT" and
       wka.labor_type in ("07","15","24","42","49","54","62","64","90","98")
*/
/*
select "ReportDate" = convert(char(8),getdate(),1),
       "Project" = convert(char(4),project),
       "LaborCode" = convert(char(2),labor_type),
       "Name" = shop_person,
       "STHours" = sum(st_hours),
       "OTHours" = sum(ot_hours)
into #tempreportedlabor
from #templabor
group by project,labor_type,shop_person
*/

/*
select "Project" = convert(char(4),project),
       LaborCode,
       Name,
       "ST Hours" = sum(st_hours),
       "OT Hours" = sum(ot_hours)
from #templabor
group by project,LaborCode,Name
order by project,LaborCode,Name
compute sum(sum(st_hours)), sum(sum(ot_hours))
*/

select sched_date,project,labor_type,shop_person,st_hours,ot_hours 
from #templabor
order by sched_date,project,labor_type,shop_person


