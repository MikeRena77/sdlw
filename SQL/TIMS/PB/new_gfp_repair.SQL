select 
	shop,
	part,
	inv_dsc,
	inv_sot,
	 labor_indx,
	 beg_dt,
	 end_dt,
	 problem_code,
	 status_code,
	 act_total	
from v_parts_repair
where 	beg_dt between '07/01/00' AND '07/31/00'
UNION ALL
select
	 shop ,
	 part,
	inv_dsc=null,
	inv_sot=0,
	 labor_indx,
	 beg_dt,
	 end_dt,
	 problem_code,
	 status_code,
	 act_total
from v_noparts
where 	beg_dt between '07/01/00' AND '07/31/00'