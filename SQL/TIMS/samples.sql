drop proc samples
go
/*  WR problem field must='SAMPL' and WR repair code field=23 for a sample pass; all other */
/* repair code field values count as a sample fail  */
create proc samples (@MONTH int,@YEAR int ) /* execute samples @MONTH=8,@YEAR=1998 */
as
 SELECT ae_r_eqm_e.attr_val_8,   
         ae_p_phs_e.beg_dt,   
         ae_r_eqm_e.attr_val_0,   
         ae_p_phs_e.serial_no,   
         ae_p_phs_e.proposal,   
         ae_p_phs_e.repair_code,   
         ae_p_phs_e.problem_code,   
         ae_p_phs_e.part, 
	ae_p_phs_e.shop, 
	fail=1,
	pass=0  
       
   INTO #temp
    FROM ae_r_eqm_e,   
         ae_p_phs_e  
   WHERE ( ae_r_eqm_e.part = ae_p_phs_e.part ) and  
         ( ae_r_eqm_e.serial_no = ae_p_phs_e.serial_no ) and  
         ( ( datepart(month,ae_p_phs_e.beg_dt) = @MONTH ) ) and
	( ( datepart(year,ae_p_phs_e.beg_dt) = @YEAR ) ) and
	   ae_p_phs_e.repair_code !=23 and
    		ae_p_phs_e.problem_code='SAMPL'  
ORDER BY ae_r_eqm_e.attr_val_8 ASC,   
         ae_p_phs_e.beg_dt ASC   

  INSERT #temp
	select
	  ae_r_eqm_e.attr_val_8,   
         ae_p_phs_e.beg_dt,   
         ae_r_eqm_e.attr_val_0,   
         ae_p_phs_e.serial_no,   
         ae_p_phs_e.proposal,   
         ae_p_phs_e.repair_code,   
         ae_p_phs_e.problem_code,   
         ae_p_phs_e.part, 
	ae_p_phs_e.shop, 
	fail=0,
	pass=1   
        
   /*INTO #temp2 */
    FROM ae_r_eqm_e,   
         ae_p_phs_e  
   WHERE ( ae_r_eqm_e.part = ae_p_phs_e.part ) and  
         ( ae_r_eqm_e.serial_no = ae_p_phs_e.serial_no ) and  
         ( ( datepart(month,ae_p_phs_e.beg_dt) = @MONTH ) ) and
	( ( datepart(year,ae_p_phs_e.beg_dt) = @YEAR ) ) and
	   ae_p_phs_e.repair_code=23 and
    		ae_p_phs_e.problem_code='SAMPL'  

select * from #temp ORDER BY shop,attr_val_8 ,   beg_dt 

GO

