/*
select * into #tempmap from dyncorp_time_map
where WAO = "9000"
*/
/*
update #tempmap set WAO = "9007"
*/
/*
insert into #tempmap 
select contract_no,task,suffix,WAO = "91Z6",time_type,order_type,contract_type
from dyncorp_time_map
where WAO = "9106"
*/