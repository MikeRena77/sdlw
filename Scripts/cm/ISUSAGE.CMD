/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   ISUSAGE.CMD  $
*               $Revision:   1.0  $
*               $Date:   19 Dec 1996 14:58:52  $
*
*DESCRIPTION:   IsUsage(parameter)
*
*               If parameter is "", "?", "/?", "-?", "/H", "-H", "HELP",
*               "-HELP", or "/HELP" (case insensitive), then return 1,
*               else return 0.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   Q:/vcs/cm/ISUSAGE.CMv  $
   
      Rev 1.0   19 Dec 1996 14:58:52   rosimild
   Initial revision.
   
      Rev 1.1   29 Nov 1995 15:49:24   MerrillC
   Strip leading and trailing blanks for argument.
   
      Rev 1.0   12 Apr 1995 11:42:10   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG parm
  parm = strip(parm)
  IF parm == "" THEN RETURN 1

  /* strip off any leaving '/' or '-' */
  IF left(parm, 1) == '/' THEN parm = substr(parm, 2)
  IF left(parm, 1) == '-' THEN parm = substr(parm, 2)

EXIT parm == "?" | parm == "H" | parm == "HELP"
