/*
select distinct project,order_type,time_type,contract_type
from time_card_map
where project not like "%-%" and project not like "%AAAA"
order by project
*/
/*
select * from ae_p_wka_d where sched_date between "04/19/99" and "04/30/99" and
time_type <> "RE"
*/
/*
create table dyncorp_time_map
(contract_no char(8),
task char(6),
suffix char(2),
WAO char(8),
time_type char(2),
order_type char(1),
contract_type char(1))
*/
/*
insert into dyncorp_time_map
select contract_no,dept_pool,"40",project,time_type,order_type,contract_type
from #tempdyncorp
*/
select * from dyncorp_time_map