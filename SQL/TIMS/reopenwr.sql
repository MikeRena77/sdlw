
update ae_p_pro_e 
set status_code = "50-CLOSED"
where proposal in 
("983601",
"984048",
"984103",
"984205",
"984274",
"984310",
"984446")
/*
update ae_p_phs_e
set status_code = "60-CLOSED" 
where proposal in 
("983601",
"984048",
"984103",
"984205",
"984274",
"984310",
"984446")
*/