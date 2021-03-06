#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   prmtlst.pl  $
#*               $Revision:   1.5  $
#*               $Date:   13 Jun 2005 13:23:00  $
#*
#* DESCRIPTION:  Generate a build's promote list
#*               
#* MODIFICATION/REV HISTORY:
#*$Log:   P:/vcs/cm/prmtlst.plv  $
#* 
#*    Rev 1.5   13 Jun 2005 13:23:00   BMaster
#* Modified to allow dashes in the file name when the file is marked
#* for deletion
#* 
#*    Rev 1.4   12 Mar 2004 15:13:46   WTong
#* update to be able to promote the files with "-" in the middle of the name.
#* 
#*    Rev 1.3   Oct 05 1999 12:54:08   brettl
#* added support for case where a file is promoted and deleted in the
#* same build - file should not be included in promote.lst in this case
#* 
#*    Rev 1.2   Nov 19 1997 10:36:00   bmaster
#* Added p:\cm to require-bldutil.pl statement.  So it can be run anywhere
#* 
#*    Rev 1.1   Nov 17 1997 17:10:16   BrettL
#* Enhanced to exclude back-promoted revisions from the promote.lst.
#* (Major rework)
#* 
#*    Rev 1.0   26 Jun 1997 16:04:34   BrettL
#* Initial revision.
#* 
#*****************************************************************************
#/* end extraction */

require 'p:\cm\bldutils.pl';

if ($#ARGV != 4 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
  print <<HelpSection;
tool: prmtlst
description: This tool creates a list of files, and their revisions, that
             should be promoted for a build based on the filenames in SCRs.

limitation: this should only be used with a new build
            for instance if the latest build is N0700R
            don't use this for a refresh of N0700Q

usage:prmtlst <project> <build label> <promote list> <scr list> <log output>
example:prmtlst NBASE BASE70 q:\\scr\\build\\n0700a\\promote.lst q:\\scr\\build\\n0700a\\scrfiles.lst q:\\scr\\build\\n0700a\\promote.log 
HelpSection
exit 1;
}

$project = "\U$ARGV[0]";
$buildLabel = "\U$ARGV[1]";
$promoteListFile = "\U$ARGV[2]";
$scrListFile = "\U$ARGV[3]";
$logFile = "\U$ARGV[4]";

&getProjectDrive(*drive, $project);
$vcsRoot = "$drive\\VCS\\";
$vlogInputFileList = "$ENV{TMP}\\prmtlst.tmp";

%moduleRevs = ();
%moduleDels = ();

open (LOG_FILE, ">$logFile");

###########################
#loop over SCRs, put each module into an array
#   check the array to see if the module was already processed
#   if it exists in the array, check the revisions and save the
#   bigger of the two.
#(keep deleted modules in seperate array)

open (SCR_LIST_FILE, "<$scrListFile");
while ($scrFile = <SCR_LIST_FILE>)
{

  open (THIS_SCR, "<$scrFile");
  while (<THIS_SCR>)
  {
    s/\//\\/g; # convert forward to back slashes

    #normal module name line 
    if (/^[\S\.]+\s+([\d\.]+|new)\s+[\d\.]+\s+\S+\s+\S+/i)
    {
      print LOG_FILE;
      
      ($file, $oldRev, $newRev, $path, $scrName) = split(/\s+/);
      $fullName = "\U$path\\$file";

      if ( $moduleRevs{$fullName} )
      {
         local $isNewer = 0;
         local $existingRev = $moduleRevs{$fullName};
         print LOG_FILE "duplicate promote: $fullName ($existingRev, $newRev)";
         &isRevNewer(*isNewer, $newRev, $moduleRevs{$fullName} );
         if ( $isNewer )
         {
            $moduleRevs{$fullName} = $newRev;
         }
         print LOG_FILE "  Using Rev $moduleRevs{$fullName}\n";
      }
      else
      {
         $moduleRevs{$fullName} = $newRev;
      }
                  
    }

    #delete line (starts with tilde)
    if (/^~([\S\.\\\/])+\s*$/)
    {
      print LOG_FILE;
      s/^~//; #remove leading "~"
      s/\s//g; #remove white space
      s/\n//g; #remove new line
      $moduleDels{"\U$_"} = "~"; # the value "~" is just a placeholder
    }

  }
  close (THIS_SCR);
}
close (SCR_LIST_FILE);


##############################
#create the @file list for vlog

open (VLOG_INPUT_FILE_LIST, ">$vlogInputFileList");
foreach $thisFile ( sort keys %moduleRevs)
{
  $archiveFile = "$vcsRoot$thisFile";
  print VLOG_INPUT_FILE_LIST "$archiveFile\n";

}
close (VLOG_INPUT_FILE_LIST);

##############################
#loop over pvcs output
#compare each line's file/rev with the moduleRevs array
#if there's a back-promote detected, delete it from the array

$vlogCmd = "vlog -q -bv$buildLabel \@$vlogInputFileList";
print LOG_FILE "$vlogCmd\n";
open(PVCS_OUTPUT, "$vlogCmd|" );
while (<PVCS_OUTPUT>)
{
   print LOG_FILE;
   
   #example output returned by pvcs:
   #Q:\VCS\COMMON\DATABASE\BASUPGRD.SQLv - BASE70 : 4.15

   s/\s//g;   #srip out all the whitespace
   s/\//\\/g; #convert slashes to back-slashes (just in case)

   #strip off everything but the filename and the revision, 
   #insert ":" delimiter
   s/.......(.*)v-$buildLabel:([\d\.]*)$/$1:$2/; 

   #convert to uppercase and split it
   ($thisFile, $buildLabelRev) = split ':', "\U$_";

   #confirm the file in the pvcs output is a known file
   #    if it's not a known file, log an error, this should not happen
   if ( $moduleRevs{$thisFile} )
   {
     $scrRev = $moduleRevs{$thisFile};
     
     &isRevOlder(*isOlder, $scrRev, $buildLabelRev );
     if ( $isOlder )
     {
       print LOG_FILE "skipping back promoted file: ".
             "$thisFile = $buildLabel:$buildLabelRev, promoted:$scrRev\n";
       delete $moduleRevs{$thisFile};
     }

   }
   else 
   {
      print LOG_FILE "ERROR: $thisFile not found in module list\n";
   }   
}
close (PVCS_OUTPUT);


###########################
#sometimes a file is promoted and deleted in the same build
#loop over the promote list and remove any entries from the list that
#are contained in the delete list


foreach $thisFile ( keys %moduleRevs )
{
   if ( $moduleDels{$thisFile} )
   {
      delete $moduleRevs{$thisFile};
   }
}  


###########################
#write the promote.lst file

open (PROMOTE_LIST_FILE, ">$promoteListFile");

$newRevCount = 0;
foreach $thisFile ( sort keys %moduleRevs)
{
   printf PROMOTE_LIST_FILE "%-30s %s\n", "$thisFile", "$moduleRevs{$thisFile}";
   $newRevCount++;
}  

$delModuleCount = 0;
foreach $thisFile ( sort keys %moduleDels)
{
  print PROMOTE_LIST_FILE "~$thisFile\n";
  $delModuleCount++;
}  

close (PROMOTE_LIST_FILE);

close (LOG_FILE);

print "$promoteListFile created. updates: $newRevCount deletes: $delModuleCount\n";
