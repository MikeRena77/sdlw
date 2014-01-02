select "Project" = convert(char(7),prj.project),
       "Person" = wka.shop_person,
       "Work_Req" = convert(char(8),wka.proposal),
       "Date" = wka.sched_date,
       "Hours" = wka.act_hrs,
       "Cost" = wka.act_cost
from ae_p_wka_d wka, ae_p_pro_e pro, ae_j_prj_d prj
where prj.proposal = wka.proposal and
      pro.proposal = prj.proposal and
      prj.project in ("91P6") and
      wka.sched_date < "05/31/99" and
      wka.shop_person in (
"Mark Rudolph"
)
order by prj.project,wka.shop_person, wka.proposal,wka.sched_date
compute sum(wka.act_hrs),sum(wka.act_cost) by prj.project, wka.shop_person,wka.proposal
compute sum(wka.act_hrs),sum(wka.act_cost) by prj.project
/*
9007 - DAVID SPROTT
9043 - BRUCE BUBAR
9102 - HARRY SCOTT
9104 - BILL CROW AND GEORGE NEIBLER
9107 - CLARENCE RICE AND RUDY RANDOLPH
9108 - BILL KEATING AND EDDIE PEREDO AND LARRY KOTARA
9110 - ARCHIE KINNEBRE AND WAYNE MCVICKER
9117 - BILL CROW AND LLOYD VEARRIER
9106 - HARRY SCOTT
91J6 - TERESA LANHAM AND PETER REILLY
91M6 - MICHAEL MUDSON
91P6 - MARK RUDOLPH
*/