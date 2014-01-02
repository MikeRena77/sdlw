drop table #temp_gfp

go

create table #temp_gfp
(
t_proposal char(15),
	t_shop char(15),
	t_part char(15) NULL,
	t_beg_dt datetime,
	t_end_dt datetime,
	t_problem_code char(5),
	t_status_code char(10),
	t_sum float,
	t_seq_comm char(75)
)

go

insert into #temp_gfp
Select  ae_p_phs_e.proposal,
	ae_p_phs_e.shop,
	ae_p_phs_e.part,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	sum((ae_p_phs_e.act_lab)+(ae_p_phs_e.act_mat)),
	'seq_comm'=((str(ae_p_dsc_h.seq,3,0) +('~') + ae_p_dsc_h.comm))

FROM	ae_p_phs_e, ae_p_dsc_h
WHERE	((ae_p_phs_e.part='') or
	(ae_p_phs_e.part=null)) and
	(ae_p_phs_e.proposal=ae_p_dsc_h.proposal) AND
	(ae_p_phs_e.beg_dt BETWEEN '02/01/00' and '02/29/00')
GROUP BY
	ae_p_phs_e.proposal,
	ae_p_phs_e.shop,
	ae_p_phs_e.part,
	ae_p_phs_e.beg_dt,
	ae_p_phs_e.end_dt,
	ae_p_phs_e.problem_code,
	ae_p_phs_e.status_code,
	ae_p_dsc_h.sort_code,
	ae_p_dsc_h.seq,
	ae_p_dsc_h.comm

go

select
	t_proposal,
	t_shop,
	t_part,
	t_beg_dt,
	t_end_dt,
	t_problem_code,
	t_status_code,
	t_sum,
	t_seq_comm
	
from #temp_gfp

/*GROUP BY t_proposal,
	t_shop,
	t_end_dt,
	t_part,
	t_problem_code,
	t_status_code,
	t_beg_dt,
	t_sum,
	t_seq_comm*/
ORDER BY
	t_proposal, t_end_dt
--	t_seq_comm
/*
--WORK REQUEST EXTRA DESCRIPTION
select proposal, seq, comm
from ae_p_dsc_h
order by proposal 
*/