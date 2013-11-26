/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   ISVCSERR.CMD  $
*               $Revision:   1.0  $
*               $Date:   19 Dec 1996 14:58:58  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2 
*
* MODIFICATION/REV HISTORY:
* $Log:   Q:/vcs/cm/ISVCSERR.CMv  $
   
      Rev 1.0   19 Dec 1996 14:58:58   rosimild
   Initial revision.
   
      Rev 1.3   14 Nov 1995 16:08:42   BMASTER
   Added missing ;
   
      Rev 1.2   13 Nov 1995 13:18:06   MerrillC
   Added two message string to search for regarding license notifications.
   
      Rev 1.1   18 Oct 1995 09:11:44   MerrillC
   Added "file must not be a directory" get warning
   
      Rev 1.0   12 Oct 1995 09:48:06   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG file rest

IF rest \= "" | isUsage(file) THEN DO
   /* then usage help request */
   SAY ""
   SAY "Usage:  ISVCSERR <file>"
   SAY ""
   SAY "<file> is a file which includes (among possibly other things)"
   SAY "output from PVCS log files.  If any of the lines in <file>"
   SAY "appear to be a PVCS error that would affect the CM scripts,"
   SAY "then this script returns 1.  Otherwise, it returns 0."
   EXIT 0
END /* THEN usage request */

/* MAINTENANCE NOTE:  If you want to interpret additional PVCS warnings and  */
/* errors as begin CM script errors and if it can be detected by comparing   */
/* the first part of the line, then add the error prefix you are looking for */
/* to the following array.                                                   */
i=0
i=i+1;  prefixStr.i = "get: warning, can't locate archive";         prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "get: warning, can't find revision";          prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "get: warning, file must not be a directory"; prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "get: License notification: exceeded max.";   prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "get: warning, license notification: ";       prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "get: error, ";                               prefixLen.i = length(prefixStr.i)
i=i+1;  prefixStr.i = "vcs: error, ";                               prefixLen.i = length(prefixStr.i)
prefixStr.0 = i
prefixLen.0 = i

isError = 0
CALL stream file, 'C', 'OPEN READ'
DO WHILE lines(file)
   /* read a line for the log file */
   line = linein(file)

   /* check line for prefix indicating an error message */
   DO i = 1 to prefixStr.0
      IF left(line, prefixLen.i) == prefixStr.i THEN DO
         /* then we've found a probably error message, so flag it and leave */
         isError = 1
         LEAVE
      END /* THEN error found */
   END /* DO all prefixes */
END /* WHILE outFile */
CALL stream file, 'C', 'CLOSE'

EXIT isError
