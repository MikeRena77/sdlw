#!perl
#/*****************************************************************************
#* NAME:         $Workfile:   GetServerName.pl  $
#*               $Revision:   1.0  $
#*               $Date:   05 Aug 2002 09:24:22  $
#*
#* DESCRIPTION:  Returns software development server name.
#*               
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/GetServerName.plv  $
#*  
#*     Rev 1.0   05 Aug 2002 09:24:22   CraigL
#*  Initial revision.
#*
#*****************************************************************************
$ServerName = $ENV{'SOFTWARE_DEVELOPMENT_SERVER'};
if( !$ServerName )
{
   $ServerName = "WDSWDEVL";
}

return 1
