/*
 * dropTmp.sql
 *
 * Drop TMP tables generated, and not dropped,
 * by previous Harvest 4 installations
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR CONTINUE

DROP table tmpEnvironment;
DROP table tmpState;
DROP table tmpStateProcess;
DROP table tmpApprove;
DROP table tmpApproveList;
DROP table tmpCheckInProc;
DROP table tmpCheckOutProc;
DROP table tmpConMrgProc;
DROP table tmpCrPkgProc;
DROP table tmpCrsEnvMrgProc;
DROP table tmpDelVersProc;
DROP table tmpDemoteProc;
DROP table tmpIntMrgProc;
DROP table tmpListDiffProc;
DROP table tmpListVersProc;
DROP table tmpMovePkgProc;
DROP table tmpNotify;
DROP table tmpNotifyList;
DROP table tmpLinkedProcess;
DROP table tmpPackageGroup;
DROP table tmpPromoteProc;
DROP table tmpRemItemProc;
DROP table tmpSnapViewProc;
DROP table tmpUDP;
DROP table tmpView;
