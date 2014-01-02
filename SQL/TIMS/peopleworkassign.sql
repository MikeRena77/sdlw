select prj.project,phs.proposal,phs.sort_code,phsdsc,estimator,shop_person
from ae_p_phs_e phs, ae_p_pro_s pro, ae_j_prj_d prj
where phs.proposal = pro.proposal and
      phs.proposal = prj.proposal and
      phs.sort_code = pro.sort_code and
      phs.proposal like "99%" and shop = "DESIGN ENG" and
      phs.status_code not in ("50-COMPLET","60-CLOSED")
order by prj.project,phs.proposal,phs.sort_code
