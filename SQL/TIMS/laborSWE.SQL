select 
	prj.project,
	wka.proposal,
       	wka.shop,
       	wka.shop_person,
       	"hours" = sum(wka.act_hrs),
       	"total cost" = convert(money,sum(wka.act_cost))
from   	ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where  	prj.proposal = wka.proposal and
       	pro.proposal = prj.proposal and 
	(wka.shop_person = 'PETE JADEN' or 
	wka.shop_person = 'ROGER MADERO' or 
	wka.shop_person = 'MIKE MAGATAGAN' OR 
	wka.shop_person = 'KAREN SCOTT' OR
       	wka.shop = "SOFTWARE ENG") and
	/*
	wka.shop_person = 'BOB CARPENTER' OR 
	wka.shop_person = 'CHRIS HANSEN' OR 
	wka.shop_person = 'EARNEST LYNCH' OR 
	wka.shop_person = 'TONY ROSS' OR
	wka.shop_person = 'JOHN RYAN' OR  
	wka.shop_person = 'BART WHEELER' OR 
	wka.shop_person = 'GRANT ZU' OR 
 AND */
       sched_date between "10/01/00" and "06/27/01"
group by wka.shop,prj.project,wka.proposal,wka.shop_person
order by wka.shop_person