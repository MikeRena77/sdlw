#!p:\perl
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   warn.pl  $
#*               $Revision:   1.1  $
#*               $Date:   Aug 19 1997 15:50:36  $
#*
#* DESCRIPTION:  Prints all the warning messages from make.out to warnings.out
#*               
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/warn.plv  $
#* 
#*    Rev 1.1   Aug 19 1997 15:50:36   BrettL
#* fixed comment prefix characters in mod/rev section, and fixed dollar-log line
#*   
#*      Rev 1.0   04 Aug 1997 13:34:38   SujitG
#*   Initial revision.
#*****************************************************************************
#/* end extraction */



require 'chckparm.pl';

$listdir = "$drive\\";
$bldname = shift(@ARGV);

$fileFrom  = "$listdir\\build\\$bldname\\make.out";
$fileTo = "$listdir\\scr\\build\\$bldname\\warnings.out"; 

# remove the extra slashes
$fileFrom =~ s/\\{2}/\\/;
$fileTo =~ s/\\{2}/\\/;


# takes the lines containing " warning from the make.out  
`grep -i -n warning $fileFrom > $fileTo`;










