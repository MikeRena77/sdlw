
select * 
into #temptimecard
from time_card_map where project = "06020000"

update #temptimecard set project = "05010000"

insert into time_card_map select * from #temptimecard