/*
create table CostSummary
( Project char(15),
  WorkRequest char(15),
  Phase char(5),
  Shop char(15),
  LaborCode char(5),
  Person char(20),
  Date datetime,
  TransNum float,
  IncidentalCharge char(15) null,
  Hours int null,
  Cost money null
)
*/

declare @begindate datetime
declare @enddate datetime
declare @mindate datetime


select @begindate = convert(char(8),dateadd(day,-1,getdate()),1)

select @enddate = convert(char(8),getdate(),1)
 
select @mindate = min(sched_date)
from ae_p_wka_e
where entry_date between @begindate and @enddate 

insert into CostSummary
select prj.project,
       wka.proposal,
       wka.sort_code,
       wka.shop,
       wka.labor_type,
       wka.shop_person,
       convert(char(8),wka.sched_date,1),
       trans_no,
       "Incidental" = "     ",
       sum(wka.act_hrs),
       convert(money,sum(wka.act_cost))
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date between @begindate and @enddate and
       wka.act_hrs > 0
group by prj.project,wka.proposal,wka.sort_code,wka.shop,wka.labor_type,
         wka.shop_person,convert(char(8),wka.sched_date,1),trans_no

update CostSummary
set IncidentalCharge = contract_no
from CostSummary costsum, ae_p_phs_e phs
where costsum.WorkRequest = phs.proposal and
      costsum.Phase = phs.sort_code and
      Project like "90%" and
      ltrim(contract_no) <> null

update CostSummary
set Hours = Hours + wka.act_hrs,Cost = Cost + wka.act_cost
from ae_p_wka_d wka, CostSummary costsum
where wka.trans_no = costsum.TransNum and
      wka.proposal = costsum.WorkRequest and
      wka.sort_code = costsum.Phase and
      convert(char(8),sched_date,1) = Date and
      wka.act_hrs < 0

/*
select "Project" = convert(char(7),Project),
       "WorkRequest" = convert(char(11),WorkRequest),
       "Phase" = convert(char(5),Phase),
       Person,Date,
       "DayOfWeek" = convert(char(9),datename(weekday,Date)),
       "DayOfMonth" = convert(char(10),datename(day,Date)),
       "DayOfYear" = convert(char(9),datename(dayofyear,Date)),
       "Week" = convert(char(4),datename(week,Date)),
       "Month" = convert(char(10),datename(month,Date)),
       "Quarter" = convert(char(7),datename(quarter,Date)),
       "Year" = convert(char(4),datename(year,Date)),
       Hours
from #tempcostsum 
where Person = "Bob Rasmussen"
order by datename(week,Date),Date
compute sum(Hours) by datename(week,Date) 
*/
/*
select shop_person,shop,sched_date,entry_date,ap_hrs,ot_hrs 
from ae_p_wka_e
where sched_date between "07/01/99" and "07/09/99"
order by shop,shop_person,sched_date
*/
/*
select hd.shop_person,hd.trans_no,hd.sched_date,hd.entry_date,act_hrs,ap_hrs 
from ae_p_wka_e  hd, ae_p_wka_d dtl 
where dtl.sched_date between "07/01/99" and "07/09/99" and 
      hd.trans_no = dtl.trans_no and hd.shop_person = "Bob Rasmussen"
order by dtl.sched_date
*/
/*
select * from ae_p_wka_d where shop_person = "Bob Rasmussen" and
sched_date between "07/01/99" and "07/09/99"
*/
