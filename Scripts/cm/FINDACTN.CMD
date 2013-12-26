/* begin extraction */
/*****************************************************************************
*
*
* NAME          :  $Workfile:   findactn.cmd  $
*                  $Revision:   1.0  $
*                  $Date:   31 Dec 1996 12:51:42  $
*
* DESCRIPTION:
*   This utility can be used inside makefiles that call another commands
*   to find the command at one of the standard structures use in PROMS.
*   
*
* TARGET: OS/2 2.X
* TOOLS:          
*
* MODIFICATION/REV HISTORY :
*
* 08/15/94 RPS - returning exit code to the caller.
* 03/23/94 RPS - added a small help.
* 03/18/94 RPS - Initial Version.
*
*****************************************************************************/
/* end extraction */

/* LOCAL DEFINES */
PARSE ARG myFile subsys theCmd theOptions

GlobalEnv = 'ENVIRONMENT'

IF (myFile = '') THEN DO
   SAY 'FINDACTN file subsystem theCommand theOptions'
   SAY '     file       - name of a file (makefile.mak, ccboard.cmd)'
   SAY '     subsystem  - componet+ subsystem (sc\sys, ipt\ui )'
   SAY '     theCommand - a command or NONE (make, none)'
   SAY '     theOptions - switchs for the command ( -B -K )'
   SAY ' findactn makefile.mak sc\sys make -K -p rebuild'
   SAY ' findactn ccboard.cmd sc\util none'
   EXIT
END

/* assembly the list of directories to search */
dirList.0 = myFile
dirList.1 = VALUE( 'PROMS_DROOT',, GlobalEnv )
IF (dirList.1 <> '' )  THEN
  dirList.1 = dirList.1'\'subsys'\'myFile
dirList.2 = VALUE( 'PROMS_GROOT',, GlobalEnv )
IF (dirList.2 <> '' )  THEN
  dirList.2 = dirList.2'\'subsys'\'myFile
dirList.3 = VALUE( 'PROMS_BROOT',, GlobalEnv )
IF (dirList.3 <> '' ) THEN
  dirList.3 = dirList.3'\'subsys'\'myFile

/* searching the commands */
DO i=0 TO 3
  IF dirList.i <> '' THEN DO
    line = STREAM( dirList.i, 'C', 'QUERY EXISTS' ) 
    IF line <> '' THEN DO
       IF theCmd <> '' THEN 
          SELECT
            /* to execute a make command */
            WHEN (theCmd = 'make') | (theCmd = 'MAKE') THEN DO
                theCmd '-f'line theOptions
                EXIT rc
            END

            /* probably a REXX command */
            WHEN (theCmd = 'NONE') | (theCmd = 'none') THEN DO
                'call' line theOptions
                EXIT rc
            END
/*
            OTHERWISE
*/
         END
       /* no command has been specified */
       ELSE DO
          'call' line theOptions
          EXIT rc
       END 
    END
  END 
END
SAY 'ERROR - Could not find the specified file or command.'
EXIT 10
