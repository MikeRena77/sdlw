/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   pvcs2bld.cmd  $
*               $Revision:   1.42  $
*               $Date:   01 Nov 1995 17:25:32  $
* DESCRIPTION:  This script simply calls P2BLD with an initial argument of 0.
*               See also ADD2BLD script.
*
* TARGET:       OS/2 2.1
*
* MODIFICATION/REV HISTORY:
* $Log:   P:\vcs\cm\pvcs2bld.cmv  $
   
      Rev 1.42   01 Nov 1995 17:25:32   MerrillC
   Now requires that its arguments be separated by commas.
   Usage help requests are now passed on to P2BLD.CMD to be processed.
*****************************************************************************/
/* end extraction */

ARG arglist
IF \isUsage(arglist) & pos(',', arglist) == 0 THEN DO
   /* then arguments are not separated by commas, so complain and exit */
   SAY "Arguments must be separated by commas."
   CALL err_beep
   EXIT 1
END /* THEN no commas */

EXIT p2bld(0','arglist)
/*=========================================================================*/
