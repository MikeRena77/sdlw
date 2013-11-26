/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   add2bld.cmd  $
*               $Revision:   1.2  $
*               $Date:   01 Nov 1995 17:26:38  $
* DESCRIPTION:  This script simply calls P2BLD with an initial argument of 1.
*               See also PVCS2BLD script.
*
* TARGET:       OS/2 2.1
*
* MODIFICATION/REV HISTORY:
* $Log:   P:\vcs\cm\add2bld.cmv  $
   
      Rev 1.2   01 Nov 1995 17:26:38   MerrillC
   Now requires that its arguments be separated by commas.
   Usage help requests are now passed on to P2BLD.CMD to be processed.
      Rev 1.0   09 Oct 1995 14:14:08   SAMN
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG arglist
IF \isUsage(arglist) & pos(',', arglist) == 0 THEN DO
   /* then arguments are not separated by commas, so complain and exit */
   SAY "Arguments must be separated by commas."
   CALL err_beep
   EXIT 1
END /* THEN no commas */

EXIT p2bld(1','arglist)
/*=========================================================================*/
