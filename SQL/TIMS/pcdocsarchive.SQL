
select distinct "Funny Number" = convert(char(15),c.path),"DTN Number" = p.docnumber,
       "Title" = convert(char(130),p.docname), "WAO" = u.org_id
from profile p, components c, user_org u
where p.docnumber = c.docnumber and
      p.org = u.system_id and
      u.org_id not like "0%"
order by p.docnumber

/*
select distinct docnumber from profile where 
org in (select system_id from user_org where org_id not like "0%")
*/
/*
select c.path,p.docnumber,p.docname,u.org_id
into #docs
from profile p, components c, user_org u
where p.docnumber = c.docnumber and
      p.org = u.system_id and
      u.org_id not like "0%"
*/