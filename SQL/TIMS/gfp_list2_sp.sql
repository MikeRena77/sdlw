  create proc gfp_list
  as
     SELECT PART_NUMBER=ae_i_inv_e.part,   
         DESCRIPTION=ae_i_inv_e.inv_dsc,   
         UNIT=ae_i_inv_e.inv_uom,   
         PRICE=ae_i_inv_e.inv_cost,   
         QTY=ae_i_inv_e.inv_sot,   
         TOTAL_PRICE=ae_i_inv_e.tot_amt,   
         WAREHOUSE=ae_i_inv_e.warehouse  
    FROM ae_i_inv_e  
   WHERE ae_i_inv_e.serial_yn = 'Y'    
   COMPUTE sum(inv_sot),sum (tot_amt)