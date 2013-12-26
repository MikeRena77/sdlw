/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   ISDIR.CMD  $
*               $Revision:   1.0  $
*               $Date:   19 Dec 1996 14:58:54  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   Q:/vcs/cm/ISDIR.CMv  $
   
      Rev 1.0   19 Dec 1996 14:58:54   rosimild
   Initial revision.
   
      Rev 1.1   23 Oct 1995 12:45:46   MerrillC
   Change to recognize the root of an drive letter that exists as being
   a directory.
   
      Rev 1.0   16 Oct 1995 10:51:10   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG dirPathname rest

IF rest \= "" | isUsage(dirPathname) THEN DO
   /* then this is a usage help request */
   SAY ""
   SAY "Usage:  ISDIR  <dirPathname>"
   SAY ""
   SAY "<dirPathname> is the pathname of a directory written without a trailing"
   SAY "'\'.  This script returns 1 if <dirPathname> represents an existing"
   SAY "directory and 0 otherwise."
   EXIT ""
END /* THEN usage help */

/* Normalize the argument */
len = length(dirPathname)
IF right(dirPathname, 1) == "\" THEN
   /* remove trialing \ */
   dirPathname = substr(dirPathname, 1, len - 1)

IF right(dirPathname, 4) == "\*.*" THEN
   /* remove trailing \*.* */
   dirPathname = substr(dirPathname, 1, len - 4)

'@dir' dirPathname '1> NUL 2> NUL'
EXIT rc == 0
/*==========================================================================*/
