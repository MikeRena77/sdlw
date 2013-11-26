/* begin extraction */
/*****************************************************************************
* NAME:         $Workfile:   ERR_BEEP.CMD  $
*               $Revision:   1.0  $
*               $Date:   19 Dec 1996 14:58:56  $
* DESCRIPTION:  Plays the standard CM error beep.
* TARGET:       OS/2
*
* MODIFICATION/REV HISTORY:
*$Log:   Q:/vcs/cm/ERR_BEEP.CMv  $
   
      Rev 1.0   19 Dec 1996 14:58:56   rosimild
   Initial revision.
   
      Rev 1.0   26 Sep 1995 13:12:22   MerrillC
   Initial revision.
*****************************************************************************/
/* end extraction */

CALL beep 440, 150
CALL beep 220, 300
EXIT
