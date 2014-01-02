

update ae_p_pro_e 
set status_code = "40-COMPLET"
where proposal in 
("984359")


update ae_p_phs_e
set status_code = "50-COMPLET" 
where proposal in 
("984359")

