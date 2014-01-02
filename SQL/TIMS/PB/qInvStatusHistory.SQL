-- inventory status history
select *
from ae_i_inv_h
order by login,
	status_date DESC