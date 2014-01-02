drop proc rep_report
go
 create proc rep_report (@report_month int,@report_year int)
/* GFP Maintenance Actions- Contractor Furnished Report query  */ 
/* report WR repair actions after elimination all but the last phase status_date per phase */
/* execute rep_report @report_MONTH=8,@report_YEAR=1998  */
AS 
 SELECT
	 ae_p_pst_e.proposal,ae_p_pst_e.sort_code ,status_date=max(status_date)
    INTO #temp  
    FROM  
         ae_p_pst_e  
   WHERE 
         ( ( datepart(month,ae_p_pst_e.status_date) = @report_month) ) and
	( ( datepart(year,ae_p_pst_e.status_date) = @report_year) )
GROUP BY ae_p_pst_e.proposal,ae_p_pst_e.sort_code 

select   ae_r_eqm_e.attr_val_8,   
         ae_r_eqm_e.attr_val_0,   
         ae_p_phs_e.proposal,   
         ae_p_phs_e.labor_indx,   
         ae_p_phs_e.craft_code,   
         ae_p_phs_e.beg_dt,   
         #temp.status_date,   
         ae_p_phs_e.act_tot,   
         #temp.status_date
FROM	ae_r_eqm_e,   
         ae_p_phs_e,
	#temp  
WHERE  ( ae_r_eqm_e.part = ae_p_phs_e.part ) and  
         ( ae_r_eqm_e.serial_no = ae_p_phs_e.serial_no ) and  
         ( ae_p_phs_e.proposal = #temp.proposal ) and  
         ( ae_p_phs_e.sort_code = #temp.sort_code )    
ORDER BY ae_r_eqm_e.attr_val_8 ASC,   
         ae_r_eqm_e.attr_val_0 ASC,   
         ae_p_phs_e.proposal ASC 
  go
