select 
       	wka.shop,
       	wka.shop_person,
	prj.project,
	wka.proposal,
       	"hours" = sum(wka.act_hrs),
       	"total cost" = convert(money,sum(wka.act_cost))
from   	ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  	prj.proposal = wka.proposal and
      	pro.proposal = prj.proposal and 
       	wka.shop = "SOFTWARE ENG" and
	(wka.shop_person = 'MICHAEL ANDREWS' OR 
	wka.shop_person = 'STEVE BROWN' OR 
	wka.shop_person = 'BUNNELL' OR 
	wka.shop_person = 'DUANE CLARK' OR 
	wka.shop_person = 'MARK COONS' OR
	wka.shop_person = 'STEVE EHLERT' OR  
	wka.shop_person = 'BARRY FISHER' OR 
	wka.shop_person = 'CONRAD PALMER' OR 
	wka.shop_person = 'EARNEST SWINDEL' OR 
	wka.shop_person = 'DONNA ZELISKO') AND 
       	sched_date between "10/01/00" and "06/27/01"
group by wka.shop,prj.project,wka.proposal,wka.shop_person
order by wka.shop_person