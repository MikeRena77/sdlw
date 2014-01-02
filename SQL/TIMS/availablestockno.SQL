/*
select distinct stockno, fsc = substring(stockno,1,4), seqno = substring(stockno,13,4)
from property
where substring(stockno,9,3) = "Z33"
order by stockno
*/
/*
select distinct substring(stockno,1,4)
from Property
where substring(stockno,9,3) = "Z33"
*/
/*
create table AvailableStockNo
(
stockno char(16),
seqno char(4)
)
*/

declare @fsc char(4)
declare @loopcnt smallint
declare @maxloop smallint
declare @seqno char(4)

declare stocknocursor cursor for
 select distinct substring(stockno,1,4)
 from Property
 where substring(stockno,9,3) = "Z33"

open stocknocursor

select @maxloop = 100

while (0=0)
 begin
   fetch next
   from stocknocursor
   into @fsc

   if (@@fetch_status <> 0)
     break
   else
     begin
       select @loopcnt = 1
       while (@loopcnt <= @maxloop)
         begin
           select @seqno = convert(char(4),@loopcnt)
           if (@loopcnt < 10) 
             select @seqno = "000" + @seqno
           else if (@loopcnt < 100)
             select @seqno = "00" + @seqno
           else
             select @seqno = "0" + @seqno
           insert into AvailableStockNo
           values (@fsc + "-01-Z33-" + @seqno, @seqno)
           select @loopcnt = @loopcnt + 1
         end         
     end
  end
close stocknocursor
deallocate stocknocursor
