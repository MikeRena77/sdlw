#!perl
#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   cmplabel.pl  $
#*               $Revision:   1.3  $
#*               $Date:   Oct 27 1998 14:27:12  $
#*
#* DESCRIPTION:  Compares archives labels, prints report if labels'
#*               revision ids are different.
#*
#* TARGET:       OS/2 2.1
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:/vcs/cm/cmplabel.plv  $
#* 
#*    Rev 1.3   Oct 27 1998 14:27:12   brettl
#* fixed typographical errors in help, also added example using redirection
#* 
#*    Rev 1.2   Sep 25 1998 12:59:02   brettl
#* removed code that automatically changed params to uppercase.
#* Some labels are not all uppercase and vcs and this script are case
#* sensitive.
#* 
#*    Rev 1.1   Aug 19 1997 15:38:26   BrettL
#* updated script to support new archive names ("v" suffix)
#* 
#*    Rev 1.0   Aug 11 1997 12:38:30   BrettL
#* Initial revision.
#*  
#*     Rev 1.0   11 Mar 1997 14:23:30   brettl
#*  Initial revision.
#*  
#*
#*****************************************************************************
# end extraction 

if ($#ARGV < 2 || $#ARGV > 3 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
print <<HelpSection;

Tool: CMPLABEL
Description: Compares revisions associated with 2 pvcs build labels
             Differences in revisions are printed to stdout.

Usage: cmplabel <label 1> <label 2> <archive directory>
Example: cmplabel NEXT30 BASE30 q:\\vcs\\common\\database

Use the following example for redirection, NT has bug in file association shell
  perl p:\\cm\\cmplabel.pl NEXT30 BASE30 q:\\vcs\\common\\database \> cmplabel.out


Keywords: compare pvcs build label revisions

HelpSection
exit;
}

$lblOne = "@ARGV[0]";
$lblTwo = "@ARGV[1]";
$archiveRoot = "@ARGV[2]";
$tmpFile = "tmpfile.lst";

if (-e $tmpFile)
{
  print "cannot delete $tmpFile.  Please delete and retry.\n";
  exit;
}

`dir /s /b /on $archiveRoot\\*.*v>$tmpFile`; 
 
open(VLOG_OUT, "vlog -Q -B \@$tmpFile|");
while (<VLOG_OUT>)
{
  if (/\"$lblOne\"\s\=/) 
  {
    s/.*\=\s*(\S*)\s*$/\1/;
    $revOne = $_;
  }
  elsif (/\"$lblTwo\"\s\=/) 
  {
    s/.*\=\s*(\S*)\s*$/\1/;
    $revTwo = $_;
  }
  elsif (/Last trunk rev/) 
  {
    s/.*\:\s*(\S*)\s*$/\1/;
    $revLatest = $_;
  }
  #1st line of next archive in listing encountered, 
  #process previous archive's data
  elsif (/^Archive:/) 
  {
   
    #if a "*" is in the rev id, then the label is a floater, and floaters are
    #only on the trunk, so use the archive's latest rev when a "*" is in the
    #rev id
    if ($revOne =~ /\*/) {$revOne = $revLatest;}
    if ($revTwo =~ /\*/) {$revTwo = $revLatest;}
 
    if ($revOne ne $revTwo)
      {print "$archiveName - $lblOne=$revOne, $lblTwo=$revTwo\n";}
 
    #set the archive name, reset revs for this archive's processing
    s/^Archive:\s*(\S*)\s*$/\1/;
    $archiveName = $_;
    $revOne = "";
    $revTwo = "";
    $revLatest = "";
  }

}
close(VLOG_OUT);

`del $tmpFile`;

exit;
