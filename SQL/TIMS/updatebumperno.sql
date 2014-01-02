
create table #tempremarks
(
recordno int,
invrecordno int,
remarks varchar(10)
)

insert into #tempremarks
select inv.recordno,inv.invrecordno,remarks = substring(convert(char(50),remarks),1,7)
from invserialized inv, property prop, propertywarehouse pw, warehouse ware
where inv.recordno = prop.recordno and
      prop.recordno = pw.recordno and
      pw.warehousecode = ware.warehousecode and
      ware.warehousedesc = "AUTOMOTIVE" and
       remarks like "TSC-[0-9][0-9][0-9], %"

insert into #tempremarks
select inv.recordno,inv.invrecordno,remarks = substring(convert(char(50),remarks),1,8)
from invserialized inv, property prop, propertywarehouse pw, warehouse ware
where inv.recordno = prop.recordno and
      prop.recordno = pw.recordno and
      pw.warehousecode = ware.warehousecode and
      ware.warehousedesc = "AUTOMOTIVE" and
      remarks like "TSC-[0-9][0-9][0-9][0-9]%" 

insert into #tempremarks
select inv.recordno,inv.invrecordno,remarks = substring(convert(char(50),remarks),1,8)
from invserialized inv, property prop, propertywarehouse pw, warehouse ware
where inv.recordno = prop.recordno and
      prop.recordno = pw.recordno and
      pw.warehousecode = ware.warehousecode and
      ware.warehousedesc = "AUTOMOTIVE" and
      remarks like "TSC-[0-9][0-9][0-9]A%"

update invserializedattributes
set bumperno = remarks
from invserializedattributes inv, #tempremarks tmp
where inv.recordno = tmp.recordno and
      inv.invrecordno = tmp.invrecordno

select * from invserializedattributes where invrecordno in 
(select invrecordno from #tempremarks)

