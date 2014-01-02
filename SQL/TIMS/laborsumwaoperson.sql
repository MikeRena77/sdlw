select 
       "Project" = prj.project,
       "Person" = wka.shop_person,
       "Hours" = sum(wka.act_hrs),
       "Cost" = convert(money,sum(wka.act_cost))
into #tempcostsum
from   ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  prj.proposal = wka.proposal and
       pro.proposal = prj.proposal and
       wka.sched_date < "05/31/99" and 
       project in 
("9002",	
"9004",	
"9005",	
"9007",	
"9008",	
"9010",	
"9011",	
"9012",	
"9013",	
"9014",	
"9016",	
"9017",	
"9018",	
"9019",	
"9020",	
"9021",	
"9022",	
"9023",	
"9026",	
"9027",	
"9028",	
"9030",	
"9032",	
"9037",	
"9038",	
"9042",	
"9043",	
"9052",	
"9058",	
"9101",	
"9102",	
"9103",	
"9104",	
"9105",	
"9106",	
"9107",	
"9108",	
"9110",	
"9111",	
"9112",	
"9113",	
"9117",	
"9106",
"900D",	
"91A1",	
"91A6",	
"91B1",	
"91B6",	
"91C6",	
"91C8",	
"91D6",	
"91F6",	
"91G6",	
"91H6",	
"91J6",	
"91K6",	
"91M6",	
"91N6",	
"91P6",	
"91S6",	
"91T6",	
"91U6",	
"91V6",	
"91W6",	
"91Y6",	
"91Z6")
group by prj.project,wka.shop_person

select * from #tempcostsum
order by Project, Person
compute sum(Hours), sum(Cost) by Project


