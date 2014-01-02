
select prjd.project,prj_dsc,wkad.shop_person,wkaa.work_desc
from ae_j_prj_d prjd, ae_j_prj_e prje, ae_p_wka_d wkad, ae_p_wka_a wkaa
where prjd.project = prje.project and
      prjd.proposal = wkad.proposal and
      wkad.trans_no = wkaa.trans_no and
      wkad.item_no = wkaa.item_no and
      wkad.sched_date between "02/14/00" and "02/19/00" and
      prje.prj_type like "B%" and
      wkad.shop = "INFORMATION SRV"       
order by prjd.project,prjd.proposal,wkaa.trans_no,wkaa.item_no,wkaa.seq
