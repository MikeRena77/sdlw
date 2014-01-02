-- userappaccesslist.sql  Production Server SQL

select
	timsdb.root.applicationaccess.appid,
	timsdb.root.applicationaccess.appname,
	timsdb.root.applicationaccess.appfunction,
	timsdb.root.userappaccess.employeeid,
	f234.root.ae_h_emp_e.shop_person,
        timsdb.root.userlogin.userlogin
from
	timsdb.root.applicationaccess,
	timsdb.root.userappaccess,
	timsdb.root.userlogin,
	f234.root.ae_h_emp_e
where 
	f234.root.ae_h_emp_e.u_num = timsdb.root.userappaccess.employeeid and
	timsdb.root.applicationaccess.appid = timsdb.root.userappaccess.appid and
	f234.root.ae_h_emp_e.u_num = timsdb.root.userlogin.employeeno 
	
order by f234.root.ae_h_emp_e.shop_person