#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   copyall.mak  $
#*               $Revision:   0.1  $
#*               $Date:   19 Nov 2013 8:20:00  $
#* DESCRIPTION:  MAKEFILE copies or updates        
#* PRECONDITION: 
#* TOOLS:        Make Utility
#*
#* MODIFICATION/REVISION HISTORY :
#* $Log:   C:/temp/copyall.makv  $
#*  
#*  
#*****************************************************************************/
#/* end extraction */
LOG = C:/temp/copyall.makv

ALL: REFRESH

REFRESH:  COPYDOCS COPYDNLDBAT COPYWORKSPACE

COPYDOCS :
	cd /d e:\Documents
	cd /d c:\Users\502256043\Documents
	dir /a:d /b > $(LOG)
	cd
	xcopy /m/f/h/r/s/v/y *.* "e:" >> $(LOG) 

# COPYEXE :
#   xcopy /d/f/h/r/v/y .\misc\*.exe .\TARGET\BIN\ 

COPYDNLDBAT :
	cd /d e:\Downloads
	cd /d c:\Users\502256043\Downloads
	cd
	dir /a:d /b  >> $(LOG)
	xcopy /m/f/h/r/s/v/y *.* "e:" >> $(LOG)

COPYWORKSPACE :
	cd /d e:\workspace
	cd /d c:\Users\502256043\workspace
	cd
	dir /a:d /b  >> $(LOG)
	xcopy /m/f/h/r/s/v/y *.* "e:" >> $(LOG)

