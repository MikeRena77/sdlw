/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   andirs.cmd  $
*               $Revision:   1.1  $
*               $Date:   Oct 08 1998 18:28:20  $
* DESCRIPTION:  See usage below.
*
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/andirs.cmdv  $
*  
*     Rev 1.1   Oct 08 1998 18:28:20   brettl
*  Changed default location of proot.cmd or andirs.txt to be on D:\
*  These files are build dependent and having in p:\ was causing a problem
*  
*     Rev 1.0   Oct 07 1998 14:00:54   brettl
*  Initial revision.
   
      Rev 1.0   24 Oct 1995 17:15:18   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

ARG MASK

IF isUsage(MASK) THEN DO
   /* then this is a usage help request */
   SAY ""
   SAY "Usage:  ANDIRS <mask>"
   SAY ""
   SAY "This script reads the directory names in P:\CM\ANDIRS.TXT whose annotations"
   SAY "match the five character <mask> argument.  An '*' character in the <mask>"
   SAY "argument matches any value in that position except a comment file."
   SAY ""
   SAY "The selected lines are loaded FIFO into a queue and the name of that queue"
   SAY "is returned.  If an error occurs, it returns and empty string as the queue"
   SAY "name."
   SAY ""
   SAY "It is the caller's responsibility to delete the returned queue."
   EXIT ""
END /* THEN usage help */

/* local data */
andirs_txt  = "D:\NBASE\BIN\ANDIRS.TXT"
outputQueue = ""
attribs     = ""
directory   = ""


/* open ANDIRS.TXT */
CALL stream andirs_txt, 'C', 'OPEN READ'
IF RESULT \= "READY:" THEN DO
   /* then failed to open ANDIRS.TXT file */
   SAY "ANDIRS.CMD cannot open" andirs_txt "file.  No queue created."
   EXIT ""
END /* THEN open failed */

/* open output queue */
outputQueue = RxQueue('Create')
CALL RxQueue 'Set', outputQueue

/* read input file and output to queue */
DO WHILE lines(andirs_txt)
   /* read a line */
   PARSE VALUE linein(andirs_txt) WITH attribs directory .

   /* skip uninteresting lines                                      */
   IF left(attribs, 1) == '*' THEN ITERATE /* skip comments         */
   IF strip(attribs)   == ''  THEN ITERATE /* skip blank lines      */
   IF \isMatch(attribs, MASK) THEN ITERATE /* skip wrong attributes */

   /* put directory on the queue */
   queue strip(directory)
END /* WHILE andirs_txt */
CALL stream andirs_txt, 'C', 'CLOSE'

EXIT outputQueue
/*===========================================================================*/


ISMATCH: PROCEDURE;
  ARG attribs, MASK

  DO i = 1 TO 5
     MASK_char   = substr(MASK, i, 1)
     attrib_char = substr(attribs, i, 1)
     IF MASK_char \= '*' & (MASK_char \= attrib_char) THEN RETURN 0
  END /* DO all attributes */
RETURN 1
