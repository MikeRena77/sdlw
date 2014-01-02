-- userappaccesslist.sql Development Server SQL

select
	tims_dev.dev.applicationaccess.appid,
	tims_dev.dev.applicationaccess.appname,
	tims_dev.dev.applicationaccess.appfunction,
	tims_dev.dev.userappaccess.employeeid,
	f234.root.ae_h_emp_e.shop_person,
        tims_dev.dev.userlogin.userlogin
from
	tims_dev.dev.applicationaccess,
	tims_dev.dev.userappaccess,
	tims_dev.dev.userlogin,
	f234.root.ae_h_emp_e
where 
	f234.root.ae_h_emp_e.u_num = tims_dev.dev.userappaccess.employeeid and
	tims_dev.dev.applicationaccess.appid = tims_dev.dev.userappaccess.appid and
	f234.root.ae_h_emp_e.u_num = tims_dev.dev.userlogin.employeeno AND
 	tims_dev.dev.userlogin.employeeno = '1663'
	
order by f234.root.ae_h_emp_e.shop_person