#!perl
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   notsubmitted.pl  $
#*               $Revision:   1.2  $
#*               $Date:   Sep 01 2000 08:09:58  $
#*
#* DESCRIPTION:  rename archive
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/notsubmitted.plv  $
#*  
#*     Rev 1.2   Sep 01 2000 08:09:58   JACIC
#*  if submitted for some release, don't display
#*  
#*  Modified to not pull up scr's that are submitted for other releases.
#*
#*     Rev 1.1   Feb 04 2000 13:16:32   brettl
#*  fixed typos in help output
#*  
#*     Rev 1.0   Feb 04 2000 13:12:48   brettl
#*  Initial revision.
#*  
#*  
#*
#*****************************************************************************
# end extraction 

if ($#ARGV < 1 || $#ARGV > 1 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
print <<HelpSection;

Tool: notsubmitted
displays list of a project's SCRs that have not yet been submitted for
the specified release


Usage: notsubmitted <scr directory path> <release label>
Example: notsubmitted q:\\scr\\in BASE80

Note: script doesn't look at branching
      so, for instance, a branched SCR submitted for BASE70 that should
      not be submitted for BASE80, will show up in the BASE80 listing

Note: script is very dumb, junk files in scr\\in will be included

HelpSection
exit;
}

$scrInDir = "\U@ARGV[0]";
$releaseId = "\U@ARGV[1]";

$_ = $releaseId;
if (/BASE/)
{
  $tailCount = 100;
}
else
{
  $tailCount = 40;
}

print "searching $tailCount newest files in $scrInDir...\n";

open(SCRDIR_OUT, "dir /s /b /od $scrInDir|tail -$tailCount|");
while (<SCRDIR_OUT>)
{
  if (!`grep "^SUBMITTED.*$releaseId" $_`) 
  {
    if (!`grep "^SUBMITTED.*" $_`)
    {
       print;
    }
  }
}

close(SCRDIR_OUT);
