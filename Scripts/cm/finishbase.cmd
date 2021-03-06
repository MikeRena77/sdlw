/*****************************************************************************
*
*  NAME        :  $Workfile:   finishbase.cmd  $
*                 $Revision:        $
*                 $Date:   Oct 08 1998 18:27:12  $
*
*  DESCRIPTION :  Script to Copy the base build to the network and finish pvcs
*                 labels.
*
*  MODIFICATION/REV HISTORY :
*
* $Log:   P:/vcs/cm/finishbase.cmdv  $
*  
*  Initial revision.
*
*****************************************************************************/

/***************************************************************************/
/*PARAMETERS*/
/***************************************************************************/

ARG BaseDir BuildLabel ReleaseName AllocType Rest

ScrDir = "Q:\SCR\"
/* ScrDir = "Q:\SCR\" :changed here*/
PvcsDir = "Q:\VCS"
/* PvcsDir = "Q:\VCS" :changed here*/

BuildDir = "BUILD\"
BaseBuildDir = "Q:\BUILD\"
PromoteFileName = "PROMOTE.LST"
PromoteLogFileName = "PRMTLST.LOG"
GetProotLogFileName = "GETPROOT.LOG"
NottipFileName = "Nottip.out"
ExtractlFileName = "extractl.out"
MovlabelFileName = "movlabel.out"
OutputFileName = ""
ScrFile = "SCRFILES.LST"
ScrSubDir = "IN\"
InputFileName = ""
BaseLink = ""
/* basebld log output file              */
outFile = ScrDir""BuildDir""ReleaseName"\basebld.log"
ReleaseDir = BaseBuildDir""ReleaseName

ErrorMessage = ""
/************************************************************************/
/* promote the new build to the network */
/************************************************************************/

CALL outputMsg "promote the new build to the network"
rc = promote( BaseDir"," ReleaseDir )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: promote failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/************************************************************************/
/* attach the correct label */
/************************************************************************/

CALL outputMsg "attach the correct label"
BaseLink = substr( BaseDir, 4, 9 )
OutputFileName = ScrDir""BuildDir""ReleaseName"\"MovlabelFileName
rc = movlabel( BuildLabel"," ReleaseName"," BaseLink"," OutputFileName )
IF rc \= 0 THEN
DO
   CALL outputMsg "ERROR: movlabel failed with rc = " rc
   CALL err_beep
   EXIT 1
END

/************************************************************************/
/* run the nottip utility */
/************************************************************************/

CALL outputMsg "run the nottip utility"
OutputFileName = ScrDir""BuildDir""ReleaseName"\"NottipFileName
rc = nottip( PvcsDir"," BuildLabel"," OutputFileName )
IF rc \= 0 THEN
DO
   SAY "ERROR: nottip failed with rc = " rc
   CALL err_beep
   EXIT 1
END

CALL outputMsg "Base build successfully completed at "time()

EXIT

/*=========================================================================*/

outputMsg: PROCEDURE EXPOSE outFile;
  PARSE ARG msg
  SAY msg
  CALL lineout outFile, msg
RETURN 0
/*=========================================================================*/
