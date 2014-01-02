
drop procedure Test_Support_GFP_cloth
go 
/* Report Test_Support_GFP proc req'd by Power Builder  */
create procedure Test_Support_GFP_cloth
as
declare @minpart char(35), @i2c char(2),@d_part_count int,@minWR char(15)
select trans_num=a.trans_num,trans_item=d.trans_item ,distr_qty,part=d.part,WAO=substring(trans_desc,7,6) ,
WR=substring(trans_desc,1,6) ,trans_desc,proposal 
into #temp10 from ae_i_aqr_e a,ae_i_aqr_d d 
where a.warehouse='CLOTH' and d.trans_num=a.trans_num/*and trans_num=1644.0 */

/* select * from #temp10 go */
select 
i.part,i.inv_dsc,distr_qty,inv_soh,inv_sot,WAO=substring(trans_desc,7,6) 
,WR=substring(trans_desc,1,6),proposal 
/* ,trans_desc,trans_num,trans_item */   into #temp12 from ae_i_inv_e i,#temp10 a  
where  i.part=a.part  and i.warehouse='CLOTH' order by trans_num

/* select * from #temp12 go */
select part,inv_dsc,distr_qty,inv_soh,inv_sot,WAO ,ref,#temp12.proposal
into #temp13 from #temp12,ae_p_pro_e where  #temp12.proposal=ae_p_pro_e.proposal 

/* select * from #temp13 go */

select attr_val_0=part,attr_val_8=inv_dsc,TTL_ASG=distr_qty,inv_soh,inv_sot,attr_val_9=ref 
,RTN=eto_date,proposal
into #temp14 from #temp13,ae_j_prj_e where  #temp13.ref=ae_j_prj_e.project 

/*select * from #temp14 go */
select part_wao=attr_val_0+attr_val_9 ,part_qty=sum(TTL_ASG) 
into #temp15 from #temp14 
group by attr_val_0+attr_val_9
/*select * from #temp15  */

/*insert #temp6*/ 
select attr_val_8,attr_val_0,attr_val_9,TTL_ASG=part_qty,inv_soh,inv_sot,RTN,
part=attr_val_0 ,proposal,part_wao 
into #temp16 from #temp14 t4,#temp15 t5 where (t4.attr_val_0+t4.attr_val_9)=part_wao
 order by attr_val_8,attr_val_0,attr_val_9

select @d_part_count=count(distinct(part_wao)) from #temp15
while @d_part_count > 0
begin
select @i2c=convert(char(2),@d_part_count)
/* print @i2c */
select @minpart=min(part_wao) from #temp15
select @minWR=min(proposal) from #temp16 where part_wao=@minpart
delete #temp16 where part_wao=@minpart and proposal > @minWR
delete from #temp15 where part_wao=@minpart
select @d_part_count= @d_part_count-1
/*print @minpart */
/*print @minWR */
end
/*insert #temp6*/ select attr_val_8,attr_val_0,attr_val_9,TTL_ASG,inv_soh,inv_sot,RTN,part=attr_val_0 
from #temp16 order by attr_val_8,attr_val_0,attr_val_9

/*select * from #temp16 */