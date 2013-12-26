#!p:\perl
#
# $Workfile:   CPCHNGS.PL  $
# $Revision:   1.1  $ $Date:   Oct 31 1997 14:41:26  $
# $Logfile:   P:/vcs/cm/CPCHNGS.PLv  $
#
#  copy the build's changes from the scr\build dir into the real build's
#  changes dir
#  also copy the build's scrs into the real build's changes dir
#
#  cpchngs <project> <bldlabel> <bldname>
#  ex. cpchngs nbase base22 n0220an
#  ex. cpchngs nstarter starter01 st0100ab

unshift(@INC,'.');
require 'p:\cm\chckparm.pl';

# is the bldname valid??
$bldname = shift(@ARGV);
if (!(length($bldname))) {
   die "build name must be specified\n";
}

$scrbldpath = "$drive\\scr\\build\\$bldname";
$realbldpath = "$drive\\build\\$bldname";
$bldchangespath = "$realbldpath\\changes";

$scrfiles = "$scrbldpath\\scrfiles.lst";
$summaryfile = "$scrbldpath\\$bldname.txt";

if (!-e $summaryfile)
{
   die "build summary file ${bldname}.TXT does not exist\n";
}

`copy $summaryfile $bldchangespath`;

open(SCRFILES, "<$scrfiles");
while(<SCRFILES>)
{
  chop;
  `copy $_ $bldchangespath`;
}
