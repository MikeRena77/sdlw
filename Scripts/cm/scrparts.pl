#/*****************************************************************************
#* NAME:         $Workfile:   scrparts.pl  $
#*               $Revision:   1.3  $
#*               $Date:   09 Oct 2009 09:41:32  $
#*
#* DESCRIPTION: Loop over all scrs in list, print a specific part of
#*              each scr.
#*               
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/scrparts.plv  $
#*  
#*     Rev 1.3   09 Oct 2009 09:41:32   AOtt
#*  Modified to support new format scr files with added fields for PA-DSS 
#*  compliance.
#*  
#*     Rev 1.2   Nov 11 1999 09:49:20   brettl
#*  fixed problem when a section title is duplicated in, say, the review
#*  comments - script now stops parsing after it has finished the 1st matched
#*  section found
#*  
#*     Rev 1.1   Sep 29 1999 10:46:16   brettl
#*  added code to ignore the new // bla bla bla // helper comments in the SCR
#*  
#*     Rev 1.0   Nov 17 1997 17:13:00   BrettL
#*  Initial revision.
#* 
#* 
#*****************************************************************************

require 'p:\cm\bldutils.pl'; 

if ($#ARGV != 6 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
  print <<HelpSection;
tool: scrparts
description: This tool loops over the build's list of scrs and prints a 
             section from each of the scrs.
             
             This is used to extract, say, all the module headers for
             a build for inclusion in the SWSN.

usage:   scrparts <project> <build label> <build name> <start delimiter> <stop delimiter> <alternate stop delimiter> <output file>
example: scrparts nbase base70 n0700g "Reason for Change:" "Proposed Changes:" "" changes.lst 
HelpSection
exit 1;
}

$project = "\U$ARGV[0]";

&getProjectDrive(*drive, $project);

$buildName = "\U$ARGV[1]";
$buildLabel = "\U$ARGV[2]";
$startDelimiter = "$ARGV[3]";
$stopDelimiter = "$ARGV[4]";
$alternateStopDelimiter = "$ARGV[5]";

$outputFile = "$drive\\scr\\build\\$buildLabel\\$ARGV[6]";
$scrListFile = "$drive\\scr\\build\\$buildLabel\\scrfiles.lst";

open (OUTPUT_FILE, ">$outputFile");

open (SCR_LIST_FILE, "<$scrListFile");
while ($scrFile = <SCR_LIST_FILE>)
{

  $shortScrFile = $scrFile;
  $shortScrFile =~ s/.*[\\\/](.*)\s/$1/; #srip off path

  $insideDesiredPart = 0;
  $nothingPrintedYet = 1;
  $finishedParsingSCR = 0;
  open (THIS_SCR, "<$scrFile");
  while (($_=<THIS_SCR>) && !$finishedParsingSCR)
  {
    if (!$insideDesiredPart && /$startDelimiter/)
    {
       $insideDesiredPart = 1;
       s/$startDelimiter//; #don't skip this line, people sometimes enter
                            #data after the delimiter, strip off the
                            #delimiter
    }

    if ($insideDesiredPart && (/$stopDelimiter/ || /$alternateStopDelimiter/))
    {
       $insideDesiredPart = 0;
       $finishedParsingSCR = 1;
    }

    if ($insideDesiredPart)
    {
       if ($nothingPrintedYet)
       {
          # ignore the helper comments in the SCR //
          # the helper comments look like "// bla bla bla //"
          if (!/^\s*$/ && !/^\s*\/\/.*\/\/\s*$/)
          {
             print OUTPUT_FILE "\n$shortScrFile\:\:\:\n";
             $nothingPrintedYet = 0;
          }
       }
       # ignore the helper comments in the SCR //
       # the helper comments look like "// bla bla bla //"
       if (!$nothingPrintedYet && !/^\s*\/\/.*\/\/\s*$/)
       {
          print OUTPUT_FILE;
       }
    }

  }
  close (THIS_SCR);
}
close (SCR_LIST_FILE);


close (OUTPUT_FILE);

print "$outputFile created.\n";
