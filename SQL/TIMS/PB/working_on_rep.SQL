
drop table temprepact

create table temprepact
(
	shop char(15),
	part char(15) null ,
	inv_dsc char(60) null,
	inv_sot float ,
	beg_dt datetime,
	end_dt datetime,
	problem_code char(5),
	status_code char(10),
	totl numeric(15)
)

insert into temprepact
Select ae_p_phs_e.shop,
	ae_i_inv_e.part,
	ae_i_inv_e.inv_dsc,
	ae_i_inv_e.inv_sot,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	totl=sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_i_inv_e,
	ae_p_phs_e
WHERE	(ae_i_inv_e.part=ae_p_phs_e.part) and
	((ae_i_inv_e.serial_yn='Y') and
	(ae_i_inv_e.class='PROP') and
	(ae_p_phs_e.beg_dt BETWEEN '03/01/00' and '03/30/00'))
GROUP BY ae_p_phs_e.shop,
	ae_i_inv_e.part,
	ae_i_inv_e.inv_dsc,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	ae_p_phs_e.act_mat,
	ae_p_phs_e.act_lab,
	ae_i_inv_e.inv_sot,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.beg_dt
ORDER BY ae_p_phs_e.shop,
	ae_p_phs_e.beg_dt DESC

insert into temprepact
(
	shop ,
	inv_sot,
	beg_dt,
	end_dt,
	problem_code,
	status_code ,
	totl 
)

Select 	ae_p_phs_e.shop,
	inv_sot=0.0,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	totl=sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat))
FROM	ae_p_phs_e
WHERE	(ae_p_phs_e.part='') and
	(ae_p_phs_e.beg_dt BETWEEN '03/01/00' and '03/30/00')
GROUP BY ae_p_phs_e.shop,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	ae_p_phs_e.act_mat,
	ae_p_phs_e.act_lab,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.beg_dt
ORDER BY ae_p_phs_e.shop,
	ae_p_phs_e.beg_dt DESC

Select temprepact.shop,
	temprepact.part,
	temprepact.inv_dsc,
	temprepact.inv_sot,
	temprepact.beg_dt,
	temprepact.end_dt,
	temprepact.problem_code,
	temprepact.status_code,
	temprepact.totl
FROM	temprepact
GROUP BY temprepact.shop,
	temprepact.part,
	temprepact.inv_dsc,
	temprepact.problem_code,
	temprepact.status_code,
	temprepact.inv_sot,
	temprepact.end_dt,
	temprepact.beg_dt,
	temprepact.totl
ORDER BY temprepact.shop,
	temprepact.beg_dt DESC

drop table temprepact