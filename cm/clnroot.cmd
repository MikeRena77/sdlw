/*****************************************************************************
* NAME:         $Workfile:   clnroot.cmd  $
*               $Revision:   1.2  $
*               $Date:   Oct 09 1998 12:00:28  $
* DESCRIPTION:  See usage help.
*
* MODIFICATION/REV HISTORY:
* $Log:   P:/vcs/cm/clnroot.cmdv  $
   
      Rev 1.2   Oct 09 1998 12:00:28   brettl
   changed "andirs.txt" to "ANDIRS.TXT" for consistency
   
      Rev 1.1   Oct 08 1998 18:28:22   brettl
   Changed default location of proot.cmd or andirs.txt to be on D:\
   These files are build dependent and having in p:\ was causing a problem
   
      Rev 1.0   08 Jul 1997 16:34:54   SujitG
   Initial revision.
   
      Rev 1.0   24 Jun 1997 16:35:00   SujitG
   Initial revision.
   
      Rev 1.2   08 Dec 1995 13:37:04   MerrillC
   Added an optional <build_type> argument.  If that argument is the keyword
   SYMBOLS or SYMBOL (case insensitive) then this script does NOT delete the
   contents of LIB\ directories.
* 08/17/94 Mac  - No longer delete .H files derived from Raima .DDL files.
*                 No longer suppress printing of directory DEL commands.
*                 No longer delete *.FIN files (since they are no longer produced)
* 05/26/94 Mac  - Added deletion of <foo>.h files in source directories which
*                 contained <foo>.ddl files under the assumption that the .h
*                 files were derived from the .ddl files.
* 05/20/94 Mac  - Added *.@@@ and pvcs????.tmp to files to be deleted.
* 04/21/94 Mac  - initial version
*****************************************************************************/
/* end extraction */

ARG root','build_type

IF isUsage(root) THEN DO
   /* then this is a request for usage help */
   SAY ""
   SAY "Usage:  CLNROOT <root>[, <build_type>]"
   SAY ""
   SAY "This script prepares the <root> hierarchy for a build by deleting all"
   SAY "'derived' files (e.g., objects, libraries, DLLs, and everything in the"
   SAY "TARGET\ directory."
   SAY ""
   SAY "If <build_type> is SYMBOLS or SYMBOL (case insensitive), then this script"
   SAY "does NOT delete libraries.  This option should be used when preparing a"
   SAY "build hierarchy without symbols for use in a symbols build."
   EXIT 0
END /* THEN usage */


CALL RxFuncAdd 'SysFileDelete', 'RexxUtil', 'SysFileDelete'
CALL RxFuncAdd 'SysFileTree',   'RexxUtil', 'SysFileTree'

build_type = strip(build_type)
keepLibs   = build_type == "SYMBOLS" | build_type == "SYMBOL"
andirsFile = "D:\ANDIRS.TXT"

DO WHILE lines(andirsFile)
   line = linein(andirsFile)               /* list of hierarcy directories */
   IF substr(line, 1, 1)=="*" THEN ITERATE /* comment line */

   annotation = subword(line, 1, 1)
   dir        = subword(line, 2, 1)        /* has trailing \ */
   S_or_D     = substr(annotation, 4, 1)
   L_or_T     = substr(annotation, 3, 1)

   /* get rid of make.out, *.FIN, *.$$$, *.@@@, and pvcs???.tmp files */
   'del /s /f /q ' root||dir'\make.out'
   'del /s /f /q ' root||dir'\*.$$$'  
   'del /s /f /q ' root||dir'\*.@@@' 
   'del /s /f /q ' root||dir'\pvcs???.tmp' 

   IF S_or_D=="S"            THEN ITERATE /* skip source directories  */
   IF L_or_T=="L" & keepLibs THEN ITERATE /* skip library directories */

   IF L_or_T=="T"
      THEN files = root||dir'\*.OBJ' /* delete only test objects */
      ELSE files = root||dir'\*.*'   /* delete all files         */

  
   'del /f /q' files
END /* WHILE andirs.txt */

EXIT 0

