drop proc prop_turnIns
go
/* SP query for Property Turn Ins/Transfers Report;nonaccumulative unless history not converted ;execute  prop_TurnIns @MONTH ='08'*/
create procedure prop_TurnIns (@MONTH char(2))
as
declare @DYYYYMMLO char(9),@DYYYYMMHI char(9),@LYYYYMMLO char(9),@LYYYYMMHI char(9),@TYYYYMMLO char(9),@TYYYYMMHI char(9)
declare @minpart char(17), @i2c char(2),@d_part_count int,@minsn char(6)
if dataLength(rtrim(@MONTH))=1 
   begin
    select @MONTH='0'+@MONTH
   end
select @DYYYYMMHI="D"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'31'
select @DYYYYMMLO="D"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'01'
select @LYYYYMMHI="L"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'31'
select @LYYYYMMLO="L"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'01'
select @TYYYYMMHI="T"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'31'
select @TYYYYMMLO="T"+convert(char(4),datepart(yy,getdate()))+ @MONTH +'01'
select key_value,PN=substring(field_value,1,1)+substring(key_value,1,16),Barcode=substring(key_value,18,6),
   Action=substring(field_value,1,1) into #temp from ae_s_typ_v 
where field_seq=10 and screen_name='inv.w_i_eqm_e'  and substring(key_value,12,1)='-'
  and defn_type='PART INFORMATION' and  field_value between @DYYYYMMLO and @DYYYYMMHI
or field_seq=10 and screen_name='inv.w_i_eqm_e' 
  and defn_type='PART INFORMATION' and  field_value between @LYYYYMMLO and @LYYYYMMHI 
and substring(key_value,12,1)='-'
or field_seq=10 and screen_name='inv.w_i_eqm_e' 
  and defn_type='PART INFORMATION' and  field_value between @TYYYYMMLO and @TYYYYMMHI 
and substring(key_value,12,1)='-'
order by field_value
/*print @DYYYYMMLO  print @DYYYYMMHI print @TYYYYMMLO  print @TYYYYMMHI */
select key_value,PN=substring(field_value,1,1)+substring(key_value,1,(charindex('|',key_value)-1))
   ,Barcode=substring(key_value,(charindex('|',key_value)+1)
,datalength(key_value)-(charindex('|',key_value)+1)  )
   ,Action=substring(field_value,1,1)  
into #temp1 from ae_s_typ_v 
where field_seq=10 and screen_name='inv.w_i_eqm_e'  and datalength(rtrim(key_value))< 23
  and defn_type='PART INFORMATION' and  field_value between @DYYYYMMLO and @DYYYYMMHI and charindex('|',key_value)>1
or field_seq=10 and screen_name='inv.w_i_eqm_e'  and charindex('|',key_value)>1
  and defn_type='PART INFORMATION' and  field_value between @LYYYYMMLO and @LYYYYMMHI and datalength(rtrim(key_value))< 23
or field_seq=10 and screen_name='inv.w_i_eqm_e'  and charindex('|',key_value)>1
  and defn_type='PART INFORMATION' and  field_value between @TYYYYMMLO and @TYYYYMMHI and datalength(rtrim(key_value))< 23
order by field_value

insert #temp select key_value,PN,Barcode,Action from #temp1

select PN,qty= count(PN) into #temp2 from #temp group by PN
select PN,qty= count(PN) into #temp3 from #temp1 group by PN
insert #temp2 select PN,qty  from #temp3 
select t.PN,qty,key_value,Barcode,Action into #temp4 
from #temp2 t2,#temp t where t2.PN=t.PN

select a.part,inv_dsc,inv_uom,inv_cost,qty,key_value,PN,Barcode,Action 
into #temp5 from ae_i_inv_e a,#temp4 t4 where a.part=substring(t4.PN,2,16)
/* delete all rows where qty > 1 and except for min(part-sn)  */
select distinct(PN)  into #temp6 from #temp5
select @d_part_count= count(PN) from #temp5
while @d_part_count > 0
begin
select @i2c=convert(char(2),@d_part_count)
print @i2c
select @minpart=min(PN) from #temp6
select @minsn=min(barcode) from #temp5 where PN=@minpart
delete #temp5 where PN=@minpart and barcode > @minsn
delete from #temp6 where PN=@minpart
select @d_part_count= @d_part_count-1
print @minpart
print @minsn
end

select PN,Part,DESCRIPTION=inv_dsc ,UNIT=inv_uom ,PRICE=qty*inv_cost, ACT=Action ,QTY= qty ,inv_cost,Barcode 
 from #temp5
