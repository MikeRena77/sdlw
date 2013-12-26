#/* begin extraction */
#/*****************************************************************************
#* NAME:         $Workfile:   brnchtip.cmd  $
#*               $Revision:   1.0  $
#*               $Date:   05 Mar 1997 09:30:06  $
#*
#* DESCRIPTION:  Forces a branch on the tip
#*
#*               See run-time help for more detail
#*
#* MODIFICATION/REV HISTORY:
#* $Log:   P:\vcs\cm\brnchtip.plv  $
#*  
#*  
#*     Rev 1.0   Oct 09 1998 13:16:40   brettl
#*  Initial revision. (brought over from os/2)
#*
#*     Rev 1.2   05 Mar 1997 09:30:06   brettl
#*  Fixed grammatical error in output.
#*  
#*     Rev 1.1   05 Mar 1997 09:22:46   brettl
#*  Added code to print NEXT label information after branch for
#*  developer to inspect.
#*  
#*     Rev 1.0   04 Mar 1997 14:20:22   brettl
#*  Initial revision.
#*
#*****************************************************************************/
#/* end extraction */

if ($#ARGV < 1 || $#ARGV > 2 || $ARGV[0] eq '-h' || $ARGV[0] eq '-H')
{
print <<HelpSection;

Tool: BRNCHTIP

DESCRIPTION:  Forces a branch on the tip
              Sometimes required to ensure the tip is associated with
              the latest release.

              The build labels are adjusted to reflect the branch.
              
              Example: NEXT (base 8.0) and NEXT70 both point to the
              archive tip.  A change needs to go into Base 7.0 but must
              not go into Base 8.0.  If a branch is not forced in this
              case, the NEXT label (base 8.0) will float up and point
              to the Base 7.0 version.  Next time a change is made to
              this file for Base 8.0, the base 7.0 version will be
              retrieved erroneously.


Usage: brnchtip <next-label> <project|drive> <archive file>
Example: brnchtip NEXT NSTARTER common\\database\\fdd.in
Example: brnchtip NEXT s: common\\database\\fdd.in

OR

Usage: brnchtip <next-label> <full archive path>
Example: brnchtip NEXT s:\\vcs\\common\\database\\fdd.in
Example: brnchtip NEXT fdd.in
         (this last example assumes that your vcs.cfg points to the correct
         archive directory)

Keywords: branch tip pvcs

HelpSection
exit;
}


$nextLabel = "\U@ARGV[0]";
$_ = $nextLabel;
if (!/^NEXT\d*$/)
{
  print "NEXTnn arg missing\n";
  exit;
}

$project = "\U@ARGV[1]";
$_ = $project;

if ( /^[A-Z]\:$/ ) {$driveLetter = $_;}
elsif ( /NBASE/ )  { $driveLetter = 'Q:'; }
elsif (/^N[A-Z]*$/) { $driveLetter = 'S:'; }

#if project/drive is specified then create full archive name
if ($driveLetter)
{
  $fileName = "\U@ARGV[2]";
  $archiveName = "$driveLetter\\vcs\\$fileName";
}
#if the project/drive wasn't specified, use the 2nd arg as the archive name
else
{
  $archiveName = "\U@ARGV[1]";
}

#request a vlog report for NEXT, this returns data only if NEXTnn is not
#the tip
print "checking archive $archiveName...\n";
$vlogReport = `vlog -Q -BC$nextLabel $archiveName`;
$vlogStatus = $?;

if ($vlogStatus)
{
  print "Unable to retrieve vlog report for pvcs archive: $archiveName\n".
        "$nextLabel may not exist or $archiveName my not exist";
  exit;
}

#if anything is in the vlog output, then the requested label is not
#on the tip, so abort request
if ($vlogReport)
{
  print "Label: $nextLabel is not on $archiveName's tip.".
        "brnchtip is not needed\n";
  exit;
}

print "getting the tip...\n";
print "get -QN -L$nextLabel $archiveName\n";
$getOut = `get -QN -L$nextLabel $archiveName`;
$getStatus = $?;

if ($getStatus)
{
  print "problem getting/locking $archiveName.  BRNCHTIP aborting...\n";
  exit;
}

print "forcing branch...\n";
$putOut = `put -Q -FB -m"no changes made, branch forced on tip" -V$nextLabel $archiveName`;
$putStatus = $?;

if ($putStatus)
{
  print "Forcing the branch for archive $archiveName failed.\n".
        "IMPORTANT: file is still locked\n".
        "Please unlock, branch and cleanup the archive manuall.\n";
}


print "tip was branched successfully\n";
print "confirm following NEXT label revisions are correct\n";
print "if they are not correct, you must fix them manually\n";
print "archive: $archiveName\n";

open(VLOG_OUT, "vlog -Q -B $archiveName|");
while (<VLOG_OUT>)
{
  if (/NEXT|Last trunk rev/)
  {
    print;
  }
}
close(VLOG_OUT);
