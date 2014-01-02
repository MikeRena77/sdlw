drop proc prop_loans
go
/* SP query for Property LOaned Off Contract Report;accumulative */
create procedure prop_loans
as
/* find all valid length key_values that apply */
select key_value,PN=substring(key_value,1,16),Barcode=substring(key_value,18,6),
   Action=field_value into #temp from ae_s_typ_v 
where field_seq=9 and screen_name='inv.w_i_eqm_e'  and substring(key_value,12,1)='-'
  and defn_type='PART INFORMATION' and  field_value ='OUT' and datalength(rtrim(key_value))= 23
or field_seq=9 and screen_name='inv.w_i_eqm_e' 
  and defn_type='PART INFORMATION' and  field_value ='OUT' and datalength(rtrim(key_value))= 23
and substring(key_value,12,1)='-'
order by field_value

/* find illegally shorted key_values & omits history */
select key_value,PN=substring(key_value,1,(charindex('|',key_value)-1))
   ,Barcode=substring(key_value,(charindex('|',key_value)+1)
,datalength(key_value)-(charindex('|',key_value)+1)  )
   ,Action=field_value  
into #temp1 from ae_s_typ_v 
where field_seq=9 and screen_name='inv.w_i_eqm_e'  and datalength(rtrim(key_value))< 23
  and defn_type='PART INFORMATION' and  field_value='OUT' and charindex('|',key_value)>1
or field_seq=9 and screen_name='inv.w_i_eqm_e'  and charindex('|',key_value)>1
  and defn_type='PART INFORMATION' and  field_value ='OUT' 
and datalength(rtrim(key_value))< 23
order by field_value

insert #temp select key_value,PN,Barcode,Action from #temp1

select PN,qty= count(PN) into #temp2 from #temp group by PN

select PN,qty= count(PN) into #temp3 from #temp1 group by PN

insert #temp2 select PN,qty  from #temp3 
select PN=t.PN,qty,key_value,t2PN=t2.PN,Barcode,Action into #temp4 
from #temp2 t2,#temp t where t2.PN=t.PN
select a.part,inv_dsc,inv_uom,inv_cost/*,qty,key_value,t4.PN,Barcode,Action */
into #temp5 from ae_i_inv_e a,#temp4 t4 where a.part=t4.PN 
select * from #temp5