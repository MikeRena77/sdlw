create procedure LaborSummary @BeginDate datetime, @EndDate datetime as

create table #templabor
(sched_date datetime,
 project char(15),
 st_hours float,
 ot_hours float,
 shop_person char(25),
 labor_type char(2)
)

insert into #templabor
select wka.sched_date,
       prj.project,
       st_hours = wka.act_hrs,
       ot_hours = 0.0,
       wka.shop_person,
       wka.labor_type
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between @BeginDate and dateadd(hour,23,@EndDate) and
       wka.time_type = "RE" and
       wka.shop in ("DESIGN ENG","ENG ADMIN","INFORMATION SRV","SOFTWARE ENG",
               "SYSTEMS ENGNR","TECHNICAL SVCS","FORT BRAGG SHOP","ANALYST SHOP")

insert into #templabor
select wka.sched_date,
       prj.project,
       st_hours = 0.0,
       ot_hours = wka.act_hrs,
       wka.shop_person,
       wka.labor_type
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between @BeginDate and dateadd(hour,23,@EndDate) and
       wka.time_type = "OT" and
       wka.shop in ("DESIGN ENG","ENG ADMIN","INFORMATION SRV","SOFTWARE ENG",
               "SYSTEMS ENGNR","TECHNICAL SVCS","FORT BRAGG SHOP","ANALYST SHOP")

select "ReportDate" = convert(char(8),getdate(),1),
       "WeekEnd" = @EndDate,
       "Project" = convert(char(8),project),
       "STHours" = sum(st_hours),
       "OTHours" = sum(ot_hours),
       "Name" = shop_person,
       "LaborCode" = convert(char(2),labor_type)
into #tempreportedlabor
from #templabor
group by project,shop_person, labor_type

select Project,Name,LaborCode,STHours,OTHours,WeekEnd
from #tempreportedlabor
order by Project,Name

