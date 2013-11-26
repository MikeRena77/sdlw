/* begin extraction */
/*****************************************************************************
*
*  NAME        :  $Workfile:   endbld.cmd  $
*                 $Revision:   1.5  $  $Date:   12 Oct 2009 08:23:16  $
*                 $Logfile:   P:/vcs/cm/endbld.cmdv  $
*
*  DESCRIPTION :  Script to do misc post-build stuff
*
*  MODIFICATION/REV HISTORY :
*
* $Log:   P:/vcs/cm/endbld.cmdv  $
*  
*     Rev 1.5   12 Oct 2009 08:23:16   AOtt
*  Fixed a bug generating reasons.lst
*  
*     Rev 1.3   Nov 17 1997 17:11:12   BrettL
*  Added calls to new scrparts.pl.  This gets info from SCRs and puts it into
*  files pulled in by the swsn macro.
*  
*     Rev 1.2   Aug 25 1997 17:16:08   BrettL
*  corrected comment prefixes
*  fixed paths to  perl scripts
*  
*     Rev 1.1   12 Aug 1997 15:10:52   SujitG
*  
*     Rev 1.0   04 Aug 1997 15:14:20   SujitG
*  Initial revision.
*  
*     Rev 1.0   04 Aug 1997 15:12:54   SujitG
*  Initial revision.
*  
*     Rev 1.1   16 Apr 1997 11:08:08   brettl
*  Added call to cpchngs, to copy important changes into the build's
*  changes dir
*  
*     Rev 1.0   16 Apr 1997 10:46:38   brettl
*  Initial revision.
*
*
*****************************************************************************/
/* end extraction */

ARG Project BldLabel BldName
/* Handle usage request */

IF isUsage(Project) | Project = "" | BldName = "" THEN DO
REM /* IF Project = "" THEN DO */
   '@cls'
   SAY " "
   SAY " "
   SAY "Usage:  ENDBLD <project> <bldlabel> <bldname>"
   SAY " "
   SAY " This utility will automatically create the build notes for a"
   SAY " complete build from the build output files.  The results are"
   SAY " stored in the build output file directory as bldname.txt. "
   SAY " ex. q:\scr\build\n0220ar\n0220ar.txt"
   SAY " "
   SAY " This utility also adds the release.num file information to the"
   SAY " build summary file located in p:\latest.  If the file doesn't"
   SAY " exist, it will create one."
   SAY " "
   SAY " <project> identifies which drive will be used for linking to a"
   SAY " particular project.  One of nbase, nshell, nbp, nchevron etc."
   SAY " "
   SAY " <bldlabel> identifies which build release label to relate to."
   SAY " Ex. base22 shell22."
   SAY " "
   SAY " <bldname> identifies which build the build notes will be created for"
   SAY " and build summary updated for.  Ex. n0220ar sh0221a"
   SAY " "
   SAY " Ex:  endbld nbase base22 n0220ar"
   SAY " "
   EXIT 0
END /* THEN usage */

'perl -Ip:\cm p:\cm\warn.pl' Project BldLabel BldName
'perl -Ip:\cm p:\cm\bldnotes.pl' Project BldLabel BldName
'perl -Ip:\cm p:\cm\bldsmry.pl' Project BldLabel BldName
'perl -Ip:\cm p:\cm\cpchngs.pl' Project BldLabel BldName

'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*Reason for Change:" "^\s*Proposed Changes:" "" reasons.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*1. Changes with User Impact" "^\s*2. Changes with Cavnet/SST Impact" "" userimpact.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*2. Changes with Cavnet/SST Impact" "^\s*3. Changes with Developer Impact" "" cavnetimpact.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*3. Changes with Developer Impact" "^\s*4. Changes with Internal Impact" "" devlimpact.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*4. Changes with Internal Impact" "^\s*5. Changes with Customer Impact" "^\s*Change Comments from Module Headers:" intimpact.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*5. Changes with Customer Impact" "^\s*How to Back-out Changes:" "" custimpact.lst'
'perl -Ip:\cm p:\cm\scrparts.pl ' Project BldLabel BldName '"^\s*Change Comments from Module Headers:" "^\s*\*=========================================================================" "" moduleheaders.lst'
