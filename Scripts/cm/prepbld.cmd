@rem = '
@echo off
perl -Ip:\cm p:\cm\prepbld.cmd %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
@rem ';
#
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   prepbld.cmd  $
#*               $Revision:   1.1  $
#*               $Date:   Oct 31 1997 14:42:12  $
#
#* DESCRIPTION:  See usage help below
#
#
#  prepare scr perl script
#  this script will take a set of files from the accept directory
#  and prepare an scrfiles.lst file for the next build specified
#
#  prepbld <project> <bldlabel> <bldname>
#  ex. prepbld nbase base22 n0220an
#  ex. prepbld nstarter starter01 st0100ab
#
#* TARGET:       NT
#*
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/prepbld.cmdv  $
#* 
#*    Rev 1.1   Oct 31 1997 14:42:12   BrettL
#* adding explicit path to require statement so it can be run from anywhere
#* 
#*    Rev 1.0   02 Jul 1997 18:26:48   BrettL
#* Initial revision.
#
#*****************************************************************************/
#/* end extraction */

if ( (!(length(@ARGV[0]))) || (@ARGV[0] =~ /\?/i) || (@ARGV[0] =~ /^help/i) || (@ARGV[0] =~ /^-h/i) ) {
   print "\n";
   print "Usage:  PREPBLD <project> <bldlabel> <bldname>\n";
   print " \n";
   print " This utility calls accept and prepare to accept scrs and\n";
   print " create/edit the scrfiles.lst file for a build.\n";
   print " \n";
   print " <project> identifies which drive will be used for linking to a\n";
   print " particular project.  One of nbase, nshell, nbp, nchevron etc.\n";
   print " \n";
   print " <bldlabel> identifies which build release label to relate to.\n";
   print " Ex. base22 shell22.\n";
   print " \n";
   print " <bldname> identifies which build the build notes will be created for\n";
   print " and build summary updated for.  Ex. n0220ar sh0221a\n";
   print " \n";
   print " Ex:  prepbld nbase base22 n0220ar\n";
   print " \n";
   exit;
}

unshift(@INC,'.');
require 'p:\cm\chckparm.pl';

$bldname = shift(@ARGV);

# is the bldname valid??
if (!(length($bldname))) {
   die "build name must be specified\n";
}

`accptscr $project $label`;
`prepscr $project $label $bldname`;


__END__
:endofperl
